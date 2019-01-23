Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F3BC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA8B2184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284000;
	bh=KMB0BfXZo4nvXE/WOA2+BhNv1NRJ0JiVud+mNhTz9Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YYTHdIjCS9aystXOjf8ryKtG/tUFn3HIQbdiwmHkoWdiLdVVN0XLbp84S3UAWIWKT
	 J8LJGkiwyEyU86pCfpuHqliydfK0ttjKrijgk+ZlMkmsqlN9BlMCWVr3SuTpi3ji8C
	 zNZlYr6yNrV13U8zc00NK2xqSXnVS6eVzjNl0Z1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfAWWxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbfAWWwg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:36 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F1A2184C;
        Wed, 23 Jan 2019 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283954;
        bh=KMB0BfXZo4nvXE/WOA2+BhNv1NRJ0JiVud+mNhTz9Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6sSsNJKSTitAi9s8JkugvZMbJWo688S4G6Oh4kDOoxRy3Np2BVnUDgD7xeYX7yYv
         rqhHlfNzQRWeKvz86Ziu9MWINBPM4x0BqbancVS+N8tE8xoobLgdH/aO6q3mlbKICI
         DeCmJcwdwqdYmJ1Mm5pBdKijtorENm1og23rWg08=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 12/15] crypto: testmgr - convert aead testing to use testvec_configs
Date:   Wed, 23 Jan 2019 14:49:23 -0800
Message-Id: <20190123224926.250525-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert alg_test_aead() to use the new test framework, using the same
list of testvec_configs that skcipher testing uses.

This significantly improves AEAD test coverage mainly because previously
there was only very limited test coverage of the possible data layouts.
Now the data layouts to test are listed in one place for all algorithms
and optionally are also randomly generated.  In fact, only one AEAD
algorithm (AES-GCM) even had a chunked test case before.

This already detected bugs in all the AEGIS and MORUS implementations as
well as the AES-NI GCM implementation.

I removed the AEAD chunked test vectors that were the same as
non-chunked ones, but left the ones that were unique.

Note: the rewritten test code allocates an aead_request just once per
algorithm rather than once per encryption/decryption, but some AEAD
algorithms incorrectly change the tfm pointer in the request.  It's
nontrivial to fix these, so to move forward I'm temporarily working
around it by resetting the tfm pointer.  But they'll need to be fixed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 613 ++++++++++++++---------------------------------
 crypto/testmgr.h |  47 ----
 2 files changed, 185 insertions(+), 475 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fd3fed8eee4e..0c70d8678afb 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1208,443 +1208,222 @@ static int test_hash(struct crypto_ahash *tfm,
 	return 0;
 }
 
