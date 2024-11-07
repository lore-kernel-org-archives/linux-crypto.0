Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D254910F9
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 05:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730957870; cv=none; b=OLUbX039zPzRdg4C7kbUfQtJw+BOe/5UgXEV4geaGt2ZZsnyL6hDNbQ6LpEuuPbkUqolEXyd6Of1EOJ6JqyzRJtqk9jKKLM4Vy0P0CUvlpqD8vso2S/1w5bMLvKR/u6+gpZOioREbVku4BF6ZfWQffkpNZz82zW9ikBY87PhNNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730957870; c=relaxed/simple;
	bh=egorOKSZmi3n/x1hQvF5L++xH5H+goqGTM50RXqxQ9E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fHG+tlmeg7D+vwkEkLofwuPzCvprV3M9qsnpKoefA6a1g/xnST/h50iy45Wri8C1C5fRMyZjgtPTftlP08/iwk/5GXQSvq0zfprcDT//woTU2JgmmEwOGZwixBKiIPAV45XbDjzCNnO90kyGA1twYF6Dwtf2WKaDKGRXEcyCAaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Plcj4eZ4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Plcj4eZ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BvG5Qdix74+kB7Qaufh9HRUZb/s6BaI/IUb4gjtBA9k=; b=Plcj4eZ4zeAEEIOCGsPd3RGkJp
	GO2AO8kmCC5b8Yh6evbkg1mIfeoepWYCdJyhSKnnRR3UILBv37qX0nP1WvZvL3odIVzmd7LiJ3UGM
	TwGCZijYPT0YyXEjlpJcZxjDhBAWNPxtcv58bBjhBcL/lfDrSzdAcREV/zHO6hTeh/D1OR2kmwvzV
	/TvdaOtn83rQVsO2yVAQmr7RhxuSGMVt8mLj/LKWFk6LjoEnaJ3ELJDJ95BkwVKODkVLUtqDhbX+l
	0PzIVZ28Kr6omU/g8iclQ8Pn5XW+P8mUB09ON5wsD6NG5mrEIiZkCdOpFZY+H3R23g3hHR2/yEewm
	Hy7jeEbw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t8vD5-00F4uc-1q;
	Thu, 07 Nov 2024 13:37:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 07 Nov 2024 13:37:35 +0800
Date: Thu, 7 Nov 2024 13:37:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/mpi - Export mpi_set_bit
Message-ID: <ZyxSHy8XritbvoU_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This function is part of the exposed API and should be exported.
Otherwise a modular user would fail to build, e.g., crypto/rsa.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crypto/mpi/mpi-bit.c b/lib/crypto/mpi/mpi-bit.c
index 835a2f0622a0..934d81311360 100644
--- a/lib/crypto/mpi/mpi-bit.c
+++ b/lib/crypto/mpi/mpi-bit.c
@@ -95,6 +95,7 @@ int mpi_set_bit(MPI a, unsigned int n)
 	a->d[limbno] |= (A_LIMB_1<<bitno);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mpi_set_bit);
 
 /*
  * Shift A by N bits to the right.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
