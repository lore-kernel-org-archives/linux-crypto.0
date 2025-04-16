Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADC617A2E0;
	Wed, 16 Apr 2025 07:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790287; cv=none; b=ORVghMoJ6PKfShljUn4n9BjsOD47HUrR5HDyL7mJWcvov7WHX7Qh3SB4/p49yj09mnvgJeCwRwGHXkQomNqJcDdZ6Q61lKzHJNqrX1V5kYP6JNijbr7nnJhRS8/sQr9SzYrh4HmGlZv9DCYBacdAyd2i29EKkWgU1Ed/8j+0uRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790287; c=relaxed/simple;
	bh=uP2QUktcuMnIwHeWtqkVJCqIHzMHvjMl4VU1q0BxTuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2sesSGpORPomg1KpACjZQTI384WFA650NmDehDX2Bzj2TFnB1mxetwo8C0Dofmzvz2yOGmMjVb6JYXYp7io9aIRCxrA4131e98F+cNu3iRIF5AYwjw0JXximkgDgFDDPcXVxCab4v5oxNsUl0IyZFsIx+h2FUoWEvH7em6oEh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Bn0gXelO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Bn0gXelO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0lZOoJFvr1n/x73N+eL2qI8RtydiULjbS/3B456AGJg=; b=Bn0gXelOKb/+lmIQekagbZ3My3
	tFVCfJ2FVpnz8Nlg6cfjOwoj0hn0bDPThjTPZRAZ9hbDi9uw3hDUQSLunz+9ZNJAn7tGVZZ5KWml2
	lHtR6jNB49ow8NGcr2TWDFDYh4DSC4hMX18Ck6kJ3msga0nkzY778S2fOf8pM5fmSUluiRvSseMrr
	a7SrIqf+P0BVnim14guBiEKUEHWxNypGp7B/+CTPSOijgfC79p8/XYXwIGTSK3ZpADHdnmXRS1vDH
	8w8era46jzYL5BHpwpsVq8882ahHqY7R939dYhPbNkciI8ERgtCJZgUTux7lFy+fkHEDGe+r+Njvj
	r6MzLZSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xeg-00G7t2-1e;
	Wed, 16 Apr 2025 15:57:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:57:58 +0800
Date: Wed, 16 Apr 2025 15:57:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: dan.carpenter@linaro.org, thomas.lendacky@amd.com, john.allen@amd.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix __sev_snp_shutdown_locked()
Message-ID: <Z_9jBrd4o6-Xp42_@gondor.apana.org.au>
References: <20250409193429.346501-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409193429.346501-1-Ashish.Kalra@amd.com>

On Wed, Apr 09, 2025 at 07:34:29PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix smatch warning:
> 	drivers/crypto/ccp/sev-dev.c:1755 __sev_snp_shutdown_locked()
> 	error: uninitialized symbol 'dfflush_error'.
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/linux-crypto/d9c2e79c-e26e-47b7-8243-ff6e7b101ec3@stanley.mountain/
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
