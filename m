From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hanging modprobe aes_s390
Date: Thu, 26 Feb 2009 14:06:18 +0800
Message-ID: <20090226060618.GA11303@gondor.apana.org.au>
References: <20090225035137.GA31538@gondor.apana.org.au> <1235583230.17311.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58562 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753249AbZBZGGY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 01:06:24 -0500
Content-Disposition: inline
In-Reply-To: <1235583230.17311.57.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 25, 2009 at 05:33:50PM +0000, Jan Glauber wrote:
>
> STACK TRACE FOR TASK: 0x3f6137c8 (modprobe)
> 
>  STACK:
>  0 schedule+1136 [0x2df82c]
>  1 fcntl_setlk+412 [0x107a0c]
>  2 sys_fcntl+262 [0xd7076]
>  3 sysc_noemu+16 [0x27a5e]

I see.  Please let me know if this patch fixes it.

crypto: api - Fix module load deadlock with fallback algorithms

With the mandatory algorithm testing at registration, we have
now created a deadlock with algorithms requiring fallbacks.
This can happen if the module containing the algorithm requiring
fallback is loaded first, without the fallback module being loaded
first.  The system will then try to test the new algorithm, find
that it needs to load a fallback, and then try to load that.

As both algorithms share the same module alias, it can attempt
to load the original algorithm again and block indefinitely.

As algorithms requiring fallbacks are a special case, we can fix
this by giving them a different module alias than the rest.  Then
it's just a matter of using the right aliases according to what
algorithms we're trying to find.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index c42cd89..6118890 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -556,7 +556,7 @@ static void __exit aes_s390_fini(void)
 module_init(aes_s390_init);
 module_exit(aes_s390_fini);
 
-MODULE_ALIAS("aes");
+MODULE_ALIAS("aes-all");
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("GPL");
diff --git a/crypto/api.c b/crypto/api.c
index efe77df..38a2bc0 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -215,8 +215,19 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 	mask &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 	type &= mask;
 
-	alg = try_then_request_module(crypto_alg_lookup(name, type, mask),
-				      name);
+	alg = crypto_alg_lookup(name, type, mask);
+	if (!alg) {
+		char tmp[CRYPTO_MAX_ALG_NAME];
+
+		request_module(name);
+
+		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask) &&
+		    snprintf(tmp, sizeof(tmp), "%s-all", name) < sizeof(tmp))
+			request_module(tmp);
+
+		alg = crypto_alg_lookup(name, type, mask);
+	}
+
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 856b3cc..3f0fdd1 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -489,4 +489,4 @@ MODULE_DESCRIPTION("VIA PadLock AES algorithm support");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("aes");
+MODULE_ALIAS("aes-all");
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index a7fbade..a2c8e85 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -304,7 +304,7 @@ MODULE_DESCRIPTION("VIA PadLock SHA1/SHA256 algorithms support.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("sha1");
-MODULE_ALIAS("sha256");
+MODULE_ALIAS("sha1-all");
+MODULE_ALIAS("sha256-all");
 MODULE_ALIAS("sha1-padlock");
 MODULE_ALIAS("sha256-padlock");

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
