From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 2/3] crypto: testmgr.c: white space removal on __test_skcipher
Date: Fri, 8 Aug 2014 14:27:51 +0300
Message-ID: <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch inverts two if conditions to remove code blocks
indentation. Several white space clean-ups follow.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 283 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 136 insertions(+), 147 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 51f47f2..36f45ff 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -974,73 +974,69 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (!(template[i].np) || (template[i].also_non_np)) {
-			j++;
+		if (template[i].np && !template[i].also_non_np)
+			continue;
 
-			ret = -EINVAL;
-			if (WARN_ON(align_offset + template[i].ilen >
-				    PAGE_SIZE))
-				goto out;
+		j++;
 
-			data = xbuf[0];
-			data += align_offset;
-			memcpy(data, template[i].input, template[i].ilen);
+		ret = -EINVAL;
+		if (WARN_ON(align_offset + template[i].ilen > PAGE_SIZE))
+			goto out;
 
-			crypto_ablkcipher_clear_flags(tfm, ~0);
-			if (template[i].wk)
-				crypto_ablkcipher_set_flags(
-					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+		data = xbuf[0];
+		data += align_offset;
+		memcpy(data, template[i].input, template[i].ilen);
 
-			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
-						       template[i].klen);
-			if (!ret == template[i].fail) {
-				pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
-				       d, j, algo,
-				       crypto_ablkcipher_get_flags(tfm));
-				goto out;
-			} else if (ret)
-				continue;
+		crypto_ablkcipher_clear_flags(tfm, ~0);
+		if (template[i].wk)
+			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			sg_init_one(&sg[0], data, template[i].ilen);
-			if (diff_dst) {
-				data = xoutbuf[0];
-				data += align_offset;
-				sg_init_one(&sgout[0], data, template[i].ilen);
-			}
+		ret = crypto_ablkcipher_setkey(tfm, template[i].key,
+					       template[i].klen);
+		if (!ret == template[i].fail) {
+			pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
+			       d, j, algo, crypto_ablkcipher_get_flags(tfm));
+			goto out;
+		} else if (ret)
+			continue;
 
-			ablkcipher_request_set_crypt(req, sg,
-						     (diff_dst) ? sgout : sg,
-						     template[i].ilen, iv);
-			ret = enc ?
-				crypto_ablkcipher_encrypt(req) :
-				crypto_ablkcipher_decrypt(req);
+		sg_init_one(&sg[0], data, template[i].ilen);
+		if (diff_dst) {
+			data = xoutbuf[0];
+			data += align_offset;
+			sg_init_one(&sgout[0], data, template[i].ilen);
+		}
 
-			switch (ret) {
-			case 0:
+		ablkcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
+					     template[i].ilen, iv);
+		ret = enc ? crypto_ablkcipher_encrypt(req) :
+			    crypto_ablkcipher_decrypt(req);
+
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&result.completion);
+			if (!ret && !((ret = result.err))) {
+				reinit_completion(&result.completion);
 				break;
-			case -EINPROGRESS:
-			case -EBUSY:
-				ret = wait_for_completion_interruptible(
-					&result.completion);
-				if (!ret && !((ret = result.err))) {
-					reinit_completion(&result.completion);
-					break;
-				}
-				/* fall through */
-			default:
-				pr_err("alg: skcipher%s: %s failed on test %d for %s: ret=%d\n",
-				       d, e, j, algo, -ret);
-				goto out;
 			}
+			/* fall through */
+		default:
+			pr_err("alg: skcipher%s: %s failed on test %d for %s: ret=%d\n",
+			       d, e, j, algo, -ret);
+			goto out;
+		}
 
