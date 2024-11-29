Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A57160799;
	Fri, 29 Nov 2024 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732874005; cv=none; b=NtuwgJQzvWhJZ3N1W9D0WS5EImZ/VFkRm29TskWXdCZCNmZ8x93DoxcjqDGkacgx2op7DtHTOqsdEhIfGVSMFyCUUhuE/8S0XyYVsApVg5NqKnP362gPDUAnD4wpgyi4chK+0qRglN4EDBtj90KF2hXRy9wAU5gxQyzq1VXAYGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732874005; c=relaxed/simple;
	bh=hx3C9drbPwcI7X8FuWDpi2I33d1NaJctELt9voru1fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bM7av9AGBK7vV+2A231Ip0ywKllHRdpQ5GYwk5p6EQYVxq8Xku5+fgR1zrhHgF0q6h5/yj2w5WQhs9GgQKwv8hmI44yEyGiHjo+RvC8zFjgq9WHt2yO3yIUo0TtlSIJDeMx+oM945MLJPWbr6tW7McjTXDK1baNsFlWOOX72RFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CcXX6HmQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CcXX6HmQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Yl0j5uIS4r/S01x6tXWiLlOS813jd6l7rs7DmO+WbWI=; b=CcXX6HmQ7izN0f06eKh6B6PvY5
	vwjaizE1uwJGGLrvtBhaKXdr815xV/SLM/vAjHNHCj48VMw1QSPsZzxaZEBOtzadymv3Dly7nX8QF
	TKTaWPm7n6seDaDI/DmDMqV4ffI2rDnz3Ey8S3mxDVdDMku40Xs3yfTvxmUHGBnYt/eJRJoDvc6+9
	+PBfE/6VRWYJHOsuMY7V+dL+PK+/BDEEVspnWY4oJmhNhzzInKVkGCCbKZfpYMsGaGzVHlCmEnx7I
	3IkH2uh73gDAfu6VQcK1Wm0xq5nllLsu3gzC2ztfK6MfHpIugVGux6joOBR1ABBTu1R1AbK7w+mDU
	0LnxyG6Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tGxgb-002MkO-01;
	Fri, 29 Nov 2024 17:53:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Nov 2024 17:53:16 +0800
Date: Fri, 29 Nov 2024 17:53:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] crypto: rsassa-pkcs1 - Copy source data for SG list
Message-ID: <Z0mPDA31r_LEYzNq@gondor.apana.org.au>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

As virtual addresses in general may not be suitable for DMA, always
perform a copy before using them in an SG list.

Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 4d077fc96076..f68ffd338f48 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -163,10 +163,6 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 	struct rsassa_pkcs1_inst_ctx *ictx = sig_instance_ctx(inst);
 	const struct hash_prefix *hash_prefix = ictx->hash_prefix;
 	struct rsassa_pkcs1_ctx *ctx = crypto_sig_ctx(tfm);
-	unsigned int child_reqsize = crypto_akcipher_reqsize(ctx->child);
-	struct akcipher_request *child_req __free(kfree_sensitive) = NULL;
-	struct scatterlist in_sg[3], out_sg;
-	struct crypto_wait cwait;
 	unsigned int pad_len;
 	unsigned int ps_end;
 	unsigned int len;
@@ -187,37 +183,25 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 
 	pad_len = ctx->key_size - slen - hash_prefix->size - 1;
 
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + pad_len,
-			    GFP_KERNEL);
-	if (!child_req)
-		return -ENOMEM;
-
 	/* RFC 8017 sec 8.2.1 step 1 - EMSA-PKCS1-v1_5 encoding generation */
-	in_buf = (u8 *)(child_req + 1) + child_reqsize;
+	in_buf = dst;
+	memmove(in_buf + pad_len + hash_prefix->size, src, slen);
+	memcpy(in_buf + pad_len, hash_prefix->data, hash_prefix->size);
+
 	ps_end = pad_len - 1;
 	in_buf[0] = 0x01;
 	memset(in_buf + 1, 0xff, ps_end - 1);
 	in_buf[ps_end] = 0x00;
 
-	/* RFC 8017 sec 8.2.1 step 2 - RSA signature */
-	crypto_init_wait(&cwait);
-	sg_init_table(in_sg, 3);
-	sg_set_buf(&in_sg[0], in_buf, pad_len);
-	sg_set_buf(&in_sg[1], hash_prefix->data, hash_prefix->size);
-	sg_set_buf(&in_sg[2], src, slen);
-	sg_init_one(&out_sg, dst, dlen);
-	akcipher_request_set_tfm(child_req, ctx->child);
-	akcipher_request_set_crypt(child_req, in_sg, &out_sg,
-				   ctx->key_size - 1, dlen);
-	akcipher_request_set_callback(child_req, CRYPTO_TFM_REQ_MAY_SLEEP,
-				      crypto_req_done, &cwait);
 
-	err = crypto_akcipher_decrypt(child_req);
-	err = crypto_wait_req(err, &cwait);
-	if (err)
+	/* RFC 8017 sec 8.2.1 step 2 - RSA signature */
+	err = crypto_akcipher_sync_decrypt(ctx->child, in_buf,
+					   ctx->key_size - 1, in_buf,
+					   ctx->key_size);
+	if (err < 0)
 		return err;
 
-	len = child_req->dst_len;
+	len = err;
 	pad_len = ctx->key_size - len;
 
 	/* Four billion to one */
@@ -239,8 +223,8 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	struct rsassa_pkcs1_ctx *ctx = crypto_sig_ctx(tfm);
 	unsigned int child_reqsize = crypto_akcipher_reqsize(ctx->child);
 	struct akcipher_request *child_req __free(kfree_sensitive) = NULL;
-	struct scatterlist in_sg, out_sg;
 	struct crypto_wait cwait;
+	struct scatterlist sg;
 	unsigned int dst_len;
 	unsigned int pos;
 	u8 *out_buf;
@@ -259,13 +243,12 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -ENOMEM;
 
 	out_buf = (u8 *)(child_req + 1) + child_reqsize;
+	memcpy(out_buf, src, slen);
 
 	crypto_init_wait(&cwait);
-	sg_init_one(&in_sg, src, slen);
-	sg_init_one(&out_sg, out_buf, ctx->key_size);
+	sg_init_one(&sg, out_buf, slen);
 	akcipher_request_set_tfm(child_req, ctx->child);
-	akcipher_request_set_crypt(child_req, &in_sg, &out_sg,
-				   slen, ctx->key_size);
+	akcipher_request_set_crypt(child_req, &sg, &sg, slen, slen);
 	akcipher_request_set_callback(child_req, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      crypto_req_done, &cwait);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
