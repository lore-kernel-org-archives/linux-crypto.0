From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 1/6] crypto: sha512: implement base layer for SHA-512
Date: Sun, 29 Mar 2015 12:38:11 +0200
Message-ID: <CAKv+Gu9kMPM2t5r8pgdw=Cc5juGTxCeJJc1L-yBy6AS_A2UUAA@mail.gmail.com>
References: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
	<1427580628-7128-2-git-send-email-ard.biesheuvel@linaro.org>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735FC8A1E8@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:32824 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbbC2KiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2015 06:38:12 -0400
Received: by iecvj10 with SMTP id vj10so98337400iec.0
        for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2015 03:38:12 -0700 (PDT)
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC8A1E8@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29 March 2015 at 10:29, Markus Stockhausen <stockhausen@collogia.de>=
 wrote:
>> Von: linux-crypto-owner@vger.kernel.org [linux-crypto-owner@vger.ker=
nel.org]&quot; im Auftrag von &quot;Ard Biesheuvel [ard.biesheuvel@lina=
ro.org]
>> Gesendet: Samstag, 28. M=C3=A4rz 2015 23:10
>> An: linux-arm-kernel@lists.infradead.org; linux-crypto@vger.kernel.o=
rg; samitolvanen@google.com; herbert@gondor.apana.org.au; jussi.kivilin=
na@iki.fi
>> Cc: Ard Biesheuvel
>> Betreff: [RFC PATCH 1/6] crypto: sha512: implement base layer for SH=
A-512
>>
>> To reduce the number of copies of boilerplate code throughout
>> the tree, this patch implements generic glue for the SHA-512
>> algorithm. This allows a specific arch or hardware implementation
>> to only implement the special handling that it needs.
>
> Hi Ard,
>
> Implementing a common layer is a very good idea - I didn't like to
> implement the glue code once again for some recently developed
> PPC crypto modules. From my very short crypto experience I was
> surprised that my optimized implementations degraded disproportional
> for small calculations in the <=3D256byte update scenarios in contras=
t to
> some very old basic implementations. Below you will find some hints,
> that might fit your implementation too. Thus all new implementations
> based on your framework could benefit immediately.
>

Thanks for taking a look!

>> ...
>> +int sha384_base_init(struct shash_desc *desc)
>> +{
>> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
>> +
>> +       *sctx =3D (struct sha512_state){
>> +               .state =3D {
>> +                       SHA384_H0, SHA384_H1, SHA384_H2, SHA384_H3,
>> +                       SHA384_H4, SHA384_H5, SHA384_H6, SHA384_H7,
>> +               }
>> +       };
>> +       return 0;
>> +}
>
> IIRC the above code will initialize the whole context including the 6=
4/128
> byte buffer. Direct assignment of the 8 hashes was faster in my case.
>

Ah, I missed that. I will change it.

>> ...
>> +int sha512_base_do_update(struct shash_desc *desc, const u8 *data,
>> +                         unsigned int len, sha512_block_fn *block_f=
n, void *p)
>> +{
>> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
>> +       unsigned int partial =3D sctx->count[0] % SHA512_BLOCK_SIZE;
>> +
>> +       sctx->count[0] +=3D len;
>> +       if (sctx->count[0] < len)
>> +               sctx->count[1]++;
>
> You should check if early kick out at this point if the buffer won't =
be filled up
> is faster than first taking care about big data. That can improve per=
formance
> for small blocks while large blocks might be unaffected.
>
>> +
>> +       if ((partial + len) >=3D SHA512_BLOCK_SIZE) {

Isn't this early kickout? The if is only entered if there is enough
data to run the block function, otherwise it is a straight memcpy. I
could add an unlikely() here to favor the small data case


>> +               int blocks;
>> +
>> +               if (partial) {
>> +                       int p =3D SHA512_BLOCK_SIZE - partial;
>> +
>> +                       memcpy(sctx->buf + partial, data, p);
>> +                       data +=3D p;
>> +                       len -=3D p;
>> +               }
>> +
>> +               blocks =3D len / SHA512_BLOCK_SIZE;
>> +               len %=3D SHA512_BLOCK_SIZE;
>> +
>> +               block_fn(blocks, data, sctx->state,
>> +                        partial ? sctx->buf : NULL, p);
>> +               data +=3D blocks * SHA512_BLOCK_SIZE;
>> +               partial =3D 0;
>> +       }
>> +       if (len)
>> +               memcpy(sctx->buf + partial, data, len);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(sha512_base_do_update);
>> +
>> +int sha512_base_do_finalize(struct shash_desc *desc, sha512_block_f=
n *block_fn,
>> +                           void *p)
>> +{
>> +       static const u8 padding[SHA512_BLOCK_SIZE] =3D { 0x80, };
>> +
>> +       struct sha512_state *sctx =3D shash_desc_ctx(desc);
>> +       unsigned int padlen;
>> +       __be64 bits[2];
>> +
>> +       padlen =3D SHA512_BLOCK_SIZE -
>> +                (sctx->count[0] + sizeof(bits)) % SHA512_BLOCK_SIZE=
;
>> +
>> +       bits[0] =3D cpu_to_be64(sctx->count[1] << 3 |
>> +                             sctx->count[0] >> 61);
>> +       bits[1] =3D cpu_to_be64(sctx->count[0] << 3);
>> +
>> +       sha512_base_do_update(desc, padding, padlen, block_fn, p);
>
> I know that this is the most intuitive and straight implementation fo=
r handling
> finalization. Nevertheless the maybe a little obscure generic md5 alg=
orithm
> gives best in class performance for hash finalization of small input =
data.
>

Well, memcpy'ing a buffer consisting almost entirely of zeroes doesn't
quite feel right, indeed.
I will instead follow the md5 suggestion

> For comparison: From the raw numbers the sha1-ppc-spe assembler modul=
e
> written by me is only 10% faster than the old sha1-popwerpc assembler=
 module.
> Both are simple assembler algorithms without hardware acceleration. F=
or large
> blocks I gain another 8% by avoding function calls because the core m=
odule
> may process several blocks. But for small single block updates the ab=
ove glue
> code optimizations gave
>
> 16byte block single update: +24%
> 64byte block single update: +16%
> 256byte block single update +12%
>
> Considering CPU assisted SHA calculations that percentage may be even=
 higher.
>
> Maybe worth the effort ...
>

Absolutely!

Thanks again
