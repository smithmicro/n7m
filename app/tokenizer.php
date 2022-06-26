<?php
@define('CONST_Max_Word_Frequency', 10000000);
@define('CONST_Term_Normalization_Rules', ":: lower ();[^[:Letter:] [:Number:] [:Space:]] >;[:Lm:] >;:: [[:Number:]] Latin ();:: [[:Number:]] Ascii ();;:: [[:Number:]] NFD ();;[[:Nonspacing Mark:] [:Cf:]] >;;[:Space:]+ > ' ';");
@define('CONST_Transliteration', ":: lower ();[^[:Letter:] [:Number:] [:Space:]] >;[:Lm:] >;:: [[:Number:]] Latin ();:: [[:Number:]] Ascii ();;:: [[:Number:]] NFD ();;[[:Nonspacing Mark:] [:Cf:]] >;;[:Space:]+ > ' ';:: Latin ();:: Ascii ();:: NFD ();:: lower ();[^a-z0-9[:Space:]] >;:: NFC ();");
require_once('/usr/local/lib/nominatim/lib-php/tokenizer/icu_tokenizer.php');
