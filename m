Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFB98462;
	Mon, 27 Jul 2026 00:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785111930; cv=none; b=YYG9y9BRkuhtrujqr9FAX8lNaqYml+/U/vptZSS6ZtSIAtGykeMBSutycoUaEwoziNVDg/sbZXLg5pkA9aGeIrG+18cjVDV90gkkE5/SWz161RnaFz7Ytk3vXNymrZ/hsR1GvREsFJBfe9Q2rt4bi/jIx0bCbSUVZ4Tbo0IuVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785111930; c=relaxed/simple;
	bh=w73zaOxIpXVHO1k+paV72gC41a0e0+A7s8hHR4vxsPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5blcmDAiFO8UCnBPi+iKf1YBwhMwf2O/OvBp+f+E7Zq6q6Ie7wpxvWPjX4L3hB2J1Zq+vJO6RZcdb6B/QncJSHNmGW9PPzRTgFJh1xjqRlFhketk3rW7M06oH1k9zNAx3C3hNpC6RKB1jif+R/FoPruOV2e6cZoNwImTIKfCU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JgtxTG6p; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JgtxTG6p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kWlBZW1wbK+sQ2UrWbNDc+MtqluzUEIxTahpjqGfIUY=; 
	b=JgtxTG6p0V4nkGJHEY9ZUyVjort3zqmN+D0/vxeGQicPnPjYHYKtXmbjY2DAmx+56a3XUcFGa82
	j5oU0S0I6PEDc88Z3ZzGijpYUjULz3/tv0CT9cO1S3eVMec+Evuc+0YnpwBv6dGv5uGHmFkBlbmnl
	+qVtKnWUB9VRQWrkGjv7KL4BHVZhYVgguHJ8CiCkQZnwwOzhuohhjvs6lVeFmCamRX3YbsFaarl+u
	0+281NohHOUCDsX2qt4UTdiNp0apuU7KO6IGSKhLUiwX35Dvq1iDuuL6oux9zyagmtzXQwcOR0Hk+
	BOHutxkZxmqz+kBlNkN9uPQhuNyNMxZ6EGsg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo99g-0000000Gysx-37ws;
	Mon, 27 Jul 2026 08:25:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:25:16 +1000
Date: Mon, 27 Jul 2026 10:25:16 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: cesa: check for sram_dma error
Message-ID: <amalbOVzL4gCWS99@gondor.apana.org.au>
References: <20260717225831.1085313-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717225831.1085313-1-rosenp@gmail.com>

On Fri, Jul 17, 2026 at 03:58:31PM -0700, Rosen Penev wrote:
> dma_map_resource() might fail. In such a case, don't call
> dma_unmap_resource()
> 
> Fixes: 37d728f76c41 ("crypto: marvell/cesa - Fix DMA API misuse")
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: use dma_mapping_error(). Fix Fixes tag.
>  drivers/crypto/marvell/cesa/cesa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

I think it would be better to fix mv_cesa_probe to not call the
cleanup functions on uninitialised engines.

err_cleanup:
	for (i = 0; i < XXX; i++)
		mv_cesa_put_sram(pdev, i);

So replace XXX here with one past the last index that was successfully
initialised.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
