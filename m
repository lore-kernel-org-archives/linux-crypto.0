Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C748FC54EE9
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 08:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiIBIbh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 04:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiIBIbg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 04:31:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E079528731
        for <linux-crypto@vger.kernel.org>; Fri,  2 Sep 2022 01:31:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y1so1211980plb.2
        for <linux-crypto@vger.kernel.org>; Fri, 02 Sep 2022 01:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=yi1YlG4o+83tAAztzmlLDIzklPdbfoDcNOyPLytpFSw=;
        b=quw8J7Sl2sDi4SqsO19TKnCUNgguWkgtcEZ2nomRbLc0dNBQMMHRMTF07L5GAJS6aq
         cAkH5+dQ+Bm/uUgOBrtphAuve5Ves80za+HEpqEHiZ45N9tSWV5dd0L3//DcvxP7gwhc
         hd1qdE0IIOaTNDcXVBe3rTIC7Ots2TMKp0TS/2ebCGoTL6t0sTLUompwQKfjyP44lD2A
         bBAwWBYsvRj3Cq4AhoDY4+MT2hZSNKHCWoOMG50/bp21YZWnxSBXrjb5+QBih86b9cdi
         Dkpbm7/0PfCb7YwrjcGf1L9TCV8g4IZoH0wV1WpEnOazys3l1NCh+5LglEi4lm6MkNwU
         dLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yi1YlG4o+83tAAztzmlLDIzklPdbfoDcNOyPLytpFSw=;
        b=gRO6/L6kjyLqqQUMYkUuI78xAsZ1J+EQQ6PL2LX+VyFRLCLNq+1ArVv4wOh6LXfsla
         T93vgaVDCnrqw9Kf6jAr2jvodIHiQkXByOmajam4vUDWO7SFuFscouagC2SpD0+k59mS
         zNOeMSVkAKzETUf4eV9ju25exlVpbxjN0eheTOzC2IYi+10YxoiF+o6KAy3WeEKLBYmH
         fXXx3QNlZ482LUI62P6e+zVP3PaVMuFPnT1m8e6kL2ufrnXcJl0nwE3JrBxOvFYRNW0d
         PSP0u4vbaB4Ns6YesljZf+H5GlArzy85iZdo0Pj5Tun6NCy9Llp7fjG5GLZ61kg+cFKW
         ig5A==
X-Gm-Message-State: ACgBeo11Cqm1iYCyNNGxkRXKs6O+EvjFTp3d8t84voOLfSO7BpVMjynV
        A2Q9mg2kvA+e4dDV8Ph5W750hkynyKs=
X-Google-Smtp-Source: AA6agR7Ra5GvbJfWkSYYo3j5elDLjMszn4GpxGI2V8EgPlIxomYEa0HDD4CGWKAk4R2MRGAGrFac6A==
X-Received: by 2002:a17:903:187:b0:175:4e37:c294 with SMTP id z7-20020a170903018700b001754e37c294mr10038683plg.129.1662107494292;
        Fri, 02 Sep 2022 01:31:34 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9-20020a170903230900b001636d95fe59sm995906plh.172.2022.09.02.01.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 01:31:33 -0700 (PDT)
Message-ID: <438feee8-e529-8614-41cb-4f7bec2abcf6@gmail.com>
Date:   Fri, 2 Sep 2022 17:31:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Content-Language: en-US
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     linux-crypto@vger.kernel.org, elliott@hpe.com,
        herbert@gondor.apana.org.au, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, davem@davemloft.net, bp@alien8.de,
        x86@kernel.org, hpa@zytor.com
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
 <c6535c51-e069-ef46-3f7d-a08aecc0c957@iki.fi>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <c6535c51-e069-ef46-3f7d-a08aecc0c957@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jussi,
Thank you so much for this work!

