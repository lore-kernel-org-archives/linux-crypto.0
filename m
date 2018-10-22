Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DB1C67863
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Oct 2018 22:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D45E20652
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Oct 2018 22:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="NrsKd4sw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D45E20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbeJWGpy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Oct 2018 02:45:54 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:53233 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbeJWGpy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 02:45:54 -0400
Received: by mail-it1-f196.google.com with SMTP id 134-v6so13746800itz.2
        for <linux-crypto@vger.kernel.org>; Mon, 22 Oct 2018 15:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MRolh3nCcZxRyeru8QeQLX/oNifBU+Ja/laSMq/Ni8M=;
        b=NrsKd4swWWozs+V39V6HgVB+4jV5ErYuTBKXvJ/X3Xxc3eRIB3y5WwBvotOB3tEaD1
         5hwVihTOdbMc+tWWyFhWEmYqWkELEvhduoOrojuliljgWEd1ZCNikkK0lj4QI5tGyejn
         erUB5zxb5M9buU/gllHj4cgjN7B38YSRawxfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=MRolh3nCcZxRyeru8QeQLX/oNifBU+Ja/laSMq/Ni8M=;
        b=ZXzEuubt/PBRC6ZwYsSzIje/tWSH8ABHua/sDRd240Ska9h3vZLIOtB349meCcQON7
         6meKcyIv+akSdg6jt16Azmby3VVwbMEpOv4aQeGiCety/tpUy25hdIVH6kiLmQ4OvweB
         z8xl7+9KkXQTfOniVj8a6/mRfQpyczx0SErAR0fAYhslGyiGijbg7lYJN8643mfuG3tJ
         +U1GBVU559WXPy+9FMcHXtte+NyfvUBbeE6JkqFBmhZuF/VXonGnOhWMXfqpldbzLsyW
         Rf3oYiUORuMjPkBzZN38vs3os+lr9zohpu/7nscqmhZJ7PrSxxZHRwkvIWDYjcYilo7g
         Qdgw==
X-Gm-Message-State: ABuFfojEdDiz4mWS+3IG0sLDCxn0ym17kgM1j2faWcokzJAhqXH9L1O+
        sX0p7CoUhEEYsVy9YpbmysGlO3nUK3fHIRFfPHf+zQ==
X-Google-Smtp-Source: ACcGV60ViIeOTi5Lk+yvgj117r2VYWktKNH8PY7TbGXc6nB49d2dQbWr7HCc/eAPUbF0Pt+iHnFCfM3epTA8U8/zIiA=
X-Received: by 2002:a02:69cf:: with SMTP id e198-v6mr6645282jac.130.1540247128091;
 Mon, 22 Oct 2018 15:25:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Mon, 22 Oct 2018 15:25:27
 -0700 (PDT)
In-Reply-To: <20181022184236.GA59695@gmail.com>
References: <20181015175424.97147-1-ebiggers@kernel.org> <20181015175424.97147-10-ebiggers@kernel.org>
 <CAKv+Gu-5WM19g5HguDheAADbigKNxokDCFMekkt4OYdEEa8Avw@mail.gmail.com>
 <20181020053834.GC876@sol.localdomain> <CAKv+Gu-A_EhMBXq_nqzBzpgN36foo6hA3Ba3=j+WVM-jph=mrw@mail.gmail.com>
 <20181022184236.GA59695@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 22 Oct 2018 19:25:27 -0300
Message-ID:
 <CAKv+Gu_vXmfNQT8j=G_Zz5C3-zDPPEQ2ne6ZZQw8mD0rifO8qA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/12] crypto: nhpoly1305 - add NHPoly1305 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181022222527.wGZZMSMMsfqvl97KMBYxlT2Y4pVXxdJsmNU2eZBJpVY@z>

