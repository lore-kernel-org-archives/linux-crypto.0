Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A435322B60;
	Mon, 12 Jan 2026 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245815; cv=none; b=dDBQTZquaHUy2LKjCHOjd3t1hbQGY+2p3TICAAy8bMOZL3paStf4/v4Nklb+vVAIlJTPJ4/FZLtq1V9mkMROwT6PQsK7M0u7HD+aMlyo+7dKPojpFAUXNOYj5TAnitSZSltFZopWt3QAKQC7JgOMruv6OSXbcm11QAyKfR7vzPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245815; c=relaxed/simple;
	bh=o3zwy8vdt1uNhlRXa37yap+uRed8L836MSpoje1i5gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxm7aNaDLevXpUHjndTmlLSiSD06S+EXvBmwKJQeAMqLSm8c1LXmvQ8Scjp44MwawzICNOvrkyyTxt/bnJOY4HJi+MsOpVC73DMxPAE1mc2MAedblRPp3fjV+QqBjhLunwShUzKcm3lEKtITWQfizPVU5VwN+WMPQ2gAg9lubOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+iQkfre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+iQkfre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D62C2BC9E;
	Mon, 12 Jan 2026 19:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245815;
	bh=o3zwy8vdt1uNhlRXa37yap+uRed8L836MSpoje1i5gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+iQkfrebqurkYNcMsEDhd2QqbiCtp7wnSgHoAica72oEzTDfUKkSMUWZXpuRb9em
	 1Do/8hqedeDta5gxo8MqlDW61v9x7Q7vZTzXp2TkY2U7zjXVxEQdDb5Tc0XzAX7VVU
	 9TKEdQm8jHgXrAALBCww1rQnpHL301XBCKXcpnpH8fVqyvtxN0AZzZ4xBw/eYgSrKk
	 cV3ifLIvrwSzEZQPhWE6hzNHFva8oR20xdbCbycacxePJ6OtQUL7re5uWOMRmer5Mp
	 aKzUopZrsfMlXGNoISdPApHFyM2o8Bm7RRE27u6Iu2eUcffx29++btLMVG3D96Ohac
	 Y99nAkUMvYzgA==
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
Subject: [PATCH v2 31/35] crypto: omap - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:29 -0800
Message-ID: <20260112192035.10427-32-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
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

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/omap-aes-gcm.c | 6 +++---
 drivers/crypto/omap-aes.h     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 1f4586509ca4..c652f9d0062f 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -175,11 +175,11 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 
 static int do_encrypt_iv(struct aead_request *req, u32 *tag, u32 *iv)
 {
 	struct omap_aes_gcm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 
-	aes_encrypt(&ctx->actx, (u8 *)tag, (u8 *)iv);
+	aes_encrypt(&ctx->akey, (u8 *)tag, (const u8 *)iv);
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

