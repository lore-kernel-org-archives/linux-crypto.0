Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35768C43460
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136FB61363
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhEUCF3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 22:05:29 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:39594 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhEUCF2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 22:05:28 -0400
Received: by mail-oi1-f174.google.com with SMTP id y76so9023060oia.6;
        Thu, 20 May 2021 19:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9fdH0SN9VUeMUbSb8aDt83HzmkEYcJr78YUXp4lCmeA=;
        b=iGreE/gqKVRNNPNvstSzPIqhHpnkFqqpe7ueOvSJXN4bUw6CeBHkvuP+fyG/nu8wIK
         M+ipeeT3oki75LVhVRQE3j4bNb6H265tGYBzonk9QBHPMZ9ERsuQ63hl0MXYEbzWSstZ
         5nX7DVKhApIDYEEwmc+W/v8+SBU7pQpcwkaPgY0LHVm03K8Shh8VOVRpfz+jUx6SvDEl
         QcNHDH+8bTIwr9WL7URdFsqy0slG1yRmZL+d08Vxde/LyQuse7/vGNRc0dijhFVpprP/
         TgM3DakPEDiAkw5e7WcnULiBHYJPC8qrK8X29m1Im9VYwNh7+VHD35+aFC8L0EN829Qq
         OL9g==
X-Gm-Message-State: AOAM531PZfc76QpeLZvLjwn0CNmTcdO825wTvP4GZUlsI+TZG2XCvyOy
        jYzWnGkSl6a9e4PmD9wQ1A==
X-Google-Smtp-Source: ABdhPJz5I+8jM3jJcv60seXotXjXJjLle5BdrNuMwFhPVT8jv3yjwueMfTmo+aLKNGdUJ1++iFKrwg==
X-Received: by 2002:a05:6808:309:: with SMTP id i9mr356643oie.14.1621562646140;
        Thu, 20 May 2021 19:04:06 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l20sm922057oop.3.2021.05.20.19.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 19:04:05 -0700 (PDT)
Received: (nullmailer pid 2507147 invoked by uid 1000);
        Fri, 21 May 2021 02:04:04 -0000
Date:   Thu, 20 May 2021 21:04:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Fabien Parent <fparent@baylibre.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, mkorpershoek@baylibre.com,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: mediatek: convert to yaml schema
Message-ID: <20210521020404.GA2507117@robh.at.kernel.org>
References: <20210520111656.66017-1-fparent@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520111656.66017-1-fparent@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 May 2021 13:16:55 +0200, Fabien Parent wrote:
> Convert the RNG binding for MediaTek to use YAML schema.
> 
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
> 
> v2: Write the compatibles in a more compact way
> 
>  .../devicetree/bindings/rng/mtk-rng.txt       | 22 --------
>  .../devicetree/bindings/rng/mtk-rng.yaml      | 53 +++++++++++++++++++
>  2 files changed, 53 insertions(+), 22 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.yaml
> 

Applied, thanks!
