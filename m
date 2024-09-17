Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF811BC41;
	Tue, 17 Sep 2024 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726550739; cv=none; b=ezm3AO40RIM/IvT14OaT3wuiuQG3szA/9DYXwYo/PJI5M1RC0OBN2UTylADGst+gSt5BgULmzPOQUdkoKL48yHPSb77TVJQNli5VqESh7wYzgXZawM+1orSNZqVheNVesm1SymU4/AphXcXqVQWoTA0686fRCaChO0vYnwTCWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726550739; c=relaxed/simple;
	bh=SbgGtDZbCMwqxg9fIcm760Dt+3OQFNMZEl5gHbWnpbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uD425d89WHhd319Ak9pUPDVyISyi2HaaV3Q0ZRdxyLEagehKq9beB5IGpB6RDknuwBgexoRlWg4p9+gW7ydG5hzjNoNG88jvVaw1aoCVBPkSgD1irMwIo0TGgRyJsReeI/w8w3Q7ex0gUHPvRArKQmITb9lP75VYBeTGOJZ+Xms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UcPI6k1y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UcPI6k1y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2h0Rpecx8X+Q1bfXED84RAkn6MnxicCc380aLCjYM84=; b=UcPI6k1yyFM22eZI/xBozPxiS0
	HeDbqeJh0dS/9Ra3TJ1Ci+bhopqb1vfTVMqIl8CEqPTKv2h1qo1jEK0domv1JrTDcl300GEXHRsHf
	2sSwi5VOxyuCoMEeZjnzRq6y5nb0261vkQhDxfNpIMSigXc/EqNieM48np8HRq2YZQQ3xLeVCbz6a
	6P3CPS6FgaRKFjoBcReTHl/apAaUocDa8MY2hrjdYKUUKYzLzdnTnsDTwiz7wdPFncddjIP+0ueHm
	GklyugrrNMcyH7dgvTQ0GS+k37eAhHYFfApivPYx9A4pJZikQEfx+oYBLz1e5cXCN2KtJWLV7Cmpo
	BNGXXulg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sqQYN-002wnR-0T;
	Tue, 17 Sep 2024 13:25:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 17 Sep 2024 13:25:20 +0800
Date: Tue, 17 Sep 2024 13:25:20 +0800
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
Message-ID: <ZukSwAh2FnVvQ85J@gondor.apana.org.au>
References: <1di.ZclR.6M4clePpGuH.1cv1hD@seznam.cz>
 <ZuVKtuMqiCu67hn2@gondor.apana.org.au>
 <24h.ZcXr.7FvRaSxxibG.1cvNHL@seznam.cz>
 <ZuV1zguLBsBZnGB5@gondor.apana.org.au>
 <26J.ZcYd.2XLMv9N98Uy.1cvOHp@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26J.ZcYd.2XLMv9N98Uy.1cvOHp@seznam.cz>

On Sat, Sep 14, 2024 at 02:41:23PM +0200, Tomas Paukrt wrote:
>
> Do you mean CRYPTO_ALG_KERN_DRIVER_ONLY instead of CRYPTO_ALG_INTERNAL or something else?

No I mean a new flag which forces af_alg to only use keys from
the keyring subsystem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
