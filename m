Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5910FC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Apr 2022 11:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350902AbiDSLMA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Apr 2022 07:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350894AbiDSLL7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Apr 2022 07:11:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5562657A
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 04:09:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id y21so8922185wmi.2
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 04:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=k9SQS6DEx7PcK3aZSt7NFnPshwNlUhuY2vj8QCcgdU8=;
        b=f8jTBzdCgR6gZoEBSlPxq90yrNFz+cJET9rvKb4SBbgJ3hbal36VvgdomSIglGgnO2
         3m52LyW2/NdxIy6Gtfurhq600ou6nWq7Vo8VlhKKUxdcfpzNbNSLAAfHScLAiqIPJnli
         D04SCxBNOYYZDuahNhtsJDUlWB5unMRdTrn/kJnFc31Ui5htITjZeD61zi+pb1l97IW/
         9L2Qo1bthVeE7l1MPTQDaeETEDSUvtMflBQ2dm1j4rDzIRWNfzKlW/Uw0sUAHMuob9pS
         l8EMODJrZvsH0VNyDN0nBwcr4Kae1lvAroCpPCxGh5764YFDnTKwa7A2Abu/qUz8uQLW
         /tNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=k9SQS6DEx7PcK3aZSt7NFnPshwNlUhuY2vj8QCcgdU8=;
        b=QFSTx+yaKHOeuVtEB3RNY+DQeOTA+iiiiu7N9MAZWhkw04/SWgOocIKOl1nQOxeePX
         KI0co4yaVam7MMDMmi/bQ4vga95ljBk7Z8Uh60RlCKz3fMkJmKz304Y02/PtYaHm2ois
         V4HJxeJPPwkOzTc9mwmd+c4rhKpym++JMI+qyuwRt+LFaMkVK5Hvo2RJftaRPsdTFA57
         ctwnWTd/cwTAtHLDoYHUa53c2IReG1oEbbrh6xurZdRgvaq5ZNvIeqK4wb+tw/GJfocB
         KY99K/hZUfo3pLuQ7lkg5HgKzuqI2vLdSVkLN5g61PMfln3YxuduvNMMRtCojSy2Bkeg
         uVCQ==
X-Gm-Message-State: AOAM531DekA3+aK0ar0cHPANw1DZel6dcfCo6poEoNkxMDMymrjHaNxa
        bKPen/IFodrpDojxuWerILVWWA==
X-Google-Smtp-Source: ABdhPJyom0pejQx9+muBJ4LXKjDgivoBsIZxgzm1mENjReqSKOE98rUgPTpWVyVn3NH52/xaRjs95g==
X-Received: by 2002:a05:600c:4f87:b0:392:9236:3c73 with SMTP id n7-20020a05600c4f8700b0039292363c73mr11110988wmq.158.1650366554533;
        Tue, 19 Apr 2022 04:09:14 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id 7-20020a05600c024700b0038ec0c4a2e7sm18549936wmj.11.2022.04.19.04.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:09:14 -0700 (PDT)
Date:   Tue, 19 Apr 2022 13:09:11 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 24/33] dt-bindings: crypto: convert rockchip-crypto to
 YAML
Message-ID: <Yl6YV9nLVI4qYsPP@Red>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
 <20220413190713.1427956-25-clabbe@baylibre.com>
 <44efe8b6-1712-5b87-f030-2f1328533ee8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44efe8b6-1712-5b87-f030-2f1328533ee8@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Wed, Apr 13, 2022 at 09:31:13PM +0200, Krzysztof Kozlowski a écrit :
> On 13/04/2022 21:07, Corentin Labbe wrote:
> > Convert rockchip-crypto to YAML.
> 
> Thank you for your patch. There is something to discuss/improve.
> 
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - rockchip,rk3288-crypto
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 4
> > +
> > +  clock-names:
> > +    maxItems: 4
> 
> This is not needed and dt_bindings_check should complain.
> 
> > +    items:
> > +      const: aclk
> > +      const: hclk
> > +      const: sclk
> > +      const: apb_pclk
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  reset-names:
> > +    maxItems: 1
> 
> The same.
> 

I forgot to test the intermediate patch...
Before I send a new version, does the final document is okay ?
