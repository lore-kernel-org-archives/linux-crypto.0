Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72E2D4B68;
	Sat, 20 Sep 2025 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758371086; cv=none; b=XxeLGfnxs+lTtWFu5bS5VTp8FxUeB8RbvyFJOW2yAkRq8a0E8GlapXXSZ3XPpZHECWtM+atxKBs7ibCnr43xP7LHKhk149BcfDgPb4GRZiJmOPxwEMsVKxrdusgePKhCnWnRFJrsmV1JP5/8mq6H7Db4qsErZue4b0aHKUwdtgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758371086; c=relaxed/simple;
	bh=QkGs3CcTduaVBCAdGEn7X/UZDrvPjIp9c1P80mHRQUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ag4O26fG0V81ud+WgJwlsfd3z+qp0hRGYucL7d8VPuNmarpZcxkFwln0Salgq2qS0VLaCz6jVSu/dkSkJpKZpsfi0uCfueWp7XsNzvIT51A07e3L3/IKCBE7GB5ck0u7JyJvd5qMnwX0czbWveWR7Ii65Lbb3RnoYE3lPCsMgB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mlutS17W; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mlutS17W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=Gihya9xP0fAcqsxzSzES+1BCfKN/8rEUF3BTdeplS64=; b=mlutS17W7yGIqhdfi1idO6nGob
	czgsUB/fZ/9YSk0UXQNqq2kkv6rrIBIbqoFGHs5FsN70xtSIbNBx4wpbkLK34OGTcxKdk39f2ZHt4
	I/YFgc7KbUiJquNnJ5TO2teOt+hJGjAlDyvf6/0hKgQ0ES451eXDCw1/EfS5KQgz9/YGtocmNPrH2
	7Dy+NDITl0wVWEzhBdtLULqvyBoJ8WFuHOGxm5rccB0mMeydzP1ERdViZeOIcUcmsNniDLdG7Oue7
	3QRyu6ikDglunhBZt8ewIthuWYaULvRwph5QTKoTRhkpph1kXabfGyYmg/fiZSK4VwW/DwqHeWn4N
	q2b9FAyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uzwdc-00704n-0p;
	Sat, 20 Sep 2025 20:24:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 20 Sep 2025 20:24:24 +0800
Date: Sat, 20 Sep 2025 20:24:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, Neal Liu <neal_liu@aspeedtech.com>,
	"David S. Miller" <davem@davemloft.net>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Johnny Huang <johnny_huang@aspeedtech.com>,
	Dhananjay Phadke <dphadke@linux.microsoft.com>,
	linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: aspeed - Fix dma_unmap_sg() direction
Message-ID: <aM6c-LsUNPN3CJ3m@gondor.apana.org.au>
References: <20250910082232.16723-3-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910082232.16723-3-fourier.thomas@gmail.com>

On Wed, Sep 10, 2025 at 10:22:31AM +0200, Thomas Fourier wrote:
> It seems like everywhere in this file, when the request is not
> bidirectionala, req->src is mapped with DMA_TO_DEVICE and req->dst is
> mapped with DMA_FROM_DEVICE.
> 
> Fixes: 62f58b1637b7 ("crypto: aspeed - add HACE crypto driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
> v1->v2:
>   - fix confusion between dst and src in commit message 
> 
>  drivers/crypto/aspeed/aspeed-hace-crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
