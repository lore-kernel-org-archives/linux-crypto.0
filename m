Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F773ECAAD8
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Aug 2022 20:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiH2UCM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Aug 2022 16:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiH2UCL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2022 16:02:11 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701E79752B;
        Mon, 29 Aug 2022 13:02:10 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-11edd61a9edso5773873fac.5;
        Mon, 29 Aug 2022 13:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=heDlxahlElGXVYwB2W6L7qQGe7aDiUidQ7Kv6j0r3rE=;
        b=3pKca5LrgBZzgEvgAH1vI5fHTFCG1K8hfa6ioss/fBjQHstJ2b7i0DH+fOJ9Pg9P/m
         q8eA3TJ7z/lRxDXkYwjvw2JjXOudY676Xq3Zf7hxuWTyJj8BGv0pfx+SIIKpGsNb8iIX
         YyoBuCVYuunynUqQqUdJopm3/haVO49Fp6EqDHD8JAQYr8PERk5ZyUbKeqFQ31UXBIiN
         K1uHbQiDwPFaXEK2FtNHi3e48xhlO4lmd+bviACeaFnUkg8Lth/vyyg7c9d9vNNX/mTS
         g2VKxb6oPjo+LjB9+FnIrSuKjvhto/A0FCgLNVA9+pDx0qp/gLBnhw3/gv63L5iN7N0W
         4Rsw==
X-Gm-Message-State: ACgBeo1+mLYSvmFbhsP1gmFOKtWzqXD3pqj+G0U9KVTH4NEGD0J8ifDQ
        PmiFJ+ftm4HnsTwj6lL2Aw==
X-Google-Smtp-Source: AA6agR7imhGalw24paYm0hGoNiPCs9z3xZhA32pXWQg75grNPB3xOQUmklHt6R+BJxACdjCgZwSwEg==
X-Received: by 2002:a05:6870:3906:b0:11e:4c51:13d1 with SMTP id b6-20020a056870390600b0011e4c5113d1mr8702681oap.281.1661803329741;
        Mon, 29 Aug 2022 13:02:09 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e20-20020a056830201400b006394756c04fsm6068234otp.0.2022.08.29.13.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 13:02:09 -0700 (PDT)
Received: (nullmailer pid 2323558 invoked by uid 1000);
        Mon, 29 Aug 2022 20:02:08 -0000
Date:   Mon, 29 Aug 2022 15:02:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jayesh Choudhary <j-choudhary@ti.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        herbert@gondor.apana.org.au, j-keerthy@ti.com
Subject: Re: [RESEND PATCH] dt-bindings: crypto: ti,sa2ul: drop dma-coherent
 property
Message-ID: <20220829200208.GA2323499-robh@kernel.org>
References: <20220826091142.262325-1-j-choudhary@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826091142.262325-1-j-choudhary@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 26 Aug 2022 14:41:42 +0530, Jayesh Choudhary wrote:
> crypto driver itself is not dma-coherent. It is the dmaengine
> that moves data and the buffers are to be mapped to the
> dmaengine provider. So this property should be dropped.
> 
> Fixes: 2ce9a7299bf6 ('dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation')
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
> 
> Resending the patch as it got ACK-ed but did not get MERGED.
> (https://lore.kernel.org/all/2935fd8e-ceda-fec9-db47-65d3ec142e32@linaro.org/)
> We get some warnings which are expected. I will post the dt-node
> fixes once this patch gets merged.
> 
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml        | 13 -------------
>  1 file changed, 13 deletions(-)
> 

Applied, thanks!
