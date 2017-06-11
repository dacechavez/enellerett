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
$cmdline -w  和製漢語 
$cmdline -w  部落格 
$cmdline -w  사회과학원 어학연구소 
$cmdline -w  찦차를 타고 온 펲시맨과 쑛다리 똠방각하 
$cmdline -w  社會科學院語學研究所 
$cmdline -w  울란바토르 
$cmdline -w  𠜎𠜱𠝹𠱓𠱸𠲖𠳏 
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
$cmdline -w  $HOME 
$cmdline -w  %d 
$cmdline -w  %s 
$cmdline -w  {0} 
$cmdline -w  %*.*s 
$cmdline -w  File:///
$cmdline -w  ../../../../../../../../../../../etc/passwd%00 
$cmdline -w  ../../../../../../../../../../../etc/hosts 
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


echo "Killing daemon..."
kill -9 $(pgrep bloomd)