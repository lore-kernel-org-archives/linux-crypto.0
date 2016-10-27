From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: acomp: export all scomp interfaces
Date: Thu, 27 Oct 2016 16:09:49 +0200
Message-ID: <20161027141029.2566709-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The newly added scomp/acomp interface has a couple of functions
that should be exported to allow linking the two drivers
as loadable modules:

ERROR: "crypto_acomp_scomp_free_ctx" [crypto/acompress.ko] undefined!
ERROR: "crypto_acomp_scomp_alloc_ctx" [crypto/acompress.ko] undefined!
ERROR: "crypto_init_scomp_ops_async" [crypto/acompress.ko] undefined!

Alternatively, both of them could be combined into one loadable module.

Fixes: 1ab53a77b772 ("crypto: acomp - add driver-side scomp interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/scompress.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 35e396d154b7..1f9cdcddb2ce 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -267,6 +267,7 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_init_scomp_ops_async);
 
 struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req)
 {
@@ -286,6 +287,7 @@ struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req)
 
 	return req;
 }
+EXPORT_SYMBOL_GPL(crypto_acomp_scomp_alloc_ctx);
 
 void crypto_acomp_scomp_free_ctx(struct acomp_req *req)
 {
@@ -298,6 +300,7 @@ void crypto_acomp_scomp_free_ctx(struct acomp_req *req)
 	if (ctx)
 		crypto_scomp_free_ctx(scomp, ctx);
 }
+EXPORT_SYMBOL_GPL(crypto_acomp_scomp_free_ctx);
 
 static const struct crypto_type crypto_scomp_type = {
 	.extsize = crypto_alg_extsize,
-- 
2.9.0
