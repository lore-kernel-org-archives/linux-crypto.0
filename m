From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 1/4] crypto: inside-secure - per request invalidation
Date: Tue, 28 Nov 2017 10:05:15 +0100
Message-ID: <20171128090518.12469-2-antoine.tenart@free-electrons.com>
References: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
Cc: Ofer Heifetz <oferh@marvell.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:54767 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdK1JKD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 04:10:03 -0500
In-Reply-To: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ofer Heifetz <oferh@marvell.com>

When an invalidation request is needed we currently override the context
.send and .handle_result helpers. This is wrong as under high load other
requests can already be queued and overriding the context helpers will
make them execute the wrong .send and .handle_result functions.

This commit fixes this by adding a needs_inv flag in the request to
choose the action to perform when sending requests or handling their
results. This flag will be set when needed (i.e. when the context flag
will be set).

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: commit message, and removed non related changes from the
original commit]
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/crash.txt         | 56 ++++++++++++++++++++
 drivers/crypto/inside-secure/safexcel_cipher.c | 71 +++++++++++++++++++++-----
 drivers/crypto/inside-secure/safexcel_hash.c   | 68 +++++++++++++++++++-----
 3 files changed, 168 insertions(+), 27 deletions(-)
 create mode 100644 drivers/crypto/inside-secure/crash.txt

