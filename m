From: Vakul Garg <vakul.garg@nxp.com>
Subject: RE: [PATCH] tls: Add support for encryption using async offload
 accelerator
Date: Wed, 31 Jan 2018 10:40:00 +0000
Message-ID: <HE1PR04MB30823274C8F3EFF3592C5A148BFB0@HE1PR04MB3082.eurprd04.prod.outlook.com>
References: <20180131155905.6523-1-vakul.garg@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "ilyal@mellanox.com" <ilyal@mellanox.com>,
        "aviadye@mellanox.com" <aviadye@mellanox.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-he1eur01on0063.outbound.protection.outlook.com ([104.47.0.63]:36592
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752772AbeAaKkD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 05:40:03 -0500
In-Reply-To: <20180131155905.6523-1-vakul.garg@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Forgot to add 'v2' in subject line.
I will be resending.

-----Original Message-----
From: Vakul Garg=20
Sent: Wednesday, January 31, 2018 9:29 PM
To: linux-crypto@vger.kernel.org
Cc: ilyal@mellanox.com; aviadye@mellanox.com; davejwatson@fb.com; davem@dav=
emloft.net; netdev@vger.kernel.org; Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH] tls: Add support for encryption using async offload accele=
rator

Async crypto accelerators (e.g. drivers/crypto/caam) support offloading GCM=
 operation. If they are enabled, crypto_aead_encrypt() return error code -E=
INPROGRESS. In this case tls_do_encryption() needs to wait on a completion =
till the time the response for crypto offload request is received.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
v1-v2:
 - Used crypto_wait_req() to wait for async operation completion
 - Passed CRYPTO_TFM_REQ_MAY_BACKLOG to crypto_aead_encrypt

 include/net/tls.h | 2 ++
 net/tls/tls_sw.c  | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h index 936cfc5cab7d..8a8e=
1256caee 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -36,6 +36,7 @@
=20
 #include <linux/types.h>
 #include <asm/byteorder.h>
+#include <linux/crypto.h>
 #include <linux/socket.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
@@ -57,6 +58,7 @@
=20
 struct tls_sw_context {
 	struct crypto_aead *aead_send;
+	struct crypto_wait async_wait;
=20
 	/* Sending context */
 	char aad_space[TLS_AAD_SPACE_SIZE];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c index 73d19210dd49..31a9f0=
ef8af6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -214,7 +214,11 @@ static int tls_do_encryption(struct tls_context *tls_c=
tx,
 	aead_request_set_ad(aead_req, TLS_AAD_SPACE_SIZE);
 	aead_request_set_crypt(aead_req, ctx->sg_aead_in, ctx->sg_aead_out,
 			       data_len, tls_ctx->iv);
-	rc =3D crypto_aead_encrypt(aead_req);
+
+	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &ctx->async_wait);
+
+	rc =3D crypto_wait_req(crypto_aead_encrypt(aead_req), &ctx->async_wait);
=20
 	ctx->sg_encrypted_data[0].offset -=3D tls_ctx->prepend_size;
 	ctx->sg_encrypted_data[0].length +=3D tls_ctx->prepend_size; @@ -663,6 +6=
67,8 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx)
 		goto out;
 	}
=20
+	crypto_init_wait(&sw_ctx->async_wait);
+
 	ctx->priv_ctx =3D (struct tls_offload_context *)sw_ctx;
=20
 	crypto_info =3D &ctx->crypto_send;
