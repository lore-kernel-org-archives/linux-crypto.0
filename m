From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH -next] crypto: api: Do not access module name directly from module structure
Date: Fri, 24 Apr 2015 08:58:03 -0700
Message-ID: <1429891083-525-1-git-send-email-linux@roeck-us.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

'struct module' is only fully declared if CONFIG_MODULES is configured.
If not, the build fails with

crypto/algapi.c: In function 'crypto_check_module_sig':
crypto/algapi.c:49:12: error: dereferencing pointer to incomplete type

Fixes: 59afdc7b3214 ("crypto: api - Move module sig ifdef into accessor
	function")
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Seen in next-20150424.

 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c63836f4ff64..3103e6a1282e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -46,7 +46,7 @@ static inline void crypto_check_module_sig(struct module *mod)
 {
 	if (fips_enabled && mod && !module_sig_ok(mod))
 		panic("Module %s signature verification failed in FIPS mode\n",
-		      mod->name);
+		      module_name(mod));
 }
 
 static int crypto_check_alg(struct crypto_alg *alg)
-- 
2.1.0
