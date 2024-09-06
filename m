Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEC0145B11;
	Fri,  6 Sep 2024 07:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606635; cv=none; b=ufTwIQ6w77BTyfhQJ5JBejWgArHHphW9ulSxJNMYaC01mk+wTbfAGXeRTu2JjSpTXmiwYlDLWxWXyIKUBIinz0mnl2tCof5gv4bNOTkCth0k97Z1qllEyDoSkFAyS5skVfH1Yh2YXDxVl7CmO0MmAeRflATHE3PH5El6aFuIbSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606635; c=relaxed/simple;
	bh=+F4Q3l1w/86+9+zNV+gh0ba/kqzPI1JMkDFat9cgZeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcLHeH5VgFziOL5LvWx0WakfXY9sUZU4/OCUvMmsJQEAstABbUt+Lb8N9Tzp9pwh5wuQ7H7sV0kJGSok6yfgGQfGQbiN9WLKVb85jAd2XHslvKOm9gFJJVeyyStOrc8h6iph9Uw6Ppnd9jMgKViAweYFY5i20Rs2gr2K2erng/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gRI5uGcB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gRI5uGcB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0M9gSM0LGbvHFT8vxtke9782uGKuGhEYIqzbKdzgri4=; b=gRI5uGcBx4fVzvwiW6sQJROUY6
	il0kWYDO7ADj8LrCF+fGhd1N4/Ja+OoPGhIb/35z6TjUepq9gRTiqKaT1o7nJsTiUXUdeEjZOG/Kr
	EJC9XzjsWwon2CCffknR3GdHT+Ekukj+KWw0DChCPcPZ2IXlAFG3GWn4tfc879LhGtrTSpBbOSGGp
	2MwpopqNsfvzcumal2042v3qvcj7M3fgS3Q4c7zu6i3tS0MIpLuvwDevItfzkR0eX4ASPPtl1E6z1
	T6+8SmIRcmTQwE5MoM9CLoJghQqd+08QqmtIjAchrWYlMFYyZlRFFH0VTa6LRLiuUjkOq1fGG9BW+
	5ILlMljA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSx3-000Wai-0S;
	Fri, 06 Sep 2024 15:10:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:10:26 +0800
Date: Fri, 6 Sep 2024 15:10:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto: hisilicon/sec - Remove trailing space
 after \n newline
Message-ID: <Ztqq4lRe7crT7mA2@gondor.apana.org.au>
References: <20240901160430.143143-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240901160430.143143-1-colin.i.king@gmail.com>

On Sun, Sep 01, 2024 at 05:04:30PM +0100, Colin Ian King wrote:
> There is a extraneous space after a newline in a dev_err message.
> Remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/crypto/hisilicon/sec/sec_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
