Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FC223505D;
	Mon, 23 Jun 2025 09:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670344; cv=none; b=Yp4sPo7V/iJA8Oi5ZPY8tT25Y/Sg5azT1ZJqsQChj+vOERlE9gGctzPE2/ML3AnSSkNv+Q5/T/LgJs1WX1dghSPyWYGARUM6TZm8nZs8qhgujylH/uqpDsXvBaZUxyRKP44cn/8WsGCMsCyuFLFOwAbvuGwQMSxY8ZIQNRC42UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670344; c=relaxed/simple;
	bh=xbzYjdtuD/OKOGQNFyCz9+V4qKRWhge8UyXyAQvWu0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnBe8jSVKZSJew4M3utV0EvOZ1VE72VX21BoI49V3mbyoJd91FAIfMIrfk4mzJVmJquQuFhLAjtuSd/vhiUt+HG04b16rjjjkJ+x1xvcumDSuseZl7lyNJ1/gFC2/tBIIQmDsqJukxigeiwUWVH6NzNfBA+pd7KlmlPP179bPEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SqEZAOmQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SqEZAOmQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rxZCp3EGJypSphPcK6o/bK8NHaaE3nPOVh4GCXjG9hA=; b=SqEZAOmQ7xFe7pQ0Jhm51CfXlO
	JYvNGzRjsYf1bPg2vIjh0iJiEgB09NcethdheoeDLfEXDlUlVKY1Fg0pZGb0PjYN2IbxCroXQat36
	3DLbEDG2FTqPURS6rJJUPTptAFBLrUK0hVXfX1OdE2RSGLc+kqLh7zhMC/mqB0dYjtb5u7NJ7Yz8N
	6DJRsMdxOYzY8ENtBIVeYmRBYxnErb5SomqAifp3GReaRpjyKp6crl5G2tufCxsG4OWuMfSE3f7Tq
	2yLCNnZbEJjrTH/tPvtKd5ZGh0w6h0S1ZlC0T0rDX9tp/uCD2dInsHFI9akrJMjJzhyFynLDh/X5/
	f6Wv+s4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd4c-000FVb-1b;
	Mon, 23 Jun 2025 17:18:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:18:38 +0800
Date: Mon, 23 Jun 2025 17:18:38 +0800
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
Subject: Re: [PATCH v2] dt-bindings: crypto: Convert ti,omap2-aes to DT schema
Message-ID: <aFkb7s6GPLZtG7Gh@gondor.apana.org.au>
References: <20250611231047.1400566-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611231047.1400566-1-robh@kernel.org>

On Wed, Jun 11, 2025 at 06:10:45PM -0500, Rob Herring (Arm) wrote:
> Convert the TI OMAP AES binding to DT schema format. It's a straight
> forward conversion.
> 
> Make "ti,hwmods" not required as it is deprecated and only used on
> OMAP2.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v2:
>  - Drop ti,hwmods from required
>  - Fix filename to be omap2, not omap4.
> ---
>  .../devicetree/bindings/crypto/omap-aes.txt   | 31 ----------
>  .../bindings/crypto/ti,omap2-aes.yaml         | 58 +++++++++++++++++++
>  2 files changed, 58 insertions(+), 31 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
