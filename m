Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58D232D443;
	Mon,  5 Jan 2026 05:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590110; cv=none; b=eDNM+PJpT3ZpqxGLovq23v8dXoawPd0UH9rQ1SUFGjPsy9TBES+0slYQ0LI1TN8JWIoy/nUl2sborl4r6I0I8g3Bh67iYwZG5150EfpJKnRkR84nDuK4aDo6QlVeZNDVq/bboe6yK8SDaJO3HGsjsvnPpIGRa+zuWxP+8+MbE+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590110; c=relaxed/simple;
	bh=51MqJUw9vLPBjNhyqGm5KNGeBpiM474Yq2fJhY4WaSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cj0bJ5UWUsJDzjexifjMo9kkPtZrPEcGvz63ONlSaj95vKJmBSV/u56X1U5GTnhCNQgQRh7B1NFKQfC5ChnI1BgG29M/saKqtlG9J1cV0UEXIctU3ODKbo8glOriPun/CIuL9MAcSFSfPvsLLdZm3ZqMlx2qHrAqd6CDubq3gcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXSvV+Xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXSvV+Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F59C2BC9E;
	Mon,  5 Jan 2026 05:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590109;
	bh=51MqJUw9vLPBjNhyqGm5KNGeBpiM474Yq2fJhY4WaSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXSvV+XiKYdSDaoLylpVKvfPU5H02g22cONeH1AE5K3CY4QrcH+VLEe11L7WHbJzn
	 LQSqWGsgWEKCMoMaJYF+Xm5hEC43m4LeRGnKUyEVoUIPotAd44MP8wSybbaCCCat5j
	 CGqKTFDxES3LadpubNdtviwiZrJmeaUai+ibeYgYsbYGBRLhyHu5ON/yBoS0ncX7MN
	 Yl52+ZfRZsgz0TFx6YNmC1QuRryhC97RyS1FEX7bJUtKL6X9rXiLOevoqJksUXWwLk
	 owp7xxBpt2wAiibDSu/dC8MrjseY1KJivEQJxFhwfVwfauU8c3ADjYkexSt0lke601
	 5A/r1MY4KeGyg==
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
Subject: [PATCH 28/36] crypto: crypto4xx - Use new AES library API
Date: Sun,  4 Jan 2026 21:13:01 -0800
Message-ID: <20260105051311.1607207-29-ebiggers@kernel.org>
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
 drivers/crypto/amcc/crypto4xx_alg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 38e8a61e9166..1947708334ef 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -489,23 +489,23 @@ static int crypto4xx_aes_gcm_validate_keylen(unsigned int keylen)
 }
 
 static int crypto4xx_compute_gcm_hash_key_sw(__le32 *hash_start, const u8 *key,
 					     unsigned int keylen)
 {
-	struct crypto_aes_ctx ctx;
+	struct aes_enckey aes;
 	uint8_t src[16] = { 0 };
 	int rc;
 
-	rc = aes_expandkey(&ctx, key, keylen);
+	rc = aes_prepareenckey(&aes, key, keylen);
 	if (rc) {
-		pr_err("aes_expandkey() failed: %d\n", rc);
+		pr_err("aes_prepareenckey() failed: %d\n", rc);
 		return rc;
 	}
 
-	aes_encrypt(&ctx, src, src);
+	aes_encrypt_new(&aes, src, src);
 	crypto4xx_memcpy_to_le32(hash_start, src, 16);
-	memzero_explicit(&ctx, sizeof(ctx));
+	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
 int crypto4xx_setkey_aes_gcm(struct crypto_aead *cipher,
 			     const u8 *key, unsigned int keylen)
-- 
2.52.0

