Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7F21DE2A1;
	Mon, 28 Oct 2024 14:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126622; cv=none; b=tiXZ3fSJGOSdsAfC8QsDztrGSj9Isuq/bC7x+0x1K5Th47k6l1CeC/JejveAWVx0+yPXvCqaAUrV1+W3rncCPR3seXiiWgq0ey2t240adHDmlPnf/PBDn3Vgy6iSLLvUdfZN4fWDrp4aADVRHLgclAK7Ox2nuPu840s+zaUKEQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126622; c=relaxed/simple;
	bh=8dk3jQXqVNLtNBSBu8i0zu9YlvX2SJldVag1wY9K7lA=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3tZih08VMMoShbxiLLxg3vIduaHao8D2enMjvtx1E/gH3nU4dVc6748CgZEefTOKVTj/G1a5cwtM49PNoT4CcdQ4OYHPpZd+lRjhM88+1mymPYGSYmE6J/AtWUjHBXe/X3RO/4pljrUWassQiu1mKyYz4DntY4h7rCG85LxwQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pz9KVQYx; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pz9KVQYx"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d6ff1cbe1so3283975f8f.3;
        Mon, 28 Oct 2024 07:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730126619; x=1730731419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0o9UR6/T9IDZWX4PfCYo7WA8X0C5Y7vXRC8iiUeqkNw=;
        b=Pz9KVQYx87ECwZTjB5cS6/yo/MFkzZUl0E6kz7GNoq/nz0x0OforCidSbPA6ashiPS
         5aFMMxqb2OspS9gFJwDrr1bxX0cfzMP9dCCJJFb9CmL/RkTyl1KnII1MTQIU3LyNutbN
         J0CetlbGOo6RzOYUDFili8lOltogs47mpQDGKTj8GTOd+/p9PgWpsyxrH1ZzWFHaRV4c
         1bdkI0GYpgENoboq05KkPfm/8FL70wv10ArZEzHTG5yR+ULtcRoiZnl65jx/Bi0dZpvU
         XFUK8K1Td1ah7R0J68gWBoScx+okSnpFGYujoTKGnx2a89cC5ckv1ImQRdMfLveP8nJT
         Ulcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730126619; x=1730731419;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0o9UR6/T9IDZWX4PfCYo7WA8X0C5Y7vXRC8iiUeqkNw=;
        b=uIo5hgvJmPl0Tsga9EWN2Im1PaPnZGZQbULX41xVjzbSsIOLUQoCVVVx0SzSchQ2oO
         SqGDcG6EmcUbbwx8mFlioiPZtTKA3KWc/r2+Za/acc0pWc0GLx6VySjfjsRSiHPUJeMp
         K01E66g7wN5N3FVhhb73RhvQgg5AhDI84WxXGFVGxtnzGcPEaezKM1EHrgq2kgdXIhyW
         CJdOBPZxl6OWHRz538f0k4xHzMnR6GqF+ihbI9ePlIEeAvCMiZUzF5W3Uzp1TRBI5H7x
         wVfGVxb+uVXVxji4EMXRlPpiMkeAGNpCBrBWbQTP9FvnWvYuCBCCm3l/wsXVBQTV3T+A
         m3gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRc+aXLvxHEyvqQjNVFtMLzt7lOY6amHSjxy9hBIgxRKADIvpmho5EfDalix0E+iU4CuAYxVzU5M6i@vger.kernel.org, AJvYcCWuGXyqNJ4P+NzJuot+Pmx6/k3UWXKV18wAoTozR+sxJ5ZK4gGahzrA2gi4J2MIaHQRxAtPxw/jkZlsiRlr@vger.kernel.org, AJvYcCXyKGyXrQmU0O36NTE92ZLSNO1mENMVkPDNsGQfnySgju3MM9JjvepMPaqMW6T4DilPNiy6MD6Z1cqCPuVU@vger.kernel.org
