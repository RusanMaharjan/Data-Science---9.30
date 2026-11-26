import streamlit as st
from models import gemini

st.set_page_config(
    page_title='Gemini API Project',
    page_icon=':robot:',
    layout='wide'
)

st.title('Streamlit :blue[Pro]:red[ject] :grin:', icon='🦁')

st.header('Gemini Project :green[:robot:]')

st.subheader('Using Gemini-3.6-flash Model')


# st.text_input('Prompt')

prompt = st.text_area('Enter your Prompt', 
                      placeholder='Explain about animal.')

button_clicked = st.button('Send Prompt :airplane:')

if button_clicked:
    if prompt.strip() == '':
        st.warning('Prompt field cannot be empty.')
    else:
        with st.spinner('Generating Content...'):
            answer = gemini(prompt)
            st.success('Content Generated.')
            st.write(answer)
