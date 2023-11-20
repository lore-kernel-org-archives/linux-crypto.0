Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="PfJ3IBp0"
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EBA107
	for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 04:37:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40859c466efso15497275e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 04:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1700483823; x=1701088623; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5xIcaRzTEKrbvWfEvAe9OkNKCvoLd6Y4BAtiZQNEI2A=;
        b=PfJ3IBp0nywXav3uWvb+RBlAvp9vSg8rFLqoUtxi3OSMl3IcTruQHAB+ugIvBFbc1t
         hvLjkCXwWoYSdDGQgx0unEyJezR3FtvWKqFjRricR0Vp6vMR/UqH6vrIseTak+EjG1bK
         8JzWfcIYrvRAGtj7yXgBE0b8X28D3j1Msn11cYrHXg9ler29ZO0P6xfBSbM7Q8PiXy0Y
         2MIHs01K+wYhN0x9tsCoiJPtjckRuNEhNwEHKFj1fsJUqjXYmPAp6N1PihLHXkE+ZJ0j
         f2tJ7KmhdSpYPlBpvg/eNyqt8Dj2qIfKDfC2dq4KG8s4+rSwomo3+r0655OFXkkmMeId
         BkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483823; x=1701088623;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5xIcaRzTEKrbvWfEvAe9OkNKCvoLd6Y4BAtiZQNEI2A=;
        b=kxBdCZ0wQ0XRF2ucN9clnfW9ZkpiEAyP4+1uRn9azNsX3XCKyjaLIQcburDtPcBAo8
         bqm7aOv3ZLutT37AJzr/c5DNauBLU/By5QI5lBQHsvzD9o5ZamS1e5n8nqIZ9QB292ep
         iiojRRkMUIg7moR4MMHtCNRZfe98D7McZRxWOXElcy/waInYW1MuGJKe30309jW3ISFX
         RJk/JJMyI5jszt01gNNZf5M+bYVq1Sa5bxFR9VfcwN5w4ZZS2qX2ayUj0j5xfvjuuaj+
         OkHYIRvGmbxWdwBM9jqtKFf82iuR23rnP38rUTNxGtTXxDnvVtj+XcD8d6Fdk24QWBcF
         S7lg==
X-Gm-Message-State: AOJu0YxFeFXKtBcBnZN0iR0J7mjArLZ3eDQ7GV2TCfyhTd2PHsht8rUh
	EmR84DJCvpaO+I3arxlvr/SG+Q==
X-Google-Smtp-Source: AGHT+IHTUQJofzeJ168RnZJSmmmO8MO0i6WawW814cn01ZEqqTeKJ+1xX/Ywal+JY5mPU5YLuA/H0A==
X-Received: by 2002:a05:600c:4589:b0:409:295:9c6e with SMTP id r9-20020a05600c458900b0040902959c6emr5469924wmo.30.1700483823418;
        Mon, 20 Nov 2023 04:37:03 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id n10-20020a05600c4f8a00b004095874f6d3sm13523859wmq.28.2023.11.20.04.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:37:03 -0800 (PST)
Date: Mon, 20 Nov 2023 13:37:01 +0100
From: Corentin LABBE <clabbe@baylibre.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
	krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
	p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org,
	ricardo@pardini.net, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 1/6] dt-bindings: crypto: add support for
 rockchip,crypto-rk3588
Message-ID: <ZVtS7YBhhtqCQX8w@Red>
References: <20231107155532.3747113-1-clabbe@baylibre.com>
 <20231107155532.3747113-2-clabbe@baylibre.com>
 <97ae9fa0-0a6c-41d2-8a6c-1706b920d7ea@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97ae9fa0-0a6c-41d2-8a6c-1706b920d7ea@linaro.org>

Le Tue, Nov 07, 2023 at 05:40:24PM +0100, Krzysztof Kozlowski a écrit :
> On 07/11/2023 16:55, Corentin Labbe wrote:
> > Add device tree binding documentation for the Rockchip cryptographic
> > offloader V2.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  .../crypto/rockchip,rk3588-crypto.yaml        | 65 +++++++++++++++++++
> >  1 file changed, 65 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
> > new file mode 100644
> > index 000000000000..07024cf4fb0e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
> > @@ -0,0 +1,65 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/rockchip,rk3588-crypto.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Rockchip cryptographic offloader V2
> 
> v2? Where is any documentation of this versioning? From where does it
> come from?
> 

Hello

Datasheet/TRM has no naming or codename.
But vendor source call it crypto v2, so I kept the name.

> > +
> > +maintainers:
> > +  - Corentin Labbe <clabbe@baylibre.com>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - rockchip,rk3568-crypto
> > +      - rockchip,rk3588-crypto
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    minItems: 3
> 
> You also must describe the items instead.
> 
> Where do you see any binding using minItems alone?
> 
> > +
> > +  clock-names:
> > +    items:
> > +      - const: core
> > +      - const: a
> > +      - const: h
> > +
> > +  resets:
> > +    minItems: 1
> 
> No, maxItems.
> 
> > +
> > +  reset-names:
> > +    items:
> > +      - const: core
> 
> Drop reset-names, not really needed and not useful.
> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +  - reset-names
> 
> 

I will fix all thoses problems.
Thanks for review.
Regards
