Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00741E5B69
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993201; cv=none; b=Ena0KNpKw5fvgPCNx5VTShdp3xqkFxjpolicCko8s7HkR4sMK36HjCNgKO/4yWd1yX4/G5qEbFQRAtptJfgeiXNLEoZe1DgOt7Ha/4365oHeYE8avQhgazOPVbE11XCMZpD0YeYw59hGsq2Je0dCJLG8dV3bXiEzDFrY5bz6sMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993201; c=relaxed/simple;
	bh=6TZ9ixY2x8wCmR+PhOXfZ4nyXv9A9I5kC1an1kFzmic=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=l6oEuFoc9REaj9olcZSGxTO2h4x2L53a96PCTmmfQCP/dnAaRBP2ODLzZLJeMoZU+4yeki+U9RXPfwT0VHBlPfna989OUrNZCPDk4hcOr54ljjXgTC4zt/XW45sMGj2BZ8qrqrluKDO3trIM15wbVBfhp3viKuku6qHo0yQuIec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z4kJ52+i; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z4kJ52+i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0zM7czs2QCegCOiBnC04nazJUAftVvclzN7Gk2JG7ew=; b=Z4kJ52+igFCwP4X60K+Ff2jot8
	czVX0SFFdo+pNPsiqdSZbzi/ySSYk/JCGAUaFG03sSqhlQtgbwOzkqwQhDV9QVUUDgwBsqa0SvCcp
	pRpGllrXjIDq/O8CfqQzWHDIZQlWlMYHBlXlgem9bo70FxVNKK0Q+xjCTA5xgMNxXqj65Pe7dT5gm
	4QyXas4RxCByqBYEf3BWQItCWROUfPXsfIHaKk9RXYdFiqrU2on6Hfj0f4KkAhlX3xWx2HCbDK+Y9
	85pQVIKFo4iJkAxdHfGDTQpTbMDZGC/tNGzLFY0kH2Nf8CatMSN37U8Pj1IcSA3kchtFmgkkUE/c3
	YWQ7O4wQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aa-002AbU-02;
	Wed, 30 Apr 2025 14:06:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:36 +0800
Date: Wed, 30 Apr 2025 14:06:36 +0800
Message-Id: <8833072cf031dfbaf05b9af639e08eb73b2a5cb8.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/12] crypto: sparc/sha256 - Export block functions as GPL
 only
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the block functions as GPL only, there is no reason
to let arbitrary modules use these internal functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/sparc/lib/crypto/sha256.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/lib/crypto/sha256.c b/arch/sparc/lib/crypto/sha256.c
index 6f118a23d210..b4fc475dcc40 100644
--- a/arch/sparc/lib/crypto/sha256.c
+++ b/arch/sparc/lib/crypto/sha256.c
@@ -30,13 +30,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 	else
 		sha256_blocks_generic(state, data, nblocks);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_sha256_opcodes);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_sparc64_mod_init(void)
 {
-- 
2.39.5

