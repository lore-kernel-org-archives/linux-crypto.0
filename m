Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C7EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 16:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2DF661BFE
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 16:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhKPQQ1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhKPQQZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 11:16:25 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A485BC061570;
        Tue, 16 Nov 2021 08:13:27 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso2435751wms.3;
        Tue, 16 Nov 2021 08:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqaMY4kaFXWYnw+VaMV/E8xThN/h/ADiRMd9YHdw7UA=;
        b=bgQhElR67eCSv0/YSUJi//NKt/20FDtRrJPTze0kztN3IZzyerJfd+HFn/qbBHjZYl
         i5iJb1lFpiJ9K6H5aRD4DGPcAQo0RxA4s5MkNeD9II2NfAYhFA7CZA9uvS1BOFFs5n80
         eCu6zPzyUVokM7GrAGvkuE5jdRdZn/cKyi41kO0d2mijXZZuYqD1djJv369BVS1Io+oc
         +J/wn8xR80IziRS/pXTjojcqVm9pZsVaGWIVkRPwtVO4r+5mlct8VI6ydQkVwmtg7159
         xsZJZFbt/OwYEA4pjw8YD0SYdpzJts+ta/T9qdrzbuAb60bvnNSA+u+uW6uDoyqct0vH
         9drA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqaMY4kaFXWYnw+VaMV/E8xThN/h/ADiRMd9YHdw7UA=;
        b=AvQ9hros6B7HliOdKDTqH0aYXG22jFqN+hkxUipBpJ4ybXRL92QUvFoxwMUc5lGPij
         ppF8wAQD7c7/EtNZt9P0ZkkRaE9orNkJ638qBUn5Pp1o8fBPQIRXY3zOkmsGbxzw0Hrg
         lkdbr6NgEBnWRJBg+MPbM3RvwSxhohgHhIjwweGQo16nnu0avawZhJBQq2dhQ9fWVG+l
         G24uP62hjTNKCWNiOnKbMcZ/behUCq9aUr5FJCKlHnKl57WPM4MR+GJ8lwm9SfhkJRSm
         Ko1Yj/mBAb2GueYt1LSyoiuOdNt7TwsQD+N/sA7M5RS3vpZI9mOZj5iS5Daocyk7v7OW
         oYTA==
X-Gm-Message-State: AOAM5312gLSmaGlckuJaYM7sGJpZIh7tMeyeSh0iN6eHN4N/MDefXbsJ
        23oa8rSnU8ViM7l88luUQDw=
X-Google-Smtp-Source: ABdhPJw/XK0xa6zzZwAKYc/mRNjbCjL/N1lRyGhdIj9ustTSwbBNFtJOhwefxyiNWK9Go3z/VUXxJA==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr69273009wmi.115.1637079206153;
        Tue, 16 Nov 2021 08:13:26 -0800 (PST)
Received: from kista.localnet (cpe-86-58-29-253.static.triera.net. [86.58.29.253])
        by smtp.gmail.com with ESMTPSA id c16sm17253971wrx.96.2021.11.16.08.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:13:25 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     devicetree@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>, linux-sunxi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Add optional dma properties
Date:   Tue, 16 Nov 2021 17:13:24 +0100
Message-ID: <2603789.mvXUDI8C0e@kista>
In-Reply-To: <20211116143255.385480-1-maxime@cerno.tech>
References: <20211116143255.385480-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Maxime,

Dne torek, 16. november 2021 ob 15:32:55 CET je Maxime Ripard napisal(a):
> Some platforms, like the v3s, have DMA channels assigned to the crypto
> engine, which were in the DTSI but were never documented.
> 
> Let's make sure they are.
> 
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

> ---
>  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml    | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-
crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-
crypto.yaml
> index 0429fb774f10..dedc99e34ebc 100644
> --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-
crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-
crypto.yaml
> @@ -44,6 +44,16 @@ properties:
>        - const: ahb
>        - const: mod
>  
> +  dmas:
> +    items:
> +      - description: RX DMA Channel
> +      - description: TX DMA Channel
> +
> +  dma-names:
> +    items:
> +      - const: rx
> +      - const: tx
> +
>    resets:
>      maxItems: 1
>  
> -- 
> 2.33.1
> 
> 


