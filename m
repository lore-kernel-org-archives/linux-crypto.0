Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1F32A3C3;
	Mon,  5 Jan 2026 05:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590104; cv=none; b=RYmGtR9+g74wPpILtoeXP5Po0pbe2YERzJ9+RnOBUcsujpdCEkWOc2hQ+pF92PZvl6DurAKLpJgZcqDpYKz5kyh29vU03ngQjRRFbGpc07mkN+yTUAGGG8xxK20RJ0mM01kEAeEkS/L8Tk+jrYHSSZcy0kTM7vZq6H87MUvCuKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590104; c=relaxed/simple;
	bh=klPJ473PykKQQDYl1om5YMlpRUk81c20WTNsOMHP7DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5nJjoEcgKEP+HZYxQ2FzH/zdtQ6QePu5yyyO1NaWmu2cTGr2wpjSVyFi+9NVtltwRp8UOXW7paW+soXL3RBLlqn2+BkSWXC2Nn1izYxi5FaWtW9bbiySETyDopSadfyqzekh9o7h8IgzOgTWO5+2jAbdekCk/dnceKSUVTtHK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHgMZsjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHgMZsjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0343C116D0;
	Mon,  5 Jan 2026 05:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590103;
	bh=klPJ473PykKQQDYl1om5YMlpRUk81c20WTNsOMHP7DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHgMZsjZMHek5raGp9g4rQhMLz2r2A2VSURUybAP2Cxx+6Ssxofsf4uFiW7PHNrTr
	 4GcZbeM1ankeyfaCs+YLYh+37aFeXhTqf74mKTHvp8g8IpcUt92ndg+QZ8kR+Hmii+
	 pp9HT+sxj+akKmL0CinvqZOieJKQYibROmAYqdxYjeOCAI1EbB6kres3FykuAc+p0x
	 fDPK6mTfflJDPsC18bTxnw4qRTdSL8OSOURKrt84Jk2RxdrNy4WkOvkSKRHMkl8N38
	 ynLZheSoFmmfOpvBaCGWb/b8fYimMD6hfL6muOcB2p2mIsu/ppKEzPSBjECrWPeafC
	 uRfZpAT6wO16A==
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
Subject: [PATCH 19/36] Bluetooth: SMP: Use new AES library API
Date: Sun,  4 Jan 2026 21:12:52 -0800
Message-ID: <20260105051311.1607207-20-ebiggers@kernel.org>
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
 net/bluetooth/smp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 3a1ce04a7a53..69007e510177 100644
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
+	aes_encrypt_new(&aes, data, data);
 
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

