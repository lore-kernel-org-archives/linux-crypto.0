Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFD7270575
	for <linux-crypto@vger.kernel.org>; Sat, 14 Mar 2026 04:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773463565; cv=none; b=VlVAJ4J8hy9+lLnmxuDdo+wW3ZLaPUZhij/X+jVkcoXsjKqj9jVBCAbjYWyQy3Nd34woaq9YbAN8WeGk/9UXWHqB8lsY4ZZhhRWnew6goXg2s54ZwpcLbrx/8Ya5Q0VdTPI3UVREzM6YjoRL7+ioeOCEUj2zXFxQVXq7nXcmk3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773463565; c=relaxed/simple;
	bh=wFoSukxm3sC+6cSY46NAnx6fpxTJYNdSFQtxuG2cz5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNw87SrjG8sciU3Th8el3kAnwdYmHsNlae6YKmcUE7GVAtKe/x51E1IsLaut5ftpeD++9/nI67o3RIrMwjyVvYho3BAarPcV+EeuKAbbnmEAxgroF6qGoqoSzBqOj5dPnRV4O3ItMmxSmoYO0cUj3/KcK1/lwZ/0jsVVKQBkqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FZwdNFbF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FZwdNFbF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AGj64KnDA3JOY5RuHkHLi5Xq2wsK2S1ByviEOVeP4Bo=; 
	b=FZwdNFbF4IgW581bprzR5/lDZ2umcVSd3sd1ceOb37mqU2yenEk2gMeMxdvsuEtbAOxpYFJ9zj0
	w2t4ikF18UDrzU50CeRfHuJP/bTLBEPn3LV6kwknwKTSgYHjAZK28EN8d1MzoDLq+NNAu7928o1WO
	LiQB33ImkLZbO7peE4cwT+F1N1zPzvE4jRLI649eh3xydcqqJGrYTLpU3DvcJrDwQ8ANqlIpcMP2e
	2vv8Xedvd4BQqdiyYXTG+BaME15/kdUyB6K3hl5306DPd+mpAbIqDwWaB7A0z+t5Q2WmT4ofUpljg
	98WmAU6fvL2/2mVB0xNBCml/HfXFO+JLbxdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1Gsy-00EKrX-0j;
	Sat, 14 Mar 2026 12:46:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 13:46:00 +0900
Date: Sat, 14 Mar 2026 13:46:00 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	michal.simek@amd.com
Subject: Re: [PATCH 2/6] crypto: zynqmp-sha: Change algo type from shash to
 ahash
Message-ID: <abToCIT1L1V17ns7@gondor.apana.org.au>
References: <20260303071953.149252-1-h.jain@amd.com>
 <20260303071953.149252-3-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303071953.149252-3-h.jain@amd.com>

On Tue, Mar 03, 2026 at 12:49:49PM +0530, Harsh Jain wrote:
>
> +struct zynqmp_sha_desc_ctx {
> +	struct ahash_request fallback_req;

Please use HASH_FBREQ_ON_STACK instead of rolling your own fallback.

See drivers/crypto/aspeed for an example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
