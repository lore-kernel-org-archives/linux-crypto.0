Return-Path: <SRS0=EWVs=PV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfAMXeV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jan 2019 18:34:21 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/5] crypto: unify the AEAD encryption and decryption test vectors
Date: Sun, 13 Jan 2019 15:32:23 -0800
Message-Id: <20190113233228.5851-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series makes AEAD encryption and decryption be tested using a
single list of test vectors for each algorithm, similar to what is done
for length-preserving ciphers now (see commit 92a4c9fef34c).

This removes almost 5000 lines of "code", even after copying the unique
AEAD decryption test vectors into the encryption test vectors to ensure
that no test coverage is lost.

The real change is in patch 5/5 which is mostly scripted with awk.
The patch file is 427KB, so it might run into the mailing list limit and
not reach the list.  The full series can be retrieved from branch
"aead-testvec-consolidation" (commit 692a55c17432) of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git

In case it's helpful for review, below I've also included an abbreviated
version of patch 5/5 which includes the commit message and the diff for
just the non-scripted portion of the patch.

Eric Biggers (5):
  crypto: testmgr - skip AEAD encryption test vectors with novrfy set
  crypto: testmgr - add ccm(aes) decryption tests to encryption tests
  crypto: testmgr - add gcm(aes) decryption tests to encryption tests
  crypto: testmgr - add rfc4543(gcm(aes)) decryption test to encryption
    tests
  crypto: testmgr - unify the AEAD encryption and decryption test
    vectors

 crypto/testmgr.c |  257 +-
 crypto/testmgr.h | 7226 ++++++++--------------------------------------
 2 files changed, 1280 insertions(+), 6203 deletions(-)

-- 
2.20.1

[abbreviated patch 5/5, non-scripted changes only]

crypto: testmgr - unify the AEAD encryption and decryption test vectors

Currently testmgr has separate encryption and decryption test vectors
for AEADs.  That's massively redundant, since usually the decryption
tests are identical to the encryption tests, just with the input/result
swapped.  And for some algorithms it was forgotten to add decryption
test vectors, so for them currently only encryption is being tested.

Therefore, eliminate the redundancy by removing the AEAD decryption test
vectors and updating testmgr to test both AEAD encryption and decryption
using what used to be the encryption test vectors.  Naming is adjusted
accordingly: each aead_testvec now has a 'ptext' (plaintext), 'plen'
(plaintext length), 'ctext' (ciphertext), and 'clen' (ciphertext length)
instead of an 'input', 'ilen', 'result', and 'rlen'.  "Ciphertext" here
refers to the full ciphertext, including the authentication tag.

For now the scatterlist divisions are just given for the plaintext
length, not also the ciphertext length.  For decryption, the last
scatterlist element is just extended by the authentication tag length.

In total, this removes over 5000 lines from testmgr.h, with no reduction
in test coverage since prior patches already copied the few unique
decryption test vectors into the encryption test vectors.

The testmgr.h portion of this patch was automatically generated using
the following awk script, except that I also manually updated the
definition of 'struct aead_testvec' and fixed the location of the
comment describing the AEGIS-128 test vectors.

    BEGIN { OTHER = 0; ENCVEC = 1; DECVEC = 2; DECVEC_TAIL = 3; mode = OTHER }

    /^static const struct aead_testvec.*_enc_/ { sub("_enc", ""); mode = ENCVEC }
    /^static const struct aead_testvec.*_dec_/ { mode = DECVEC }
    mode == ENCVEC {
        sub(/\.input[[:space:]]*=/,     ".ptext\t=")
        sub(/\.result[[:space:]]*=/,    ".ctext\t=")
        sub(/\.ilen[[:space:]]*=/,      ".plen\t=")
        sub(/\.rlen[[:space:]]*=/,      ".clen\t=")
        print
    }
    mode == DECVEC_TAIL && /[^[:space:]]/ { mode = OTHER }
    mode == OTHER                         { print }
    mode == ENCVEC && /^};/               { mode = OTHER }
    mode == DECVEC && /^};/               { mode = DECVEC_TAIL }

