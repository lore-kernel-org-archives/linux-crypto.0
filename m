Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721ED38A72C;
	Mon, 12 Jan 2026 19:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245812; cv=none; b=O199OwoB8MLaCX4sjoRSXtHxTicw4YzDl6j6fTLgE+0j1Qp3n+gA4RF33toloUrAipKNUBnQobuch8dlc6KnUMnCHL1Y9Y5hCPs97oKxHM01kL2eaumgkCFFWp3e2pksf88ecmZLBgDSdvf/8FTzGLg0sncnppGHHeQyWtk4WcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245812; c=relaxed/simple;
	bh=WLZZawaQBX35WPW58Hz//ngE+4DAJvp0HQ0I1HlTY/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djhQfcTzGHpMYG9n1eShZB5vwcJq4XxEMa1ndl72e7+RG6IVhGdX2KyX0+5cNkwmEf0oHN4f2PWs8jeKnp3FRAHZ07ui+pfUG1E1HL4nhwL14aK1PLKJUhTQdVwuUfEK6y6dkOoLTSzLwXvqtodet8IUCUISXlo+KFwIxo/hx+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1uZHKet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1uZHKet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27E5C2BC86;
	Mon, 12 Jan 2026 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245812;
	bh=WLZZawaQBX35WPW58Hz//ngE+4DAJvp0HQ0I1HlTY/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1uZHKeto0AfyTDnkpw+maKdeM0KeDm2Q70XvXQU/RpOQN8SKGIlrpmf3qjxTie86
	 HCNSg4+UvVX3xUSdbQVP8xeeOQMJoQg1DuN+j3Q7uMn1pi8833mHKQsAMJKHJ/r0co
	 Cp9t7NfmIB9UcWHN7L1swZLb2Bt1wDVrX1d7fqpuqdvA8b11taUYiaKgJY13HpgOwo
	 UqE27wAEUeCRcKwzQPZMRSqiSF3OIPD11Gu7aUrpUal/Qv2Wf/u6wG8DO8SrVskdHr
	 mp5bV4KfXC90NInEuREpltxcfpeZYFO7VWCjJqaaviHvltHYdOmLgxI6z8RRKbwvRF
	 Fm8EGShrZgCLg==
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
Subject: [PATCH v2 26/35] crypto: ccp - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:24 -0800
Message-ID: <20260112192035.10427-27-ebiggers@kernel.org>
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
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index d8426bdf3190..71480f7e6f6b 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -259,11 +259,11 @@ static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	struct ccp_ctx *ctx = crypto_ahash_ctx_dma(tfm);
 	struct ccp_crypto_ahash_alg *alg =
 		ccp_crypto_ahash_alg(crypto_ahash_tfm(tfm));
 	u64 k0_hi, k0_lo, k1_hi, k1_lo, k2_hi, k2_lo;
 	u64 rb_hi = 0x00, rb_lo = 0x87;
-	struct crypto_aes_ctx aes;
+	struct aes_enckey aes;
 	__be64 *gk;
 	int ret;
 
 	switch (key_len) {
 	case AES_KEYSIZE_128:
@@ -282,11 +282,11 @@ static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	/* Set to zero until complete */
 	ctx->u.aes.key_len = 0;
 
 	/* Set the key for the AES cipher used to generate the keys */
-	ret = aes_expandkey(&aes, key, key_len);
+	ret = aes_prepareenckey(&aes, key, key_len);
 	if (ret)
 		return ret;
 
 	/* Encrypt a block of zeroes - use key area in context */
 	memset(ctx->u.aes.key, 0, sizeof(ctx->u.aes.key));
-- 
2.52.0

