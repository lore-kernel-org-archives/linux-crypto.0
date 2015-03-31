From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: AW: problem with testing a CTR block cipher mode
 which is partially working
Date: Tue, 31 Mar 2015 20:02:40 +0200
Message-ID: <551AE140.3000209@gmail.com>
References: <55198F14.1090902@gmail.com> <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>,
 "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBQ6C5OUAKGQEHMBHPEY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

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

Sorry but if I change endianness of anything, the first block became invali=
d.

I have tryed ctr(des) but the same problem rise, the first block (so the fi=
rst 8bytes) are correctly ciphered then everything is bad.
So I suspect the hardware to not increasing counter between blocks, but why=
..


--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
