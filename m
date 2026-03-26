Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4020F21D3E4;
	Thu, 26 Mar 2026 00:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484205; cv=none; b=IIuGrv8asW/geH3iPGU/f2JxoLzXkWv1RUmHwLDEY9p8fGNDI2MQv0mrPH31jnK9woS7vBxzLv/gTj2b+thncHVSg358rWTJY/8EBDhCzjEoLmYKDIYsiq4iz+Y3QKrL4PrVzZ3Fs3VdvoYzYGa/FrKNJP+OLYGv/emo6wge2MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484205; c=relaxed/simple;
	bh=8RXRQarUEH5v46Pvke7LgdMNRlK7yH/04VpO240qSdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLu1AkBDoRLGKofH9OZvb8djA6HqiHqsQMSxX+SIJa+/cY6ueY18T+vpFMiua1jI3Ynzbyeu76hGmJzIOElnhsYDjkimnXe7KEeUU+BRX14ohOZOwznE6KwHpmCDIydRAytU1Za5L6oXGviluGMM22NyJB60YqXFweXtviu1RHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqhazUoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqhazUoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26978C4CEF7;
	Thu, 26 Mar 2026 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484205;
	bh=8RXRQarUEH5v46Pvke7LgdMNRlK7yH/04VpO240qSdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqhazUoTcDANuwlR0ubP5mgbR77uZCK281aBYKQrHpu1PTu8FdHXW7/83zylTM5dg
	 qv5jfNNJVUGgJgxC24bqFSMV5ejFeWUjltDawJcrgYYaQrMa27zG1WbE4ywFkkVkcF
	 ACWqgxZlKCa76XQhbxz6mMuve9yDq3am4+oNxIl0jeyvSUV13zyf6D45wyMVVeUYjL
	 wf6+zaI01Ab8Duizg0OIPDd+IEB9ORIyLNLplCB3owwyRnSLMG/NYGLaDKYKoBBMOf
	 27q2kmqF4+peqIxAt2b37m4oV5G7ALOOXWdztsb9q6k0BSSIpwZ1RYUD7+fJkDcpeV
	 BMM7EHM3O/cdA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 02/11] crypto: dh - Use crypto_stdrng_get_bytes()
Date: Wed, 25 Mar 2026 17:14:58 -0700
Message-ID: <20260326001507.66500-3-ebiggers@kernel.org>
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
 crypto/dh.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 8250eeeebd0f..7ad4768716c8 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -386,17 +386,11 @@ static void *dh_safe_prime_gen_privkey(const struct dh_safe_prime *safe_prime,
 
 	/*
 	 * 5.6.1.1.3, step 3 (and implicitly step 4): obtain N + 64
 	 * random bits and interpret them as a big endian integer.
 	 */
-	err = -EFAULT;
-	if (crypto_get_default_rng())
-		goto out_err;
-
-	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)key,
-				   oversampling_size);
-	crypto_put_default_rng();
+	err = crypto_stdrng_get_bytes(key, oversampling_size);
 	if (err)
 		goto out_err;
 
 	/*
 	 * 5.6.1.1.3, step 5 is implicit: 2^N < q and thus,
-- 
2.53.0

