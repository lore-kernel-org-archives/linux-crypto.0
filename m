Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFA6C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 16:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbiBJQpT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:45:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244633AbiBJQpS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 11:45:18 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06F613B
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:45:18 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id l67-20020a1c2546000000b00353951c3f62so4359270wml.5
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yjDhqf592V3qt8wWnx7Xe2xWw8Y2UB9NWdwLTiczK1o=;
        b=5TiOMJ8Mlb50qXyWCZxwL5pAfIOmsQI/kinuGONPUTIEg0Szrjxp1VmltFKf/RGzoy
         tJJCDStGrt7koz6rkvJ2pE08unxcEkVEMaJOJ7qf2OF2JsuPVRUo8YQi8cpo/cHtEBBh
         JoyDWNohkzUHovRFWv5Gb9N0Y0mYf/B5ZDzxuW4ZrD4QBlWy+lg1JxpU7PP+XC/J5DkZ
         6TVoQcBVjEJWG6G6FgN9q1DmuMjc3Zp4tcNhK/dfz9/IJz7etW8HuC5W+sKw7Z4hTJ8g
         D+BrYu9wDbOh8eatRoUaYM3FtdzJ4E+S3+b8p1MQhvKbDOyr20N6nIogcEAIyCtCNXdY
         YoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yjDhqf592V3qt8wWnx7Xe2xWw8Y2UB9NWdwLTiczK1o=;
        b=KasjUjzjfjfN4dp4aNGr9bn2LY8oU7enqXoFiL3vZnWR+lJJMJdIZRaVmH5k74odHY
         xOXo0yN3okRNKa3sEU4Y4em/5Jq+K4Cm0Xnjjq7/jAacXHSA0GceqM6areI5q+bvZ1p7
         KUrJl0RP4Nty6dy4CaQMtP+cQLNl/LFoyNkVvmc5/UnXnf/rhe+114jyt78m7UqCj6o7
         yiCYxPXlDoBV4rRauFWL8+WU4XESGuL1H3WELKgSVcxJWKKqFip2W7Iy3GR2TA1azym7
         YFThelmGJZ26UjgudoDAV3rFklR9/4lH85K+ByAB7FR+ZQhbgrri4EH/6t+JxrOZeeV6
         T72A==
X-Gm-Message-State: AOAM532qie/oKyxAeauLrnWp83RKkUovgoiYAUE8Tir4lsQF1bN8NoAu
        ZmheFqIWxpzGW44/eTjTaCqosg==
X-Google-Smtp-Source: ABdhPJyc2/8ZJ4hxIbLPFVcCV1rZ1Bg0TV7Oh4Mt69EeuvSrocHuFZNrVs7yoFvWEICUdpXlSZYVqg==
X-Received: by 2002:a7b:cb90:: with SMTP id m16mr2868273wmi.3.1644511517233;
        Thu, 10 Feb 2022 08:45:17 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id d14sm2743881wrv.50.2022.02.10.08.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:45:16 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:45:14 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v2] dt-bindings: crypto: convert rockchip-crypto to yaml
Message-ID: <YgVBGvTBuMd17sm8@Red>
References: <20220210161403.2966196-1-clabbe@baylibre.com>
 <7acb44da-5833-f638-9348-0cbcc21cfc13@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7acb44da-5833-f638-9348-0cbcc21cfc13@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Feb 10, 2022 at 05:19:50PM +0100, Krzysztof Kozlowski a écrit :
> On 10/02/2022 17:14, Corentin Labbe wrote:
> > Convert rockchip-crypto to yaml
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> > Change since v1:
> > - fixed example
> > - renamed to a new name
> > - fixed some maxItems
> > 
> >  .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
> >  .../bindings/crypto/rockchip-crypto.txt       | 28 --------
> >  2 files changed, 66 insertions(+), 28 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > new file mode 100644
> > index 000000000000..44f415597e32
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > @@ -0,0 +1,66 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Rockchip Electronics And Security Accelerator
> > +
> > +maintainers:
> > +  - Corentin Labbe <clabbe@baylibre.com>
> 
> You removed Heiko. It's fine for me, just is it expected?
> 

This is an error I fixed manualy in v1 file and forgot to change and commit...

Sorry
I will resend a new version later
