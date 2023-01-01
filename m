Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAF9C4167B
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Jan 2023 09:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjAAJNI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Jan 2023 04:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjAAJNH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Jan 2023 04:13:07 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1E15F7B
        for <linux-crypto@vger.kernel.org>; Sun,  1 Jan 2023 01:13:06 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 124so17032586pfy.0
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jan 2023 01:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Is4k+gx3KJfrIFoJwvzCiaGbFwIyqTDsgClxLrk5UJQ=;
        b=NlFz9NcxV1wINEXt3iDPnKE/6hDLG0FDx/TtqC0Ms4cy7s+enWHjESCev76+j2a5GH
         pmcW68VgTXRmsZYTgLF1S0uRSl6UQQQ9vXPOwPW8P0dvBt61a51BTZvXTV3mjP4GF9op
         WtT7qHLZo9oas9v+45aMnLf8PMAM0ZigwAaQMlaUMjKGxtnFLKoAo+GBfUD+sCw9nR/F
         08dje3tOMh0wwT8aMaXpe5XSkHeb5rhxY2JFXpTZ8vA6idOxjsJcbduX/x/9obpw037N
         oFMlaRZRXr4YQiMHMtDaqiMAmwaZkxaKKdgsUQKf2s47rT1KYhkKWUEuWC9P9dj4Qaly
         wB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Is4k+gx3KJfrIFoJwvzCiaGbFwIyqTDsgClxLrk5UJQ=;
        b=rAm1afFk37yUTcQPRI9O8qt/SvN0XWjMcBm5DcLafFbEW5WnvV+uBmVXO5tiwsc+lK
         cUoYZkU8zzOBRTQfSSn/REKVo4KOc/zi/H3Z5B0CNDbX1gbsg2w4R6cn7MUoCNjUW/Rv
         I5t2zaHMfTg5OVhBNU2M6dcY/r4gw4G/3WwD4UvjxIkjqs3ScqkdDHVJGvuVHwg9+fB7
         Gb+oQVWfVry/LddZAws9hW3AjFjhV7bk5q6bpq33sgPHCVIaI3V0e9UVX46bVu1k7nti
         NeTwE14JWK9MX24KQUEQe2QTgWANnCabwns1OHUXZD2BUGejlXTKnUJcMhooYNQ8RP9w
         mcsA==
X-Gm-Message-State: AFqh2ko2qKkFPOXynLcDe04nOY0ITs25YzNwbNyVgYJFJ7eFDgL+5348
        sg0N+zzKwamZawf1RGocoTYyUvCOuUrFuA==
X-Google-Smtp-Source: AMrXdXuRoiHgjg90iXYPtfdF9zeFr8V7j26sB9E99kGWWj7JXL9t7TcDjpsGoYuyLRCDS/kpi8P3xw==
X-Received: by 2002:aa7:8a42:0:b0:582:34f2:20f1 with SMTP id n2-20020aa78a42000000b0058234f220f1mr4377436pfa.11.1672564384878;
        Sun, 01 Jan 2023 01:13:04 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k26-20020aa79d1a000000b0058130f1eca1sm10951327pfp.182.2023.01.01.01.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 01:13:03 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org,
        ap420073@gmail.com
Subject: [PATCH v8 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Sun,  1 Jan 2023 09:12:48 +0000
Message-Id: <20230101091252.700117-1-ap420073@gmail.com>
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

v8:
 - Remove unnecessary code in aria-gfni-avx512-asm_64.S
 - Do not use magic numbers in the aria-avx.h
 - Rebase

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
 arch/x86/crypto/aria-avx.h                |   48 +-
 arch/x86/crypto/aria-gfni-avx512-asm_64.S |  971 ++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  252 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |   45 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  250 ++++
 arch/x86/kernel/asm-offsets.c             |    8 +
 crypto/aria_generic.c                     |    4 +
 11 files changed, 3052 insertions(+), 29 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.34.1

