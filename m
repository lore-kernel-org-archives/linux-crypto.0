Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF97C4321A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8EA64F72
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhCRMpA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhCRMoh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC505C06174A
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so3116940wmc.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rd9z4w9LE1HolCnpzEf+gv0c+Los0igJWAfUgufQ4UM=;
        b=smUYcY3bH6WJZsnhdH1GiU+qMOjP0jFa4N5IWcbWJ8GIsDAqrL5z2tg1883ti4JXHb
         rSsi2zIvxaHh/Ax5K9gr7b8H/5t3UtAX78WeciTMwnIMPtmBYsM0BCvcgJ/cp7cD5MN2
         rSeUKblpDgAomDYbwLu6ASR9A1Ct+39A6HxCAmBSNwE1zJksMc2OEh/RabX/rSCHIfaE
         RQg+vge8s2xtwDK/WVbePmUkim+Eb5D00J47djQOLpR4bqwCl3s6Aq8pU5JwhTZwMYn3
         nyih1ocJSztiO0tyA19Nsx5+B7ngCml3YBhtlvP6H9CQritTWMD7x01d7ZbM0ZkTuK3g
         BJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rd9z4w9LE1HolCnpzEf+gv0c+Los0igJWAfUgufQ4UM=;
        b=Lu7rbQc594wRFA8T2HKQjrzNiAyZBjVLFwqpmMwoZ1fON7ws9ovn4mWqDAXQTeSlnh
         KeTfWLiBb35V//Pne2znUVn3Ird0/XbJG23o3nF9CltKkD7GeCtO19fnR0qSkX52uc0C
         cN8NXVxjlSZQvVZTdE2WzeYhNXEUOaUEcbrkBLZzz0VkhZkSwiZEBGmNv3xFVof2iUV4
         sLouGEVFyytR+NiY0kqBuVY5ZmzmlqaWzEI9AbH55O0FxVPVUpxlK053GpI9OaKXpDUC
         MabvPV56JdTaFPlYv4BHcNsRe3NoJOqExsu710vUHCgom54cpyr7waIVZyU9dsL2kDc4
         5gsQ==
X-Gm-Message-State: AOAM531bHvkVDQkpgNAApsjGyTFnazWdWIXc1h+BGRjsqVuG6oxibXTM
        WyWDPNn6Ye4Ab/Isa/jaS4gtPg==
X-Google-Smtp-Source: ABdhPJygbhjJs4HBWO1eviqQN63QCzvlzS87m5Lpk7e6AsEBKZ2xZx+9+p4VQO9m9wx6pJdMAcPGHg==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr3560775wml.147.1616071475551;
        Thu, 18 Mar 2021 05:44:35 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id q15sm2813900wrx.56.2021.03.18.05.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 05:44:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 05/10] crypto: keembay: ocs-hcu: Fix incorrectly named functions/structs
Date:   Thu, 18 Mar 2021 12:44:17 +0000
Message-Id: <20210318124422.3200180-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124422.3200180-1-lee.jones@linaro.org>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
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
 drivers/crypto/keembay/ocs-hcu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/keembay/ocs-hcu.c b/drivers/crypto/keembay/ocs-hcu.c
index 81eecacf603ad..deb9bd460ee62 100644
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
@@ -107,7 +107,7 @@ struct ocs_hcu_dma_entry {
 };
 
 /**
- * struct ocs_dma_list - OCS-specific DMA linked list.
+ * struct ocs_hcu_dma_list - OCS-specific DMA linked list.
  * @head:	The head of the list (points to the array backing the list).
  * @tail:	The current tail of the list; NULL if the list is empty.
  * @dma_addr:	The DMA address of @head (i.e., the DMA address of the backing
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