X-Gm-Message-State: AOJu0YwjYvw2ciFupw8YBmLyvFBUBGiOmo8iX18mkwvis8vcXe3pvwkw
	ehmcPRYiE2c5p5gVL6KgJFQ3T7hnTuXn5mPAZCUHwOzpi/xkDSqG
X-Google-Smtp-Source: AGHT+IFVLEdQhrVQexeTh8VZ2u00+D168l91ubbaWPiPvFI6RdA1c1AyL40rbbrSIN3jQ/kPERYfEA==
X-Received: by 2002:adf:efca:0:b0:37d:5103:e41d with SMTP id ffacd0b85a97d-380611eecddmr5702661f8f.39.1730126618689;
        Mon, 28 Oct 2024 07:43:38 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3bb62sm9699237f8f.29.2024.10.28.07.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 07:43:38 -0700 (PDT)
Message-ID: <671fa31a.050a0220.12b1fe.157e@mx.google.com>
X-Google-Original-Message-ID: <Zx-jFqvjwjZD91UR@Ansuel-XPS.>
Date: Mon, 28 Oct 2024 15:43:34 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>
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
References: <20241028124206.24321-1-ansuelsmth@gmail.com>
 <20241028124206.24321-2-ansuelsmth@gmail.com>
 <20241028143515.GA792452-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028143515.GA792452-robh@kernel.org>

On Mon, Oct 28, 2024 at 09:35:15AM -0500, Rob Herring wrote:
> On Mon, Oct 28, 2024 at 01:41:42PM +0100, Christian Marangi wrote:
> > Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> > 
> > The IP is present on Airoha SoC and on various Mediatek devices and
> > other SoC under different names like mtk-eip93 or PKTE.
> > 
> > All the compatible that currently doesn't have any user are left there
> > commented for reference.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> > Changes v5:
> > - Comment out compatible with no current user
> > Changes v4:
> > - Out of RFC
> > Changes v3:
> > - Add SoC compatible with generic one
> > Changes v2:
> > - Change to better compatible
> > - Add description for EIP93 models
> > 
> >  .../crypto/inside-secure,safexcel-eip93.yaml  | 67 +++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > new file mode 100644
> > index 000000000000..188240b74110
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > @@ -0,0 +1,67 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip93.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Inside Secure SafeXcel EIP-93 cryptographic engine
> > +
> > +maintainers:
> > +  - Christian Marangi <ansuelsmth@gmail.com>
> > +
> > +description: |
> > +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> > +  integrated in varios devices with very different and generic name from
> > +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> > +  developed by Inside Secure and given to license to vendors.
> > +
> > +  The IP block is sold with different model based on what feature are
> > +  needed and are identified with the final letter. Each letter correspond
> > +  to a specific set of feature and multiple letter reflect the sum of the
> > +  feature set.
> > +
> > +  EIP-93 models:
> > +    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
> > +    - EIP-93ie: i + SHA224/256, AES-192/256
> > +    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
> > +    - EIP-93ies: i + e + s
> > +    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
> > +      - items:
> > +          - const: airoha,crypto-eip93
> 
> Still doesn't look SoC specific...
>

Oh ok I didn't understand that I had to drop it.

> > +          - const: inside-secure,safexcel-eip93ies
> > +      # Compatible that doesn't have any current user.
> > +      # - items:
> > +      #     - const: SoC specific compatible
> > +      #     - enum:
> > +      #         - inside-secure,safexcel-eip93i
> > +      #         - inside-secure,safexcel-eip93ie
> > +      #         - inside-secure,safexcel-eip93is
> > +      #         - inside-secure,safexcel-eip93iw
> 
> I should have looked at the driver before commenting before, but since 
> you are using these compatibles, you should go with my other suggestion 
> or these will be listed as undocumented.
>

The other suggestion you mean with the false or not: {} ? I tried that
first with 

- items:
	- not: {}
	- enum:
		- ...

But make dt_binding_check always complained. and False had some problem
is compiling the yaml schema.

Sorry if I'm making this very confusing. We can also consider using SoC
specific compatible in the driver directly and just declare the generic
one here.

-- 
	Ansuel
