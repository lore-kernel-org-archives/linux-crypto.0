Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7E53E3DAB;
	Thu,  2 Apr 2026 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775133852; cv=none; b=g5O8MqP6IgV3JYSGzJzKDlFMVR+AlMsCBHOm3Xc0wBDeQ9OruPk0nYMkuj06WCMgCLHl3U0t6oD5ZXaAoqDutXsvmxJ5+YtsIT8Mt8uOozWKSq/AuqW3eNwTl7/VVszFSppWf9CGRSjeGZ9ccFY+5WX6Nr/8CWdm57X66n/qxqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775133852; c=relaxed/simple;
	bh=fxj56lluS0uKTzYojwNmJa9pafLEkTEI4H7SzhdcBic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnTa5RxlSUxiQCftuIeIr3AyfC64shXuXSMyXbQkSzAEWuNNVEZxk8/RXvBrcSk7WBTGaKVJA35LghVGigwMmaH1GkZkSXKodkpmlZRWyrQKnqmYLT8XZSjKIBajrHcEvYIDEQBfEUgJKr0f1bn1+LxSvBP/hutPf2m1kF4nsNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1w8HOm-000000004C2-42Qe;
	Thu, 02 Apr 2026 12:43:49 +0000
Date: Thu, 2 Apr 2026 13:43:45 +0100
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
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: mtk-rng: add SMC-based TRNG
 variants
Message-ID: <ac5kgYh6Jbv4SSz4@makrotopia.org>
References: <0a951e34b7030e514091d6c0922c5982ae349221.1775090165.git.daniel@makrotopia.org>
 <20260402-towering-transparent-malamute-1e44b8@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402-towering-transparent-malamute-1e44b8@quoll>

On Thu, Apr 02, 2026 at 09:57:59AM +0200, Krzysztof Kozlowski wrote:
> On Thu, Apr 02, 2026 at 01:37:02AM +0100, Daniel Golle wrote:
> > Add compatible strings for MediaTek SoCs where the hardware random number
> > generator is accessed via a vendor-defined Secure Monitor Call (SMC)
> > rather than direct MMIO register access:
> > 
> >   - mediatek,mt7981-rng
> >   - mediatek,mt7987-rng
> >   - mediatek,mt7988-rng
> > 
> > These variants require no reg, clocks, or clock-names properties since
> > the RNG hardware is managed by ARM Trusted Firmware-A.
> > 
> > Relax the $nodename pattern to also allow 'rng' in addition to the
> > existing 'rng@...' pattern.
> > 
> > Add a second example showing the minimal SMC variant binding.
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> > v2: express compatibilities with fallback
> > 
> >  .../devicetree/bindings/rng/mtk-rng.yaml      | 28 ++++++++++++++++---
> >  1 file changed, 24 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> > index 7e8dc62e5d3a6..34648b53d14c6 100644
> > --- a/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> > +++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> > @@ -11,12 +11,13 @@ maintainers:
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
> >        - items:
> >            - enum:
> >                - mediatek,mt7622-rng
> > @@ -25,6 +26,11 @@ properties:
> >                - mediatek,mt8365-rng
> >                - mediatek,mt8516-rng
> >            - const: mediatek,mt7623-rng
> > +      - items:
> > +          - enum:
> > +              - mediatek,mt7987-rng
> > +              - mediatek,mt7988-rng
> > +          - const: mediatek,mt7981-rng
> >  
> >    reg:
> >      maxItems: 1
> > @@ -38,9 +44,19 @@ properties:
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
> As requested last time - drop
> 
> > +            contains:
> > +              const: mediatek,mt7981-rng
> > +    then:
> 
> missing constraints for mediatek,mt7981-rng. So does it have IO space
> and clocks or not?

The firmware variant which has the RNG under the control of TF-A and
requires Linux to use SMC to access it implies that Linux should not
touch the clk and cannot access the IO space (which is accessible from
secure-land only in this case).

Do you think something like the hunk below would properly express that?

@@ -38,9 +44,23 @@ properties:
 
 required:
   - compatible
-  - reg
-  - clocks
-  - clock-names
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7981-rng
+    then:
+      properties:
+        reg: false
+        clocks: false
+        clock-names: false
+    else:
+      required:
+        - reg
+        - clocks
+        - clock-names
 
 additionalProperties: false
 

> 
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
> No improvements.
> 
> Also, make the example complete since binding claims you have clocks and
> reg.

So clocks and reg have to be prohibited, not just allowed to be absent,
right?

> 
> I am not sure it should be even same file, but if you are making it same
> file, then make it correct.

It's the same hardware. In case of the MT7986 SoC MediaTek has even switched
from requiring the mediatek,mt7623-rng driver implementation to have the TRNG
controlled by TF-A in newer firmware, see driver implementation
auto-detecting this as a work-around...
