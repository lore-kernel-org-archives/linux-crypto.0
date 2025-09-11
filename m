Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C59282E1
	for <linux-crypto@vger.kernel.org>; Thu, 11 Sep 2025 04:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757565819; cv=none; b=A0RXRdv5loxDlg0Yt2Q9AYjR4AV7brJt378l/MIctIWYZcH7A8yVzK8pe5pqU4nCAqMZWXlp24+J2M/DsWfEnZCKAmovaBAAJW93tIQRoHodNKtfG3pEJH7V541SvI+mG6IJSvF5dhhYzoEJimmzUhFnLYZHLDFfv6oE8KR3lOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757565819; c=relaxed/simple;
	bh=wgc45ieyyRkxoqGAjfjyFpp8/nnj4AULlU6eFO7JXD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AvesYswfFJDEOFHEeKG0pwy37k6Z7pyDs9RhRWIMctf29vU4VPP0H8Cn0hgLOVlXbN7DiO8P1SOoILMwEGwU5GaiHOyxevs2nKk6SMTtNIAStCFFo97UdLhdzUk3Hhg2L35+Ht5/3YTimN3jHJtEQ7KYCgx0lj6hsjfdqKzxY1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rs3bG2sh; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rs3bG2sh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2hfVVA8d+x6ga9dIGFsOSHrYE4e1HRqHXyniqvM3uek=; b=Rs3bG2shOapzKLYyd/y3zF4FeM
	G1KQODen2u0Lv1iiytbDFANCw3zYfrdnW3Z5OByqnXNz3jDrmhSXkpczoYNNwALC2nG8g/QHfidtE
	ZoTAWh30xulYh03IjpXYnsT6clglw70400hyzCU3QPiexn0mUUwgxx+7bmBw6S3uMDfD4Oo+I0USd
	rdyCtyMFE85zAWY+V+o/SoimW/a2mje8SpNSGTg2aFrtF2CrjPSCwiGANT7kE3xP4tNt5nvLrrGqE
	0pbpEfIWDqSut+KlbQ1YHR33KX2ETwEGvWplUdUuhuADM3Wq0ogwI1XyEeQek4ftESH5hZ2EiVT2h
	Z+awDwMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uwYu8-004Qyi-2Y;
	Thu, 11 Sep 2025 12:43:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Sep 2025 12:43:25 +0800
Date: Thu, 11 Sep 2025 12:43:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] crypto: ahash - Allow async stack requests when
 specified
Message-ID: <aMJTbV98DMjhEO0Y@gondor.apana.org.au>
References: <cover.1757392363.git.herbert@gondor.apana.org.au>
 <45f65a569f76a7212057f65ca800206d8f76b2e1.1757392363.git.herbert@gondor.apana.org.au>
 <CAMj1kXG1ES-vvUWfJz9Kefp84vCDcT+H0=RP5a8tRq5nrhddmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG1ES-vvUWfJz9Kefp84vCDcT+H0=RP5a8tRq5nrhddmg@mail.gmail.com>

On Wed, Sep 10, 2025 at 08:06:56PM +0200, Ard Biesheuvel wrote:
>
> If the algorithm is asynchronous, it may return -EINPROGRESS to the
> caller, and proceed to access the request structure after that. So
> this only works if the caller waits on the completion, and does not
> return (and release its stack frame) before the request is completed.
> 
> This makes this feature rather limited in usefulness imo - truly async
> hashes are only performant (if they ever are) if many requests can be
> in flight at the same time, and using stack requests makes that
> impossible.

This patch was meant to deal with the storage subsystem usage
of ahash where the caller always waited for the hash to complete
synchronously.  In that particular context, it would be safe to
use a request object on the stack if it was not also used for DMA.

Of course it turned out that this won't be useful for other reasons,
so I'll just drop this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
