Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178D538DEC;
	Wed, 24 Sep 2025 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758711628; cv=none; b=nqgxvyLnflfCuiMVTaMAa6XVdQvXzwvPf9924Hj+ENR122eZaFPY5rOlkiITxKvR5UzknaOF4PHas/dn8QgTpyid+1WxLgdwJ4bSP5rBa80uJL2GLvnChr9KpA/T0aK+mnV+OnWEM2ix0Rk+gSsTcs0hJrvFtWC3ml90E7TouBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758711628; c=relaxed/simple;
	bh=7KpDcW/oIVgg5lRaVdhpKQRu1/7ir1rselHbnNp1Mrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PF/OdCTJ08T1bU8aVdp2jmWVB4MlW9n2EV+p5BOUBj2fZ9p0UqwlbvU2QCNLtrr3U+0MnIjBrzf3eVY6xYAsaCBh3ZqrbGamZQcuUyhyUcXNG2/pjWLgOHBj+DybvshbS4e1LHyAPFWDI6S0RLemPPcye2B0dKxhCkcSVths0VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=UoPz72OV; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="UoPz72OV"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cWv5J6QKYz9snt;
	Wed, 24 Sep 2025 13:00:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758711620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dAaz71v8UalAH+2YQiktqvi4SkWlPgPtsfTdejouApE=;
	b=UoPz72OVzwXN9741E8vdeHe/Z4pz8IPwTTj+I919pbeW2xeWwfb1g1TDWKnrCnf+FDUZ0Q
	0SqqbUaqlw0fEHjsi4kFsd6aMiFyPrKHo+REpAYH3Xn+SbfKjPNGcPvN9yzEfkXF3bIwN2
	rtUV6sktnlVtLnZwmnXU/k74XDh6aEh4sIbZ9bo8QlEfWoZJZ5n+PLYZa6eEQet4+MSXGi
	gyeqBc8KxWaCCQlxATdOGnV6zIzYxjef0Uoj74ZeEm57CSY8VbwubqeEbwZMcjgKbtp8kp
	kRJif+30aiupPSQplk3CEunq0jU0nLgUR1DVoYNwyz0tWbgd4sA33Swg45IuUw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of dev@kael-k.io designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=dev@kael-k.io
Date: Wed, 24 Sep 2025 13:00:08 +0200
From: Kael D'Alcamo <dev@kael-k.io>
To: Rob Herring <robh@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT
 schema
Message-ID: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
References: <20250923103900.136621-1-dev@kael-k.io>
 <20250923142943.GA3134901-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923142943.GA3134901-robh@kernel.org>
X-Rspamd-Queue-Id: 4cWv5J6QKYz9snt

On 2025-09-23 09:29:43, Rob Herring wrote:
> On Tue, Sep 23, 2025 at 12:38:22PM +0200, Kael D'Alcamo wrote:
> > Convert the Devicetree binding documentation for:
> > * SUNW,n2-rng
> > * SUNW,vf-rng
> > * SUNW,kt-rng
> > * ORCL,m4-rng
> > * ORCL,m7-rng
> > from plain text to YAML.
> 
> While I welcome any conversions, I wouldn't put Sparc stuff high on 
> priority list as we're not going to run the validation tools on them 
> and we can't change anything in their DTs if we did. My priority is the 
> remaining warnings on arm64 and then active arm32 platforms (e.g. 
> aspeed). We're down to <700 unique warnings on arm64 (from ~10000). 
> 
> There's builds with warnings of Linus' and next trees here:
> 
> https://gitlab.com/robherring/linux-dt/-/jobs
> 
> And some scripts to fetch the warnings here:
> 
> https://gitlab.com/robherring/ci-jobs
> 

Thanks for the feedback, I'll definetly take a look to those warnings in 
order to propose more useful contributions in the future.

Meanwhile, given that I already wrote this DT binding schema, I think it would
be a shame to discard the work already done, even if it's low priority.

> > 
> > Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> > ---
> >  .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 ---------
> >  .../bindings/rng/sparc_sun_oracle_rng.yaml    | 61 +++++++++++++++++++
> 
> SUNW,n2-rng.yaml for the filename.
>
> >  2 files changed, 61 insertions(+), 30 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
> >  create mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
> > deleted file mode 100644
> > index b0b211194c71..000000000000
> > --- a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
> > +++ /dev/null
> > @@ -1,30 +0,0 @@
> > -HWRNG support for the n2_rng driver
> > -
> > -Required properties:
> > -- reg		: base address to sample from
> > -- compatible	: should contain one of the following
> > -	RNG versions:
> > -	- 'SUNW,n2-rng' for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
> > -	- 'SUNW,vf-rng' for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
> > -	- 'SUNW,kt-rng' for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4), (UltraSPARC KT/Niagara 3 - development names)
> > -	more recent systems (after Oracle acquisition of SUN)
> > -	- 'ORCL,m4-rng' for SPARC T5/M5
> > -	- 'ORCL,m7-rng' for SPARC T7/M7
> > -
> > -Examples:
> > -/* linux LDOM on SPARC T5-2 */
> > -Node 0xf029a4f4
> > -	.node:  f029a4f4
> > -	rng-#units:  00000002
> > -	compatible: 'ORCL,m4-rng'
> > -	reg:  0000000e
> > -	name: 'random-number-generator'
> > -
> > -/* solaris on SPARC M7-8 */
> > -Node 0xf028c08c
> > -	rng-#units:  00000003
> > -	compatible: 'ORCL,m7-rng'
> > -	reg:  0000000e
> > -	name:  'random-number-generator'
> > -
> > -PS: see as well prtconfs.git by DaveM
> > diff --git a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
> > new file mode 100644
> > index 000000000000..fea6be544784
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
> > @@ -0,0 +1,61 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/rng/sparc_sun_oracle_rng.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: HWRNG support for the n2_rng driver
> 
> SUN UltraSPARC HWRNG
> 
> > +
> > +maintainers:
> > +  - David S. Miller <davem@davemloft.net>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - SUNW,n2-rng  # for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
> > +      - SUNW,vf-rng  # for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
> > +      # for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4),
> > +      #  (UltraSPARC KT/Niagara 3 - development names)
> > +      #  more recent systems (after Oracle acquisition of SUN)
> > +      - SUNW,kt-rng
> > +      - ORCL,m4-rng  # for SPARC T5/M5
> > +      - ORCL,m7-rng  # for SPARC T7/M7
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  "rng-#units":
> > +    description: Number of RNG units
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    minimum: 1
> 
> This will need an exception in vendor-prefixes.yaml to fix the warning. 
> Looking at some of the Sparc DTs briefly, there's a few more ways '#' 
> shows up.
> 
> I suppose this:
> 
> "^[a-zA-Z0-9#_][a-zA-Z0-9+\\-._@]{0,63}$": true
> 
> needs to be:
> 
> "^[a-zA-Z0-9#_][a-zA-Z0-9#+\\-._@]{0,63}$": true 
> 
> (I think the '@' should be dropped here.)
> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +# PS: see as well prtconfs.git by DaveM
> > +examples:
> > +  - |
> > +    bus {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        rng@e {
> > +            compatible = "ORCL,m4-rng";
> > +            reg = <0xe>;
> > +            rng-#units = <2>;
> > +        };
> > +    };
> > +  - |
> > +    bus {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        rng@e {
> > +            compatible = "ORCL,m7-rng";
> > +            reg = <0xe>;
> > +            rng-#units = <3>;
> > +        };
> > +    };
> 
> I think one example is enough.
> 
> Rob

Kael
