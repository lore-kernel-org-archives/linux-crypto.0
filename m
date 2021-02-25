Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F86C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A1264F21
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhBYS17 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbhBYS16 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:27:58 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6011EC061574
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:18 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id s15so4837052qtq.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3qSHutfjPy0EOhPiH6AWkm82ddTRUb/cgeNETSCNBCc=;
        b=FBYbGpWJCE+HSYVdV5pw2twtzkKMT+QzWxslw7/BhILvYCUfVXTEcQrASttmL4Z+mq
         7ZiwQDVAKnLPnM0thr9I4RyPIc0tPMpmbbS9WdaN/W5elbbolcvwnV4MI0egLeeo+LmM
         +C109WKTh6FqVHXVqWMKBWt4esqtR6BXTZGCxF3Fdem1p0vuR69kTxIwLVjJ8QPuv3UV
         xtJRl40sV3T1SkXqZKgX4dQvdTKs01zbIIl5A3v/8MWjmquEGjsvL6SE7js5wEXaXkm2
         JOr8JDtH6mdoh4CJRfjj6+wiJqaSBj/B5XoVsk3Q+DrioVDyXEi4kqQw1GBVoqX+An7k
         VuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3qSHutfjPy0EOhPiH6AWkm82ddTRUb/cgeNETSCNBCc=;
        b=kz3gH+4FdeckJUATMziKn7FvRe2NCwE0k1MxRu9T8rBFOMqagFJm4bICmmOICoBlOx
         xJDXUWBuZ8rSQ8EQFFSfp03Wq8iLPIB62VsmIlZOZJFM0bFhsWktuC4JQg30GnVBpqcn
         C8v1W0fLPvrFxNB3pb2S4BDSmrW/ly1YEMsj82pEfFiNJpdCpneQrqyDhaqYBk6J/3Hr
         2FdcMGcwIDho+puBjF3dxX6EihL2hUlopLxsDb0/VcsHvxRXuT8d7KsRKsVGVMk3/nBW
         wc2EDllbNKOGBFvFriiNfw1Yg8BxV/ismcKNT4cErGHrWDDfNj5g9iq89/uHIp77i9e4
         ziiQ==
X-Gm-Message-State: AOAM531nxLiLR115RxrFuyqJvsXqEaVRXf51WmFbIdA/p+hJmWnOjDDi
        MQB3b5GdBXf+Zk9FoWzVNfNGaw==
X-Google-Smtp-Source: ABdhPJxRRGKChcV9zwck2AHYqWey+QMaXwyT+/UEQ7Tn/44kcqcNFuStrxW14hAzlrYCKuorP/9wAw==
X-Received: by 2002:ac8:53c2:: with SMTP id c2mr3491946qtq.166.1614277637530;
        Thu, 25 Feb 2021 10:27:17 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:17 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Add support for AEAD algorithms in Qualcomm Crypto Engine driver
Date:   Thu, 25 Feb 2021 13:27:09 -0500
Message-Id: <20210225182716.1402449-1-thara.gopinath@linaro.org>
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

This series is dependant on https://lkml.org/lkml/2021/2/11/1052.

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
 drivers/crypto/qce/aead.c   | 817 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/aead.h   |  56 +++
 drivers/crypto/qce/common.c | 198 ++++++++-
 drivers/crypto/qce/common.h |   9 +-
 drivers/crypto/qce/core.c   |   4 +
 7 files changed, 1077 insertions(+), 23 deletions(-)
 create mode 100644 drivers/crypto/qce/aead.c
 create mode 100644 drivers/crypto/qce/aead.h

-- 
2.25.1

