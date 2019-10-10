Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17349C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E3D206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570742728;
	bh=SdbdUtaad6/P2t61SXRz1phjnILIHfvzihqc9s92Ujo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ytHf3AErvLV6tz0HG9cFI9u7b+P4xQL6x2bE2VD2IMu30UoxdBGjBoYLQDpBXmEik
	 5iMA2a7kRKAfCbsLRAYaFPbJ9xUKKjK1H0ASuwlACscenSa3uwPZxxU1hBPW8P/T+S
	 X65IeWhjLPgxb7ghcCWCSxsHKwXxrF1mn8z6e1VM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfJJVZ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:25:28 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43000 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 17:25:28 -0400
Received: by mail-oi1-f196.google.com with SMTP id i185so6212997oif.9;
        Thu, 10 Oct 2019 14:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lv3rk3pHLhZvybEif/qwYDFpnKkl8bdDZ4HIHyWSdq0=;
        b=BRwmreNFexqhyMy+SdjFDgWjzor89ZVwlZnMzAo/Hcf4mS0SrzclPTusxsZ8M2g+bJ
         X7mG1xkLZRcfA6gKto5SGrPzKwD3Z/N7i/2eHYjGn+hC/PVJFj06Ls6kk7kZ7rYqbqiJ
         +uxzDEQU2rYxtz0zzSc0qaOMM8+E/NN0IjVIFNAO9SgJRqPfsZMlAwWKav+A0+a+Hlps
         nXu3Ud9+OxiuDhD+8uSNfnxy5OgezwbYjyqKoN0BE2nu+nI+BXqGropulfvTu8r0Cj7f
         gHhRxgElT6rPU2WzeregO9vGVvp/1BhmjljVeE87QQ4wJbo9+w5C7ni2rHHFXVi7kR8N
         TuKg==
X-Gm-Message-State: APjAAAWcPmweYS5ko9mWBL85wXXXdXrHF45+cDlaNaOt16GSzUQUOVR9
        11GlPAPLJ2R9YUvQcIaRIw==
X-Google-Smtp-Source: APXvYqyeZEQ766dBfpM3fs7aXjEXnwsmy6jN3B5Ks2+eoXLgvPE6nnx4qQhk7S2cWYyWurIXrAHtMA==
X-Received: by 2002:aca:2b08:: with SMTP id i8mr8915743oik.146.1570742727053;
        Thu, 10 Oct 2019 14:25:27 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i13sm2119432otj.58.2019.10.10.14.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 14:25:26 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:25:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: samsung: Convert SSS and SlimSSS
 bindings to json-schema
Message-ID: <20191010212525.GA10949@bogus>
References: <20190920163635.9186-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920163635.9186-1-krzk@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Sep 2019 18:36:35 +0200, Krzysztof Kozlowski wrote:
> Convert Samsung Exynos Security SubSystem (SSS) and SlimSSS hardware
> crypto accelerator bindings to DT schema format using json-schema.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Rebased on linux-next due to conflicting change in MAINTAINERS file
> coming through arm-soc tree.
> 
> Changes since v1:
> 1. Add additionalProperties:false
> ---
>  .../bindings/crypto/samsung-slimsss.txt       | 19 ------
>  .../bindings/crypto/samsung-slimsss.yaml      | 47 +++++++++++++++
>  .../bindings/crypto/samsung-sss.txt           | 32 ----------
>  .../bindings/crypto/samsung-sss.yaml          | 58 +++++++++++++++++++
>  MAINTAINERS                                   |  4 +-
>  5 files changed, 107 insertions(+), 53 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.yaml
> 

Applied, thanks.

Rob
