Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F3185E4F
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jul 2024 19:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720033511; cv=none; b=s+6Gy7Sd5nDdJnHp/5wP0x+6GH4WZ6OE2PxgAhRf0CjQjH5r+yxNt2gZzgZLRgHzYAEGjd+sY7BlWQcn8VtOWyKIm4+naKsr7AH6Jiu0k79CHvmDsHWXUPyZdLzABzywxDXzwfIPdARHTrk8z3f+1XzwlJp0On5vIAgBdmUfDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720033511; c=relaxed/simple;
	bh=2Vz6hJ0h/TklevmbNfooUTLTupNNk8r/DeolGS3CKWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vzd3na/YuOpCManSHCCaEM15HiaexQAkWQocn66JDm2ecDbTBKRxilDHTcqgTP5NPZtThSCwDquXKdhpyiKSqB9VHZF9qpPfG/SWb1kBY4xLY+emkWQjDqkCo0YW1RjeTb+AAB4zQIclQJtTUb2q0uasnVpbkee3Fy8HRDktuZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODE1v+ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODE1v+ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2523C2BD10;
	Wed,  3 Jul 2024 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720033510;
	bh=2Vz6hJ0h/TklevmbNfooUTLTupNNk8r/DeolGS3CKWg=;
	h=From:To:Cc:Subject:Date:From;
	b=ODE1v+ey7nJvOvCjIivqGz1zkiGI0vIW11lqLynWKg5NOIBLM26jZ3yzRXMSIO6Lz
	 OX2BFWifslAUEKZMZCVKo/2XikhvDwPnZwvz+YESaV0ZcQtxDLHlVEAV8keAlU+rdC
	 vxsTq5CBy2jgd65hLl9LEUSVexLIEtyfyz/Rzvx+/RscHGW+njBsZzQFbjznpQUVXx
	 K4hdLP7ml2+0xDRC/1Lz+RBWUdV9+OtK1id/VF1XfK85KYAWytUtSBInaydKl/FVWn
	 fcvi1g6NFDtyP1Ep/sF2kbRCnQzcxQ3NYqLddEY5U/+o+s2WB7ioYY2OjNaottXpDO
	 ULYlF+HIDVqbw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: testmgr - generate power-of-2 lengths more often
Date: Wed,  3 Jul 2024 12:04:31 -0700
Message-ID: <20240703190431.6513-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
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

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This is the same as
https://lore.kernel.org/linux-crypto/20240621165922.77672-3-ebiggers@kernel.org/,
just resent as a standalone patch.

 crypto/testmgr.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a780b615f8c6..f02cb075bd68 100644
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
+	if (len && prandom_u32_below(rng, 4) == 0)
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

base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
-- 
2.45.2

