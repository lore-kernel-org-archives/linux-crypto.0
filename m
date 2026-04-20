Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311E238236E;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667021; cv=none; b=fCgSe37AaFgVZzfhaT9vg4ud+CSrFXSLwF04Kv8PDlzEIE5AdkJRebEbV3L43yiKKMGH6B/5HKjNiqSvsd/UbBpWQpPbZSmJdDy9xLuyPo7XULYkR+w+Wi1zULxlNsPu3EI4xwzu7+Utc5Q8RepZwpX0iPQuUQtYkwnv6RdvIQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667021; c=relaxed/simple;
	bh=8M+wIAMl08TAO8KoZrYMwmaOEg0axbynMBgbBycn82A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaOYjoMn6GvjOLb3+LMHiVfzU1j1tCCHO4ukJYwu0yhoxdi9FIvqVdw8Paxlk2B6uf2G1/Gy5HZaSFtSfP/FhDxavUs8uRSbjlYPb3PFf9l/2ZIwYPZA/Ryd2LOB1x94yNKjbXQfgP+ythM8AbgNKKZSkdE9Nr4RqLGhESKWDS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+R6y7W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+R6y7W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD412C19425;
	Mon, 20 Apr 2026 06:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667021;
	bh=8M+wIAMl08TAO8KoZrYMwmaOEg0axbynMBgbBycn82A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+R6y7W347pL6zDvh5UeZsADDbgG8d12od0Kvt6XuNUKPZMugxq1U0W9+D0o6ePRa
	 mrzbq0ZEihp576M8bU6pcjvDJ2mSO4ZCcCBT+b9tw4r/UibuUfQ+OSP0ELv0uQ3YjJ
	 FkxAoHn04dgxU9h3TRHlVqh3H0vBDT8UWqM8CpZvtay5uNrYuIoB1xtQ1XJjExCmDi
	 hKrzTgz+qQZ6mYVHVMoAso7LYUbkwEgCo8+X9OEwL3zOpzaeQC2LTp3gjGkcL/ivLZ
	 AX5X6q3lZjJ3LRSSisSHuxmQHFMYlpNt0E2nEu2+epG2zB/wPgcn0yoToZ3sflefxn
	 Lt22Ba7bUqCLA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 05/38] crypto: drbg - Fix the fips_enabled priority boost
Date: Sun, 19 Apr 2026 23:33:49 -0700
Message-ID: <20260420063422.324906-6-ebiggers@kernel.org>
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

When fips_enabled=1, it seems to have been intended for one of the
algorithms defined in crypto/drbg.c to be the highest priority "stdrng"
algorithm, so that it is what is used by "stdrng" users.

However, the code only boosts the priority to 400, which is less than
the priority 500 used in drivers/crypto/caam/caamprng.c.  Thus, the CAAM
RNG could be used instead.

Fix this by boosting the priority by 2000 instead of 200.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index f23b431bd490..e3065fb9541b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1830,11 +1830,11 @@ static inline void __init drbg_fill_array(struct rng_alg *alg,
 	 * If FIPS mode enabled, the selected DRBG shall have the
 	 * highest cra_priority over other stdrng instances to ensure
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;
 	alg->base.cra_init	= drbg_kcapi_init;
 	alg->base.cra_exit	= drbg_kcapi_cleanup;
-- 
2.53.0

