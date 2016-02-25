From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - memset request context to zero during import
Date: Thu, 25 Feb 2016 16:48:13 -0600
Message-ID: <20160225224813.2020.48336.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:9535
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbcBYWsW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2016 17:48:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since a crypto_ahash_import() can be called against a request context
that has not had a crypto_ahash_init() performed, the request context
needs to be cleared to insure there is no random data present. If not,
the random data can result in a kernel oops during crypto_ahash_update().

Cc: <stable@vger.kernel.org> # 3.14.x-
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    1 +
 drivers/crypto/ccp/ccp-crypto-sha.c      |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index d095452..3d9acc5 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -244,6 +244,7 @@ static int ccp_aes_cmac_import(struct ahash_request *req, const void *in)
 	/* 'in' may not be aligned so memcpy to local variable */
 	memcpy(&state, in, sizeof(state));
 
+	memset(rctx, 0, sizeof(*rctx));
 	rctx->null_msg = state.null_msg;
 	memcpy(rctx->iv, state.iv, sizeof(rctx->iv));
 	rctx->buf_count = state.buf_count;
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 7002c6b..8ef06fa 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -233,6 +233,7 @@ static int ccp_sha_import(struct ahash_request *req, const void *in)
 	/* 'in' may not be aligned so memcpy to local variable */
 	memcpy(&state, in, sizeof(state));
 
+	memset(rctx, 0, sizeof(*rctx));
 	rctx->type = state.type;
 	rctx->msg_bits = state.msg_bits;
 	rctx->first = state.first;
