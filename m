From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 01/10] crypto: authenc - Find proper IV address in ablkcipher
 callback
Date: Tue, 12 Nov 2013 11:46:04 -0600
Message-ID: <20131112174604.19746.83804.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When performing an asynchronous ablkcipher operation the authenc
completion callback routine is invoked, but it does not locate and use
the proper IV.

The callback routine, crypto_authenc_encrypt_done, is updated to use
the same method of calculating the address of the IV as is done in
crypto_authenc_encrypt function which sets up the callback.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 crypto/authenc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index ffce19d..528b00b 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -368,9 +368,10 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 	if (!err) {
 		struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 		struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-		struct ablkcipher_request *abreq = aead_request_ctx(areq);
-		u8 *iv = (u8 *)(abreq + 1) +
-			 crypto_ablkcipher_reqsize(ctx->enc);
+		struct authenc_request_ctx *areq_ctx = aead_request_ctx(areq);
+		struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
+							    + ctx->reqoff);
+		u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(ctx->enc);
 
 		err = crypto_authenc_genicv(areq, iv, 0);
 	}
