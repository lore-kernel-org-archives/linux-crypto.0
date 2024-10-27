Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AD417C61;
	Sun, 27 Oct 2024 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730068273; cv=none; b=mR3e8yANDUOmTh3+SBbsweBiGg06vRMAoiYKbi/0hfCfhsR+omXK9rVFa72OEmdg/rlkHswBiLK1uTwSRvzFCFlvJU1P+J4X+fcux9LtjRfCivDjkj9pTvZuY0u4b2mqHgkEeUnV+ijALFktBCUBK2uOXcnEa7VBxJml1us5XSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730068273; c=relaxed/simple;
	bh=TZuysod91j8XGFVw5rUWxKcBjLEDID4bnPfMM69TS88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mR6kbmmDIDd8rHGUqvU8HzvLzWtKANE/+O6mdFlLwILRCQVWQQkrqka7uOiQMRAg74nSZNSgcf37hmeHufmASb5Wg5QHpdsEgcgxhAUU/CjQVLhNl8LN5YVS2Z0suF6GM3PYTl90j33i776gHAoBUsLt8SH8iGkc8ewDS7bG5oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwW4OqLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwW4OqLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6996DC4CEC3;
	Sun, 27 Oct 2024 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730068272;
	bh=TZuysod91j8XGFVw5rUWxKcBjLEDID4bnPfMM69TS88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XwW4OqLx/3KMbBODxKu4qIMHnrXkaK02gr1Bs1d3rAivraJAAf+wKAxSS+2g0LesH
	 8uL7mRXyS0Lze+4AeP/K1gTRMvonUbmc+/Txm7E2N0rvVO9ZI/erQS65YPET5VbkLS
	 goRN0/I52wjnhqWOIwu1NTf+rgOWKIFki1H2djxVTEefPyyql4q7IGq2NEbC1bt6Z+
	 +E5n7uK7aJfM8y2+NAQ26qOi/f+9ebXnibIII4KT0X26OofNuKX9DJd7La30gEM+hR
	 8lxuvxeD/knxPmqw9QNai2zLUmKvjDdcN+GANvggD5XdMRqV9XLIueJsPbFIB6shS8
	 S6sIISm94wbpw==
Date: Sun, 27 Oct 2024 17:31:11 -0500
From: Rob Herring <robh@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Conor Dooley <conor@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH v4 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel
 EIP-93 crypto engine
Message-ID: <20241027223111.GA151367-robh@kernel.org>
References: <20241025094734.1614-1-ansuelsmth@gmail.com>
 <20241025094734.1614-2-ansuelsmth@gmail.com>
 <20241025-marmalade-constant-1c733ef5f3e8@spud>
 <671bd796.df0a0220.216be3.8504@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671bd796.df0a0220.216be3.8504@mx.google.com>

On Fri, Oct 25, 2024 at 07:38:26PM +0200, Christian Marangi wrote:
> On Fri, Oct 25, 2024 at 05:44:39PM +0100, Conor Dooley wrote:
> > On Fri, Oct 25, 2024 at 11:47:23AM +0200, Christian Marangi wrote:
> > > Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> > > 
> > > The IP is present on Airoha SoC and on various Mediatek devices and
> > > other SoC under different names like mtk-eip93 or PKTE.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > > Changes v4:
> > > - Out of RFC
> > 
> > I left comments on v3, that I do not see addressed here.
> >
> 
> I missed them sorry, I was confused with the other reply about RFC not
> asking for comments. Let me copy the comments here so we can continue
> here.
> 
> > > Changes v3:
> > > - Add SoC compatible with generic one
> > > Changes v2:
> > > - Change to better compatible
> > > - Add description for EIP93 models
> > > 
> > >  .../crypto/inside-secure,safexcel-eip93.yaml  | 63 +++++++++++++++++++
> > >  1 file changed, 63 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > > new file mode 100644
> > > index 000000000000..13341710ee31
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > > @@ -0,0 +1,63 @@
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
> > >
> > This implies that you should have a non-trivial set of fallbacks, with
> > the "i" model as the base for that. eg:
> > 
> > "ie", "i"
> > "is", "i"
> > "iw", "i"
> > "ies", "ie, "is", "i" (I dunno which would be a better order here)
> >
> 
> These info are what I found around since informations about models are very
> scarce. The driver itself makes use of a bitmap in the IP to detect the
> supported stuff so the meaning of this is really to comunicate the set
> of feature mounted on the system.
> 
> Any hint on how to describe this better? I assume you refer to some kind
> of yaml logic structure to put in the compatible?

I think the list is fine as-is. If we already had support for the 'i' 
version and then added new 'iX' versions, then having the fallback makes 
sense. But since this is all new and defined at one time, I don't think 
defining all those combinations buys us anything. And an OS can still 
choose to only support the 'i' features even if the h/w supports the e, 
s, and/or w features.

> 
> > > +
> > > +properties:
> > > +  compatible:
> > > +    items:
> > > +      - const: airoha,crypto-eip93
> > > +      - enum:
> > > +          - inside-secure,safexcel-eip93i
> > > +          - inside-secure,safexcel-eip93ie
> > > +          - inside-secure,safexcel-eip93is
> > > +          - inside-secure,safexcel-eip93ies
> > > +          - inside-secure,safexcel-eip93iw
> > > +
> >
> > I don't really get what's going on here. Why is the first compatible the
> > generic one? That seems suspect to me, as I doubt the crypto block on a
> > particular SoC varies? I'd expect to see some soc-specific compatibles
> > with a fallback to the inside-secure IP version that it integrates.
> >
> 
> This was already discussed and hoped this solution was accepted (I
> didn't get any reply in the other revision, so I'm probably wrong)
> 
> Everything started with:
> - airoha,mtk-eip93
> 
> Was wrong as the compatible wasn't clear on what mtk was and if the IP
> was from airoha (it's not, it's licensed to...)
> 
> Then only the inside-secure ones, following how it's done for the newer
> inside-secure eip197.
> 
> Krzysztof then suggested that, since it's licensed but OEM can make
> modification, it should be sensible to put a compatible of the SoC where
> the thing is mounted at the front of the other compatible. Eip197 should
> have received the same treatement but for some reason it didn't.
> 
> So here in v3/v4 with this proposed solution.
> 
> First compatible is SoC name, useful if the Vendor made modification to
> the IP. Then the generic model that describe the set of feature
> supported.
> 
> I checked the register of 3 different device where EIP93 is implemented
> and they ALL match them. ONLY additional register are added for debug
> purpose and never conflicting bits are introduced.
> 
> Hence why IMHO it's OK to use the combo of Vendor + second compatible
> for the generic implementation.
> 
> >From both comments I'm not really sure what do you mean about fallback,
> anyway hope it's clear now.

The issue is that airoha only has 1 implementation of safexcel, not any 
of them which is what you defined. Well, at least if that's an SoC 
specific compatible which it doesn't look like either.

The issue is that you probably don't have an actual user for all the 
variants. I would just list them commented out or like this:

items:
  - false (tools might complain with this. "not: {}" may work instead)
  - enum:
      # IP versions without an SoC specific compatible defined yet
      - inside-secure,safexcel-eip93i
      - inside-secure,safexcel-eip93ie
      - inside-secure,safexcel-eip93is
      - inside-secure,safexcel-eip93ies
      - inside-secure,safexcel-eip93iw

(So remove the one you use in this list)

Rob
