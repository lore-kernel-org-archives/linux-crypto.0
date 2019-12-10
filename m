Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D48C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 13:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68F320652
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 13:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bQXlBTV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfLJNyH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 08:54:07 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:36577 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfLJNyH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 08:54:07 -0500
Received: by mail-wm1-f41.google.com with SMTP id p17so3304848wma.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2019 05:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wJv4A44Eqoc+KiEJG2QTZn4uQ1BPHzg2Kjrnh6RrONs=;
        b=bQXlBTV1VbBRYEpuREpMpEdrWBUmaE9OvwE13XnoUQvn6LJ3KsOBznuZYU8qlhvF8U
         Njvt0pqcSNiRHRNkjWPX8yTqmJxb8An1E46FVPToLWC2DwQSx8JzjC1Y87dtnHatlNhH
         k9XpXzzYaAmGYukFjE4uLr4hrsCf3wKxF6uAzrLnmUCMzrPY4KL5ohbLjIvXsn232UYH
         LnwfjAYG7ZQGt+xpHuWtVhwZTRyMvDfWnuMLbYN+eQTWV1q/NzQI/7EyWFJVk5nKpSqq
         DzkTgEf+C9uCSkXNhGcInCeCRhEACvFFyaxFBAdm8+xmnD7SoqDGnBP1LEnerT+MWe2O
         TqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJv4A44Eqoc+KiEJG2QTZn4uQ1BPHzg2Kjrnh6RrONs=;
        b=FQuzFnfC49WbrDEqmx/NCYvRprts9yQfP1JJR8ZH5ru3UrGr1hTvFBkn2hKcabVgWS
         NKjQVYE6JZNrbALev7U8nq+EHp0gp48dl3w0dV51OWGt1VQq83cnrfmfG+zvsi9B2MQf
         TyS9FmsAnCwDEbmQSRCPvwMw29JPh7aS8YnjMWFLv4nWt/5a9zRVKvaK+v3tPmVjRkRl
         WEaz3cyTh2eGu/xRiVwR+Dcefh+1M9V23N3jnauzmRhPboozSZdupyJ1d/b30HL68XbP
         4gUHuCbMN4haNF5swjgTp6k9/WlL36WcOSR9cuLIU2SrSeZrVIzT7UiOC3NWGAzfQImD
         NsLA==
X-Gm-Message-State: APjAAAUNy9Bt8VFIPFwZU1J5DX0LGdeRreQP+r/P7PhpM9W5ecAKkQl0
        4llrRga4X5+07heD0cKKq+iUyf6MfroAsgDBm6QD5QKGzLbVmw==
X-Google-Smtp-Source: APXvYqwBxhF7Kfnu4bQoC9dbSv+9H4wH6NV1BslXpgs0bEmjD7O4wWkN4tZpq0vo3J0DjzC3gWq3od/urpJZpg/+J94=
X-Received: by 2002:a1c:a591:: with SMTP id o139mr5130012wme.95.1575986043855;
 Tue, 10 Dec 2019 05:54:03 -0800 (PST)
MIME-Version: 1.0
References: <de5768f5-8c56-bec0-0c73-04aa4805c749@ti.com> <CAKv+Gu-XNFE+=griwBJCNooyoV7BR81hkqQ9jV3PDb-P6ghYxg@mail.gmail.com>
 <82a75666-3cb7-e33d-d873-1aad5581a13c@ti.com> <CAKv+Gu9H9wFbAZwA5Gt6TaqBVEQheryP+kG+y5FsmNmf8FE5_Q@mail.gmail.com>
 <2a124fcf-9bdc-7305-1d0b-6482ffffe3c5@ti.com>
In-Reply-To: <2a124fcf-9bdc-7305-1d0b-6482ffffe3c5@ti.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 10 Dec 2019 14:53:52 +0100
Message-ID: <CAKv+Gu8kr-n0D8r17a4RXNO_VfNRGNjvwdCMazE9rb9OSthzbg@mail.gmail.com>
Subject: Re: aes_expandkey giving wrong expanded keys over crypto_aes_expand_key(older
 deprecated implementation under aes_generic)
