import re;

def valid_fio(name: str) -> bool:
    pattern = r'^[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+(?:\s[А-ЯЁ][а-яё]+)?$'
    return bool(re.match(pattern, name))