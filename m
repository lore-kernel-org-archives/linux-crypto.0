Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815A01CEEA8;
	Fri,  1 Nov 2024 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488351; cv=none; b=gZph1tYw3FwIbPZeG165k1/2hCdPg4DHqAIQ7RdQPIvZauRXdxGm6DM10bVLMbuN8ZMcZb3DjPd2vQpdyLtazYcAb5aPWwBF+h9uWrhN6bb39/3mT1IC+CtlQFTAw2K7Luvs5GNHtqnFICnr0bCSjbFKZi6cHRoePfd0CKTQd08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488351; c=relaxed/simple;
	bh=uDz0+rrdKUxN7l++C1yclZv0bkKrRBTyhR8EgMvYQjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBUE48tS84gLNj2FO2AvlN4PfIMmiaggVkJxfcAmlvyE/wPrwqzm1uMoKWII8pZBM/VZp0A/ktRegkf0i1n0cK5o/t0IJieK+3PvayEK2U8V8AA5JPLhFM69/GX59P7JKVGqnSs2pe2mFOZVKxOlasse0lePl0Jn0BatKW3QBTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pt06Jk4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pt06Jk4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD346C4CECD;
	Fri,  1 Nov 2024 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730488351;
	bh=uDz0+rrdKUxN7l++C1yclZv0bkKrRBTyhR8EgMvYQjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pt06Jk4rqrpDY2wKmy2XXXWpChHkcnIP34Tf+iNO478aLXDzfFWI//ErszeF/c6lq
	 1qbP/oU84hIaMZjgbVpAe4HNWD8bIonlTgeXgFIrFqV3kCoKFIdhVPInzSI/bPG9ED
	 9heSn3m9KAh+gQGQeJYefeWAS/IUrDV+PJ6pArU5h1azfEqoiAmVga1CYaizBdU18v
	 g3ivDW59fS6KjfYNMqlAnMLBt5a6z/lNnnuptV2DBlzBJnOR94ozJyGszryTZb37Ge
	 U7hQxYute3bZR4b6UYLj3ILL2tmZSAkHpJ3ZzR5NeXDcNVC/7yM8aZ+Er3CH0K/HEH
	 pWgUB7i/Ke7Gg==
Date: Fri, 1 Nov 2024 14:12:29 -0500
From: Rob Herring <robh@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Subject: Re: [PATCH v5 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel
 EIP-93 crypto engine
Message-ID: <20241101191229.GA3841377-robh@kernel.org>
References: <20241028124206.24321-1-ansuelsmth@gmail.com>
 <20241028124206.24321-2-ansuelsmth@gmail.com>
 <20241028143515.GA792452-robh@kernel.org>
 <671fa31a.050a0220.12b1fe.157e@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671fa31a.050a0220.12b1fe.157e@mx.google.com>

On Mon, Oct 28, 2024 at 03:43:34PM +0100, Christian Marangi wrote:
> On Mon, Oct 28, 2024 at 09:35:15AM -0500, Rob Herring wrote:
> > On Mon, Oct 28, 2024 at 01:41:42PM +0100, Christian Marangi wrote:
> > > Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> > > 
> > > The IP is present on Airoha SoC and on various Mediatek devices and
> > > other SoC under different names like mtk-eip93 or PKTE.
> > > 
> > > All the compatible that currently doesn't have any user are left there
> > > commented for reference.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > > Changes v5:
> > > - Comment out compatible with no current user
> > > Changes v4:
> > > - Out of RFC
> > > Changes v3:
> > > - Add SoC compatible with generic one
> > > Changes v2:
> > > - Change to better compatible
> > > - Add description for EIP93 models
> > > 
> > >  .../crypto/inside-secure,safexcel-eip93.yaml  | 67 +++++++++++++++++++
> > >  1 file changed, 67 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > > new file mode 100644
> > > index 000000000000..188240b74110
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > > @@ -0,0 +1,67 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip93.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Inside Secure SafeXcel EIP-93 cryptographic engine
> > > +
> > > +maintainers:
> > > +  - Christian Marangi <ansuelsmth@gmail.com>
> > > +
> > > +description: |
> > > +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> > > +  integrated in varios devices with very different and generic name from
> > > +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> > > +  developed by Inside Secure and given to license to vendors.
> > > +
> > > +  The IP block is sold with different model based on what feature are
> > > +  needed and are identified with the final letter. Each letter correspond
> > > +  to a specific set of feature and multiple letter reflect the sum of the
> > > +  feature set.
> > > +
> > > +  EIP-93 models:
> > > +    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
> > > +    - EIP-93ie: i + SHA224/256, AES-192/256
> > > +    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
> > > +    - EIP-93ies: i + e + s
> > > +    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
> > > +
> > > +properties:
> > > +  compatible:
> > > +    oneOf:
> > > +      - items:
> > > +          - const: airoha,crypto-eip93
> > 
> > Still doesn't look SoC specific...
> >
> 
> Oh ok I didn't understand that I had to drop it.

Not drop, but something with the SoC name in it. What's the SoC you are 
using?

> 
> > > +          - const: inside-secure,safexcel-eip93ies
> > > +      # Compatible that doesn't have any current user.
> > > +      # - items:
> > > +      #     - const: SoC specific compatible
> > > +      #     - enum:
> > > +      #         - inside-secure,safexcel-eip93i
> > > +      #         - inside-secure,safexcel-eip93ie
> > > +      #         - inside-secure,safexcel-eip93is
> > > +      #         - inside-secure,safexcel-eip93iw
> > 
> > I should have looked at the driver before commenting before, but since 
> > you are using these compatibles, you should go with my other suggestion 
> > or these will be listed as undocumented.
> >
> 
> The other suggestion you mean with the false or not: {} ? I tried that
> first with 
> 
> - items:
> 	- not: {}
> 	- enum:
> 		- ...
> 
> But make dt_binding_check always complained. and False had some problem
> is compiling the yaml schema.

Either way should work with main branch now.

> Sorry if I'm making this very confusing. We can also consider using SoC
> specific compatible in the driver directly and just declare the generic
> one here.

How would that work for the cases without an SoC specific compatible 
yet? Of course, if you can't test the i, ie, is or iw variants, how do 
you know they work. Just relying on them being a subset of functionality 
I guess.

Rob
