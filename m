Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A288C4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 14:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKFOhm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 09:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiKFOhl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 09:37:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA98DEB8
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 06:37:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 4so8991753pli.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Nov 2022 06:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wNxCSGpYtc+UynGtWraZm3CyyjI4HiR4ahTJTEodmI=;
        b=DGYx7QnaztFK1tq/eTHUjDo9EDJ1h4L1o1VSkxbkjfXVns91IU3ukjsayNqZ3MW2gx
         03yEjGSrbJCWaj+zrxMvZv59cbX3I3ABN7rN3hUVhNxISUNfJj1eMbM528fo4vq801Is
         z0d/MF7rxhlq5MBBTN2cPVMpCKsiw4GBYQuZ7I5h65pf/1/cLE6d3mdFursOZSZbilNT
         jVA/bDrg5yuQuOD48Og0C2jGztUwuPyRtDCsliQEofxSVeZMgvFFxEFVyKNJR25hmU6o
         KJedxaKX2eaA6NNoEklJ7CGPCnKHGlnVmxIAm3FjtFJSnWQBabP6rVZ6uSVEFjQXiReM
         rwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0wNxCSGpYtc+UynGtWraZm3CyyjI4HiR4ahTJTEodmI=;
        b=e0Y2bpDQ26zvC/Vv9p9OB91p0OOyCFrUXKQxhjw/IBWWQtxprHpCE4LoRQ55mfuLnq
         /xy6I8Qv4tL+98muiV7KXgxWKfF/E7OWSa2E5kRD9nagcVwnzqth4t0M96wJcjdatUku
         kXEBPTXsU8+OQn4zNg/GD6OnHEi4/tNTUKGJ59we+mlhzx/yUFS5rniklzlw0pEn8qM+
         gi/3auv4PrSMDZklpP/NRMrXGKsA32RFNp/3NVAXKjGga0k/EUCoeqSpvRtrsRGKHbgv
         EkuYAuZw0UIeDhhJG0BBNnl5utLXBjSP170sWX4lnTR9+KCx6ucNL8sYTcex+sVyryaB
         iHtg==
X-Gm-Message-State: ACrzQf0xXaTBPEZU6TNm/3E3k5vA12AoQukNp8Ux2NryVdmASf26Vf9C
        +7p5lr0GWuWGmQR7o0163fEw+weBCgLFEQbt
X-Google-Smtp-Source: AMsMyM75eJShcwwTWOsy6wNhQv8mmHa8fSch7Is5FgS06zYg2+zPcDnn8OqY5P/eGDvZZ83gTusJCg==
X-Received: by 2002:a17:903:1245:b0:178:9234:3768 with SMTP id u5-20020a170903124500b0017892343768mr46111066plh.146.1667745458766;
        Sun, 06 Nov 2022 06:37:38 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7973a000000b0056da2ad6503sm2696580pfg.39.2022.11.06.06.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 06:37:38 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v3 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Sun,  6 Nov 2022 14:36:23 +0000
Message-Id: <20221106143627.30920-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
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

v3:
 - Use ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds defines.

v2:
 - Add new "add keystream array into struct aria_ctx" patch.
 - Use keystream array in the aria_ctx instead of stack memory

Taehee Yoo (4):
  crypto: aria: add keystream array into struct aria_ctx
  crypto: aria: do not use magic number offsets of aria_ctx
  crypto: aria: implement aria-avx2
  crypto: aria: implement aria-avx512

 arch/x86/crypto/Kconfig                   |   38 +
 arch/x86/crypto/Makefile                  |    6 +
 arch/x86/crypto/aria-aesni-avx-asm_64.S   |   26 +-
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1432 +++++++++++++++++++++
 arch/x86/crypto/aria-avx.h                |   41 +-
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1019 +++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  236 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |   30 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  232 ++++
 arch/x86/kernel/asm-offsets.c             |   11 +
 include/crypto/aria.h                     |   24 +
 11 files changed, 3065 insertions(+), 30 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.17.1

