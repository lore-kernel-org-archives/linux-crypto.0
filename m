Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8B718FC95;
	Fri,  7 Jun 2024 12:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761672; cv=none; b=CGUl2oppy2PIFPqAnzTPYDalMX8Wsni+ijZG+H7sPU4oRV4CH2HoATasxWebVlFv/ZcJyrjYb3KyNvULJcCzRwUX3ZZUyTzbuUtSlLpNXUcFIZJJ/5lkQOmzebUgJElTgZ1lvCAfW8mRPtV3HteCnhd/VLurQOA96qFqY/3L+bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761672; c=relaxed/simple;
	bh=eJs63ZbeFgQzPVql9iMW8zmdX2TPotIFYYk2b6oCVZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAWpNVCCo45T588BfPPMIjmPnPIYr3dIog7MxIHVRUIkDkeL2CtWzkgG/A4VfobdgtLg4axBwWp02f7yQtZZaqhYyaUCajbAcJj4PNeKBq5XlSjaMHPZYhDMZQZ4cuX8unhjxleaLpLRtKri9clJmVmyOO1xiLJw9/jBRENrk14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYH3-006pMO-22;
	Fri, 07 Jun 2024 20:00:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 20:00:52 +0800
Date: Fri, 7 Jun 2024 20:00:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - add missing MODULE_DESCRIPTION()
 macro
Message-ID: <ZmL2dKZB04hlSxZ-@gondor.apana.org.au>
References: <20240602-md-atmel-sha204a-v1-1-ab02640a0cf2@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602-md-atmel-sha204a-v1-1-ab02640a0cf2@quicinc.com>

On Sun, Jun 02, 2024 at 03:33:39PM -0700, Jeff Johnson wrote:
> make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/atmel-sha204a.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
