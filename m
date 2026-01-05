Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152B327209;
	Mon,  5 Jan 2026 05:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590095; cv=none; b=uDY/5BV2AzTyuG0KonhigfI+Hvtt4z9GnV2ewGhsDQJhw3lDzRYUM6yYh+DIxOZnLYI04OuEckK8zWxMlnbZ2YuQoWMd6doXo7dd3vDIwkAY+zi0Jbhq1UhFhWXmKjNrjrXwvNREH7euUuE7gvuqFuu38ScntqhRoDdaGTpM/40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590095; c=relaxed/simple;
	bh=r+Qzw8crmbVQ6JrhV/JdglMrrXxEutC0ymCPwabmY4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9jDx9EwQLjwcy8zdeo9hysmmpBCpVYvu4ts/R+GtGy6JPT3HAFlJROIuxPd2gds2YstvyrEQlHgWZRiBBv8kJa3Nj8D6R4XvmPXXwXoaGukFPkbUz8RLeQsKjEP/LNOGMFN9nCOWNs+2aoVLDuKBJHh7FtwItxLsm1I52SbOQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ha2Mg2lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ha2Mg2lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5DAC116D0;
	Mon,  5 Jan 2026 05:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590094;
	bh=r+Qzw8crmbVQ6JrhV/JdglMrrXxEutC0ymCPwabmY4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha2Mg2lmVEyVLJsqAxVeeF3Hs64jrH9zp2Xowl6MfoO/WjdTlOUp7UNsCTZkTJtfU
	 2AYsyz02/MC1BAUuUuoBZAAKn6CAkbwzdKIP9v/9RaFaVlsPUTBR1Woohd2oKK9FMO
	 5Rot1rQ1o2dNTQtuIt/afr1Uq6xrxjiZyQ+IT5GvmdQgtjAHrsK8GdwhELc8E7+eRv
	 9pHjeEyKHYLlQcEY3FNTJCSA4nzsOny+dsca1a4hl1RnrQpY5UnvlJGyvhEzgNgW8y
	 /GwmtZUqbDRE9WdmGEsKpgpkR36Z61nAyxx0OD8nadJY+jrz/URE7Bdw4del+ewJqI
	 vkYTEb2DdJScQ==
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
Subject: [PATCH 07/36] crypto: aegis - Switch from crypto_ft_tab[] to aes_enc_tab[]
Date: Sun,  4 Jan 2026 21:12:40 -0800
Message-ID: <20260105051311.1607207-8-ebiggers@kernel.org>
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

Instead of crypto_ft_tab[0] from aes_generic.c, use aes_enc_tab from
lib/crypto/aes.c.  These contain the same data, so the result is the
same.  This will allow aes_generic.c to eventually be removed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig | 2 +-
 crypto/aegis.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 12a87f7cf150..443fe8e016fd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -764,11 +764,11 @@ endmenu
 menu "AEAD (authenticated encryption with associated data) ciphers"
 
 config CRYPTO_AEGIS128
 	tristate "AEGIS-128"
 	select CRYPTO_AEAD
-	select CRYPTO_AES  # for AES S-box tables
+	select CRYPTO_LIB_AES  # for AES S-box tables
 	help
 	  AEGIS-128 AEAD algorithm
 
 config CRYPTO_AEGIS128_SIMD
 	bool "AEGIS-128 (arm NEON, arm64 NEON)"
diff --git a/crypto/aegis.h b/crypto/aegis.h
index 6ef9c174c973..ffcf8e85ea69 100644
--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -60,11 +60,11 @@ static __always_inline void crypto_aegis_block_and(union aegis_block *dst,
 static __always_inline void crypto_aegis_aesenc(union aegis_block *dst,
 						const union aegis_block *src,
 						const union aegis_block *key)
 {
 	const u8  *s  = src->bytes;
-	const u32 *t = crypto_ft_tab[0];
+	const u32 *t = aes_enc_tab;
 	u32 d0, d1, d2, d3;
 
 	d0 = t[s[ 0]] ^ rol32(t[s[ 5]], 8) ^ rol32(t[s[10]], 16) ^ rol32(t[s[15]], 24);
 	d1 = t[s[ 4]] ^ rol32(t[s[ 9]], 8) ^ rol32(t[s[14]], 16) ^ rol32(t[s[ 3]], 24);
 	d2 = t[s[ 8]] ^ rol32(t[s[13]], 8) ^ rol32(t[s[ 2]], 16) ^ rol32(t[s[ 7]], 24);
-- 
2.52.0

