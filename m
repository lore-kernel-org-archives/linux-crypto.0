Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC981ECAAD5
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 09:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiIBJj4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 05:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiIBJjy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 05:39:54 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64662A180
        for <linux-crypto@vger.kernel.org>; Fri,  2 Sep 2022 02:39:52 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y141so1348567pfb.7
        for <linux-crypto@vger.kernel.org>; Fri, 02 Sep 2022 02:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4BA4Lo44EqNBE+4wiJGOiKMF6xnQ9xiv4AiOgP6lKlA=;
        b=iOJ+cTNtP5hiyipkrHNFfczN5RHYqgwhIoaIo3yiggL7I5YTWRIqbxM6TOi2wz+vk2
         TVfCue1si63D/Pk/gnIkJq7toO21tBlSKvnHMCbpCOhjZIOa8if1RZWGTKGuo1sqs1Xb
         gD+QaTpK2D8CBZQFhNBmpjbkKo2YaNmmQ3lk+3mTf07J7HPD96Oa6v6ETgvJVMvUXBuw
         0PhAU0xMIadeFdQd9yylzH+AjHWuNtDQGYgrhwcdCxFvcO8lMPoTt9IgIylfLvCTP2Ts
         oNtFs9tyJ5vjeKs5uCcYHcx6mRwb11EfN9fmIJx4y/cFBT9LGdI9Bb/xfQqQiEaBrR0b
         XQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4BA4Lo44EqNBE+4wiJGOiKMF6xnQ9xiv4AiOgP6lKlA=;
        b=PTIfnQGXHJ9JT/XXJ6jJJDqfBjfGBc6MOcu2kmQGctQNd1jVTtbWdtBhMBrTHOxGoQ
         FHuuKtgLBTylVA8HebY4rQ76+T8NGu0/iVLgE+TpAbTsAvQlOkbgdC4fVm/1b+xcb4Bn
         FVLuc/MLvXt13OQuQHxg+ShQGr6XPfyf048Z0gz6jnbKSfTNEEylge+unbFojaBLLTLQ
         OMtvqm52AmvNa3a9dgC9EO3lIR+X3RIETLobszvxgQ9bRlOoZAMBw5RJNpg5+dt9Hedk
         7LVjemYNSEmXOb+leNuwxLkkO+CPHpoW7TFRAG6375nhz18COYNkRPw77qj+KU3Hp5G/
         KV0w==
X-Gm-Message-State: ACgBeo379mTDJ5HqqJQdWE0nY2iF1bQqGV7skhmmaXTHo8NF1Pv5aYGt
        aET4pxdb09jkve5QeogQ70X3jndTUF0=
X-Google-Smtp-Source: AA6agR7ARcbVhU8sdKHufleOQFudKC6bFPs+ZM8jhz81rVonlBboGbDnnPsLwTZnuspjsRa8qJerUQ==
X-Received: by 2002:a62:5ac6:0:b0:537:f0fa:4ae1 with SMTP id o189-20020a625ac6000000b00537f0fa4ae1mr29727109pfb.70.1662111591748;
        Fri, 02 Sep 2022 02:39:51 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902d2c700b0017515e598c5sm1171980plc.40.2022.09.02.02.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 02:39:50 -0700 (PDT)
Message-ID: <9557c406-a3af-6b20-5933-b61fd759ca70@gmail.com>
Date:   Fri, 2 Sep 2022 18:39:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/3] crypto: aria: add ARIA AES-NI/AVX/x86_64
 implementation
Content-Language: en-US
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     elliott@hpe.com, hpa@zytor.com, x86@kernel.org,
        davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, bp@alien8.de,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
References: <20220826053131.24792-1-ap420073@gmail.com>
 <afef1c3a-9a72-9006-da95-d63ec5aece5c@iki.fi>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <afef1c3a-9a72-9006-da95-d63ec5aece5c@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jussi,
Thank you so much for this great work!

