Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DB8EDE;
	Tue,  7 May 2024 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715041517; cv=none; b=Zl07JVnNGXXb6rKBJrsVNDEjoQ7fMxrQhYmAKzTf8G4lMxFl1IIZOhPGPHxC7eAIbO4BNuZo27bkGjyFkeWV5xBrldiiw56lzQlXP28z+PJIr7xLFT51tVHUV0xj77QEek2TJiqgBcJ3TTw/2+YqmzOjTdXqRbYE1nD+x3d+62U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715041517; c=relaxed/simple;
	bh=Uz9jUnVkeFhGTzlbzEDSdQYkq7NwLZLlyFt/EXJFwgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub8kRpAD+bbYa3fyv0tkLOUic9U8Nvm8OwLtUSh3ua5T+xkKoy7048nAxk4L2Tu0aN+1MlpTxymJcWcHzV3dJcdBmd712B5XDNep3W9uM8U4jCPzqNqa2Z734blpoADwP6pCSq95Bgys0rAKXx4cXjPUX0RfnEWth3+aWuLwWEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdoVgErU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdoVgErU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AEBC4AF68;
	Tue,  7 May 2024 00:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715041516;
	bh=Uz9jUnVkeFhGTzlbzEDSdQYkq7NwLZLlyFt/EXJFwgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdoVgErUHlFaNHNPh7L2HqNT2WhznXXZhVrDA03ETRpynG1rucaSJefVdt2C+j4Dg
	 pByuM9zrY3/oKGhLDINRgqHVGjPoU6hPpffQnAsgTPBJO8WmuwAeehgVemsROA0O35
	 LGulunY6Bce+vgQqqhKRnCdScqv2Px2OYsSLst/Ei+5/ko7Fa9QPG/WUAabYP6KybP
	 tGCMblilUdPk+SI7OsBRZYKJb9uEKHZ7ybTYF4XqtWww0jXcVUM4/S5juxhzlouGx1
	 CFGaSIC74zn60cHGQoYvGsAoAw+x4S2kEWBwZFxbSpL/RVotxMl4bkzZsZ0TzigmzZ
	 SOCmbWoyvaPig==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 2/8] crypto: testmgr - generate power-of-2 lengths more often
Date: Mon,  6 May 2024 17:23:37 -0700
Message-ID: <20240507002343.239552-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240507002343.239552-1-ebiggers@kernel.org>
References: <20240507002343.239552-1-ebiggers@kernel.org>
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
2.45.0

