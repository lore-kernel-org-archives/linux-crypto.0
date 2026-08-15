Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1D33E34E;
	Sat, 15 Aug 2026 01:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757182; cv=none; b=BerObs6IhPwFZoLTeHogGsQM6agOnlWmbyV9OvX/wQS+xTaMS/CReSGXsmF28gtBcrdIqcfZuKU6gbft/q4gbB3afInKoPn/+E1+xMwLySYKs8w5Tv0LEkpfyk4m+0X40+8aDBdWD4KJftdAPzRvMLWJWJhgQxoCIkaopLb7cak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757182; c=relaxed/simple;
	bh=HSWlqIB9x2VjOediW0HIGthiSrqgVvthy5N7sUZHJjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JH2a8hnzkI77H6iTphvlk56x3DnlpIwlp/4BNTsrOmESNEq08Hh+biHwvjVyB46fn60rVlYynvFpu29fKwiVFSzvT4x6Y/pyB5TQ72T6R7UCxtpXWQGjqaoSslOxE5zzuSxet9zY+b6XiUaBu2SiGmGsFGbu74dOMPHrwgU2dB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=K6hHG43R; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="K6hHG43R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZN3GEA4hpMPy7hywrY9SaoACRStnBSsn4j6zMNZP70s=; 
	b=K6hHG43RilOfE26j32j2D/7zd2fwzpE6yw691xzGqbkSbQQz687Prg1URQ1I3dWVD0XtmfKWyME
	17BrDpdF+r2pUg87ZdyuEehg/tjQmpTBs8rFmUa0ekGYRn8Y7AGgySj3N7DdSHIEKzWErBLjxs908
	JPse+QDMv6qvvxz2imztkcjnEiLqHbYd4d9jRKS+MtGJSxw4wgcQd4rml7Cu78yFZSUtQiHts9mvH
	2qXQEDMsW/o76VGUa82BquU/RdM30JGCUWQ6BZsvrUvStGn+1ReIC+0A0aUhaBnwNl9W4yfBXnbMG
	E8N1hhYzKZNAH1Omkn/rYOaY5wQTEs7WVYfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3A9-000000054tt-1N4y;
	Sat, 15 Aug 2026 09:26:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:26:17 +1000
Date: Sat, 15 Aug 2026 11:26:17 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: eip93 - use struct_size() and flexible array for
 ring allocation
Message-ID: <an_AOQWYPGvORVJJ@gondor.apana.org.au>
References: <20260803224028.87631-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803224028.87631-1-rosenp@gmail.com>

On Mon, Aug 03, 2026 at 03:40:28PM -0700, Rosen Penev wrote:
> Embed the single ring as a flexible array member in eip93_device
> instead of allocating it separately. This simplifies the probe path
> and uses struct_size() for a single allocation.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  .../crypto/inside-secure/eip93/eip93-main.c   |  6 +----
>  .../crypto/inside-secure/eip93/eip93-main.h   | 22 +++++++++----------
>  2 files changed, 12 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
