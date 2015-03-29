From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [RFC PATCH 1/6] crypto: sha512: implement base layer for SHA-512
Date: Sun, 29 Mar 2015 16:05:57 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8A36E@EXCHANGE.collogia.de>
References: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
	<1427580628-7128-2-git-send-email-ard.biesheuvel@linaro.org>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735FC8A1E8@EXCHANGE.collogia.de>,<CAKv+Gu9kMPM2t5r8pgdw=Cc5juGTxCeJJc1L-yBy6AS_A2UUAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-456de776-2dcd-46d3-8ae8-eb55f55cffc1"
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:7132 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980AbbC2QHR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2015 12:07:17 -0400
In-Reply-To: <CAKv+Gu9kMPM2t5r8pgdw=Cc5juGTxCeJJc1L-yBy6AS_A2UUAA@mail.gmail.com>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-456de776-2dcd-46d3-8ae8-eb55f55cffc1
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> Von: Ard Biesheuvel [ard.biesheuvel@linaro.org]=0A=
> Gesendet: Sonntag, 29. M=E4rz 2015 12:38=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-arm-kernel@lists.infradead.org; linux-crypto@vger.kernel.org; s=
amitolvanen@google.com; herbert@gondor.apana.org.au; jussi.kivilinna@iki.fi=
=0A=
> Betreff: Re: [RFC PATCH 1/6] crypto: sha512: implement base layer for SHA=
-512=0A=
> =0A=
>>> ...=0A=
>>> +int sha512_base_do_update(struct shash_desc *desc, const u8 *data,=0A=
>>> +                         unsigned int len, sha512_block_fn *block_fn, =
void *p)=0A=
>>> +{=0A=
>>> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);=0A=
>>> +       unsigned int partial =3D sctx->count[0] % SHA512_BLOCK_SIZE;=0A=
>>> +=0A=
>>> +       sctx->count[0] +=3D len;=0A=
>>> +       if (sctx->count[0] < len)=0A=
>>> +               sctx->count[1]++;=0A=
>>>=0A=
>> You should check if early kick out at this point if the buffer won't be =
filled up=0A=
>> is faster than first taking care about big data. That can improve perfor=
mance=0A=
>> for small blocks while large blocks might be unaffected.=0A=
>>=0A=
>>> +=0A=
>>> +       if ((partial + len) >=3D SHA512_BLOCK_SIZE) {=0A=
>=0A=
>Isn't this early kickout? The if is only entered if there is enough=0A=
>data to run the block function, otherwise it is a straight memcpy. I=0A=
>could add an unlikely() here to favor the small data case=0A=
=0A=
I did my tests only on low end hardware. 32bit PPC e500 single core 800MHz=
=0A=
256K cache. Maybe it prefers early return statements. =0A=
=0A=
Additionally I ended up clearing the context in the finish function with a =
=0A=
simple inlined 32bit writes loop. Everything else (e.g. memzero) resulted i=
n =0A=
slower processing. Don't know what your clearing syntax will produce after=
=0A=
compilation.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-456de776-2dcd-46d3-8ae8-eb55f55cffc1
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

------=_NextPartTM-000-456de776-2dcd-46d3-8ae8-eb55f55cffc1--
