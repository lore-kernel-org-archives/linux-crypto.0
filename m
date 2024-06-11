Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FD816FF5F;
	Tue, 11 Jun 2024 03:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077752; cv=none; b=jEysxPfSfYAvDPYwAHeertj3kiB66wMflP6rbkPAkD1eIwUvy2g+bFbuGzmzdsAFcvNr4fA5IQ74Qydkj4wEN/YI2Kex+8NBhW+TpyHxLYPJNXXdpZfvQh27yqRq/O8ipy13PNV6eLg/c9+qur0UysqPWIHlwIDtNJrwXnHzvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077752; c=relaxed/simple;
	bh=3Myc2DjRilGP9scN5V2L55rhYJGZy56duqw2t1iLq/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRimsBEZpVLVVld8dnzQO+6+B5nFbW2CMibDz51NQkHh+fqFQEyNaqGwCvj4TwQEUPRTfakEWXJmbJt2AUqC/h2K/FjIaITt5wktfjBL3UCIfFbJvYUsFrn4Qoxl1VSfpVz5DSd5zhxRkibdfZtaM5aAjjAvA2ZltsUzvjYuqCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFRkrBGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFRkrBGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460CBC4AF53;
	Tue, 11 Jun 2024 03:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077751;
	bh=3Myc2DjRilGP9scN5V2L55rhYJGZy56duqw2t1iLq/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFRkrBGrzaqTfflif8UOdiNJYKo0O0Z3Yxu8SjeII2aGfrrGuD9V0CM/aULKjG7gK
	 BB/az7T2Inde2WmXConss6u8WogUIwi4OO0qywljJFHOIwY35G+YEpyC9OLCLgYvHp
	 Pbo42tWm3pgDculHkV0vXW0I+jMtydn2RZNUC4HahFF5B06pjmuVGXaVl2XwxXxbb5
	 mAOwAc+03t475yA0pM7dQFRXfXJW3CNe+TVBvpCxwy89PG0JEhQpSek8cdlAkpgWRa
	 c8jFtzXcVXJCV9kwqA6KULGdnmkfid4R8aZPme2JyiIQ9JKcSfOkLdWpT0ptOMjwev
	 g2M060zbMuDDA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v5 02/15] crypto: testmgr - generate power-of-2 lengths more often
Date: Mon, 10 Jun 2024 20:48:09 -0700
Message-ID: <20240611034822.36603-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
References: <20240611034822.36603-1-ebiggers@kernel.org>
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
index a780b615f8c6..cea2de6b1532 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -914,18 +914,24 @@ static unsigned int generate_random_length(struct rnd_state *rng,
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
@@ -1017,10 +1023,12 @@ static char *generate_random_sgl_divisions(struct rnd_state *rng,
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
2.45.1

