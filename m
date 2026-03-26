Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677D9215F5C;
	Thu, 26 Mar 2026 00:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484206; cv=none; b=s8ehDaSNK7vchgMgXES0hgPWtKIVre6ZZyc1Ldjou5b03hXp9kDF06uTP14XnSNcuLu8Z6VjbW2FOFZ5SNymr9gTKzum8Kist5/H3AGO6PnbglmFSOetBiXoSc1PLaBNc4Jw6TaGoS+qvg1esbdDekzJAtpkincdoR35639qN3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484206; c=relaxed/simple;
	bh=b0/9b/j23QPsJQ1pApefZrlxDXVK8JIv6o1ngIZmr9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYmWQl/NEFUIwazBKHcUDLkl2vsX8P/rT8HeP14jFiVocDQiYoQ7tjss0R/j5j7ntg98bjCK/ISUwpPxNqIZ0/tWBjyORCH6Pqio0OFkpxAdJZ6tej4h5W8Gv+CXKBY2xB/519Llk+qMQkEP3g1P1nVzA3M0MB8Knp3W5OnJQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0NAbTCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0NAbTCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438F9C2BCB5;
	Thu, 26 Mar 2026 00:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484206;
	bh=b0/9b/j23QPsJQ1pApefZrlxDXVK8JIv6o1ngIZmr9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0NAbTCtv3sAhG5/8AYqHK0RgQy9mISxvmLWfKkA8jS8o36CILlL0dYZB47Mtk89A
	 Z4/2kEeIzO+K9//O6vNHtPxJ7KOpnuSSALYC8g91DIO7oJYhGTbbejLgegBnBH3p7q
	 +xH7w40vANwVIbndUxPEgD7luBUuTScuD+YHOidJI/oeRSIdCEbtapm3fPbb6enJTp
	 dFZokPkNd+fy4ogTlzmb1soMv4nKyfoa52oE/fZik3Y0sFYDKs/UcEp1/C5CSx6ahC
	 pKZ1tpK2mDi22SBFfwTJ9WfFXO8tuou9azKKCKz6XB3U0bCfVcbbShBPR+kizU9InT
	 DCh8BvF28Z0sw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 03/11] crypto: ecc - Use crypto_stdrng_get_bytes()
Date: Wed, 25 Mar 2026 17:14:59 -0700
Message-ID: <20260326001507.66500-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the sequence of crypto_get_default_rng(),
crypto_rng_get_bytes(), and crypto_put_default_rng() with the equivalent
helper function crypto_stdrng_get_bytes().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/ecc.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 08150b14e17e..43b0def3a225 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1531,20 +1531,15 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
 	 * strength associated with N.
 	 *
 	 * The maximum security strength identified by NIST SP800-57pt1r4 for
 	 * ECC is 256 (N >= 512).
 	 *
-	 * This condition is met by the default RNG because it selects a favored
-	 * DRBG with a security strength of 256.
+	 * This condition is met by stdrng because it selects a favored DRBG
+	 * with a security strength of 256.
 	 */
-	if (crypto_get_default_rng())
-		return -EFAULT;
-
 	/* Step 3: obtain N returned_bits from the DRBG. */
-	err = crypto_rng_get_bytes(crypto_default_rng,
-				   (u8 *)private_key, nbytes);
-	crypto_put_default_rng();
+	err = crypto_stdrng_get_bytes(private_key, nbytes);
 	if (err)
 		return err;
 
 	/* Step 4: make sure the private key is in the valid range. */
 	if (__ecc_is_key_valid(curve, private_key, ndigits))
-- 
2.53.0

