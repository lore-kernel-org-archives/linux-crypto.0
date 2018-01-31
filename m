From: Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCHv2] tls: Add support for encryption using async offload accelerator
Date: Wed, 31 Jan 2018 21:34:37 +0530
Message-ID: <20180131160437.6583-1-vakul.garg@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: ilyal@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vakul Garg <vakul.garg@nxp.com>
To: linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
GCM operation. If they are enabled, crypto_aead_encrypt() return error
code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
completion till the time the response for crypto offload request is
received.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
v1-v2:
 - Used crypto_wait_req() to wait for async operation completion
 - Passed CRYPTO_TFM_REQ_MAY_BACKLOG to crypto_aead_encrypt

 include/net/tls.h | 2 ++
 net/tls/tls_sw.c  | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 936cfc5cab7d..8a8e1256caee 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -36,6 +36,7 @@
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
+#include <linux/crypto.h>
 #include <linux/socket.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
@@ -57,6 +58,7 @@
 
 struct tls_sw_context {
 	struct crypto_aead *aead_send;
+	struct crypto_wait async_wait;
 
 	/* Sending context */
 	char aad_space[TLS_AAD_SPACE_SIZE];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 73d19210dd49..31a9f0ef8af6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -214,7 +214,11 @@ static int tls_do_encryption(struct tls_context *tls_ctx,
 	aead_request_set_ad(aead_req, TLS_AAD_SPACE_SIZE);
 	aead_request_set_crypt(aead_req, ctx->sg_aead_in, ctx->sg_aead_out,
 			       data_len, tls_ctx->iv);
-	rc = crypto_aead_encrypt(aead_req);
+
+	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &ctx->async_wait);
+
+	rc = crypto_wait_req(crypto_aead_encrypt(aead_req), &ctx->async_wait);
 
 	ctx->sg_encrypted_data[0].offset -= tls_ctx->prepend_size;
 	ctx->sg_encrypted_data[0].length += tls_ctx->prepend_size;
@@ -663,6 +667,8 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx)
 		goto out;
 	}
 
+	crypto_init_wait(&sw_ctx->async_wait);
+
 	ctx->priv_ctx = (struct tls_offload_context *)sw_ctx;
 
 	crypto_info = &ctx->crypto_send;
-- 
2.13.6
