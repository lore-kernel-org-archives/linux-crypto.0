Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FD42C11FA;
	Thu,  6 Nov 2025 07:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762413108; cv=none; b=SfsbhXcI5S/vSmwi0dWzZBSQhou+D9ZtDkoHxxecf2CwyuPrTcRGz3r4H/7+pcxieKf02W7+1ENHvpy2zlWgEE1J7B1ceuOD6/MJCAyVWT/Orlsz1QmqMGpsH9ULYnU12hVskUeQPGRKoNeL79Fo25TDF8xAZhag9ACfGek4Uhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762413108; c=relaxed/simple;
	bh=mbu55kh2GmscU6nr9NP6lLEKAXaM9AwhrLZTInBd0pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4Oyu6B0p1PSzTufp2S7WeT7+/DSy2QXPZf9KcIGRTwMe6dZ6YNrRQ9cu3M6DRvEE20VOUmJUyTuxLnE8HiynhanBD/jYy7ZwT562XlProgliNadRcnDP3sR7Y63NEddBOu8u6qpbdZ2Q91GCh2Cu8eb3FQPxMdIpNwjWWUEdLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sYqDDYO6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sYqDDYO6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9Ym51P7wIBI8NceAbs2Y6O/r8XdS9ULqAFrC6Z2ACIE=; 
	b=sYqDDYO6RN6tsSs7WO9n+9tkfLCoc/rERCwD7wp+5WjlKDRdV+OpJywLLXodO1yEVdatvYkxvNH
	fCd4q3nGYs71bfUJhz3N6pKeAYNgsHwKCdZ/sVGtDem9E4yyJHbrZAW/Y5W58Q+BGDpJGPymnVICQ
	Vkw9vWXd9ndlyON4V/aoQ0VDJHfOXEr75NWUmUlHYpGY5ZWqjm4x5PNRyp8PH2Yc0INhZ2TbvrG2Q
	Sd4Ku+TKfPnJB3AuDd6LI+g3DEoz1lGuDfVeM6UUMsLLiFByyg7O+vDeYn13jvHYik38GoV5yM7aW
	8ewsSWABp7DvmznbwqViPlyxjQg93oEIGXVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGu9j-000rfi-0Q;
	Thu, 06 Nov 2025 15:11:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:11:39 +0800
Date: Thu, 6 Nov 2025 15:11:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 02/21] crypto/arm64: sm4-ce-ccm - Avoid pointless
 yield of the NEON unit
Message-ID: <aQxKK_5QWa4AM1IH@gondor.apana.org.au>
References: <20251031103858.529530-23-ardb+git@google.com>
 <20251031103858.529530-25-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031103858.529530-25-ardb+git@google.com>

On Fri, Oct 31, 2025 at 11:39:01AM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it when calling APIs that may sleep.
> 
> Also, move the calls to kernel_neon_end() to the same scope as
> kernel_neon_begin(). This is needed for a subsequent change where a
> stack buffer is allocated transparently and passed to
> kernel_neon_begin().
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/sm4-ce-ccm-glue.c | 25 +++++---------------
>  1 file changed, 6 insertions(+), 19 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
