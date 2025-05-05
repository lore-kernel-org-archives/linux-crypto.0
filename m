Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2403C242901
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448373; cv=none; b=YYe2oqlZri9nGCwuXp/rpsVQDLk94bmoO4UXUO23tAXm32JnYD/INb6QUGbBorWhVqHcrhtUIW04bgfWoRboY2AEGCutQydskG0t3PvDQqVRNGPk5ndiQVluhDKXhz2mRKUf3xAo8aoGszTqtqzdkDxX7PiaLUcsfgjyU5HceUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448373; c=relaxed/simple;
	bh=8tn+oVtGmn0VWLt3VmUNk7Baow4vz4UU+tmkc2bvkQ8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=EfO10YWmtQQNlYnhTQ8vR7IagAGQ/1ROvNSwP90uFzu7WBWfStcCbT8VB6hrAgMUjJToZr00Zw/SKbXkvcGKBJBRH9S4K3gNYgwegmjho++sdMo+7wnSyzej0h6uqlkXc5UYMLD3mlRhfld2pkbx8OYo1+NZswxzlvkcALTqvDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lG8dKlwF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lG8dKlwF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5rBPQ13HhKdcSsMdDfJZhIBnwV3XO6mMqO2cdeNDC58=; b=lG8dKlwFOyI5zZdR6eTzTAq4pU
	/p7efTkQr/CCJv00EdNMDYx0V0o3HMhl7xqQN+er7MhuZCo+YtnD4Mb8AVjANEXdg1ku+m4HqHUUm
	IEpuzEitwWnstFl+HnsgFc0UXox0dSB5rr6S6zTequ/l9r++Fn9KcLDoZ1xyY++f+4e2OmXOy5Mri
	FZTmmGc03mw+KfyJAv2ElGdnuouPXzv3ggo5V2yrvZ9mfjLcHggH/hWetH1x5HQJMH0VNUhy+0cui
	BggLxlbCCXOziS0aH6Gdah4rpWYMDUgCIGJDa2c0ja/Khsfo06z3p55/mzBgj5pGOQo9yKfLngy2/
	Gh5V3Ytg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBv03-003YOE-0G;
	Mon, 05 May 2025 20:32:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:32:47 +0800
Date: Mon, 05 May 2025 20:32:47 +0800
Message-Id: <01361d2f6aebbcff343539a2e15102c2c2bcbdfe.1746448291.git.herbert@gondor.apana.org.au>
In-Reply-To: <1bdf0bc9343ad20885076a17c5c720acfd4a2547.1746448291.git.herbert@gondor.apana.org.au>
References: <1bdf0bc9343ad20885076a17c5c720acfd4a2547.1746448291.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] crypto: shash - Set reqsize in shash_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Make reqsize static for shash algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 1 -
 crypto/shash.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 2a29c4a73d36..ec246cc37619 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -286,7 +286,6 @@ static int crypto_init_ahash_using_shash(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
-	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
 	return 0;
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index dee391d47f51..dd3b7de89309 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -483,6 +483,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	if (alg->statesize > HASH_MAX_STATESIZE)
 		return -EINVAL;
 
+	base->cra_reqsize = sizeof(struct shash_desc) + alg->descsize;
+
 	return 0;
 }
 
-- 
2.39.5

