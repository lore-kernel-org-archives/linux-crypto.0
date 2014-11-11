From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/2] crypto: AF_ALG - zeroize message digest buffer
Date: Tue, 11 Nov 2014 05:37:07 +0100
Message-ID: <2491424.h8JBGRc3Yx@tachyon.chronox.de>
References: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'Sandy Harris' <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Zeroize the buffer holding the message digest calculated for the
consumer before the buffer is released by the hash AF_ALG interface
handler.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_hash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 8502462..f75db4c 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -258,6 +258,8 @@ static void hash_sock_destruct(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 
+	memzero_explicit(ctx->result,
+		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
 	sock_kfree_s(sk, ctx->result,
 		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
 	sock_kfree_s(sk, ctx, ctx->len);
-- 
2.1.0