-static int __test_aead(struct crypto_aead *tfm, int enc,
-		       const struct aead_testvec *template, unsigned int tcount,
-		       const bool diff_dst, const int align_offset)
+static int test_aead_vec_cfg(const char *driver, int enc,
+			     const struct aead_testvec *vec,
+			     unsigned int vec_num,
+			     const struct testvec_config *cfg,
+			     struct aead_request *req,
+			     struct cipher_test_sglists *tsgls)
 {
-	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
-	unsigned int i, j, k, n, temp;
-	int ret = -ENOMEM;
-	char *q;
-	char *key;
-	struct aead_request *req;
-	struct scatterlist *sg;
-	struct scatterlist *sgout;
-	const char *e, *d;
-	struct crypto_wait wait;
-	unsigned int authsize, iv_len;
-	char *iv;
-	char *xbuf[XBUFSIZE];
-	char *xoutbuf[XBUFSIZE];
-	char *axbuf[XBUFSIZE];
-
-	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
-	if (!iv)
-		return ret;
-	key = kmalloc(MAX_KEYLEN, GFP_KERNEL);
-	if (!key)
-		goto out_noxbuf;
-	if (testmgr_alloc_buf(xbuf))
-		goto out_noxbuf;
-	if (testmgr_alloc_buf(axbuf))
-		goto out_noaxbuf;
-	if (diff_dst && testmgr_alloc_buf(xoutbuf))
-		goto out_nooutbuf;
-
-	/* avoid "the frame size is larger than 1024 bytes" compiler warning */
-	sg = kmalloc(array3_size(sizeof(*sg), 8, (diff_dst ? 4 : 2)),
-		     GFP_KERNEL);
-	if (!sg)
-		goto out_nosg;
-	sgout = &sg[16];
-
-	if (diff_dst)
-		d = "-ddst";
-	else
-		d = "";
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const unsigned int alignmask = crypto_aead_alignmask(tfm);
+	const unsigned int ivsize = crypto_aead_ivsize(tfm);
+	const unsigned int authsize = vec->clen - vec->plen;
+	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
+	const char *op = enc ? "encryption" : "decryption";
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 _iv[3 * (MAX_ALGAPI_ALIGNMASK + 1) + MAX_IVLEN];
+	u8 *iv = PTR_ALIGN(&_iv[0], 2 * (MAX_ALGAPI_ALIGNMASK + 1)) +
+		 cfg->iv_offset +
+		 (cfg->iv_offset_relative_to_alignmask ? alignmask : 0);
+	struct kvec input[2];
+	int err;
 
-	if (enc == ENCRYPT)
-		e = "encryption";
+	/* Set the key */
+	if (vec->wk)
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	else
-		e = "decryption";
-
-	crypto_init_wait(&wait);
-
-	req = aead_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		pr_err("alg: aead%s: Failed to allocate request for %s\n",
-		       d, algo);
-		goto out;
+		crypto_aead_clear_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
+	err = crypto_aead_setkey(tfm, vec->key, vec->klen);
+	if (err) {
+		if (vec->fail) /* expectedly failed to set key? */
+			return 0;
+		pr_err("alg: aead: %s setkey failed with err %d on test vector %u; flags=%#x\n",
+		       driver, err, vec_num, crypto_aead_get_flags(tfm));
+		return err;
 	}
-
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
-
-	iv_len = crypto_aead_ivsize(tfm);
-
-	for (i = 0, j = 0; i < tcount; i++) {
-		const char *input, *expected_output;
-		unsigned int inlen, outlen;
-		char *inbuf, *outbuf, *assocbuf;
-
-		if (template[i].np)
-			continue;
-		if (enc) {
-			if (template[i].novrfy)
-				continue;
-			input = template[i].ptext;
-			inlen = template[i].plen;
-			expected_output = template[i].ctext;
-			outlen = template[i].clen;
-		} else {
-			input = template[i].ctext;
-			inlen = template[i].clen;
-			expected_output = template[i].ptext;
-			outlen = template[i].plen;
-		}
-
-		j++;
-
-		/* some templates have no input data but they will
-		 * touch input
-		 */
-		inbuf = xbuf[0] + align_offset;
-		assocbuf = axbuf[0];
-
-		ret = -EINVAL;
-		if (WARN_ON(align_offset + template[i].clen > PAGE_SIZE ||
-			    template[i].alen > PAGE_SIZE))
-			goto out;
-
-		memcpy(inbuf, input, inlen);
-		memcpy(assocbuf, template[i].assoc, template[i].alen);
-		if (template[i].iv)
-			memcpy(iv, template[i].iv, iv_len);
-		else
-			memset(iv, 0, iv_len);
-
-		crypto_aead_clear_flags(tfm, ~0);
-		if (template[i].wk)
-			crypto_aead_set_flags(tfm,
-					      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-
-		if (template[i].klen > MAX_KEYLEN) {
-			pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
-			       d, j, algo, template[i].klen,
-			       MAX_KEYLEN);
-			ret = -EINVAL;
-			goto out;
-		}
-		memcpy(key, template[i].key, template[i].klen);
-
-		ret = crypto_aead_setkey(tfm, key, template[i].klen);
-		if (template[i].fail == !ret) {
-			pr_err("alg: aead%s: setkey failed on test %d for %s: flags=%x\n",
-			       d, j, algo, crypto_aead_get_flags(tfm));
-			goto out;
-		} else if (ret)
-			continue;
-
-		authsize = template[i].clen - template[i].plen;
-		ret = crypto_aead_setauthsize(tfm, authsize);
-		if (ret) {
-			pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
-			       d, authsize, j, algo);
-			goto out;
-		}
-
-		k = !!template[i].alen;
-		sg_init_table(sg, k + 1);
-		sg_set_buf(&sg[0], assocbuf, template[i].alen);
-		sg_set_buf(&sg[k], inbuf, template[i].clen);
-		outbuf = inbuf;
-
-		if (diff_dst) {
-			sg_init_table(sgout, k + 1);
-			sg_set_buf(&sgout[0], assocbuf, template[i].alen);
-
-			outbuf = xoutbuf[0] + align_offset;
-			sg_set_buf(&sgout[k], outbuf, template[i].clen);
-		}
-
-		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg, inlen,
-				       iv);
-
-		aead_request_set_ad(req, template[i].alen);
-
-		ret = crypto_wait_req(enc ? crypto_aead_encrypt(req)
-				      : crypto_aead_decrypt(req), &wait);
-
-		switch (ret) {
-		case 0:
-			if (template[i].novrfy) {
-				/* verification was supposed to fail */
-				pr_err("alg: aead%s: %s failed on test %d for %s: ret was 0, expected -EBADMSG\n",
-				       d, e, j, algo);
-				/* so really, we got a bad message */
-				ret = -EBADMSG;
-				goto out;
-			}
-			break;
-		case -EBADMSG:
-			if (template[i].novrfy)
-				/* verification failure was expected */
-				continue;
-			/* fall through */
-		default:
-			pr_err("alg: aead%s: %s failed on test %d for %s: ret=%d\n",
-			       d, e, j, algo, -ret);
-			goto out;
-		}
-
-		if (memcmp(outbuf, expected_output, outlen)) {
-			pr_err("alg: aead%s: Test %d failed on %s for %s\n",
-			       d, j, e, algo);
-			hexdump(outbuf, outlen);
-			ret = -EINVAL;
-			goto out;
-		}
+	if (vec->fail) {
+		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %u\n",
+		       driver, vec_num);
+		return -EINVAL;
 	}
 
