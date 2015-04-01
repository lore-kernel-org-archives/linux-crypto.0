From: "kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: AW: problem with testing a CTR block cipher
 mode which is partially working
Date: Wed, 1 Apr 2015 10:06:37 +0800
Message-ID: <2015040110063394945846@gmail.com>
References: <55198F14.1090902@gmail.com>,
	<12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>,
	<551AE140.3000209@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_001_NextPart650844260004_=----"
Cc: "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
	"Markus Stockhausen" <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-sunxi+bncBC5PRQO6XENRBMNF5WUAKGQEX3BS6TI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.

------=_001_NextPart650844260004_=----
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear All,

About the SS module, there is some detail information.
There is some issues on the SS hardware module, the issues make the some=20
AES/DES/3DS algorithm be not available.
1. The byte order of the counter is wrong, make the result error, so, the C=
TR=20
mode is not available.
2. Hardware don't support the continuous subcontracting, make the CTS mode =
is=20
not available.
3. Another issue need be taken attention is that hardware will modify the k=
ey=20
register when do AES encrypt, so, it need software to restore the key regis=
ter
when doing every frame.

These issues are presented on the A10, A13, A20, A31 and A33.
The issues of SS module have been fixed on the A83T platform, so, I suggest=
 to=20
take more attention to the A83T platform if any interest in the SS module.

If any problem, please don't hesitate to contact me(kevin-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org=
)
or Shuge(shuge-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org).



kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
=20
From: Corentin LABBE
Date: 2015-04-01 02:02
To: Markus Stockhausen; linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Subject: [linux-sunxi] Re: AW: problem with testing a CTR block cipher mode=
 which is partially working
