Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD33C2BB48
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 14:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E66422473
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 14:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437759AbgLNOff (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 09:35:35 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41308 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437703AbgLNOff (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 09:35:35 -0500
Received: by mail-oi1-f195.google.com with SMTP id 15so19354551oix.8;
        Mon, 14 Dec 2020 06:35:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pmYimdHqPZCmGoKy+QfoCbZ6cMjYvJ9Ol9TiMKbqo5U=;
        b=UGNT6S3ltcqpANs7rrVV3QG+UqBdrSA6wH6Qv5gq/Ik7TwlpBFuP7Sxc+EZP3og3ad
         ARJjn0VmpHeDgwDoxW0FldQob7EXeUWCply30Zyd4MlYf0sRlBc7p4qga2fAcA0PeVGP
         7bsaVmaJJOVWK6D4vqiZm2DZj8/k69C6KnMWOIOcDzIVOTFrsER3shotSzJ7THJM0jy7
         tj28ecrm81HXEWAX40mp1Phrja/eQnd8Xn6T1omPJty4JAaZWG5EwUpm/ULJ2Ou0p8bd
         NBT8iH93YaOf3jpqfANLrdYluPrWCYusn0MS/+Iaz0O3cydrG7MgvQyEyGi9cgPVhmJs
         PcfQ==
X-Gm-Message-State: AOAM533PUfsKZChFi/R7AsPd05lGxDy1+yMCUJxBfm4I95qPlS2r5FJU
        c78kDNJeuvt1B5CQjpSH2azuvsfRuA==
X-Google-Smtp-Source: ABdhPJxIZjyrGjwvcSupSDPeypUPaJjXZrJg/DEAYpaJ6OrhlsJtNXtsfhunBmocYWyjVbBoZqy2LQ==
X-Received: by 2002:aca:bc41:: with SMTP id m62mr18229830oif.16.1607956494486;
        Mon, 14 Dec 2020 06:34:54 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d13sm4354186oti.74.2020.12.14.06.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 06:34:53 -0800 (PST)
Received: (nullmailer pid 1883746 invoked by uid 1000);
        Mon, 14 Dec 2020 14:34:52 -0000
Date:   Mon, 14 Dec 2020 08:34:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
List-Id: <soc.lore.kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, soc@kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/4] dt-bindings: Remove PicoXcell bindings
Message-ID: <20201214143452.GA1883626@robh.at.kernel.org>
References: <20201210200315.2965567-1-robh@kernel.org>
 <20201210200315.2965567-5-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210200315.2965567-5-robh@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 10 Dec 2020 14:03:15 -0600, Rob Herring wrote:
> PicoXcell has had nothing but treewide cleanups for at least the last 8
> years and no signs of activity. The most recent activity is a yocto vendor
> kernel based on v3.0 in 2015.
> 
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> I'll take this via the DT tree.
> 
>  .../devicetree/bindings/arm/picoxcell.txt     | 24 -------------------
>  .../bindings/crypto/picochip-spacc.txt        | 21 ----------------
>  .../devicetree/bindings/net/macb.txt          |  2 --
>  .../bindings/timer/snps,dw-apb-timer.yaml     |  7 ------
>  4 files changed, 54 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/picoxcell.txt
>  delete mode 100644 Documentation/devicetree/bindings/crypto/picochip-spacc.txt
> 

Applied, thanks!