diff --git a/drivers/crypto/inside-secure/crash.txt b/drivers/crypto/inside-secure/crash.txt
new file mode 100644
index 000000000000..18f15e542e62
--- /dev/null
+++ b/drivers/crypto/inside-secure/crash.txt
@@ -0,0 +1,56 @@
+[   12.117635] Unable to handle kernel NULL pointer dereference at virtual address 00000000
+[   12.127101] Mem abort info:
+[   12.131303]   Exception class = DABT (current EL), IL = 32 bits
+[   12.138636]   SET = 0, FnV = 0
+[   12.143100]   EA = 0, S1PTW = 0
+[   12.146325] Data abort info:
+[   12.149230]   ISV = 0, ISS = 0x00000006
+[   12.153093]   CM = 0, WnR = 0
+[   12.156085] user pgtable: 4k pages, 48-bit VAs, pgd = ffff8000eab7d000
+[   12.162649] [0000000000000000] *pgd=00000000eaaec003, *pud=00000000eaaed003, *pmd=0000000000000000
+[   12.171665] Internal error: Oops: 96000006 [#1] PREEMPT SMP
+[   12.177263] Modules linked in: cryptodev(O)
+[   12.181471] CPU: 3 PID: 249 Comm: irq/30-f2800000 Tainted: GO    4.14.0-rc7 #416
+[   12.189857] Hardware name: Marvell 8040 MACHIATOBin (DT)
+[   12.195192] task: ffff8000e6a68e00 task.stack: ffff00000de80000
+[   12.201146] PC is at __memcpy+0x70/0x180
+[   12.205088] LR is at safexcel_handle_result+0xbc/0x360
+[   12.210247] pc : [<ffff000008646ef0>] lr : [<ffff00000849961c>] pstate: 60000145
+[   12.217673] sp : ffff00000de83ca0
+[   12.221002] x29: ffff00000de83ca0 x28: ffff8000eb377c80 
+[   12.226340] x27: ffff00000de83d93 x26: 0000000000000020 
+[   12.231678] x25: ffff00000de83d94 x24: 0000000000000001 
+[   12.237015] x23: ffff8000e772114c x22: ffff8000e77357c0 
+[   12.242352] x21: ffff8000eb377080 x20: ffff8000eb377000 
+[   12.247689] x19: ffff8000e7721018 x18: 0000000000000055 
+[   12.253025] x17: 0000ffff90477460 x16: ffff00000824cb10 
+[   12.258362] x15: 0000000000000b08 x14: 00003d0900000000 
+[   12.263699] x13: 00000000000186a0 x12: 0000000000000004 
+[   12.269035] x11: 0000000000000040 x10: 0000000000000a00 
+[   12.274372] x9 : ffff00000de83d00 x8 : ffff000008e78a08 
+[   12.279709] x7 : 0000000000000003 x6 : ffff8000eb377088 
+[   12.285046] x5 : 0000000000000000 x4 : 0000000000000000 
+[   12.290382] x3 : 0000000000000020 x2 : 0000000000000020 
+[   12.295719] x1 : 0000000000000000 x0 : ffff8000eb377088 
+[   12.301058] Process irq/30-f2800000 (pid: 249, stack limit = 0xffff00000de80000)
+[   12.308484] Call trace:
+[   12.310941] Exception stack(0xffff00000de83b60 to 0xffff00000de83ca0)
+[   12.317410] 3b60: ffff8000eb377088 0000000000000000 0000000000000020 0000000000000020
+[   12.325274] 3b80: 0000000000000000 0000000000000000 ffff8000eb377088 0000000000000003
+[   12.333137] 3ba0: ffff000008e78a08 ffff00000de83d00 0000000000000a00 0000000000000040
+[   12.341000] 3bc0: 0000000000000004 00000000000186a0 00003d0900000000 0000000000000b08
+[   12.348863] 3be0: ffff00000824cb10 0000ffff90477460 0000000000000055 ffff8000e7721018
+[   12.356726] 3c00: ffff8000eb377000 ffff8000eb377080 ffff8000e77357c0 ffff8000e772114c
+[   12.364589] 3c20: 0000000000000001 ffff00000de83d94 0000000000000020 ffff00000de83d93
+[   12.372452] 3c40: ffff8000eb377c80 ffff00000de83ca0 ffff00000849961c ffff00000de83ca0
+[   12.380315] 3c60: ffff000008646ef0 0000000060000145 ffff000008499604 ffff8000eb377000
+[   12.388177] 3c80: ffffffffffffffff ffff000008499604 ffff00000de83ca0 ffff000008646ef0
+[   12.396041] [<ffff000008646ef0>] __memcpy+0x70/0x180
+[   12.401028] [<ffff000008496bd8>] safexcel_irq_ring_thread+0x128/0x270
+[   12.407498] [<ffff00000810bf80>] irq_thread_fn+0x30/0x70
+[   12.412832] [<ffff00000810c2b8>] irq_thread+0x158/0x200
+[   12.418080] [<ffff0000080d4688>] kthread+0x108/0x140
+[   12.423066] [<ffff000008084c7c>] ret_from_fork+0x10/0x24
+[   12.428401] Code: 54000080 540000ab a8c12027 a88120c7 (a8c12027) 
+[   12.434521] ---[ end trace 6845b94599e89fd8 ]---
+[   12.439193] genirq: exiting task "irq/30-f2800000" (249) is an active IRQ thread (irq 30)
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 5438552bc6d7..9ea24868d860 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -14,6 +14,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/skcipher.h>
+#include <crypto/internal/skcipher.h>
 
 #include "safexcel.h"
 
@@ -33,6 +34,10 @@ struct safexcel_cipher_ctx {
 	unsigned int key_len;
 };
 
+struct safexcel_cipher_req {
+	bool needs_inv;
+};
+
 static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx,
 				  struct crypto_async_request *async,
 				  struct safexcel_command_desc *cdesc,
@@ -126,9 +131,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	return 0;
 }
 
-static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
-				  struct crypto_async_request *async,
-				  bool *should_complete, int *ret)
+static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int ring,
+				      struct crypto_async_request *async,
+				      bool *should_complete, int *ret)
 {
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_result_desc *rdesc;
@@ -265,7 +270,6 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
 	request->req = &req->base;
-	ctx->base.handle_result = safexcel_handle_result;
 
 	*commands = n_cdesc;
 	*results = n_rdesc;
@@ -341,8 +345,6 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 
 	ring = safexcel_select_ring(priv);
 	ctx->base.ring = ring;
-	ctx->base.needs_inv = false;
-	ctx->base.send = safexcel_aes_send;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
 	enq_ret = crypto_enqueue_request(&priv->ring[ring].queue, async);
@@ -359,6 +361,26 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 	return ndesc;
 }
 
