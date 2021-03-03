Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137CCC15505
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF2164F4F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345736AbhCDAHX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243813AbhCCOhu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 09:37:50 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E7EC0611C3
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 06:35:02 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d11so23926000wrj.7
        for <linux-crypto@vger.kernel.org>; Wed, 03 Mar 2021 06:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39xrqSAYtv9KigkLBZKC9OTmCVVdo8yE25LRar3D2UY=;
        b=VQ9cM0oqM57huxiYVr2jgosLOhPO9LZ+aUzWHCnyELnzuNJn++8bWgghXseyRujsgc
         01JhEPHgIBgtGAEwYWVUTeFpryv+93wmNSS+tzfx5qhafhHKCKiTq1GcxWvFfkx9HW91
         7qYb61R0W7QdwJc6MJdsdi7EEvPys8CNJldPhsNcFQlW4g8p0Crk6yoklRII1X8yAJWO
         7a6RYhPoj/BNeqB/f808qaWhFuXzohjNhQCOTjpj8JOK7xRmjjZCd/nA1rziRAnmLbN6
         Rud3vtd23PwrlJdo9BerAR6ywTb/1c0bQRZU1Oayfx3tWT1UoKMIfGYnGxfj7+I/aJfC
         Cgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39xrqSAYtv9KigkLBZKC9OTmCVVdo8yE25LRar3D2UY=;
        b=jj7hk07LzkFDtlzhQq06CpqMdM0g2I0HGalZEf2YM9yZxuwklSYMjTBMBgOa6GREBK
         ZTAdjFrdFiZ9Y1vQLhL/8uq0mMOk1ZwHuCnoFUsHxtngl5tlG6PYujhF1LeuhLWsaUeu
         cT1e0n4WWZ2BCe/p506JwhOoH9BTEt3Rz35pT+frHqqHJ3UEXwUnYxcf4myVe7siTs7O
         +J1US/+W/jlncLCgtL3bRZ7pwRQCLCOtxXC1KNoqRVnTCJwbLCWecINOe7MgpuorZDMI
         1TIzShV/QQGC9tvCHtVHodLNIj403vJUINhgLCEu38z8P4lfhuE+nAQzzVyHSyfP3BNP
         wjJg==
X-Gm-Message-State: AOAM5305lO3kHAZg9JrHL/wDwlwKI9RiNvO+YMvDQqcXeFwATp1CaDrt
        /K90e+z9V3DVBek6Xm3OZJtc7w==
X-Google-Smtp-Source: ABdhPJx1eC43WGjYA+6qeGM+76LvmKklSB3nEuuGd2pnyVyjR7a7a2cUzDgM2/CtDZacja2KcBmgrQ==
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr26973841wrt.426.1614782101662;
        Wed, 03 Mar 2021 06:35:01 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f16sm31475923wrt.21.2021.03.03.06.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:35:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 05/10] crypto: keembay: ocs-hcu: Fix incorrectly named functions/structs
Date:   Wed,  3 Mar 2021 14:34:44 +0000
Message-Id: <20210303143449.3170813-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303143449.3170813-1-lee.jones@linaro.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/keembay/ocs-hcu.c:107: warning: expecting prototype for struct ocs_hcu_dma_list. Prototype was for struct ocs_hcu_dma_entry instead
 drivers/crypto/keembay/ocs-hcu.c:127: warning: expecting prototype for struct ocs_dma_list. Prototype was for struct ocs_hcu_dma_list instead
 drivers/crypto/keembay/ocs-hcu.c:610: warning: expecting prototype for ocs_hcu_digest(). Prototype was for ocs_hcu_hash_update() instead
 drivers/crypto/keembay/ocs-hcu.c:648: warning: expecting prototype for ocs_hcu_hash_final(). Prototype was for ocs_hcu_hash_finup() instead

Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Cc: Declan Murphy <declan.murphy@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/keembay/ocs-hcu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/keembay/ocs-hcu.c b/drivers/crypto/keembay/ocs-hcu.c
index 81eecacf603ad..d522757855fb0 100644
--- a/drivers/crypto/keembay/ocs-hcu.c
+++ b/drivers/crypto/keembay/ocs-hcu.c
@@ -93,7 +93,7 @@
 #define OCS_HCU_WAIT_BUSY_TIMEOUT_US		1000000
 
 /**
- * struct ocs_hcu_dma_list - An entry in an OCS DMA linked list.
+ * struct ocs_hcu_dma_entry - An entry in an OCS DMA linked list.
  * @src_addr:  Source address of the data.
  * @src_len:   Length of data to be fetched.
  * @nxt_desc:  Next descriptor to fetch.
@@ -597,7 +597,7 @@ int ocs_hcu_hash_init(struct ocs_hcu_hash_ctx *ctx, enum ocs_hcu_algo algo)
 }
 
 /**
- * ocs_hcu_digest() - Perform a hashing iteration.
+ * ocs_hcu_hash_update() - Perform a hashing iteration.
  * @hcu_dev:	The OCS HCU device to use.
  * @ctx:	The OCS HCU hashing context.
  * @dma_list:	The OCS DMA list mapping the input data to process.
@@ -632,7 +632,7 @@ int ocs_hcu_hash_update(struct ocs_hcu_dev *hcu_dev,
 }
 
 /**
- * ocs_hcu_hash_final() - Update and finalize hash computation.
+ * ocs_hcu_hash_finup() - Update and finalize hash computation.
  * @hcu_dev:	The OCS HCU device to use.
  * @ctx:	The OCS HCU hashing context.
  * @dma_list:	The OCS DMA list mapping the input data to process.
-- 
2.27.0

