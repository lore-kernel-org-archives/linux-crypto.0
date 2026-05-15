Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622C744BCB5;
	Fri, 15 May 2026 10:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840012; cv=none; b=Fy6Sjv7JJsXdvBqIxHp+/um6ZYgIVQFoJEO+bj/4CNMTzFSo3NJRoKS6cFcNGvLyl/LHfEObsHEQp3c0VJGgq9NCUPXMO5Wo+5ac/TxLzyNiMoUkuwNfDgSzdXX+y/oyBis2sKaGk5PGdnnkdY6x53pQF90fDoqBfK6ZeCMw3TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840012; c=relaxed/simple;
	bh=lnNtd2PSsZibHOsmh0vUEJcS3FmEBlNbUQsXaZjsmZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sny8DPjXUekqL498Gu4o4+Zkd3SNnDgiIocBGlnIJEGRbJHSWV63gQLFdpHTkm1NYWA2w/6e/iQUjtedUGu/LQV7NTakWSbN6bcVmebRiWLBw1QqhhOe9chKK4Z5YgOmOtkgIaYqt07/65YQnRa7lQgi3lACdJrfANEEpm3FE6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jzlYkPQW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jzlYkPQW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=p7mS3COEz/5MmKKIxJO0OFbLGDgt61I4Y5KtBcBZNiI=; 
	b=jzlYkPQWS7wxFpiUZOSA8mA85+GwPC1ff27Xw7bLx4canNKH5uebJcFFrJG1wtHDhazrWLO3TeN
	d6RbRmSnvldcF32zSazkcAJu97V21WDbgjZ1TmXV1LQwd4wi3JSNSFOc7A4wAPuGZ5s7djX90vB04
	f08p/nutgL2T07EIZCMYeoUbpAxlzpT+YYpSDQMRV+F/8R060hzrbb0fPVVNwdgx7hBVE/uiqjvqA
	fUni0//Wpp0RK5/AUgG6gcXzjpTFAxVRMfv0EQ8EvBOzNwTOPEBKvLiHFjHcHQS1ncUzzunmyHeiQ
	GyY7hadFZmEDoj6XS5UqZ1JAwJtOA1r+hqbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpXe-00EOGX-09;
	Fri, 15 May 2026 18:13:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:13:14 +0800
Date: Fri, 15 May 2026 18:13:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Andres Salomon <dilinger@queued.net>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-geode@lists.infradead.org
Subject: Re: [PATCH] hwrng: Drop unused assignment to pci driver_data
Message-ID: <agbxugXdb8kW1rCt@gondor.apana.org.au>
References: <20260504092015.1955605-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260504092015.1955605-2-u.kleine-koenig@baylibre.com>

On Mon, May 04, 2026 at 11:20:14AM +0200, Uwe Kleine-König (The Capable Hub) wrote:
> Explicitly assigning 0 to driver_data in drivers not using this member
> has no benefit. Drop these and similarly depend on the compiler to
> zero-initialize the list terminator.
> 
> This is a preparation for making struct pci_device_id::driver_data an
> anonymous union (which makes initializing using a list expression fail),
> but it's also a nice cleanup by itself.
> 
> It was verified on x86 and arm64 that this change doesn't introduce
> changes to the compiled drivers.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
> ---
>  drivers/char/hw_random/amd-rng.c    | 6 +++---
>  drivers/char/hw_random/cavium-rng.c | 4 ++--
>  drivers/char/hw_random/geode-rng.c  | 4 ++--
>  3 files changed, 7 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