+static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
+				  struct crypto_async_request *async,
+				  bool *should_complete, int *ret)
+{
+	struct skcipher_request *req = skcipher_request_cast(async);
+	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
+	int err;
+
+	if (sreq->needs_inv) {
+		sreq->needs_inv = false;
+		err = safexcel_handle_inv_result(priv, ring, async,
+						 should_complete, ret);
+	} else {
+		err = safexcel_handle_req_result(priv, ring, async,
+						 should_complete, ret);
+	}
+
+	return err;
+}
+
 static int safexcel_cipher_send_inv(struct crypto_async_request *async,
 				    int ring, struct safexcel_request *request,
 				    int *commands, int *results)
@@ -368,8 +390,6 @@ static int safexcel_cipher_send_inv(struct crypto_async_request *async,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret;
 
-	ctx->base.handle_result = safexcel_handle_inv_result;
-
 	ret = safexcel_invalidate_cache(async, &ctx->base, priv,
 					ctx->base.ctxr_dma, ring, request);
 	if (unlikely(ret))
@@ -381,11 +401,29 @@ static int safexcel_cipher_send_inv(struct crypto_async_request *async,
 	return 0;
 }
 
+static int safexcel_send(struct crypto_async_request *async,
+			 int ring, struct safexcel_request *request,
+			 int *commands, int *results)
+{
+	struct skcipher_request *req = skcipher_request_cast(async);
+	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
+	int ret;
+
+	if (sreq->needs_inv)
+		ret = safexcel_cipher_send_inv(async, ring, request,
+					       commands, results);
+	else
+		ret = safexcel_aes_send(async, ring, request,
+					commands, results);
+	return ret;
+}
+
 static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct skcipher_request req;
+	struct safexcel_cipher_req *sreq = skcipher_request_ctx(&req);
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
@@ -399,7 +437,7 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 	skcipher_request_set_tfm(&req, __crypto_skcipher_cast(tfm));
 	ctx = crypto_tfm_ctx(req.base.tfm);
 	ctx->base.exit_inv = true;
-	ctx->base.send = safexcel_cipher_send_inv;
+	sreq->needs_inv = true;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
 	crypto_enqueue_request(&priv->ring[ring].queue, &req.base);
@@ -424,19 +462,21 @@ static int safexcel_aes(struct skcipher_request *req,
 			enum safexcel_cipher_direction dir, u32 mode)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret, ring;
 
+	sreq->needs_inv = false;
 	ctx->direction = dir;
 	ctx->mode = mode;
 
 	if (ctx->base.ctxr) {
-		if (ctx->base.needs_inv)
-			ctx->base.send = safexcel_cipher_send_inv;
+		if (ctx->base.needs_inv) {
+			sreq->needs_inv = true;
+			ctx->base.needs_inv = false;
+		}
 	} else {
 		ctx->base.ring = safexcel_select_ring(priv);
-		ctx->base.send = safexcel_aes_send;
-
 		ctx->base.ctxr = dma_pool_zalloc(priv->context_pool,
 						 EIP197_GFP_FLAGS(req->base),
 						 &ctx->base.ctxr_dma);
@@ -476,6 +516,11 @@ static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)
 			     alg.skcipher.base);
 
 	ctx->priv = tmpl->priv;
+	ctx->base.send = safexcel_send;
+	ctx->base.handle_result = safexcel_handle_result;
+
+	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+				    sizeof(struct safexcel_cipher_req));
 
 	return 0;
 }
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 74feb6227101..6135c9f5742c 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -32,6 +32,7 @@ struct safexcel_ahash_req {
 	bool last_req;
 	bool finish;
 	bool hmac;
+	bool needs_inv;
 
 	u8 state_sz;    /* expected sate size, only set once */
 	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)];
@@ -119,9 +120,9 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	}
 }
 
-static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
-				  struct crypto_async_request *async,
-				  bool *should_complete, int *ret)
+static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int ring,
+				      struct crypto_async_request *async,
+				      bool *should_complete, int *ret)
 {
 	struct safexcel_result_desc *rdesc;
 	struct ahash_request *areq = ahash_request_cast(async);
@@ -165,9 +166,9 @@ static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
 	return 1;
 }
 
