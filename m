Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3259C433B4
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1AEF61207
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhDQNZc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhDQNZb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 09:25:31 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E72FC061574
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:05 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b139so26273581qkc.10
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZm00Xc0p/94j6srLK1r3tkA4U5Cw6X9E6ocH2iLzlI=;
        b=CWt1fRfAKh485gQO18embcRiO4WSeHn9EhQgKBOQ5P9ntIKFLrbpsVl3Vw2Punfh6t
         /gaSBJLXqDoPzr6+GELua6LGj+syhSzbZsw6grMRstR73o86A88d6gfuLJ5lrnj6hm3n
         Sqs7O4mNMkLOreVy7Er7Hc0deqdoX7C14ewhFAbDiZUoNfRJ4VHC/1SFXcYkxvWdVjoX
         iKPdHuS0FlZ/c4CUpiIMbXJLJSvesp9n2F+rsei8b75YT7vraOWEmdm0qAGmtbGE93B1
         sNCtCKV4eORY3LscHZ6822iEcXdQD9KlFarfRYoBOyQ8yzjC1NdRnuP8kye7v5MYspUU
         75Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZm00Xc0p/94j6srLK1r3tkA4U5Cw6X9E6ocH2iLzlI=;
        b=I+sfryTfpBfqS4GQWmxCnxyX79w9bVQAGRJ5suoLt18bvdSh48gXLeIQUornxUsyvF
         Z3KvcpD4XuUUfmelZmX7AeXiiAnGHoOG1E6KqiVsMWaMU7w0vd/kQdb3Txhse7JaQiKV
         6+6jq2tn1fGXmLHAxCITcjcdriGek1tYX0gxCRIjCadWDY3/T4lwY3NzJJi9PxVcZ1jx
         WpTnnThZ0OU/21PEp95XBEWWj14RASTLUFMxPayy1VRSEb4B+GCanTMeP+S1gtPJKNXU
         GV1lAtpfcnSguiz7QFZMxAifC7A/EGW9ok8dgjWEpclXd/BofBZ0+PlNdxcrHvT+Ptq4
         n2nA==
X-Gm-Message-State: AOAM530YZAdTt5Uw4zBbUS7jE+wd2/k8I5FLRr54mTUdQ1oJ73fhB/YK
        POjkVW0vIfFlKRNS2QiLQYAzOw==
X-Google-Smtp-Source: ABdhPJzQHrRYUSGCD23lP/9i2iV3V1jvYARwoyqHLWPYfeQZ0Qyd1v2CJSiUHu8Dr2S2zwO6dy5LDw==
X-Received: by 2002:a05:620a:444f:: with SMTP id w15mr3829536qkp.437.1618665904339;
        Sat, 17 Apr 2021 06:25:04 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id o25sm1988327qtl.37.2021.04.17.06.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 06:25:03 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v2 0/7] Add support for AEAD algorithms in Qualcomm Crypto Engine driver
Date:   Sat, 17 Apr 2021 09:24:56 -0400
Message-Id: <20210417132503.1401128-1-thara.gopinath@linaro.org>
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
 drivers/crypto/qce/common.c | 198 ++++++++-
 drivers/crypto/qce/common.h |   9 +-
 drivers/crypto/qce/core.c   |   4 +
 7 files changed, 1104 insertions(+), 20 deletions(-)
 create mode 100644 drivers/crypto/qce/aead.c
 create mode 100644 drivers/crypto/qce/aead.h

-- 
2.25.1

