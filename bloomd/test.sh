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
call_daemon  undefined 
call_daemon  undef 
call_daemon  null 
call_daemon  NULL 
###call_daemon  (null) 
call_daemon  nil 
call_daemon  NIL 
call_daemon  true 
call_daemon  false 
call_daemon  True 
call_daemon  False 
call_daemon  TRUE 
call_daemon  FALSE 
call_daemon  None 
call_daemon  hasOwnProperty 
call_daemon  \\ 
call_daemon  \\\\ 
call_daemon  0 
call_daemon  1 
call_daemon  1.00 
call_daemon  $1.00 
call_daemon  1/2 
call_daemon  1E2 
call_daemon  1E02 
call_daemon  1E+02 
call_daemon  -1 
call_daemon  -1.00 
call_daemon  -$1.00 
call_daemon  -1/2 
call_daemon  -1E2 
call_daemon  -1E02 
call_daemon  -1E+02 
call_daemon  1/0 
call_daemon  0/0 
call_daemon  -2147483648/-1 
call_daemon  -9223372036854775808/-1 
call_daemon  -0 
call_daemon  -0.0 
call_daemon  +0 
call_daemon  +0.0 
call_daemon  0.00 
call_daemon  0..0 
call_daemon  . 
call_daemon  0.0.0 
call_daemon  0,00 
call_daemon  0,,0 
call_daemon  , 
call_daemon  0,0,0 
call_daemon  0.0/0 
call_daemon  1.0/0.0 
call_daemon  0.0/0.0 
call_daemon  1,0/0,0 
call_daemon  0,0/0,0 
call_daemon  --1 
call_daemon  - 
call_daemon  -. 
call_daemon  -, 
call_daemon  999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 
call_daemon  NaN 
call_daemon  Infinity 
call_daemon  -Infinity 
call_daemon  INF 
call_daemon  1#INF 
call_daemon  -1#IND 
call_daemon  1#QNAN 
call_daemon  1#SNAN 
call_daemon  1#IND 
call_daemon  0x0 
call_daemon  0xffffffff 
call_daemon  0xffffffffffffffff 
call_daemon  0xabad1dea 
call_daemon  123456789012345678901234567890123456789 
call_daemon  1,000.00 
call_daemon  1 000.00 
call_daemon  1'000.00 
call_daemon  1,000,000.00 
call_daemon  1 000 000.00 
call_daemon  1'000'000.00 
call_daemon  1.000,00 
call_daemon  1 000,00 
call_daemon  1'000,00 
call_daemon  1.000.000,00 
call_daemon  1 000 000,00 
call_daemon  1'000'000,00 
call_daemon  01000 
call_daemon  08 
call_daemon  09 
call_daemon  2.2250738585072011e-308 
call_daemon  和製漢語 
call_daemon  部落格 
call_daemon  사회과학원 어학연구소 
call_daemon  찦차를 타고 온 펲시맨과 쑛다리 똠방각하 
call_daemon  社會科學院語學研究所 
call_daemon  울란바토르 
call_daemon  𠜎𠜱𠝹𠱓𠱸𠲖𠳏 
call_daemon  👾 🙇 💁 🙅 🙆 🙋 🙎 🙍 
call_daemon  🐵 🙈 🙉 🙊 
call_daemon  ❤️ 💔 💌 💕 💞 💓 💗 💖 💘 💝 💟 💜 💛 💚 💙 
call_daemon  ✋🏿 💪🏿 👐🏿 🙌🏿 👏🏿 🙏🏿 
call_daemon  🚾 🆒 🆓 🆕 🆖 🆗 🆙 🏧 
call_daemon  0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 
call_daemon  🇺🇸🇷🇺🇸 🇦🇫🇦🇲🇸 
call_daemon  🇺🇸🇷🇺🇸🇦🇫🇦🇲 
call_daemon  🇺🇸🇷🇺🇸🇦 
call_daemon  １２３ 
call_daemon  ١٢٣ 
call_daemon  ثم نفس سقطت وبالتحديد،, جزيرتي باستخدام أن دنو. إذ هنا؟ الستار وتنصيب كان. أهّل ايطاليا، بريطانيا-فرنسا قد أخذ. سليمان، إتفاقية بين ما, يذكر الحدود أي بعد, معاملة بولندا، الإطلاق عل إيو. 
call_daemon  בְּרֵאשִׁית, בָּרָא אֱלֹהִים, אֵת הַשָּׁמַיִם, וְאֵת הָאָרֶץ 
call_daemon  הָיְתָהtestالصفحات التّحول 
call_daemon  ﷽ 
call_daemon  ﷺ 
call_daemon  مُنَاقَشَةُ سُبُلِ اِسْتِخْدَامِ اللُّغَةِ فِي النُّظُمِ الْقَائِمَةِ وَفِيم يَخُصَّ التَّطْبِيقَاتُ الْحاسُوبِيَّةُ،  
call_daemon    
call_daemon  ␣ 
call_daemon  ␢ 
call_daemon  ␡ 
call_daemon  ‪‪test‪ 
call_daemon  ‫test‫ 
call_daemon   test  
call_daemon  test⁠test‫ 
call_daemon  ⁦test⁧ 
call_daemon  Ṱ̺̺̕o͞ ̷i̲̬͇̪͙n̝̗͕v̟̜̘̦͟o̶̙̰̠kè͚̮̺̪̹̱̤ ̖t̝͕̳̣̻̪͞h̼͓̲̦̳̘̲e͇̣̰̦̬͎ ̢̼̻̱̘h͚͎͙̜̣̲ͅi̦̲̣̰̤v̻͍e̺̭̳̪̰-m̢iͅn̖̺̞̲̯̰d̵̼̟͙̩̼̘̳ ̞̥̱̳̭r̛̗̘e͙p͠r̼̞̻̭̗e̺̠̣͟s̘͇̳͍̝͉e͉̥̯̞̲͚̬͜ǹ̬͎͎̟̖͇̤t͍̬̤͓̼̭͘ͅi̪̱n͠g̴͉ ͏͉ͅc̬̟h͡a̫̻̯͘o̫̟̖͍̙̝͉s̗̦̲.̨̹͈̣ 
call_daemon  ̡͓̞ͅI̗̘̦͝n͇͇͙v̮̫ok̲̫̙͈i̖͙̭̹̠̞n̡̻̮̣̺g̲͈͙̭͙̬͎ ̰t͔̦h̞̲e̢̤ ͍̬̲͖f̴̘͕̣è͖ẹ̥̩l͖͔͚i͓͚̦͠n͖͍̗͓̳̮g͍ ̨o͚̪͡f̘̣̬ ̖̘͖̟͙̮c҉͔̫͖͓͇͖ͅh̵̤̣͚͔á̗̼͕ͅo̼̣̥s̱͈̺̖̦̻͢.̛̖̞̠̫̰ 
call_daemon  ̗̺͖̹̯͓Ṯ̤͍̥͇͈h̲́e͏͓̼̗̙̼̣͔ ͇̜̱̠͓͍ͅN͕͠e̗̱z̘̝̜̺͙p̤̺̹͍̯͚e̠̻̠͜r̨̤͍̺̖͔̖̖d̠̟̭̬̝͟i̦͖̩͓͔̤a̠̗̬͉̙n͚͜ ̻̞̰͚ͅh̵͉i̳̞v̢͇ḙ͎͟-҉̭̩̼͔m̤̭̫i͕͇̝̦n̗͙ḍ̟ ̯̲͕͞ǫ̟̯̰̲͙̻̝f ̪̰̰̗̖̭̘͘c̦͍̲̞͍̩̙ḥ͚a̮͎̟̙͜ơ̩̹͎s̤.̝̝ ҉Z̡̖̜͖̰̣͉̜a͖̰͙̬͡l̲̫̳͍̩g̡̟̼̱͚̞̬ͅo̗͜.̟ 
call_daemon  ̦H̬̤̗̤͝e͜ ̜̥̝̻͍̟́w̕h̖̯͓o̝͙̖͎̱̮ ҉̺̙̞̟͈W̷̼̭a̺̪͍į͈͕̭͙̯̜t̶̼̮s̘͙͖̕ ̠̫̠B̻͍͙͉̳ͅe̵h̵̬͇̫͙i̹͓̳̳̮͎̫̕n͟d̴̪̜̖ ̰͉̩͇͙̲͞ͅT͖̼͓̪͢h͏͓̮̻e̬̝̟ͅ ̤̹̝W͙̞̝͔͇͝ͅa͏͓͔̹̼̣l̴͔̰̤̟͔ḽ̫.͕ 
call_daemon  Z̮̞̠͙͔ͅḀ̗̞͈̻̗Ḷ͙͎̯̹̞͓G̻O̭̗̮ 
call_daemon  ˙ɐnbᴉlɐ ɐuƃɐɯ ǝɹolop ʇǝ ǝɹoqɐl ʇn ʇunpᴉpᴉɔuᴉ ɹodɯǝʇ poɯsnᴉǝ op pǝs 'ʇᴉlǝ ƃuᴉɔsᴉdᴉpɐ ɹnʇǝʇɔǝsuoɔ 'ʇǝɯɐ ʇᴉs ɹolop ɯnsdᴉ ɯǝɹo˥ 
call_daemon  00˙Ɩ$- 
call_daemon  Ｔｈｅ ｑｕｉｃｋ ｂｒｏｗｎ ｆｏｘ ｊｕｍｐｓ ｏｖｅｒ ｔｈｅ ｌａｚｙ ｄｏｇ 
call_daemon  𝐓𝐡𝐞 𝐪𝐮𝐢𝐜𝐤 𝐛𝐫𝐨𝐰𝐧 𝐟𝐨𝐱 𝐣𝐮𝐦𝐩𝐬 𝐨𝐯𝐞𝐫 𝐭𝐡𝐞 𝐥𝐚𝐳𝐲 𝐝𝐨𝐠 
call_daemon  𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌 
call_daemon  𝑻𝒉𝒆 𝒒𝒖𝒊𝒄𝒌 𝒃𝒓𝒐𝒘𝒏 𝒇𝒐𝒙 𝒋𝒖𝒎𝒑𝒔 𝒐𝒗𝒆𝒓 𝒕𝒉𝒆 𝒍𝒂𝒛𝒚 𝒅𝒐𝒈 
call_daemon  𝓣𝓱𝓮 𝓺𝓾𝓲𝓬𝓴 𝓫𝓻𝓸𝔀𝓷 𝓯𝓸𝔁 𝓳𝓾𝓶𝓹𝓼 𝓸𝓿𝓮𝓻 𝓽𝓱𝓮 𝓵𝓪𝔃𝔂 𝓭𝓸𝓰 
call_daemon  𝕋𝕙𝕖 𝕢𝕦𝕚𝕔𝕜 𝕓𝕣𝕠𝕨𝕟 𝕗𝕠𝕩 𝕛𝕦𝕞𝕡𝕤 𝕠𝕧𝕖𝕣 𝕥𝕙𝕖 𝕝𝕒𝕫𝕪 𝕕𝕠𝕘 
call_daemon  𝚃𝚑𝚎 𝚚𝚞𝚒𝚌𝚔 𝚋𝚛𝚘𝚠𝚗 𝚏𝚘𝚡 𝚓𝚞𝚖𝚙𝚜 𝚘𝚟𝚎𝚛 𝚝𝚑𝚎 𝚕𝚊𝚣𝚢 𝚍𝚘𝚐 
call_daemon  ⒯⒣⒠ ⒬⒰⒤⒞⒦ ⒝⒭⒪⒲⒩ ⒡⒪⒳ ⒥⒰⒨⒫⒮ ⒪⒱⒠⒭ ⒯⒣⒠ ⒧⒜⒵⒴ ⒟⒪⒢ 
call_daemon  % 
call_daemon  _ 
call_daemon  - 
call_daemon  -- 
call_daemon  --version 
call_daemon  --help 
call_daemon  $USER 
call_daemon  $HOME 
call_daemon  %d 
call_daemon  %s 
call_daemon  {0} 
call_daemon  %*.*s 
call_daemon  File:///
call_daemon  ../../../../../../../../../../../etc/passwd%00 
call_daemon  ../../../../../../../../../../../etc/hosts 
call_daemon  +++ATH0 
call_daemon  CON 
call_daemon  PRN 
call_daemon  AUX 
call_daemon  CLOCK$ 
call_daemon  NUL 
call_daemon  A: 
call_daemon  ZZ: 
call_daemon  COM1 
call_daemon  LPT1 
call_daemon  LPT2 
call_daemon  LPT3 
call_daemon  COM2 
call_daemon  COM3 
call_daemon  COM4 
call_daemon  DCC SEND STARTKEYLOGGER 0 0 0 
call_daemon  Scunthorpe General Hospital 
call_daemon  Penistone Community Church 
call_daemon  Lightwater Country Park 
call_daemon  Jimmy Clitheroe 
call_daemon  Horniman Museum 
call_daemon  shitake mushrooms 
call_daemon  RomansInSussex.co.uk 
call_daemon  http://www.cum.qc.ca/ 
call_daemon  Craig Cockburn, Software Specialist 
call_daemon  Linda Callahan 
call_daemon  Dr. Herman I. Libshitz 
call_daemon  magna cum laude 
call_daemon  Super Bowl XXX 
call_daemon  medieval erection of parapets 
call_daemon  evaluate 
call_daemon  mocha 
call_daemon  expression 
call_daemon  Arsenal canal 
call_daemon  classic 
call_daemon  Tyson Gay 
call_daemon  Dick Van Dyke 
call_daemon  basement 


echo "Killing daemon..."
kill -9 $(pgrep bloomd)