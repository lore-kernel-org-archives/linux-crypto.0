Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A2BC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 01:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbiBJB0v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 20:26:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiBJB0k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 20:26:40 -0500
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC14F20188;
        Wed,  9 Feb 2022 17:26:39 -0800 (PST)
Received: by mail-oi1-f170.google.com with SMTP id u3so4389697oiv.12;
        Wed, 09 Feb 2022 17:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uEpUpIfQBjsAuD0aREJWR3efYMmJJL1AuZam/m/6eyk=;
        b=w0ScF+hR78OXG+jAoOQKsdehtypFF3RMaEyWoWtnHyAT3GIGAYX6JdJAVvef353Eer
         ywLafQAHVOGs5VF2KcQrS+B9BfSUKV6gdQy61ecs58IsYzkEjwKOs2mLOPS3yXGQu+37
         3mNa3gAAjbpaYmrNzeREWa1OClg0xBoFbJKcUG03YsW9hdfJOt24Bov0KCJyIhp+ncma
         Ba98F2YpPwbIPQYWVwZUo9zOO4QDyE97HYhsKI2V7nJH3a4XR+cgEygFUGpFnCqI/5Qe
         8Z84mUGh5muRcXmltqWtopzAYaoG9xMFYr+oO1Rh2zgZ3LEKxTjH0Dg5CXWBOJkhXnc4
         I09g==
X-Gm-Message-State: AOAM531SRupS0U/GR3zl7RjUvII0NMIWv9olLRFOGCIsS9U4MhkwuaOV
        LGYOiZuuFCYnaV23DEYj6EHkKlZoWPhe
X-Google-Smtp-Source: ABdhPJwoR118NCOFT4jqQkNW8s4CsH9rsEXgiQUx/h/9X+JbFWXy6NTwk+s6c9KZXxU3htf8jMh9MQ==
X-Received: by 2002:a05:6870:b1d6:: with SMTP id x22mr1770817oak.32.1644452944711;
        Wed, 09 Feb 2022 16:29:04 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w7sm2001747oiv.8.2022.02.09.16.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 16:29:04 -0800 (PST)
Received: (nullmailer pid 1255559 invoked by uid 1000);
        Thu, 10 Feb 2022 00:29:03 -0000
Date:   Wed, 9 Feb 2022 18:29:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     nicolas.ferre@microchip.com
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dt-bindings: rng: atmel,at91-trng: update maintainers
 entry
Message-ID: <YgRcT8yGjzMryNDp@robh.at.kernel.org>
References: <d84760e0b81c338e01f7856e1ce3c5b600b08f23.1643553619.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d84760e0b81c338e01f7856e1ce3c5b600b08f23.1643553619.git.nicolas.ferre@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 30 Jan 2022 15:47:08 +0100, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Update according to new MAINTAINERS entry.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> ---
> Hi,
> 
> Patch for new MAINTAINERS entry is here:
> https://lore.kernel.org/linux-arm-kernel/23819d8baa635815d0893955197561fe4f044d5e.1643553501.git.nicolas.ferre@microchip.com/
> 
> Regards,
>   Nicolas
> 
>  Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
