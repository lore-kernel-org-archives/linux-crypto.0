Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4647BC3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177E2216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p9W4spdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfHUOdC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37971 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbfHUOdC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id m125so2372670wmm.3
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=kUJpizLlmm66I2Pnnp3eJ7jlYiNKdCttYY5hdsXWS1c=;
        b=p9W4spdnqcLjGzXvDCQvdK7Tv5WEFBqW4L3XIv/M7fP3l3hmUe8tj4WBVt+44ghxIi
         8/miBHY97Eyf1AUhdXZ7HkoRpELWDuPA2wNlfgefbVbtYXy7uMN+t1kypZ6RrWFH3CO+
         whV7OT4o0fVsVL7WP3AYG+5ITiYVmgPbevX8Vbzd7/nnl4TMuHeAvWhlk86MGsZ7dwuI
         0iqWG52VPNjv25kS7pFjWZXthN9PMWcbn0hH80f1Dy85bFn0gz1Vw5BFo8FEXvSH1lFb
         VjpqB0qryqBlp1fj8bcJ4sH6E7Gl53DD1OeqAhjySk6f5ApDjsYSYVqrfEXDWMvo5x/P
         KhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kUJpizLlmm66I2Pnnp3eJ7jlYiNKdCttYY5hdsXWS1c=;
        b=sLmMI6UTXiFBCGzis7OB3Hhy4BdZdTJc2CvJOS1eLDqptaSllmuDBy4z1h72jv8y5b
         0p7Zh9xxhUz7Jk08e2ikWHQdu6THGB5neE7L8GFQuvR/25ecz8sVhB8mnvptgpDugaQm
         Qwuje/eKJUpNF+Fg6Lsh5T/eP1g9+ArSiGDkfkE9gx8BjHVDFY6rpKbr16gxd/ttaIAi
         cZcjaZ4iAO/CuYtrIiGygKf+PLrRWSutoUMPYIb8vcp8VaUfqojlBwtvwx2PuX74P9JF
         wq1l87ty/RLJBMR3mvTeTVE/JDLtApZcCtT8ZQhQyZaKz80LlViG/pm8Db8GG8qlmOTU
         TzJQ==
X-Gm-Message-State: APjAAAXI1oSvFR6gMoUxJv1m6yYcQx33DNVx5Z8WZDb6bAAbbYa+ManG
        PzRwJU/sned8/8WWiGUH2EEGfSgY21nrTw==
X-Google-Smtp-Source: APXvYqyN7ZMKgFJe/Wwe7lHcIcWXdBCZg2pmruI0Gl04qnFfh3ecjSSD1ojalARff5GZlxguofdg0A==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr359364wmk.136.1566397979643;
        Wed, 21 Aug 2019 07:32:59 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:32:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 00/17] crypto: arm/aes - XTS ciphertext stealing and other updates
Date:   Wed, 21 Aug 2019 17:32:36 +0300
Message-Id: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a collection of improvements for the ARM and arm64 implementations
of the AES based skciphers.

NOTES:
- the last two patches add XTS ciphertext stealing test vectors and should
  NOT be merged until all AES-XTS implementations have been confirmed to work
- this series applies onto v13 of my ESSIV series
- tested for correctness [on both QEMU and actual hardware (via kernelci)] but
  not for performance regressions

The most important part of this series is the implementation of ciphertext
stealing support for the XTS skciphers. The CE and NEON bit slicing based
code for both ARM and arm64 is updated to handle inputs of any length >= the
XTS block size of 16 bytes.

It also updates the arm64 CTS/CBC implementation not to use a request ctx
structure, and ports the resulting implementation to ARM as well.

The remaining patches are cleanups and minor improvements in the 'ongoing
maintenance' category. None of these are -stable candidates AFAICT.

Ard Biesheuvel (16):
  crypto: arm/aes - fix round key prototypes
  crypto: arm/aes-ce - yield the SIMD unit between scatterwalk steps
  crypto: arm/aes-ce - switch to 4x interleave
  crypto: arm/aes-ce - replace tweak mask literal with composition
  crypto: arm/aes-neonbs - replace tweak mask literal with composition
  crypto: arm64/aes-neonbs - replace tweak mask literal with composition
  crypto: arm64/aes-neon - limit exposed routines if faster driver is
    enabled
  crypto: skcipher - add the ability to abort a skcipher walk
  crypto: arm64/aes-cts-cbc-ce - performance tweak
  crypto: arm64/aes-cts-cbc - move request context data to the stack
  crypto: arm64/aes - implement support for XTS ciphertext stealing
  crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS
  crypto: arm/aes-ce - implement ciphertext stealing for XTS
  crypto: arm/aes-neonbs - implement ciphertext stealing for XTS
  crypto: arm/aes-ce - implement ciphertext stealing for CBC
  crypto: testmgr - add test vectors for XTS ciphertext stealing

Pascal van Leeuwen (1):
  crypto: testmgr - Add additional AES-XTS vectors for covering CTS

 arch/arm/crypto/aes-ce-core.S       | 462 ++++++++++++++------
 arch/arm/crypto/aes-ce-glue.c       | 377 +++++++++++++---
 arch/arm/crypto/aes-neonbs-core.S   |  24 +-
 arch/arm/crypto/aes-neonbs-glue.c   |  91 +++-
 arch/arm64/crypto/aes-ce.S          |   3 +
 arch/arm64/crypto/aes-glue.c        | 299 ++++++++-----
 arch/arm64/crypto/aes-modes.S       | 107 ++++-
 arch/arm64/crypto/aes-neon.S        |   5 +
 arch/arm64/crypto/aes-neonbs-core.S |   9 +-
 arch/arm64/crypto/aes-neonbs-glue.c | 111 ++++-
 crypto/skcipher.c                   |   3 +
 crypto/testmgr.h                    | 368 ++++++++++++++++
 include/crypto/internal/skcipher.h  |   5 +
 13 files changed, 1498 insertions(+), 366 deletions(-)

-- 
2.17.1

