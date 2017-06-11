#!/bin/bash

# Below we'll start the bloomd daemon, call it through bloomcmd and check the
# return codes. Finally, we kill the daemon.

daemon="./bloomd.out"
cmdline="../bloomcmd/bloomcmd.out"

if [[ ! -f $daemon ]]; then
	echo "Cant find $daemon executable, exiting..."
	exit 1
fi

if [[ ! -f $cmdline ]]; then
	echo "Cant find $cmdline executable, exiting..."
	exit 1
fi

running=$(ps -e | grep -q bloomd)
if [[ "$?" == "1" ]]; then
	echo "Starting daemon..."
	$daemon &
	sleep 2
	echo "PID=$(pgrep bloomd)"
else
	echo "Daemon already up with pid $(pgrep bloomd)"
fi

echo "0=no such word"
echo "1=en"
echo "2=ett"

call_daemon () {
	echo -n "asking $@... "
	$cmdline -w $@
}

call_daemon foo
call_daemon flaska
call_daemon bord
call_daemon bar
call_daemon baz
call_daemon hej

# empty string
call_daemon 

# naughty strings from github.com/minimaxir/big-list-of-naughty-strings
# call daemon directly, dont do bash function calling with these
$cmdline -w  undefined 
$cmdline -w  undef 
$cmdline -w  null 
$cmdline -w  NULL 
###$cmdline -w  (null) 
$cmdline -w  nil 
$cmdline -w  NIL 
$cmdline -w  true 
$cmdline -w  false 
$cmdline -w  True 
$cmdline -w  False 
$cmdline -w  TRUE 
$cmdline -w  FALSE 
$cmdline -w  None 
$cmdline -w  hasOwnProperty 
$cmdline -w  \\ 
$cmdline -w  \\\\ 
$cmdline -w  0 
$cmdline -w  1 
$cmdline -w  1.00 
$cmdline -w  $1.00 
$cmdline -w  1/2 
$cmdline -w  1E2 
$cmdline -w  1E02 
$cmdline -w  1E+02 
$cmdline -w  -1 
$cmdline -w  -1.00 
$cmdline -w  -$1.00 
$cmdline -w  -1/2 
$cmdline -w  -1E2 
$cmdline -w  -1E02 
$cmdline -w  -1E+02 
$cmdline -w  1/0 
$cmdline -w  0/0 
$cmdline -w  -2147483648/-1 
$cmdline -w  -9223372036854775808/-1 
$cmdline -w  -0 
$cmdline -w  -0.0 
$cmdline -w  +0 
$cmdline -w  +0.0 
$cmdline -w  0.00 
$cmdline -w  0..0 
$cmdline -w  . 
$cmdline -w  0.0.0 
$cmdline -w  0,00 
$cmdline -w  0,,0 
$cmdline -w  , 
$cmdline -w  0,0,0 
$cmdline -w  0.0/0 
$cmdline -w  1.0/0.0 
$cmdline -w  0.0/0.0 
$cmdline -w  1,0/0,0 
$cmdline -w  0,0/0,0 
$cmdline -w  --1 
$cmdline -w  - 
$cmdline -w  -. 
$cmdline -w  -, 
$cmdline -w  999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 
$cmdline -w  NaN 
$cmdline -w  Infinity 
$cmdline -w  -Infinity 
$cmdline -w  INF 
$cmdline -w  1#INF 
$cmdline -w  -1#IND 
$cmdline -w  1#QNAN 
$cmdline -w  1#SNAN 
$cmdline -w  1#IND 
$cmdline -w  0x0 
$cmdline -w  0xffffffff 
$cmdline -w  0xffffffffffffffff 
$cmdline -w  0xabad1dea 
$cmdline -w  123456789012345678901234567890123456789 
$cmdline -w  1,000.00 
$cmdline -w  1 000.00 
$cmdline -w  1'000.00 
$cmdline -w  1,000,000.00 
$cmdline -w  1 000 000.00 
$cmdline -w  1'000'000.00 
$cmdline -w  1.000,00 
$cmdline -w  1 000,00 
$cmdline -w  1'000,00 
$cmdline -w  1.000.000,00 
$cmdline -w  1 000 000,00 
$cmdline -w  1'000'000,00 
$cmdline -w  01000 
$cmdline -w  08 
$cmdline -w  09 
$cmdline -w  2.2250738585072011e-308 
$cmdline -w  ,./;'[]\\-= 
$cmdline -w  <>?:\"{}|_+ 
$cmdline -w  !@#$%^&*()`~ 
$cmdline -w  \u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f 
$cmdline -w   
$cmdline -w  \t\u000b\f              ​    　 
$cmdline -w  ­؀؁؂؃؄؅؜۝܏᠎​‌‍‎‏‪‫‬‭‮⁠⁡⁢⁣⁤⁦⁧⁨⁩⁪⁫⁬⁭⁮⁯﻿￹￺￻𑂽𛲠𛲡𛲢𛲣𝅳𝅴𝅵𝅶𝅷𝅸𝅹𝅺󠀁󠀠󠀡󠀢󠀣󠀤󠀥󠀦󠀧󠀨󠀩󠀪󠀫󠀬󠀭󠀮󠀯󠀰󠀱󠀲󠀳󠀴󠀵󠀶󠀷󠀸󠀹󠀺󠀻󠀼󠀽󠀾󠀿󠁀󠁁󠁂󠁃󠁄󠁅󠁆󠁇󠁈󠁉󠁊󠁋󠁌󠁍󠁎󠁏󠁐󠁑󠁒󠁓󠁔󠁕󠁖󠁗󠁘󠁙󠁚󠁛󠁜󠁝󠁞󠁟󠁠󠁡󠁢󠁣󠁤󠁥󠁦󠁧󠁨󠁩󠁪󠁫󠁬󠁭󠁮󠁯󠁰󠁱󠁲󠁳󠁴󠁵󠁶󠁷󠁸󠁹󠁺󠁻󠁼󠁽󠁾󠁿 
$cmdline -w  ﻿ 
$cmdline -w  ￾ 
$cmdline -w  Ω≈ç√∫˜µ≤≥÷ 
$cmdline -w  åß∂ƒ©˙∆˚¬…æ 
$cmdline -w  œ∑´®†¥¨ˆøπ“‘ 
$cmdline -w  ¡™£¢∞§¶•ªº–≠ 
$cmdline -w  ¸˛Ç◊ı˜Â¯˘¿ 
$cmdline -w  ÅÍÎÏ˝ÓÔÒÚÆ☃ 
$cmdline -w  Œ„´‰ˇÁ¨ˆØ∏”’ 
$cmdline -w  `⁄€‹›ﬁﬂ‡°·‚—± 
$cmdline -w  ⅛⅜⅝⅞ 
$cmdline -w  ЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя 
$cmdline -w  ٠١٢٣٤٥٦٧٨٩ 
$cmdline -w  ⁰⁴⁵ 
$cmdline -w  ₀₁₂ 
$cmdline -w  ⁰⁴⁵₀₁₂ 
$cmdline -w  ด้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็ ด้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็ ด้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็็้้้้้้้้็็็็็้้้้้็็็็ 
$cmdline -w  ' 
$cmdline -w  \" 
$cmdline -w  '' 
$cmdline -w  \"\" 
$cmdline -w  '\"' 
$cmdline -w  \"''''\"'\" 
$cmdline -w  \"'\"'\"''''\" 
$cmdline -w  <foo val=“bar” /> 
$cmdline -w  <foo val=“bar” /> 
$cmdline -w  <foo val=”bar“ /> 
$cmdline -w  <foo val=`bar' /> 
$cmdline -w  田中さんにあげて下さい 
$cmdline -w  パーティーへ行かないか 
$cmdline -w  和製漢語 
$cmdline -w  部落格 
$cmdline -w  사회과학원 어학연구소 
$cmdline -w  찦차를 타고 온 펲시맨과 쑛다리 똠방각하 
$cmdline -w  社會科學院語學研究所 
$cmdline -w  울란바토르 
$cmdline -w  𠜎𠜱𠝹𠱓𠱸𠲖𠳏 
$cmdline -w  Ⱥ 
$cmdline -w  Ⱦ 
$cmdline -w  ヽ༼ຈل͜ຈ༽ﾉ ヽ༼ຈل͜ຈ༽ﾉ  
$cmdline -w  (｡◕ ∀ ◕｡) 
$cmdline -w  ｀ｨ(´∀｀∩ 
$cmdline -w  __ﾛ(,_,*) 
$cmdline -w  ・(￣∀￣)・:*: 
$cmdline -w  ﾟ･✿ヾ╲(｡◕‿◕｡)╱✿･ﾟ 
$cmdline -w  ,。・:*:・゜’( ☻ ω ☻ )。・:*:・゜’ 
$cmdline -w  (╯°□°）╯︵ ┻━┻) 
$cmdline -w  (ﾉಥ益ಥ）ﾉ﻿ ┻━┻ 
$cmdline -w  ┬─┬ノ( º _ ºノ) 
$cmdline -w  ( ͡° ͜ʖ ͡°) 
$cmdline -w  😍 
$cmdline -w  👩🏽 
$cmdline -w  👾 🙇 💁 🙅 🙆 🙋 🙎 🙍 
$cmdline -w  🐵 🙈 🙉 🙊 
$cmdline -w  ❤️ 💔 💌 💕 💞 💓 💗 💖 💘 💝 💟 💜 💛 💚 💙 
$cmdline -w  ✋🏿 💪🏿 👐🏿 🙌🏿 👏🏿 🙏🏿 
$cmdline -w  🚾 🆒 🆓 🆕 🆖 🆗 🆙 🏧 
$cmdline -w  0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 
$cmdline -w  🇺🇸🇷🇺🇸 🇦🇫🇦🇲🇸 
$cmdline -w  🇺🇸🇷🇺🇸🇦🇫🇦🇲 
$cmdline -w  🇺🇸🇷🇺🇸🇦 
$cmdline -w  １２３ 
$cmdline -w  ١٢٣ 
$cmdline -w  ثم نفس سقطت وبالتحديد،, جزيرتي باستخدام أن دنو. إذ هنا؟ الستار وتنصيب كان. أهّل ايطاليا، بريطانيا-فرنسا قد أخذ. سليمان، إتفاقية بين ما, يذكر الحدود أي بعد, معاملة بولندا، الإطلاق عل إيو. 
$cmdline -w  בְּרֵאשִׁית, בָּרָא אֱלֹהִים, אֵת הַשָּׁמַיִם, וְאֵת הָאָרֶץ 
$cmdline -w  הָיְתָהtestالصفحات التّحول 
$cmdline -w  ﷽ 
$cmdline -w  ﷺ 
$cmdline -w  مُنَاقَشَةُ سُبُلِ اِسْتِخْدَامِ اللُّغَةِ فِي النُّظُمِ الْقَائِمَةِ وَفِيم يَخُصَّ التَّطْبِيقَاتُ الْحاسُوبِيَّةُ،  
$cmdline -w  ​ 
$cmdline -w    
$cmdline -w  ᠎ 
$cmdline -w  　 
$cmdline -w  ﻿ 
$cmdline -w  ␣ 
$cmdline -w  ␢ 
$cmdline -w  ␡ 
$cmdline -w  ‪‪test‪ 
$cmdline -w  ‫test‫ 
$cmdline -w   test  
$cmdline -w  test⁠test‫ 
$cmdline -w  ⁦test⁧ 
$cmdline -w  Ṱ̺̺̕o͞ ̷i̲̬͇̪͙n̝̗͕v̟̜̘̦͟o̶̙̰̠kè͚̮̺̪̹̱̤ ̖t̝͕̳̣̻̪͞h̼͓̲̦̳̘̲e͇̣̰̦̬͎ ̢̼̻̱̘h͚͎͙̜̣̲ͅi̦̲̣̰̤v̻͍e̺̭̳̪̰-m̢iͅn̖̺̞̲̯̰d̵̼̟͙̩̼̘̳ ̞̥̱̳̭r̛̗̘e͙p͠r̼̞̻̭̗e̺̠̣͟s̘͇̳͍̝͉e͉̥̯̞̲͚̬͜ǹ̬͎͎̟̖͇̤t͍̬̤͓̼̭͘ͅi̪̱n͠g̴͉ ͏͉ͅc̬̟h͡a̫̻̯͘o̫̟̖͍̙̝͉s̗̦̲.̨̹͈̣ 
$cmdline -w  ̡͓̞ͅI̗̘̦͝n͇͇͙v̮̫ok̲̫̙͈i̖͙̭̹̠̞n̡̻̮̣̺g̲͈͙̭͙̬͎ ̰t͔̦h̞̲e̢̤ ͍̬̲͖f̴̘͕̣è͖ẹ̥̩l͖͔͚i͓͚̦͠n͖͍̗͓̳̮g͍ ̨o͚̪͡f̘̣̬ ̖̘͖̟͙̮c҉͔̫͖͓͇͖ͅh̵̤̣͚͔á̗̼͕ͅo̼̣̥s̱͈̺̖̦̻͢.̛̖̞̠̫̰ 
$cmdline -w  ̗̺͖̹̯͓Ṯ̤͍̥͇͈h̲́e͏͓̼̗̙̼̣͔ ͇̜̱̠͓͍ͅN͕͠e̗̱z̘̝̜̺͙p̤̺̹͍̯͚e̠̻̠͜r̨̤͍̺̖͔̖̖d̠̟̭̬̝͟i̦͖̩͓͔̤a̠̗̬͉̙n͚͜ ̻̞̰͚ͅh̵͉i̳̞v̢͇ḙ͎͟-҉̭̩̼͔m̤̭̫i͕͇̝̦n̗͙ḍ̟ ̯̲͕͞ǫ̟̯̰̲͙̻̝f ̪̰̰̗̖̭̘͘c̦͍̲̞͍̩̙ḥ͚a̮͎̟̙͜ơ̩̹͎s̤.̝̝ ҉Z̡̖̜͖̰̣͉̜a͖̰͙̬͡l̲̫̳͍̩g̡̟̼̱͚̞̬ͅo̗͜.̟ 
$cmdline -w  ̦H̬̤̗̤͝e͜ ̜̥̝̻͍̟́w̕h̖̯͓o̝͙̖͎̱̮ ҉̺̙̞̟͈W̷̼̭a̺̪͍į͈͕̭͙̯̜t̶̼̮s̘͙͖̕ ̠̫̠B̻͍͙͉̳ͅe̵h̵̬͇̫͙i̹͓̳̳̮͎̫̕n͟d̴̪̜̖ ̰͉̩͇͙̲͞ͅT͖̼͓̪͢h͏͓̮̻e̬̝̟ͅ ̤̹̝W͙̞̝͔͇͝ͅa͏͓͔̹̼̣l̴͔̰̤̟͔ḽ̫.͕ 
$cmdline -w  Z̮̞̠͙͔ͅḀ̗̞͈̻̗Ḷ͙͎̯̹̞͓G̻O̭̗̮ 
$cmdline -w  ˙ɐnbᴉlɐ ɐuƃɐɯ ǝɹolop ʇǝ ǝɹoqɐl ʇn ʇunpᴉpᴉɔuᴉ ɹodɯǝʇ poɯsnᴉǝ op pǝs 'ʇᴉlǝ ƃuᴉɔsᴉdᴉpɐ ɹnʇǝʇɔǝsuoɔ 'ʇǝɯɐ ʇᴉs ɹolop ɯnsdᴉ ɯǝɹo˥ 
$cmdline -w  00˙Ɩ$- 
$cmdline -w  Ｔｈｅ ｑｕｉｃｋ ｂｒｏｗｎ ｆｏｘ ｊｕｍｐｓ ｏｖｅｒ ｔｈｅ ｌａｚｙ ｄｏｇ 
$cmdline -w  𝐓𝐡𝐞 𝐪𝐮𝐢𝐜𝐤 𝐛𝐫𝐨𝐰𝐧 𝐟𝐨𝐱 𝐣𝐮𝐦𝐩𝐬 𝐨𝐯𝐞𝐫 𝐭𝐡𝐞 𝐥𝐚𝐳𝐲 𝐝𝐨𝐠 
$cmdline -w  𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌 
$cmdline -w  𝑻𝒉𝒆 𝒒𝒖𝒊𝒄𝒌 𝒃𝒓𝒐𝒘𝒏 𝒇𝒐𝒙 𝒋𝒖𝒎𝒑𝒔 𝒐𝒗𝒆𝒓 𝒕𝒉𝒆 𝒍𝒂𝒛𝒚 𝒅𝒐𝒈 
$cmdline -w  𝓣𝓱𝓮 𝓺𝓾𝓲𝓬𝓴 𝓫𝓻𝓸𝔀𝓷 𝓯𝓸𝔁 𝓳𝓾𝓶𝓹𝓼 𝓸𝓿𝓮𝓻 𝓽𝓱𝓮 𝓵𝓪𝔃𝔂 𝓭𝓸𝓰 
$cmdline -w  𝕋𝕙𝕖 𝕢𝕦𝕚𝕔𝕜 𝕓𝕣𝕠𝕨𝕟 𝕗𝕠𝕩 𝕛𝕦𝕞𝕡𝕤 𝕠𝕧𝕖𝕣 𝕥𝕙𝕖 𝕝𝕒𝕫𝕪 𝕕𝕠𝕘 
$cmdline -w  𝚃𝚑𝚎 𝚚𝚞𝚒𝚌𝚔 𝚋𝚛𝚘𝚠𝚗 𝚏𝚘𝚡 𝚓𝚞𝚖𝚙𝚜 𝚘𝚟𝚎𝚛 𝚝𝚑𝚎 𝚕𝚊𝚣𝚢 𝚍𝚘𝚐 
$cmdline -w  ⒯⒣⒠ ⒬⒰⒤⒞⒦ ⒝⒭⒪⒲⒩ ⒡⒪⒳ ⒥⒰⒨⒫⒮ ⒪⒱⒠⒭ ⒯⒣⒠ ⒧⒜⒵⒴ ⒟⒪⒢ 
$cmdline -w  <script>alert(123)</script> 
$cmdline -w  &lt;script&gt;alert(&#39;123&#39;);&lt;/script&gt; 
$cmdline -w  <img src=x onerror=alert(123) /> 
$cmdline -w  <svg><script>123<1>alert(123)</script> 
$cmdline -w  \"><script>alert(123)</script> 
$cmdline -w  '><script>alert(123)</script> 
$cmdline -w  ><script>alert(123)</script> 
$cmdline -w  </script><script>alert(123)</script> 
$cmdline -w  < / script >< script >alert(123)< / script > 
$cmdline -w   onfocus=JaVaSCript:alert(123) autofocus 
$cmdline -w  \" onfocus=JaVaSCript:alert(123) autofocus 
$cmdline -w  ' onfocus=JaVaSCript:alert(123) autofocus 
$cmdline -w  ＜script＞alert(123)＜/script＞ 
$cmdline -w  <sc<script>ript>alert(123)</sc</script>ript> 
$cmdline -w  --><script>alert(123)</script> 
$cmdline -w  \";alert(123);t=\" 
$cmdline -w  ';alert(123);t=' 
$cmdline -w  JavaSCript:alert(123) 
$cmdline -w  ;alert(123); 
$cmdline -w  src=JaVaSCript:prompt(132) 
$cmdline -w  \"><script>alert(123);</script x=\" 
$cmdline -w  '><script>alert(123);</script x=' 
$cmdline -w  ><script>alert(123);</script x= 
$cmdline -w  \" autofocus onkeyup=\"javascript:alert(123) 
$cmdline -w  ' autofocus onkeyup='javascript:alert(123) 
$cmdline -w  <script\\x20type=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  <script\\x3Etype=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  <script\\x0Dtype=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  <script\\x09type=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  <script\\x0Ctype=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  <script\\x2Ftype=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  <script\\x0Atype=\"text/javascript\">javascript:alert(1);</script> 
$cmdline -w  '`\"><\\x3Cscript>javascript:alert(1)</script> 
$cmdline -w  '`\"><\\x00script>javascript:alert(1)</script> 
$cmdline -w  ABC<div style=\"x\\x3Aexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:expression\\x5C(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:expression\\x00(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:exp\\x00ression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:exp\\x5Cression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x0Aexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x09expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE3\\x80\\x80expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x84expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xC2\\xA0expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x80expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x8Aexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x0Dexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x0Cexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x87expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xEF\\xBB\\xBFexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x20expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x88expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x00expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x8Bexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x86expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x85expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x82expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\x0Bexpression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x81expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x83expression(javascript:alert(1)\">DEF 
$cmdline -w  ABC<div style=\"x:\\xE2\\x80\\x89expression(javascript:alert(1)\">DEF 
$cmdline -w  <a href=\"\\x0Bjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x0Fjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xC2\\xA0javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x05javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE1\\xA0\\x8Ejavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x18javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x11javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x88javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x89javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x80javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x17javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x03javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x0Ejavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x1Ajavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x00javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x10javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x82javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x20javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x13javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x09javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x8Ajavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x14javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x19javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\xAFjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x1Fjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x81javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x1Djavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x87javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x07javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE1\\x9A\\x80javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x83javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x04javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x01javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x08javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x84javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x86javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE3\\x80\\x80javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x12javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x0Djavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x0Ajavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x0Cjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x15javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\xA8javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x16javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x02javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x1Bjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x06javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\xA9javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x80\\x85javascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x1Ejavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\xE2\\x81\\x9Fjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"\\x1Cjavascript:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"javascript\\x00:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"javascript\\x3A:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"javascript\\x09:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"javascript\\x0D:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  <a href=\"javascript\\x0A:javascript:alert(1)\" id=\"fuzzelement1\">test</a> 
$cmdline -w  `\"'><img src=xxx:x \\x0Aonerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x22onerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x0Bonerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x0Donerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x2Fonerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x09onerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x0Conerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x00onerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x27onerror=javascript:alert(1)> 
$cmdline -w  `\"'><img src=xxx:x \\x20onerror=javascript:alert(1)> 
$cmdline -w  \"`'><script>\\x3Bjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x0Djavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xEF\\xBB\\xBFjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x81javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x84javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE3\\x80\\x80javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x09javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x89javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x85javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x88javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x00javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\xA8javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x8Ajavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE1\\x9A\\x80javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x0Cjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x2Bjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xF0\\x90\\x96\\x9Ajavascript:alert(1)</script> 
$cmdline -w  \"`'><script>-javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x0Ajavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\xAFjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x7Ejavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x87javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x81\\x9Fjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\xA9javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xC2\\x85javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xEF\\xBF\\xAEjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x83javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x8Bjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xEF\\xBF\\xBEjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x80javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x21javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x82javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE2\\x80\\x86javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xE1\\xA0\\x8Ejavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x0Bjavascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\x20javascript:alert(1)</script> 
$cmdline -w  \"`'><script>\\xC2\\xA0javascript:alert(1)</script> 
$cmdline -w  <img \\x00src=x onerror=\"alert(1)\"> 
$cmdline -w  <img \\x47src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img \\x11src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img \\x12src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img\\x47src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img\\x10src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img\\x13src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img\\x32src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img\\x47src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img\\x11src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img \\x47src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img \\x34src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img \\x39src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img \\x00src=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x09=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x10=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x13=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x32=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x12=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x11=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x00=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src\\x47=x onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src=x\\x09onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src=x\\x10onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src=x\\x11onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src=x\\x12onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img src=x\\x13onerror=\"javascript:alert(1)\"> 
$cmdline -w  <img[a][b][c]src[d]=x[e]onerror=[f]\"alert(1)\"> 
$cmdline -w  <img src=x onerror=\\x09\"javascript:alert(1)\"> 
$cmdline -w  <img src=x onerror=\\x10\"javascript:alert(1)\"> 
$cmdline -w  <img src=x onerror=\\x11\"javascript:alert(1)\"> 
$cmdline -w  <img src=x onerror=\\x12\"javascript:alert(1)\"> 
$cmdline -w  <img src=x onerror=\\x32\"javascript:alert(1)\"> 
$cmdline -w  <img src=x onerror=\\x00\"javascript:alert(1)\"> 
$cmdline -w  <a href=java&#1&#2&#3&#4&#5&#6&#7&#8&#11&#12script:javascript:alert(1)>XXX</a> 
$cmdline -w  <img src=\"x` `<script>javascript:alert(1)</script>\"` `> 
$cmdline -w  <img src onerror /\" '\"= alt=javascript:alert(1)//\"> 
$cmdline -w  <title onpropertychange=javascript:alert(1)></title><title title=> 
$cmdline -w  <a href=http://foo.bar/#x=`y></a><img alt=\"`><img src=x:x onerror=javascript:alert(1)></a>\"> 
$cmdline -w  <!--[if]><script>javascript:alert(1)</script --> 
$cmdline -w  <!--[if<img src=x onerror=javascript:alert(1)//]> --> 
$cmdline -w  <script src=\"/\\%(jscript)s\"></script> 
$cmdline -w  <script src=\"\\\\%(jscript)s\"></script> 
$cmdline -w  <IMG \"\"\"><SCRIPT>alert(\"XSS\")</SCRIPT>\"> 
$cmdline -w  <IMG SRC=javascript:alert(String.fromCharCode(88,83,83))> 
$cmdline -w  <IMG SRC=# onmouseover=\"alert('xxs')\"> 
$cmdline -w  <IMG SRC= onmouseover=\"alert('xxs')\"> 
$cmdline -w  <IMG onmouseover=\"alert('xxs')\"> 
$cmdline -w  <IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;> 
$cmdline -w  <IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041> 
$cmdline -w  <IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29> 
$cmdline -w  <IMG SRC=\"jav   ascript:alert('XSS');\"> 
$cmdline -w  <IMG SRC=\"jav&#x09;ascript:alert('XSS');\"> 
$cmdline -w  <IMG SRC=\"jav&#x0A;ascript:alert('XSS');\"> 
$cmdline -w  <IMG SRC=\"jav&#x0D;ascript:alert('XSS');\"> 
$cmdline -w  perl -e 'print \"<IMG SRC=java\\0script:alert(\\\"XSS\\\")>\";' > out 
$cmdline -w  <IMG SRC=\" &#14;  javascript:alert('XSS');\"> 
$cmdline -w  <SCRIPT/XSS SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT> 
$cmdline -w  <BODY onload!#$%&()*~+-_.,:;?@[/|\\]^`=alert(\"XSS\")> 
$cmdline -w  <SCRIPT/SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT> 
$cmdline -w  <<SCRIPT>alert(\"XSS\");//<</SCRIPT> 
$cmdline -w  <SCRIPT SRC=http://ha.ckers.org/xss.js?< B > 
$cmdline -w  <SCRIPT SRC=//ha.ckers.org/.j> 
$cmdline -w  <IMG SRC=\"javascript:alert('XSS')\" 
$cmdline -w  <iframe src=http://ha.ckers.org/scriptlet.html < 
$cmdline -w  \\\";alert('XSS');// 
$cmdline -w  <u oncopy=alert()> Copy me</u> 
$cmdline -w  <i onwheel=alert(1)> Scroll over me </i> 
$cmdline -w  <plaintext> 
$cmdline -w  http://a/%%30%30 
$cmdline -w  </textarea><script>alert(123)</script> 
$cmdline -w  1;DROP TABLE users 
$cmdline -w  1'; DROP TABLE users-- 1 
$cmdline -w  ' OR 1=1 -- 1 
$cmdline -w  ' OR '1'='1 
$cmdline -w    
$cmdline -w  % 
$cmdline -w  _ 
$cmdline -w  - 
$cmdline -w  -- 
$cmdline -w  --version 
$cmdline -w  --help 
$cmdline -w  $USER 
$cmdline -w  /dev/null; touch /tmp/blns.fail ; echo 
$cmdline -w  `touch /tmp/blns.fail` 
$cmdline -w  $(touch /tmp/blns.fail) 
$cmdline -w  @{[system \"touch /tmp/blns.fail\"]} 
$cmdline -w  eval(\"puts 'hello world'\") 
$cmdline -w  System(\"ls -al /\") 
$cmdline -w  `ls -al /` 
$cmdline -w  Kernel.exec(\"ls -al /\") 
$cmdline -w  Kernel.exit(1) 
$cmdline -w  %x('ls -al /') 
$cmdline -w  <?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><!DOCTYPE foo [ <!ELEMENT foo ANY ><!ENTITY xxe SYSTEM \"file:///etc/passwd\" >]><foo>&xxe;</foo> 
$cmdline -w  $HOME 
$cmdline -w  $ENV{'HOME'} 
$cmdline -w  %d 
$cmdline -w  %s 
$cmdline -w  {0} 
$cmdline -w  %*.*s 
$cmdline -w  File:///
$cmdline -w  ../../../../../../../../../../../etc/passwd%00 
$cmdline -w  ../../../../../../../../../../../etc/hosts 
$cmdline -w  () { 0; }; touch /tmp/blns.shellshock1.fail; 
$cmdline -w  () { _; } >_[$($())] { touch /tmp/blns.shellshock2.fail; } 
$cmdline -w  <<< %s(un='%s') = %u 
$cmdline -w  +++ATH0 
$cmdline -w  CON 
$cmdline -w  PRN 
$cmdline -w  AUX 
$cmdline -w  CLOCK$ 
$cmdline -w  NUL 
$cmdline -w  A: 
$cmdline -w  ZZ: 
$cmdline -w  COM1 
$cmdline -w  LPT1 
$cmdline -w  LPT2 
$cmdline -w  LPT3 
$cmdline -w  COM2 
$cmdline -w  COM3 
$cmdline -w  COM4 
$cmdline -w  DCC SEND STARTKEYLOGGER 0 0 0 
$cmdline -w  Scunthorpe General Hospital 
$cmdline -w  Penistone Community Church 
$cmdline -w  Lightwater Country Park 
$cmdline -w  Jimmy Clitheroe 
$cmdline -w  Horniman Museum 
$cmdline -w  shitake mushrooms 
$cmdline -w  RomansInSussex.co.uk 
$cmdline -w  http://www.cum.qc.ca/ 
$cmdline -w  Craig Cockburn, Software Specialist 
$cmdline -w  Linda Callahan 
$cmdline -w  Dr. Herman I. Libshitz 
$cmdline -w  magna cum laude 
$cmdline -w  Super Bowl XXX 
$cmdline -w  medieval erection of parapets 
$cmdline -w  evaluate 
$cmdline -w  mocha 
$cmdline -w  expression 
$cmdline -w  Arsenal canal 
$cmdline -w  classic 
$cmdline -w  Tyson Gay 
$cmdline -w  Dick Van Dyke 
$cmdline -w  basement 
$cmdline -w  If you're reading this, you've been in a coma for almost 20 years now. We're trying a new technique. We don't know where this message will end up in your dream, but we hope it works. Please wake up, we miss you. 
$cmdline -w  Roses are \u001b[0;31mred\u001b[0m, violets are \u001b[0;34mblue. Hope you enjoy terminal hue 
$cmdline -w  But now...\u001b[20Cfor my greatest trick...\u001b[8m 
$cmdline -w  The quic\b\b\b\b\b\bk brown fo\u0007\u0007\u0007\u0007\u0007\u0007\u0007\u0007\u0007\u0007\u0007x... [Beeeep] 
$cmdline -w  Powerلُلُصّبُلُلصّبُررً ॣ ॣh ॣ ॣ冗"

echo "Killing daemon..."
kill -9 $(pgrep bloomd)