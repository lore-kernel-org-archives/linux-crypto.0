Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B779CC;
	Sat, 14 Sep 2024 08:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726302919; cv=none; b=mK3nokg502OdM0HZf7erehpO/QyZ9nzZhO6khl6avf+SwcsKnd+G+Wdc6d8ZxoSeDEf7rdaRM5ZPFzaT1x1p4ylwzawk4yHu251LkldDi586XFI+cW/gULhtBkjoT/FGa9ZIvwLZ5FaHCUjK85+NtBnaakBQg76cbhe/GgmgCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726302919; c=relaxed/simple;
	bh=jt3Zet2HTHu+J26EzPl8OaYkruhDJ5fNoAT4xi2O8RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liuygh8pOHqQk/Ldw4z/we9aMRfjUzMwdDIOIeD6OuZfnpr2FQrKbR7eOcM+utWTZ+TRNMoaXssxO4Fm2UgWxsOq8J0dJSOJsDb7CKLeqwPWkv2r2Ag9YRk0JXIgWdgU4LziYWrk+NuZ31g1FSjkMXNICGjrVgl7xEfFop5k0UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aXjJUo7g; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aXjJUo7g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zh2QQjKAES8s1zvEmN/QjGKAcR4fcEDJhy9PIMv/14s=; b=aXjJUo7gSmo3AAaVSQAN3/FPng
	PkfELSQfu21TbWmDSccTI0/8QBi2z0DOcM/79uYce/pSzuTf5NVwgIL3UqsAN1jvaBxZY2Ra2ohur
	Q7g4lWh71vKPdpRboir6KTdnTqC7xvSItv7RigEFDwJBvnPATqQ0+hNdxE8JbdFGMy0eiR2Yp50JF
	oNn1O/ln0PPW3nEvG8WU5uuPqpI0IvPo+2xOxSd0em5a7czImBkla+w/iZ+scbCtYQ7vR9cTlssD7
	UwP7GQDXT5wcWonoiGhMmlyXB3vZsqRmzeDJQYaoB4hxXbVsqGZs9ho9LNiiXeDwuAGHDq3d2qOqk
	R3o7KLEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1spO5J-002R6i-0h;
	Sat, 14 Sep 2024 16:35:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Sep 2024 16:35:02 +0800
Date: Sat, 14 Sep 2024 16:35:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tomas Paukrt <tomaspaukrt@email.cz>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: mxs-dcp: Enable user-space access to AES with
 hardware-bound keys
Message-ID: <ZuVKtuMqiCu67hn2@gondor.apana.org.au>
References: <1di.ZclR.6M4clePpGuH.1cv1hD@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1di.ZclR.6M4clePpGuH.1cv1hD@seznam.cz>

On Fri, Sep 13, 2024 at 12:58:21PM +0200, Tomas Paukrt wrote:
> Add an option to enable user-space access to cbc(paes) and ecb(paes)
> cipher algorithms via AF_ALG.
> 
> Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
> ---
>  drivers/crypto/Kconfig   | 13 +++++++++++++
>  drivers/crypto/mxs-dcp.c |  8 ++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 94f23c6..4637c6f 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -460,6 +460,19 @@ config CRYPTO_DEV_MXS_DCP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called mxs-dcp.
> 
> +config CRYPTO_DEV_MXS_DCP_USER_PAES
> +	bool "Enable user-space access to AES with hardware-bound keys"
> +	depends on CRYPTO_DEV_MXS_DCP && CRYPTO_USER_API_SKCIPHER
> +	default n
> +	help
> +	  Say Y to enable user-space access to cbc(paes) and ecb(paes)
> +	  cipher algorithms via AF_ALG.
> +
> +	  In scenarios with untrustworthy users-pace, this may enable
> +	  decryption of sensitive information.
> +
> +	  If unsure, say N.
> +

Why not just expose it uncondtionally?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
