Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D22C16D9CB;
	Sun, 16 Jun 2024 06:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718517874; cv=none; b=ojjYYAum64Y62NGRppOUN6F3PuWU9rlWQ2DkeP+raX3a/IBwr3xJmdaUMJY5CQo34IaEh9U8rnC7nEg7NonhMTeBz/NAqSF/HvXyXS7Nqk+XY+av176fKcCtBygV6yGZVdfEv2KKMJ2dXT0CEX+eXwgKCG5CnHFzZO3sWWfcNDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718517874; c=relaxed/simple;
	bh=wNbbkltnCkSP3zohQH8HlsPetJ8LPyWQ4nF7pDjrrCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emRcjiyBKmN7zKjZRxPJxXLE1D3goaLzZ2i8AS/UdibGSuejpELQu1/0l+J0n27CDdN+dR4wo4PazMPem79eSV7+TF6Cj9xHurlfzTIlaIiVFxblueZSAVdZuiFN7wFB4Foz0Iv7KLSbofKUtOOXx3Q///hU0RWGeXR1X0Fi0VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sIit5-000aN4-2H;
	Sun, 16 Jun 2024 13:57:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Jun 2024 13:57:11 +0800
Date: Sun, 16 Jun 2024 13:57:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>
Subject: Re: [PATCH v1 1/1] hw_random: Remove list.h from the hw_random.h
Message-ID: <Zm5-t-8npvbzJmZf@gondor.apana.org.au>
References: <20240605185133.2535780-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605185133.2535780-1-andriy.shevchenko@linux.intel.com>

On Wed, Jun 05, 2024 at 09:51:33PM +0300, Andy Shevchenko wrote:
> The 'struct list' type is defined in types.h, no need to include list.h
> for that.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/hw_random.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