On 9/2/22 04:51, Jussi Kivilinna wrote:
 > Hello,
 >
 > On 26.8.2022 8.31, Taehee Yoo wrote:
 >> +#define aria_sbox_8way(x0, x1, x2, x3,            \
 >> +               x4, x5, x6, x7,            \
 >> +               t0, t1, t2, t3,            \
 >> +               t4, t5, t6, t7)            \
 >> +    vpxor t0, t0, t0;                \
 >> +    vaesenclast t0, x0, x0;                \
 >> +    vaesenclast t0, x4, x4;                \
 >> +    vaesenclast t0, x1, x1;                \
 >> +    vaesenclast t0, x5, x5;                \
 >> +    vaesdeclast t0, x2, x2;                \
 >> +    vaesdeclast t0, x6, x6;                \
 >> +                            \
 >> +    /* AES inverse shift rows */            \
 >> +    vmovdqa .Linv_shift_row, t0;            \
 >> +    vmovdqa .Lshift_row, t1;            \
 >> +    vpshufb t0, x0, x0;                \
 >> +    vpshufb t0, x4, x4;                \
 >> +    vpshufb t0, x1, x1;                \
 >> +    vpshufb t0, x5, x5;                \
 >> +    vpshufb t0, x3, x3;                \
 >> +    vpshufb t0, x7, x7;                \
 >> +    vpshufb t1, x2, x2;                \
 >> +    vpshufb t1, x6, x6;                \
 >> +                            \
 >> +    vmovdqa .Linv_lo, t0;                \
 >> +    vmovdqa .Linv_hi, t1;                \
 >> +    vmovdqa .Ltf_lo_s2, t2;                \
 >> +    vmovdqa .Ltf_hi_s2, t3;                \
 >> +    vmovdqa .Ltf_lo_x2, t4;                \
 >> +    vmovdqa .Ltf_hi_x2, t5;                \
 >> +    vbroadcastss .L0f0f0f0f, t6;            \
 >> +                            \
 >> +    /* extract multiplicative inverse */        \
 >> +    filter_8bit(x1, t0, t1, t6, t7);        \
 >> +    /* affine transformation for S2 */        \
 >> +    filter_8bit(x1, t2, t3, t6, t7);        \
 >
 > Here's room for improvement. These two affine transformations
 > could be combined into single filter_8bit...
 >
 >> +    /* extract multiplicative inverse */        \
 >> +    filter_8bit(x5, t0, t1, t6, t7);        \
 >> +    /* affine transformation for S2 */        \
 >> +    filter_8bit(x5, t2, t3, t6, t7);        \
 >> +                            \
 >> +    /* affine transformation for X2 */        \
 >> +    filter_8bit(x3, t4, t5, t6, t7);        \
 >> +    vpxor t7, t7, t7;                \
 >> +    vaesenclast t7, x3, x3;                \
 >> +    /* extract multiplicative inverse */        \
 >> +    filter_8bit(x3, t0, t1, t6, t7);        \
 >> +    /* affine transformation for X2 */        \
 >> +    filter_8bit(x7, t4, t5, t6, t7);        \
 >> +    vpxor t7, t7, t7;                \
 >> +    vaesenclast t7, x7, x7;                         \
 >> +    /* extract multiplicative inverse */        \
 >> +    filter_8bit(x7, t0, t1, t6, t7);
 >
 > ... as well as these two filter_8bit could be replaced with
 > one operation if 'vaesenclast' would be changed to 'vaesdeclast'.
 >
 > With these optimizations, 'aria_sbox_8way' would look like this:
 >
 > /////////////////////////////////////////////////////////
 > #define aria_sbox_8way(x0, x1, x2, x3,            \
 >                 x4, x5, x6, x7,            \
 >                 t0, t1, t2, t3,            \
 >                 t4, t5, t6, t7)            \
 >      vpxor t7, t7, t7;                \
 >      vmovdqa .Linv_shift_row, t0;            \
 >      vmovdqa .Lshift_row, t1;            \
 >      vpbroadcastd .L0f0f0f0f, t6;            \
 >      vmovdqa .Ltf_lo__inv_aff__and__s2, t2;        \
 >      vmovdqa .Ltf_hi__inv_aff__and__s2, t3;        \
 >      vmovdqa .Ltf_lo__x2__and__fwd_aff, t4;        \
 >      vmovdqa .Ltf_hi__x2__and__fwd_aff, t5;        \
 >                              \
 >      vaesenclast t7, x0, x0;                \
 >      vaesenclast t7, x4, x4;                \
 >      vaesenclast t7, x1, x1;                \
 >      vaesenclast t7, x5, x5;                \
 >      vaesdeclast t7, x2, x2;                \
 >      vaesdeclast t7, x6, x6;                \
 >                              \
 >      /* AES inverse shift rows */            \
 >      vpshufb t0, x0, x0;                \
 >      vpshufb t0, x4, x4;                \
 >      vpshufb t0, x1, x1;                \
 >      vpshufb t0, x5, x5;                \
 >      vpshufb t1, x3, x3;                \
 >      vpshufb t1, x7, x7;                \
 >      vpshufb t1, x2, x2;                \
 >      vpshufb t1, x6, x6;                \
 >                              \
 >      /* affine transformation for S2 */        \
 >      filter_8bit(x1, t2, t3, t6, t0);        \
 >      /* affine transformation for S2 */        \
 >      filter_8bit(x5, t2, t3, t6, t0);        \
 >                              \
 >      /* affine transformation for X2 */        \
 >      filter_8bit(x3, t4, t5, t6, t0);        \
 >      /* affine transformation for X2 */        \
 >      filter_8bit(x7, t4, t5, t6, t0);        \
 >      vaesdeclast t7, x3, x3;                \
 >      vaesdeclast t7, x7, x7;
 >
 > /* AES inverse affine and S2 combined:
 >   *      1 1 0 0 0 0 0 1     x0     0
 >   *      0 1 0 0 1 0 0 0     x1     0
 >   *      1 1 0 0 1 1 1 1     x2     0
 >   *      0 1 1 0 1 0 0 1     x3     1
 >   *      0 1 0 0 1 1 0 0  *  x4  +  0
 >   *      0 1 0 1 1 0 0 0     x5     0
 >   *      0 0 0 0 0 1 0 1     x6     0
 >   *      1 1 1 0 0 1 1 1     x7     1
 >   */
 > .Ltf_lo__inv_aff__and__s2:
 >      .octa 0x92172DA81A9FA520B2370D883ABF8500
 > .Ltf_hi__inv_aff__and__s2:
 >      .octa 0x2B15FFC1AF917B45E6D8320C625CB688
 >
 > /* X2 and AES forward affine combined:
 >   *      1 0 1 1 0 0 0 1     x0     0
 >   *      0 1 1 1 1 0 1 1     x1     0
 >   *      0 0 0 1 1 0 1 0     x2     1
 >   *      0 1 0 0 0 1 0 0     x3     0
 >   *      0 0 1 1 1 0 1 1  *  x4  +  0
 >   *      0 1 0 0 1 0 0 0     x5     0
 >   *      1 1 0 1 0 0 1 1     x6     0
 >   *      0 1 0 0 1 0 1 0     x7     0
 >   */
 > .Ltf_lo__x2__and__fwd_aff:
 >      .octa 0xEFAE0544FCBD1657B8F95213ABEA4100
 > .Ltf_hi__x2__and__fwd_aff:
 >      .octa 0x3F893781E95FE1576CDA64D2BA0CB204
 > /////////////////////////////////////////////////////////
 >
 > I tested above quickly in userspace against aria-generic
 > and your original aria-avx implementation and output matches
 > to these references. In quick and dirty benchmark, function
 > execution time was ~30% faster on AMD Zen3 and ~20% faster
 > on Intel tiger-lake.

I tested your implementation.
It works very well and as you mentioned, it improves performance so much!
Before:
128bit 4096bytes: 14758 cycles
After:
128bit 4096bytes: 11972 cycles

I will apply your implementation in the v3 patch!
Thank you so much!

Taehee Yoo
