Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67931A8F84;
	Thu, 26 Mar 2026 00:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484207; cv=none; b=SH1qAqV+sDOF5z+sMz/Th2ionHc/wGBz6RaHEps5YjlhY25WHWpQUzlDWgR/pwhv9sleMQFnhWwAZZgfjEgCuyYC86t6B/OIXUQ4FwWAp7owGHY130ND+Gh1WC7XoHtQRPSzF8RdrjUUZAu1YZxdXrk9/BSWtWU2AAy8dtjyBgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484207; c=relaxed/simple;
	bh=4Swp1cs6iV8ZLXuEHat42F4Z33RaoHb0nQf1lLGDVl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIOb5e64Cd+epIcR0x4Dhwdr1BZnrGuSU8+ynMN1kPQ9E3r8dEDUNC0LAmy2oCFAhRWiRwDab2tqH4Em16MjoU10aV4q0LJCKCBIvDgR85kNbyJQ57esNo884ekYZ5CvjdxapMiatdidasDhFGO8REcmSXt+LnvN59QLvKYZCjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROKdZrpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROKdZrpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC2C2BC9E;
	Thu, 26 Mar 2026 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484207;
	bh=4Swp1cs6iV8ZLXuEHat42F4Z33RaoHb0nQf1lLGDVl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROKdZrpqOr/+OP+8wd/4OhKoIB6iExiFz6LfSPxwbp4LF3a49az7nQnBnLYwTk1te
	 a8dcdOeqg6kZ8EiY8Aa5SGXTJ6e8ECiOoOkMar/pcSoKBT9sdMcnHXLvrtn1woNrLh
	 wY0bpL10t86ypmLX3xCiePfDyJ/cb77VQhO4IQWZfKNCc2IJAtAXI5Ec8+TK2rLS06
	 bRVtrOUANEvioF8X75hOJ3tJsR9c71ELEzud5XCe+QyUDV5OIyg1JySm/6Gc0RA9EL
	 v7ng9wX6ZckiAk3mu/bsBvcfgG5kdGS8ZjYbGh/JPEGj8HftFyR1JkWWUT2lOxdG42
	 7GjIFfjdKfAuQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/11] crypto: geniv - Use crypto_stdrng_get_bytes()
Date: Wed, 25 Mar 2026 17:15:00 -0700
Message-ID: <20260326001507.66500-5-ebiggers@kernel.org>
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
 crypto/geniv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/crypto/geniv.c b/crypto/geniv.c
index 42eff6a7387c..c619a5ad2fc1 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -112,17 +112,11 @@ int aead_init_geniv(struct crypto_aead *aead)
 	struct crypto_aead *child;
 	int err;
 
 	spin_lock_init(&ctx->lock);
 
-	err = crypto_get_default_rng();
-	if (err)
-		goto out;
-
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(aead));
-	crypto_put_default_rng();
+	err = crypto_stdrng_get_bytes(ctx->salt, crypto_aead_ivsize(aead));
 	if (err)
 		goto out;
 
 	child = crypto_spawn_aead(aead_instance_ctx(inst));
 	err = PTR_ERR(child);
-- 
2.53.0

