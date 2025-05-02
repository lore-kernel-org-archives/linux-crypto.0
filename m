Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F752AF0E
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746176645; cv=none; b=VzGRbdhyJF90jaMrGbCjGS9yLuspkUJLRr6tXRZ+wKA74X3uF6+JSjcyNqfq7y8MbKI0K3dWts9PhhtvvljH4uo6zUaLrj4L8RS9bIJTo8BfPswOkPI8SkOagbv/pzi+FGTNrqjMQHiWfhKY8RC3mHyuxs7tID+pAWmUBH6XO8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746176645; c=relaxed/simple;
	bh=ODO6ZM0/jidY6rye1tNgcaqtkmpS0cCKNDugLw6dSI0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=sCmB8LDZ0fce8HdHUrav3h+qDW0sJM/ORfFGqXFYdDS/FQnA8u2XwEfLJbNCUOYM2i/mGvkvQDK9kKFOh+h8TkxA0k932DC2Fe/ZuY15SNa6OkUmJQw05nEBoVVJeUwI1vmkYdTuDPKAHKnLYYS1EGOhb13NLDsKbBKlbH1X/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HgcDOUwH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HgcDOUwH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mw4AWBcJUevQs8Dg5ceK4NY4Phh54ID4GE52xb9j6tU=; b=HgcDOUwHbqtAx5G0U9UsFgGiLi
	psDdgQb34KWfsJpbQMVADRVv/bSVOFXIsBm9eUNDBpwoChfbts7QuRUIjZ0nqZs617uJ5By8B/Jx/
	wbHy9Ka5qRVUm0RP1qaLKvzUZ78kU4LTdXfpuQFhV0S6lapRIc6QW6YptRUeWhCK3/XWXBRkMAuLz
	laT+7SuTg+7qKYtE6t104denmLcFHVJgtJuSdSCvbZjKhK4DaZvp8RpiwaAPXx4JbqeAFYzNhxsN9
	IzyZ9hq2ijHH6DahPZQS+Q5lAMqqWDhYPK60OsNdW9alHNNyIPFQa+Fx5KKCqk/B4vAoi6AKnwlY/
	mc9ZaXHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAmJL-002ns7-0j;
	Fri, 02 May 2025 17:04:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 17:03:59 +0800
Date: Fri, 02 May 2025 17:03:59 +0800
Message-Id: <c468e80c2e06884e8b7e25b212f367a0a23edd5d.1746176535.git.herbert@gondor.apana.org.au>
In-Reply-To: <41f8d44fe2b46ac2e1f0c54e550aa8bffe9e1cf3.1746176535.git.herbert@gondor.apana.org.au>
References: <41f8d44fe2b46ac2e1f0c54e550aa8bffe9e1cf3.1746176535.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: shash - Mark shash algorithms as REQ_CHAIN
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Mark shash algorithms with the REQ_CHAIN bit as they can handle
virtual addresses as is.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/shash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 4f446463340e..025f9f3a9d49 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -450,6 +450,7 @@ static int shash_prepare_alg(struct shash_alg *alg)
 
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
+	base->cra_flags |= CRYPTO_ALG_REQ_CHAIN;
 
 	/*
 	 * Handle missing optional functions.  For each one we can either
-- 
2.39.5

