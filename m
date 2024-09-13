Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABFA1B9849;
	Fri, 13 Sep 2024 10:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726223753; cv=none; b=EKxz45bnrc4MhreIN1aJH55xcTCWQ3iAi8E+DKq3dzF9mlIFABo2F6wrTkvXwkmMd1z1yXjEfIRcwZrgUXcoCP/7gulPrVyYzHFW+ZUsysQbvPD0nmWtYCRiNpu3woKlIt/QTSWbSQ8s764KQ34uWcoTLywuM9hD8KpFmnRYhN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726223753; c=relaxed/simple;
	bh=QMrpPami73TETdHGs58sVyb81klDU7+CdK20WR30NXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7dJURgvk0yrZVvdJj7lsbNUMslVeEzoBMtdaCkFA8qgrWfMnrqcgdekjwBRf9TK1FhenFvbHWRzSYVL6012KKe+ysH8V+CLKKppQX6xR0ZoESvPTKRO1Ew9F7QFoRK/uLdppt2P/jpMhrgc8J8gMxHst4WNQFGZRlLxCvLHN2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b0oRHCYm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b0oRHCYm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0CNSbKCh69zCkNZH9jjKsEGylWzRRbRWSCCkDQw1EN4=; b=b0oRHCYmhr2BHyiELxmtqT8RHH
	L0n+o1OocTiaM9+NYNmaOM/L1OjhoCUkRZAwChGWKWOe5cmg//ZSKgQ9WjOKSq2hobW8loM1lIgGd
	PpraMNvXMnyAvkNRkSHW82BaW42d0xkrKZNkkoDyNx42GCxEYJJDPIuYoVWqi+gSQ3xchSyRgruFY
	ZoowMCGpsRXlWHYODOHhL2INhN/hij7SsZgqmhUpEm+ZGYBCPYaGYQIQmsuJ2oF/XsjaFr5alfRKn
	1ygt5YEj8V+aWEvNbAMEofsQairfmQVJALguTZLIGjIIRkUaBVPTJo3KPZfLWGngaC7saj/7RKYQ0
	R7A1fCJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sp3UD-002E1K-2g;
	Fri, 13 Sep 2024 18:35:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Sep 2024 18:35:23 +0800
Date: Fri, 13 Sep 2024 18:35:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Eric Biggers <ebiggers@kernel.org>, kristo@kernel.org, will@kernel.org,
	akpm@linux-foundation.org, davem@davemloft.net,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	robh@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org, vigneshr@ti.com, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Add support for MCRC64 engine to calculate 64-bit
 CRC in Full-CPU mode
Message-ID: <ZuQVa8ARmd4fjAup@gondor.apana.org.au>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
 <87tti098af.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zme3EcW4Uz8kTbTt@gondor.apana.org.au>
 <20240611031314.GA2557@sol.localdomain>
 <ZmfBxLB8RC_KNUlx@gondor.apana.org.au>
 <87cylhm3tn.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cylhm3tn.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>

On Fri, Sep 06, 2024 at 04:44:44PM +0530, Kamlesh Gurudasani wrote:
>
> Just wanted to confirm, if this is being rejected primarily because
> 1. there is no in-kernel user for crc64-iso3309
> 2. or poor performance benefit of using it from userspace

Essentially we don't want to add every random algorithm to the crypto
API because we may end up having to maintain them long after the users
have disappeared.

For a special-purpose algorithm like this, it's perfectly fine to have
a custom driver to be made so that your user-space app can access the
hardware.

> The context for asking is that we have another superset IP known as MCRC
> (this one is MCRC64), which supports crc8/16/32/64(iso-3309).
> 
> That IP has working DMA and will give good offloading numbers.
> 
> We are planning to send drivers for crc8/16/32 for MCRC
> 1.should I put efforts for crc64-iso3309 as well or
> 2.drop the crc64-iso3309 and send only for remaining
> crc8/16/32(standard algorithms with already in-kernel user).
> 
> All our devices either have MCRC or MCRC64.

Do any existing kernel users benefit sufficiently from these algorithms
being offloaded? If no then there is no need to bother.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