Le 30/03/2015 20:08, Markus Stockhausen a =C3=A9crit :
>> Von: linux-crypto-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-crypto-owner-u79uwXL29TasMV2rI37PzA@public.gmane.org=
org]&quot; im Auftrag von &quot;Corentin LABBE [clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Gesendet: Montag, 30. M=C3=A4rz 2015 19:59
>> An: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
>> Betreff: problem with testing a CTR block cipher mode which is partially=
 working
>>
>> hello
>>
>> I am trying to add the CTR (counter) block cipher mode for AES on my Sec=
urity System driver.
>>
>> When testing with the tcrypt module I got the following result:
>> [ 1256.986989] alg: skcipher: Test 1 failed on encryption for ctr-aes-su=
nxi-ss
>> [ 1256.987004] 00000000: 87 4d 61 91 b6 20 e3 26 1b ef 68 64 99 0d b6 ce
>> [ 1256.987013] 00000010: 40 94 25 91 d7 b4 4f 49 ab c1 9d 33 a4 4e f6 54
>> [ 1256.987023] 00000020: ce 58 d2 f0 01 8f 92 a2 5f 2c bb 66 13 8b 9d 76
>> [ 1256.987032] 00000030: 30 fa 4a 40 b1 67 2e f3 46 b7 9a 7c ba 91 0b a2
>>
>> As you can see the first ciphered block is correct (according to testmgr=
.h), the subsequent blocks are bad.
>>
>> So Could I assume that the setting of key and IV are good (at least for =
the first cipher pass.
>>
>> The number of inputs(register) are limited and I have tested near all th=
e possibility.
>> Any idea of what could be wrong.
>>
>=20
> had a similar challenge a few months ago. I had to take care about
>=20
> - counter IV is big endian (implemented it little endian in first place)
> - CTR allows to encrypt data that does not need to be amultiple of 16 byt=
es.
>=20
> Markus
>=20
=20
Sorry but if I change endianness of anything, the first block became invali=
d.
=20
I have tryed ctr(des) but the same problem rise, the first block (so the fi=
rst 8bytes) are correctly ciphered then everything is bad.
So I suspect the hardware to not increasing counter between blocks, but why=
..
=20
=20
--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

------=_001_NextPart650844260004_=----
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=
=3DUTF-8"><style>body { line-height: 1.5; }blockquote { margin-top: 0px; ma=
rgin-bottom: 0px; margin-left: 0.5em; }p { margin-top: 0px; margin-bottom: =
0px; }body { font-size: 10.5pt; font-family: =E6=A5=B7=E4=BD=93; color: rgb=
(0, 0, 0); line-height: 1.5; }</style></head><body>
<div><span></span><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0pt; font=
-family: =E6=A5=B7=E4=BD=93, Tahoma; font-size: 14.399999618530273px; line-=
height: 16.799999237060547px;"><span style=3D"font-family: =E6=96=B0=E5=AE=
=8B=E4=BD=93;">Dear All,</span></p><p class=3D"MsoNormal" style=3D"margin: =
0cm 0cm 0pt; font-family: =E6=A5=B7=E4=BD=93, Tahoma; font-size: 14.3999996=
18530273px; line-height: 16.799999237060547px;"><span style=3D"font-family:=
 =E6=96=B0=E5=AE=8B=E4=BD=93;"><br></span></p><p class=3D"MsoNormal" style=
=3D"margin: 0cm 0cm 0pt; font-size: 14.399999618530273px; line-height: 16.7=
99999237060547px;"><span style=3D"font-family: =E6=96=B0=E5=AE=8B=E4=BD=93;=
 background-color: rgba(0, 0, 0, 0);">About the SS module, there is some de=
tail information.<br>There is some issues on the SS hardware module, the is=
sues make the some <br>AES/DES/3DS algorithm be not available.<br>1. The by=
te order of the counter is wrong, make the result error, so, the CTR <br>mo=
de is not available.<br>2. Hardware don't support the continuous subcontrac=
ting, make the CTS mode is <br>not available.<br>3. Another issue need be t=
aken attention is that hardware will modify the key <br>register when do AE=
S encrypt, so, it need software to restore the key register</span></p><p cl=
ass=3D"MsoNormal" style=3D"margin: 0cm 0cm 0pt; font-size: 14.3999996185302=
73px; line-height: 16.799999237060547px;"><span style=3D"font-family: =E6=
=96=B0=E5=AE=8B=E4=BD=93; background-color: rgba(0, 0, 0, 0);">when doing e=
very frame.<br><br>These issues are presented on the A10, A13, A20, A31 and=
 A33.<br>The issues of SS module have been fixed on the A83T platform, so, =
I suggest to <br>take more attention to the A83T platform if any interest i=
n the SS module.<br><br>If any problem, please don't hesitate to contact me=
(kevin-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org</span><span style=3D"background-color: rgba(0, 0, =
0, 0); font-family: =E6=96=B0=E5=AE=8B=E4=BD=93; font-size: 14.399999618530=
273px; line-height: 16.799999237060547px;">)</span></p><p class=3D"MsoNorma=
l" style=3D"margin: 0cm 0cm 0pt; font-size: 14.399999618530273px; line-heig=
ht: 16.799999237060547px;"><span style=3D"font-family: =E6=96=B0=E5=AE=8B=
=E4=BD=93; background-color: rgba(0, 0, 0, 0);">or Shuge(shuge@allwinnertec=
h.com).</span></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0pt; font=
-family: =E6=A5=B7=E4=BD=93, Tahoma; font-size: 14.399999618530273px; line-=
height: 16.799999237060547px;"><br></p></div><hr style=3D"width: 210px; hei=
ght: 1px;" color=3D"#b5c4df" size=3D"1" align=3D"left">
<div><span><div style=3D"MARGIN: 10px; FONT-FAMILY: verdana; FONT-SIZE: 10p=
t"><div>kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</div></div></span></div>
<blockquote style=3D"margin-top: 0px; margin-bottom: 0px; margin-left: 0.5e=
m;"><div>&nbsp;</div><div style=3D"border:none;border-top:solid #B5C4DF 1.0=
pt;padding:3.0pt 0cm 0cm 0cm"><div style=3D"PADDING-RIGHT: 8px; PADDING-LEF=
T: 8px; FONT-SIZE: 12px;FONT-FAMILY:tahoma;COLOR:#000000; BACKGROUND: #efef=
ef; PADDING-BOTTOM: 8px; PADDING-TOP: 8px"><div><b>From:</b>&nbsp;<a href=
=3D"mailto:clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">Corentin LABBE</a></div><div><b>Date:=
</b>&nbsp;2015-04-01&nbsp;02:02</div><div><b>To:</b>&nbsp;<a href=3D"mailto=
:stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org">Markus Stockhausen</a>; <a href=3D"mailto:linux-c=
rypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a></div><div><b>CC:</b=
>&nbsp;<a href=3D"mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">linux-sunxi@googlegr=
oups.com</a></div><div><b>Subject:</b>&nbsp;[linux-sunxi] Re: AW: problem w=
ith testing a CTR block cipher mode which is partially working</div></div><=
/div><div><div>Le 30/03/2015 20:08, Markus Stockhausen a =C3=A9crit :</div>
<div>&gt;&gt; Von: linux-crypto-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-crypto-owner@v=
ger.kernel.org]&amp;quot; im Auftrag von &amp;quot;Corentin LABBE [clabbe.m=
ontjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]</div>
<div>&gt;&gt; Gesendet: Montag, 30. M=C3=A4rz 2015 19:59</div>
<div>&gt;&gt; An: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</div>
<div>&gt;&gt; Cc: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</div>
<div>&gt;&gt; Betreff: problem with testing a CTR block cipher mode which i=
s partially working</div>
<div>&gt;&gt;</div>
<div>&gt;&gt; hello</div>
<div>&gt;&gt;</div>
<div>&gt;&gt; I am trying to add the CTR (counter) block cipher mode for AE=
S on my Security System driver.</div>
<div>&gt;&gt;</div>
<div>&gt;&gt; When testing with the tcrypt module I got the following resul=
t:</div>
<div>&gt;&gt; [ 1256.986989] alg: skcipher: Test 1 failed on encryption for=
 ctr-aes-sunxi-ss</div>
