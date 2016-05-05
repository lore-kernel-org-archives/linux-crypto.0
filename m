From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Thu, 5 May 2016 16:42:49 +0800
Message-ID: <20160505084249.GA4971@gondor.apana.org.au>
References: <20160503.123301.298039059390449291.davem@davemloft.net>
 <20160504040731.GA25758@gondor.apana.org.au>
 <CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44064 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbcEEIm4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 04:42:56 -0400
Content-Disposition: inline
In-Reply-To: <CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 05:49:04PM +0300, Anatoly Pugachev wrote:
>
> just tested cryptodev (
> http://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> ) kernel, same OOPS, but kernel version is 4.6.0-rc2+ .
> kernel OOPS message - https://paste.fedoraproject.org/362554/23732641/

Anatoly, could you please test this patch on top of cryptodev?
Thanks!

---8<---
Subject: crypto: testmgr - Use kmalloc memory for RSA input

As akcipher uses an SG interface, you must not use vmalloc memory
as input for it.  This patch fixes testmgr to copy the vmalloc
test vectors to kmalloc memory before running the test.

This patch also removes a superfluous sg_virt call in do_test_rsa.

Cc: <stable@vger.kernel.org>
Reported-by: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fcd89fe..c727fb0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1780,6 +1780,7 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 static int do_test_rsa(struct crypto_akcipher *tfm,
 		       struct akcipher_testvec *vecs)
 {
+	char *xbuf[XBUFSIZE];
 	struct akcipher_request *req;
 	void *outbuf_enc = NULL;
 	void *outbuf_dec = NULL;
@@ -1788,9 +1789,12 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	int err = -ENOMEM;
 	struct scatterlist src, dst, src_tab[2];
 
+	if (testmgr_alloc_buf(xbuf))
+		return err;
+
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
-		return err;
+		goto free_xbuf;
 
 	init_completion(&result.completion);
 
@@ -1808,9 +1812,14 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	if (!outbuf_enc)
 		goto free_req;
 
+	if (WARN_ON(vecs->m_size > PAGE_SIZE))
+		goto free_all;
+
+	memcpy(xbuf[0], vecs->m, vecs->m_size);
+
 	sg_init_table(src_tab, 2);
-	sg_set_buf(&src_tab[0], vecs->m, 8);
-	sg_set_buf(&src_tab[1], vecs->m + 8, vecs->m_size - 8);
+	sg_set_buf(&src_tab[0], xbuf[0], 8);
+	sg_set_buf(&src_tab[1], xbuf[0] + 8, vecs->m_size - 8);
 	sg_init_one(&dst, outbuf_enc, out_len_max);
 	akcipher_request_set_crypt(req, src_tab, &dst, vecs->m_size,
 				   out_len_max);
@@ -1829,7 +1838,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		goto free_all;
 	}
 	/* verify that encrypted message is equal to expected */
-	if (memcmp(vecs->c, sg_virt(req->dst), vecs->c_size)) {
+	if (memcmp(vecs->c, outbuf_enc, vecs->c_size)) {
 		pr_err("alg: rsa: encrypt test failed. Invalid output\n");
 		err = -EINVAL;
 		goto free_all;
@@ -1844,7 +1853,13 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		err = -ENOMEM;
 		goto free_all;
 	}
-	sg_init_one(&src, vecs->c, vecs->c_size);
+
+	if (WARN_ON(vecs->c_size > PAGE_SIZE))
+		goto free_all;
+
+	memcpy(xbuf[0], vecs->c, vecs->c_size);
+
+	sg_init_one(&src, xbuf[0], vecs->c_size);
 	sg_init_one(&dst, outbuf_dec, out_len_max);
 	init_completion(&result.completion);
 	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max);
@@ -1871,6 +1886,8 @@ free_all:
 	kfree(outbuf_enc);
 free_req:
 	akcipher_request_free(req);
+free_xbuf:
+	testmgr_free_buf(xbuf);
 	return err;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
