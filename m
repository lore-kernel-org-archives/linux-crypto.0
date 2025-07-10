Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0C3DDC1;
	Thu, 10 Jul 2025 08:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752135141; cv=none; b=VOxo5cmD0q36Q3DeHaJlq6ywwnDFNA+asgMy0M4F+2r1+XuFceq710UpspaxDAFCJmXqqj8cOy15LuiUfgTmlWojlFNIOmYY6AC2c66j8sUyTFubVTjt8uXaPBU800HzTUZKwjbHXKuBQDgaA69AqlvwRV5Rm3FiPCLwANw90kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752135141; c=relaxed/simple;
	bh=sRNOShUFvcLrTtZKQcfu6LF+KJU4nqvG2b0QeR5tOHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAxwK8OfySg/ZYxA57lBOiyn2Sl+8xup2jsSwZrn3AfN5F5dfCCcJ2azOCrhdTMW5SPeLF0Tyt89MPLngGKI/SF+aekPlpl1BBVBuw+C/4aTJCUd32BO3kyd6gudUuK/tlkfK/Kb12LevahzdQA1OGhIxRNKYmcECFwAZ2eXOUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pdjVUrex; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pdjVUrex"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z8WqumyvggfaVXZ7CRDetpHSxcPkOqvMvUK9gA3juJs=; b=pdjVUrexPJeUIdEs4fUAFkTdrx
	2QM6G36yJWK0PW3KySzVBbvmlK9jZix2jCKYeDzx+SIkCRcU5ewsp9WUwfIRIhZkM6zWjOXATLScs
	k6S5U9P0IsFsaVEYrExQ81aZGNY0wdSdG10eh3qkaaMfBMlo3vM8+/kw1PiqdfOnLOlBRmXtkHk3+
	+1BFBTda3NBOmf9AQ7IrTkCirXMI9NwIkODeiledryhhMYPpbevHIUczrlA3DFkB44PS50cDeWC+Y
	4Q0gVJexLLCWbecgmWLshRueHGLtCo6W0Dd0UpNmVifP7ORkx6B5YqvKGZkqlsn4sB7S3VOSn9lIr
	AxyGVhkQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uZm8X-005Orn-2K;
	Thu, 10 Jul 2025 16:12:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Jul 2025 20:12:06 +1200
Date: Thu, 10 Jul 2025 20:12:06 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] crypto: sun8i-ce - implement request batching
Message-ID: <aG911t_b18z7QHe-@gondor.apana.org.au>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>

On Thu, Jun 26, 2025 at 12:58:03PM +0300, Ovidiu Panait wrote:
> The Allwinner crypto engine can process multiple requests at a time,
> if they are chained together using the task descriptor's 'next' field.
> Having multiple requests processed in one go can reduce the number
> of interrupts generated and also improve throughput.

I think we should phase out the batching code in crypto_engine
as it doesn't really work that well.

Instead of doing batching based on backlog, we should be letting
the user push this.  For example, IPsec can hook into GSO and get
64K of data each time.  Similarly for block encryption, unit sizes
can be much greater than 4K.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
