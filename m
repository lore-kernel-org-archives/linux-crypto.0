Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C129C4320A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 21:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3201F61029
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 21:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhHQVPo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 17:15:44 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:44595 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhHQVPm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 17:15:42 -0400
Received: by mail-oi1-f180.google.com with SMTP id w6so1144917oiv.11;
        Tue, 17 Aug 2021 14:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PM2enoDBVpEuZpWbvRhxMVpJH3XAHQlsUlPw3171kZA=;
        b=HEEout4/Efp6X1vj9qiCLD7Mb9/WeObrPr08l4ZOp8krLytVn1O8+r1JoRCtqQjSPy
         i3XNVski804Uv4gDpeKUfpCGYYl38IICjBnH9Vivq3NfvmgMRGWFFQ2aH9YWKbnWsEb3
         9iOct/zQFQ/8dhVEXfZijkQDkh06k0yG3YouV0vms1VXB6WLcuKE+FrF3526fkZnf9FG
         k5Vcw6Ar24TCqKkP+Gjy1Pc6ID88bL4AfJ5ydaeF7HghzPzrFBsLvRLh6SO8xGDHAO87
         AJfhDY/WyOYcgv10sTF1+KDY4KGHhj5qEbMfouPV6QegUYiEnAJEgBaFh0t2zHBx/Hj7
         4Mjg==
X-Gm-Message-State: AOAM5338b4JZcie/NhN9FQbgAcUJIqKbfW2iFDU+lTEffQBskGTL+Tuo
        Q7IuRyz4GfI8dQ8vNmlLIw==
X-Google-Smtp-Source: ABdhPJxeKQH2Qe+oyN/Eb6NLA66EQFyOE9Rd/a//VVTyHHLmmtmQGWiK/UY92yF/ki7QTfEYTxWrEw==
X-Received: by 2002:a05:6808:f13:: with SMTP id m19mr4147887oiw.127.1629234908413;
        Tue, 17 Aug 2021 14:15:08 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n9sm613545otn.54.2021.08.17.14.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 14:15:07 -0700 (PDT)
Received: (nullmailer pid 852498 invoked by uid 1000);
        Tue, 17 Aug 2021 21:15:07 -0000
Date:   Tue, 17 Aug 2021 16:15:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        devicetree@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] dt-bindings: rng: convert Samsung Exynos TRNG to
 dtschema
Message-ID: <YRwm27L+PQx0TydS@robh.at.kernel.org>
References: <20210811084306.28740-1-krzysztof.kozlowski@canonical.com>
 <20210811084306.28740-2-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811084306.28740-2-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 11 Aug 2021 10:43:06 +0200, Krzysztof Kozlowski wrote:
> Convert Samsung Exynos SoC True Random Number Generator bindings to DT
> schema format using json-schema.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 45 insertions(+), 18 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
> 

Applied, thanks!
