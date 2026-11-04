Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833591;
	b=qh4aaVLlSOQW6oc5DcGLWPzDPkO3umhqX9DOH+utoSXc+0x4ZVH76bF4csZ9gql8q7WP
	 hgKbDOb/Lu+oybX8gmGuUcT1phftGgxYRWlZd2Ipjjod1IvNfov8yjP9WAuip1054X9NR
	 JUUCLKsA6sEnhzrvs85VQwj5Jz0PLs/WMNwdaMXEzGzoMukdjISF3if6ATqg95hWvL8UJ
	 Jzdg+iO1mObvjm77bJD24mb1YsoejuhGjYFuwE5TXGsvVFhVGItdPOtgYwTye6X2kavn4
	 nnnaRoxm0d7oOKkg3AWkci5CHlzegrtgYP+6q5pm4Q2KwmFIf7jc2LJetQWeiRv6P8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pDXDt2XnKnvIkv0fhrCARcFFHs/O/8o0ptPXatMolHg=;
	b=X98IqW2tyMzhUJCIkoj91Lk9ceTm8A9qdy8/zwLbnym+lDTNvwQzksKFm+0JGWz+4Ovn
	 z0DB/Z9rG9iHioAHPdxx0wrhfGx/kGOTyMFv3j9sHLs3rG9M3BNXFEVablRDhYXx6CMXO
	 qWxbJMFU9Cn8mutK41IlQrek1QZshoMgh7nLnLIJPRfXAQEa4KxmzuVdMsOHIpKIlaD2g
	 q0OWw/TH3bvHqBRpDWQr+dnJ+X0d5hpkykF/PXJGpN4ekeWno7dwOHG3BwWOVyCKxP34d
	 PL93EmYbAH/jHlrtsnlxq4eOWts/8tROVOs16YYFhbfR5jOVQJ0xO9itlgGQquQIMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hr5bHhu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BDE606A329
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 23:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hr5bHhu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4988B1F000C1;
	Wed,  4 Nov 2026 23:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793833590;
	bh=pDXDt2XnKnvIkv0fhrCARcFFHs/O/8o0ptPXatMolHg=;
	h=From:To:Cc:Subject:Date;
	b=hr5bHhu0noW2/5ZS9nl6Xu+xiIMAfJyqULk55e5G3Cscu1p8PdgmWZjkH1K/1Jk0l
	 rY+0Doy1tuZJx+s160lnIfdt8fXhQB/c7cFIlJE0m/P9GzxWKge/FPRvMAfFJKIcVS
	 uomxSeSJCql/twN+o9Ledi46fgc8ZZ4BN8kwbe2/0eB/tkW8FzEFNKOcMSNgxsmSzL
	 cFfuIb4izCvtjMwEAXtgp562jM3L4OwxnSGO/aHpoVxFbNdS9K+iKbvgajfHbabTrC
	 DsHjCdkB374EqQXxn9/WQUfcUq+pbbwqM1Ns4crGtgqkqZad/LBFMTKVgVo1eqEpgW
	 DhmtOGCgrviZw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: tests: Add some additional lengths to the ChaCha benchmark
Date: Wed,  4 Nov 2026 15:06:26 -0800
Message-ID: <20261104230626.87060-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the benchmarked lengths below 1420 are multiples of the ChaCha block
size, and all except 64 are a multiple of 4 blocks.  Add some additional
lengths to cover a wider variety of situations.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/chacha_kunit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/tests/chacha_kunit.c b/lib/crypto/tests/chacha_kunit.c
index bbf73dcbafee..2e002e46976e 100644
--- a/lib/crypto/tests/chacha_kunit.c
+++ b/lib/crypto/tests/chacha_kunit.c
@@ -217,7 +217,8 @@ static void test_chacha_rfc7539(struct kunit *test)
 static void benchmark_chacha(struct kunit *test)
 {
 	static const size_t lens_to_test[] = {
-		64, 256, 512, 1024, 1420, 2048, 4096, 8920, 16384,
+		64,   128,  200,  256,	511,  512,   513,
+		1024, 1420, 2048, 4096, 8920, 16384,
 	};
 	const size_t max_len = 16384;
 	u8 *data = alloc_buf(test, max_len);

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
-- 
2.56.0