-	for (i = 0, j = 0; i < tcount; i++) {
-		const char *input, *expected_output;
-		unsigned int inlen, outlen;
-
-		/* alignment tests are only done with continuous buffers */
-		if (align_offset != 0)
-			break;
-
-		if (!template[i].np)
-			continue;
-
-		if (enc) {
-			if (template[i].novrfy)
-				continue;
-			input = template[i].ptext;
-			inlen = template[i].plen;
-			expected_output = template[i].ctext;
-			outlen = template[i].clen;
-		} else {
-			input = template[i].ctext;
-			inlen = template[i].clen;
-			expected_output = template[i].ptext;
-			outlen = template[i].plen;
-		}
-
-		j++;
-
-		if (template[i].iv)
-			memcpy(iv, template[i].iv, iv_len);
-		else
-			memset(iv, 0, MAX_IVLEN);
-
-		crypto_aead_clear_flags(tfm, ~0);
-		if (template[i].wk)
-			crypto_aead_set_flags(tfm,
-					      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-		if (template[i].klen > MAX_KEYLEN) {
-			pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
-			       d, j, algo, template[i].klen, MAX_KEYLEN);
-			ret = -EINVAL;
-			goto out;
-		}
-		memcpy(key, template[i].key, template[i].klen);
-
-		ret = crypto_aead_setkey(tfm, key, template[i].klen);
-		if (template[i].fail == !ret) {
-			pr_err("alg: aead%s: setkey failed on chunk test %d for %s: flags=%x\n",
-			       d, j, algo, crypto_aead_get_flags(tfm));
-			goto out;
-		} else if (ret)
-			continue;
-
-		authsize = template[i].clen - template[i].plen;
-
-		ret = -EINVAL;
-		sg_init_table(sg, template[i].anp + template[i].np);
-		if (diff_dst)
-			sg_init_table(sgout, template[i].anp + template[i].np);
-
-		ret = -EINVAL;
-		for (k = 0, temp = 0; k < template[i].anp; k++) {
-			if (WARN_ON(offset_in_page(IDX[k]) +
-				    template[i].atap[k] > PAGE_SIZE))
-				goto out;
-			sg_set_buf(&sg[k],
-				   memcpy(axbuf[IDX[k] >> PAGE_SHIFT] +
-					  offset_in_page(IDX[k]),
-					  template[i].assoc + temp,
-					  template[i].atap[k]),
-				   template[i].atap[k]);
-			if (diff_dst)
-				sg_set_buf(&sgout[k],
-					   axbuf[IDX[k] >> PAGE_SHIFT] +
-					   offset_in_page(IDX[k]),
-					   template[i].atap[k]);
-			temp += template[i].atap[k];
-		}
-
-		for (k = 0, temp = 0; k < template[i].np; k++) {
-			n = template[i].tap[k];
-			if (k == template[i].np - 1 && !enc)
-				n += authsize;
-
-			if (WARN_ON(offset_in_page(IDX[k]) + n > PAGE_SIZE))
-				goto out;
-
-			q = xbuf[IDX[k] >> PAGE_SHIFT] + offset_in_page(IDX[k]);
-			memcpy(q, input + temp, n);
-			sg_set_buf(&sg[template[i].anp + k], q, n);
-
-			if (diff_dst) {
-				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
-
-				memset(q, 0, n);
-
-				sg_set_buf(&sgout[template[i].anp + k], q, n);
-			}
-
-			if (k == template[i].np - 1 && enc)
-				n += authsize;
-			if (offset_in_page(q) + n < PAGE_SIZE)
-				q[n] = 0;
-
-			temp += n;
-		}
+	/* Set the authentication tag size */
+	err = crypto_aead_setauthsize(tfm, authsize);
+	if (err) {
+		pr_err("alg: aead: %s setauthsize failed with err %d on test vector %u\n",
+		       driver, err, vec_num);
+		return err;
+	}
 
-		ret = crypto_aead_setauthsize(tfm, authsize);
-		if (ret) {
-			pr_err("alg: aead%s: Failed to set authsize to %u on chunk test %d for %s\n",
-			       d, authsize, j, algo);
-			goto out;
-		}
+	/* The IV must be copied to a buffer, as the algorithm may modify it */
+	if (WARN_ON(ivsize > MAX_IVLEN))
+		return -EINVAL;
+	if (vec->iv)
+		memcpy(iv, vec->iv, ivsize);
+	else
+		memset(iv, 0, ivsize);
 
-		if (enc) {
-			if (WARN_ON(sg[template[i].anp + k - 1].offset +
-				    sg[template[i].anp + k - 1].length +
-				    authsize > PAGE_SIZE)) {
-				ret = -EINVAL;
-				goto out;
-			}
+	/* Build the src/dst scatterlists */
+	input[0].iov_base = (void *)vec->assoc;
+	input[0].iov_len = vec->alen;
+	input[1].iov_base = enc ? (void *)vec->ptext : (void *)vec->ctext;
+	input[1].iov_len = enc ? vec->plen : vec->clen;
+	err = build_cipher_test_sglists(tsgls, cfg, alignmask,
+					vec->alen + (enc ? vec->plen :
+						     vec->clen),
+					vec->alen + (enc ? vec->clen :
+						     vec->plen),
+					input, 2);
+	if (err) {
+		pr_err("alg: aead: %s %s: error preparing scatterlists for test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return err;
+	}
 
-			if (diff_dst)
-				sgout[template[i].anp + k - 1].length +=
-					authsize;
-			sg[template[i].anp + k - 1].length += authsize;
-		}
+	/* Do the actual encryption or decryption */
+	testmgr_poison(req->__ctx, crypto_aead_reqsize(tfm));
+	aead_request_set_callback(req, req_flags, crypto_req_done, &wait);
+	aead_request_set_crypt(req, tsgls->src.sgl_ptr, tsgls->dst.sgl_ptr,
+			       enc ? vec->plen : vec->clen, iv);
+	aead_request_set_ad(req, vec->alen);
+	err = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
+			      crypto_aead_decrypt(req), &wait);
 
-		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-				       inlen, iv);
+	aead_request_set_tfm(req, tfm); /* TODO: get rid of this */
 
