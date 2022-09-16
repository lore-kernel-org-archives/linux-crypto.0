Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968B5ECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 12:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiIPM6G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiIPM6C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 08:58:02 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC2A8709E
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:57:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p18so21353574plr.8
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=cSxbhHveCgV8MNDCtrTvYyVWenp7pRcZjprkjGjhMj8=;
        b=TVmwgHXRgIw4R/IjVuBVGydB0faZk4R2cX1AJaEeEbxZoRh7KdxZTX1iuXOavHNwfA
         heufdWF07oJKSxNT+pXwYvqT/fNCzWxJnnZV9go76XyMR7N5lZ2YhlN2N5vtF8oSwXVP
         9jtQc7SFUByiTDeEHrkdrHkuXqKGU8kCCtHuINCKQErnTbOJBBZmoJAT4GCZgKK+6is2
         CWXG6Hqe/02DyRILSxiegunjnO5awHS9n4mBm8jhogicd4U2KSehWP/uvza28A8+9Qlf
         vMg7+TsxUAv9i1x2bvtcvr0XCyWNewUdknFbjU+Qa/bdKEC0MEzF5Sj/sVAPMK9E4DdF
         9/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cSxbhHveCgV8MNDCtrTvYyVWenp7pRcZjprkjGjhMj8=;
        b=kiPGepp9li7qRBFlFsYokmdev5QP4TwNHFIBspOx3mTEuunk4LX9Kwdc3hqn2KcJuJ
         T3tZcWDgn9s7eHlWshnOxuMqMO8/kh7xl9haA6aqDoDVz4dTMCy1ilpfnEmPFHujCa3T
         AmaseDY6oG8SmT9YTl2LmeWNm1gDSUm9ecyEjota2mzGawRjjwa3ajpz/vmKy0NRpcFM
         diHTXbp+EGMXqLYuJjw4y099wiI9cyXymiRTZ/+u9wrCQk6T4P2jlNl4Ev3Xz0oh5o0o
         3ORF/tYga6MrDjKI+0c6wj+5NV+BYlo/M6L+1fL7YYUJ6Grikrq5pHxjbZWSwXTRxWPl
         X/Mw==
X-Gm-Message-State: ACrzQf3LamVLz2HajLKaUX1WmSsMwHYagxWuWJXc9pylSmOPHAhWXHGj
        q86fKg4Cn1IOUk1KiYcUIsLilKKQgx8=
X-Google-Smtp-Source: AMsMyM7BIkgegSp/KTv0kYpi3AcL/2bONfxq1kZXWWjhMnlItLFsBMNqnvO150U/WgoUNU5vxhMwaw==
X-Received: by 2002:a17:902:f641:b0:172:9642:1bf1 with SMTP id m1-20020a170902f64100b0017296421bf1mr4753839plg.36.1663333075168;
        Fri, 16 Sep 2022 05:57:55 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id f20-20020a170902f39400b0017829a3df46sm11941062ple.204.2022.09.16.05.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:57:54 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com,
        peterz@infradead.org
Cc:     ap420073@gmail.com
Subject: [PATCH v4 0/3] crypto: aria: add ARIA AES-NI/AVX/x86_64/GFNI implementation
Date:   Fri, 16 Sep 2022 12:57:33 +0000
Message-Id: <20220916125736.23598-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The purpose of this patchset is to support the implementation of ARIA-AVX.
Many of the ideas in this implementation are from Camellia-avx,
especially byte slicing.
Like Camellia, ARIA also uses a 16way strategy.

ARIA cipher algorithm is similar to AES.
There are four s-boxes in the ARIA spec and the first and second s-boxes
are the same as AES's s-boxes.
Almost functions are based on aria-generic code except for s-box related
function.
The aria-avx doesn't implement the key expanding function.
it supports only encrypt() and decrypt().

Encryption and Decryption are actually the same but it should use
separated keys(encryption key and decryption key).
En/Decryption steps are like below:
1. Add-Round-Key
2. S-box.
3. Diffusion Layer.

There is no special thing in the Add-Round-Key step.

There are some notable things in s-box step.
Like Camellia, it doesn't use a lookup table, instead, it uses AES-NI.
There are 2 implementations for that.
One is to use AES-NI and affine transformation, which is the same as
Camellia, sm4, and others.
Another is to use GFNI.
GFNI implementation is faster than AES-NI implementation.
So, it uses GFNI implementation if the running CPU supports GFNI.

