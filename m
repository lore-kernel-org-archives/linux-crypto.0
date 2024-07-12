Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B954E132133;
	Fri, 12 Jul 2024 23:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828594; cv=none; b=SwtVnG38wlJvXaomgVtu7Enmkedlf8znKzmIKn0Ih833fKvESesCp/EwSDourLwgZXrvT0xyy0OAfBDezwX5wVkytJqbp5CHW08xEXA7Hq6dLXs2w0yGysDt/2NTqFO+J2eAU900EYsEtt3ukRTc9evqhWNsV52IMAqO64QUd1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828594; c=relaxed/simple;
	bh=fJmqQadkjuCKEKTMCucxpfaXrsiC+Dv+QQEqQnIBCwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UABXF/ZI0mqJTM7JPpxHNcgRuSImb/sle5TYJqcmb5meEoiX7Qdo0j7LJ23ZGMbc/cyL53t4ZFKMeuFiVfBdtpFeZRw0ckScXEhzFQaxDg1IwL/mxw3k0GUh2kvW4WNZQ3WUXJC/BYIyz2jV4rXuCgTBnHiYz3m4eUO9JhwlC3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sSQ7C-001q3t-1x;
	Sat, 13 Jul 2024 09:55:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Jul 2024 11:55:50 +1200
Date: Sat, 13 Jul 2024 11:55:50 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Gstir <david@sigma-star.at>
Cc: "David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	David Oberhollenzer <david.oberhollenzer@sigma-star.at>,
	Richard Weinberger <richard@nod.at>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	sigma star Kernel Team <upstream+dcp@sigma-star.at>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] crypto: mxs-dcp: Ensure payload is zero when using key
 slot
Message-ID: <ZpHChqeDBhddyY+e@gondor.apana.org.au>
References: <20240703124958.45898-1-david@sigma-star.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703124958.45898-1-david@sigma-star.at>

On Wed, Jul 03, 2024 at 02:49:58PM +0200, David Gstir wrote:
> We could leak stack memory through the payload field when running
> AES with a key from one of the hardware's key slots. Fix this by
> ensuring the payload field is set to 0 in such cases.
> 
> This does not affect the common use case when the key is supplied
> from main memory via the descriptor payload.
> 
> Signed-off-by: David Gstir <david@sigma-star.at>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202405270146.Y9tPoil8-lkp@intel.com/
> Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound keys")
> ---
>  drivers/crypto/mxs-dcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
