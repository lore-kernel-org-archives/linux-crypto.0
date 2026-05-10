Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC453612F0
	for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 23:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778454551; cv=none; b=EPcUhy9es2gUtdBw0hTJLtdRLzvOhi+K6JSjcY5gBJyLyRPNisl1QWhie3NxuYr0f+kuuwW+mRog59hxpOlVXSlFBvprto454Cgh2mQYe+0afRvuXTfVDVMbFhRnNUMt1nk8rs4XOC3LC2AVtFLgoCcBCwazrr/bcrftQaYd5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778454551; c=relaxed/simple;
	bh=aHkXnb2OKVF3ZzHhEGgrjspE33t66deY8NhGKGzKq8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WTUd2r0hdsfP7QhY4lo5RsJ1Qr60kuq1o8IwFPcGk3/kvlvJjh7l8KcghsLXQ7z5tuyiw8gt9c02+0cyeEM7Ce6D5XH8I8N4EdXg5FSjAYnqimSBaLITEGj1JbDNxwO1yxFmww0URk86i2g7gNBruYrqz0XJIzsOU7c20LgIL7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=otPBmIWw; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="otPBmIWw"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso24837485e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 16:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778454548; x=1779059348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HZyFCF4GPlM3GT3Tj0IfjbAYoaJDP02dnOBVUskPFZY=;
        b=otPBmIWwak1M2zRU1StET4fitjE8rPGsnMegRQeHzh6cGhp0aG3Nepu8whSOYPquKK
         ZG/CQ8Q+owOI2bKb12OCpKPg1Fn+3SLx2LBQU9fcwAwgY+u4pTOeBQu34BolPtH2D4he
         MnxYVkRBaaK2rLcimmSW5w/PwWKPVeV5nmpXR0+as2Oa8zsDLH5n4tQDHdssL6QV4/XL
         8K+AC1H93AVKUvkJ6+yb7I90O3MiKgebB+onRNTcHXQoLAh4zN3xeOK1weEgGXvNaRkV
         vz7Y9SOJYbU1MQux7ij2U9m50Ke1Qb+yVOpoGYtwsikZiS7sgGupX2VPiLuvNXU9mq1U
         /5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778454548; x=1779059348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZyFCF4GPlM3GT3Tj0IfjbAYoaJDP02dnOBVUskPFZY=;
        b=Viz7CH3nw2btgQBGb8MYwYwebB5tGtRHMs5RUyxvw0T+xgsXR5VKLPhz0N7jlTBdS/
         JbtGNpuuRJASgBCXTtcvkDdzJB45Oi0veDpom4Ioad+P//r4EtN6/O1Ye/+ZHoRK7gx8
         8sVyBXULFWDmSR9eLSgZoXjSdWXsQ3Z5tv8rD9dpKUkCp3Nv4/qSVGPB/RgCE27KC94r
         dmTq5NZXyyU9EgNzepotHvnFrkWPRiVKWHePqbaaSATDcXRbW6b37Xa45UnXN2zm20+K
         PoMuZo7xT4fqqDbgvbYB7cFE48OB0om/XymQBUNXCGDi9ZdyiVZg4akEU7vuHzpxzvqi
         GEQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9BSVi+MKOPMvMT6JVOBlILLwuv/JYXtdo6kNncJwAZI4cYAr4UVztd0zDNXg3HmEssjGwniRi9Jsus1Kw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIxhv+sCgauxroRMQkyA4opgOSLdAyWKyFl8fePJnOYnnRhcIm
	w+DtLT+la8/+w+nRIy3xhAa6TU3vX9aC6dZgwHwaArbg0PVGP/DHuoud
X-Gm-Gg: Acq92OGuq/b6fxOLMtOqFKm8Q33BsUqkwIkoEBsNXCzPskK65UojACaaWWThKFoepYU
	KSLjahLEq+fRZkPPNzTNi6OUtRaeIxYby1EUOD2mZJxc/PAPDY//cbpxgjFuZkirN6bK7fjZkF9
	8m5IqJ19pxBL3F6cmhuiqPLzK6fSW6a/MxddM3bCGeNJcjSwHWcgZHB+LJ7le0p27Ekg+yDKN9X
	yq8sCO+q8LG8JnTTfATUg2/ipUz3TsV0KIpE3Xg05DYN1v8abcyUtYE8I8gs64w47NS/c0Rc6/h
	nLM4+ATLhFudmdzPqOCEjcmFNsspwKZDVcQvHAZduK14tIk3icnVHMS8NELLoFLlnpXYmUbfioy
	OJfACMY9CBbQK92gQJEOrYXGCl2mEV/tC13FSysyFq0pPX9PXGQnwwEZ/Wi1jMwdlO1J5QrRWnA
	g96Cg6oPXpDc4WTBNaxqU95dE99RwyUtmwDcznFJMfLgoxVFw=
