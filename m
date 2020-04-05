Return-Path: <SRS0=Egg7=5V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBE6C2BA1A
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 01:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B4182072B
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 01:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586050244;
	bh=u83SZeY4b8At86WZ+bH1uhTZZIzQidP2aeRvePvMMQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=I4Gud5AGVNoObmAAG91xhKl5Kl9RAvq97iLtJBbqPeoLvFvFEClDUCP1Co/WzPKBk
	 iIXS1q7Zdsc0FGu9+P0W1DvY2THh1J8yjieahWvua+8T6xBeTNw6rywbOz8fvjFwkN
	 8sTDa11QXMuvRKBO+BFyjOybwpksNJs384c5pm4Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDEBan (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Apr 2020 21:30:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34984 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgDEBan (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Apr 2020 21:30:43 -0400
Received: by mail-io1-f65.google.com with SMTP id o3so11984720ioh.2;
        Sat, 04 Apr 2020 18:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SA6yfaT/T+t66yxeKgkZ/FLyq4yKlkIEnEy6+NCFKfI=;
        b=P2NeT0yWS/+G7Tr4nRGI0tBvLymto5ONBM8LLyUaLAn6/CjdWYXwYCh8LFzCNaVfdF
         hmKqwYBX1RhmtDz8qfhysZLg7/wNsXRuYtHwHvHu8lyRgkGr3AJwqY3maPYrBX6XQ62V
         uB+o+F1kqgO/gcY1lUdY3NJH+UNswikBZilvS8+dC2almyPG3TyLzaG1130vrgf+hjO7
         xclNk7XP+LjLePzDrtpSsBgIG2Ed4gLXK1i3cpJvW+1Z5TLTcL0EDfr8qFzrpxBpBw1I
         2LKfgoVVTTOlrrYoC3XYrZ5Y+CKDJyTQbpsaAU61Yc0TgizfpJlKX5SWRXl3bw6X9NXQ
         VXww==
X-Gm-Message-State: AGi0PuaJ2loVx+Snzab9WMVm9aJ6mzUqtcnTOHBNhu3sANS95MPeThZY
        WffEBBoBkZ0OWjOAJHfhzA==
X-Google-Smtp-Source: APiQypK1jZz7wMLYq2apg85L1tx1WOLQ6glr/VHHvRwAqeStiWHwcc7SPH4lCGpCo/qo4uZRiGSOHQ==
X-Received: by 2002:a05:6638:626:: with SMTP id h6mr12539553jar.70.1586050242898;
        Sat, 04 Apr 2020 18:30:42 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id j2sm529814ioq.13.2020.04.04.18.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 18:30:41 -0700 (PDT)
Received: (nullmailer pid 21553 invoked by uid 1000);
        Sun, 05 Apr 2020 01:30:38 -0000
Date:   Sat, 4 Apr 2020 19:30:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: Re: [PATCH v7 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Message-ID: <20200405013038.GA21509@bogus>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <1585289423-18440-2-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585289423-18440-2-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 27 Mar 2020 09:10:21 +0300, Hadar Gat wrote:
> The Arm CryptoCell is a hardware security engine. This patch adds DT
> bindings for its TRNG (True Random Number Generator) engine.
> 
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  .../devicetree/bindings/rng/arm-cctrng.yaml        | 54 ++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
