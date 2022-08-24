Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F420C32796
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 15:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiHXP7N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiHXP7M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 11:59:12 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48697CB77
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 08:59:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u22so16023124plq.12
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 08:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc;
        bh=2XM0vhvs5q/s2S654KAU02uD3fJjzxLaMAnECVEfqh8=;
        b=YjMT1aOb6ImMg1QI9cFZHG8AbxrkRHyjucjFbJh/vmhELbCPruNSLBCQQGGCAq5CUF
         0bg4scVnYSs7IpG4pBFki/UuQh24r90h8Jk1K/pPrhC05n6PqNHgSgaVtciVHxCdOv7m
         bjSSsfr4luXDECS78Egq5sBVjSOjUr7KlfAkOfCtaZUR43P8gLeLAllBlNFeYTZrOhGH
         XhL0ghMXxzOdCHK16fJB86u27W1TcU4w1DIwaIluAMd6B0W/P6k9/TvdWWzthdsKxakq
         rP/pPLUmwXoBGaGYdjFZ+c8KYf4eXAiJi0sDAlYvjDx3ssveun4InyghEVLt2ATk7UOZ
         62jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2XM0vhvs5q/s2S654KAU02uD3fJjzxLaMAnECVEfqh8=;
        b=OpdtmKfQGIgKLtpVBd7W71reKjEQo3jYSSakPTJv1cAfyqHtb9JmrnQ6AINPBYuj4X
         u5uYT44gQ4GpSwwfHPRhFeoEwDC8WJ4Y3yasZ1ZzvTtFiPyfujYEEjjZU1qHkHL+661c
         up7PVo9UReHaNMbt8/TShJCwZZyInhXMwM94D6R0o+aFht++IiRSd4DfQaOMFd+7SiUM
         0M/cP/uKpzN7BhulhOvQPmxF+gtsRpp2L4qKtA/BCEDBojtzrTBgXHe+yRTJF7J9W+Zr
         ymxlSufho/d9Vpifc60TAvgHWRDnqW2tvIULYy2K9hlXpXL4NGGO6LWT4j1YXKpuZbID
         pLTw==
X-Gm-Message-State: ACgBeo0SmAvgWySXkX9FNbZ+c09zYBnvC5yCbprB4snALqLE8RA6vvJi
        a/rajcC6pP7ic2nTXN2sNCtScIfXP+M=
X-Google-Smtp-Source: AA6agR5Ymk6pPVj2ttmgarI/miRajI7fzrjRxTarKLQ1+lNZPAfkJs5oO3edfrJdsC4xvU0yuVqD/A==
X-Received: by 2002:a17:902:8643:b0:172:e067:d7ac with SMTP id y3-20020a170902864300b00172e067d7acmr16572251plt.164.1661356747934;
        Wed, 24 Aug 2022 08:59:07 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a034c00b001fb438fb772sm1540318pjf.56.2022.08.24.08.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:59:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     ap420073@gmail.com
Subject: [PATCH 0/3] crypto: aria: add ARIA AES-NI/AVX/x86_64 implementation
Date:   Wed, 24 Aug 2022 15:58:49 +0000
Message-Id: <20220824155852.12671-1-ap420073@gmail.com>
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

