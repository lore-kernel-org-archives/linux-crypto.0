From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Fri, 13 Aug 2010 17:56:24 -0500
Message-ID: <20100813175624.84657c76.kim.phillips@freescale.com>
References: <4C63DF4C.1020501@gmail.com>
	<20100812.153208.48514514.davem@davemloft.net>
	<4C6529E1.8020300@gmail.com>
	<20100813.144537.102558594.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: mcuelenaere@gmail.com, kmpark@infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.hengli.com.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:46207
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284Ab0HNNDA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Aug 2010 09:03:00 -0400
In-Reply-To: <20100813.144537.102558594.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 13 Aug 2010 14:45:37 -0700
David Miller <davem@davemloft.net> wrote:

> From: Maurus Cuelenaere <mcuelenaere@gmail.com>
> Date: Fri, 13 Aug 2010 13:17:53 +0200
> 
> >  Op 13-08-10 00:32, David Miller schreef:
> >> From: Maurus Cuelenaere <mcuelenaere@gmail.com>
> >> Date: Thu, 12 Aug 2010 13:47:24 +0200
> >>
> >> tcrypt can validate async crypto algorithms, but cannot performance
> >> test them just yet.  I can performance test async hash algorithms,
> >> for which I added the code for a few months ago.
> > Hmm ok, I suppose implementing support for performance testing async crypto
> > algorithms isn't trivial?
> 
> It shouldn't be that hard, the issue is simply that nobody has put
> the time in to do the work yet.

I wrote the following a long time ago for a customer, yet didn't have
the time (and I still don't have the time) to fix it up and submit it:

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a890a67..7be35ca 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -44,6 +44,7 @@
  * Used by test_cipher_speed()
  */
 static unsigned int sec;
+static atomic_t reqs_in_progress;
 
 static char *alg = NULL;
 static u32 type;
@@ -59,30 +60,55 @@ static char *check[] = {
 	"lzo", "cts", "zlib", NULL
 };
 
-static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
+static int test_cipher_jiffies(struct ablkcipher_request *req, int enc,
 			       struct scatterlist *sg, int blen, int sec)
 {
 	unsigned long start, end;
 	int bcount;
+	unsigned int inprogress_max;
 	int ret;
+	int completion_wait;
+
+	atomic_set(&reqs_in_progress, 0);
+	inprogress_max = 0;
 
 	for (start = jiffies, end = start + sec * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
 		if (enc)
-			ret = crypto_blkcipher_encrypt(desc, sg, sg, blen);
+			ret = crypto_ablkcipher_encrypt(req);
 		else
-			ret = crypto_blkcipher_decrypt(desc, sg, sg, blen);
+			ret = crypto_ablkcipher_decrypt(req);
 
-		if (ret)
+		switch (ret) {
+		case -EINPROGRESS:
+			atomic_inc(&reqs_in_progress);
+			inprogress_max = max(inprogress_max, (unsigned int)
+					     atomic_read(&reqs_in_progress));
+			break;
+		case -EAGAIN:
+			bcount--;
+			break;
+		case 0: break;
+		default:
+			printk("%s %d: bad ret: %d\n", __func__, __LINE__, ret);
 			return ret;
+		}
 	}
 
+	while (atomic_read(&reqs_in_progress) != 0)
+		cpu_relax();
+
+	completion_wait = jiffies - end;
 	printk("%d operations in %d seconds (%ld bytes)\n",
 	       bcount, sec, (long)bcount * blen);
+	printk("inprogress_max %d\n", inprogress_max);
+	printk("jiffies waiting for all to finish: %d (%dHZ)\n",
+	       completion_wait, HZ);
+
 	return 0;
 }
 
-static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
+static int test_cipher_cycles(struct ablkcipher_request *req, int enc,
 			      struct scatterlist *sg, int blen)
 {
 	unsigned long cycles = 0;
@@ -95,9 +121,9 @@ static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
 		if (enc)
-			ret = crypto_blkcipher_encrypt(desc, sg, sg, blen);
+			ret = crypto_ablkcipher_encrypt(req);
 		else
-			ret = crypto_blkcipher_decrypt(desc, sg, sg, blen);
+			ret = crypto_ablkcipher_decrypt(req);
 
 		if (ret)
 			goto out;
@@ -109,9 +135,9 @@ static int test_cipher_cycles(struct blkcipher_desc *desc, int enc,
 
 		start = get_cycles();
 		if (enc)
-			ret = crypto_blkcipher_encrypt(desc, sg, sg, blen);
+			ret = crypto_ablkcipher_encrypt(req);
 		else
-			ret = crypto_blkcipher_decrypt(desc, sg, sg, blen);
+			ret = crypto_ablkcipher_decrypt(req);
 		end = get_cycles();
 
 		if (ret)
@@ -133,14 +159,19 @@ out:
 
 static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
 
+static void ablkcipher_done(struct crypto_async_request *req, int err)
+{
+	atomic_dec(&reqs_in_progress);
+}
+
 static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 			      struct cipher_speed_template *template,
 			      unsigned int tcount, u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
 	const char *key, iv[128];
-	struct crypto_blkcipher *tfm;
-	struct blkcipher_desc desc;
+	struct crypto_ablkcipher *tfm;
+	struct ablkcipher_request req;
 	const char *e;
 	u32 *b_size;
 
@@ -151,15 +182,17 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 
 	printk("\ntesting speed of %s %s\n", algo, e);
 
-	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
 
 	if (IS_ERR(tfm)) {
 		printk("failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		return;
 	}
-	desc.tfm = tfm;
-	desc.flags = 0;
+	ablkcipher_request_set_tfm(&req, tfm);
+	crypto_ablkcipher_set_flags(tfm, 0);
+
+	ablkcipher_request_set_callback(&req, 0, ablkcipher_done, NULL);
 
 	i = 0;
 	do {
@@ -189,10 +222,10 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 				}
 			}
 
-			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
+			ret = crypto_ablkcipher_setkey(tfm, key, *keysize);
 			if (ret) {
 				printk("setkey() failed flags=%x\n",
-						crypto_blkcipher_get_flags(tfm));
+						crypto_ablkcipher_get_flags(tfm));
 				goto out;
 			}
 
@@ -204,21 +237,24 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 				memset (tvmem[j], 0xff, PAGE_SIZE);
 			}
 
-			iv_len = crypto_blkcipher_ivsize(tfm);
-			if (iv_len) {
+			iv_len = crypto_ablkcipher_ivsize(tfm);
+			if (iv_len)
 				memset(&iv, 0xff, iv_len);
-				crypto_blkcipher_set_iv(tfm, iv, iv_len);
-			}
+
+			ablkcipher_request_set_crypt(&req, sg, sg, *b_size,
+						     iv_len ? (void *)iv : NULL);
+
 
 			if (sec)
-				ret = test_cipher_jiffies(&desc, enc, sg,
+				ret = test_cipher_jiffies(&req, enc, sg,
 							  *b_size, sec);
 			else
-				ret = test_cipher_cycles(&desc, enc, sg,
+				ret = test_cipher_cycles(&req, enc, sg,
 							 *b_size);
 
 			if (ret) {
-				printk("%s() failed flags=%x\n", e, desc.flags);
+				printk("%s() failed flags=%x\n", e,
+				       crypto_ablkcipher_get_flags(tfm));
 				break;
 			}
 			b_size++;
@@ -228,7 +264,7 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 	} while (*keysize);
 
 out:
-	crypto_free_blkcipher(tfm);
+	crypto_free_ablkcipher(tfm);
 }
 
 static int test_hash_jiffies_digest(struct hash_desc *desc,