Note that git's default diff algorithm gets confused by the testmgr.h
portion of this patch, and reports too many lines added and removed.
It's better viewed with 'git diff --minimal' (or 'git show --minimal'),
which reports "2 files changed, 1235 insertions(+), 6491 deletions(-)".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c |  260 +-
 crypto/testmgr.h | 7466 +++++++---------------------------------------
 2 files changed, 1235 insertions(+), 6491 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e075b896c0290..7b8bb2c29980f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -77,10 +77,8 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 #define DECRYPT 0
 
 struct aead_test_suite {
-	struct {
-		const struct aead_testvec *vecs;
-		unsigned int count;
-	} enc, dec;
+	const struct aead_testvec *vecs;
+	unsigned int count;
 };
 
 struct cipher_test_suite {
@@ -616,9 +614,6 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	const char *e, *d;
 	struct crypto_wait wait;
 	unsigned int authsize, iv_len;
-	void *input;
-	void *output;
-	void *assoc;
 	char *iv;
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
@@ -669,27 +664,41 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	iv_len = crypto_aead_ivsize(tfm);
 
 	for (i = 0, j = 0; i < tcount; i++) {
+		const char *input, *expected_output;
+		unsigned int inlen, outlen;
+		char *inbuf, *outbuf, *assocbuf;
+
 		if (template[i].np)
 			continue;
-		if (enc && template[i].novrfy)
-			continue;
+		if (enc) {
+			if (template[i].novrfy)
+				continue;
+			input = template[i].ptext;
+			inlen = template[i].plen;
+			expected_output = template[i].ctext;
+			outlen = template[i].clen;
+		} else {
+			input = template[i].ctext;
+			inlen = template[i].clen;
+			expected_output = template[i].ptext;
+			outlen = template[i].plen;
+		}
 
 		j++;
 
 		/* some templates have no input data but they will
 		 * touch input
 		 */
-		input = xbuf[0];
-		input += align_offset;
-		assoc = axbuf[0];
+		inbuf = xbuf[0] + align_offset;
+		assocbuf = axbuf[0];
 
 		ret = -EINVAL;
-		if (WARN_ON(align_offset + template[i].ilen >
-			    PAGE_SIZE || template[i].alen > PAGE_SIZE))
+		if (WARN_ON(align_offset + template[i].clen > PAGE_SIZE ||
+			    template[i].alen > PAGE_SIZE))
 			goto out;
 
-		memcpy(input, template[i].input, template[i].ilen);
-		memcpy(assoc, template[i].assoc, template[i].alen);
+		memcpy(inbuf, input, inlen);
+		memcpy(assocbuf, template[i].assoc, template[i].alen);
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, iv_len);
 		else
@@ -716,7 +725,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		} else if (ret)
 			continue;
 
-		authsize = abs(template[i].rlen - template[i].ilen);
+		authsize = template[i].clen - template[i].plen;
 		ret = crypto_aead_setauthsize(tfm, authsize);
 		if (ret) {
 			pr_err("alg: aead%s: Failed to set authsize to %u on test %d for %s\n",
@@ -726,23 +735,20 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 		k = !!template[i].alen;
 		sg_init_table(sg, k + 1);
-		sg_set_buf(&sg[0], assoc, template[i].alen);
-		sg_set_buf(&sg[k], input,
-			   template[i].ilen + (enc ? authsize : 0));
-		output = input;
+		sg_set_buf(&sg[0], assocbuf, template[i].alen);
+		sg_set_buf(&sg[k], inbuf, template[i].clen);
+		outbuf = inbuf;
 
 		if (diff_dst) {
 			sg_init_table(sgout, k + 1);
-			sg_set_buf(&sgout[0], assoc, template[i].alen);
+			sg_set_buf(&sgout[0], assocbuf, template[i].alen);
 
-			output = xoutbuf[0];
-			output += align_offset;
-			sg_set_buf(&sgout[k], output,
-				   template[i].rlen + (enc ? 0 : authsize));
+			outbuf = xoutbuf[0] + align_offset;
+			sg_set_buf(&sgout[k], outbuf, template[i].clen);
 		}
 
-		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-				       template[i].ilen, iv);
+		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg, inlen,
+				       iv);
 
 		aead_request_set_ad(req, template[i].alen);
 
@@ -771,17 +777,19 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 			goto out;
 		}
 
