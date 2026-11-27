import streamlit as st
import pandas as pd
import plotly.express as px
from style import title_style

# Cache -> st.cache
@st.cache_data
def read_data(path:str) -> pd.DataFrame:
    df = pd.read_csv(path)
    return df

@st.cache_data
def clean_data(df:pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["order_date"] = pd.to_datetime(df["order_date"], format="mixed")
    df["order_time"] = pd.to_datetime(df["order_time"], format="mixed").dt.time

    # Feature engineering
    df["Order_Day"]    = df["order_date"].dt.day_name()
    df["Order_Month"]  = df["order_date"].dt.month_name()
    df["month_num"]    = df["order_date"].dt.month
    df["Order_Hour"]   = pd.to_datetime(df["order_time"], format="%H:%M:%S").dt.hour

    # Categorical ordering so plots sort correctly
    weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday",
                "Thursday", "Friday", "Saturday"]
    df["Order_Day"] = pd.Categorical(df["Order_Day"], categories=weekdays, ordered=True)

    months = ["January", "February", "March", "April", "May", "June",
              "July", "August", "September", "October", "November", "December"]
    df["Order_Month"] = pd.Categorical(df["Order_Month"], categories=months, ordered=True)

    return df

df_raw = read_data('pizza_sales.csv')
df = clean_data(df_raw)

# Webpage Metadata
st.set_page_config(
    page_title='Pizza Sales Dashboard',
    page_icon='🍕',
    layout='wide'
)


# Sidebar
st.sidebar.header(
    'Filter Data'
)

# Filter data using Pizza Size
sizes = df['pizza_size'].unique()
filter_sizes = st.sidebar.multiselect(
    'Pizza Size',
    options=sizes,
    default=sizes
)

# Filter data using Pizza Category
categories = df['pizza_category'].unique()
filter_categories = st.sidebar.multiselect(
    'Pizza Category',
    options=categories,
    default=categories
)

filter_data = df[
    (df['pizza_category'].isin(filter_categories)) &
    (df["pizza_size"].isin(filter_sizes))
]

if filter_data.empty:
    st.toast(':red[Filter Data Field Cannot be Empty.]')
    st.stop()
    
# Title
# st.title('Pizza Sales Dashboard :pizza:')

# markdown with css
st.markdown(title_style(title='Pizza Sales Dashboard'), 
            unsafe_allow_html=True)

# Tabs
overivew, time, top_bottom, raw_data = st.tabs([
    'Overview', 'Time Analysis', 'Top/Bottom Analysis', 'Raw Data'
])

# % of sales by category
cat_pct = filter_data.groupby('pizza_category')['total_price'].sum().reset_index()

fig = px.pie(
    cat_pct,
    names='pizza_category',
    values='total_price',
    hole=0.6
)
st.plotly_chart(fig)