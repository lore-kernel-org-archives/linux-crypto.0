Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195AE376A02;
	Sat, 10 Oct 2026 08:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620290; cv=none; b=C4N3Dk/ENdOrHGeEXgcynLwD6KdyKC1UYKpxwBDX2bc9lKy2Qai3GhW9H/DzIPVZ89k5JcM9Er1jOkgVHCTy2VRurLP3UC7pewgUxFiZROLNr+zBxYCF55/csvBqFziVF4P3u0GXcJ2yOFhw4CiTF96DxmEXoDJTBmiQi+sjmCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620290; c=relaxed/simple;
	bh=OS9EwkaKxHu1KTV4vOtxKzx6o3vEAVWBmk0osN0R4xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TFo3JM881h3UMwhEHgFRYebwDL93fzKtejkbQj4fbDEmMDSGiLZS0V8yxN2D46C4Jb+FBOYzPQBEACLVzE8DyHgg6f2Vny22KJ26iHWGO/T2L7KJrTy+7AYEgySETDxsdF+HB35K1czJbrtrp2Jr9shCkbbERYMV3OyvbBHr4UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSsYTjQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSsYTjQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A081F000FF;
	Sat, 10 Oct 2026 08:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791620289;
	bh=KN8inG2eDZZjrXlblF7pQPwBcbGnsDcd2/rkjsC9adM=;
	h=From:To:Cc:Subject:Date;
	b=mSsYTjQg96Sj1BvFIjPMenFd+3xAjLBfZmgzAEQJqw/xvvb67z9FCXqSPGgFECiNF
	 lAy1j7GS2b3Dy0D2dqJ7lRSpt0ZbVuwSA5UqJv1zeW5uVT8t55u9lpZ2p2r7I2BbWk
	 YTYtKpIcYQMxvg79PDw5l01ybkqKM/JQDQq9su7uj525WPjG2+bO0IKP17Jgm57KOj
	 txwRSugKEabFu3Gi167D0bYAlthsH95eAOb3I7ZkzRKm7vIk1Q9jyUJs/z1pd3hO8w
	 h0Lqeg6z2CMdLf5cQztqJbxTzj6jzcEGntHKfsTcGdX7RH1WgsiDWYQev2gudSsYun
	 lEsUy2sqAD2yw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18,6.12,6.6,6.1,5.15,5.10] crypto: drbg - Fix ineffective sanity check
Date: Sat, 10 Oct 2026 10:17:20 +0200
Message-ID: <20261010081720.17151-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 040ad83b0e8aa065fd2fc641cacba8491a8b186d upstream.

Fix drbg_healthcheck_sanity() to correctly check the return value of
drbg_generate().  drbg_generate() returns 0 on success, or a negative
errno value on failure.  drbg_healthcheck_sanity() incorrectly assumed
that it returned a positive value on success.

This didn't make the sanity check fail, but it made it ineffective.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

This commit doesn't matter for anything other than certification.  But
it did have 'Cc stable' on it, and it failed to apply due to a trivial
conflict.  So it might as well be backported as intended.

 crypto/drbg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index dc8996789da6..51c36cfa8eff 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1986,7 +1986,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2030,12 +2029,12 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
-	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
-	BUG_ON(0 < len);
+	/* overflow addtllen with additional info string */
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
+	BUG_ON(ret == 0);
 	/* overflow max_bits */
-	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
-	BUG_ON(0 < len);
+	ret = drbg_generate(drbg, buf, max_request_bytes + 1, NULL);
+	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
 	ret = drbg_seed(drbg, &addtl, false);

base-commit: 725bd2f3c81d54edccb66fead01d4c0c222e2231
-- 
2.56.0

