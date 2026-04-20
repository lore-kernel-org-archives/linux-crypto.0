Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C1A38237D;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667021; cv=none; b=mA3/hZol+Rtp289maKTgZAXbCbuKOdhsdfp1/zmFA4+51xuN6WuJ8xZ4whziWgtmGMShv1t57UFFRKvPKrsW19lk4gu7tinhwHndrprXnS7cSIFvitNTn+AZHhqARSktLA7M4xD42G6cgC77uJU5T3ljKEO7nYKYeYnyb8mSzm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667021; c=relaxed/simple;
	bh=X2+q+aJboloJQk3XMt/URka1eJzNC8C1hO0VpXxY5Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT0E67Rwhza3dJOL1m0driNjb2ZZ9to3buUzEZrk5ysxL/GoUeAdRNPD/OmuKs1c2senzdKQ7e2Ib/9JrdkVVK1UXH27K3YSDasTuS5bhahS4JeLTuL1l/FOkQgTWx/+DIj9z7Nz+DPaWQ6HfzgGepupuGWmFvYD87BUJ/I6O9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVano3wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVano3wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656E1C2BCC4;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667021;
	bh=X2+q+aJboloJQk3XMt/URka1eJzNC8C1hO0VpXxY5Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVano3wbEpMjZTDIwtherM1YCs7pj2WiIAElQ6CR3EzOLmPD344kaHrTc2LYo/Pbe
	 Dpy7ZXIOGig4WXR3z5ySBoGLdhm7Ut5nhKobXoX2eIKD5EngnU0e0bPwgT1y237tOs
	 N0RCEVY7lpWeOxtHvTy5gvevnDfndMgawzdYPpBYLmXfO8utBkgx3negnCCFFRAVfT
	 Kd2XBkPGn+U4rbQOy35c+fKHVXpVY2vOnyzH0B5ONKvXFArZIH2FUO1EHsjBd9xWkW
	 KAi0CM9mgW6W+NvrtC6HDSBCKBv0SJI2GAS1MiRTbKE+Db+spQOoK/phc1fZxxoVDy
	 pFC9L++PKzjkw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 07/38] crypto: drbg - Remove broken commented-out code
Date: Sun, 19 Apr 2026 23:33:51 -0700
Message-ID: <20260420063422.324906-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commented-out code doesn't compile.  Even if it did, it wouldn't
actually do what it was apparently intended to do, seeing as the "test"
for "drbg_pr_hmac_sha512" and "drbg_pr_ctr_aes256" is alg_test_null().

Just delete it to avoid keeping broken code around, and so that there
isn't any perceived need to try to update it as the DRBG code is
refactored.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index f6bff275c31b..bb8ddc090307 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1217,40 +1217,11 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * were successfully and the following are not. If the initial would
 	 * pass and the following would not, the kernel integrity is violated.
 	 * In this case, the entire kernel operation is questionable and it
 	 * is unlikely that the integrity violation only affects the
 	 * correct operation of the DRBG.
-	 *
-	 * Albeit the following code is commented out, it is provided in
-	 * case somebody has a need to implement the test of 11.3.3.
 	 */
-#if 0
-	if (drbg->reseed_ctr && !(drbg->reseed_ctr % 4096)) {
-		int err = 0;
-		pr_devel("DRBG: start to perform self test\n");
-		if (drbg->core->flags & DRBG_HMAC)
-			err = alg_test("drbg_pr_hmac_sha512",
-				       "drbg_pr_hmac_sha512", 0, 0);
-		else if (drbg->core->flags & DRBG_CTR)
-			err = alg_test("drbg_pr_ctr_aes256",
-				       "drbg_pr_ctr_aes256", 0, 0);
-		else
-			err = alg_test("drbg_pr_sha256",
-				       "drbg_pr_sha256", 0, 0);
-		if (err) {
-			pr_err("DRBG: periodical self test failed\n");
-			/*
-			 * uninstantiate implies that from now on, only errors
-			 * are returned when reusing this DRBG cipher handle
-			 */
-			drbg_uninstantiate(drbg);
-			return 0;
-		} else {
-			pr_devel("DRBG: self test successful\n");
-		}
-	}
-#endif
 
 	/*
 	 * All operations were successful, return 0 as mandated by
 	 * the kernel crypto API interface.
 	 */
-- 
2.53.0

