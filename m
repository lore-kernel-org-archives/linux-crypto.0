Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A4327204;
	Mon,  5 Jan 2026 05:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590111; cv=none; b=lmhtu7UjcmhqcOwcaSROKmEEdghHJ/4nywwD1qvQ6KTVr2fzOvb+8QfRszrYdfETK5Vqy3nz5TQQo2bsWJ2YuNbqAn9T24StyoG+8USiPbbxeUpwbDrfVq97T+JHe7y1q5q7pAsVlr1M3MqfuOaeWMza5CUSIQit3RFlojV58OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590111; c=relaxed/simple;
	bh=aczZF388MJyjmHPpFhPybAXNgrNBDPfQD3X1AxBltYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo30q+x5NHcjtUkB5aCvJXM0TsObensA9zqpwhwdr6Ndg4HOqt89aEivq4J5Lw05TpYitStSNk+hyJMButNjx5Q0QXRrQoRaFEmGMuvKw9p081exDGR5ptcRoO2pnCUke/jAyQYvb76sG8foI1+Soe9U+0zfRfKI/tmWjH655q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COMWjura; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COMWjura"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF868C19424;
	Mon,  5 Jan 2026 05:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590111;
	bh=aczZF388MJyjmHPpFhPybAXNgrNBDPfQD3X1AxBltYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COMWjurarSx0tc1u0S//8fc2KTuNtS7ijGjFRXrLCJRnu+BuhGv5rgrBzbQUJ9eF5
	 fVBqlLQCuTXn/8/pQ/36762MnXgp49Y/vHrPz+Wy10++9qVLD712eBBI3lj9aXnofW
	 w9BoBKOvqzQIGb/Y3WbOUvJy4+90x0vv1nkK6HHPztOSezbco4jwJZe26f9WBPqpFS
	 Y33A2c+vhXOxvM9uuhpD/HfuD9O3XcHzM9gQcrRCNuE3jgGt8ftga6xph8pPM2WNwy
	 LnP5SXRnh6sRdcCJDF0YTvrEIRBr9CnT0phwNCdB/LyCfXliTTCkqThp8KHp5P5g2+
	 PtPGFK4PWLXCg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 31/36] crypto: omap - Use new AES library API
Date: Sun,  4 Jan 2026 21:13:04 -0800
Message-ID: <20260105051311.1607207-32-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note: aes_encrypt_new() will be renamed to aes_encrypt() once all
callers of the old aes_encrypt() have been updated.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/omap-aes-gcm.c | 6 +++---
 drivers/crypto/omap-aes.h     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 1f4586509ca4..efe94a983589 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -175,11 +175,11 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 
 static int do_encrypt_iv(struct aead_request *req, u32 *tag, u32 *iv)
 {
 	struct omap_aes_gcm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 
-	aes_encrypt(&ctx->actx, (u8 *)tag, (u8 *)iv);
+	aes_encrypt_new(&ctx->akey, (u8 *)tag, (const u8 *)iv);
 	return 0;
 }
 
 void omap_aes_gcm_dma_out_callback(void *data)
 {
@@ -312,11 +312,11 @@ int omap_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct omap_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 	int ret;
 
-	ret = aes_expandkey(&ctx->actx, key, keylen);
+	ret = aes_prepareenckey(&ctx->akey, key, keylen);
 	if (ret)
 		return ret;
 
 	memcpy(ctx->octx.key, key, keylen);
 	ctx->octx.keylen = keylen;
@@ -332,11 +332,11 @@ int omap_aes_4106gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	if (keylen < 4)
 		return -EINVAL;
 	keylen -= 4;
 
-	ret = aes_expandkey(&ctx->actx, key, keylen);
+	ret = aes_prepareenckey(&ctx->akey, key, keylen);
 	if (ret)
 		return ret;
 
 	memcpy(ctx->octx.key, key, keylen);
 	memcpy(ctx->octx.nonce, key + keylen, 4);
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index 99c36a777e97..6aa70bde387a 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -96,11 +96,11 @@ struct omap_aes_ctx {
 	struct crypto_skcipher	*fallback;
 };
 
 struct omap_aes_gcm_ctx {
 	struct omap_aes_ctx	octx;
-	struct crypto_aes_ctx	actx;
+	struct aes_enckey	akey;
 };
 
 struct omap_aes_reqctx {
 	struct omap_aes_dev *dd;
 	unsigned long mode;
-- 
2.52.0

