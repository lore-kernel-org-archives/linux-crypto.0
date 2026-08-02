Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8561232B136;
	Sun,  2 Aug 2026 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785711724; cv=none; b=PLnrNSnrE0Z6AV9CCazMj4s4z1yU4D9+r1K8P/joMsTcutNoWhsKvGYTvFjYiKGXDg7QhkEFAuck9FYThWpwEEJMoU7tj/R78GoFmU20jXtXQeqeNm487EpYrpHUtqgvdxkDHfM1BIo3a6eAFgUS77A6Aon0SziNUupRg2g2lVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785711724; c=relaxed/simple;
	bh=yQmL8K4SKHc9RAQBEBdy9LfMi8IUQFrhNvJZCbsKJD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2gOK2fHeu+q99/oWNHS2PMe2Kf8qNAuX2pDWld+qtrWBMNju1HJxoqccCNVs286e9IpOUPJSnhts+PbB+2eNZv+id87SdFrN+25wUk4bH/tOh8VRKenV5DhyuTl/d1EhKnWhK0bKLKV7KXYQjJg3J23Qs3e2c7BScyxSf+5Ud8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juklaJQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juklaJQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2978F1F00A3D;
	Sun,  2 Aug 2026 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785711723;
	bh=xsDoFBNG0XcHBCgcqwyp020b85v8chptiEHsK1IxUg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juklaJQ4JCsu0JdL16RBrcv0zQ14urPgOn8wEix/3SE+LKV8XF//xaqOmt6D2JKFM
	 wElTRuuCOAWXJwgr/dMPz+N+8qijbkFD1rj1B1hzfSuBGlXsMcnu2HmKrBWz0R9dSF
	 27gB5CtWf9XabVR14JKDNgRD8fUje9deJWrg3EkvspMOFOZZ4LHEblFirz/TAFpftL
	 GDiEqIhY8mhZY2TRjm4nEY558CO0/dmAXh/oXbNM6CLe/iRqBezwyaYLF+SGzXZMUD
	 J1sPAzkbF2C95jesqeyqSKrMpk9Q5gTDlKO1Tsqy3kJLAtc8go99O82qTF6bBfuY5s
	 Dcn2W6e7XII7A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Richard Weinberger <richard@nod.at>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] crypto: af_alg - Make cbc(paes) privileged-only
Date: Sun,  2 Aug 2026 16:00:53 -0700
Message-ID: <20260802230055.100746-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802230055.100746-1-ebiggers@kernel.org>
References: <20260802230055.100746-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So far the only reported use cases for cbc(paes) have involved processes
running as root.  Therefore, make af_alg_restrict=1 allow only
privileged use of this algorithm for now.

Fixes: 947d62c09436 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 4c86b1993bde..68b48d805e92 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -41,7 +41,7 @@ static const struct af_alg_allowlist_entry skcipher_allowlist[] = {
 	{ "cbc(aes)", true }, /* iwd */
 	{ "cbc(des)", true }, /* iwd */
 	{ "cbc(des3_ede)", true }, /* iwd */
-	{ "cbc(paes)", false }, /* caam and others */
+	{ "cbc(paes)", true }, /* caam and others */
 	{ "ctr(aes)", true }, /* iwd */
 	{ "ecb(aes)", true }, /* iwd, bluez */
 	{ "ecb(des)", true }, /* iwd */
-- 
2.55.0