-static int safexcel_ahash_send(struct crypto_async_request *async, int ring,
-			       struct safexcel_request *request, int *commands,
-			       int *results)
+static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
+				    struct safexcel_request *request, int *commands,
+				    int *results)
 {
 	struct ahash_request *areq = ahash_request_cast(async);
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
@@ -292,7 +293,6 @@ static int safexcel_ahash_send(struct crypto_async_request *async, int ring,
 
 	req->processed += len;
 	request->req = &areq->base;
-	ctx->base.handle_result = safexcel_handle_result;
 
 	*commands = n_cdesc;
 	*results = 1;
@@ -374,8 +374,6 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 
 	ring = safexcel_select_ring(priv);
 	ctx->base.ring = ring;
-	ctx->base.needs_inv = false;
-	ctx->base.send = safexcel_ahash_send;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
 	enq_ret = crypto_enqueue_request(&priv->ring[ring].queue, async);
@@ -392,6 +390,26 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 	return 1;
 }
 
+static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
+				  struct crypto_async_request *async,
+				  bool *should_complete, int *ret)
+{
+	struct ahash_request *areq = ahash_request_cast(async);
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+	int err;
+
+	if (req->needs_inv) {
+		req->needs_inv = false;
+		err = safexcel_handle_inv_result(priv, ring, async,
+						 should_complete, ret);
+	} else {
+		err = safexcel_handle_req_result(priv, ring, async,
+						 should_complete, ret);
+	}
+
+	return err;
+}
+
 static int safexcel_ahash_send_inv(struct crypto_async_request *async,
 				   int ring, struct safexcel_request *request,
 				   int *commands, int *results)
@@ -400,7 +418,6 @@ static int safexcel_ahash_send_inv(struct crypto_async_request *async,
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	int ret;
 
-	ctx->base.handle_result = safexcel_handle_inv_result;
 	ret = safexcel_invalidate_cache(async, &ctx->base, ctx->priv,
 					ctx->base.ctxr_dma, ring, request);
 	if (unlikely(ret))
@@ -412,11 +429,30 @@ static int safexcel_ahash_send_inv(struct crypto_async_request *async,
 	return 0;
 }
 
+static int safexcel_ahash_send(struct crypto_async_request *async,
+			 int ring, struct safexcel_request *request,
+			 int *commands, int *results)
+{
+
+	struct ahash_request *areq = ahash_request_cast(async);
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+	int ret;
+
+	if (req->needs_inv)
+		ret = safexcel_ahash_send_inv(async, ring, request,
+					      commands, results);
+	else
+		ret = safexcel_ahash_send_req(async, ring, request,
+					      commands, results);
+	return ret;
+}
+
 static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct ahash_request req;
+	struct safexcel_ahash_req *rctx = ahash_request_ctx(&req);
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
@@ -430,7 +466,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	ahash_request_set_tfm(&req, __crypto_ahash_cast(tfm));
 	ctx = crypto_tfm_ctx(req.base.tfm);
 	ctx->base.exit_inv = true;
-	ctx->base.send = safexcel_ahash_send_inv;
+	rctx->needs_inv = true;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
 	crypto_enqueue_request(&priv->ring[ring].queue, &req.base);
@@ -481,14 +517,16 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret, ring;
 
-	ctx->base.send = safexcel_ahash_send;
+	req->needs_inv = false;
 
 	if (req->processed && ctx->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED)
 		ctx->base.needs_inv = safexcel_ahash_needs_inv_get(areq);
 
 	if (ctx->base.ctxr) {
-		if (ctx->base.needs_inv)
-			ctx->base.send = safexcel_ahash_send_inv;
+		if (ctx->base.needs_inv) {
+			ctx->base.needs_inv = false;
+			req->needs_inv = true;
+		}
 	} else {
 		ctx->base.ring = safexcel_select_ring(priv);
 		ctx->base.ctxr = dma_pool_zalloc(priv->context_pool,
@@ -622,6 +660,8 @@ static int safexcel_ahash_cra_init(struct crypto_tfm *tfm)
 			     struct safexcel_alg_template, alg.ahash);
 
 	ctx->priv = tmpl->priv;
+	ctx->base.send = safexcel_ahash_send;
+	ctx->base.handle_result = safexcel_handle_result;
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct safexcel_ahash_req));
-- 
2.14.3
