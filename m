Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB3923F36D;
	Sun,  2 Mar 2025 08:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903162; cv=none; b=lDOHse8v9pNZSCUfEuFIpIlwUX4yEIn14nEpvxv3hBRTfZXwz02D2h5kNoreSvkgOmm9vzxKT87DkYaVlauqWrJXQoK4TfbZi1gShlcwyeuCOI2bwKSdY5eBjNRb8//VTNKlyTTrHtpI2QO8eGmrajbXq1cLAn+xj2TU+Ac8P2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903162; c=relaxed/simple;
	bh=JVMN9SnHc2Bh4n7rxszMF/zv7SdvkIWwDtI57GPBi/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyyT3M77RUohpMlq7RJfDm+uurOfTgcANbSH4ajTr9O93bD9Ddp5FIYQvg7r1HfH9tQCL/J/1RRsHgJ3UUH0V86V31mkCMvwBYVNStNhFnnf4NiEkaRX8mZcinYjom21W/95FUCeQ8vfCUeTXOhrTMJYDlrUBWmDv1zCTDdMGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=k666dQ92; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="k666dQ92"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7qMmZYizc3miIZb89w4GXGO4sF77UiknNsywOJwqe6Y=; b=k666dQ92vTCUEEUcPJGbtkPqeq
	hQTAS6a989l9kh33zrLB1lw7MPxBNFBMxK98nH1ICAllQfciNYMDkeaJorYohRghTTH0UgW4lZSGO
	PU4Cf9IoDpbstKZAF1ibrx+hV+L3leEM4JjvTLm73xOYPEFSOhwnFUCbCXI0YvYNqvHL6wD/f9yWv
	ijzRBfSnjvr/XNCfanAOqwSNILDZ11eBFm/N4RTx50hbHzwaN3Yu9WWP7WfxEohn0g33neocFE5fL
	qRunDvDRP9BiaO/9iZo7aBT91pECgXo5Z09hjdj0oe9vLhle5VlL8E8yKHNv+pSm+AUKGg4UFbuoC
	B9MtYcdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toeQy-0030qv-2i;
	Sun, 02 Mar 2025 16:12:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 16:12:24 +0800
Date: Sun, 2 Mar 2025 16:12:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: j.ne@posteo.net
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.li@nxp.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: crypto: Convert fsl,sec-2.0 to YAML
Message-ID: <Z8QS6F-cqktz4dYS@gondor.apana.org.au>
References: <20250220-ppcyaml-crypto-v3-1-99eedece4821@posteo.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250220-ppcyaml-crypto-v3-1-99eedece4821@posteo.net>

On Thu, Feb 20, 2025 at 12:57:35PM +0100, J. Neuschäfer via B4 Relay wrote:
> From: "J. Neuschäfer" <j.ne@posteo.net>
> 
> Convert the Freescale security engine (crypto accelerator) binding from
> text form to YAML. The list of compatible strings reflects what was
> previously described in prose; not all combinations occur in existing
> devicetrees.
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Signed-off-by: J. Neuschäfer <j.ne@posteo.net>
> ---
> V3:
> - split out as a single patch
> - Add Frank Li's R-b tag
> - fix typo in email address syntax
> - normalize spelling of "descriptor type", and reformat the description
>   of fsl,descriptor-types-mask for readability
> - add missing end-of-document marker (...)
> 
> V2:
> - part of series [PATCH v2 00/12] YAML conversion of several Freescale/PowerPC DT bindings
>   Link: https://lore.kernel.org/lkml/20250207-ppcyaml-v2-3-8137b0c42526@posteo.net/
> - several improvements suggested by Rob Herring:
>   - remove unnecessary multiline markers
>   - constrain fsl,num-channels to enum: [1,4]
>   - constrain fsl,channel-fifo-len to plausible limits
>   - constrain fsl,exec-units-mask to maximum=0xfff
> - trim subject line (remove "binding")
> ---
>  .../devicetree/bindings/crypto/fsl,sec2.0.yaml     | 144 +++++++++++++++++++++
>  .../devicetree/bindings/crypto/fsl-sec2.txt        |  65 ----------
>  2 files changed, 144 insertions(+), 65 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
