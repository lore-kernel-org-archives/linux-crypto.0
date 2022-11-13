Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0981C4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Nov 2022 16:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbiKMQ5A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 11:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbiKMQ47 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 11:56:59 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75C711C0A
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 08:56:58 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b21so8089127plc.9
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 08:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjuGd06Gi/2sCGIi3FZ+MvKMB5ya8yG/fDJ4CRRpoGE=;
        b=TOolrUjN9TguGygIq0uUUT50Y1DhNBPkZN56CY+ZNonm7BYBhJ5P+j2ed6gH8KPfUn
         bJ/IEso+OdkcKmk7uq8d4g0tyv4wpb2eYV/qETW8DEkVZa6JJDi4Ox1FbGlHy3jiddpr
         d0a9NZMuCJ/BshPZfrUaAyrNlQ7hUmQv3FG1w3McEWTlH4tUxMBG272LYeEbFhb8t+t4
         NR9ucKb8WfriekGNRLXYpJXKxybrGLlS4h9SbcvOvLOAE5dyPTGbpn5rXKKP7KxCr56z
         JIn4BPXbC9op/qYH4GGErMVa8VcAt2krGzyeFe4ROJGB9efiD/da3ruO9mZUQpnHghg2
         ti/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjuGd06Gi/2sCGIi3FZ+MvKMB5ya8yG/fDJ4CRRpoGE=;
        b=CHyeJHua0q85xE3/CSB3jufZ1knB2Bux3QkirR+yDm2rzUGLa1mH7OYOTRJ3raiLju
         9QYO/8XjvSDnh/6GEgPLZG9WMFO8RJZxntKYiRQvgzeR+GGS9URWmS5g8rMIYnaoKl+a
         tLn+AsMtHjRqh0V/beRPSQFgLkU0HdRVFAFC4Pm8127HD1DP4hFFzDyrRejAY/e4LaTm
         NQLI3jL7Q/drLWgK+hQif55wVN3TNTgF1e1YDc47+ywNzu9ViT8W2JuPxurAC7cN1cu6
         nw7NyE2UG2BmYU7jYqWfXUNHi1ujg39A8V3eUuISP1YKd5MuEe4iXbsnmHbRJydhNbJQ
         +hGg==
X-Gm-Message-State: ANoB5pmAmwabhuG5B4Q1K4vAw1lMF0g7bENy8WYxgVTiK7i6TIuglq24
        Tc7fAYIHSY2WNKONV1q0ZYqZpPfYx4oTKw==
X-Google-Smtp-Source: AA0mqf7xDxpai9HinxGAdIAdw4JWtT2TuAdNAQfuuiVdJ4dcL8HrVxjIfbQihs3ScMp3XyOXVCA83A==
X-Received: by 2002:a17:90b:103:b0:213:5a4d:8138 with SMTP id p3-20020a17090b010300b002135a4d8138mr10431267pjz.17.1668358617939;
        Sun, 13 Nov 2022 08:56:57 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id qi18-20020a17090b275200b001f8c532b93dsm4910477pjb.15.2022.11.13.08.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:56:57 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v4 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Sun, 13 Nov 2022 16:56:41 +0000
Message-Id: <20221113165645.4652-1-ap420073@gmail.com>
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

v4:
 - Use keystream array in the request ctx

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
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1432 +++++++++++++++++++++
 arch/x86/crypto/aria-avx.h                |   46 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1019 +++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  251 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |   45 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  249 ++++
 arch/x86/kernel/asm-offsets.c             |   11 +
 crypto/aria_generic.c                     |    4 +
 11 files changed, 3099 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.17.1

