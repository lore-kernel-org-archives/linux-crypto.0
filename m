Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB096C4321E
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 20:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbiBJUnl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 15:43:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344363AbiBJUnk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 15:43:40 -0500
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BF7103F;
        Thu, 10 Feb 2022 12:43:40 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.88,359,1635199200"; 
   d="scan'208";a="5603085"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 21:42:33 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] crypto: use GFP_KERNEL
Date:   Thu, 10 Feb 2022 21:42:18 +0100
Message-Id: <20220210204223.104181-5-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220210204223.104181-1-Julia.Lawall@inria.fr>
References: <20220210204223.104181-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Platform_driver probe functions aren't called with locks held
and thus don't need GFP_ATOMIC. Use GFP_KERNEL instead.

Problem found with Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 +-
 drivers/crypto/ux500/hash/hash_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 97277b7150cb..5a57c9afd8c8 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1264,7 +1264,7 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	dev_dbg(dev, "[%s]", __func__);
-	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_ATOMIC);
+	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_KERNEL);
 	if (!device_data) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 51a6e1a42434..5157c118d642 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1658,7 +1658,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	struct hash_device_data *device_data;
 	struct device		*dev = &pdev->dev;
 
-	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_ATOMIC);
+	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_KERNEL);
 	if (!device_data) {
 		ret = -ENOMEM;
 		goto out;

