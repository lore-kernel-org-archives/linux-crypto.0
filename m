Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D468C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Apr 2022 18:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiDCTAd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Apr 2022 15:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiDCTAc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Apr 2022 15:00:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E076447
        for <linux-crypto@vger.kernel.org>; Sun,  3 Apr 2022 11:58:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r11-20020a1c440b000000b0038ccb70e239so840285wma.3
        for <linux-crypto@vger.kernel.org>; Sun, 03 Apr 2022 11:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=t/RpIWdhbQVBXdaJ9oI5/IoGk7GgpeKKoOGSNN4wvL4=;
        b=iiuksQImYHQwFGIIvxhiUz1Kb7RqQfCkD9nr2/f9EKEev9O1Gerai4R+qVyYrIqgGx
         nitAv//xgEQNlKcwzDj8hHfToG/ZXHGJO94o+PqurCzSX6zSrMqIx4NsIG2+61MIs3DM
         H/2NklABJqKRd2J95fJCHDgnjQjfD8UsWsj6+sqOcPS1nVtPR+hGx5uzY+BQ0+a3ssnl
         azRlg9npq9HlKarVHYEgprjkGiq4LTNfkQxuSwl+s+MPxn+9OBhy0YIceeO/cp+GiS/2
         /665pzb6/czZxtTshSQc8c43PpTc5ymPNf1sOa6ERhZ6BTL0QNHJVWVukWfvUr2gLBHB
         7J3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=t/RpIWdhbQVBXdaJ9oI5/IoGk7GgpeKKoOGSNN4wvL4=;
        b=nOkVuTvcEDlejoeMIuc/A3DqLXoFCva3QPDBGXrNl9o7ILAtD2RwPGBgPn0Ty/Jv3W
         vtQJLlIjB0X/PGrRp4jd4rnvHvVP4bhoxO7J+HOi3mUHVV+lvEEBcDy73QWuLTqnIx0E
         nn6ioTnZs8fbxR+h69Gzw0VWlLtCVl/xlk4VG0upV56sN/zoK7ubVpCK9OSe5QDBx9Kd
         7aPTmDrp/0i5H56qyr+x5eclwzsDojf9PSjhWSvLT2A9g2lY2/HLnYEZM8K3ZP6gqSFK
         K6HYrZ3JsP/4TXSPFoPUyBfuSjsCHIrHgT7GsQ0uhnMeKLRawiBzl5ZGhdnbcyRAWoNM
         z1ZQ==
X-Gm-Message-State: AOAM530x6VD/tHUTf7mLKj9xlf55+GmxphK5iGwQSxnC3hDKqT4nhGHd
        La8/JlLu8uVS0usVZzVL3fT93A==
X-Google-Smtp-Source: ABdhPJzaazCPH6bFmU44UKKw6seoXSI3MBgT9c48Etfj1O+qSs+lrQUM2JPkuI1O1SQe4ZWjHVI07g==
X-Received: by 2002:a05:600c:1c1e:b0:38c:b393:b357 with SMTP id j30-20020a05600c1c1e00b0038cb393b357mr16709948wms.66.1649012315105;
        Sun, 03 Apr 2022 11:58:35 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id m7-20020adffe47000000b002060d09327fsm2505092wrs.16.2022.04.03.11.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 11:58:34 -0700 (PDT)
Date:   Sun, 3 Apr 2022 20:58:32 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 28/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Message-ID: <YknuWEOPq+I6jq9X@Red>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-29-clabbe@baylibre.com>
 <30305936-4b69-e1ce-44c2-0d1d113b460e@linaro.org>
 <d092ede9-df92-9b34-d2d0-5da043e11679@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d092ede9-df92-9b34-d2d0-5da043e11679@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Sat, Apr 02, 2022 at 02:07:26PM +0200, Krzysztof Kozlowski a écrit :
> On 02/04/2022 13:53, Krzysztof Kozlowski wrote:
> > On 01/04/2022 22:17, Corentin Labbe wrote:
> >> The latest addition to the rockchip crypto driver need to update the
> >> driver bindings.
> >>
> >> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> >> ---
> >>  .../crypto/rockchip,rk3288-crypto.yaml        | 68 +++++++++++++++++--
> >>  1 file changed, 63 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> >> index 66db671118c3..e6c00bc8bebf 100644
> >> --- a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> >> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> >> @@ -11,8 +11,18 @@ maintainers:
> >>  
> >>  properties:
> >>    compatible:
> >> -    enum:
> >> -      - rockchip,rk3288-crypto
> >> +    oneOf:
> >> +      - description: crypto IP present on RK3288 SoCs
> >> +        items:
> >> +          - const: rockchip,rk3288-crypto
> >> +      - description: crypto IP present on RK3328 SoCs
> > 
> > These two comments are not helping, so this should be just enum.
> > 
> >> +        items:
> >> +          - const: rockchip,rk3328-crypto
> >> +      - description: crypto IPs present on RK3399. crypto0 is the first IP with
> >> +                     RSA support, crypto1 is the second IP without RSA.
> > 
> > The second part of this comment is helpful, first not. You have chosen
> > enum in your first patch, so just extend it with comments. Additionally
> > indexing does not scale. What if next generation reverses it and crypto0
> > does not have RSA and crypto1 has?
> 
> Actually let me re-think this. Is programming model (registers?) same
> between crypto0 and crypto1? If yes, this should be same compatible and
> add a dedicated property "rockchip,rsa"?
> 
> I looked at your driver and you modeled it as main and sub devices. I
> wonder why - are there some dependencies? It would be helpful to have
> such information here in commit msg as well. Your commit #26 says that
> only difference is the RSA.
> 

Hello

There is no dependency, my only problem is that only one of 2 instance need to register crypto algos.
The only perfect way is to have a list_head of devices, but I found this a bit complex/overkill.
I understand my current way is not ideal, I will probably try this other way. In that case, yes problably the 2 node need to have the same compatible (and only a future rockchip,rsa will permit to distinct where RSA is).

Regards
