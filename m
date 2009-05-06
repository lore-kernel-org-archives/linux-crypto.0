From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AMCC PPC4XX Security Driver-Self tests for GCM
Date: Wed, 6 May 2009 14:17:04 +0800
Message-ID: <20090506061704.GB28609@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B079E98F7@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loc Ho <lho@amcc.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41679 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbZEFGRH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2009 02:17:07 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B079E98F7@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 01, 2009 at 05:17:58PM -0700, Shasi Pulijala wrote:
> 
> The gcm tests for the security driver all fail although they pass with the earlier version( the one with the tcrypt testing module). After a little digging in I found that this could be the possible problem:
> 
> The input vector that is passed down to the driver gets overwritten in test_aead() function in testmgr.c even before calling encrypt/decrypt function. For example below is one such input plain text vector from testmgr.h for gcm. I dump it before and after calling setkey function as follows in test_aead () function:

Good point.  Now that the test engine is used at registration
time we can no longer use statically allocated buffers.  Please
try this patch and see if it helps.

commit ffac89b79ddb0cc5e0ac870e4bcb855ec51804aa
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed May 6 14:15:47 2009 +0800

    crypto: testmgr - Dynamically allocate xbuf and axbuf
    
    We currently allocate temporary memory that is used for testing
    statically.  This renders the testing engine non-reentrant. As
    algorithms may nest, i.e., one may construct another in order to
    carry out a part of its operation, this is unacceptable.  For
    example, it has been reported that an AEAD implementation allocates
    a cipher in its setkey function, which causes it to fail during
    testing as the temporary memory is overwritten.
    
    This patch replaces the static memory with dynamically allocated
    buffers.  We need a maximum of 16 pages so this slightly increases
    the chances of an algorithm failing due to memory shortage.
    However, as testing usually occurs at registration, this shouldn't
    be a big problem.
    
    Reported-by: Shasi Pulijala <spulijala@amcc.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 6906f92..9908dd8 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -280,29 +280,13 @@ static struct notifier_block cryptomgr_notifier = {
 
 static int __init cryptomgr_init(void)
 {
-	int err;
-
-	err = testmgr_init();
-	if (err)
-		return err;
-
-	err = crypto_register_notifier(&cryptomgr_notifier);
-	if (err)
-		goto free_testmgr;
-
-	return 0;
-
-free_testmgr:
-	testmgr_exit();
-	return err;
+	return crypto_register_notifier(&cryptomgr_notifier);
 }
 
 static void __exit cryptomgr_exit(void)
 {
 	int err = crypto_unregister_notifier(&cryptomgr_notifier);
 	BUG_ON(err);
-
-	testmgr_exit();
 }
 
 subsys_initcall(cryptomgr_init);
diff --git a/crypto/internal.h b/crypto/internal.h
index fc76e1f..113579a 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -121,9 +121,6 @@ int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
 int crypto_probing_notify(unsigned long val, void *v);
 
-int __init testmgr_init(void);
-void testmgr_exit(void);
-
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
 	if (atomic_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e76af78..c555094 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -107,9 +107,6 @@ struct alg_test_desc {
 
 static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 
-static char *xbuf[XBUFSIZE];
-static char *axbuf[XBUFSIZE];
-
 static void hexdump(unsigned char *buf, unsigned int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
@@ -128,6 +125,33 @@ static void tcrypt_complete(struct crypto_async_request *req, int err)
 	complete(&res->completion);
 }
 
+static int testmgr_alloc_buf(char *buf[XBUFSIZE])
+{
+	int i;
+
+	for (i = 0; i < XBUFSIZE; i++) {
+		buf[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!buf[i])
+			goto err_free_buf;
+	}
+
+	return 0;
+
+err_free_buf:
+	while (i-- > 0)
+		free_page((unsigned long)buf[i]);
+
+	return -ENOMEM;
+}
+
+static void testmgr_free_buf(char *buf[XBUFSIZE])
+{
+	int i;
+
+	for (i = 0; i < XBUFSIZE; i++)
+		free_page((unsigned long)buf[i]);
+}
+
 static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		     unsigned int tcount)
 {
@@ -137,8 +161,12 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 	char result[64];
 	struct ahash_request *req;
 	struct tcrypt_result tresult;
-	int ret;
 	void *hash_buff;
+	char *xbuf[XBUFSIZE];
+	int ret = -ENOMEM;
+
+	if (testmgr_alloc_buf(xbuf))
+		goto out_nobuf;
 
 	init_completion(&tresult.completion);
 
@@ -146,7 +174,6 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 	if (!req) {
 		printk(KERN_ERR "alg: hash: Failed to allocate request for "
 		       "%s\n", algo);
-		ret = -ENOMEM;
 		goto out_noreq;
 	}
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
@@ -272,6 +299,8 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 out:
 	ahash_request_free(req);
 out_noreq:
+	testmgr_free_buf(xbuf);
+out_nobuf:
 	return ret;
 }
 
@@ -280,7 +309,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
 	unsigned int i, j, k, n, temp;
-	int ret = 0;
+	int ret = -ENOMEM;
 	char *q;
 	char *key;
 	struct aead_request *req;
@@ -292,6 +321,13 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 	void *input;
 	void *assoc;
 	char iv[MAX_IVLEN];
+	char *xbuf[XBUFSIZE];
+	char *axbuf[XBUFSIZE];
+
+	if (testmgr_alloc_buf(xbuf))
+		goto out_noxbuf;
+	if (testmgr_alloc_buf(axbuf))
+		goto out_noaxbuf;
 
 	if (enc == ENCRYPT)
 		e = "encryption";
@@ -304,7 +340,6 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 	if (!req) {
 		printk(KERN_ERR "alg: aead: Failed to allocate request for "
 		       "%s\n", algo);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -581,6 +616,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 out:
 	aead_request_free(req);
+	testmgr_free_buf(axbuf);
+out_noaxbuf:
+	testmgr_free_buf(xbuf);
+out_noxbuf:
 	return ret;
 }
 
@@ -589,10 +628,14 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_cipher_tfm(tfm));
 	unsigned int i, j, k;
-	int ret;
 	char *q;
 	const char *e;
 	void *data;
+	char *xbuf[XBUFSIZE];
+	int ret = -ENOMEM;
+
+	if (testmgr_alloc_buf(xbuf))
+		goto out_nobuf;
 
 	if (enc == ENCRYPT)
 	        e = "encryption";
@@ -646,6 +689,8 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 	ret = 0;
 
 out:
+	testmgr_free_buf(xbuf);
+out_nobuf:
 	return ret;
 }
 