-		q = output;
-		if (memcmp(q, template[i].result, template[i].rlen)) {
+		if (memcmp(outbuf, expected_output, outlen)) {
 			pr_err("alg: aead%s: Test %d failed on %s for %s\n",
 			       d, j, e, algo);
-			hexdump(q, template[i].rlen);
+			hexdump(outbuf, outlen);
 			ret = -EINVAL;
 			goto out;
 		}
 	}
 
 	for (i = 0, j = 0; i < tcount; i++) {
+		const char *input, *expected_output;
+		unsigned int inlen, outlen;
+
 		/* alignment tests are only done with continuous buffers */
 		if (align_offset != 0)
 			break;
@@ -789,8 +797,19 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		if (!template[i].np)
 			continue;
 
-		if (enc && template[i].novrfy)
-			continue;
+		if (enc) {
+			if (template[i].novrfy)
+				continue;
+			input = template[i].ptext;
+			inlen = template[i].plen;
+			expected_output = template[i].ctext;
+			outlen = template[i].clen;
+		} else {
+			input = template[i].ctext;
+			inlen = template[i].clen;
+			expected_output = template[i].ptext;
+			outlen = template[i].plen;
+		}
 
 		j++;
 
@@ -818,7 +837,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		} else if (ret)
 			continue;
 
-		authsize = abs(template[i].rlen - template[i].ilen);
+		authsize = template[i].clen - template[i].plen;
 
 		ret = -EINVAL;
 		sg_init_table(sg, template[i].anp + template[i].np);
@@ -845,32 +864,32 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		}
 
 		for (k = 0, temp = 0; k < template[i].np; k++) {
-			if (WARN_ON(offset_in_page(IDX[k]) +
-				    template[i].tap[k] > PAGE_SIZE))
+			n = template[i].tap[k];
+			if (k == template[i].np - 1 && !enc)
+				n += authsize;
+
+			if (WARN_ON(offset_in_page(IDX[k]) + n > PAGE_SIZE))
 				goto out;
 
 			q = xbuf[IDX[k] >> PAGE_SHIFT] + offset_in_page(IDX[k]);
-			memcpy(q, template[i].input + temp, template[i].tap[k]);
-			sg_set_buf(&sg[template[i].anp + k],
-				   q, template[i].tap[k]);
+			memcpy(q, input + temp, n);
+			sg_set_buf(&sg[template[i].anp + k], q, n);
 
 			if (diff_dst) {
 				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
 				    offset_in_page(IDX[k]);
 
-				memset(q, 0, template[i].tap[k]);
+				memset(q, 0, n);
 
-				sg_set_buf(&sgout[template[i].anp + k],
-					   q, template[i].tap[k]);
+				sg_set_buf(&sgout[template[i].anp + k], q, n);
 			}
 
-			n = template[i].tap[k];
 			if (k == template[i].np - 1 && enc)
 				n += authsize;
 			if (offset_in_page(q) + n < PAGE_SIZE)
 				q[n] = 0;
 
-			temp += template[i].tap[k];
+			temp += n;
 		}
 
 		ret = crypto_aead_setauthsize(tfm, authsize);
@@ -895,8 +914,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		}
 
 		aead_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-				       template[i].ilen,
-				       iv);
+				       inlen, iv);
 
 		aead_request_set_ad(req, template[i].alen);
 
@@ -935,10 +953,10 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				    offset_in_page(IDX[k]);
 
 			n = template[i].tap[k];
-			if (k == template[i].np - 1)
-				n += enc ? authsize : -authsize;
+			if (k == template[i].np - 1 && enc)
+				n += authsize;
 
-			if (memcmp(q, template[i].result + temp, n)) {
+			if (memcmp(q, expected_output + temp, n)) {
 				pr_err("alg: aead%s: Chunk test %d failed on %s at page %u for %s\n",
 				       d, j, e, k, algo);
 				hexdump(q, n);
@@ -947,9 +965,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 			q += n;
 			if (k == template[i].np - 1 && !enc) {
-				if (!diff_dst &&
-					memcmp(q, template[i].input +
-					      temp + n, authsize))
+				if (!diff_dst && memcmp(q, input + temp + n,
+							authsize))
 					n = authsize;
 				else
 					n = 0;
@@ -1721,8 +1738,9 @@ static int test_cprng(struct crypto_rng *tfm,
 static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
+	const struct aead_test_suite *suite = &desc->suite.aead;
 	struct crypto_aead *tfm;
-	int err = 0;
+	int err;
 
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
@@ -1731,18 +1749,10 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 		return PTR_ERR(tfm);
 	}
 
-	if (desc->suite.aead.enc.vecs) {
-		err = test_aead(tfm, ENCRYPT, desc->suite.aead.enc.vecs,
-				desc->suite.aead.enc.count);
-		if (err)
-			goto out;
-	}
-
-	if (!err && desc->suite.aead.dec.vecs)
-		err = test_aead(tfm, DECRYPT, desc->suite.aead.dec.vecs,
-				desc->suite.aead.dec.count);
+	err = test_aead(tfm, ENCRYPT, suite->vecs, suite->count);
+	if (!err)
+		err = test_aead(tfm, DECRYPT, suite->vecs, suite->count);
 
-out:
 	crypto_free_aead(tfm);
 	return err;
 }
@@ -2424,28 +2434,19 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "aegis128",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aegis128_enc_tv_template),
-				.dec = __VECS(aegis128_dec_tv_template),
-			}
+			.aead = __VECS(aegis128_tv_template)
 		}
 	}, {
 		.alg = "aegis128l",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aegis128l_enc_tv_template),
