Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E287C4708E
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 13:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLGN70 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 08:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLGN7L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 08:59:11 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129B25BD59
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 05:59:11 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 4so17132059pli.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2022 05:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YhThQPI2xFsZTnoYoCoKaXaVzJoWxSp/zyEv67TkbDA=;
        b=dBOI0xQ22reKS/ZVPk7RXkCMBYCu/YuWGv9EF8Dbe4A70YQKBpKPshuuBmZkjWYjBn
         RD18SDM5Dkl+Kb5HhbowrrUWSr0Djj3olv4LNVezYbBHPvwy4Z36W8mmwAm6RDztvOI4
         IEuyYMNRqCJA4v3871AMzQGKwf0jmMSbHKid7c2+gVlrLHKOqMmVDOHtgpRnI3PmniLM
         y8JkXXfJcNXWoKuqswvp+1hhfvyp121ljLrtN7aOSQuHjmoPrAy4vczGGa9L3/GiUBSm
         IzlGxDfVhSZfK+wkNQ2h9oJ1EHJEdBkq8oa2lfspvffdAily0nDnhEZ83RiSBf/mDVUq
         MEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YhThQPI2xFsZTnoYoCoKaXaVzJoWxSp/zyEv67TkbDA=;
        b=pJFj/1i4o4hJtrmQI09pgcCSWr4UedjsfKCYLlz+rpxwQv3M+sCAU+cGZmPFSXaLYI
         nXTzcnx3knSeoXxf77Yiyw55NRybCywp7HI7VPbIZZTZnnCo+ToOoq8F7zAPBmIRHJHK
         Fcf58Orz/Ghhu/9e4qDL7lXma627eV8/4tJrPDycC8HSUR+U9QOHTsqZwFluBqkgydhF
         u4Z/JuwjNYrF1/uWOWaEoVw4xQefmjF9vPAez55dXtlvdFvpNL4KM2Y4wBO28fCYNIrJ
         SDrG1fCLb55vAIOx86/UpSV1OKFtfZgLGHe+vBCJfVxB7ns8Hs0zRMC5uCnRM5AnnXYF
         04tg==
X-Gm-Message-State: ANoB5plbm2RWQre7qIGUOGMqDi+IEbRp31DA2Yy2zJOLDMu8SD/K7gpR
        yFihCw5OltjaFB1xMNUlPhPfqVUsnyERuQ==
X-Google-Smtp-Source: AA0mqf61ceznxcTzeMeDu4TiHzvJLcf/uaq0sn0FZ05tIa9mK2hnjVHf3oOyDPB28d2EZkY2zjfaFw==
X-Received: by 2002:a17:902:b414:b0:186:7a6b:dcdb with SMTP id x20-20020a170902b41400b001867a6bdcdbmr634011plr.40.1670421549725;
        Wed, 07 Dec 2022 05:59:09 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001885041d7b8sm14554619pln.293.2022.12.07.05.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:59:08 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org,
        ap420073@gmail.com
Subject: [PATCH v7 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Wed,  7 Dec 2022 13:58:51 +0000
Message-Id: <20221207135855.459181-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset is to implement aria-avx2 and aria-avx512.
There are some differences between aria-avx, aria-avx2, and aria-avx512,
but they are not core logic(s-box, diffusion layer).

ARIA-AVX2
It supports 32way parallel processing using 256bit registers.
Like ARIA-AVX, it supports both AES-NI based s-box layer algorithm and
GFNI based s-box layer algorithm.
These algorithms are the same as ARIA-AVX except that AES-NI doesn't
support 256bit registers, so it is used twice.

ARIA-AVX512
It supports 64way parallel processing using 512bit registers.
It supports only GFNI based s-box layer algorithm.

Benchmarks with i3-12100
commands: modprobe tcrypt mode=610 num_mb=8192

ARIA-AVX512(128bit and 256bit)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx512) encryption
tcrypt: 1 operation in 1504 cycles (1024 bytes)
tcrypt: 1 operation in 4595 cycles (4096 bytes)
tcrypt: 1 operation in 1763 cycles (1024 bytes)
tcrypt: 1 operation in 5540 cycles (4096 bytes)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx512) decryption
tcrypt: 1 operation in 1502 cycles (1024 bytes)
tcrypt: 1 operation in 4615 cycles (4096 bytes)
tcrypt: 1 operation in 1759 cycles (1024 bytes)
tcrypt: 1 operation in 5554 cycles (4096 bytes)

ARIA-AVX2 with GFNI(128bit and 256bit)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx2) encryption
tcrypt: 1 operation in 2003 cycles (1024 bytes)
tcrypt: 1 operation in 5867 cycles (4096 bytes)
tcrypt: 1 operation in 2358 cycles (1024 bytes)
tcrypt: 1 operation in 7295 cycles (4096 bytes)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx2) decryption
tcrypt: 1 operation in 2004 cycles (1024 bytes)
tcrypt: 1 operation in 5956 cycles (4096 bytes)
tcrypt: 1 operation in 2409 cycles (1024 bytes)
tcrypt: 1 operation in 7564 cycles (4096 bytes)

ARIA-AVX with GFNI(128bit and 256bit)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx) encryption
tcrypt: 1 operation in 2761 cycles (1024 bytes)
tcrypt: 1 operation in 9390 cycles (4096 bytes)
tcrypt: 1 operation in 3401 cycles (1024 bytes)
tcrypt: 1 operation in 11876 cycles (4096 bytes)
    testing speed of multibuffer ecb(aria) (ecb-aria-avx) decryption
tcrypt: 1 operation in 2735 cycles (1024 bytes)
tcrypt: 1 operation in 9424 cycles (4096 bytes)
tcrypt: 1 operation in 3369 cycles (1024 bytes)
tcrypt: 1 operation in 11954 cycles (4096 bytes)

This patchset will not successfully be merged before applying CFI fixes
because of conflict.

v7:
 - Use IS_ENABLED() instead of defined()

v6:
 - Rebase for "CFI fixes" patchset.
 - Use SYM_TYPED_FUNC_START instead of SYM_FUNC_START.

v5:
 - Set CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE flag to avx2, and avx512.

v4:
 - Use keystream array in the request ctx.

v3:
 - Use ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds defines.

v2:
 - Add new "add keystream array into struct aria_ctx" patch.
 - Use keystream array in the aria_ctx instead of stack memory

Taehee Yoo (4):
  crypto: aria: add keystream array into request ctx
  crypto: aria: do not use magic number offsets of aria_ctx
  crypto: aria: implement aria-avx2
  crypto: aria: implement aria-avx512

 arch/x86/crypto/Kconfig                   |   38 +
 arch/x86/crypto/Makefile                  |    6 +
 arch/x86/crypto/aria-aesni-avx-asm_64.S   |   26 +-
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1433 +++++++++++++++++++++
 arch/x86/crypto/aria-avx.h                |   46 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1020 +++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  252 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |   45 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  250 ++++
 arch/x86/kernel/asm-offsets.c             |    9 +
 crypto/aria_generic.c                     |    4 +
 11 files changed, 3101 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.34.1

