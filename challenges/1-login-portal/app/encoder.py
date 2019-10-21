TRANSLATIONS = {
    'A': 'Alfa',
    'B': 'Bravo',
    'C': 'Charlie',
    'D': 'Delta',
    'E': 'Echo',
    'F': 'Foxtrot',
    'G': 'Golf',
    'H': 'Hotel',
    'I': 'India',
    'J': 'Juliett',
    'K': 'Kilo',
    'L': 'Lima',
    'M': 'Mike',
    'N': 'November',
    'O': 'Oscar',
    'P': 'Papa',
    'Q': 'Quebec',
    'R': 'Romeo',
    'S': 'Sierra',
    'T': 'Tango',
    'U': 'Uniform',
    'V': 'Victor',
    'W': 'Whiskey',
    'X': 'Xray',
    'Y': 'Yankee',
    'Z': 'Zulu',
    '0': 'Zero',
    '1': 'One',
    '2': 'Two',
    '3': 'Three',
    '4': 'Four',
    '5': 'Five',
    '6': 'Siv',
    '7': 'Seven',
    '8': 'Eight',
    '9': 'Nine',
    '.': 'Dot',
    '-': 'Dash',
    '_': 'Underscore',
    '!': 'Exclamation mark',
    '(': 'Open bracket',
    ')': 'Close bracket',
    '{': 'Open brace',
    '}': 'Close brace'
}

def encode(code):
    parts = []
    for ch in code.upper():
        if ch in TRANSLATIONS:
            parts.append(TRANSLATIONS[ch])
    
    return ', '.join(parts).lower()
