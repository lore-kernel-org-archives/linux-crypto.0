From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC PATCH] crypto: caam - fix signals handling
Date: Fri, 7 Jul 2017 16:57:06 +0300
Message-ID: <20170707135706.5487-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, Dan Douglass <dan.douglass@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0061.outbound.protection.outlook.com ([104.47.34.61]:4248
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750892AbdGGN5U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:57:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver does not properly handle the case when signals interrupt
wait_for_completion_interruptible():
-it does not check for return value
-completion structure is allocated on stack; in case a signal interrupts
the sleep, it will go out of scope, causing the worker thread
(caam_jr_dequeue) to fail when it accesses it

wait_for_completion_interruptible() is replaced with uninterruptable
wait_for_completion().
We choose to block all signals while waiting for I/O (device executing
the split key generation job descriptor) since the alternative - in
order to have a deterministic device state - would be to flush the job
ring (aborting *all* in-progress jobs).

Cc: <stable@vger.kernel.org>
Fixes: 045e36780f115 ("crypto: caam - ahash hmac support")
Fixes: 4c1ec1f930154 ("crypto: caam - refactor key_gen, sg")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---

Sending this as RFC, since I am not completely convinced that masking all
signals is the proper thing to do.
In case of I/O is this acceptable, or should the driver use instead
wait_for_completion_killable()?

 drivers/crypto/caam/caamhash.c | 2 +-
 drivers/crypto/caam/key_gen.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index da4f94eab3da..718a03293ab6 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -396,7 +396,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
 	if (!ret) {
 		/* in progress */
-		wait_for_completion_interruptible(&result.completion);
+		wait_for_completion(&result.completion);
 		ret = result.err;
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR,
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 1bb2816a9b4d..c425d4adaf2a 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -149,7 +149,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
 	if (!ret) {
 		/* in progress */
-		wait_for_completion_interruptible(&result.completion);
+		wait_for_completion(&result.completion);
 		ret = result.err;
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
-- 
2.12.0.264.gd6db3f216544
