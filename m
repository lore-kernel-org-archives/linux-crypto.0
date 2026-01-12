Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B96538944C;
	Mon, 12 Jan 2026 19:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245808; cv=none; b=CaonqUlNDwVHwn3KlryRv6d5uALg4ag8CkXwpHKzuWSkfaAxkTydgDvThmHIAVlOzqFJrwtUlTBDaYYAGvC6LirgnIbDfmTeJ9U1t9Ay0QVUvKShYpA68DObhmwBsNSqpMqjU6Be8I2tzkSYeE1nOH4ZcTsm0gQy6YCZF9+XyiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245808; c=relaxed/simple;
	bh=/+92A2W8sPhnyqgSvgeYDPLSqRQhqBCuSe5uLYbIIyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoSWDbOguiakeP9vkymh6U/al8ugLRUxiK1e6iULxRH1COOTqCEO9ZCbrrbFtL0zSL48mTKfIFR5VasX/GT39SvnLjVe4fMgPHz6GeuMd9gdhP3VpsnwQ5+UomwNHyLQEsH05LXCjryPvwZCR/BqktxddTqbHAfp4pImAgcYULo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1GvvbAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1GvvbAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01984C116D0;
	Mon, 12 Jan 2026 19:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245808;
	bh=/+92A2W8sPhnyqgSvgeYDPLSqRQhqBCuSe5uLYbIIyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1GvvbAZd1QxRXqOx3RVwEnT8L6/7in7jYWOmXPjC5hvhKjvhv+Wzfs5/LUMHR8Lc
	 SdGTbOSLXj/2W/iKIhh/AT5PZwYWYZ1BOouRjUMUk2hghvgAR6+JvM8kF0KbCUU7yp
	 puzPO54NzZ3xe7XfNGWN6VWmD3ZkQ+dVaqDcSY/FoA3F/XNqeh1rnjNcSxjRjbPA7/
	 gqecjM8PRPEN29c60wRVNKJHik18bwbo1WjAwXvniH+AS9JnoM0gcQ2DNi5blIsfxI
	 UYBfP/Us7YHO8J9QoEFy1ANvrLWZNZs147dSPjGhBOGui77MkyOPGu0k7NMYzgIM2A
	 bXI6EI75/O3bQ==
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
Subject: [PATCH v2 19/35] Bluetooth: SMP: Use new AES library API
Date: Mon, 12 Jan 2026 11:20:17 -0800
Message-ID: <20260112192035.10427-20-ebiggers@kernel.org>
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
 net/bluetooth/smp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 3a1ce04a7a53..bf61e8841535 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -372,36 +372,36 @@ static int smp_h7(struct crypto_shash *tfm_cmac, const u8 w[16],
  * s1 and ah.
  */
 
 static int smp_e(const u8 *k, u8 *r)
 {
-	struct crypto_aes_ctx ctx;
+	struct aes_enckey aes;
 	uint8_t tmp[16], data[16];
 	int err;
 
 	SMP_DBG("k %16phN r %16phN", k, r);
 
 	/* The most significant octet of key corresponds to k[0] */
 	swap_buf(k, tmp, 16);
 
-	err = aes_expandkey(&ctx, tmp, 16);
+	err = aes_prepareenckey(&aes, tmp, 16);
 	if (err) {
 		BT_ERR("cipher setkey failed: %d", err);
 		return err;
 	}
 
 	/* Most significant octet of plaintextData corresponds to data[0] */
 	swap_buf(r, data, 16);
 
-	aes_encrypt(&ctx, data, data);
+	aes_encrypt(&aes, data, data);
 
 	/* Most significant octet of encryptedData corresponds to data[0] */
 	swap_buf(data, r, 16);
 
 	SMP_DBG("r %16phN", r);
 
-	memzero_explicit(&ctx, sizeof(ctx));
+	memzero_explicit(&aes, sizeof(aes));
 	return err;
 }
 
 static int smp_c1(const u8 k[16],
 		  const u8 r[16], const u8 preq[7], const u8 pres[7], u8 _iat,
-- 
2.52.0

