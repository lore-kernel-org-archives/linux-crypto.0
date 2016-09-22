From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: BUG: rsa-pkcs1pad decrypt regression in 4.8
Date: Thu, 22 Sep 2016 17:04:57 +0800
Message-ID: <20160922090456.GA5272@gondor.apana.org.au>
References: <alpine.OSX.2.20.1609211630400.14260@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47997 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753122AbcIVJFH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 05:05:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.20.1609211630400.14260@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 21, 2016 at 04:39:30PM -0700, Mat Martineau wrote:
> 
> Herbert -
> 
> There was a regression in pkcs1pad signature verification, related
> to signature verification, that you fixed in commit 27710b8ea3defcb:
> 
> https://git.kernel.org/cgit/linux/kernel/git/herbert/crypto-2.6.git/commit/?id=27710b8ea3defcbd7d340dbd0423d911b4eb7c4f
> 
> There is a very similar problem in the decrypt operation, which was
> not adjusted for the leading zero changes. See
> pkcs1pad_decrypt_complete().
> 
> I haven't had a chance to test a fix yet, but with the final 4.8
> release coming up very soon I wanted to report the issue.

Thanks.  This patch should fix the problem.

---8<---
crypto: rsa-pkcs1pad - Handle leading zero for decryption

As the software RSA implementation now produces fixed-length
output, we need to eliminate leading zeros in the calling code
instead.

This patch does just that for pkcs1pad decryption while signature
verification was fixed in an earlier patch.

Fixes: 9b45b7bba3d2 ("crypto: rsa - Generate fixed-length output")
Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 877019a..8baab43 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -298,41 +298,48 @@ static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	unsigned int dst_len;
 	unsigned int pos;
-
-	if (err == -EOVERFLOW)
-		/* Decrypted value had no leading 0 byte */
-		err = -EINVAL;
+	u8 *out_buf;
 
 	if (err)
 		goto done;
 
-	if (req_ctx->child_req.dst_len != ctx->key_size - 1) {
-		err = -EINVAL;
+	err = -EINVAL;
+	dst_len = req_ctx->child_req.dst_len;
+	if (dst_len < ctx->key_size - 1)
 		goto done;
+
+	out_buf = req_ctx->out_buf;
+	if (dst_len == ctx->key_size) {
+		if (out_buf[0] != 0x00)
+			/* Decrypted value had no leading 0 byte */
+			goto done;
+
+		dst_len--;
+		out_buf++;
 	}
 
-	if (req_ctx->out_buf[0] != 0x02) {
-		err = -EINVAL;
+	if (out_buf[0] != 0x02)
 		goto done;
-	}
-	for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
-		if (req_ctx->out_buf[pos] == 0x00)
+
+	for (pos = 1; pos < dst_len; pos++)
+		if (out_buf[pos] == 0x00)
 			break;
-	if (pos < 9 || pos == req_ctx->child_req.dst_len) {
-		err = -EINVAL;
+	if (pos < 9 || pos == dst_len)
 		goto done;
-	}
 	pos++;
 
-	if (req->dst_len < req_ctx->child_req.dst_len - pos)
+	err = 0;
+
+	if (req->dst_len < dst_len - pos)
 		err = -EOVERFLOW;
-	req->dst_len = req_ctx->child_req.dst_len - pos;
+	req->dst_len = dst_len - pos;
 
 	if (!err)
 		sg_copy_from_buffer(req->dst,
 				sg_nents_for_len(req->dst, req->dst_len),
-				req_ctx->out_buf + pos, req->dst_len);
+				out_buf + pos, req->dst_len);
 
 done:
 	kzfree(req_ctx->out_buf);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
