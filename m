Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EFC1527BB;
	Fri, 21 Jun 2024 12:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973275; cv=none; b=PwPglADWF8KH4mnWJZgAxL9Oz9RPvXeayJFl/9An0LwjEX2AGEEzWQ5wvNVxtuDG8mgNlzUGEKauaM3GBjP8u1OUy2D/knegZjMnGsxM0XyLFqg6nK9wBlAsVTdj1/fJ5z9Nd1Z3OnRxjb1sqkRfvSBsOnbcnroZril6Y3HCdKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973275; c=relaxed/simple;
	bh=vUVvNctaPVLLYkhaC2RkdX9sgZkPkbhRqFGtCGGVTL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbrKaCWEV+PD0nzU/VrYNlKjJgDeEv6+7IJRCFeQlU2a6W5gyhtzdz1LUazRBxx0c1ke1ogmyaBLeNolr5hwOIGsVR0bPLTCTX2ZlpQ1FrEVHsJio02O4iAydtaWn4IxwA+HYvb4wjuFPM9CiTkzwp34mfuecYRd5ZHtiiQHZ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdSu-002enm-2W;
	Fri, 21 Jun 2024 22:34:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:34:05 +1000
Date: Fri, 21 Jun 2024 22:34:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: arm/poly1305 - add missing MODULE_DESCRIPTION()
 macro
Message-ID: <ZnVzPV295Zcs0Npk@gondor.apana.org.au>
References: <20240613-md-arm-arch-arm-crypto-v1-1-0ff745c4220a@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613-md-arm-arch-arm-crypto-v1-1-0ff745c4220a@quicinc.com>

On Thu, Jun 13, 2024 at 05:57:05PM -0700, Jeff Johnson wrote:
> With ARCH=arm, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/crypto/poly1305-arm.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/arm/crypto/poly1305-glue.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
