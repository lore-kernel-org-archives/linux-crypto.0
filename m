Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7D18EFED;
	Fri, 30 Aug 2024 10:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014360; cv=none; b=ESN6RQSWJ9W7w+I9aAh/ppprT2kKPrRT2UfnVp+hD3TaB4Zse8ZYJM6gcQWy5OU9YiF6GZP/+9LdmeVlDn5KaMnW+F1J8tggl5Uwb+SQ5HrRS7kZgyoKethpjW3evGt9hnaT+bwsfcu8D5n17ArFn/M6R4DY/hSTR1hv3du5wBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014360; c=relaxed/simple;
	bh=gvppTPOwKOdCSZvyPTB3N1VjeQmkQ/MKSgKPsBNp3wY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViwPZiIEnOhdRLeIn37ovQfc99c2LVnDoGNOgyMpK3Zni0kxJNxngecUqvppyO+NYI/tHiiXQ9nVfe6NoGV8mc7S0JhSAVl1/doMVue1MGYmXrn9WntzpA37389aKs3GzMCb0wRWIc4u+u/PHc8RtzzNTXkEWaqdMapO8meH00Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjytb-008Uqh-2P;
	Fri, 30 Aug 2024 18:39:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:39:08 +0800
Date: Fri, 30 Aug 2024 18:39:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Frank Li <Frank.Li@nxp.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] dt-bindings: crypto: fsl,sec-v4.0: add second
 register space for rtic
Message-ID: <ZtGhTM4cHz2VWCdD@gondor.apana.org.au>
References: <20240821192135.578126-1-Frank.Li@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821192135.578126-1-Frank.Li@nxp.com>

On Wed, Aug 21, 2024 at 03:20:48PM -0400, Frank Li wrote:
> Add two description for register space of rtic. There are two register
> space, one is for control and status, the other optional space is
> recoverable error indication register space.
> 
> Fix below CHECK_DTBS error:
> arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dtb: crypto@1700000: rtic@60000:reg: [[393216, 256], [396800, 24]] is too long
>         from schema $id: http://devicetree.org/schemas/crypto/fsl,sec-v4.0.yaml#
> 
> Signed-off-by: Frank Li <Frank.Li@nxp.com>
> ---
>  Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
