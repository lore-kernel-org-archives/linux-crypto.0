Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4911E230C;
	Wed,  9 Oct 2024 22:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511897; cv=none; b=TytOauyO6W1FqmCP6EjHAerWihDttGkQ7vHhC4dBhzzm0acl6lK2ZeRQOlqQscGkhZvL1hmBKGJWmbuB26GXV1/QGcogLRENOpVdAGuKf0xsMjZqm9vl2U1WY9EMZxjNvWk7YQmlhOh1eIOMBc4BexgfoAtdm4EFlGCO58YDjGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511897; c=relaxed/simple;
	bh=mU9gcBCEheceOs4IIXU/WEntpbUBKN4IUVmhpqz4zBY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k64e3TbhoLZRA3G+7zJUWXZyy33XBRK960heL/4aSHpTgedq/1f4FfwqN4j4AqzsiJw7TrIWiLvzq2eAw9pG0tbkN30lDq5+Va+aQhevImGlxhR4je0kc5DVMle1M6Hqyoqt+Q5ewqh5hEGqiOTtpldCgYrvVsCq5SlXcI2/Zpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqozlMAm; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqozlMAm"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37d4821e6b4so112391f8f.3;
        Wed, 09 Oct 2024 15:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728511894; x=1729116694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0i77NC6oLQq+IeEr+P4sfxSedK09tyLyxivDjpTqakQ=;
        b=DqozlMAmBMnr5TO/KiRQu012gzr7E6eYvt3uu0khqFsNf5JAbnoFEWbTytC4FYVZvM
         WoAQWPSrux072+WAo6hPZEOTw/HOAL0Nj1Ur2gE18cdTH/1J+yV7/jIObMSevRQL/5Oe
         5NUfBHcdBnEmghNTINEdffrT1pCT+u2rqhp4Co++fUZoN96wyaGig9SGE6N6kjAPbdk3
         8+vPX7Sf1+qEZTsU4Ofe9ljmMi71MNAM0c/LXbWdjTssqdbmhaA9xMXSBNDsYkFd/sWy
         MGbeb6QftyPlpr/Th/+cerO6l88cq2b8m3okSYgv2c3jBc7x4buLYyR1IDjPs5CY1hbD
         /9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728511894; x=1729116694;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0i77NC6oLQq+IeEr+P4sfxSedK09tyLyxivDjpTqakQ=;
        b=A26nRwpNHRa5ftZxxfsreqTQBvO39KGQdvPkWts3X8tsnl04hxP5qPkJR9Quhu3bU3
         iK1dCBWzO5l7PTP1Jx1QfqNwIP4YkT4jwVbLWYcjLx4nUG9vDzpkMBl8CyxvEJ3cjFne
         agVtWCMXp0HfavdQjCvKwAj4fW4AT3Peay8j8G907witqh764IiCYNMLGd69223GTQei
         R+qye1XwyxfZgm+ZAFuksQ8lcyu8BPbDFp5BvQz1HFsBj14CvImqXWeGYPdufpg6CqII
         5B3Q/oo/QXvtf6ca6RRHmp5/m90ee7yVSAqx8tjyGJI1dqC+yYv4SmavT54sg1U6PXJx
         Sb/w==
X-Forwarded-Encrypted: i=1; AJvYcCUEdVdIUTy7ebMl7QDlNwH5t4WHIYEISK0S9HdzOkUjAL4/0kbkYUhT1ZJzceU6Zv2NRCXQqwEGkUpqPdok@vger.kernel.org, AJvYcCUa3gM4A1GQPD7ANIsJTP5/DiAWsn4yrnIjfDmdApWsg2DQSO3Ys8HcwqTCJxznGHpcUmDPfSDhlYLK@vger.kernel.org, AJvYcCUozdhtl/jPNrZT7IHLyOcl8Q/hfIRuc9gXIBGP01JYPEwPTBkwr8DG4RQ5mzbCvZVlflmEgdI3rzB3ngHx@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe5eMywgrw3RdQTYMiTGf4jSP1x05opzb4SQtRkd/DETyWBFBM
	koWY2yDwu6Xnfi1i4IP0/H+81wj2ob2VEHiNGNovRntBTujhHZdC
X-Google-Smtp-Source: AGHT+IHw9cL4v+z9P6U/yiMBej1wyxRUTPzlrVemNRcu+QpJcb9PafME3WdhTwugRboleUKOXk5CCg==
X-Received: by 2002:a5d:670d:0:b0:37d:476d:2d58 with SMTP id ffacd0b85a97d-37d476d2db1mr964948f8f.45.1728511893739;
        Wed, 09 Oct 2024 15:11:33 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1696f921sm11356159f8f.91.2024.10.09.15.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 15:11:33 -0700 (PDT)
Message-ID: <6706ff95.df0a0220.22b580.89e6@mx.google.com>
X-Google-Original-Message-ID: <Zwb_kucVA3WNpaGf@Ansuel-XPS.>
Date: Thu, 10 Oct 2024 00:11:30 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto
 engine
References: <20241009171223.12695-1-ansuelsmth@gmail.com>
 <20241009212400.GA735586-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009212400.GA735586-robh@kernel.org>

On Wed, Oct 09, 2024 at 04:24:00PM -0500, Rob Herring wrote:
> On Wed, Oct 09, 2024 at 07:12:20PM +0200, Christian Marangi wrote:
> > Add bindings for the Mediatek EIP-93 crypto engine. The same IP is also
> > present on Airoha SoC.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../bindings/crypto/mediatek,mtk-eip93.yaml   | 40 +++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> > new file mode 100644
> > index 000000000000..b0173b4da42d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> > @@ -0,0 +1,40 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/mediatek,mtk-eip93.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Mediatek EIP93 crypto engine
> > +
> > +maintainers:
> > +  - Christian Marangi <ansuelsmth@gmail.com>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - mediatek, mtk-eip93
> 
> space?
> 
> Why mediatek and mtk? Is eip93 an SoC? 
>

Hi Rob,

totally blind for not noticing this (and not even dt_binding_check
notice it wow)

Anyway the naming of this thing is a bit strange and hope you can give
some hint about what to use.

This is a crypto block included in various product like Mediatek SoC
(mt7621), DSP (ADSP-BF70x Blackfin) and in more recent stuff Airoha SoC
EN7581.

In documentation and in GPL source is called in various name... PKTE,
EIP93, geneirc "Crypto". One common name in drivers is tho EIP93.

Currently upstream it's supported the more recent version of this kind
of HW Crypto block, EIP197.

There the compatible is

"inside-secure,safexcel-eip197"

So from these info IN THEORY, the real produced of all this stuff is
inside-secure and the product is safexcel (confirmed also in other
product)

NOW the real problem.

From what I notice EIP93 HW Crytpo present on the old Mediatek SoC
(mt7621) have some small difference in some registry so maybe a specific
compatible will be needed.

Given this situation would it be acceptable to have

- inside-secure,safexcel-eip93
- inside-secure,safexcel-eip93-mt7621 (or maybe risky but
    more generic -mediatek ?)

The current driver doesn't fully account for the mediatek variant so it
would require some later changes. Maybe a better strategy is to just not
declare mediatek compatible for now? I know it sound stupid to ask a
question for something not entirely supported now but it's really to
understand how to move in the future. (just to prevent case where the
generic compatible is misused and we get mad on handling it in the
driver)

> > +      - airoha,mtk-eip93
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
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
> > +      compatible = "airoha,mtk-eip93";
> > +      reg = <0x1fb70000 0x1000>;
> > +
> > +      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> > +    };
> > -- 
> > 2.45.2
> > 

-- 
	Ansuel
