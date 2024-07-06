Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BB579C4;
	Sat,  6 Jul 2024 00:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720227166; cv=none; b=bcAGzNVYrr4yRCYoXtr4cU+YeP4qCBosI7wSPPDys4mci4JxXxPTcH0mTs5OWK/y+GQJS/KVpCPRJaMSGDMuZsnnyPzQpj47dWqBMcnM9dxmvKXD1iyfb0tbqw9X5jKDIQnDmnaAwWeJ8XgpRfa6NYTR80/ch9+1/YhqogBQNdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720227166; c=relaxed/simple;
	bh=aSLAZMWNSKbItXTRvyDlKCOOWbhJTKXc49JLYbYf1E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9vRUc6Co4JLgZknwp+QVAy7Pc+jyn2soZlPd+Q+pJJJamjYptbCutFhxutGRQz/QDUvS4pWh/mR3ZZ8dgt5WlWVBlrT3MdZJ+MBA8CoJPkcXKKRE2O0OE4uaDUJ3Tpz4hP9bXkfgJrnBpQfVeVQNMNnzpI7wh4MFTqPQdSDksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPtfK-006h6O-1n;
	Sat, 06 Jul 2024 10:52:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:52:25 +1000
Date: Sat, 6 Jul 2024 10:52:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] crypto: starfive: Fixes for RSA
Message-ID: <ZoiVSZmcCSv7AKEF@gondor.apana.org.au>
References: <20240626014043.1194521-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626014043.1194521-1-jiajie.ho@starfivetech.com>

On Wed, Jun 26, 2024 at 09:40:41AM +0800, Jia Jie Ho wrote:
> This series adds handling for 32-bit unaligned input text and a fix
> for a missing pointer assignment in the driver.
> 
> v2->v3:
> - Retain u32 aligned attribute for preallocated buffer.
> - Replace sizeof(u32) with 4 to simplify calculation.
> - Removed unrelated changes from patch 1.
> - Move nent changes into patch 2.
> 
> v1->v2:
> - Build the extra space required for shifting into reqsize.
> 
> Jia Jie Ho (2):
>   crypto: starfive - Align rsa input data to 32-bit
>   crypto: starfive - Fix nent assignment in rsa dec
> 
>  drivers/crypto/starfive/jh7110-cryp.h |  4 ++--
>  drivers/crypto/starfive/jh7110-rsa.c  | 15 +++++++++------
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