To calculate the first s-box(S1), it just uses the aesenclast and then
inverts shift_row. No more process is needed for this job because the
first s-box is the same as the AES encryption s-box.

To calculate the second s-box(X1, invert of S1), it just uses the
aesdeclast and then inverts shift_row. No more process is needed
for this job because the second s-box is the same as the AES
decryption s-box.

To calculate the third s-box(S2), it uses the aesenclast,
then affine transformation, which is combined AES inverse affine and
ARIA S2.

To calculate the last s-box(X2, invert of S2), it uses the aesdeclast,
then affine transformation, which is combined X2 and AES forward affine.

The optimized third and last s-box logic and GFNI s-box logic are
implemented by Jussi Kivilinna.

The aria-generic implementation is based on a 32-bit implementation,
not an 8-bit implementation.
The aria-avx Diffusion Layer implementation is based on aria-generic
implementation because 8-bit implementation is not fit for parallel
implementation but 32-bit is fit for this.

The first patch in this series is to export functions for aria-avx.
The aria-avx uses existing functions in the aria-generic code.
The second patch is to implement aria-avx.
The last patch is to add async test for aria.

Benchmarks:
The tcrypt is used.
cpu: i3-12100

How to test:
   modprobe aria-generic
   tcrypt mode=610 num_mb=8192

Result:
    testing speed of multibuffer ecb(aria) (ecb(aria-generic)) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 534 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2006 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 3674 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 52374 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 608 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2586 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 4707 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 69794 cycles

    testing speed of multibuffer ecb(aria) (ecb(aria-generic)) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 545 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 1995 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 3673 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 52359 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 615 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2588 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 4712 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 69916 cycles

How to test:
   modprobe aria
   tcrypt mode=610 num_mb=8192

AVX with AES-NI:
    testing speed of multibuffer ecb(aria) (ecb-aria-avx) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 629 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2060 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 1223 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 11931 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 686 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2616 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 1439 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 15488 cycles

    testing speed of multibuffer ecb(aria) (ecb-aria-avx) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 609 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2027 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 1211 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 12040 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 684 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2614 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 1445 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 15478 cycles

AVX with GFNI:
    testing speed of multibuffer ecb(aria) (ecb-aria-avx) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 730 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2056 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 1028 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 9223 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 685 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2603 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 1179 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 11728 cycles

    testing speed of multibuffer ecb(aria) (ecb-aria-avx) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 617 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2057 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 1020 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 9280 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 687 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2599 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 1176 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 11909 cycles

v4:
 - Fix sparse warning.
 - Remove .align statement for .text
   - https://lkml.kernel.org/r/20220915111144.248229966@infradead.org 

v3:
 - Use ECB macro instead of opencode.
 - Implement ctr(aria-avx).
 - Improve performance(20% ~ 30%) with combined affine transformation
   for S2 and X2.
   - Implemented by Jussi Kivilinna.
 - Improve performance( ~ 55%) with GFNI.
   - Implemented by Jussi Kivilinna.
 - Add aria-ctr async speed test.
 - Add aria-gcm multi buffer speed test
 - Rebase and fix Kconfig

v2:
 - Do not call non-FPU functions(aria_{encrypt | decrypt}()) in the
   FPU context.
 - Do not acquire FPU context for too long.

Taehee Yoo (3):
  crypto: aria: prepare generic module for optimized implementations
  crypto: aria-avx: add AES-NI/AVX/x86_64/GFNI assembler implementation
    of aria cipher
  crypto: tcrypt: add async speed test for aria cipher

 arch/x86/crypto/Kconfig                 |   18 +
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 1303 +++++++++++++++++++++++
 arch/x86/crypto/aria-avx.h              |   16 +
 arch/x86/crypto/aria_aesni_avx_glue.c   |  213 ++++
 crypto/Makefile                         |    2 +-
 crypto/{aria.c => aria_generic.c}       |   39 +-
 crypto/tcrypt.c                         |   30 +
 include/crypto/aria.h                   |   17 +-
 9 files changed, 1623 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/aria-avx.h
 create mode 100644 arch/x86/crypto/aria_aesni_avx_glue.c
 rename crypto/{aria.c => aria_generic.c} (86%)

-- 
2.17.1

