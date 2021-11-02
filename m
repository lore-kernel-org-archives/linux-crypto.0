Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87455C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 17:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685D760E78
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 17:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhKBRkE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 13:40:04 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:43669 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhKBRkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 13:40:04 -0400
Received: by mail-oi1-f169.google.com with SMTP id o4so31031805oia.10;
        Tue, 02 Nov 2021 10:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I4wS/MeApg+acnjIPcmIJRjqzT3xZ9ohIefTe2eA5Ww=;
        b=YL5pLW4vosf9iSz6oAAuJr+PHyni+O/SwLdZ0O+K1RYZzB8tgi19GZld3bhstBinLw
         NZd4VkF/VnTKz9bGsUj5xUqTYxpA5Vj0rTK1+9XjS/vJd+RcLi7Qe/YMkYrwll8/mAHe
         qGbvCUPC4oQAOIuOcxSZPqdW3IzxomzV08so89b5oMqyzmjNYFJnAP9KnqX2DaoQMwoG
         kJGGHuuk4dFY1F27AMsjTawaaJpEXgRhUQD1Lr4htrrBF5AyyeILUcFzlQ9XK5FSqLQi
         bVAn0DX3arFXnGq/EF0+YwUGzHeYxisnJ9/E803Ei1nVctlJL1nxhD08MgM8zgt9E9s/
         0Nvg==
X-Gm-Message-State: AOAM531LNUqGaQOCQVYvghUdZU1tSrC6py9UjLWgzRQwIBZSIAKqaVSL
        LffjMlEiAMIdne+BFXg1SA==
X-Google-Smtp-Source: ABdhPJwFt7oZf3aTr+9ZIpmdhnMpkMuBp6BB+Cfvx0lXcBpv3bbPDYT7FEjrIJFQ4+bQKQlHHGLxdQ==
X-Received: by 2002:aca:d956:: with SMTP id q83mr6099213oig.165.1635874648601;
        Tue, 02 Nov 2021 10:37:28 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id m14sm4199586ooe.39.2021.11.02.10.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 10:37:28 -0700 (PDT)
Received: (nullmailer pid 3130452 invoked by uid 1000);
        Tue, 02 Nov 2021 17:37:27 -0000
Date:   Tue, 2 Nov 2021 12:37:27 -0500
From:   Rob Herring <robh@kernel.org>
To:     Richard van Schagen <vschagen@icloud.com>
Cc:     robh+dt@kernel.org, matthias.bgg@gmail.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto
 engine
Message-ID: <YYF3V0FzIwhIuyNK@robh.at.kernel.org>
References: <20211028015800.3449040-1-vschagen@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028015800.3449040-1-vschagen@icloud.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 28 Oct 2021 09:58:00 +0800, Richard van Schagen wrote:
> Add bindings for the Mediatek EIP-93 crypto engine.
> 
> Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> ---
> Changes since V3:
>  - Corrected typo
>  - Removed "interrupt-parent"
> 
> Changes since V2:
>  - Adding 2 missing "static" which got lost in my editing (sorry)
> 
> Changes since V1
>  - Add missing #include to examples
> 
>  .../bindings/crypto/mediatek,mtk-eip93.yaml   | 38 +++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