On 9/2/22 05:09, Jussi Kivilinna wrote:
 > Hello,
 >
 > On 26.8.2022 8.31, Taehee Yoo wrote:
 >> The purpose of this patchset is to support the implementation of
 >> ARIA-AVX.
 >> Many of the ideas in this implementation are from Camellia-avx,
 >> especially byte slicing.
 >> Like Camellia, ARIA also uses a 16way strategy.
 >>
 >> ARIA cipher algorithm is similar to AES.
 >> There are four s-boxes in the ARIA spec and the first and second s-boxes
 >> are the same as AES's s-boxes.
 >> Almost functions are based on aria-generic code except for s-box related
 >> function.
 >> The aria-avx doesn't implement the key expanding function.
 >> it only support encrypt() and decrypt().
 >>
 >> Encryption and Decryption logic is actually the same but it should use
 >> separated keys(encryption key and decryption key).
 >> En/Decryption steps are like below:
 >> 1. Add-Round-Key
 >> 2. S-box.
 >> 3. Diffusion Layer.
 >>
 >> There is no special thing in the Add-Round-Key step.
 >>
 >> There are some notable things in s-box step.
 >> Like Camellia, it doesn't use a lookup table, instead, it uses aes-ni.
 >>
 >> To calculate the first s-box, it just uses the aesenclast and then
 >> inverts shift_row. No more process is needed for this job because the
 >> first s-box is the same as the AES encryption s-box.
 >>
 >> To calculate a second s-box(invert of s1), it just uses the aesdeclast
 >> and then inverts shift_row. No more process is needed for this job
 >> because the second s-box is the same as the AES decryption s-box.
 >>
 >> To calculate a third and fourth s-boxes, it uses the aesenclast,
 >> then inverts shift_row, and affine transformation.
 >>
 >> The aria-generic implementation is based on a 32-bit implementation,
 >> not an 8-bit implementation.
 >> The aria-avx Diffusion Layer implementation is based on aria-generic
 >> implementation because 8-bit implementation is not fit for parallel
 >> implementation but 32-bit is fit for this.
 >>
 >> The first patch in this series is to export functions for aria-avx.
 >> The aria-avx uses existing functions in the aria-generic code.
 >> The second patch is to implement aria-avx.
 >> The last patch is to add async test for aria.
 >>
 >> Benchmarks:
 >> The tcrypt is used.
 >> cpu: i3-12100
 >
 > This CPU also supports Galois Field New Instructions (GFNI) which are
 > even better suited for accelerating ciphers that use same building
 > blocks as AES. For example, I've recently implemented camellia using
 > GFNI for libgcrypt [1].
 >
 > I quickly hacked GFNI to your implementation and it gives nice extra
 > bit of performance (~55% faster on Intel tiger-lake). Here's GFNI
 > version of 'aria_sbox_8way', that I used:
 >
 > /////////////////////////////////////////////////////////
 > #define aria_sbox_8way(x0, x1, x2, x3,                  \
 >                         x4, x5, x6, x7,                  \
 >                         t0, t1, t2, t3,                  \
 >                         t4, t5, t6, t7)                  \
 >          vpbroadcastq .Ltf_s2_bitmatrix, t0;             \
 >          vpbroadcastq .Ltf_inv_bitmatrix, t1;            \
 >          vpbroadcastq .Ltf_id_bitmatrix, t2;             \
 >          vpbroadcastq .Ltf_aff_bitmatrix, t3;            \
 >          vpbroadcastq .Ltf_x2_bitmatrix, t4;             \
 >          vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;   \
 >          vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;   \
 >          vgf2p8affineqb $(tf_inv_const), t1, x2, x2;     \
 >          vgf2p8affineqb $(tf_inv_const), t1, x6, x6;     \
 >          vgf2p8affineinvqb $0, t2, x2, x2;               \
 >          vgf2p8affineinvqb $0, t2, x6, x6;               \
 >          vgf2p8affineinvqb $(tf_aff_const), t3, x0, x0;  \
 >          vgf2p8affineinvqb $(tf_aff_const), t3, x4, x4;  \
 >          vgf2p8affineqb $(tf_x2_const), t4, x3, x3;      \
 >          vgf2p8affineqb $(tf_x2_const), t4, x7, x7;      \
 >          vgf2p8affineinvqb $0, t2, x3, x3;               \
 >          vgf2p8affineinvqb $0, t2, x7, x7;
 >
 > #define BV8(a0,a1,a2,a3,a4,a5,a6,a7) \
 >          ( (((a0) & 1) << 0) | \
 >            (((a1) & 1) << 1) | \
 >            (((a2) & 1) << 2) | \
 >            (((a3) & 1) << 3) | \
 >            (((a4) & 1) << 4) | \
 >            (((a5) & 1) << 5) | \
 >            (((a6) & 1) << 6) | \
 >            (((a7) & 1) << 7) )
 >
 > #define BM8X8(l0,l1,l2,l3,l4,l5,l6,l7) \
 >          ( ((l7) << (0 * 8)) | \
 >            ((l6) << (1 * 8)) | \
 >            ((l5) << (2 * 8)) | \
 >            ((l4) << (3 * 8)) | \
 >            ((l3) << (4 * 8)) | \
 >            ((l2) << (5 * 8)) | \
 >            ((l1) << (6 * 8)) | \
 >            ((l0) << (7 * 8)) )
 >
 > /* AES affine: */
 > #define tf_aff_const BV8(1, 1, 0, 0, 0, 1, 1, 0)
 > .Ltf_aff_bitmatrix:
 >          .quad BM8X8(BV8(1, 0, 0, 0, 1, 1, 1, 1),
 >                      BV8(1, 1, 0, 0, 0, 1, 1, 1),
 >                      BV8(1, 1, 1, 0, 0, 0, 1, 1),
 >                      BV8(1, 1, 1, 1, 0, 0, 0, 1),
 >                      BV8(1, 1, 1, 1, 1, 0, 0, 0),
 >                      BV8(0, 1, 1, 1, 1, 1, 0, 0),
 >                      BV8(0, 0, 1, 1, 1, 1, 1, 0),
 >                      BV8(0, 0, 0, 1, 1, 1, 1, 1))
 >
 > /* AES inverse affine: */
 > #define tf_inv_const BV8(1, 0, 1, 0, 0, 0, 0, 0)
 > .Ltf_inv_bitmatrix:
 >          .quad BM8X8(BV8(0, 0, 1, 0, 0, 1, 0, 1),
 >                      BV8(1, 0, 0, 1, 0, 0, 1, 0),
 >                      BV8(0, 1, 0, 0, 1, 0, 0, 1),
 >                      BV8(1, 0, 1, 0, 0, 1, 0, 0),
 >                      BV8(0, 1, 0, 1, 0, 0, 1, 0),
 >                      BV8(0, 0, 1, 0, 1, 0, 0, 1),
 >                      BV8(1, 0, 0, 1, 0, 1, 0, 0),
 >                      BV8(0, 1, 0, 0, 1, 0, 1, 0))
 >
 > /* S2: */
 > #define tf_s2_const BV8(0, 1, 0, 0, 0, 1, 1, 1)
 > .Ltf_s2_bitmatrix:
 >          .quad BM8X8(BV8(0, 1, 0, 1, 0, 1, 1, 1),
 >                      BV8(0, 0, 1, 1, 1, 1, 1, 1),
 >                      BV8(1, 1, 1, 0, 1, 1, 0, 1),
 >                      BV8(1, 1, 0, 0, 0, 0, 1, 1),
 >                      BV8(0, 1, 0, 0, 0, 0, 1, 1),
 >                      BV8(1, 1, 0, 0, 1, 1, 1, 0),
 >                      BV8(0, 1, 1, 0, 0, 0, 1, 1),
 >                      BV8(1, 1, 1, 1, 0, 1, 1, 0))
 >
 > /* X2: */
 > #define tf_x2_const BV8(0, 0, 1, 1, 0, 1, 0, 0)
 > .Ltf_x2_bitmatrix:
 >          .quad BM8X8(BV8(0, 0, 0, 1, 1, 0, 0, 0),
 >                      BV8(0, 0, 1, 0, 0, 1, 1, 0),
 >                      BV8(0, 0, 0, 0, 1, 0, 1, 0),
 >                      BV8(1, 1, 1, 0, 0, 0, 1, 1),
 >                      BV8(1, 1, 1, 0, 1, 1, 0, 0),
 >                      BV8(0, 1, 1, 0, 1, 0, 1, 1),
 >                      BV8(1, 0, 1, 1, 1, 1, 0, 1),
 >                      BV8(1, 0, 0, 1, 0, 0, 1, 1))
 >
 > /* Identity matrix: */
 > .Ltf_id_bitmatrix:
 >          .quad BM8X8(BV8(1, 0, 0, 0, 0, 0, 0, 0),
 >                      BV8(0, 1, 0, 0, 0, 0, 0, 0),
 >                      BV8(0, 0, 1, 0, 0, 0, 0, 0),
 >                      BV8(0, 0, 0, 1, 0, 0, 0, 0),
 >                      BV8(0, 0, 0, 0, 1, 0, 0, 0),
 >                      BV8(0, 0, 0, 0, 0, 1, 0, 0),
 >                      BV8(0, 0, 0, 0, 0, 0, 1, 0),
 >                      BV8(0, 0, 0, 0, 0, 0, 0, 1))
 > /////////////////////////////////////////////////////////
 >
 > GFNI also allows easy use of 256-bit vector registers so
 > there is way to get additional 2x speed increase (but
 > requires doubling number of parallel processed blocks).
 >

I checked that my i3-12100 supports GFNI.
Then, benchmarked this implementation.
It works very well and it shows amazing performance!
Before:
128bit, 4096 bytes: 14758 cycles
After:
128bit, 4096 bytes: 9404 cycles

I think I must add this implementation to the v3 patch.
Like your code[1], I also will add a condition on whether CPU supports 
GFNI or not.
This will be very helpful to the AVX2 and AVX-512 implementation too.
I think AVX2 implementation will use 256-bit vector register.
So, as you mentioned, its potential performance increment is also great.

Thank you so much again for your great work!

Taehee Yoo

[1]
https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=blob;f=cipher/camellia-aesni-avx2-amd64.h#l80 


 > -Jussi
 >
 > [1]
 > 
https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=blob;f=cipher/camellia-aesni-avx2-amd64.h#l80 

 >
