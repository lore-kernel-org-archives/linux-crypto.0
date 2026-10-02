Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244C947F2EA;
	Fri,  2 Oct 2026 10:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935856; cv=none; b=Rxa2OicZIUw43yizxKU53FGux0q2OXNkSpR1RZGAhwd5nqOjGenl4pH5nQD9NOiUVwYOh1X3jPqA1Lc0H/Tot39DmRoHIePv7eJnSFgpW8c1gyRrvaiPCQe72tqWjX7mWGBeScNFHRRlCXskMg3s1xeTHs6KYsII8PRiqujPj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935856; c=relaxed/simple;
	bh=7VEVQ3u77Fhd8wPBmdSdQZK+qwN5FHvCBvw7G/AdlJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ac9kVcBVOpNcuk3NqB0rGus/HJeTUC71sePK7lozrwlIM7w70UtGAQqEDJgDXgTqHRcXdjk/x1Q8l6NlIaATIQATpFSkHPIp0X0yQH0WnS8PvzBMTZ0VvQpwXrQCKf+RzZH+33VhV6AZ0UW6McKz/BWIj8BsRG3ntSidU3FZaJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mO0J9Sgi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mO0J9Sgi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=trnwrqw/HickAJ5PlywAdnxDcCfMIPd0ACXP6DY0G1E=; 
	b=mO0J9SgipK+jaO00bjvED3C+9NqlLYTA+2gJNVnWnSbmfB7/h3vHT44q+c7rngX4NC4gX47OQ5N
	2JKA8LY+KLg8Y1BQRNaEepN34Yu+wX9RVsf/bbcT89wodo1lXnDi+9o2fnAYi8zELqDayW+82wbJz
	tBrR99S9x8xCWpip1UOUAz9ETWPSStjuywmNjH0bdUN1wsdNmc6Rvnm/6+QYXSJYGvmoX4mM/RgFf
	9d3HRw3S8y645PsGytr3sTIACPXqGnP5S3Z2De4+pXuusgsNVxLZ4KEtPyHikS0qURpNh5Wnx3jln
	ZoEi2sDiD+AhNl0lA3OixuCz1jQ3IMWou6lA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaDp-000000001h9-2p60;
	Fri, 02 Oct 2026 18:10:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:10:33 +1000
Date: Fri, 2 Oct 2026 20:10:33 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: intel - declare warning string as const
Message-ID: <ar-DGWjHrlBjwTqm@gondor.apana.org.au>
References: <20260923104237.82599-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923104237.82599-2-blum@kernel.org>

On Wed, Sep 23, 2026 at 12:42:35PM +0200, Thorsten Blum wrote:
> The warning string is not modified and only used during initialization.
> Declare it as const, replace __initdata with __initconst, and indent the
> string.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/intel-rng.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
