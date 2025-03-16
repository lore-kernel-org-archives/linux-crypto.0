Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9703C3FE4
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742099704; cv=none; b=tF7Yc3lXdkm7vQDCK5GOAwqGxe/OwMmkr69o9DIxsJa9//6+mVMKrnCGoxS1N+fCre/BGW9cLsTPNouCiqPH5EHzR1GszajpwoDULBg6fWA5eVlDPA1N5vcgD1+c2H8olKsKWXK1dMRxf6a73wclpvElUDZKOAYTSfFDbIERaWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742099704; c=relaxed/simple;
	bh=3zw+V45kchpT1BnNlpE2cQxVqoGPef+UI1HLnsWvxNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkM/eTzMjZMoSmJ9SWXpDG7s/ScVsz3H1EEBzQfCmA4hmc5itQtUFrl0x9lP18picQqssm0cbe4mZeee1r/8tgGP3EVZNYxs5W8AR7Okhbq3sXNsMEfd74cBxEPrRQQtJbvBpTxx/lGOkFTxwF31S3vECZPpEmRObtZ6LpclGoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WUncfrH6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WUncfrH6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TRn9AdheWolObx3qjoaxQAXPpmlhgN1ZKk+VGaKit8c=; b=WUncfrH6Akm54zq1RI4qhinSka
	ycsnr7XhCP8a9kAZ+iTxl0npybklDjRbV1hT275ujSvd/RahQ/BGUBFpV2/ehftkMFTFE+89fG8f3
	Ntew0ty/PvjUsaNbK8dTgLbOGYHlFFpherfR+EQJmV802vzuVht4Q6QbMIsJWXjJI7bzrBFxxRNGd
	qzL7tOdU6U9vdRhHPIvL12ONsyq2yVz/7jCN5j25vWqvBCMf+L1EnmGW2DZVeBSjqn1xvQzmmrdCP
	lcigRP1ZHHUwhwzguwnNYQ2keEJeMevLMs/Rv26JvnLB3MvHBnh2kMYYPiqolTeK3tYiIXjB0kb0U
	0DwwR3bQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttfiD-006yxe-2s;
	Sun, 16 Mar 2025 12:34:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 12:34:57 +0800
Date: Sun, 16 Mar 2025 12:34:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 1/3] lib/scatterlist: Add SG_MITER_LOCAL and use it
Message-ID: <Z9ZU8bB7MSg9d3yt@gondor.apana.org.au>
References: <cover.1741842470.git.herbert@gondor.apana.org.au>
 <eee86a8ed9152a79b21c41e900a47279c09c28fe.1741842470.git.herbert@gondor.apana.org.au>
 <20250316033247.GB117195@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316033247.GB117195@sol.localdomain>

On Sat, Mar 15, 2025 at 08:32:47PM -0700, Eric Biggers wrote:
> On Thu, Mar 13, 2025 at 01:14:53PM +0800, Herbert Xu wrote:
> >   * Context:
> > - *   May sleep if !SG_MITER_ATOMIC.
> > + *   May sleep if !SG_MITER_ATOMIC && !SG_MITER_LOCAL.
> 
> This is incorrect.  kmap_local_page() does not disable preemption.

I thought it was talking about the function itself, i.e., that
kmap may sleep.  But on a second look yes this is ambiguous and
it could be made clearer.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
