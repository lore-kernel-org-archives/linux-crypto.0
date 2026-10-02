Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B5E42E405;
	Fri,  2 Oct 2026 07:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926084; cv=none; b=ST0tIEB8UM9QtJ1xn15ZpY7PvTS9Ln/cJPC8nbGQgoLmVJH/pUjBf0J0t1qo3Y3KIqVKElIOyPLzeKuY33kCIeg4eiBY5B4oSnDo7hU3xcDhHbxUwzNM/G+YqMUCMsAkaBEk8I++CwrGjGN/1a96lO+6Ms/mAt+D5gcVEqMZZTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926084; c=relaxed/simple;
	bh=zkLzi8D0/cBQCHeSreNWoUBWAWroFJBtPWofSCRMLHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbSo+gu0/1Ev/2MG/6mcEWYPzW+qjU41aeGCf1GsFZjC8EiFaRQm3O8G5tCtYiFMVrNg1egM3DpLZCe/FQykavLUqu+/aUtXoZRp2APUEvTbF41DLH76GM5kBEMyoG6IK76fDhOr4V0KKvdfoob66m0jH097mqM6m8dL6zDzFGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gIIkQKfn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gIIkQKfn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kdsw56wwAYZ7zZH2Gqn8T536hu02iHBa7BBTKyQ4N3k=; 
	b=gIIkQKfnPINtUVN2ifwtWLP+T6f//jFb8ZrEsT2hFqvwjmvziyLbxIyzP7z6skmoc2ohcWDiifg
	Rt5TYl7660lRnDQUaHEVpL86K0y6sh/Sx4p00BaUBafhftU6dGuGzOy4X/whDyswoOegmJ36r7mW0
	K+Y6vgL2tGnSbfi4xp/go/sjOPT1LgVPUBvFbxuZQgcDqUcnFhX9zNEnO1zWlMu9nAoch/Cx7fGGP
	lvURbcg4pQ8Fvct5mkI7k3P1ILgwne+F8cf0bj+0lgYmWSfPLZpD38CIuaMUzC6qguymchBHz407c
	N0Up69S32NciWo3n3FoLcU21CRO40z8C4vWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCXgP-00000002lSZ-1aGY;
	Fri, 02 Oct 2026 15:27:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 17:27:53 +1000
Date: Fri, 2 Oct 2026 17:27:53 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Christophe Leroy <chleroy@kernel.org>
Subject: Re: [PATCH v7 00/20] crypto: talitos - Driver cleanup
Message-ID: <ar9c-eJtdmlunbt4@gondor.apana.org.au>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>

On Wed, Sep 23, 2026 at 05:18:36PM +0200, Paul Louvel wrote:
>
> Sashiko reviews dismissed:
> 
> [1], 1: If this is an issue, it is an existing issue because
> the driver used devm_kzalloc() to allocate an instance of struct
> talitos_crypto_alg.
> Second, how should a driver knows that it should keep this memory
> because a tfm instance is still alive ? For me, the only fix would be to
> use kzalloc() and then never free it, which is not acceptable.
> 
> [2], [3]: A kernel configuration that selects both version is possible,
> but a SoC featuring both hardware version of the crypto engine is not
> possible and not described in any device tree. Freescale MPCxxxx SoC
> family is more than 15+ years old.

Could you please post responses to the new review comments as well?

https://sashiko.dev/#/patchset/20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097%40bootlin.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
