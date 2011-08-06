From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
Date: Sat, 06 Aug 2011 10:26:25 +0200
Message-ID: <1312619188.5589.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

Fix a get/put_cpu() imbalance in the error case when qp == NULL

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index d0183ddb..6683b58 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1006,9 +1006,8 @@ static int n2_do_ecb(struct ablkcipher_request *req, bool encrypt)
 
        spin_unlock_irqrestore(&qp->lock, flags);
 
-       put_cpu();
-
 out:
+       put_cpu();
        n2_chunk_complete(req, NULL);
        return err;
 }
@@ -1096,9 +1095,8 @@ static int n2_do_chaining(struct ablkcipher_request *req, bool encrypt)
 
        spin_unlock_irqrestore(&qp->lock, flags);
 
-       put_cpu();
-
 out:
+       put_cpu();
        n2_chunk_complete(req, err ? NULL : final_iv_addr);
        return err;
 }