-		aead_request_set_ad(req, template[i].alen);
+	if (err) {
+		if (err == -EBADMSG && vec->novrfy)
+			return 0;
+		pr_err("alg: aead: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
+		       driver, op, err, vec_num, cfg->name);
+		return err;
+	}
+	if (vec->novrfy) {
+		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
 
-		ret = crypto_wait_req(enc ? crypto_aead_encrypt(req)
-				      : crypto_aead_decrypt(req), &wait);
+	/* Check for the correct output (ciphertext or plaintext) */
+	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
+				    enc ? vec->clen : vec->plen,
+				    vec->alen, enc || !cfg->inplace);
+	if (err == -EOVERFLOW) {
+		pr_err("alg: aead: %s %s overran dst buffer on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return err;
+	}
+	if (err) {
+		pr_err("alg: aead: %s %s test failed (wrong result) on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return err;
+	}
 
-		switch (ret) {
-		case 0:
-			if (template[i].novrfy) {
-				/* verification was supposed to fail */
-				pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret was 0, expected -EBADMSG\n",
-				       d, e, j, algo);
-				/* so really, we got a bad message */
-				ret = -EBADMSG;
-				goto out;
-			}
-			break;
-		case -EBADMSG:
-			if (template[i].novrfy)
-				/* verification failure was expected */
-				continue;
-			/* fall through */
-		default:
-			pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret=%d\n",
-			       d, e, j, algo, -ret);
-			goto out;
-		}
+	return 0;
+}
 
