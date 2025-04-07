Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E959014AA9;
	Mon,  7 Apr 2025 03:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743998214; cv=none; b=GbmI3Tb7IiobPRksS8ezr+nNBh9XpaZzr2hgsRXrLpeqtFtMd6OcU6HMhh/6mhsOtJOgh6T38+n2b+cGSCKGdyvVfH00vdkA5TlJwoTubWplWmYz8fxrhmKFiAIK0pQO6s/L0ZVPfSihyccQB5A4iBoxk7j5YfmiU6uNZLoJU2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743998214; c=relaxed/simple;
	bh=S+pL2t3URZac9VfYC4csGspGyQI2T3N3K6Ln7gjkKw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuestfxYRbhBSDSvWDk/Nc4Aea0JLhk1xi5CrtJHoStWekFknKtIxzyfE0ra5RtHGc58X9yDMpQoEtJYrOl5BIVMzwpe0R9KYXBNtpA9iP3LkTXkxaxsA76DVIvyoxyS2FExm9+h601kEVGJ2QPzGqfpsDYcIuTBUfsk81A7WdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MjM7iyEY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MjM7iyEY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JOCVFoZKN/0pqI+VbreA8eza28Uh0Gc02Hvheb6BCGo=; b=MjM7iyEY/h4tSrTK0unjHkO4Oo
	2RuFhUkcyGB72cfF9bCWWIpSkUw7gsLUuo78Mk08Isdsb8djPNEwFTtU3lMbJtH6opFwnNwte3Rt2
	Xm+ZX9TI5ZR1BQLBW91PxI7qXGWQ04x6QuhEa4o2r1EnHehMNpX7ok2ThI6hH8eJp5/PNpXhBkGRE
	nijigLBBfka/ZRIVVMtUE7vwqFxAJcPZwmJb5RpquykO73AzRTJ/4OLT8/gNdKsu22iu+ZVJPnFzB
	nTub1XOMRiaTwQy1G3lhBfe0KCzLRT+YsHMuR7VRRrJvnSh0YzPN7na66M5jZbsFNwKRjjQBDGrgB
	eDSa+SwQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1dbA-00DMQq-2a;
	Mon, 07 Apr 2025 11:56:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 11:56:36 +0800
Date: Mon, 7 Apr 2025 11:56:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: sun8i-ce-hash - drop
 CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG ifdefs
Message-ID: <Z_NM9LnUF6Gpv_iz@gondor.apana.org.au>
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
 <20250401192321.3370188-4-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401192321.3370188-4-ovidiu.panait.oss@gmail.com>

On Tue, Apr 01, 2025 at 10:23:19PM +0300, Ovidiu Panait wrote:
> 'struct sun8i_ce_alg_template' is always defined, even with
> CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled, so the ifdef guards
> are not needed.
> 
> Make sure the statistics have IS_ENABLED() checks instead.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> index b0959d8218cb..530c5181d73c 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> @@ -31,9 +31,7 @@ static void sun8i_ce_hash_stat_fb_inc(struct crypto_ahash *tfm)
>  
>  		algt = container_of(alg, struct sun8i_ce_alg_template,
>  				    alg.hash.base);
> -#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
>  		algt->stat_fb++;
> -#endif

Should this go under IS_ENABLED as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