To:     Keerthy <j-keerthy@ti.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, "Kristo, Tero" <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 10 Dec 2019 at 12:04, Keerthy <j-keerthy@ti.com> wrote:
>
>
>
> On 10/12/19 3:37 pm, Ard Biesheuvel wrote:
> > On Tue, 10 Dec 2019 at 11:06, Keerthy <j-keerthy@ti.com> wrote:
> >>
> >>
> >>
> >> On 10/12/19 3:31 pm, Ard Biesheuvel wrote:
> >>> Hello Keerthy,
> >>>
> >>> On Tue, 10 Dec 2019 at 10:35, Keerthy <j-keerthy@ti.com> wrote:
> >>>>
> >>>> Hi Ard,
> >>>>
> >>>> I am not sure if am the first one to report this. It seems like
> >>>> aes_expandkey is giving me different expansion over what i get with the
> >>>> older crypto_aes_expand_key which was removed with the below commit:
> >>>>
> >>>> commit 5bb12d7825adf0e80b849a273834f3131a6cc4e1
> >>>> Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>>> Date:   Tue Jul 2 21:41:33 2019 +0200
> >>>>
> >>>>     crypto: aes-generic - drop key expansion routine in favor of library
> >>>> version
> >>>>
> >>>> The key that is being expanded is from the crypto aes(cbc) testsuite:
> >>>>
> >>>>   }, { /* From NIST SP800-38A */
> >>>>                 .key    = "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
> >>>>                           "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
> >>>>                           "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
> >>>>                 .klen   = 24,
> >>>>
> >>>>
> >>>> The older version crypto_aes_expand_key output that passes the cbc(aes)
> >>>> decryption test:
> > ...
> >>>>
> >>>> The difference is between 52nd index through 59.
> >>>>
> >>>> Any ideas if this is expected?
> >>>>
> >>>
> >>> Yes, this is expected. This particular test vector uses a 192 bit key,
> >>> so those values are DC/ignored.
> >>
> >> Thanks for the quick response. However with the new implementation
> >> decryption test case fails for me with wrong result.
> >
> > Can you share more details please? Platform, endianness, etc ..
>
> Ard,
>
> I am trying to get aes working on a yet to be upstream TI HW crypto
> Accelerator SA2UL. It is little endian.
>
> I had posted a series earlier this year:
>
> https://lkml.org/lkml/2019/6/28/20
>
> The device expects the inverse key for decryption.
>

Could you elaborate? There is no such thing as an inverse *key*, only
an inverse *key schedule* which is used for the Equivalent Inverse
Cipher.

AES-192 expands the 24 byte key to 13 round keys consisting of 4
32-bit words each, and so the algorithm does not actually use the
contents of slots 52 and up in this case.

> In the earlier working version i was copying the ctx.key_enc[48] to
> ctx.key_enc[53] index of the ctx.key_enc array as the 24 bytes of
> decryption key to my hardware.
>
> Now as told earlier the 52nd & 53rd words are changed and hence i end up
> in wrong result.
>
> Fail:
>
> ctx.key_dec[48] = 0xf7b0738e & ctx.key_enc[48] = 0x6fa08be9
> ctx.key_dec[49] = 0x52640eda & ctx.key_enc[49] = 0x3c778c44
> ctx.key_dec[50] = 0x2bf310c8 & ctx.key_enc[50] = 0x472cc8e
> ctx.key_dec[51] = 0xe5799080 & ctx.key_enc[51] = 0x2220001
> ctx.key_dec[52] = 0x13eaf950 & ctx.key_enc[52] = 0x13eaf850
> ctx.key_dec[53] = 0xffff8000 & ctx.key_enc[53] = 0xffff8000
>
> Pass:
>
> ctx.key_dec[48] = 0xf7b0738e & ctx.key_enc[48] = 0x6fa08be9
> ctx.key_dec[49] = 0x52640eda & ctx.key_enc[49] = 0x3c778c44
> ctx.key_dec[50] = 0x2bf310c8 & ctx.key_enc[50] = 0x472cc8e
> ctx.key_dec[51] = 0xe5799080 & ctx.key_enc[51] = 0x2220001
> ctx.key_dec[52] = 0x105127e8 & ctx.key_enc[52] = 0x68342d29
> ctx.key_dec[53] = 0xffff8000 & ctx.key_enc[53] = 0xddd31195
>

The old code does the following for AES-192

#define loop6(i)       do {            \
       t = ror32(t, 8);                \
       t = ls_box(t) ^ rco_tab[i];     \
       t ^= ctx->key_enc[6 * i];               \
       ctx->key_enc[6 * i + 6] = t;            \
       t ^= ctx->key_enc[6 * i + 1];           \
       ctx->key_enc[6 * i + 7] = t;            \
       t ^= ctx->key_enc[6 * i + 2];           \
       ctx->key_enc[6 * i + 8] = t;            \
       t ^= ctx->key_enc[6 * i + 3];           \
       ctx->key_enc[6 * i + 9] = t;            \
       t ^= ctx->key_enc[6 * i + 4];           \
       ctx->key_enc[6 * i + 10] = t;           \
       t ^= ctx->key_enc[6 * i + 5];           \
       ctx->key_enc[6 * i + 11] = t;           \
} while (0)

case AES_KEYSIZE_192:
        ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
        t = ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
        for (i = 0; i < 8; ++i)
                loop6(i);
        break;

so while it happens to populate slots 52 and 53 as well (when i == 7),
the AES spec does not actually cover this, given that those values are
not actually used in the computation (and I am at a loss understanding
why it should make a difference in your case).

In any case, you can work around this by calculating the missing
values in your driver's expand_key() routine,

ctx.key_enc[52] = ctx.key_enc[51] ^ ctx.key_enc[46];
ctx.key_enc[53] = ctx.key_enc[52] ^ ctx.key_enc[47];
