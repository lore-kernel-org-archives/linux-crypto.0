Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D349C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 05:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiJZFWj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 01:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiJZFWj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 01:22:39 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09B2B0B07
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 22:22:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p3so12062326pld.10
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 22:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2AWZBE84PI7ARl0hgJNRPVmC7BCiIPk2wi6a0nWgpfk=;
        b=Q13vSPw49P3NxDgquo6xASxJQ7Sz/idKZYLephhb0lCsGeJMbdcEfb/FpeTc96wN6M
         RLD7/IpDMFjbwduLlcHS9K6/d6uYP1GlibiCNWkL6Og+h0XD8VqIY67y+FSsWrFMbYMx
         ST3UBTxspEl6Qy/gLYAOntJyftd4Qp5fzIXKNbUeumETy+su4zs+uTTGl7f1+H+ljsqb
         iwFiT5QoQzFh6rclhbM08D2BWmEDim4h2IvOt3/WzJC08kDgLkuLnkSoCOJLP8T8qhLR
         AObkzTC5BRqMjV6mh5XEG65OxsSetqzi/wb9SLLxos+TE/D0SagmEvd/biK3p+3aUUSS
         Weiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2AWZBE84PI7ARl0hgJNRPVmC7BCiIPk2wi6a0nWgpfk=;
        b=FEqjlNvGxjEytw75uKWYDFIPatiBYBQ5+Jj7yZj6MvKgQpzZqv2/izCGabWAgpTVxJ
         rrlU547ER1Jfr85CWNe2KuzekyQZOpeEx0VeQr8n+hVy/J1H0ZZOkUBeT0PFehJtEwtL
         nXm9r/DBoW5XuBcqV2oIxor7EnM+7iLfVmd//RKgfnMfnLKrI96KV/f8MzZDKMaR61Je
         EsxOUTvMadwr/zF4t6bfgroreBvi8yEg6Y0JJ1oBGklkJi43+YtSlU1AA1CjDG/KUK06
         DrHCsRRoQQKq0kff1ilWxjasgEaTS2yIKHewu8SVH21O47uB8526KHus/Lg2DjThKEn5
         KQXg==
X-Gm-Message-State: ACrzQf2J5zM++E5dcGakrVGi+f66qV4Ok3j71Wycd8hTPpisFA7PGfpA
        htqNVlVQVwPVZkVSpyTc16zhrHyAnPxKDw==
X-Google-Smtp-Source: AMsMyM5lTY2iviu46yCF93imcYMLvUoc0dcSvHdDJdXUxpzDVvv+nt5Rwi3fnJJNIp2pUD2oDSAbhQ==
X-Received: by 2002:a17:902:7296:b0:180:1330:b3c0 with SMTP id d22-20020a170902729600b001801330b3c0mr41315442pll.170.1666761756770;
        Tue, 25 Oct 2022 22:22:36 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id s5-20020a656445000000b00462ae17a1c4sm2119254pgv.33.2022.10.25.22.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 22:22:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH 0/2] crypto: aria: implement aria-avx2 and aria-avx512
Date:   Wed, 26 Oct 2022 05:20:55 +0000
Message-Id: <20221026052057.12688-1-ap420073@gmail.com>
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

Taehee Yoo (2):
  crypto: aria: implement aria-avx2
  crypto: aria: implement aria-avx512

 arch/x86/crypto/Kconfig                   |   38 +
 arch/x86/crypto/Makefile                  |    6 +
 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 1436 +++++++++++++++++++++
 arch/x86/crypto/aria-avx.h                |   45 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 1023 +++++++++++++++
 arch/x86/crypto/aria_aesni_avx2_glue.c    |  240 ++++
 arch/x86/crypto/aria_aesni_avx_glue.c     |    6 +
 arch/x86/crypto/aria_gfni_avx512_glue.c   |  236 ++++
 8 files changed, 3030 insertions(+)
 create mode 100644 arch/x86/crypto/aria-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/aria-gfni-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/aria_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/aria_gfni_avx512_glue.c

-- 
2.17.1

