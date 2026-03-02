Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ADE32A3FD;
	Mon,  2 Mar 2026 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454312; cv=none; b=Vfeq7yA2Qg29F5SNL/amvWDVnTDzXiB6qMKT9o3rTfNi62tBHUrCG24HMh7fN6Y5kE+zlG5g76V0UATgeWF48AI9Kmin+TKlJjUb6ktvCJRCX/Av11R9B+A3O3GWDUMK+Nri49VODobaVn0KSeBnK9IhxE80p5ZMgVhDjFQxh2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454312; c=relaxed/simple;
	bh=YdiS28IRdEMZtT3oGRf8x9y4j+O25ZgArtbVJIo14hA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2Bz5uqQdZhkR/tbeuUjGZ2ZqEhHPr0rV600yYn4bZ7h829p738rQ4r/whO/R6bhUEEFSEYqafIrDFmYIvC0GmA0rBn/3bpXwFN/uQf36tFkh+wAN8qBuMxWmsSaK9Y+qKq/2cRrISHgFHQhxLBQiFQf3R5uxh0cLRwkTVhjA8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kGWQ4xGb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kGWQ4xGb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=svS5G4tud4NFJgwF8QjTNMoi9+m0eQcVhlhPlVj4Bc8=; 
	b=kGWQ4xGbZQfp3H3Wl7naamqAUKEHP/oGfkW34Rnj5Dfwyk2mseVWx4wENPXJQBTtaCTR+29emnc
	H2irG5eXDNOPSnBr+Jx1IZ2P0t7aHEbqVp33EN2oF89TktUJVj2cb+w7Xm1vSk6FLtZO9OrhtNRSa
	8rsjrVtehUEpRAuPU+BPyfvtBNfs5Ly/1i3y8S9fSRtqIQzXbYMxgxmnQSurWRv+q50xtG2U1y8D9
	JCvQPrye/hkEWM08xB9LGSfE1TwSJvbJ6ffxPi2AM6Wxbr2VAyP/vUpCZTra4hkqpH1iTOqS4V6mf
	XwsQJzpM7T4ujpkhU5weY8TZVSBoDDLBjvsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vx2KW-00AlCx-0J;
	Mon, 02 Mar 2026 20:24:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 02 Mar 2026 21:24:56 +0900
Date: Mon, 2 Mar 2026 21:24:56 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: drbg - convert to guard(mutex)
Message-ID: <aaWBmE5H6HrDq7u3@gondor.apana.org.au>
References: <20260207232925.80976-1-rajveer.chaudhari.linux@gmail.com>
 <aaJfDsCLKfy34dSP@gondor.apana.org.au>
 <CANS1UbimhOWVzVORMpe-vbec7qcWi=d6VyPo-D-nBXdr0NouRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANS1UbimhOWVzVORMpe-vbec7qcWi=d6VyPo-D-nBXdr0NouRQ@mail.gmail.com>

On Sun, Mar 01, 2026 at 05:16:24PM +0530, Rajveer Chaudhari wrote:
>
> Yes, this is safe. I traced through all functions called by
> drbg_uninstantiate():

Even if it happens to be safe we still shouldn't do it unless it is
actually required for correctness.  We've had many dead-locks
caused by freeing resources while holding a mutex used for
allocation.
 
> In fact, holding the mutex during drbg_uninstantiate() is
> more correct than the original, as it prevents another thread from
> accessing the drbg state while it is being freed on the error path.

It's either correct or not.  If the mutex is required for
freeing resources please point out the race condition without
it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
