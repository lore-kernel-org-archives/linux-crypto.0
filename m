Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A754706A;
	Fri, 18 Sep 2026 09:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725395; cv=none; b=UlODhk/vdWRYarKe1hL9R09J7TI7T6R1Oy+ow9yXOCArLGHCV0DrmM9N/IoSZm2xZF9RNZJgc5TqL01zEMWJX5ijC9ul7ob3OHBowR+/8cMjSennxHNNyQgdo6XFLqD9/ttU1xWU0kpSIatRrkvwislvDNkdgeRh136ZyLL3a1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725395; c=relaxed/simple;
	bh=b7qmHjhoAucvA+qW19n8eM0ifQLGidvn939j7HSOm7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtYBVBPIhL1AUtLxlOIhEkhDriBiP+M6rWuVJeyw4nHF5bU96+bbX6thhwLQbCJ9sFz5AkHGak3/OlvoWKMXNSoRCns1ZtXXC8fe63DJEE7zlkG6QaIfPwYBdaa639oIhd1IQQERFfUEJbkaFZGWK37q70r/GNEcUae811sGZQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GtIpM4K4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GtIpM4K4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LK/WsKHOqSlu2/F7hwEvMrB2bCxFF1mnOcwumFXO0MU=; 
	b=GtIpM4K4IQQYasuUwbqJd0mGwHA0q+EPwQEA1wGf1mZbAx/NyfUDLHGrnC+AMYRJS4ZY2JsKAwV
	uIwQlsErd5kjNCIbandk9Kam2aHlnIoUcyxrXnZFAkR8BwZBaS/HonE9Uoq03aU+Kp//BKErIJAGt
	57Htja6l14rkXBJtMKUzRR8quRj9re4Hfc5B5U7vE2/QBIMqlxZLuevcSX4jbW/DbL3pFy+cY0vAJ
	Yh4+EsvEy/NuO5omVNK3zijPrMor75oLLW5KE+HYieozaZMdcDG+i3V9HLH1x2isspNEQiFnO0ubf
	kBh3e6SUxxBw7XCRYDfP4BscTvdAMsnnMOrQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VKW-0000000FM3A-44GZ;
	Fri, 18 Sep 2026 17:56:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:56:28 +1000
Date: Fri, 18 Sep 2026 19:56:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-des: fix crypto engine cleanup
Message-ID: <aq0KzDMFoClLWo7A@gondor.apana.org.au>
References: <20260912144116.993932-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912144116.993932-1-lgs201920130244@gmail.com>

On Sat, Sep 12, 2026 at 10:41:16PM +0800, Guangshuo Li wrote:
> omap_des_probe() allocates and starts a crypto engine, but the remove
> path does not call the matching crypto_engine_exit(). The probe failure
> path already performs this cleanup.
> 
> crypto_engine_alloc_init() creates a kthread worker for processing
> requests. Without crypto_engine_exit() during driver removal, the
> worker is left running after the device is removed.
> 
> Call crypto_engine_exit() after unregistering the algorithms and before
> tearing down the remaining request handling resources. This stops the
> engine and destroys its worker.
> 
> This issue was found by manual code inspection.
> 
> Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto engine framework")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/crypto/omap-des.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
