Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB219DF62;
	Mon, 27 Jul 2026 00:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112355; cv=none; b=UBmHfu/aC9Nhn0a//SFrMr1bv4hCso+anW596BV2r2JC6iADWXGoNkvj9kqHnX9+FRCH/22lhVDJPn6FUQEzz18gT8nsXcLsEDwULfY7e6f4OQDeIKoHRx/466i1ZqTrDZjz5v2v7nb6eaT02D6xS+YgUJI/283E3oBgNek3ruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112355; c=relaxed/simple;
	bh=HNEwZRZIXwvC+bgVi0Rnm6KE+QxPLecxXmWct6544k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhXNMfJOuhWNcYyYOcxa4fA+xMJ7ArFbdpB7qFVrQZjAZLsa24LWBrLGhuLY331mObYF4obt/t7pdMOicJdB+YAZLJ3m3V5dWHztjHil6iGkJ1VKBuOzuth4WEwLFqz0Sbj0UEZf9XDt1QRR6EJJpbj9CX6hEpXy+hZovGECRVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=knO0AlaB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="knO0AlaB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zPro22Tq5IX0/TWloRDmCe5ZLKcEksgfNj0cfzZv4dU=; 
	b=knO0AlaBXKGPqHXYqBwPPH+or9nj7QhPQ2GrBY0xxmD6d3w8ILq9QckxfGuQebrt8TU2N5Coc/o
	ZK0gwPRoP1w49Ko6HETqUL4t7EBf4mpMqIaW7aIagT50WarikgTsoQd7NGxGb3Ux6W9Dwocpe9LO5
	FTB63IzZJE4xE+7aiCghBT6L74rj7iGGkEZusdHkMC+ONORmmi/ANyj8sz4pCnGdNCM6Eg3WhmFjW
	ZQMH1do7zAmzPa79uejoMq06Eyuc6eCRnbuXVCldrrZTUUlNdxj/lamxIsNvIwlU4o8ob4Z2552+f
	FPQxdSV4nYjTSlDXXBkluZW3mdVnS0BsUHFA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9GY-0000000Gyw0-2laI;
	Mon, 27 Jul 2026 08:32:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:32:22 +1000
Date: Mon, 27 Jul 2026 10:32:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linmao Li <lilinmao@kylinos.cn>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - Initialize completion before
 requesting IRQ
Message-ID: <amanFspzLLbEYLOq@gondor.apana.org.au>
References: <20260714033015.367735-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714033015.367735-1-lilinmao@kylinos.cn>

On Tue, Jul 14, 2026 at 11:30:15AM +0800, Linmao Li wrote:
> kmb_ocs_aes_probe() requests the device IRQ before initializing
> irq_completion. Once the handler is registered it can run immediately,
> and ocs_aes_irq_handler() unconditionally calls complete(). An
> interrupt in this window would therefore use an uninitialized
> completion.
> 
> Initialize the completion before requesting the IRQ, as the sibling
> OCS HCU and ECC drivers already do.
> 
> Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
