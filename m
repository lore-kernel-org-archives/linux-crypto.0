Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356395223
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 03:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741922850; cv=none; b=TWiUCm7sVP9UtcImD3b+KzaWrRQsAfhrNTGE/tsr42vpxyae49nIbblZC/SqelnNUc0/JrQHQ35s4tIAUefIkUbMKQfSr8/V9bSCACrt7S46oqCQzubgtHkh/3IG4/QMUdtmnL+DEXeBQCTYpNKqzWeZ4iWcD5QfQzEdtfxMNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741922850; c=relaxed/simple;
	bh=WqoagNHsJph3+c2XHpMrXgQIup2RqduyAgsDWlAzYf4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=vBb9nrCOViTLUBxybje2OlDARy1CZbdkYqP6SjWj2rLPTND1aGni2XTTvfis17JjXxl/I55UNw6OUCEzZLVyPHMGcwfStHmpBrHDWuwRgFwPN9h00OVn5LawhXLwNm0hgMsnAL4gfNtjfaz9GPu44dCNa7GOtOv1/NDcOZF2Fic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NZHq/MS1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NZHq/MS1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4F4+6VdkBSnv6ZIyg6CAj7W2D3mMvZqb8XUKm3ChwG0=; b=NZHq/MS1XxiicTRZYBYO2u+00F
	xJCSO4KyxlT5X2CmIFYjfokCv8DQti2NGtnFl4PVmr3QgSqxcn1aNQlFYt0KctyHGyW5SdWH/8gG+
	KczKksKRTKQ5VzPEb5fDZ3Eaoy2b29fYPo5JkKA8rjhAcM+hN3ep3BCTtZxTIpzMuYmsxzMkweJAg
	g+Mhky+K2LwoFQv8vHv1nTC4ovJI7GhAtUzc7BWa0JjS0lW/BaTG5w2ktqija8jnzQyI6DOKyr1//
	0GUKB5CqB4/hwak99n/aFhmpim3kluH4Xq9s1qJ5/PrViRrt/+v7BaPTnHnH1zH/0G/tSJ8GLyNHa
	4aPSrbZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsvhj-006S96-0h;
	Fri, 14 Mar 2025 11:27:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Mar 2025 11:27:23 +0800
Date: Fri, 14 Mar 2025 11:27:23 +0800
Message-Id: <65808c8cdfdd2c4bf8889dc33b145ccbf54602e7.1741922689.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741922689.git.herbert@gondor.apana.org.au>
References: <cover.1741922689.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 2/2] crypto: hash - Use nth_page instead of doing it by
 hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use nth_page instead of adding n to the page pointer.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 1fe594880295..06559e5a715b 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -80,7 +80,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
-	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
+	walk->pg = nth_page(sg_page(walk->sg), (walk->offset >> PAGE_SHIFT));
 	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
@@ -221,7 +221,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (!IS_ENABLED(CONFIG_HIGHMEM))
 		return crypto_shash_digest(desc, data, nbytes, req->result);
 
-	page += offset >> PAGE_SHIFT;
+	page = nth_page(page, offset >> PAGE_SHIFT);
 	offset = offset_in_page(offset);
 
 	if (nbytes > (unsigned int)PAGE_SIZE - offset)
-- 
2.39.5

