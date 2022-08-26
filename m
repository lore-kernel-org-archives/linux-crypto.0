Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F6FECAAD2
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 05:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244727AbiHZFbv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 01:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHZFbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 01:31:48 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C8BCD789
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p9-20020a17090a2d8900b001fb86ec43aaso568370pjd.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc;
        bh=yS3SaFTHZqn8OOn8upgBndffY9XZLHGw4+nzTLBesmw=;
        b=DSKxCRCcngcSPzTL32XsWXFr/cvsVOmVo866/5XctB0+PSf0di3SM1lmmEkkHhCi3O
         VOSiS8YnhZ7+g5wVG1028pyJB+Pjr9NBp6CvZmXrA7odF4XeV3INH5IyvLXIsU5ag6b/
         tW45l6/u8JoxtKYYX2s28DzzVzjbGIUgx5AkcKK39qDeZscekNJz3D8dqvWoP6V74x9l
         SktkU7A/Z489H8QkXCUt85Wr1xVOTVYaNOseekzuUoxKMfLUWBf364bP4CcbzCuwV0Ls
         Ct/A/xX6J5EBv8Ix58ZXzJyzryOXDHBqdTUoxz4uzf5iYLsx9LP7QZ4T7uoaf1n4SWxA
         YGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yS3SaFTHZqn8OOn8upgBndffY9XZLHGw4+nzTLBesmw=;
        b=iXqzPp4vEYuV7DKc7kRJZpw6EJjSg0fuTt0k3neX9gmvracVDhpVPgG9UhrxbKmBfT
         YTMGoKOdJpDHpjuCtSWa8whQnj8U3JWBlgZofTUrNHF2KM7GQ+cKSv45etftIwtWwK9K
         oMd8enSg2eq1iDVHnKdT/CtID1YHL5J0SKSKJ+G21fa+n8ATaYxDbjRW/ozlspZpeEY9
         cocfM6M/P96XKkqjXTt7gngpmTnd6JsHMWWBstaYe/Dh0fCCDptqDPEjVROAWMOxFWjd
         UHBG8oGYBdP0dquq0mHePdAj34OBtKj9HrrhxLEc444+VjGQYp5l9shXR0ekMMlS4EHe
         QI0g==
X-Gm-Message-State: ACgBeo2C586n/5xuYonnqlM1/5KZESPrXs/JMHvuHPydeOW2znNNcIgN
        7vtEKIQEUm4MfxAkA3Y3c0Gg2umbN6w=
X-Google-Smtp-Source: AA6agR4xG/HvktyYTwe5EvMqP4x1Xn3JX9IEG5EDhajZkx8Zb/iJWypmINjr3w3E5gQDXlys9RGkkQ==
X-Received: by 2002:a17:90b:3b8a:b0:1f5:1df2:1fff with SMTP id pc10-20020a17090b3b8a00b001f51df21fffmr2572279pjb.169.1661491907025;
        Thu, 25 Aug 2022 22:31:47 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b00172925f3c79sm545726pla.153.2022.08.25.22.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 22:31:46 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     elliott@hpe.com, ap420073@gmail.com
Subject: [PATCH v2 0/3] crypto: aria: add ARIA AES-NI/AVX/x86_64 implementation
Date:   Fri, 26 Aug 2022 05:31:28 +0000
Message-Id: <20220826053131.24792-1-ap420073@gmail.com>
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
it only support encrypt() and decrypt().

Encryption and Decryption logic is actually the same but it should use
separated keys(encryption key and decryption key).
En/Decryption steps are like below:
1. Add-Round-Key
2. S-box.
3. Diffusion Layer.

There is no special thing in the Add-Round-Key step.

There are some notable things in s-box step.
Like Camellia, it doesn't use a lookup table, instead, it uses aes-ni.

To calculate the first s-box, it just uses the aesenclast and then
inverts shift_row. No more process is needed for this job because the
first s-box is the same as the AES encryption s-box.

To calculate a second s-box(invert of s1), it just uses the aesdeclast
and then inverts shift_row. No more process is needed for this job
because the second s-box is the same as the AES decryption s-box.

To calculate a third and fourth s-boxes, it uses the aesenclast,
then inverts shift_row, and affine transformation.

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

Result:
    testing speed of multibuffer ecb(aria) (ecb-aria-avx) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 727 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2040 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 1399 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 14758 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 702 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2615 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 1677 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 19454 cycles
    testing speed of multibuffer ecb(aria) (ecb-aria-avx) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 638 cycles
test 2 (128 bit key, 128 byte blocks): 1 operation in 2090 cycles
test 3 (128 bit key, 256 byte blocks): 1 operation in 1394 cycles
test 6 (128 bit key, 4096 byte blocks): 1 operation in 14824 cycles
test 7 (256 bit key, 16 byte blocks): 1 operation in 719 cycles
test 9 (256 bit key, 128 byte blocks): 1 operation in 2633 cycles
test 10 (256 bit key, 256 byte blocks): 1 operation in 1684 cycles
test 13 (256 bit key, 4096 byte blocks): 1 operation in 19457 cycles

v2:
 - Do not call non-FPU functions(aria_{encrypt | decrypt}() in the 
   FPU context.
 - Do not acquire FPU context for too long.

Taehee Yoo (3):
  crypto: aria: prepare generic module for optimized implementations
  crypto: aria-avx: add AES-NI/AVX/x86_64 assembler implementation of
    aria cipher
  crypto: tcrypt: add async speed test for aria cipher

 arch/x86/crypto/Makefile                |   3 +
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 648 ++++++++++++++++++++++++
 arch/x86/crypto/aria_aesni_avx_glue.c   | 165 ++++++
 crypto/Kconfig                          |  21 +
 crypto/Makefile                         |   2 +-
 crypto/{aria.c => aria_generic.c}       |  39 +-
 crypto/tcrypt.c                         |  13 +
 include/crypto/aria.h                   |  14 +-
 8 files changed, 889 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx_glue.c
 rename crypto/{aria.c => aria_generic.c} (86%)

-- 
2.17.1

