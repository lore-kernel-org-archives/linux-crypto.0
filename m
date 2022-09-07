Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854E4C38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 20:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiIGUmc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiIGUma (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 16:42:30 -0400
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0107FC1669;
        Wed,  7 Sep 2022 13:42:29 -0700 (PDT)
Received: by mail-oo1-f42.google.com with SMTP id c9-20020a4a4f09000000b0044e1294a737so2644198oob.3;
        Wed, 07 Sep 2022 13:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qj6UgvUxI3FzO2eVUPQ0Nsd1aUiPM+2tNjRSCOPmJZs=;
        b=UJIgtdrzEishUGwhMl8+m3TBWlS5SGPL/6MNNOy17XYjAZlXn40rJkdVZGmAU0gX1U
         eGvsFd/8RCFbpBDAyoMBLgcKqsw4tSGBOdYTZFUdMClTv55jC5xW9HVf15EUQi23sJY0
         PztCey5qtozk8rKKk2gq+CND7KjJq+eQRyg8ggBKjnURg278gudYsEknojDRDAIBkOVg
         nR/f4RAq2bVgiG1EJXIUt3QBrhMJ6jSGtoBOwYE5geHxLz0FGgFDJbOprjap6COLjJ9q
         YPr/LK8Hzg8oJM+ugI8LgW4f59xb7u0pMCxcRHSBadUzg+3QeFL/MyT/WlvNA9Bn7tKA
         qyNw==
X-Gm-Message-State: ACgBeo338R2oKjO/vZ+sUnQpdhYKFaSUb9VE0XkX6W5W4NLcCRt1MmRp
        WqdYE8F3nsbQUGfK2iODCxsYor5JvQ==
X-Google-Smtp-Source: AA6agR712axyO0qokGHVYgm2brcOhizvaSBGfAHJ2WZcv6MoJEcLlNY0GE2s+F3STenIe95x8pF5YQ==
X-Received: by 2002:a4a:2243:0:b0:44a:e5cf:81e5 with SMTP id z3-20020a4a2243000000b0044ae5cf81e5mr1908609ooe.44.1662583349139;
        Wed, 07 Sep 2022 13:42:29 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d4-20020a9d72c4000000b0063b34c35575sm7730675otk.42.2022.09.07.13.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:42:28 -0700 (PDT)
Received: (nullmailer pid 306425 invoked by uid 1000);
        Wed, 07 Sep 2022 20:42:28 -0000
Date:   Wed, 7 Sep 2022 15:42:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Davis <afd@ti.com>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Jayesh Choudhary <j-choudhary@ti.com>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nishanth Menon <nm@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH] dt-bindings: rng: omap_rng: Drop requirement for clocks
Message-ID: <20220907204228.GA306367-robh@kernel.org>
References: <20220901171041.32056-1-afd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901171041.32056-1-afd@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 01 Sep 2022 12:10:41 -0500, Andrew Davis wrote:
> For K3 devices the clock fed into the RNG module is shared with the rest
> of the Crypto module, it is not dedicated to the RNG module and cannot be
> controlled by the RNG driver. The driver does not require this clock to
> always be defined and the DT binding should not force it either.
> 
> Remove this so we can start dropping out the clock properties as needed.
> 
> Signed-off-by: Andrew Davis <afd@ti.com>
> ---
>  Documentation/devicetree/bindings/rng/omap_rng.yaml | 11 -----------
>  1 file changed, 11 deletions(-)
> 

Applied, thanks!
