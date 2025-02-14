Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815EAC2EF
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 02:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739500293; cv=none; b=NUV8oRbJ4nZxQumZ1xUo7XbF2padpHUjAcS6ERJeoOcZmCZigTodirZx0r7DpPXQfQupVkenYrHtTVvkkEL0I6/H1B+vHEDnk9tV7JAEUCr+PVLlhxzQ/D8GoUiNe3S2FfCLB5KsLZW8B+EgiuxYk9e/b8vaDZrAm8Sq2S5Y1c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739500293; c=relaxed/simple;
	bh=56HWxJPERZ3ox3Y0LY0/D33rnsM685wVdNu2b490XGY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=W8Pg6mj2L0ohIg3W4DXj5UhnShC9enylcPPadXNiTNjYHMkAnvsXm/4QchNQBw7jCntQlf+iAbYaKHHMU5/s/pOVGDC34uyB9Sfnq28nMvvrQerkn6u4sFx8p/ZBhZxe/NtZ8gJeEg6a80b4+yMJvjYAb92QgpCbApUTYTAdutI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AsbWyDMC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AsbWyDMC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LLfD9cN7JPUYOx80Sg4LF+BO7SKXI2PnVV9UHzOwlrE=; b=AsbWyDMCYJDoZeRhNdny2kGHUa
	kJWOpIR886borimupbc9CKhnlkuuzHrqgwdfbUdGPtsqwBs4o7AoAdtOP4a/Xz/QfTg1yec/R0l7A
	8yu+nOoK9SGPt+8hoRyc2RPF0rutuNYYwIdNMC0N9Ozo4FZlmw+k6ywZAMDPYIrZG204/PoTC3oG1
	hpyC1/ingNdT7PeIQepxZedPJTIr4Jj97a+tCqkmfl6JUmERM47xA7jy1xPUBUge8w7guVZu9i5gF
	+0zLyt1BmG7hUl4qsAI2x6QmrOG7M3BtwDw+qogNYEqctgfNEls6E1+JPIotgEbxs/NdR6wzdK7J1
	dAWIU5rA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tilHI-000D8n-0s;
	Fri, 14 Feb 2025 10:31:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Feb 2025 10:31:25 +0800
Date: Fri, 14 Feb 2025 10:31:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Coiby Xu <coxu@redhat.com>
Subject: [PATCH] crypto: api - Fix larval relookup type and mask
Message-ID: <Z66q_X7EgJTZuq8D@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When the lookup is retried after instance construction, it uses
the type and mask from the larval, which may not match the values
used by the caller.  For example, if the caller is requesting for
a !NEEDS_FALLBACK algorithm, it may end up getting an algorithm
that needs fallbacks.

Fix this by making the caller supply the type/mask and using that
for the lookup.

Reported-by: Coiby Xu <coxu@redhat.com>
Fixes: 96ad59552059 ("crypto: api - Remove instance larval fulfilment")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/api.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index bfd177a4313a..c2c4eb14ef95 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -36,7 +36,8 @@ EXPORT_SYMBOL_GPL(crypto_chain);
 DEFINE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
 #endif
 
-static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
+					     u32 type, u32 mask);
 static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 					    u32 mask);
 
@@ -145,7 +146,7 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 	if (alg != &larval->alg) {
 		kfree(larval);
 		if (crypto_is_larval(alg))
-			alg = crypto_larval_wait(alg);
+			alg = crypto_larval_wait(alg, type, mask);
 	}
 
 	return alg;
@@ -197,7 +198,8 @@ static void crypto_start_test(struct crypto_larval *larval)
 	crypto_schedule_test(larval);
 }
 
-static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
+					     u32 type, u32 mask)
 {
 	struct crypto_larval *larval;
 	long time_left;
@@ -219,12 +221,7 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 			crypto_larval_kill(larval);
 		alg = ERR_PTR(-ETIMEDOUT);
 	} else if (!alg) {
-		u32 type;
-		u32 mask;
-
 		alg = &larval->alg;
-		type = alg->cra_flags & ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
-		mask = larval->mask;
 		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
 		      ERR_PTR(-EAGAIN);
 	} else if (IS_ERR(alg))
@@ -304,7 +301,7 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 	}
 
 	if (!IS_ERR_OR_NULL(alg) && crypto_is_larval(alg))
-		alg = crypto_larval_wait(alg);
+		alg = crypto_larval_wait(alg, type, mask);
 	else if (alg)
 		;
 	else if (!(mask & CRYPTO_ALG_TESTED))
@@ -352,7 +349,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 	ok = crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST, larval);
 
 	if (ok == NOTIFY_STOP)
-		alg = crypto_larval_wait(larval);
+		alg = crypto_larval_wait(larval, type, mask);
 	else {
 		crypto_mod_put(larval);
 		alg = ERR_PTR(-ENOENT);
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