-			q = data;
-			if (memcmp(q, template[i].result, template[i].rlen)) {
-				pr_err("alg: skcipher%s: Test %d failed on %s for %s\n",
-				       d, j, e, algo);
-				hexdump(q, template[i].rlen);
-				ret = -EINVAL;
-				goto out;
-			}
+		q = data;
+		if (memcmp(q, template[i].result, template[i].rlen)) {
+			pr_err("alg: skcipher%s: Test %d failed on %s for %s\n",
+			       d, j, e, algo);
+			hexdump(q, template[i].rlen);
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -1055,116 +1051,109 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (template[i].np) {
-			j++;
+		if (!template[i].np)
+			continue;
 
-			crypto_ablkcipher_clear_flags(tfm, ~0);
-			if (template[i].wk)
-				crypto_ablkcipher_set_flags(
-					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+		j++;
 
-			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
-						       template[i].klen);
-			if (!ret == template[i].fail) {
-				pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
-				       d, j, algo,
-				       crypto_ablkcipher_get_flags(tfm));
-				goto out;
-			} else if (ret)
-				continue;
+		crypto_ablkcipher_clear_flags(tfm, ~0);
+		if (template[i].wk)
+			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
-			temp = 0;
-			ret = -EINVAL;
-			sg_init_table(sg, template[i].np);
-			if (diff_dst)
-				sg_init_table(sgout, template[i].np);
-			for (k = 0; k < template[i].np; k++) {
-				if (WARN_ON(offset_in_page(IDX[k]) +
-					    template[i].tap[k] > PAGE_SIZE))
-					goto out;
+		ret = crypto_ablkcipher_setkey(tfm, template[i].key,
+					       template[i].klen);
+		if (!ret == template[i].fail) {
+			pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
+			       d, j, algo, crypto_ablkcipher_get_flags(tfm));
+			goto out;
+		} else if (ret)
+			continue;
 
-				q = xbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
+		temp = 0;
+		ret = -EINVAL;
+		sg_init_table(sg, template[i].np);
+		if (diff_dst)
+			sg_init_table(sgout, template[i].np);
+		for (k = 0; k < template[i].np; k++) {
+			if (WARN_ON(offset_in_page(IDX[k]) +
+				    template[i].tap[k] > PAGE_SIZE))
+				goto out;
 
-				memcpy(q, template[i].input + temp,
-				       template[i].tap[k]);
+			q = xbuf[IDX[k] >> PAGE_SHIFT] + offset_in_page(IDX[k]);
 
-				if (offset_in_page(q) + template[i].tap[k] <
-				    PAGE_SIZE)
-					q[template[i].tap[k]] = 0;
+			memcpy(q, template[i].input + temp, template[i].tap[k]);
 
-				sg_set_buf(&sg[k], q, template[i].tap[k]);
-				if (diff_dst) {
-					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-					    offset_in_page(IDX[k]);
+			if (offset_in_page(q) + template[i].tap[k] < PAGE_SIZE)
+				q[template[i].tap[k]] = 0;
 
-					sg_set_buf(&sgout[k], q,
-						   template[i].tap[k]);
+			sg_set_buf(&sg[k], q, template[i].tap[k]);
+			if (diff_dst) {
+				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
 
-					memset(q, 0, template[i].tap[k]);
-					if (offset_in_page(q) +
-					    template[i].tap[k] < PAGE_SIZE)
-						q[template[i].tap[k]] = 0;
-				}
+				sg_set_buf(&sgout[k], q, template[i].tap[k]);
 
-				temp += template[i].tap[k];
+				memset(q, 0, template[i].tap[k]);
+				if (offset_in_page(q) +
+				    template[i].tap[k] < PAGE_SIZE)
+					q[template[i].tap[k]] = 0;
 			}
 
-			ablkcipher_request_set_crypt(req, sg,
-					(diff_dst) ? sgout : sg,
-					template[i].ilen, iv);
+			temp += template[i].tap[k];
+		}
 
-			ret = enc ?
-				crypto_ablkcipher_encrypt(req) :
-				crypto_ablkcipher_decrypt(req);
+		ablkcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
+					     template[i].ilen, iv);
 
-			switch (ret) {
-			case 0:
-				break;
-			case -EINPROGRESS:
-			case -EBUSY:
-				ret = wait_for_completion_interruptible(
+		ret = enc ? crypto_ablkcipher_encrypt(req) :
+			    crypto_ablkcipher_decrypt(req);
+
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
 					&result.completion);
-				if (!ret && !((ret = result.err))) {
-					reinit_completion(&result.completion);
-					break;
-				}
-				/* fall through */
-			default:
-				pr_err("alg: skcipher%s: %s failed on chunk test %d for %s: ret=%d\n",
-				       d, e, j, algo, -ret);
-				goto out;
+			if (!ret && !((ret = result.err))) {
+				reinit_completion(&result.completion);
+				break;
 			}
+			/* fall through */
+		default:
+			pr_err("alg: skcipher%s: %s failed on chunk test %d for %s: ret=%d\n",
+			       d, e, j, algo, -ret);
+			goto out;
+		}
 
-			temp = 0;
-			ret = -EINVAL;
-			for (k = 0; k < template[i].np; k++) {
-				if (diff_dst)
-					q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-					    offset_in_page(IDX[k]);
-				else
-					q = xbuf[IDX[k] >> PAGE_SHIFT] +
-					    offset_in_page(IDX[k]);
+		temp = 0;
+		ret = -EINVAL;
+		for (k = 0; k < template[i].np; k++) {
+			if (diff_dst)
+				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
+			else
+				q = xbuf[IDX[k] >> PAGE_SHIFT] +
+				    offset_in_page(IDX[k]);
 
-				if (memcmp(q, template[i].result + temp,
-					   template[i].tap[k])) {
-					pr_err("alg: skcipher%s: Chunk test %d failed on %s at page %u for %s\n",
-					       d, j, e, k, algo);
-					hexdump(q, template[i].tap[k]);
-					goto out;
-				}
+			if (memcmp(q, template[i].result + temp,
+				   template[i].tap[k])) {
+				pr_err("alg: skcipher%s: Chunk test %d failed on %s at page %u for %s\n",
+				       d, j, e, k, algo);
+				hexdump(q, template[i].tap[k]);
+				goto out;
+			}
 
-				q += template[i].tap[k];
-				for (n = 0; offset_in_page(q + n) && q[n]; n++)
-					;
-				if (n) {
-					pr_err("alg: skcipher%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
-					       d, j, e, k, algo, n);
-					hexdump(q, n);
-					goto out;
-				}
-				temp += template[i].tap[k];
+			q += template[i].tap[k];
+			for (n = 0; offset_in_page(q + n) && q[n]; n++)
+				;
+			if (n) {
+				pr_err("alg: skcipher%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
+				       d, j, e, k, algo, n);
+				hexdump(q, n);
+				goto out;
 			}
+			temp += template[i].tap[k];
 		}
 	}
 
-- 
1.8.3.1
