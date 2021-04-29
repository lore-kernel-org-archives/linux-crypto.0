Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198DBC433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA3261447
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhD2PIC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240450AbhD2PH4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 11:07:56 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976D9C06138B
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:09 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id u20so35292623qku.10
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJriSY/3BoO1fHsVgHab2OGWTgIWKz/XuakYolqJtHg=;
        b=P43IVnbOO1KOh0wwx2LKjHbidBxkD+RQyNaMv1TLiF6K5NcRwSd9UeIE4ozLi05/9r
         mt0LXt3WDcvq3LGkC8/zgqAuFvF3+C3Mrgn/IwXMteNul6/BWKRDrLTozu1aeBROuj43
         lp+cgQvjJSBIuFWdAo7jQbUOxMKR/yXUNabsNZj//ghJ0lyo6actzWuwEOnbFPpvULVb
         mVvn1n3VHcBWRuhDr1AouhWJkNfu3zGSjVmo68gc9T2//tKjxIUJrLK++yo38Z868Sur
         Zo7uhaUXm1bEhnmpepCjYuul3SU4Hj+6W7VKGuVJxBRncm+0xhQHByjqJpT5q6JIxH9j
         1Vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJriSY/3BoO1fHsVgHab2OGWTgIWKz/XuakYolqJtHg=;
        b=ik57uwdEjQeNIjHkQOLM6m4t+WkK2vEIJXidi1KbkTesM8/kPmurCAPizYf2oRLbWA
         8nF3AktO1RAJl/zx0uV+oNcDsC2r/qTosMfFNJA6JVnhvn+ekxgLSX/b/GKC+G3wIYCF
         x8fC5LwxXEJ9q7vnpU+vYmtnxn0UEYKqtG0hAtgJyQqv7G4hLGW+Zf/CCZ6f1tjRf7/s
         5g7IzqI1l5IWQvqrkN6EWNStIs0T8hWdFgS1YEGFu6YaqJGNMQj0gPxH7Yt2wGbU3i5o
         X0CtWd77GNk9mcYzpz7qllgRtJkf0lF/kko26KItw5g7X2FjlC01uwySTl/d0cz/iDYK
         fKnw==
X-Gm-Message-State: AOAM532niwGSvDqPkqKoI84FQ2kVXtJiMwvuUNs6QZUjrDJCGiu29ffC
        ldPKkafs4RaQCiDnJNnkJGjpCg==
X-Google-Smtp-Source: ABdhPJw6BVL6oIwP9QDnk+MHuqu75/I+KE0MpjMGALVikb4wE3xysyeuazVjIkJ9H4vT8A58dMBXow==
X-Received: by 2002:a37:4c4:: with SMTP id 187mr87385qke.163.1619708828855;
        Thu, 29 Apr 2021 08:07:08 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id j191sm2223822qke.131.2021.04.29.08.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:07:08 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v4 0/7] Add support for AEAD algorithms in Qualcomm Crypto Engine driver
Date:   Thu, 29 Apr 2021 11:07:00 -0400
Message-Id: <20210429150707.3168383-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable support for AEAD algorithms in Qualcomm CE driver.  The first three
patches in this series are cleanups and add a few missing pieces required
to add support for AEAD algorithms.  Patch 4 introduces supported AEAD
transformations on Qualcomm CE.  Patches 5 and 6 implements the h/w
infrastructure needed to enable and run the AEAD transformations on
Qualcomm CE.  Patch 7 adds support to queue fallback algorithms in case of
unsupported special inputs.

This patch series has been tested with in kernel crypto testing module
tcrypt.ko with fuzz tests enabled as well.

Thara Gopinath (7):
  crypto: qce: common: Add MAC failed error checking
  crypto: qce: common: Make result dump optional
  crypto: qce: Add mode for rfc4309
  crypto: qce: Add support for AEAD algorithms
  crypto: qce: common: Clean up qce_auth_cfg
  crypto: qce: common: Add support for AEAD algorithms
  crypto: qce: aead: Schedule fallback algorithm

 drivers/crypto/Kconfig      |  15 +
 drivers/crypto/qce/Makefile |   1 +
 drivers/crypto/qce/aead.c   | 841 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/aead.h   |  56 +++
 drivers/crypto/qce/common.c | 196 ++++++++-
 drivers/crypto/qce/common.h |   9 +-
 drivers/crypto/qce/core.c   |   4 +
 7 files changed, 1102 insertions(+), 20 deletions(-)
 create mode 100644 drivers/crypto/qce/aead.c
 create mode 100644 drivers/crypto/qce/aead.h

-- 
2.25.1

