Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF48D1DCB0F;
	Thu, 17 Oct 2024 12:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729169890; cv=none; b=rOoWzaQbe9ZtGHwnT+PYhvXGJrQTGbICMth9/b6DRkAFwu93TVEZg+JT8IBmFw3hJyq8Vtk7zmXkPIjZ7I2tE0mfdOkN9sB2J08xNQyGqWaPS5UmpGojJLjRj4G05AAa75DTArnnieV9eGfRWcIdk+eAFTX/Cre9pAm5Ee+UJYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729169890; c=relaxed/simple;
	bh=bIePXqAtUlqkTufvGumQxPUc0PqpBMo4EmQ3/DSX1hE=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvfnIuwGHu6hZJLd61oV+iKZazdHHl046GAnMBMDxt7QgFRDpWZ8gQ7cbWgBoKx7+xKpxbRJAS7Y6c4QrJkvyV74NwDXJ0Y9LzHsEwuKaY6LgFVSmtH4uqOtMG0OuZvL7qqqkAvH28ObMkdBWBC3BEPKgfTrO+/h06tOiNZvaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cP1NCxaM; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cP1NCxaM"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43159c9f617so6869255e9.2;
        Thu, 17 Oct 2024 05:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729169886; x=1729774686; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5VuFpsKd1Glm/eRZkFsD3jO6x6bmNRZsuLbQ0G2y7yU=;
        b=cP1NCxaMYPGhqrwroXk4+iaS3/saXCqq7ZWH4nGoCgAtTKw1+6GYyZ+jCxfhuzoJq1
         5+dpmeL8MqgLj7+a5TxKvUepjWGFFzRcXzpCZbIqA74cojhgEpFTa67z3OwS++oq2v9Y
         a/NMgzGG0fbNYAJ5Ci0g2Cy7wsGhmFY1F9ZASe6aWzFMnEXxFnLj8U42XCHDTKjqxAZQ
         xfhGfr/cGwZIWPhi8+fjY3gqy7l7npbU20RUE36ZB+EKn1kQfLDidX4Ot5mDRYXEikdc
         4XS70w7z/4RhgrrhZcO8TNGfwU1YX4E6Jrz07RinPEW+7ELGmYk1tItIm8iHYQL2JEhd
         kZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729169886; x=1729774686;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VuFpsKd1Glm/eRZkFsD3jO6x6bmNRZsuLbQ0G2y7yU=;
        b=LCWeoB0QBxMOF3Sbh5B/FpPvzA7/mPvNKNxNCKmD1FQR9zpKDyQDp/XSn3uNOrFIyE
         5OlS5CjVQtmEkRQkkRpJ7Z5X95abni1RgrV8vkpmh3XmekPxGzYW1oB2mbm3MEHY6CU6
         PDwtetBw3XFRIpRo1Kaf2F8bVIWkRFFrrzcwnVcW/eiy0ZTMC03g8w2rHYlNe7po4ac1
         UKS2uZgvZZIs/5QL7ay+tEBMC6sN/vQoFcAkXyMnApb/r+PdVIGrXa066MK6ZGATU7oc
         wItasBaBYVqgneOluFNNjYmfrhTsEvWHAhh0YVd3Shx7NLNUbN9KPAoWPJpZXS5UG1tb
         Tdvg==
X-Forwarded-Encrypted: i=1; AJvYcCVAjniJUA/M2DjQ9tRhlzEIhyl23mEBlNbjSQXXtV+5VPP3sBybpYeTclQz0SY/Zb6YK3bqCJQCIcdu9yrw@vger.kernel.org, AJvYcCXPnnu9wM1DUWiAPyCzHT2tby2pS5rWGMeFaDWgV0kQmD84H6dDx080Iynzw9Nbaw5AKrn0wvs6z0t2@vger.kernel.org, AJvYcCXnZdl7dGuG65+YRIGlUIz9j6poouGQ66K+kOh8rv3QwiEx5U+9mw3mXEFungi5X8Y1Ix0PTrp3GMkEIGU8@vger.kernel.org
X-Gm-Message-State: AOJu0YzwVE8egM8jJBuS6161v9hwX49RouGj5kDQd6xKKErVtLVklpI7
	4VGPu/Oy1F027MhZaWzukXzfNPc2bSxwbqZ6Ff2YjhxlKylI9/z7mNdIpA==
X-Google-Smtp-Source: AGHT+IEHtuRD9oDrBXiWk+27egjDRvZxIs2hhjYZB4oJFwN2wDbiqtmYcbXPus2BKXPg1GIc9bXBxA==
X-Received: by 2002:adf:ce83:0:b0:37d:4cf9:e085 with SMTP id ffacd0b85a97d-37d86bdc2c4mr4984748f8f.25.1729169885956;
        Thu, 17 Oct 2024 05:58:05 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fc41a15sm7164214f8f.110.2024.10.17.05.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 05:58:05 -0700 (PDT)
Message-ID: <671109dd.df0a0220.20fb5e.b4ad@mx.google.com>
X-Google-Original-Message-ID: <ZxEJ2jIwUHBrpE53@Ansuel-XPS.>
Date: Thu, 17 Oct 2024 14:58:02 +0200
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
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
References: <20241017004335.27471-1-ansuelsmth@gmail.com>
 <20241017004335.27471-2-ansuelsmth@gmail.com>
 <20241017123823.GA3032377-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017123823.GA3032377-robh@kernel.org>

On Thu, Oct 17, 2024 at 07:38:23AM -0500, Rob Herring wrote:
> On Thu, Oct 17, 2024 at 02:43:18AM +0200, Christian Marangi wrote:
> > Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> > 
> > The IP is present on Airoha SoC and on various Mediatek devices and
> > other SoC under different names like mtk-eip93 or PKTE.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> > Changes v2:
> > - Change to better compatible
> > - Add description for EIP93 models
> > 
> >  .../crypto/inside-secure,safexcel-eip93.yaml  | 61 +++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > new file mode 100644
> > index 000000000000..fc0877d93514
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
> > @@ -0,0 +1,61 @@
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
> > +    enum:
> > +      - inside-secure,safexcel-eip93i
> > +      - inside-secure,safexcel-eip93ie
> > +      - inside-secure,safexcel-eip93is
> > +      - inside-secure,safexcel-eip93ies
> > +      - inside-secure,safexcel-eip93iw
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> 
> 
> No clocks? All their other IP has clocks.
>

They are handled internally for each submodule. From the IP side, they
can be disabled with some register but in Autonomous mode (the one the
driver supports) they are handled automatically.

In short, yes for this "old" IP, no clock.

> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    crypto@1e004000 {
> > +      compatible = "inside-secure,safexcel-eip93ies";
> > +      reg = <0x1fb70000 0x1000>;
> > +
> > +      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> > +    };
> > -- 
> > 2.45.2
> > 

-- 
	Ansuel
