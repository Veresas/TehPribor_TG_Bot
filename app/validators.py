import re;

def valid_fio(name: str) -> bool:
    pattern = r'^[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+(?:\s[А-ЯЁ][а-яё]+)?$'
    return bool(re.match(pattern, name))

def valid_age(age: str) -> bool:
    pattern = r"^(1[89]|[2-9]\d)$"
    return bool(re.match(pattern, age))