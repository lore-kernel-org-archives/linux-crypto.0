Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3495430C157;
	Fri, 11 Sep 2026 05:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789103624; cv=none; b=i5lMyvrINc7SNzmJQR/e8GW1UzJ/oGzs8yw1BNw1TQWXJSQ4BItwBjGj2WjbhDUA0AOeDdA2sHEWo3NK7lreZDAuv8yC2vO/X3MlOkzM353BBwdoSrnidD8idSWL4jboppdu3b7ZbH4kH/bAgluvOxXcq2QJ4e8y2ULiGcrLQtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789103624; c=relaxed/simple;
	bh=LOi2iC7FJZGl5iGPPhHJp7/TZBr5E7+tdhPjj2BtWXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/1dYNvNQdTEtf6NBBbMMx7Y1HvC5gdRpmdW9n5hxH9g/tibyHy68PvS8P6+lr7Otp81HJr3bGczXw8zDZ0+yNYT3G7dkMSfQ45AZaM+F1C5++gnP9BAtRhodhtinKGZ/rN3qoc5mULM6bqlZBkeptJ3tJ67UOFLeth2zsKUToY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TeyUBFYl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TeyUBFYl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8JQSyhuDqR6r3F3TcLX9Gk82JpvsFU2Iy6IWZgMv2lQ=; 
	b=TeyUBFYlhEcdKTnuqJ2LnOVyqCo5N7Qph4dNlzzVKcdqhL1UHY8nPp6G7jfDBE4BQj8GWlv7JAE
	9fpKs9sPKW3m+3XvHgsOtd9xWI1cyv6EZTeQN0uFPYvmU2heYw716cI0lVwEgPf9Sz5SGHZ1MnrK/
	S6A3bGwhQn61tGXTU7SlpkdQ2Czqf+mFaWq2vnqAAk7bs9xkRHIFzeVvTUwQhINdt7g9Zmys39sM7
	hkN1N50Ep1HFeyxe0Wzz2W3OSnT3mkRG5UOLV0FVuPDrIMd0op8DxF+TmrwXFSMzSB4K/m6GVq7Iw
	HNfNLHTlDxJYuGHjzf2r0a8ZFMJsrpv6GzVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tZr-0000000Ctvs-4BPT;
	Fri, 11 Sep 2026 13:13:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:13:31 +1000
Date: Fri, 11 Sep 2026 15:13:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Triet Hoang <triet.hoang.dev@gmail.com>
Cc: dsaxena@plexity.net, olivia@selenic.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap-rng: Convert to DEFINE_SIMPLE_DEV_PM_OPS()
Message-ID: <aqON-wLtJG9cdFop@gondor.apana.org.au>
References: <20260820045127.1960734-1-triet.hoang.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820045127.1960734-1-triet.hoang.dev@gmail.com>

On Thu, Aug 20, 2026 at 11:51:27AM +0700, Triet Hoang wrote:
> Convert the deprecated SIMPLE_DEV_PM_OPS
> to DEFINE_SIMPLE_DEV_PM_OPS and pm_sleep_ptr().
> 
> This lets us drop the __maybe_unused annotations from its suspend and
> resume callbacks, and reduces kernel size in case CONFIG_PM or
> CONFIG_PM_SLEEP is disabled.
> 
> Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
> ---
>  drivers/char/hw_random/omap-rng.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
