Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1577BCCA47E
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 19:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358962AbiFVTi6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jun 2022 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359141AbiFVTi0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jun 2022 15:38:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44DD3DDCF;
        Wed, 22 Jun 2022 12:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655926705; x=1687462705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SrqNYLhrIYTbLf+pLr5lA6vQS1PpkyYUL/1WuAbc1Ag=;
  b=MWs9LiOujiOhIkjSbaPy0AgY2djnX7OKK8nIHXn3OJNlTePcNtF6SrZF
   aPXp4JJvGES4MhmS7yHnHb8nXUIQqIPRPcrWKTaaYIGJza7+D3ASkzN0g
   9SOnvIOxzpuTtAfH3XS17EollcgsYkCWzYDNNPBD6n4SqyMMeH1Y5zwB6
   oyhPmoB1BCtUMRie5FkgQkNrYKQ9s652wfapJ5zHSc2DOzlt1il+maInm
   4Zy2tCmOahIqLrOFO6w+4x4KYOts/QRZXIJyshQ1rkVnvolRkHSSdZx6N
   ymeCtjN/dTN7XPU9wo14/d9w4EsW0303h1B2c+teSSUs2QXvnCmPtR9SA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="305983072"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305983072"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 12:38:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="715542081"
Received: from bwalker-desk.ch.intel.com ([143.182.136.162])
  by orsmga004.jf.intel.com with ESMTP; 22 Jun 2022 12:38:23 -0700
From:   Ben Walker <benjamin.walker@intel.com>
To:     vkoul@kernel.org
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v4 04/15] crypto: stm32/hash: Use dmaengine_async_is_tx_complete
Date:   Wed, 22 Jun 2022 12:37:42 -0700
Message-Id: <20220622193753.3044206-5-benjamin.walker@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220622193753.3044206-1-benjamin.walker@intel.com>
References: <20220503200728.2321188-1-benjamin.walker@intel.com>
 <20220622193753.3044206-1-benjamin.walker@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace dma_async_is_tx_complete with dmaengine_async_is_tx_complete.
The previous API will be removed in favor of the new one.

Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: Ben Walker <benjamin.walker@intel.com>
---
 drivers/crypto/stm32/stm32-hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d43f761..aef447847c499 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -453,8 +453,7 @@ static int stm32_hash_xmit_dma(struct stm32_hash_dev *hdev,
 					 msecs_to_jiffies(100)))
 		err = -ETIMEDOUT;
 
-	if (dma_async_is_tx_complete(hdev->dma_lch, cookie,
-				     NULL, NULL) != DMA_COMPLETE)
+	if (dmaengine_async_is_tx_complete(hdev->dma_lch, cookie) != DMA_COMPLETE)
 		err = -ETIMEDOUT;
 
 	if (err) {
-- 
2.35.1

