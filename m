Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E634085D;
	Sat,  5 Oct 2024 05:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106324; cv=none; b=V9LhhOTdZus2c1Q29SX8N2VJ4ovvcywWnW8GgMwc2TWKzAhp/Bkfm2sFUap92RRsopU1YDE+YOGJr2wVN1sZTn4YtxFcVLPVqG5NTVD3a9pXTvbQC9dfSSn6tlnOg4R5S70mMAkYyGYueTnXTOlHSwWEtZZOEbxKIV7Vwp5/etU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106324; c=relaxed/simple;
	bh=/NjnvWP50ak7RDdpDyrL7mk1KcXJcGuksMwjQx3L6F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRbFrcRaskw7loAVCY7xrPMnO7TnGngbBbaFLpSPMptba54NeunMILt4ZHpQF3MI+Y+OcUXF+jQ3kCtGqFVczW/JQ26OybDnuD14ePTqYJSx2AjXlqbaVg4CwE5x5fTUakiIrQyPMb0SmcABEp3HggJq2vhZcZsvshqRjA44FCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DwCol7qg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DwCol7qg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BdxwkcWtARqhLRBb5Hx4g5CZ23Wm0CyPyT25I6IwC5U=; b=DwCol7qgV3Jt7pG6LmZOEyAsUV
	QNYiFD28ZRSKO6VnBGIhb9P1oz3zOfWULovELtWMY8PYRn3AA4cl5mIoNhJS8yf75xGNLIhg/Xmmi
	u1/Rt5AT+sGqITDyS1Hk6HAJxKK7NP+iGZE0o7QgHmR30mwlyiHwIwZg6GCB2112O2delMkaaggn9
	30I0ffjDnA9lICFz24VloayI9szX+VvKV+bT7gUHin2eP6rPCeDAC6JvYt5FVPSGOQajsOstIFTZO
	z52O4U3oXOvVduENZipfoANL/p8mlIuuQPAJofy7mNRp1j1XJ3652G0IZT5bI2iPaABMcRf6lVKsH
	EmDeAQPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxEX-0071W9-17;
	Sat, 05 Oct 2024 13:31:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:31:50 +0800
Date: Sat, 5 Oct 2024 13:31:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: caam: Fix the pointer passed to
 caam_qi_shutdown()
Message-ID: <ZwDPRsqCIphpCiHP@gondor.apana.org.au>
References: <c76ff86fe3ec40776646f4e5ebd5f0900ca48b37.1726395689.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76ff86fe3ec40776646f4e5ebd5f0900ca48b37.1726395689.git.christophe.jaillet@wanadoo.fr>

On Sun, Sep 15, 2024 at 12:22:12PM +0200, Christophe JAILLET wrote:
> The type of the last parameter given to devm_add_action_or_reset() is
> "struct caam_drv_private *", but in caam_qi_shutdown(), it is casted to
> "struct device *".
> 
> Pass the correct parameter to devm_add_action_or_reset() so that the
> resources are released as expected.
> 
> Fixes: f414de2e2fff ("crypto: caam - use devres to de-initialize QI")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is speculative review with care.
> ---
>  drivers/crypto/caam/qi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
