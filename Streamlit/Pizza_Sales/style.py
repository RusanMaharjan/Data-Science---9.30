def title_style(title, icon = '🍕'):
    return f"""
        <div style='
            font-size: 3em;
            font-family: TimesNewRoman;
            font-weight: bold;
            text-align: center;
        '>
           <marquee>{title}{icon}</marquee>
        </div>
    """
