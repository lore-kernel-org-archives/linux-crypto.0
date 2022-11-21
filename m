Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EE0C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 00:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKUAkP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Nov 2022 19:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKUAkN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Nov 2022 19:40:13 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D514C13E9F
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2022 16:40:12 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id z26so9928038pff.1
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2022 16:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pt8U+WwqmsHmlbi216xEiRB34ItYsjwaDCzX8zEA1k4=;
        b=dZadhSsaabY0d4DcH3LJ+XcvVF+peecf5piMYb3Cci1hOF2NMBUHXO5GYa+ZkTeB68
         oecv8joS8SS8NuhgRIlbRnqAfIT6Lk6opEH/UUT2kPAU+j/DAssLngh2TcHT5yO2vP5j
         tbFEXqaw1x/NB5VsRmMl0l7M/YE8ADZNPtVKgGTYD/oPhy4EZYK6PbnNbOfL7nXOPKFD
         4uKM6lNed7/cz06KHfAmS+o+FaQQ87HytsnuP6FkiteERL44PgY4BY0Ip/7VfIo+A3jl
         vFL1pX2M18e5IWOwYkVBCrxqsuZ5f6Zme9X7RSPYJ2LB4RCTD/rK/Cmq4Z6Xf/KVUrS1
         6V0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pt8U+WwqmsHmlbi216xEiRB34ItYsjwaDCzX8zEA1k4=;
        b=Aw8REqVA4CeBKd8+d8UzUaKtDwPLzEMStXs4IMEGch9jOUk4Sm+C5HxDGaPSCQ/Jys
         DUogDLNKQ27Xictz0sbZLg+T8EERoHf8lLc/K+URBN6A9f+/xkehSowW2bd113GoYQV2
         PIAHtx/flgt3Cbi9w99BSoNlBbNltVj/agfoBP2AokvwcttEBcz1d4NbRWH5aeyI0Y34
         EdObxC1+GYRu3VU6nySm3OPcrycikoJWyojDkmswNgafhT1rhAEeejb44NC5rzldae3n
         23E9oO7BeeGMW6lABkxKcFzEd4RsUlN10x3v8ts9wDLGsdsp0ahseo1DHdFl/Aa5FLgV
         SoUw==
X-Gm-Message-State: ANoB5plNHkkvYvNGtOjjAqVO91ONLxL64+fYjCGeL7252r3mMc7DzbIt
        V3JhvENEFbM3r535d9xC32aA8S/8QSc=
X-Google-Smtp-Source: AA0mqf5PdEAoJLSg/QktBlzNQ16sqIYiAavmEmkeWWvWp4R2lRskGWlIV9zifNbSNfzA9vseyJNIfw==
X-Received: by 2002:a63:2160:0:b0:46f:f26e:e8ba with SMTP id s32-20020a632160000000b0046ff26ee8bamr16063071pgm.250.1668991212156;
        Sun, 20 Nov 2022 16:40:12 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902680d00b001837b19ebb8sm8075682plk.244.2022.11.20.16.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 16:40:11 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        ebiggers@kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v6 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Mon, 21 Nov 2022 00:39:51 +0000
Message-Id: <20221121003955.2214462-1-ap420073@gmail.com>
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

v6:
 - Rebase for "CFI fixes" patchset.
   https://lore.kernel.org/linux-crypto/20221118194421.160414-1-ebiggers@kernel.org/T/#t
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
 arch/x86/kernel/asm-offsets.c             |   11 +
 crypto/aria_generic.c                     |    4 +
 11 files changed, 3103 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.34.1

