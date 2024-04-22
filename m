Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875041BC30;
	Mon, 22 Apr 2024 20:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818162; cv=none; b=YRtduT8M+cwx4nwaXkpMqh1BmI5Y/2bhBqlIEl0jSOnmvCb6jajl6r0rueIAZOnvGp6h0OwbQijEpzLBD0gVM4pIw6MFSv6titqk5eecp0E1sCVpoWNNSVrJj2IMU/9W2P57nhNLVT6jAEuiz+rk7C7pX2kMcjWYvSeiLcwJTx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818162; c=relaxed/simple;
	bh=GMvvTyTptY381bus5AKP9+Zcbl57z9O5+351qZUIEJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a04tzGqs/g736XmBXE+1YuBLxv1DCr6/cKkJBIWwB8fzCd8m6O1vk/hIUhthPX9nyMmWaPN4TPXHdLEjfnrRsCQ2sgPWujX8sC/wUPW5HNoYA2pF2n2aN3dQRkV3AE5jb7aE7n5BwcWmfZUJFckX2XRh45GFclUETo05x+BWEME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xk/q0l0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xk/q0l0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D41C3277B;
	Mon, 22 Apr 2024 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713818162;
	bh=GMvvTyTptY381bus5AKP9+Zcbl57z9O5+351qZUIEJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk/q0l0DX6W6+f1glrMirEixqabVzY39wigVDaGL0vXnkZx7JNiukS+/5qEl77Yq4
	 EUZM+dwyxnSryPavreuMfpWsW3NIvqOHmuGkxYBos+i2YntMk8HfjxNTLC8nhDOnUM
	 DZ5fVAUOsP/894g2ARQVFP/K7FOADtHtJZpKp7Sp+olrClhESgYTpbF7iYh84tmuAj
	 2tDetLehMqV2vtvqQmahH50ohHzZvzFa1vU5cvUDmtoDHa83mO1SYKZnxkvwajlXnJ
	 Qy4zy0o94iZCcBtqTx2qqa95mCIFxLJBsVBeQFX/WU4+alH3XYuVO/H8YB5rc+oLiV
	 fzK3AIKALgH4w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/8] crypto: testmgr - generate power-of-2 lengths more often
Date: Mon, 22 Apr 2024 13:35:38 -0700
Message-ID: <20240422203544.195390-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422203544.195390-1-ebiggers@kernel.org>
References: <20240422203544.195390-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Implementations of hash functions often have special cases when lengths
are a multiple of the hash function's internal block size (e.g. 64 for
SHA-256, 128 for SHA-512).  Currently, when the fuzz testing code
generates lengths, it doesn't prefer any length mod 64 over any other.
This limits the coverage of these special cases.

Therefore, this patch updates the fuzz testing code to generate
power-of-2 lengths and divide messages exactly in half a bit more often.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 00f5a6cf341a..2c57ebcaf368 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -901,18 +901,24 @@ static unsigned int generate_random_length(struct rnd_state *rng,
 {
 	unsigned int len = prandom_u32_below(rng, max_len + 1);
 
 	switch (prandom_u32_below(rng, 4)) {
 	case 0:
-		return len % 64;
+		len %= 64;
+		break;
 	case 1:
-		return len % 256;
+		len %= 256;
+		break;
 	case 2:
-		return len % 1024;
+		len %= 1024;
+		break;
 	default:
-		return len;
+		break;
 	}
+	if (prandom_u32_below(rng, 4) == 0)
+		len = rounddown_pow_of_two(len);
+	return len;
 }
 
 /* Flip a random bit in the given nonempty data buffer */
 static void flip_random_bit(struct rnd_state *rng, u8 *buf, size_t size)
 {
@@ -1004,10 +1010,12 @@ static char *generate_random_sgl_divisions(struct rnd_state *rng,
 		unsigned int this_len;
 		const char *flushtype_str;
 
 		if (div == &divs[max_divs - 1] || prandom_bool(rng))
 			this_len = remaining;
+		else if (prandom_u32_below(rng, 4) == 0)
+			this_len = (remaining + 1) / 2;
 		else
 			this_len = prandom_u32_inclusive(rng, 1, remaining);
 		div->proportion_of_total = this_len;
 
 		if (prandom_u32_below(rng, 4) == 0)
-- 
2.44.0

