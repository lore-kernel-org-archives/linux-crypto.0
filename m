From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: problem with testing a CTR block cipher mode which is partially
 working
Date: Mon, 30 Mar 2015 18:08:28 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>
References: <55198F14.1090902@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-1e7d5e99-7ef4-48fd-bef8-ff6574f04454"
Cc: "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
To: Corentin LABBE <clabbe.montjoie@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:61188 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752919AbbC3SId (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 14:08:33 -0400
In-Reply-To: <55198F14.1090902@gmail.com>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-1e7d5e99-7ef4-48fd-bef8-ff6574f04454
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> Von: linux-crypto-owner@vger.kernel.org [linux-crypto-owner@vger.kernel.o=
rg]&quot; im Auftrag von &quot;Corentin LABBE [clabbe.montjoie@gmail.com]=
=0A=
> Gesendet: Montag, 30. M=E4rz 2015 19:59=0A=
> An: linux-crypto@vger.kernel.org=0A=
> Cc: linux-sunxi@googlegroups.com=0A=
> Betreff: problem with testing a CTR block cipher mode which is partially =
working=0A=
> =0A=
> hello=0A=
> =0A=
> I am trying to add the CTR (counter) block cipher mode for AES on my Secu=
rity System driver.=0A=
> =0A=
> When testing with the tcrypt module I got the following result:=0A=
> [ 1256.986989] alg: skcipher: Test 1 failed on encryption for ctr-aes-sun=
xi-ss=0A=
> [ 1256.987004] 00000000: 87 4d 61 91 b6 20 e3 26 1b ef 68 64 99 0d b6 ce=
=0A=
> [ 1256.987013] 00000010: 40 94 25 91 d7 b4 4f 49 ab c1 9d 33 a4 4e f6 54=
=0A=
> [ 1256.987023] 00000020: ce 58 d2 f0 01 8f 92 a2 5f 2c bb 66 13 8b 9d 76=
=0A=
> [ 1256.987032] 00000030: 30 fa 4a 40 b1 67 2e f3 46 b7 9a 7c ba 91 0b a2=
=0A=
> =0A=
> As you can see the first ciphered block is correct (according to testmgr.=
h), the subsequent blocks are bad.=0A=
> =0A=
> So Could I assume that the setting of key and IV are good (at least for t=
he first cipher pass.=0A=
> =0A=
> The number of inputs(register) are limited and I have tested near all the=
 possibility.=0A=
> Any idea of what could be wrong.=0A=
> =0A=
=0A=
had a similar challenge a few months ago. I had to take care about=0A=
=0A=
- counter IV is big endian (implemented it little endian in first place)=0A=
- CTR allows to encrypt data that does not need to be amultiple of 16 bytes=
.=0A=
=0A=
Markus=0A=
=0A=
------=_NextPartTM-000-1e7d5e99-7ef4-48fd-bef8-ff6574f04454
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-1e7d5e99-7ef4-48fd-bef8-ff6574f04454--
