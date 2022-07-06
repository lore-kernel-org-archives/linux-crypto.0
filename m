Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D81CCA473
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 14:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiGFO2t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 10:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiGFO2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 10:28:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1B02658
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 07:28:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v16so10892181wrd.13
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 07:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ftt1gf1maseGqC1Gii2R8eooTq30YUOm7AExkJ1sGBI=;
        b=Idoj3f1+WjxFSaC8dyFJ6WmfifQA2Bwuj5QgzV8Fe9fCvZIDrYQbVnffG8rK4Nhc4M
         jvHyyMmjSeGMeDEH4iox8BuBGuO6q8XyI23QONyQjrKEGWhId2FvvYQYj+rZeGaB0/eo
         MUdXlaK5JbXGM0j2k3ek6BkgxAY9GaYqGOl+mn/4rhtdprQ7qgjNalgVk6pGjrDjT7Ku
         eeUWJoM0DPwXvseOzmAuU3AAzE03J0h5k3FeeTVa3m4j4nFPgILNL7MqTRu2UnVmw5aX
         1zZugYcVyqVJ3+nz8LREpA3sfLCyT180zGZkVMDZPDaXbPkBCuENIrpeSE4U0KAp5FG1
         0IlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ftt1gf1maseGqC1Gii2R8eooTq30YUOm7AExkJ1sGBI=;
        b=2xGLw1iKjjBUjfEW89sYP+lwc1EdAEvZVZzDCXAGVMQ8hfYFhvUPHo9ydQdVjtNEBK
         lfwAMztv+0+o9FwRQBajcGy3AGW9OsVSArvIKSPUifhM0BwRrYGqKbWDxore0eiTZUB/
         d+qwvpU+1metA4TwUmwkyo8Xr2KyOqZ0BSveCI6lyVt34CxGHcca2fdNsjsKULnTY+aR
         S3e8gP7gx+BGvkHN94wrzFh6TMnVFNRBsQ4/N/Ebb0mXkYZC+8/izGJw5mx25MjF6WLK
         zTJGS4iZWk0B8d4nUvv+tZLm6ZwKFjoh6GknewjBvpsFwF7QUvj+1vbT/r6K35btkJxW
         4O8w==
X-Gm-Message-State: AJIora/MzsE5o+KiiRLG3tjqBNDXmO0yOHCkuVEQPRMSWRty1VVOoROb
        FPFq70YCorAsh2JeW/2j5eNYrw==
X-Google-Smtp-Source: AGRyM1s/EpMgC9IgMxTtWr1OjAkAw4mmTjNBAsTu4Zuo0mz4gDkedlTMxCZZ9t17GTaZzEa0+7q8Kg==
X-Received: by 2002:adf:ea08:0:b0:21d:6dbf:6366 with SMTP id q8-20020adfea08000000b0021d6dbf6366mr13294602wrm.137.1657117724247;
        Wed, 06 Jul 2022 07:28:44 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y5-20020a056000108500b002167efdd549sm8046055wrw.38.2022.07.06.07.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 07:28:43 -0700 (PDT)
Date:   Wed, 6 Jul 2022 16:28:40 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Rob Herring <robh@kernel.org>
Cc:     john@metanate.com, heiko@sntech.de, p.zabel@pengutronix.de,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, didi.debian@cknow.org,
        herbert@gondor.apana.org.au, sboyd@kernel.org,
        mturquette@baylibre.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v8 25/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Message-ID: <YsWcGDwPCX+/95i3@Red>
References: <20220706090412.806101-1-clabbe@baylibre.com>
 <20220706090412.806101-26-clabbe@baylibre.com>
 <1657114144.957232.4099933.nullmailer@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1657114144.957232.4099933.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Wed, Jul 06, 2022 at 07:29:04AM -0600, Rob Herring a écrit :
> On Wed, 06 Jul 2022 09:04:04 +0000, Corentin Labbe wrote:
> > The latest addition to the rockchip crypto driver need to update the
> > driver bindings.
> > 
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  .../crypto/rockchip,rk3288-crypto.yaml        | 85 +++++++++++++++++--
> >  1 file changed, 77 insertions(+), 8 deletions(-)
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml: allOf:0:then:properties:clock-names: 'oneOf' conditional failed, one must be fixed:
> 	[{'const': 'aclk'}, {'const': 'hclk'}, {'const': 'sclk'}, {'const': 'apb_pclk'}] is too long
> 	[{'const': 'aclk'}, {'const': 'hclk'}, {'const': 'sclk'}, {'const': 'apb_pclk'}] is too short
> 	False schema does not allow 4
> 	1 was expected
> 	4 is greater than the maximum of 2
> 	4 is greater than the maximum of 3

Hello

I upgraded to dt-schema 2022.07 and fail to reproduce all errors.

Regards
