Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CEEC46467
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 00:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiK2AKS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Nov 2022 19:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiK2AKR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2022 19:10:17 -0500
X-Greylist: delayed 3306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 16:10:15 PST
Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCF4DD;
        Mon, 28 Nov 2022 16:10:15 -0800 (PST)
Received: from beagle8.blr.asicdesigners.com (beagle8.blr.asicdesigners.com [10.193.80.125])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 2ASNEj99013901;
        Mon, 28 Nov 2022 15:14:46 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        fmdefrancesco@gmail.com, anirudh.venkataramanan@intel.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH] MAINTAINERS: Update maintainer list for chelsio drivers
Date:   Tue, 29 Nov 2022 04:43:48 +0530
Message-Id: <20221128231348.8225-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This updates the maintainers for chelsio inline crypto drivers and
chelsio crypto drivers.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 MAINTAINERS | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61fe86968111..fbcd630e658f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5586,8 +5586,6 @@ F:	drivers/scsi/cxgbi/cxgb3i
 
 CXGB4 CRYPTO DRIVER (chcr)
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
@@ -5595,8 +5593,6 @@ F:	drivers/crypto/chelsio
 
 CXGB4 INLINE CRYPTO DRIVER
 M:	Ayush Sawal <ayush.sawal@chelsio.com>
-M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
-M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.chelsio.com
-- 
2.18.1