X-Received: by 2002:a05:600c:c10b:b0:489:1f3e:5f69 with SMTP id 5b1f17b1804b1-48e676ab390mr142419715e9.18.1778454548186;
        Sun, 10 May 2026 16:09:08 -0700 (PDT)
Received: from registry.mehben.fr ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db09cb6sm49897405e9.22.2026.05.10.16.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 16:09:06 -0700 (PDT)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: herbert@gondor.apana.org.au,
	"David S . Miller" <davem@davemloft.net>
Cc: ebiggers@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH] crypto: ctr - Convert from skcipher to lskcipher
Date: Mon, 11 May 2026 01:09:01 +0200
Message-ID: <20260510230901.1772949-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the existing skcipher CTR template with an lskcipher version,
following the pattern established by the CBC conversion (705b52fef3c7).

This enables BPF programs using the bpf_crypto kfuncs to use CTR mode
ciphers like ctr(aes), which previously failed because
crypto_alloc_lskcipher() could not find an lskcipher implementation.
ECB and CBC already have lskcipher support; CTR was the missing piece.

The rfc3686 template remains as an skcipher and continues to work
through the automatic lskcipher-to-skcipher bridge.

Tested with NIST SP 800-38A test vectors (AES-128/192/256-CTR),
partial block handling, and rfc3686 compatibility. Kernel self-tests
pass on instantiation (selftest: passed in /proc/crypto).

Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
Assisted-by: Claude:claude-opus-4-6 checkpatch
---
 crypto/ctr.c | 143 +++++++++++++++++++--------------------------------
 1 file changed, 54 insertions(+), 89 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index a388f0ceb3a0..5fceaf47bedc 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -7,7 +7,6 @@
 
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
-#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -25,139 +24,105 @@ struct crypto_rfc3686_req_ctx {
 	struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
 };
 
-static void crypto_ctr_crypt_final(struct skcipher_walk *walk,
-				   struct crypto_cipher *tfm)
+static int crypto_ctr_crypt_segment(struct crypto_lskcipher *cipher,
+				    const u8 *src, u8 *dst, unsigned int nbytes,
+				    u8 *iv)
 {
-	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm);
-	u8 *ctrblk = walk->iv;
-	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
-	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
-	const u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
-	crypto_xor_cpy(dst, keystream, src, nbytes);
-
-	crypto_inc(ctrblk, bsize);
-}
+	unsigned int bsize = crypto_lskcipher_blocksize(cipher);
 
