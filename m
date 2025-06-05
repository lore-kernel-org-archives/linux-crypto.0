Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2733062;
	Thu,  5 Jun 2025 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145581; cv=none; b=LQ+t0wUySJd5eQpxxr+a3VgIyKhWrFcQrwLHbr/SkXgFT+4LPtEMVjPYpG7KeK+/Hk9SYrzPTXUZtzyjMPm7mV7Z4BXziDopMiAacwqAd80RHOnNcVjdAjkNXPn70Sk+D90jFiC5x1wszbOOqO7+QcLYQnelOd8AlRsGk8lnMQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145581; c=relaxed/simple;
	bh=FyoxRjw/jNoDELKF6bzD0gN0GCX6ZoZdESDsckJJuWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzAE+8JejWbNZFyBlPXUOPbs7atpYHNPCEEbTSUbG78/GpSUULyaQ3hlEAIB3Ulxt8zVZuk3VjiRQBPHjf5Wr0WqsCrMiTMu3ZtDRyZqF/PYG3BKNbz+SNPwhnzvgMoY8We6+ujspnadupcHsycjiO9HvBb1vc5cww43M/fbMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6AjniNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6AjniNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1861EC4CEE7;
	Thu,  5 Jun 2025 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749145576;
	bh=FyoxRjw/jNoDELKF6bzD0gN0GCX6ZoZdESDsckJJuWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T6AjniNOpUoLEFiHTqBAX2t2EtU7bdq/X4latsYT8OwQIlcSwFHSWgOEG+3DAhylO
	 7e9DGRqhGAra2t3KeBIBnW3TEvldcW5hwyZ/OSEF+3ibV03KMS7309sF9ZVRQ1Mv6b
	 fr28QLUoLIKH6fQn63ExmB/edBUmcF+KkI1MVUm3JBz4+aievMLFGNgC2RwAUDLuEd
	 El2kWRm8nfWeQxz+Ax+x0qtYudytgk9yyLbx+HSbw17hUWBSPrQQGI0FmzvgmWoO/n
	 OeWqSoFtJcNcYO1WaaoS9AVXySdtzbB1nBU+nYE7s5+2IxM6LFx1Q4iE5BmIVvXvfg
	 TRzN8Qn4cCheQ==
Date: Thu, 5 Jun 2025 12:46:14 -0500
From: Rob Herring <robh@kernel.org>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Frank Li <Frank.li@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Message-ID: <20250605174614.GA2913631-robh@kernel.org>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
 <20250605132754.1771368-4-john.ernberg@actia.se>
 <2bfe7b81-b70e-4882-b1ce-8cbaef24838f@actia.se>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bfe7b81-b70e-4882-b1ce-8cbaef24838f@actia.se>

