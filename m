From: Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH] tls: Add support for encryption using async offload accelerator
Date: Wed, 31 Jan 2018 16:06:54 +0530
Message-ID: <20180131103654.9759-1-vakul.garg@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: ilyal@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vakul Garg <vakul.garg@nxp.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0057.outbound.protection.outlook.com ([104.47.1.57]:7616
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751452AbeAaFOX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 00:14:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
GCM operation. If they are enabled, crypto_aead_encrypt() return error
code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
completion till the time the response for crypto offload request is
received.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
 net/tls/tls_sw.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 73d19210dd49..390e6dc7b135 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -39,6 +39,11 @@
 
 #include <net/tls.h>
 
+struct crypto_completion {
+	struct completion comp;
+	int result;
+};
+
 static void trim_sg(struct sock *sk, struct scatterlist *sg,
 		    int *sg_num_elem, unsigned int *sg_size, int target_size)
 {
@@ -194,6 +199,14 @@ static void tls_free_both_sg(struct sock *sk)
 		&ctx->sg_plaintext_size);
 }
 
+static void crypto_complete(struct crypto_async_request *req, int err)
+{
+	struct crypto_completion *x = req->data;
+
+	x->result = err;
+	complete(&x->comp);
+}
+
 static int tls_do_encryption(struct tls_context *tls_ctx,
 			     struct tls_sw_context *ctx, size_t data_len,
 			     gfp_t flags)
@@ -202,6 +215,7 @@ static int tls_do_encryption(struct tls_context *tls_ctx,
 		crypto_aead_reqsize(ctx->aead_send);
 	struct aead_request *aead_req;
 	int rc;
+	struct crypto_completion crypto_done;
 
 	aead_req = kzalloc(req_size, flags);
 	if (!aead_req)
@@ -214,7 +228,15 @@ static int tls_do_encryption(struct tls_context *tls_ctx,
 	aead_request_set_ad(aead_req, TLS_AAD_SPACE_SIZE);
 	aead_request_set_crypt(aead_req, ctx->sg_aead_in, ctx->sg_aead_out,
 			       data_len, tls_ctx->iv);
+	aead_request_set_callback(aead_req, 0, crypto_complete, &crypto_done);
+
+	init_completion(&crypto_done.comp);
+
 	rc = crypto_aead_encrypt(aead_req);
+	if (rc == -EINPROGRESS) {
+		wait_for_completion(&crypto_done.comp);
+		rc = crypto_done.result;
+	}
 
 	ctx->sg_encrypted_data[0].offset -= tls_ctx->prepend_size;
 	ctx->sg_encrypted_data[0].length += tls_ctx->prepend_size;
-- 
2.13.6
