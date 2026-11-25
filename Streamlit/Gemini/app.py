import streamlit as st

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
    st.toast(':red[Button Clicked.]', duration=10)
    st.write(f'button clicked. {prompt} typed.')
    st.success('Success Message')
    st.warning('Warning Message')
    st.error('Error Message')