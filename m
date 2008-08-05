From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Tue, 05 Aug 2008 10:08:44 +0800
Message-ID: <E1KQBye-0004iR-00@gondolin.me.apana.org.au>
References: <40f323d00808041102s276c065fn8db6f5a79fdf7ad1@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, chris.mason@oracle.com,
	dwmw2@infradead.org, austin_zhang@linux.intel.com,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: bboissin@gmail.com (Benoit Boissinot)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55054 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751902AbYHECJL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 22:09:11 -0400
In-Reply-To: <40f323d00808041102s276c065fn8db6f5a79fdf7ad1@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Benoit Boissinot <bboissin@gmail.com> wrote:
> 
> Since I couldn't find any ahash user in the tree (outside of tcrypt.c), can you
> provide some example source code as to how to use it (especially synchonously).
> 
> For example the code for the digest_null testing would be fine.

Sure, here is the async hash speed test.  I haven't pushed it
yet because I'm thinking of picking up on David Howells' idea
of creating a sync hash interface that doesn't use scatterlists.

Note that you'll need the appended patch for this to compile as
the partial ahash functions were missing prototypes.

static int test_hash_cycles(struct ahash_request *req, struct scatterlist *sg,
			    int blen, int plen, char *out)
{
	unsigned long cycles = 0;
	int i, pcount;
	int ret;

	if (plen == blen)
		return test_hash_cycles_digest(req, sg, blen, out);

	ahash_request_set_crypt(req, sg, out, plen);

	local_bh_disable();
	local_irq_disable();

	/* Warm-up run. */
	for (i = 0; i < 4; i++) {
		ret = crypto_ahash_init(req);
		if (ret)
			goto out;
		for (pcount = 0; pcount < blen; pcount += plen) {
			ret = crypto_ahash_update(req);
			if (ret)
				goto out;
		}
		ret = crypto_ahash_final(req);
		if (ret)
			goto out;
	}

	/* The real thing. */
	for (i = 0; i < 8; i++) {
		cycles_t start, end;

		start = get_cycles();

		ret = crypto_ahash_init(req);
		if (ret)
			goto out;
		for (pcount = 0; pcount < blen; pcount += plen) {
			ret = crypto_ahash_update(req);
			if (ret)
				goto out;
		}
		ret = crypto_ahash_final(req);
		if (ret)
			goto out;

		end = get_cycles();

		cycles += end - start;
	}

out:
	local_irq_enable();
	local_bh_enable();

	if (ret)
		return ret;

	printk("%6lu cycles/operation, %4lu cycles/byte\n",
	       cycles / 8, cycles / (8 * blen));

	return 0;
}

static void test_hash_speed(const char *algo, unsigned int sec,
			    struct hash_speed *speed)
{
	struct scatterlist sg[TVMEMSIZE];
	struct crypto_ahash *tfm;
	char output[1024];
	int i;
	int ret;

	printk("\ntesting speed of %s\n", algo);

	tfm = crypto_alloc_ahash(algo, 0, CRYPTO_ALG_ASYNC);

	if (IS_ERR(tfm)) {
		printk("failed to load transform for %s: %ld\n", algo,
		       PTR_ERR(tfm));
		return;
	}

{
	struct {
		struct ahash_request req;
		char ctx[crypto_ahash_reqsize(tfm)];
	} req;

	ahash_request_set_tfm(&req.req, tfm);
	ahash_request_set_callback(&req.req, 0, NULL, NULL);

	if (crypto_ahash_digestsize(tfm) > sizeof(output)) {
		printk("digestsize(%u) > outputbuffer(%zu)\n",
		       crypto_ahash_digestsize(tfm), sizeof(output));
		goto out;
	}

	sg_init_table(sg, TVMEMSIZE);
	for (i = 0; i < TVMEMSIZE; i++) {
		sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
		memset(tvmem[i], 0xff, PAGE_SIZE);
	}

	for (i = 0; speed[i].blen != 0; i++) {
		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
			printk("template (%u) too big for tvmem (%lu)\n",
			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
			goto out;
		}

		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);

		if (sec)
			ret = test_hash_jiffies(&req.req, sg, speed[i].blen,
						speed[i].plen, output, sec);
		else
			ret = test_hash_cycles(&req.req, sg, speed[i].blen,
					       speed[i].plen, output);

		if (ret) {
			printk("hashing failed ret=%d\n", ret);
			break;
		}
	}
}

out:
	crypto_free_ahash(tfm);
}

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index d12498e..ee48ef8 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -101,6 +101,24 @@ static inline int crypto_ahash_digest(struct ahash_request *req)
 	return crt->digest(req);
 }
 
+static inline int crypto_ahash_init(struct ahash_request *req)
+{
+	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
+	return crt->init(req);
+}
+
+static inline int crypto_ahash_update(struct ahash_request *req)
+{
+	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
+	return crt->update(req);
+}
+
+static inline int crypto_ahash_final(struct ahash_request *req)
+{
+	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
+	return crt->final(req);
+}
+
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
