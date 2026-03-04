Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A58636C9FA;
	Wed,  4 Mar 2026 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626523; cv=none; b=e1ucGl3w5BOku4wMPGZZhNiOy0I8YtkJOIvuIZ6f+aPzfTlNqY+80pZYVMPo/bhauJqO2jI2X6omDAUOMz3iBdCMUPwuv/OfGGuQuRCMSVV8j2mpN/yJ74STqWBsIEkHeNzrOLIKKqchvlJHM6O1EuaFTsgXkqnhtxkCVCwUXUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626523; c=relaxed/simple;
	bh=QNXVSOW9tFdALkmjVYn4GHOL44CBLZoDEykweptmIyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSE3yWWJrXHwsuaiAWgeUnRu/yX1O1XyCcSmss5T0hXDZMdJcMR95O/XAfSYOCObN1NuUD5/bLwKSPAFPxtos/uvBAg+77RQohy1tukoGN5e+erMXzqWq04S8YT/RaxC9US8npzVZI9IpxYXy0dOot9xQ1nSS7kjWdZw+2vnedA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1vxl84-000000002yZ-1O0K;
	Wed, 04 Mar 2026 12:15:04 +0000
Date: Wed, 4 Mar 2026 12:14:52 +0000
From: Daniel Golle <daniel@makrotopia.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sean Wang <sean.wang@mediatek.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG
 variants
Message-ID: <aagiPIgoosVqsA0t@makrotopia.org>
References: <04622e0bc917aed4145a9a3b50b61f343fc89312.1772585683.git.daniel@makrotopia.org>
 <20260304-defiant-echidna-of-examination-b1e798@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-defiant-echidna-of-examination-b1e798@quoll>

On Wed, Mar 04, 2026 at 12:34:45PM +0100, Krzysztof Kozlowski wrote:
> On Wed, Mar 04, 2026 at 12:55:27AM +0000, Daniel Golle wrote:
> > diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> > index 7e8dc62e5d3a6..6074758552ac3 100644
> > --- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> > +++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> > @@ -11,12 +11,15 @@ maintainers:
> >  
> >  properties:
> >    $nodename:
> > -    pattern: "^rng@[0-9a-f]+$"
> > +    pattern: "^rng(@[0-9a-f]+)?$"
> >  
> >    compatible:
> >      oneOf:
> >        - enum:
> >            - mediatek,mt7623-rng
> > +          - mediatek,mt7981-rng
> > +          - mediatek,mt7987-rng
> > +          - mediatek,mt7988-rng
> 
> Not compatible with each other?

MT7623 is the original hardware first supported in Linux. It can be
accessed via MMIO and requires the clock to be enabled by Linux.

Starting with MT7981 and followed by MT7988 and MT7987 it is
technically the same hardware, but on those ARMv8 SoCs TF-A assigns
the MMIO range of the TRNG to only be accessible from within the
secure/trusted land, and TF-A provides a (vendor-specific) API
allowing non-trusted land (ie. Linux) to acquire random bytes.

With MT7986 they made the unlucky choice to initially allow direct
access to the MMIO range, but later updates to TF-A then also locked
it to secure/trusted land, offering the same API as on the newer SoCs.
So for MT7986 the driver has to try and figure out which convention to
use.


> 
> >        - items:
> >            - enum:
> >                - mediatek,mt7622-rng
> > @@ -38,9 +41,22 @@ properties:
> >  
> >  required:
> >    - compatible
> > -  - reg
> > -  - clocks
> > -  - clock-names
> > +
> > +allOf:
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          not:
> 
> Use rather positive list, so drop "not:" and use cntains for only one
> compatible - mediatek,mt7623-rng.

Ack.

> 
> > +            contains:
> > +              enum:
> > +                - mediatek,mt7981-rng
> > +                - mediatek,mt7987-rng
> > +                - mediatek,mt7988-rng
> > +    then:
> > +      required:
> > +        - reg
> > +        - clocks
> > +        - clock-names
> >  
> >  additionalProperties: false
> >  
> > @@ -53,3 +69,7 @@ examples:
> >              clocks = <&infracfg CLK_INFRA_TRNG>;
> >              clock-names = "rng";
> >      };
> > +  - |
> > +    rng {
> > +            compatible = "mediatek,mt7981-rng";
> 
> Use four spaces for indentation.

Oh sorry, I knew that actually but forgot...

