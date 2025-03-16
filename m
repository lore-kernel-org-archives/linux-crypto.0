Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311E519AD8B
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742118635; cv=none; b=gZdQh8CP5DIT9qFZuVXmQK4sZtrLsOincPBe8NCfnMvgLbTmg8GX4jTFUW5DmR2pGMHl3FZki89+QUqwfhJqaYZkyYUGckPdROCcBhY81krgt/2TV6mT1Mzab0Si6kiL4pNE9l7fakf8jVKAbhJ4W7lC0/he5uOW3ULvd8fvd4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742118635; c=relaxed/simple;
	bh=9fccqMSF/nwICLVKVsQI4AOo8ZxTPLgAq2+Ja4H9/JA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=HenqGPv9w7zZyu7yEq5VZ9zkRLr+RxjP30l/AcZwsaNDe7S7xqyDaUaSTtejcKyikuZFNBkHQs1hDU3dsqGmMKlDks2km4kPdIc1Yy+deHxBDxiB+jBsIZfXTtABdTYQkBPq8fTAfQTMIk3O4EmMgn4raw55fz8Vo7Sgb07FRcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gy/K64pa; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gy/K64pa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hsfYLoQzxjHxxPx4dgRWXQG8hKIEZBOvIYxZBwcHG/o=; b=gy/K64paE52/FwwrMsKrCEjoVt
	1EJufZr4gKqovDQ+JRPTbpFUFruguHD/CA4AysenYq0pRp1clRs2ZDyD9zwfa4VO4oWT5bIKpb7YS
	CcmL8vXytk9U+rHRA2aUjdUG/V2rIh96U+Pbw79DqxF3r91bC4lyrfepnZwhq1bxqRyhWB1BAnMyU
	u0GY0r2MLaHBKPvNO75j6BduEk1yp7iiOqSTPlJH+AITMKySlzfRyeBW3Grvi78AbFj800OLbpulR
	Ts5px81B1JjBFmmhN4LhLq5F4JvFTvoz6TY16niXMide4x6/cvAJlbFFnhgMwSi7klyFi503IEL9e
	xzDSQ5Jw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttkdS-0071Mo-0M;
	Sun, 16 Mar 2025 17:50:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 17:50:22 +0800
Date: Sun, 16 Mar 2025 17:50:22 +0800
Message-Id: <d36c40f58fbde5777d8a589383f95f33b5a56331.1742118507.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742118507.git.herbert@gondor.apana.org.au>
References: <cover.1742118507.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: scompress - Fix incorrect stream freeing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Fix stream freeing crash by passing the correct pointer.

Fixes: 3d72ad46a23a ("crypto: acomp - Move stream management into scomp layer")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 57bb7353d767..d4be977b9729 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -117,7 +117,7 @@ static void scomp_free_streams(struct scomp_alg *alg)
 		if (!ps->ctx)
 			break;
 
-		alg->free_ctx(ps);
+		alg->free_ctx(ps->ctx);
 	}
 
 	free_percpu(stream);
-- 
2.39.5

