Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C579C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 07:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiKRHXf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 02:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKRHXe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 02:23:34 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82D42F60
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 23:23:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so4290469pjk.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 23:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QsiGD5dxN/FVlYil00aRdPEvKDeQZZlt8nbcnBd6oXY=;
        b=lkafJjCzEA5HXfFK89tg09yccsbYofrXML5yb5QFaIn8d5JTYcIrGkcerCmRJLeXjA
         TNZy+N5jVQC5E+srVXQAO9OSdMGsCgcVbujFV2jXa8ruiwLMeGdWdGzBxxQjdZ2O9bkE
         NgOJw//sMYk3kQt110z9EF1RijReO8fQ17f5rB4ZmvgrT1t5r3F/Dan94IaUesn9GwTj
         dPob4VR+qaoHoGVc3BwGH49X+eH6yG05ko29hYO8mIaojAgLvFCMKBzuoKbXQ8FferAP
         8t8xSUfO3AG/B0ysnSQ6MP+cNZSPBJ0hdvDQokBDt/n1KtAFuzRuyPIod81ve+gEauw6
         G/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QsiGD5dxN/FVlYil00aRdPEvKDeQZZlt8nbcnBd6oXY=;
        b=mQEvBRjBNY8617R+Lhbsvsfk4oiS8QxWX3B+U5rYGo7UazvI0ikJzYHYvkCk6EcJUX
         Gp5i14mO1wfCxiHND5muvL3tL1eeIw+yFSRl3mmVl/eKdbmSmWUnkKMSlu7HuNKZJ+hO
         XGYIBKkkY/DNFi8Q9RkeBVxIxl2wcuDne/72AIkx+iP/Dxl0qQMiW8WdOXJ1qGIow2RS
         UQSdd3iVm9hY+8yDQNgwQ6aWo+qG1CXpt0ewaR3RpwM7WDUOuuCfcsz9Uwod7pvGbt+p
         IlY/GmdB/5HfSFR/3VIopgnP8XDhK/V+36PupSM6ElUQ7L6Yiek+1ZF4xlVQ9h9T0Xlv
         v85g==
X-Gm-Message-State: ANoB5pmuBz5E5cnbj+kdoSx8OsJlXnP2ESU0XCp4AZcXo8MtMnspsnUA
        hrksjm1+xzCb00vgr4S9Idl4nsyE/AY=
X-Google-Smtp-Source: AA0mqf5/M+VXdD3DxOFIVHqKj66cEXJfcV7vJlUaAVjQb35IoMksclYhyMze3uP7EjTGwG7Ifi9PVA==
X-Received: by 2002:a17:902:7105:b0:188:f6d4:ec28 with SMTP id a5-20020a170902710500b00188f6d4ec28mr4219971pll.47.1668756212199;
        Thu, 17 Nov 2022 23:23:32 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id ix9-20020a170902f80900b001782a0d3eeasm2734228plb.115.2022.11.17.23.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 23:23:31 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v5 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Fri, 18 Nov 2022 07:22:48 +0000
Message-Id: <20221118072252.10770-1-ap420073@gmail.com>
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
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1432 +++++++++++++++++++++
 arch/x86/crypto/aria-avx.h                |   46 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1019 +++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  252 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |   45 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  250 ++++
 arch/x86/kernel/asm-offsets.c             |   11 +
 crypto/aria_generic.c                     |    4 +
 11 files changed, 3101 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.17.1

