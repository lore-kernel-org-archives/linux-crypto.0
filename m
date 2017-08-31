From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V4 5/7] crypto/nx: Use kzalloc for workmem allocation
Date: Thu, 31 Aug 2017 00:17:25 -0700
Message-ID: <1504163845.4681.8.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mikey@neuling.org, ddstreet@ieee.org, linuxram@us.ibm.com,
        npiggin@gmail.com, benh@kernel.crashing.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41849 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750897AbdHaHRm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 03:17:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7V7FYhB120147
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:17:41 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cpbh89d8y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:17:41 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Thu, 31 Aug 2017 01:17:40 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Send window is opened / closed for each crypto session.
So initializes txwin in workmem.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index d94e25df503b..da3cb8c35ec7 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -116,7 +116,7 @@ int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
 
 	spin_lock_init(&ctx->lock);
 	ctx->driver = driver;
-	ctx->wmem = kmalloc(driver->workmem_size, GFP_KERNEL);
+	ctx->wmem = kzalloc(driver->workmem_size, GFP_KERNEL);
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
-- 
2.11.0