-				.dec = __VECS(aegis128l_dec_tv_template),
-			}
+			.aead = __VECS(aegis128l_tv_template)
 		}
 	}, {
 		.alg = "aegis256",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aegis256_enc_tv_template),
-				.dec = __VECS(aegis256_dec_tv_template),
-			}
+			.aead = __VECS(aegis256_tv_template)
 		}
 	}, {
 		.alg = "ansi_cprng",
@@ -2457,36 +2458,27 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_md5_ecb_cipher_null_enc_tv_template),
-				.dec = __VECS(hmac_md5_ecb_cipher_null_dec_tv_template)
-			}
+			.aead = __VECS(hmac_md5_ecb_cipher_null_tv_template)
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha1_aes_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha1_aes_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha1_des_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha1_des_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha1_des3_ede_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha1_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),ctr(aes))",
@@ -2496,10 +2488,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha1_ecb_cipher_null_enc_tv_temp),
-				.dec = __VECS(hmac_sha1_ecb_cipher_null_dec_tv_temp)
-			}
+			.aead = __VECS(hmac_sha1_ecb_cipher_null_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
@@ -2509,44 +2498,34 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha224_des_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha224_des_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha224_des3_ede_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha224_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha256_aes_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha256_aes_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha256_des_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha256_des_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha256_des3_ede_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha256_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha256),ctr(aes))",
@@ -2560,18 +2539,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha384_des_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha384_des_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha384_des3_ede_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha384_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha384),ctr(aes))",
@@ -2586,26 +2561,20 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha512_aes_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha512_aes_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha512_des_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha512_des_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(hmac_sha512_des3_ede_cbc_enc_tv_temp)
-			}
+			.aead = __VECS(hmac_sha512_des3_ede_cbc_tv_temp)
 		}
 	}, {
 		.alg = "authenc(hmac(sha512),ctr(aes))",
@@ -2702,10 +2671,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aes_ccm_enc_tv_template),
-				.dec = __VECS(aes_ccm_dec_tv_template)
-			}
+			.aead = __VECS(aes_ccm_tv_template)
 		}
 	}, {
 		.alg = "cfb(aes)",
@@ -3116,10 +3082,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aes_gcm_enc_tv_template),
-				.dec = __VECS(aes_gcm_dec_tv_template)
-			}
+			.aead = __VECS(aes_gcm_tv_template)
 		}
 	}, {
 		.alg = "ghash",
@@ -3314,19 +3277,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "morus1280",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(morus1280_enc_tv_template),
-				.dec = __VECS(morus1280_dec_tv_template),
-			}
+			.aead = __VECS(morus1280_tv_template)
 		}
 	}, {
 		.alg = "morus640",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(morus640_enc_tv_template),
-				.dec = __VECS(morus640_dec_tv_template),
-			}
+			.aead = __VECS(morus640_tv_template)
 		}
 	}, {
 		.alg = "nhpoly1305",
@@ -3391,47 +3348,32 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aes_gcm_rfc4106_enc_tv_template),
-				.dec = __VECS(aes_gcm_rfc4106_dec_tv_template)
-			}
+			.aead = __VECS(aes_gcm_rfc4106_tv_template)
 		}
 	}, {
 		.alg = "rfc4309(ccm(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aes_ccm_rfc4309_enc_tv_template),
-				.dec = __VECS(aes_ccm_rfc4309_dec_tv_template)
-			}
+			.aead = __VECS(aes_ccm_rfc4309_tv_template)
 		}
 	}, {
 		.alg = "rfc4543(gcm(aes))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(aes_gcm_rfc4543_enc_tv_template),
-				.dec = __VECS(aes_gcm_rfc4543_dec_tv_template),
-			}
+			.aead = __VECS(aes_gcm_rfc4543_tv_template)
 		}
 	}, {
 		.alg = "rfc7539(chacha20,poly1305)",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(rfc7539_enc_tv_template),
-				.dec = __VECS(rfc7539_dec_tv_template),
-			}
+			.aead = __VECS(rfc7539_tv_template)
 		}
 	}, {
 		.alg = "rfc7539esp(chacha20,poly1305)",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = {
-				.enc = __VECS(rfc7539esp_enc_tv_template),
-				.dec = __VECS(rfc7539esp_dec_tv_template),
-			}
+			.aead = __VECS(rfc7539esp_tv_template)
 		}
 	}, {
 		.alg = "rmd128",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4ad072b43de05..95297240b0f1c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -76,23 +76,45 @@ struct cipher_testvec {
 	bool generates_iv;
 };
 
+/*
+ * aead_testvec:	structure to describe an AEAD test
+ * @key:	Pointer to key
+ * @iv:		Pointer to IV.  If NULL, an all-zeroes IV is used.
+ * @ptext:	Pointer to plaintext
+ * @assoc:	Pointer to associated data
+ * @ctext:	Pointer to the full authenticated ciphertext.  For AEADs that
+ *		produce a separate "ciphertext" and "authentication tag", these
+ *		two parts are concatenated: ciphertext || tag.
+ * @tap:	How to distribute ptext data in @np SGs
+ * @atap:	How to distribute assoc data in @anp SGs
+ * @np:		Numbers of SG to distribute ptext data in
+ * @anp:	Numbers of SG to distribute assoc data in
+ * @fail:	setkey() failure expected?
+ * @novrfy:	Decryption verification failure expected?
+ * @wk:		Does the test need CRYPTO_TFM_REQ_WEAK_KEY?
+ *		(e.g. setkey() needs to fail due to a weak key)
+ * @klen:	Length of @key in bytes
+ * @plen:	Length of @ptext in bytes
+ * @alen:	Length of @assoc in bytes
+ * @clen:	Length of @ctext in bytes
+ */
 struct aead_testvec {
 	const char *key;
 	const char *iv;
-	const char *input;
+	const char *ptext;
 	const char *assoc;
-	const char *result;
+	const char *ctext;
 	unsigned char tap[MAX_TAP];
 	unsigned char atap[MAX_TAP];
 	int np;
 	int anp;
 	bool fail;
-	unsigned char novrfy;	/* ccm dec verification failure expected */
-	unsigned char wk; /* weak key flag */
+	unsigned char novrfy;
+	unsigned char wk;
 	unsigned char klen;
-	unsigned short ilen;
+	unsigned short plen;
+	unsigned short clen;
 	unsigned short alen;
-	unsigned short rlen;
 };
 
 struct cprng_testvec {
@@ -18907,6 +18929,13 @@ static const struct aead_testvec rfc7539esp_tv_template[] = {
 	},
 };
 
+/*
+ * AEGIS-128 test vectors - generated via reference implementation from
+ * SUPERCOP (https://bench.cr.yp.to/supercop.html):
+ *
+ *   https://bench.cr.yp.to/supercop/supercop-20170228.tar.xz
+ *   (see crypto_aead/aegis128/)
+ */
 static const struct aead_testvec aegis128_tv_template[] = {
 	{
 		.key	= "\x0f\xc9\x8e\x67\x44\x9e\xaa\x86"
@@ -19344,13 +19373,6 @@ static const struct aead_testvec aegis128_tv_template[] = {
 	},
 };
 
-/*
- * AEGIS-128 test vectors - generated via reference implementation from
- * SUPERCOP (https://bench.cr.yp.to/supercop.html):
- *
- *   https://bench.cr.yp.to/supercop/supercop-20170228.tar.xz
- *   (see crypto_aead/aegis128/)
- */
 /*
  * AEGIS-128L test vectors - generated via reference implementation from
  * SUPERCOP (https://bench.cr.yp.to/supercop.html):
-- 
2.20.1
