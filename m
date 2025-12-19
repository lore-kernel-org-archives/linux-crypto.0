Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667FE12B94;
	Fri, 19 Dec 2025 03:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766115340; cv=none; b=U29270cD/qwTXmDS43ZnnauPPhrHUlOSCHaPa88d3XMQ7AyJhLFJ7yVFMUFTuCPXWzYymirPOVitf+cTC7nZ0AwIrDxiAwpiyfA3sx7Qe9VskXaIaQQr679w+1hFmeWi743wkqkFpa3amiEMyfMt0b4n/Bvib87oPCbxUnXTkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766115340; c=relaxed/simple;
	bh=A0wK+l7n1wmHOgQvlCveWK9NWoLVsZ2Yc8NAHtU/43c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jog69vH3JzPJOM5EVYV0+fF+76/NzaKecFBrLlgEAqrzowzWrmnp/csPgS0XrUjQPit7xAHXwhYj9so3sd7o1vu9yfZZyW0dZB8X6v2HHVJX7O7O971rdZmpEHhPWyJ+/bOMstwXA5DEjGHij1wHbN3zEu9IKmT9qzs67MdzHes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jt6jMTf8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jt6jMTf8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AdIIRvwrrP5I0dgJhDbCGSvGJ1iVpExH7iBures8Epk=; 
	b=jt6jMTf8tQSIcCQNhzi7Rdf6sUe4bGYREu8vOyx1XKftpDAWVFhw2ygKqBEo0Xlp9TdYPqMVefY
	LWr5CJiCbGcD2UAs2UtMMRke/61UhKQizlAHiGxVNI6yObEjPUeViCNrw55nDg2a6kCIm0YB6s6m5
	ghZ6FyxBFKBvSNathANEyaBADJVP/oXbj/gsdD9MOfDcNLTXoR4zWJRkS+8etL1hNpnz6SBIV1x44
	cd8d6wHqM3tkJ5lI0fuVxWYXb9AUF9oTxeC14lq9QJWpFnxRgAqiaky49VIULnjrIpsfYQ3UAfDmJ
	UlN4Rm0M+CS3cRQ7vQhmataruYvpgiptAvIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWRGs-00BCzv-1e;
	Fri, 19 Dec 2025 11:35:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 11:35:14 +0800
Date: Fri, 19 Dec 2025 11:35:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeanmichel.hautbois@yoseli.org
Cc: Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v4 1/2] hwrng: imx-rngc: Use optional clock
Message-ID: <aUTH8q5nejrngXck@gondor.apana.org.au>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
 <20251126-b4-m5441x-add-rng-support-v4-1-5309548c9555@yoseli.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-b4-m5441x-add-rng-support-v4-1-5309548c9555@yoseli.org>

On Wed, Nov 26, 2025 at 08:08:09AM +0100, Jean-Michel Hautbois via B4 Relay wrote:
> From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> 
> Change devm_clk_get() to devm_clk_get_optional() to support platforms
> where the RNG clock is always enabled and not exposed via the clock
> framework (such as ColdFire MCF54418).
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> ---
>  drivers/char/hw_random/imx-rngc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
