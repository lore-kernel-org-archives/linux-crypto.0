Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46410C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239756AbiDFR5P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbiDFR5H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:57:07 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02293305B22;
        Wed,  6 Apr 2022 09:07:12 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id 12so2831088oix.12;
        Wed, 06 Apr 2022 09:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mi0PlXno3D6jBV7awtJNZHmVjzTuCmSnSrCiUvwpU7E=;
        b=ixA+1+fWlID6n92LIWvIyDbKuSPpFwo/ptM4XSfETNyHRztEoISeuDm5oZOuBfejFA
         cdz3ZZJx4uvmM3qrCfDt1fX5xa/W47mHPv43UE1MiViOzbrzXPWzy5HB/69wFAR/UvgS
         l8D0qbFbcX4en5QUcqp2oHfbOL7BM4jMbyBFsG8JP3Wye62z/mkBRT4bvZ/ZnVL8npBJ
         kh0l2C25nNAeQTJxLjxMqzCd+ZIMAC33ljbzKaG4YBb8aYjDMcDsNONcT+pecjDvM3Ym
         my9d+7ELK8uqzb6N41hDEUv4NO9lIb9nOlZ8a1D8YZXDV+F7d0BpTrC6pwpP8oOofjkz
         PpYQ==
X-Gm-Message-State: AOAM530WwdKiwYs1OJ3zYCBky39w8xkAL/bqm9GAGo1uKfNSJbG8VYE+
        9hX6gnUS8TyELR3hXA6I1A==
X-Google-Smtp-Source: ABdhPJyf9cDvzdnJyrz88zNtK+fVSdGACNFc6ZhTULEzyvDAXPx26QtcqONjw4TvsYhTPVBvMs061A==
X-Received: by 2002:a05:6808:2183:b0:2da:6d62:6ec6 with SMTP id be3-20020a056808218300b002da6d626ec6mr3895459oib.51.1649261230982;
        Wed, 06 Apr 2022 09:07:10 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id mj27-20020a0568700d9b00b000de29e1d6adsm4905187oab.16.2022.04.06.09.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 09:07:10 -0700 (PDT)
Received: (nullmailer pid 2334572 invoked by uid 1000);
        Wed, 06 Apr 2022 16:07:09 -0000
Date:   Wed, 6 Apr 2022 11:07:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     krzk+dt@kernel.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        heiko@sntech.de, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 29/33] clk: rk3399: use proper crypto0 name
Message-ID: <Yk26rQaTfZ1QvLN0@robh.at.kernel.org>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-30-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401201804.2867154-30-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 01 Apr 2022 20:18:00 +0000, Corentin Labbe wrote:
> RK3399 has 2 crypto instance, named crypto0 and crypto1 in the TRM.
> Only reset for crypto1 is correctly named, but crypto0 is not.
> Since nobody use them, add a 0 to be consistent with the TRM and crypto1 entries.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  include/dt-bindings/clock/rk3399-cru.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