On Thu, Jun 05, 2025 at 01:32:09PM +0000, John Ernberg wrote:
> Hi,
> 
> On 6/5/25 3:28 PM, John Ernberg wrote:
> > NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> > resource management.
> > 
> > Add compatible strings for these SoCs (QXP and DXP gets to share as their
> > only difference is a core-count, Q=Quad core and D=Dual core), and allow
> > power-domains for them only. Keep the old restriction for others.
> > 
> > Signed-off-by: John Ernberg <john.ernberg@actia.se>
> > 
> > ---
> > 
> > v4:
> >   - Reword commit message (Frank Li)
> >   - Add explicit imx8qxp compatible (Frank Li)
> >   - Move the job-ring constraints back to the job-ring section under an
> >     'allOf:' to avoid the warning from v2 (Rob Herring)
> > 
> > v3:
> >   - Fix warnings discovered by Rob Herring's bot
> >   - Declare the compatibles correctly (Krzysztof Kozlowski)
> > 
> > v2:
> >   - Adjust commit message (Frank Li)
> >   - Only allow power-domains when compatible with imx8qm (Frank Li)
> > ---
> >   .../bindings/crypto/fsl,sec-v4.0.yaml         | 41 ++++++++++++++++++-
> >   1 file changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > index 75afa441e019..eab43e7a354c 100644
> > --- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > @@ -46,6 +46,8 @@ properties:
> >         - items:
> >             - enum:
> >                 - fsl,imx6ul-caam
> > +              - fsl,imx8qm-caam
> > +              - fsl,imx8qxp-caam
> >                 - fsl,sec-v5.0
> >             - const: fsl,sec-v4.0
> >         - const: fsl,sec-v4.0
> > @@ -77,6 +79,9 @@ properties:
> >     interrupts:
> >       maxItems: 1
> >   
> > +  power-domains:
> > +    maxItems: 1
> > +
> >     fsl,sec-era:
> >       description: Defines the 'ERA' of the SEC device.
> >       $ref: /schemas/types.yaml#/definitions/uint32
> > @@ -106,7 +111,10 @@ patternProperties:
> >                 - const: fsl,sec-v5.0-job-ring
> >                 - const: fsl,sec-v4.0-job-ring
> >             - items:
> > -              - const: fsl,sec-v5.0-job-ring
> > +              - enum:
> > +                - fsl,imx8qm-job-ring
> > +                - fsl,imx8qxp-job-ring
> > +                - fsl,sec-v5.0-job-ring
> >                 - const: fsl,sec-v4.0-job-ring
> >             - const: fsl,sec-v4.0-job-ring
> >   
> > @@ -116,6 +124,9 @@ patternProperties:
> >         interrupts:
> >           maxItems: 1
> >   
> > +      power-domains:
> > +        maxItems: 1
> > +
> >         fsl,liodn:
> >           description:
> >             Specifies the LIODN to be used in conjunction with the ppid-to-liodn
> > @@ -125,6 +136,20 @@ patternProperties:
> >           $ref: /schemas/types.yaml#/definitions/uint32-array
> >           items:
> >             - maximum: 0xfff
> > +    allOf:
> > +      - if:
> > +          properties:
> > +            compatible:
> > +              contains:
> > +                enum:
> > +                  - fsl,imx8qm-job-ring
> > +                  - fsl,imx8qxp-job-ring
> > +        then:
> > +          required:
> > +            - power-domains
> > +        else:
> > +          properties:
> > +            power-domains: false
> 
> To dodge the allOf here I had to make some changes to dt-schema 
> nodes.yaml. Is the allOf OK or does the changes look like something that 
> should be submitted formally?

It's okay, but please send the change below either to devicetree-spec 
list or as a GH PR.

Rob

> 
> Thanks! // John Ernberg
> 
> ------------------>8------------------
> 
>  From 39e3c85e53ab570fdd5d5a93156a8a486ef20f0c Mon Sep 17 00:00:00 2001
> From: John Ernberg <john.ernberg@actia.se>
> Date: Wed, 4 Jun 2025 15:12:55 +0200
> Subject: [PATCH] schemas: nodes: Allow if-then-else in patternProperties
>   objects
> 
> Having local if-then-else statements under e.g. a patternProperties object
> node causes a schema warning about an unexpected statement.
> 
> Allow this construct to reduce size of if-then-else blocks that would
> otherwise need to occur at the top level, making them easier to read,
> and more localized to what they are controlling.
> 
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> ---
>   dtschema/meta-schemas/nodes.yaml | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/dtschema/meta-schemas/nodes.yaml 
> b/dtschema/meta-schemas/nodes.yaml
> index 0b2c8f7..e45cb45 100644
> --- a/dtschema/meta-schemas/nodes.yaml
> +++ b/dtschema/meta-schemas/nodes.yaml
> @@ -27,6 +27,9 @@ propertyNames:
>       - deprecated
>       - required
>       - not
> +    - if
> +    - else
> +    - then
>       - allOf
>       - anyOf
>       - oneOf
> 
> 
