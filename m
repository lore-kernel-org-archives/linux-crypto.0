From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: Best way to align key in AES context
Date: Wed, 11 Feb 2015 10:28:38 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD877@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD863@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-24d2c916-5db6-4edb-ab0b-dcef39fc8f80"
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:26556 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751065AbbBKK2l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Feb 2015 05:28:41 -0500
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD863@EXCHANGE.collogia.de>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-24d2c916-5db6-4edb-ab0b-dcef39fc8f80
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,=0A=
=0A=
I want to ensure that the key data in an AES ctx structure is 8 byte aligne=
d=0A=
to avoid aligment exceptions afterwards. Other fields don't need that=0A=
restriction. At the moment I'm using the following (ugly) implementation.=
=0A=
=0A=
struct ppc_aes_ctx {=0A=
        u32 rounds;=0A=
        u32 *key_enc;=0A=
        u32 *key_dec;=0A=
        char data[AES_MAX_KEYLENGTH * 2 + 8];=0A=
};=0A=
...=0A=
char *ptr;=0A=
ptr =3D ctx->data;=0A=
ptr =3D PTR_ALIGN(ptr, 8);=0A=
ctx->key_enc =3D (u32 *)(ptr);=0A=
ctx->key_dec =3D (u32 *)(ptr + AES_MAX_KEYLENGTH);=0A=
=0A=
Can anyone show me the recommended way for doing that.=0A=
=0A=
Thanks in advance.=0A=
=0A=
Markus=
------=_NextPartTM-000-24d2c916-5db6-4edb-ab0b-dcef39fc8f80
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

------=_NextPartTM-000-24d2c916-5db6-4edb-ab0b-dcef39fc8f80--