-static int crypto_ctr_crypt_segment(struct skcipher_walk *walk,
-				    struct crypto_cipher *tfm)
-{
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		   crypto_cipher_alg(tfm)->cia_encrypt;
-	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	u8 *ctrblk = walk->iv;
-	const u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	do {
-		/* create keystream */
-		fn(crypto_cipher_tfm(tfm), dst, ctrblk);
+	while (nbytes >= bsize) {
+		/* Encrypt counter block to produce keystream */
+		crypto_lskcipher_encrypt(cipher, iv, dst, bsize, NULL);
 		crypto_xor(dst, src, bsize);
-
-		/* increment counter in counterblock */
-		crypto_inc(ctrblk, bsize);
+		crypto_inc(iv, bsize);  /* Increment counter */
 
 		src += bsize;
 		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+		nbytes -= bsize;
+	}
 
 	return nbytes;
 }
 
-static int crypto_ctr_crypt_inplace(struct skcipher_walk *walk,
-				    struct crypto_cipher *tfm)
+static int crypto_ctr_crypt_inplace(struct crypto_lskcipher *cipher,
+				    u8 *dst, unsigned int nbytes, u8 *iv)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		   crypto_cipher_alg(tfm)->cia_encrypt;
-	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *dst = walk->dst.virt.addr;
-	u8 *ctrblk = walk->iv;
-	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
-	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
-
-	do {
-		/* create keystream */
-		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		crypto_xor(dst, keystream, bsize);
+	unsigned int bsize = crypto_lskcipher_blocksize(cipher);
+	u8 keystream[MAX_CIPHER_BLOCKSIZE];
 
-		/* increment counter in counterblock */
-		crypto_inc(ctrblk, bsize);
+	while (nbytes >= bsize) {
+		/* Encrypt counter block to produce keystream */
+		crypto_lskcipher_encrypt(cipher, iv, keystream, bsize, NULL);
+		crypto_xor(dst, keystream, bsize);
+		crypto_inc(iv, bsize);  /* Increment counter */
 
 		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+		nbytes -= bsize;
+	}
 
+	memzero_explicit(keystream, sizeof(keystream));
 	return nbytes;
 }
 
-static int crypto_ctr_crypt(struct skcipher_request *req)
+static int crypto_ctr_crypt(struct crypto_lskcipher *tfm, const u8 *src,
+			    u8 *dst, unsigned int len, u8 *iv, u32 flags)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-	const unsigned int bsize = crypto_cipher_blocksize(cipher);
-	struct skcipher_walk walk;
+	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher *cipher = *ctx;
+	unsigned int bsize = crypto_lskcipher_blocksize(cipher);
+	bool final = flags & CRYPTO_LSKCIPHER_FLAG_FINAL;
 	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
 
-	while (walk.nbytes >= bsize) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_ctr_crypt_inplace(&walk, cipher);
-		else
-			nbytes = crypto_ctr_crypt_segment(&walk, cipher);
-
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	if (walk.nbytes) {
-		crypto_ctr_crypt_final(&walk, cipher);
-		err = skcipher_walk_done(&walk, 0);
+	if (src == dst)
+		nbytes = crypto_ctr_crypt_inplace(cipher, dst, len, iv);
+	else
+		nbytes = crypto_ctr_crypt_segment(cipher, src, dst, len, iv);
+
+	/* Handle final partial block. */
+	if (nbytes && final) {
+		u8 keystream[MAX_CIPHER_BLOCKSIZE];
+
+		crypto_lskcipher_encrypt(cipher, iv, keystream, bsize, NULL);
+		crypto_xor_cpy(dst + len - nbytes, src + len - nbytes,
+			       keystream, nbytes);
+		crypto_inc(iv, bsize);
+		memzero_explicit(keystream, sizeof(keystream));
+		nbytes = 0;
 	}
 
-	return err;
+	return nbytes;
 }
 
 static int crypto_ctr_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct skcipher_instance *inst;
-	struct crypto_alg *alg;
+	struct lskcipher_instance *inst;
 	int err;
 
-	inst = skcipher_alloc_instance_simple(tmpl, tb);
+	inst = lskcipher_alloc_instance_simple(tmpl, tb);
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
-	alg = skcipher_ialg_simple(inst);
-
 	/* Block size must be >= 4 bytes. */
 	err = -EINVAL;
-	if (alg->cra_blocksize < 4)
+	if (inst->alg.co.base.cra_blocksize < 4)
 		goto out_free_inst;
 
 	/* If this is false we'd fail the alignment of crypto_inc. */
-	if (alg->cra_blocksize % 4)
+	if (inst->alg.co.base.cra_blocksize % 4)
 		goto out_free_inst;
 
-	/* CTR mode is a stream cipher. */
-	inst->alg.base.cra_blocksize = 1;
-
 	/*
-	 * To simplify the implementation, configure the skcipher walk to only
-	 * give a partial block at the very end, never earlier.
+	 * CTR mode is a stream cipher.  Set chunksize to the underlying
+	 * cipher block size so partial blocks only occur at the end.
 	 */
-	inst->alg.chunksize = alg->cra_blocksize;
+	inst->alg.co.chunksize = inst->alg.co.base.cra_blocksize;
+	inst->alg.co.base.cra_blocksize = 1;
 
+	/* CTR encrypt and decrypt are the same XOR-based operation. */
 	inst->alg.encrypt = crypto_ctr_crypt;
 	inst->alg.decrypt = crypto_ctr_crypt;
 
-	err = skcipher_register_instance(tmpl, inst);
+	err = lskcipher_register_instance(tmpl, inst);
 	if (err) {
 out_free_inst:
 		inst->free(inst);
-- 
2.51.1

