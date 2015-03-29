From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [RFC PATCH 1/6] crypto: sha512: implement base layer for SHA-512
Date: Sun, 29 Mar 2015 08:29:39 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8A1E8@EXCHANGE.collogia.de>
References: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>,<1427580628-7128-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-da7c72ba-91c6-454d-9143-4f659045ea6b"
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:5888 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751010AbbC2Ibq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2015 04:31:46 -0400
In-Reply-To: <1427580628-7128-2-git-send-email-ard.biesheuvel@linaro.org>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-da7c72ba-91c6-454d-9143-4f659045ea6b
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> Von: linux-crypto-owner@vger.kernel.org [linux-crypto-owner@vger.kernel.o=
rg]&quot; im Auftrag von &quot;Ard Biesheuvel [ard.biesheuvel@linaro.org]=
=0A=
> Gesendet: Samstag, 28. M=E4rz 2015 23:10=0A=
> An: linux-arm-kernel@lists.infradead.org; linux-crypto@vger.kernel.org; s=
amitolvanen@google.com; herbert@gondor.apana.org.au; jussi.kivilinna@iki.fi=
=0A=
> Cc: Ard Biesheuvel=0A=
> Betreff: [RFC PATCH 1/6] crypto: sha512: implement base layer for SHA-512=
=0A=
> =0A=
> To reduce the number of copies of boilerplate code throughout=0A=
> the tree, this patch implements generic glue for the SHA-512=0A=
> algorithm. This allows a specific arch or hardware implementation=0A=
> to only implement the special handling that it needs.=0A=
=0A=
Hi Ard,=0A=
=0A=
Implementing a common layer is a very good idea - I didn't like to =0A=
implement the glue code once again for some recently developed =0A=
PPC crypto modules. From my very short crypto experience I was =0A=
surprised that my optimized implementations degraded disproportional =0A=
for small calculations in the <=3D256byte update scenarios in contrast to =
=0A=
some very old basic implementations. Below you will find some hints, =0A=
that might fit your implementation too. Thus all new implementations =0A=
based on your framework could benefit immediately.=0A=
=0A=
> ...=0A=
> +int sha384_base_init(struct shash_desc *desc)=0A=
> +{=0A=
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);=0A=
> +=0A=
> +       *sctx =3D (struct sha512_state){=0A=
> +               .state =3D {=0A=
> +                       SHA384_H0, SHA384_H1, SHA384_H2, SHA384_H3,=0A=
> +                       SHA384_H4, SHA384_H5, SHA384_H6, SHA384_H7,=0A=
> +               }=0A=
> +       };=0A=
> +       return 0;=0A=
> +}=0A=
=0A=
IIRC the above code will initialize the whole context including the 64/128=
=0A=
byte buffer. Direct assignment of the 8 hashes was faster in my case. =0A=
=0A=
> ...=0A=
> +int sha512_base_do_update(struct shash_desc *desc, const u8 *data,=0A=
> +                         unsigned int len, sha512_block_fn *block_fn, vo=
id *p)=0A=
> +{=0A=
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);=0A=
> +       unsigned int partial =3D sctx->count[0] % SHA512_BLOCK_SIZE;=0A=
> +=0A=
> +       sctx->count[0] +=3D len;=0A=
> +       if (sctx->count[0] < len)=0A=
> +               sctx->count[1]++;=0A=
=0A=
You should check if early kick out at this point if the buffer won't be fil=
led up=0A=
is faster than first taking care about big data. That can improve performan=
ce=0A=
for small blocks while large blocks might be unaffected.=0A=
=0A=
> +=0A=
> +       if ((partial + len) >=3D SHA512_BLOCK_SIZE) {=0A=
> +               int blocks;=0A=
> +=0A=
> +               if (partial) {=0A=
> +                       int p =3D SHA512_BLOCK_SIZE - partial;=0A=
> +=0A=
> +                       memcpy(sctx->buf + partial, data, p);=0A=
> +                       data +=3D p;=0A=
> +                       len -=3D p;=0A=
> +               }=0A=
> +=0A=
> +               blocks =3D len / SHA512_BLOCK_SIZE;=0A=
> +               len %=3D SHA512_BLOCK_SIZE;=0A=
> +=0A=
> +               block_fn(blocks, data, sctx->state,=0A=
> +                        partial ? sctx->buf : NULL, p);=0A=
> +               data +=3D blocks * SHA512_BLOCK_SIZE;=0A=
> +               partial =3D 0;=0A=
> +       }=0A=
> +       if (len)=0A=
> +               memcpy(sctx->buf + partial, data, len);=0A=
> +=0A=
> +       return 0;=0A=
> +}=0A=
> +EXPORT_SYMBOL(sha512_base_do_update);=0A=
> +=0A=
> +int sha512_base_do_finalize(struct shash_desc *desc, sha512_block_fn *bl=
ock_fn,=0A=
> +                           void *p)=0A=
> +{=0A=
> +       static const u8 padding[SHA512_BLOCK_SIZE] =3D { 0x80, };=0A=
> +=0A=
> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);=0A=
> +       unsigned int padlen;=0A=
> +       __be64 bits[2];=0A=
> +=0A=
> +       padlen =3D SHA512_BLOCK_SIZE -=0A=
> +                (sctx->count[0] + sizeof(bits)) % SHA512_BLOCK_SIZE;=0A=
> +=0A=
> +       bits[0] =3D cpu_to_be64(sctx->count[1] << 3 |=0A=
> +                             sctx->count[0] >> 61);=0A=
> +       bits[1] =3D cpu_to_be64(sctx->count[0] << 3);=0A=
> +=0A=
> +       sha512_base_do_update(desc, padding, padlen, block_fn, p);=0A=
=0A=
I know that this is the most intuitive and straight implementation for hand=
ling=0A=
finalization. Nevertheless the maybe a little obscure generic md5 algorithm=
=0A=
gives best in class performance for hash finalization of small input data. =
=0A=
=0A=
For comparison: From the raw numbers the sha1-ppc-spe assembler module =0A=
written by me is only 10% faster than the old sha1-popwerpc assembler modul=
e. =0A=
Both are simple assembler algorithms without hardware acceleration. For lar=
ge =0A=
blocks I gain another 8% by avoding function calls because the core module =
=0A=
may process several blocks. But for small single block updates the above gl=
ue =0A=
code optimizations gave=0A=
=0A=
16byte block single update: +24%=0A=
64byte block single update: +16%=0A=
256byte block single update +12%=0A=
=0A=
Considering CPU assisted SHA calculations that percentage may be even highe=
r.=0A=
=0A=
Maybe worth the effort ... =0A=
=0A=
Markus=0A=
------=_NextPartTM-000-da7c72ba-91c6-454d-9143-4f659045ea6b
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

------=_NextPartTM-000-da7c72ba-91c6-454d-9143-4f659045ea6b--