On 22 October 2018 at 15:42, Eric Biggers <ebiggers@kernel.org> wrote:
> On Sat, Oct 20, 2018 at 11:06:00PM +0800, Ard Biesheuvel wrote:
>> >> > +
>> >> > +#define NH_STRIDE(K0, K1, K2, K3)                              \
>> >> > +({                                                             \
>> >> > +       m_A = get_unaligned_le32(src); src += 4;                \
>> >> > +       m_B = get_unaligned_le32(src); src += 4;                \
>> >> > +       m_C = get_unaligned_le32(src); src += 4;                \
>> >> > +       m_D = get_unaligned_le32(src); src += 4;                \
>> >> > +       K3##_A = *key++;                                        \
>> >> > +       K3##_B = *key++;                                        \
>> >> > +       K3##_C = *key++;                                        \
>> >> > +       K3##_D = *key++;                                        \
>> >> > +       sum0 += (u64)(u32)(m_A + K0##_A) * (u32)(m_C + K0##_C); \
>> >> > +       sum1 += (u64)(u32)(m_A + K1##_A) * (u32)(m_C + K1##_C); \
>> >> > +       sum2 += (u64)(u32)(m_A + K2##_A) * (u32)(m_C + K2##_C); \
>> >> > +       sum3 += (u64)(u32)(m_A + K3##_A) * (u32)(m_C + K3##_C); \
>> >> > +       sum0 += (u64)(u32)(m_B + K0##_B) * (u32)(m_D + K0##_D); \
>> >> > +       sum1 += (u64)(u32)(m_B + K1##_B) * (u32)(m_D + K1##_D); \
>> >> > +       sum2 += (u64)(u32)(m_B + K2##_B) * (u32)(m_D + K2##_D); \
>> >> > +       sum3 += (u64)(u32)(m_B + K3##_B) * (u32)(m_D + K3##_D); \
>> >> > +})
>> >> > +
>> >> > +static void nh_generic(const u32 *key, const u8 *src, size_t srclen,
>> >> > +                      __le64 hash[NH_NUM_PASSES])
>> >> > +{
>> >> > +       u64 sum0 = 0, sum1 = 0, sum2 = 0, sum3 = 0;
>> >> > +       u32 k0_A = *key++;
>> >> > +       u32 k0_B = *key++;
>> >> > +       u32 k0_C = *key++;
>> >> > +       u32 k0_D = *key++;
>> >> > +       u32 k1_A = *key++;
>> >> > +       u32 k1_B = *key++;
>> >> > +       u32 k1_C = *key++;
>> >> > +       u32 k1_D = *key++;
>> >> > +       u32 k2_A = *key++;
>> >> > +       u32 k2_B = *key++;
>> >> > +       u32 k2_C = *key++;
>> >> > +       u32 k2_D = *key++;
>> >> > +       u32 k3_A, k3_B, k3_C, k3_D;
>> >> > +       u32 m_A, m_B, m_C, m_D;
>> >> > +       size_t n = srclen / NH_MESSAGE_UNIT;
>> >> > +
>> >> > +       BUILD_BUG_ON(NH_PAIR_STRIDE != 2);
>> >> > +       BUILD_BUG_ON(NH_NUM_PASSES != 4);
>> >> > +
>> >> > +       while (n >= 4) {
>> >> > +               NH_STRIDE(k0, k1, k2, k3);
>> >> > +               NH_STRIDE(k1, k2, k3, k0);
>> >> > +               NH_STRIDE(k2, k3, k0, k1);
>> >> > +               NH_STRIDE(k3, k0, k1, k2);
>> >> > +               n -= 4;
>> >> > +       }
>> >> > +       if (n) {
>> >> > +               NH_STRIDE(k0, k1, k2, k3);
>> >> > +               if (--n) {
>> >> > +                       NH_STRIDE(k1, k2, k3, k0);
>> >> > +                       if (--n)
>> >> > +                               NH_STRIDE(k2, k3, k0, k1);
>> >> > +               }
>> >> > +       }
>> >> > +
>> >>
>> >> This all looks a bit clunky to me, with the macro, the *key++s in the
>> >> initializers and these conditionals.
>> >>
>> >> Was it written in this particular way to get GCC to optimize it in the
>> >> right way?
>> >
>> > This does get compiled into something much faster than a naive version, which
>> > you can find commented out at
>> > https://github.com/google/adiantum/blob/master/benchmark/src/nh.c#L14.
>> >
>> > Though, I admit that I haven't put a ton of effort into this C implementation of
>> > NH yet.  Right now it's actually somewhat of a translation of the NEON version.
>> > I'll do some experiments and see if it can be made into something less ugly
>> > without losing performance.
>> >
>>
>> No that's fine but please document it.
>>
>
> Hmm, I'm actually leaning towards the following instead.  Unrolling multiple
> strides to try to reduce loads of the keys doesn't seem worthwhile in the C
> implementation; for one, it bloats the code size a lot
> (412 => 2332 bytes on arm32).
>
> static void nh_generic(const u32 *key, const u8 *message, size_t message_len,
>                        __le64 hash[NH_NUM_PASSES])
> {
>         u64 sums[4] = { 0, 0, 0, 0 };
>
>         BUILD_BUG_ON(NH_PAIR_STRIDE != 2);
>         BUILD_BUG_ON(NH_NUM_PASSES != 4);
>
>         while (message_len) {
>                 u32 m0 = get_unaligned_le32(message + 0);
>                 u32 m1 = get_unaligned_le32(message + 4);
>                 u32 m2 = get_unaligned_le32(message + 8);
>                 u32 m3 = get_unaligned_le32(message + 12);
>
>                 sums[0] += (u64)(u32)(m0 + key[ 0]) * (u32)(m2 + key[ 2]);
>                 sums[1] += (u64)(u32)(m0 + key[ 4]) * (u32)(m2 + key[ 6]);
>                 sums[2] += (u64)(u32)(m0 + key[ 8]) * (u32)(m2 + key[10]);
>                 sums[3] += (u64)(u32)(m0 + key[12]) * (u32)(m2 + key[14]);
>                 sums[0] += (u64)(u32)(m1 + key[ 1]) * (u32)(m3 + key[ 3]);
>                 sums[1] += (u64)(u32)(m1 + key[ 5]) * (u32)(m3 + key[ 7]);
>                 sums[2] += (u64)(u32)(m1 + key[ 9]) * (u32)(m3 + key[11]);
>                 sums[3] += (u64)(u32)(m1 + key[13]) * (u32)(m3 + key[15]);

Are these (u32) casts really necessary? All the addends are u32 types,
so I'd expect each (x + y) subexpression to have a u32 type already as
well. Or am I missing something?

>                 key += NH_MESSAGE_UNIT / sizeof(key[0]);
>                 message += NH_MESSAGE_UNIT;
>                 message_len -= NH_MESSAGE_UNIT;
>         }
>
>         hash[0] = cpu_to_le64(sums[0]);
>         hash[1] = cpu_to_le64(sums[1]);
>         hash[2] = cpu_to_le64(sums[2]);
>         hash[3] = cpu_to_le64(sums[3]);
> }

In any case, this looks much better to me, so if the performance is
satisfactory, let's use this version.
