Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD9050AC27;
	Thu, 15 Oct 2026 09:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792057286; cv=none; b=AezCtWMuZqDpdza1q+VXv20lfH2BzjVwYOQZS0rhrEX0YkTY/1ZGzM5JPBAGeE3H/+qBbp3VsutOBbfKKZAaPNtaxE6sdinRu1dy5R9j6AP7f8NRWBHtUgkIfVhYi6zJ2WYy901R1sRnkPh8uBfLGIFLG3ORUQh2wbUT154nyQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792057286; c=relaxed/simple;
	bh=auBgT54f76xLHPsbAf5D64XC3Y7tMTvc8isupb3BnWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYL876Cts1HBJm+Hh83xBa75QwjQt6t7fUkd6tM990j2KOC3WKNmIljjVddJMRxHwRKrDFFmaGd7fWjXXJF6YRPSiCVWCMwa24No3KmZKC27toYybjt9r/0THdhisl4L4pQndc1/xKbrtI/+bMzyakj6Y7B81hxDFCL4Gmwyyds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AayoWzIl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AayoWzIl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=n/dObaMkUWm5pUqDYuOvXJ2uzV/iakL+4bYfynFPMTA=; 
	b=AayoWzIl507yCoEfvjqfTQoiWeTVGYboAIKqziCOjo9+D1pJH3shHm2jQuig9q+R8AdT/5yHe2f
	qNVO626Q6NxguYxuu70Ckd0KoTflmJ5AMRYgBTA/3/zdOhMjD72rWq5b6pVmnBLeXfMKFCRkCNpZU
	qPNKcNcJBXHRb5Zhlyh1+ECXrFUGZtsOCl0uFZR9VBHdUrYZG445G0CZ9WK0A9ApyiL4EvdYFCcQC
	ohSUk86lI9xyB9lW+d+zPZq9mYDdFAoTfwr8CHpiyqh6Kr2itvVJzRQJo2ClqhSRdV/uSa1WIY+dE
	n450QdfRBPr4zy6msj5Pkig6LKYvBK6kJ60g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHHx4-000000047Y7-2R5o;
	Thu, 15 Oct 2026 17:40:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:40:42 +1100
Date: Thu, 15 Oct 2026 20:40:42 +1100
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
Message-ID: <atCfmsPr85oAnsJT@gondor.apana.org.au>
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
