Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1646ECAAD5
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 09:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiIEJpW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 05:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiIEJpU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 05:45:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DFB20BD1
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 02:45:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso3216496pjd.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Sep 2022 02:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8Re8xcRsFk9zDvguQlm6i7HDCamUyOfMqzhGk2AV9PM=;
        b=aDX30cmapp+rNrzHujAnynPUpQFNdbNB6CjKXD66mPjHTidMztm3TeUOnVZkv9IU4u
         mZW07BtNkqzKo7b9r916AV7AgGFvXunzCLSBIw5FApaJAKFUaOHsLw0E56GB9AeQfxHx
         u/dn3tuvbgPbXbu6T8UK+T+dCLQWBV8y+kewT9Dg8UvvF73gmwKTSJk3EMPWo78/pmhn
         aPsZigu/5YJ0qwztsA4CnwFSTj0EPbaCkK1kntnxQUllDjxPuWsVBff8fRgbJ1ejKUka
         e/sdp6ky5zjHcNSbwNorL4ZLKcc4GGrHKqPRC2IANjNWlH6Puy7m/Ynt9R3cB4sSrXTy
         3gXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8Re8xcRsFk9zDvguQlm6i7HDCamUyOfMqzhGk2AV9PM=;
        b=cQ0d8MiA8iFwnsNOC61hpyJsuhB9nQ2jG1Z9VsgYX9CYS5uO3ErA1v/b6ocPn11Iwc
         UBujv3bw78BrtF3bt9MAkOP5PrBgxJ1WJun4UVI/bgepkehqSBQScDBOVpAIT9P6TxEy
         TFUNj/T2ohwsjFPBmdlMkKjwCUtN3pnOn+6ZQmoY2elbfHC99LVorXiWemsRI12f3dDs
         Oz/YCcJmr7dyR2BAsIkLMuz3JewLiPhUhxi9pue4Zytq8KJhojGPFzHfJMzsUlhxWnzs
         khsI8C/WP54ouGx83f5J7tY8aPpwwJPGluwfiq14Js/4roPh16B1qCeXvAsRtwJUaO0h
         zv4A==
X-Gm-Message-State: ACgBeo0+cs8OfFv7ee3v03GNex5jyvMmcIwVTHS9EfmVODYq84NFPFrk
        11VYWlpIVQn/kETSIJIse0QK/4DLSMQ=
X-Google-Smtp-Source: AA6agR5SL9MsFrxL6WXdGaYHC4p9jTbBvN3G80IbEPuTLc3Dq+Lh3u2Tni8wEmkTLJ1vJqmbwK9N9g==
X-Received: by 2002:a17:90b:350b:b0:1fd:fe88:7cdf with SMTP id ls11-20020a17090b350b00b001fdfe887cdfmr19021910pjb.236.1662371117995;
        Mon, 05 Sep 2022 02:45:17 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id b3-20020a170903228300b00176bfd3b6bdsm545617plh.132.2022.09.05.02.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 02:45:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com
Cc:     ap420073@gmail.com
Subject: [PATCH v3 0/3] crypto: aria: add ARIA AES-NI/AVX/x86_64/GFNI implementation
Date:   Mon,  5 Sep 2022 09:45:00 +0000
Message-Id: <20220905094503.25651-1-ap420073@gmail.com>
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

v3:
 - Use ECB macro instead of opencode.
 - Implement ctr(aria-avx).
 - Improve performance(20% ~ 30%) with combined affine transformation
   for S2 and X2.
   - Implemented by Jussi Kivilinna.
 - Improve performance( ~ 55%) with GFNI.
   - Implemented by Jussi Kivilinna.
 - Add ctr(aria) async speed test.
 - Add gcm(aria) multi buffer speed test
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
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 1304 +++++++++++++++++++++++
 arch/x86/crypto/aria-avx.h              |   16 +
 arch/x86/crypto/aria_aesni_avx_glue.c   |  213 ++++
 crypto/Makefile                         |    2 +-
 crypto/{aria.c => aria_generic.c}       |   39 +-
 crypto/tcrypt.c                         |   30 +
 include/crypto/aria.h                   |   17 +-
 9 files changed, 1624 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/aria-avx.h
 create mode 100644 arch/x86/crypto/aria_aesni_avx_glue.c
 rename crypto/{aria.c => aria_generic.c} (86%)

-- 
2.17.1