<div>&gt;&gt; [ 1256.987004] 00000000: 87 4d 61 91 b6 20 e3 26 1b ef 68 64 =
99 0d b6 ce</div>
<div>&gt;&gt; [ 1256.987013] 00000010: 40 94 25 91 d7 b4 4f 49 ab c1 9d 33 =
a4 4e f6 54</div>
<div>&gt;&gt; [ 1256.987023] 00000020: ce 58 d2 f0 01 8f 92 a2 5f 2c bb 66 =
13 8b 9d 76</div>
<div>&gt;&gt; [ 1256.987032] 00000030: 30 fa 4a 40 b1 67 2e f3 46 b7 9a 7c =
ba 91 0b a2</div>
<div>&gt;&gt;</div>
<div>&gt;&gt; As you can see the first ciphered block is correct (according=
 to testmgr.h), the subsequent blocks are bad.</div>
<div>&gt;&gt;</div>
<div>&gt;&gt; So Could I assume that the setting of key and IV are good (at=
 least for the first cipher pass.</div>
<div>&gt;&gt;</div>
<div>&gt;&gt; The number of inputs(register) are limited and I have tested =
near all the possibility.</div>
<div>&gt;&gt; Any idea of what could be wrong.</div>
<div>&gt;&gt;</div>
<div>&gt; </div>
<div>&gt; had a similar challenge a few months ago. I had to take care abou=
t</div>
<div>&gt; </div>
<div>&gt; - counter IV is big endian (implemented it little endian in first=
 place)</div>
<div>&gt; - CTR allows to encrypt data that does not need to be amultiple o=
f 16 bytes.</div>
<div>&gt; </div>
<div>&gt; Markus</div>
<div>&gt; </div>
<div>&nbsp;</div>
<div>Sorry but if I change endianness of anything, the first block became i=
nvalid.</div>
<div>&nbsp;</div>
<div>I have tryed ctr(des) but the same problem rise, the first block (so t=
he first 8bytes) are correctly ciphered then everything is bad.</div>
<div>So I suspect the hardware to not increasing counter between blocks, bu=
t why..</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>-- </div>
<div>You received this message because you are subscribed to the Google Gro=
ups "linux-sunxi" group.</div>
<div>To unsubscribe from this group and stop receiving emails from it, send=
 an email to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org</div>
<div>For more options, visit https://groups.google.com/d/optout.</div>
</div></blockquote>
</body></html>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;linux-sunxi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">linux-s=
unxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

------=_001_NextPart650844260004_=------
