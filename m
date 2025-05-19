Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E93D1FF1C7;
	Mon, 19 May 2025 05:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634396; cv=none; b=kh+Rj3wSad1OX5uDQtboL1wPcuVWEIS5Ah3Aks8GLzusjFkhA2Wu4a52O2otEkKVi6/mBcHaAjY4wYwEIBWScCzZzKHAC/Ibi/aLpawbBMHBDLGakb3JoRaVLYStLchVMh3GEUM3fYtxPAkZbTSx+N4LIe0VgXD7jk1HYowG/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634396; c=relaxed/simple;
	bh=hwk+WXLDlI0gwPgrUqdcrTrDLn5JrX6R0bsBP15p0js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0ps5BGvT/za2HzGkEVf6X0HYcAHrMrfjxlJ9ZMNqdR84F/R41YUv6eYpBHa2DBkjx7QnpWAX8yHSycN8ZskwUxr8lc6kc5PjI5A9pBwjVScrMNbrNwbzf4ZWIK++p8SK2caMianYltPEIzX01WqhMUkulLDahVaQww3KaxxTGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GKSvAuUs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GKSvAuUs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kAWEcO4awV6kIY0dr42p51DK4Sqc6uGcjJkr+bEWxFI=; b=GKSvAuUscc5o8fpxbwUIeqqMIp
	5Zro4eV3eNM4oiMWCdS3fyBHXmXU6xNFCVo96Obu/k/bYnAS/HEIATiMJGF8LSsNGbRv/TBgc+DWe
	feugKfmFwYRTe/4h2zjm4LXwuxH3iCILTNSvRCVoNF66MXSaNpi5+XIxI9ABAdXwuUIRi5Ivw4hii
	VRzsk3bf2KfCovmnaI4fknpYwk/0bVTngi5+A7kD6N6UHaBBPafYYLll39Fuuor/ESPqfYDBWxZao
	7G6LJXfmrrt7PVHLan8siI2MnMMZsotuog4k674fTaKGDeCVxXQssLylRmvZKlEa8V39fHIqLr2VT
	xlEVCn3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtXP-00783n-0g;
	Mon, 19 May 2025 13:59:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 13:59:47 +0800
Date: Mon, 19 May 2025 13:59:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Convert amd,ccp-seattle-v1a to DT
 schema
Message-ID: <aCrI08x_IZzPt-M6@gondor.apana.org.au>
References: <20250513184051.3051660-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184051.3051660-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:40:50PM -0500, Rob Herring (Arm) wrote:
> Convert the AMD Cryptographic Coprocessor binding to DT schema format.
> It's a straight forward conversion.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/amd,ccp-seattle-v1a.yaml  | 38 +++++++++++++++++++
>  .../devicetree/bindings/crypto/amd-ccp.txt    | 17 ---------
>  2 files changed, 38 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/amd-ccp.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