-		ret = -EINVAL;
-		for (k = 0, temp = 0; k < template[i].np; k++) {
-			if (diff_dst)
-				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
-			else
-				q = xbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
+static int test_aead_vec(const char *driver, int enc,
+			 const struct aead_testvec *vec, unsigned int vec_num,
+			 struct aead_request *req,
+			 struct cipher_test_sglists *tsgls)
+{
+	unsigned int i;
+	int err;
 
-			n = template[i].tap[k];
-			if (k == template[i].np - 1 && enc)
-				n += authsize;
+	if (enc && vec->novrfy)
+		return 0;
 
-			if (memcmp(q, expected_output + temp, n)) {
-				pr_err("alg: aead%s: Chunk test %d failed on %s at page %u for %s\n",
-				       d, j, e, k, algo);
-				hexdump(q, n);
-				goto out;
-			}
+	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++) {
+		err = test_aead_vec_cfg(driver, enc, vec, vec_num,
+					&default_cipher_testvec_configs[i],
+					req, tsgls);
+		if (err)
+			return err;
+	}
 
-			q += n;
-			if (k == template[i].np - 1 && !enc) {
-				if (!diff_dst && memcmp(q, input + temp + n,
-							authsize))
-					n = authsize;
-				else
-					n = 0;
-			} else {
-				for (n = 0; offset_in_page(q + n) && q[n]; n++)
-					;
-			}
-			if (n) {
-				pr_err("alg: aead%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
-				       d, j, e, k, algo, n);
-				hexdump(q, n);
-				goto out;
-			}
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+	if (!noextratests) {
+		struct testvec_config cfg;
+		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
-			temp += template[i].tap[k];
+		for (i = 0; i < fuzz_iterations; i++) {
+			generate_random_testvec_config(&cfg, cfgname,
+						       sizeof(cfgname));
+			err = test_aead_vec_cfg(driver, enc, vec, vec_num,
+						&cfg, req, tsgls);
+			if (err)
+				return err;
 		}
 	}
+#endif
+	return 0;
+}
 
