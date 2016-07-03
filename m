From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v4 PATCH 0/8] crypto: rsa - Do not gratuitously drop leading
 zeroes
Date: Sun, 3 Jul 2016 10:46:11 +0800
Message-ID: <20160703024611.GA24340@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <20160629102649.GA26987@gondor.apana.org.au>
 <20160629113125.GA27643@gondor.apana.org.au>
 <1997039.xp5G17Zq2C@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47179 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbcGCCqk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jul 2016 22:46:40 -0400
Content-Disposition: inline
In-Reply-To: <1997039.xp5G17Zq2C@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 02, 2016 at 07:55:59PM +0200, Stephan Mueller wrote:
> 
> I re-tested that patch set and I still see the same issues as before, namely 
> that sigver does not work:

Oops, somehow I conflated this problem with KPP.  Does this patch
fix it for you?

---8<---
Subject: crypto: rsa-pkcs1pad - Fix regression from leading zeros

As the software RSA implementation now produces fixed-length
output, we need to eliminate leading zeros in the calling code
instead.

This patch does just that for pkcs1pad signature verification.

Fixes: 9b45b7bba3d2 ("crypto: rsa - Generate fixed-length output")
Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8ccfdd7..880d3db 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -456,49 +456,55 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 	struct akcipher_instance *inst = akcipher_alg_instance(tfm);
 	struct pkcs1pad_inst_ctx *ictx = akcipher_instance_ctx(inst);
 	const struct rsa_asn1_template *digest_info = ictx->digest_info;
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
 
 	err = -EBADMSG;
-	if (req_ctx->out_buf[0] != 0x01)
+	if (out_buf[0] != 0x01)
 		goto done;
 
-	for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
-		if (req_ctx->out_buf[pos] != 0xff)
+	for (pos = 1; pos < dst_len; pos++)
+		if (out_buf[pos] != 0xff)
 			break;
 
-	if (pos < 9 || pos == req_ctx->child_req.dst_len ||
-	    req_ctx->out_buf[pos] != 0x00)
+	if (pos < 9 || pos == dst_len || out_buf[pos] != 0x00)
 		goto done;
 	pos++;
 
-	if (memcmp(req_ctx->out_buf + pos, digest_info->data,
-		   digest_info->size))
+	if (memcmp(out_buf + pos, digest_info->data, digest_info->size))
 		goto done;
 
 	pos += digest_info->size;
 
 	err = 0;
 
-	if (req->dst_len < req_ctx->child_req.dst_len - pos)
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
