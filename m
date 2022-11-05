Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9C5C433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 08:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiKEIUs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 04:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKEIUr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 04:20:47 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F02A2B62E
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 01:20:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 130so6415061pfu.8
        for <linux-crypto@vger.kernel.org>; Sat, 05 Nov 2022 01:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICks72csurPnJ+E5KWMZ5ZkMWEWLuj14VXM7AGH3dcw=;
        b=JpFN944P8Mu5s7hAXUqPKUztUEumeyhA0jW7O4MxJfasddt3r/jERIWpZR9yLqTE3y
         ZNtK+LgpzlaE+apIWvG+l93ojhBjksfWihYugGGRgLN5ZrzFF3BMfkJGUB2P5+b1q1Qp
         jPDXRNTB3vzSvgXG6K8OenGV/cEdXf6m03OfcRpRBAqoKgE/TM4diC7z8Kc2gRHpMWUg
         dfzGZgPmb+qlXPwukMMepfqEcPREl0l+26ZOXzDZJ/m8hqc9XvsNATi4cVvZebaEQ7AH
         BbqsgUtuZ6TUCC30Cul5QQhkI3f4zEpNq8V2yV9XOJHxOw9sX5SCyJ926itPUR/wFebm
         8+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICks72csurPnJ+E5KWMZ5ZkMWEWLuj14VXM7AGH3dcw=;
        b=peOQQl5f5Oc4sP+uKmET2Kr7LhekAszFR+zV+cmJYUB6zpdp5+/9ID2YS3g8G9HbFV
         Am3TZLmDbvAyKe7ty1OuaSDRzs/XM7UGqrB/cvY4KfYNMvz6fsO3uCXi57FOc7s9move
         eSijR/lHqzjPo3QuSD2Mg5JoZTpfckb6GuiQVUDVXEQqj0j8dNml9gdG8weEHOHPybd3
         nUloPCTJRBRQPGDBAiCJew5eYivBUTUsWSfY4GORkpqlzeUPuIckF3NcArXd0aDLh9UV
         aIK1KO6+bNWuhEZYhfglfxAJnKYjTnhFLFdAu320xvslGycgymSoPdRUgg3SrDCeS8QL
         w6tg==
X-Gm-Message-State: ACrzQf1TvFaBEhjjv/31dqWlsnrsr1HbVrI+yF+BgdBpsS35VezZVWhA
        LDpfYI4i8bLeLNdEruLOdh/4l3+iVybSfIdA
X-Google-Smtp-Source: AMsMyM5SbIpJZX4RSaUhqI9B3pHORAfAQwkwZyI8+lMj4b4QlFyWTlO5cvcIU1BjgqIKhnQGJJ4qIg==
X-Received: by 2002:a63:e158:0:b0:464:8d6:8b91 with SMTP id h24-20020a63e158000000b0046408d68b91mr33021614pgk.124.1667636445854;
        Sat, 05 Nov 2022 01:20:45 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id pv7-20020a17090b3c8700b00213c7cf21c0sm837648pjb.5.2022.11.05.01.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 01:20:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v2 0/3] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Sat,  5 Nov 2022 08:20:18 +0000
Message-Id: <20221105082021.17997-1-ap420073@gmail.com>
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

v2:
 - Add new "add keystream array into struct aria_ctx" patch.
 - Use keystream array in the aria_ctx instead of stack memory

Taehee Yoo (3):
  crypto: aria: add keystream array into struct aria_ctx
  crypto: aria: implement aria-avx2
  crypto: aria: implement aria-avx512

 arch/x86/crypto/Kconfig                   |   38 +
 arch/x86/crypto/Makefile                  |    6 +
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1436 +++++++++++++++++++++
 arch/x86/crypto/aria-avx.h                |   41 +-
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1023 +++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  236 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |   30 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  232 ++++
 include/crypto/aria.h                     |   24 +
 9 files changed, 3051 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.17.1

