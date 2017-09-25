From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH 2/2] crypto/nx: Do not initialize workmem allocation
Date: Sun, 24 Sep 2017 23:44:13 -0700
Message-ID: <1506321853.13257.6.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: herbert@gondor.apana.org.au, mpe@ellerman.id.au, ddstreet@ieee.org,
        mikey@neuling.org, suka@us.ibm.com, npiggin@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932230AbdIYGod (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 02:44:33 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8P6i2vj078356
        for <linux-crypto@vger.kernel.org>; Mon, 25 Sep 2017 02:44:32 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d6cc3u2b8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 25 Sep 2017 02:44:32 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Mon, 25 Sep 2017 02:44:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH 2/2] crypto/nx: Do not initialize workmem allocation

We are using percpu send window on P9 NX (powerNV) instead of opening /
closing per each crypto session. Means txwin is removed from workmem.
So we do not need to initialize workmem for each request.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index da3cb8c..d94e25d 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -116,7 +116,7 @@ int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
 
 	spin_lock_init(&ctx->lock);
 	ctx->driver = driver;
-	ctx->wmem = kzalloc(driver->workmem_size, GFP_KERNEL);
+	ctx->wmem = kmalloc(driver->workmem_size, GFP_KERNEL);
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
-- 
1.8.3.1
