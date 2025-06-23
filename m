Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59730230268;
	Mon, 23 Jun 2025 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670357; cv=none; b=El2yK/j00M+lD7TcIl2NoMFQX8DM1vvTzkQCfftXHlv1UX9S3GMrt7Mw/vRcGmZrHZohD9HS+0k6YzN0OAUzYj88KXTA/Jo2T9CdTZPv61ZGYOC7pj/Cl4bxvMTRWUtW/jEdNe36yI+uobNqLO4TTTvjndDt4sx9fdY5qfyFgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670357; c=relaxed/simple;
	bh=iVDRMFNyyOaeuh0O8NZIAI0SrcEqrmUX+dDEHxH0bzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sEqqZS3uXtVO0lYlRyJNiQX0UAUtP65Pz/cUxAAxgyQf71yFoBZmjCn73X3an/9d0DFYTXx1m1pxUEvl16SEmsMcQ4GyaE8KtvgI0uadQYNBzroztCR6UgZ/nK0YFXmr4zAJr1LH4D9d1CiWN0qMSHIwFJ5LkcqzXDg5sG80/Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=E1i3Ns8k; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="E1i3Ns8k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bzMURKHPban+j1X0TdgsCnuN5g+URC5tbPeVxIYUnZ8=; b=E1i3Ns8kvYu5WMznVRUOCP5tDd
	fLgvaTAxfaZHPHrgxjsKQEXpo8MWsU0aMa5DGefLD3ZXFZdOOoPat50rYRaCSnrhtTXc/KXT0sK2o
	SOKXb9R79lKMGOsMLWP9sCK1216V6MXrwScjs8HcZ3Rp8t3nmQ6bdSryd0+M03F5j5JOoTTpixpRa
	xrPsBodzEUCOBFEVTrGvjWn+BweJWoNF1tSB78r6wpuEOxTSBZY+/fj7JETUDifj2c1d2pTGSVoc4
	dcRYNfcswOeBjcxMsPx3TterzV2vdkfyTOX3ZTVng1f82pBCs4xSnTBkbINH8KZ/XZ9mzHyNXzXiC
	6DYU4kXw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd4t-000FWY-0L;
	Mon, 23 Jun 2025 17:18:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:18:55 +0800
Date: Mon, 23 Jun 2025 17:18:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: Convert ti,omap4-des to DT schema
Message-ID: <aFkb_7Qc667EzzDB@gondor.apana.org.au>
References: <20250611231058.1402457-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611231058.1402457-1-robh@kernel.org>

On Wed, Jun 11, 2025 at 06:10:56PM -0500, Rob Herring (Arm) wrote:
> Convert the TI OMAP DES binding to DT schema format.
> 
> Drop "ti,hwmods" as it is not actually used for this binding. Only
> OMAP2 platforms are using it.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v2:
>  - Drop ti,hwmods from required too
> ---
>  .../devicetree/bindings/crypto/omap-des.txt   | 30 ---------
>  .../bindings/crypto/ti,omap4-des.yaml         | 65 +++++++++++++++++++
>  2 files changed, 65 insertions(+), 30 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
