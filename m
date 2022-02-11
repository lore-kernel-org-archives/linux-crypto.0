Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC571C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 19:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352989AbiBKTsV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 14:48:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348914AbiBKTsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 14:48:19 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4EE2A5
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 11:48:16 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l67-20020a1c2546000000b00353951c3f62so6952990wml.5
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 11:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=juTeh7Pj90KLSN4yGW9MUvSWd5K4ZGezg8meChmllJM=;
        b=p2lbra2wVZWj/aHaZPHIqpQTjCq8ADCTKLacm7/mJcjw0XVpPj1tfMaXyKZq0OKBF9
         G2+oiZlPgwYGQ7qDX37e2rY+Hx+zmVLE5yjEULvC3SRlO2gWL3a9Q/cVTW/BAintjBvr
         xfpZOJ0KIRKc0l3Z/wqqpycd9cefOtaoM9nPvC3sLeZyABvxTo00k1ZVaS/65pgLX+ux
         7gV7Zo/84KYowLY6RpwlduRc2VKPdU5T/OpsabIv2mHSID67mFJJJkfyf2DsudwQMtA1
         QdbivyByiKN4KwBsg/IAYGEcn6MPBoQ5JbmXsVo1gR0i9kEMuE6cP+8nJ8TmZWvczbob
         XqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=juTeh7Pj90KLSN4yGW9MUvSWd5K4ZGezg8meChmllJM=;
        b=5C3WiBHL2y6iezR1zd7uNQUbMNZvzF3JWp6psyAA2eCqptn1/NBgYeln+wa+O1/v9b
         rBqFzHMR3tp4y2LVJXoUhylM0BcpUntmjiE5ILeBIrZzOFB1R5MuMKbLuMBZk043BZ5d
         0wUeht9/rmcKVXVifjM3KDKlr+wD9UETyDEc0jAUZ/K75PY6gcSXR2qIgNTSoj0hXJIc
         6JCAPSNXzCqEyAQS5v1BW7RN2xEd1tSUEhh6VJ0ev5SmFjsG+19KZN9HC5RGzTShHiyb
         yKNEBmXVO6lYcPMZZLnobE9f8XVcEHrhA8uQEwPgU5b9OolDq4tcCXVsCGEWUDAws4jQ
         StAg==
X-Gm-Message-State: AOAM531Y0oiCSwc8ROxEYtYEo0mOuT75GWqvNYlQR8gZ5ceb0IuEpiT3
        7zcLeDbQPDVI0JGeju9V7Pv7BA==
X-Google-Smtp-Source: ABdhPJwm4fSf5P60cAv4b4rom2weLwFPNsnAL5uORWpD8q0HuZ07dx4i7uD5lDxTuzkeJC2w/piyVQ==
X-Received: by 2002:a7b:cdfa:: with SMTP id p26mr1552313wmj.109.1644608895139;
        Fri, 11 Feb 2022 11:48:15 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j15sm104487wmq.6.2022.02.11.11.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 11:48:14 -0800 (PST)
Date:   Fri, 11 Feb 2022 20:48:07 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Johan Jonker <jbx6244@gmail.com>
Cc:     davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] dt-bindings: crypto: convert rockchip-crypto to yaml
Message-ID: <Yga9d5C2f1ubOok8@Red>
References: <20220211115925.3382735-1-clabbe@baylibre.com>
 <dba5684a-1e5f-a4d4-604b-651751636cf3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dba5684a-1e5f-a4d4-604b-651751636cf3@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Feb 11, 2022 at 02:13:00PM +0100, Johan Jonker a écrit :
> 
> 
> On 2/11/22 12:59, Corentin Labbe wrote:
> > Convert rockchip-crypto to yaml
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> > Changes since v1:
> > - fixed example
> > - renamed to a new name
> > - fixed some maxItems
> > 
> > Change since v2:
> > - Fixed maintainers section
> > 
> >  .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
> >  .../bindings/crypto/rockchip-crypto.txt       | 28 --------
> >  2 files changed, 66 insertions(+), 28 deletions(-)
> 
> >  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> 
> There's more possible to this document:
> 
> dt-bindings: crypto: rockchip: add support for px30
> https://github.com/rockchip-linux/kernel/commit/3655df1bc6114bda2a6417f39772a3cb008084ea
> 
> crypto: rockchip - add px30 crypto aes/des support
> https://github.com/rockchip-linux/kernel/commit/ee082ae4f609f3b48f768420b31d8600448bd35a
> 

Hello

The great advantage of out of tree code is that we can ignore it.
Anyway, if one day this code goes upstream, I think the new compatible should be in a new driver/module, both v1 and v2 are too different for me to be shared in the same driver.

But before upstreaming this code, the one in mainline should be fixed first, it fail self tests. (I have some patch partialy fixing it in progress)

Regards
