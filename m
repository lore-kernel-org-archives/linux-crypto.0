Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D6A18FC65;
	Sat, 19 Oct 2024 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729339069; cv=none; b=sIFccwfCe+zRCYilyI8S37cZxYaCjhf9ltet4/LqkSPqaRsaMwE4CTjEX1MSp0IKJY1n1hfKapvsvck9JGeROZjW+0JTKe/yO+na6bu7LdUeankdzRQ83Go9Paw4l0yx+HcEBnj92VEU2J/w0IATbnFfF51znd444cRcv71U7NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729339069; c=relaxed/simple;
	bh=iETj25H7QVa4F6/0psIuMJnovR1bRZh8hICT1EDnBzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIUFf6C5wTMI+bmX+1cd9S5sc6EWECPb2dJKjmz+sqi/45ksSgea9G2lPGFV7f1e/n3I3KtEG7jBTlxpJ8nHHWqxy11tDmlPFMmn6hV2pqZyJrV4A8+VHV+xh1HAoKyGYLbwQSEqU5Bu+BdOaavxXSHWsWQPrW2dVNW6Xy1ahEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aV2e8Q/G; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aV2e8Q/G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FMti5Vvdcxs1CnJI7hqh/vDh9drywIZdRBi00//GNss=; b=aV2e8Q/GX0SzCvwmOaEo5LaR7X
	7jEXld+vIKqFWNs8qaH9vMo9QEVrZu/wxrRc09GnjTLGy/mMFX4HCXtGx9kx+mByM7Rbad3KIJt6F
	eY1mvSFymbgdkyTO9zYacoTDdN+72aFj4n0Ck809nYlrPJOcJvkHnGxMmamDhyHkfGHuADl9/eZHO
	DZPWNiszp8nWTjyexl/khC0TQzl0yOtct47q8HdGIOeCVPCKRzR/vM2LmYDtIsk8UHi1a8pZnwXEu
	RKOfFSAKBRwC++yjkmAqSc7Kqm/bHjO2Ld5Tv/XrYTQVDSJ+h9f2m49p0buNxRBo1h4dO7qCirwco
	zkD4eyaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t285S-00AaOn-26;
	Sat, 19 Oct 2024 19:57:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Oct 2024 19:57:38 +0800
Date: Sat, 19 Oct 2024 19:57:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: olivia@selenic.com, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH] dt-bindings: imx-rng: Allow passing only "fsl,imx31-rnga"
Message-ID: <ZxOesppT4RxLI8-L@gondor.apana.org.au>
References: <20241009125144.560941-1-festevam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009125144.560941-1-festevam@gmail.com>

On Wed, Oct 09, 2024 at 09:51:44AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> On imx31.dtsi the rng compatible string contains "fsl,imx31-rnga" only.
> 
> Adjust the binding to accept passing "fsl,imx31-rnga" only.
> 
> This fixes the following dt-schema warning:
> 
> imx31-lite.dtb: rng@53fb0000: compatible: 'oneOf' conditional failed, one must be fixed:
> 	['fsl,imx31-rnga'] is too short
> 	'fsl,imx21-rnga' was expected
> 	'fsl,imx25-rngb' was expected
> 	'fsl,imx31-rnga' is not one of ['fsl,imx6sl-rngb', 'fsl,imx6sll-rngb', 'fsl,imx6ull-rngb']
> 	'fsl,imx35-rngc' was expected
> 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
>  Documentation/devicetree/bindings/rng/imx-rng.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