@@ -655,7 +700,6 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 	const char *algo =
 		crypto_tfm_alg_driver_name(crypto_ablkcipher_tfm(tfm));
 	unsigned int i, j, k, n, temp;
-	int ret;
 	char *q;
 	struct ablkcipher_request *req;
 	struct scatterlist sg[8];
@@ -663,6 +707,11 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 	struct tcrypt_result result;
 	void *data;
 	char iv[MAX_IVLEN];
+	char *xbuf[XBUFSIZE];
+	int ret = -ENOMEM;
+
+	if (testmgr_alloc_buf(xbuf))
+		goto out_nobuf;
 
 	if (enc == ENCRYPT)
 	        e = "encryption";
@@ -675,7 +724,6 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 	if (!req) {
 		printk(KERN_ERR "alg: skcipher: Failed to allocate request "
 		       "for %s\n", algo);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -860,6 +908,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 out:
 	ablkcipher_request_free(req);
+	testmgr_free_buf(xbuf);
+out_nobuf:
 	return ret;
 }
 
@@ -2245,41 +2295,3 @@ notest:
 	return 0;
 }
 EXPORT_SYMBOL_GPL(alg_test);
-
-int __init testmgr_init(void)
-{
-	int i;
-
-	for (i = 0; i < XBUFSIZE; i++) {
-		xbuf[i] = (void *)__get_free_page(GFP_KERNEL);
-		if (!xbuf[i])
-			goto err_free_xbuf;
-	}
-
-	for (i = 0; i < XBUFSIZE; i++) {
-		axbuf[i] = (void *)__get_free_page(GFP_KERNEL);
-		if (!axbuf[i])
-			goto err_free_axbuf;
-	}
-
-	return 0;
-
-err_free_axbuf:
-	for (i = 0; i < XBUFSIZE && axbuf[i]; i++)
-		free_page((unsigned long)axbuf[i]);
-err_free_xbuf:
-	for (i = 0; i < XBUFSIZE && xbuf[i]; i++)
-		free_page((unsigned long)xbuf[i]);
-
-	return -ENOMEM;
-}
-
-void testmgr_exit(void)
-{
-	int i;
