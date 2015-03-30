From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AW: problem with testing a CTR block cipher mode which is partially working
Date: Mon, 30 Mar 2015 21:11:30 +0200
Message-ID: <1590314.BYVZBJiBoM@tachyon.chronox.de>
References: <55198F14.1090902@gmail.com> <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39570 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbbC3TLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 15:11:35 -0400
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 30. M=E4rz 2015, 18:08:28 schrieb Markus Stockhausen:

Hi Markus,

> > Von: linux-crypto-owner@vger.kernel.org
> > [linux-crypto-owner@vger.kernel.org]&quot; im Auftrag von &quot;Cor=
entin
> > LABBE [clabbe.montjoie@gmail.com] Gesendet: Montag, 30. M=E4rz 2015=
 19:59
> > An: linux-crypto@vger.kernel.org
> > Cc: linux-sunxi@googlegroups.com
> > Betreff: problem with testing a CTR block cipher mode which is part=
ially
> > working
> >=20
> > hello
> >=20
> > I am trying to add the CTR (counter) block cipher mode for AES on m=
y
> > Security System driver.
> >=20
> > When testing with the tcrypt module I got the following result:
> > [ 1256.986989] alg: skcipher: Test 1 failed on encryption for
> > ctr-aes-sunxi-ss [ 1256.987004] 00000000: 87 4d 61 91 b6 20 e3 26 1=
b ef
> > 68 64 99 0d b6 ce [ 1256.987013] 00000010: 40 94 25 91 d7 b4 4f 49 =
ab c1
> > 9d 33 a4 4e f6 54 [ 1256.987023] 00000020: ce 58 d2 f0 01 8f 92 a2 =
5f 2c
> > bb 66 13 8b 9d 76 [ 1256.987032] 00000030: 30 fa 4a 40 b1 67 2e f3 =
46 b7
> > 9a 7c ba 91 0b a2
> >=20
> > As you can see the first ciphered block is correct (according to
> > testmgr.h), the subsequent blocks are bad.
> >=20
> > So Could I assume that the setting of key and IV are good (at least=
 for
> > the first cipher pass.
> >=20
> > The number of inputs(register) are limited and I have tested near a=
ll the
> > possibility. Any idea of what could be wrong.
>=20
> had a similar challenge a few months ago. I had to take care about
>=20
> - counter IV is big endian (implemented it little endian in first pla=
ce)

Use crypto_inc for the counter which properly increments in big endian.

> - CTR allows to encrypt data that does not need to be amultiple of 16=
 bytes.
>=20
> Markus


--=20
Ciao
Stephan
