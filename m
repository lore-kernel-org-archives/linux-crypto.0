From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: caam - fix error return code in caam_qi_init()
Date: Tue, 11 Apr 2017 16:04:09 +0000
Message-ID: <20170411160409.18430-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: horia.geanta@nxp.com, dan.douglass@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33178 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdDKQEQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2017 12:04:16 -0400
Received: by mail-pf0-f195.google.com with SMTP id c198so256571pfc.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Apr 2017 09:04:16 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the kmem_cache_create() error
handling case instead of 0(err is 0 here), as done elsewhere in this
function.

Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 45de8fd..1990ed4 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -789,7 +789,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		dev_err(qidev, "Can't allocate CAAM cache\n");
 		free_rsp_fqs();
 		platform_device_unregister(qi_pdev);
-		return err;
+		return -ENOMEM;
 	}
 
 	/* Done with the CGRs; restore the cpus allowed mask */
