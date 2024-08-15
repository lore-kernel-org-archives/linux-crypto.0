Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB1E1993B0
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723711159; cv=none; b=rJv2VYoKmE4vQVeGBSLjmBcuh3oRbeGpfvCv+82Q+ba6TDEIBGDTVmqV1CAUZE7nukMgWkEcATAl06qj07SJ+xWrS2M4cg6F7lbXKeciaOvhCzRchjE53hij2561sPPGUCbgLtJ5dGi8NnFJHejS5f2iNHnMC/NYhOzelL34+kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723711159; c=relaxed/simple;
	bh=dDzShQ5G4ricT9LQpES0EMClT1ZeAKcb+4YXNQRQf/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSMoMUzukbPcRUd5Ry4JTvRYKfJrxvoGVjKvntA6cfKjnqNNP6aDIUdderf0ZTh0yxEJ9xLvjrf+J3SbR0HbT/PudDxHtQnGvl1FrOXD6Nntj/W8k5SdNq2cjmFg0RP9+efThKonyGY6GKMwdmMDY2NnqlL68yvioI42bmUl+Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1seVsG-004oKu-05;
	Thu, 15 Aug 2024 16:39:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Aug 2024 16:39:09 +0800
Date: Thu, 15 Aug 2024 16:39:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	shwetar <shwetar@vayavyalabs.com>
Subject: Re: [PATCH v7 4/6] Add SPAcc aead support
Message-ID: <Zr2-re9H7-5OlUHb@gondor.apana.org.au>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <20240729041350.380633-5-pavitrakumarm@vayavyalabs.com>
 <6557f8f8-42d9-4824-af0d-1d327c5972be@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6557f8f8-42d9-4824-af0d-1d327c5972be@stanley.mountain>

On Thu, Aug 15, 2024 at 09:06:30AM +0300, Dan Carpenter wrote:
>
> However we're subtracting RTA_ALIGN() not rta->rta_len so there is a chance that
> this subtraction can make keylen negative (but it's unsigned so a large positive
> value).  Both keylen and rta->rta_len would need have to not be multples of 4.
> For example, if they were both set to 9.
> 
> (I'm not a domain expert so maybe here is checking for % 4 at a different level).
> 
> A high positive value of keylen would lead to memory corruption later in the
> function.

Good catch.  Those RTA_ALIGNs should be removed per the generic
authenc code.

The same bug exists in drivers/crypto/marvell/octeontx*, could
you please send patches for all of these?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