-	ret = 0;
+static int test_aead(const char *driver, int enc,
+		     const struct aead_test_suite *suite,
+		     struct aead_request *req,
+		     struct cipher_test_sglists *tsgls)
+{
+	unsigned int i;
+	int err;
 
-out:
-	aead_request_free(req);
-	kfree(sg);
-out_nosg:
-	if (diff_dst)
-		testmgr_free_buf(xoutbuf);
-out_nooutbuf:
-	testmgr_free_buf(axbuf);
-out_noaxbuf:
-	testmgr_free_buf(xbuf);
-out_noxbuf:
-	kfree(key);
-	kfree(iv);
-	return ret;
+	for (i = 0; i < suite->count; i++) {
+		err = test_aead_vec(driver, enc, &suite->vecs[i], i, req,
+				    tsgls);
+		if (err)
+			return err;
+	}
+	return 0;
 }
 
-static int test_aead(struct crypto_aead *tfm, int enc,
-		     const struct aead_testvec *template, unsigned int tcount)
+static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
 {
-	unsigned int alignmask;
-	int ret;
+	const struct aead_test_suite *suite = &desc->suite.aead;
+	struct crypto_aead *tfm;
+	struct aead_request *req = NULL;
+	struct cipher_test_sglists *tsgls = NULL;
+	int err;
 
-	/* test 'dst == src' case */
-	ret = __test_aead(tfm, enc, template, tcount, false, 0);
-	if (ret)
-		return ret;
+	if (suite->count <= 0) {
+		pr_err("alg: aead: empty test suite for %s\n", driver);
+		return -EINVAL;
+	}
 
-	/* test 'dst != src' case */
-	ret = __test_aead(tfm, enc, template, tcount, true, 0);
-	if (ret)
-		return ret;
+	tfm = crypto_alloc_aead(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
 
-	/* test unaligned buffers, check with one byte offset */
-	ret = __test_aead(tfm, enc, template, tcount, true, 1);
-	if (ret)
-		return ret;
+	req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("alg: aead: failed to allocate request for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
+	}
 
-	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
-	if (alignmask) {
-		/* Check if alignment mask for tfm is correctly set. */
-		ret = __test_aead(tfm, enc, template, tcount, true,
-				  alignmask + 1);
-		if (ret)
-			return ret;
+	tsgls = alloc_cipher_test_sglists();
+	if (!tsgls) {
+		pr_err("alg: aead: failed to allocate test buffers for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
 	}
 
-	return 0;
+	err = test_aead(driver, ENCRYPT, suite, req, tsgls);
+	if (err)
+		goto out;
+
+	err = test_aead(driver, DECRYPT, suite, req, tsgls);
+out:
+	free_cipher_test_sglists(tsgls);
+	aead_request_free(req);
+	crypto_free_aead(tfm);
+	return err;
 }
 
 static int test_cipher(struct crypto_cipher *tfm, int enc,
@@ -2274,28 +2053,6 @@ static int test_cprng(struct crypto_rng *tfm,
 	return err;
 }
 
-static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
-			 u32 type, u32 mask)
-{
-	const struct aead_test_suite *suite = &desc->suite.aead;
-	struct crypto_aead *tfm;
-	int err;
-
-	tfm = crypto_alloc_aead(driver, type, mask);
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
-	err = test_aead(tfm, ENCRYPT, suite->vecs, suite->count);
-	if (!err)
-		err = test_aead(tfm, DECRYPT, suite->vecs, suite->count);
-
-	crypto_free_aead(tfm);
-	return err;
-}
-
 static int alg_test_cipher(const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
 {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 1a73af8a79f7..dfd8059d1306 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -78,10 +78,6 @@ struct cipher_testvec {
  * @ctext:	Pointer to the full authenticated ciphertext.  For AEADs that
  *		produce a separate "ciphertext" and "authentication tag", these
  *		two parts are concatenated: ciphertext || tag.
- * @tap:	How to distribute ptext data in @np SGs
- * @atap:	How to distribute assoc data in @anp SGs
- * @np:		Numbers of SG to distribute ptext data in
- * @anp:	Numbers of SG to distribute assoc data in
  * @fail:	setkey() failure expected?
  * @novrfy:	Decryption verification failure expected?
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
@@ -97,10 +93,6 @@ struct aead_testvec {
 	const char *ptext;
 	const char *assoc;
 	const char *ctext;
-	unsigned char tap[MAX_TAP];
-	unsigned char atap[MAX_TAP];
-	int np;
-	int anp;
 	bool fail;
 	unsigned char novrfy;
 	unsigned char wk;
@@ -16605,41 +16597,6 @@ static const struct aead_testvec aes_gcm_tv_template[] = {
 			  "\x99\x24\xa7\xc8\x58\x73\x36\xbf"
 			  "\xb1\x18\x02\x4d\xb8\x67\x4a\x14",
 		.clen	= 80,
-	}, {
-		.key	= "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
-			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
-			  "\xfe\xff\xe9\x92\x86\x65\x73\x1c",
-		.klen	= 24,
-		.iv	= "\xca\xfe\xba\xbe\xfa\xce\xdb\xad"
-			  "\xde\xca\xf8\x88",
-		.ptext	= "\xd9\x31\x32\x25\xf8\x84\x06\xe5"
-			  "\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
-			  "\x86\xa7\xa9\x53\x15\x34\xf7\xda"
-			  "\x2e\x4c\x30\x3d\x8a\x31\x8a\x72"
-			  "\x1c\x3c\x0c\x95\x95\x68\x09\x53"
-			  "\x2f\xcf\x0e\x24\x49\xa6\xb5\x25"
-			  "\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
-			  "\xba\x63\x7b\x39",
-		.plen	= 60,
-		.assoc	= "\xfe\xed\xfa\xce\xde\xad\xbe\xef"
-			  "\xfe\xed\xfa\xce\xde\xad\xbe\xef"
-			  "\xab\xad\xda\xd2",
-		.alen	= 20,
-		.ctext	= "\x39\x80\xca\x0b\x3c\x00\xe8\x41"
-			  "\xeb\x06\xfa\xc4\x87\x2a\x27\x57"
-			  "\x85\x9e\x1c\xea\xa6\xef\xd9\x84"
-			  "\x62\x85\x93\xb4\x0c\xa1\xe1\x9c"
-			  "\x7d\x77\x3d\x00\xc1\x44\xc5\x25"
-			  "\xac\x61\x9d\x18\xc8\x4a\x3f\x47"
-			  "\x18\xe2\x44\x8b\x2f\xe3\x24\xd9"
-			  "\xcc\xda\x27\x10"
-			  "\x25\x19\x49\x8e\x80\xf1\x47\x8f"
-			  "\x37\xba\x55\xbd\x6d\x27\x61\x8c",
-		.clen	= 76,
-		.np	= 2,
-		.tap	= { 32, 28 },
-		.anp	= 2,
-		.atap	= { 8, 12 }
 	}, {
 		.key    = zeroed_string,
 		.klen	= 32,
@@ -16716,10 +16673,6 @@ static const struct aead_testvec aes_gcm_tv_template[] = {
 			  "\x76\xfc\x6e\xce\x0f\x4e\x17\x68"
 			  "\xcd\xdf\x88\x53\xbb\x2d\x55\x1b",
 		.clen	= 76,
-		.np     = 2,
-		.tap    = { 48, 12 },
-		.anp	= 3,
-		.atap	= { 8, 8, 4 }
 	}, {
 		.key	= "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
 			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08"
-- 
2.20.1.321.g9e740568ce-goog

