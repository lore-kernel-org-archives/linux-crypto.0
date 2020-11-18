Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997EAC6369E
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 04:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5D72465E
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 04:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QQxY3p7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgKREIs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 23:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgKREIs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 23:08:48 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FD7C061A51
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 20:08:47 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id l36so492860ota.4
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 20:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OFlGs4mKDX02PSiyPJiMC0bb+xNxk/N/G1k1e5peRxM=;
        b=QQxY3p7I4RHFjrJTNkalSyBx+aIXUj8ijk/Babr2vzHpUep7XKzj77fta6TtzebgCu
         54w0M3ZVHkJ7tSZJaQFR13s4eDVIVnuggLxxAX/z9ETdmoCw7xAt0Za8Y6X241m2BeFH
         3Er2KD5uQ9DeDGOB62xwTWlctLYgh74cMeJ5dJribRHezlK2WOR/0WPuzzI0l6M4WEjk
         zIqI92EjKqkBWA+foxnWcitA3s9/AQwyndns11yV9uHU7TQnSCWdcfqA4ytclWb0VxOP
         w3kBDZUlO6Ay3K/vVQQILFpKML26QLRUiIpvcrwjgXFFzKDAlSmB24By6DeNLtaItTfU
         j4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFlGs4mKDX02PSiyPJiMC0bb+xNxk/N/G1k1e5peRxM=;
        b=rKG2vFZoiq5lHw4Eq6ZzunJ2nTdoN8ezcq9ALqvFhZ0yhUMe5kxRZfwXxYHef7NovW
         2qPD+480y0+57rT3B4umAWa7U/5oWayXEfMziOD/SGyJYZbhak3H5j1PPUmzqh+iNbo2
         oeICW7Bp6y8UBnr8TthHo4ke8gupmorkGM/k1SziAZXN/RpZ/1FBmiIxYV1CZsooSw9q
         jIuyfYt+ct1daRdBhnZPaENw8HANQ1rPn1aO112CzzP76xRhr7B0DVCEoLmRMGyTdC9I
         Accy3hhqba1r8Z7bK+WmvqcN+cmskFI3eR4uL/BnYaXLAK5Y8zdwQ9z39VSU3OFvtotH
         Bd/A==
X-Gm-Message-State: AOAM532yFy4X8pHApHG20JhPd7LQabmXQzxZrNFTVioqRP/h5uYvvyYA
        KTtV6W6sOwIaKIq1m0kkbKDU3qx8d3R/zQ==
X-Google-Smtp-Source: ABdhPJxXjhnt+l7S4mf68h2a9v6ouX5XJ/FbYDzULaWBwyywmHfA/8h64fZ+7LNab2guhsIUdYyfpw==
X-Received: by 2002:a9d:268:: with SMTP id 95mr5025458otb.27.1605672527061;
        Tue, 17 Nov 2020 20:08:47 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a4sm6447099otj.29.2020.11.17.20.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 20:08:46 -0800 (PST)
Date:   Tue, 17 Nov 2020 22:08:44 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh+dt@kernel.org, sboyd@kernel.org,
        mturquette@baylibre.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH 6/6] devicetree:bindings:crypto: Extend qcom-qce binding
 to add support for crypto engine version 5.4
Message-ID: <20201118040844.GE8532@builder.lan>
References: <20201117134714.3456446-1-thara.gopinath@linaro.org>
 <20201117134714.3456446-7-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117134714.3456446-7-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue 17 Nov 07:47 CST 2020, Thara Gopinath wrote:

> Add compatible string to support v5.4 crypto engine.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>

$subject should be "dt-bindings: crypto: ..." and you should try to stay
within 50 chars for the subject. So how about something like:

"dt-bindings: crypto: qcom-qce: Add v5.4 to binding"

With something like that:
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
> index fdd53b184ba8..ed1ede9c0acc 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
> @@ -2,7 +2,9 @@ Qualcomm crypto engine driver
>  
>  Required properties:
>  
> -- compatible  : should be "qcom,crypto-v5.1"
> +- compatible  : should be
> +		"qcom,crypto-v5.1" for ipq6018
> +		"qcom,crypto-v5.4" for sdm845
>  - reg         : specifies base physical address and size of the registers map
>  - clocks      : phandle to clock-controller plus clock-specifier pair
>  - clock-names : "iface" clocks register interface
> -- 
> 2.25.1
> 
