Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FA1C5519F
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A54424671
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wFoI1MdR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKRD5x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 22:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKRD5w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 22:57:52 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AE9C061A51
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 19:57:52 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id k26so763090oiw.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 19:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hkDeDVPm8z3EEtXMYErIWAIVmmPC1Ustb1AIjufsLc0=;
        b=wFoI1MdRD5qXEw9klmnXnEr5A5oE1AZidmWSZsCcbu6NDwrIUF8mwmItUnRy/YtLz/
         VmKl2Ez3rutkqcvMMEK+kHmeRoAzZmQBlLnCyZAM/NvcR3tYpTNA27xmDQ+kc4+RUmf+
         nujIzRvHKDk4ruhDUWPkxJ724BuUfFBTiQv5iMWdr1DFIKXBJLPXJZwww6fAu5tIau0v
         wLxq7ceE2NdGb5tIKMt1kr8wJQJNzp1h+eed3qF9QXvjFnfILguS7pFo/pkN1T9J3R8H
         +zwUUNX6tCHnJj1hUKBl/SFYNZ9Hw1bPTNhGOwpmYeLjuj44CO+ck0mTaxoklucJnxhn
         tgdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hkDeDVPm8z3EEtXMYErIWAIVmmPC1Ustb1AIjufsLc0=;
        b=Or1GFEJsmhrPxVTxRGOxZs1WgYxOco6PbHV/wRJwJ+JUuI2JnWE2p8JrlgJtMgSUiw
         L2Ml5a704fUgeNJAfouJAucSg4BPzsjmYjCBASsxyS4eK3HLOycUtpeN54y6+Q+sY/U8
         7HC1coJW8sxwdVX8GKFSzjV1c37c71lLBlCp6uN69XpsFrpT9GfddzJiIe19VH+XsarX
         g0yCsWONmOz0zK8fScjg+eLS0l3QJFioqAHnJJptjVg1lteLij1G0CKIrLCQQZPtorgk
         4OQ1Zpl0DNQektTcfT/m2lWO0CdQYNAIuu0rGSbhvsAHFeduqpV8uMeui1v90iWxlf4X
         mjbw==
X-Gm-Message-State: AOAM533pMV19+HsfIXO2py8WGeIpulEcGXaxmOFHyMYdfU5MaRL+9J61
        amJGTi/wkRJso/HTWhR3uUTbSw==
X-Google-Smtp-Source: ABdhPJwLmLk02pk40nH7Brt4vanivaBwUWCxNW1iVUgWOy150NbSyLeuVbLBhM4ywuL4y+NA1uewew==
X-Received: by 2002:aca:4a0d:: with SMTP id x13mr1595258oia.155.1605671871907;
        Tue, 17 Nov 2020 19:57:51 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id w6sm6868012otj.12.2020.11.17.19.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 19:57:51 -0800 (PST)
Date:   Tue, 17 Nov 2020 21:57:49 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh+dt@kernel.org, sboyd@kernel.org,
        mturquette@baylibre.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH 1/6] dt-binding:clock: Add entry for crypto engine RPMH
 clock resource
Message-ID: <20201118035749.GA8532@builder.lan>
References: <20201117134714.3456446-1-thara.gopinath@linaro.org>
 <20201117134714.3456446-2-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117134714.3456446-2-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue 17 Nov 07:47 CST 2020, Thara Gopinath wrote:

> Add clock id forc CE clock resource which is required to bring up the
> crypto engine on sdm845.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>

$subject should have bindings in plural to match other changes and a
space after the ':'

Apart from that, things looks good.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  include/dt-bindings/clock/qcom,rpmh.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/dt-bindings/clock/qcom,rpmh.h b/include/dt-bindings/clock/qcom,rpmh.h
> index 2e6c54e65455..30111c8f7fe9 100644
> --- a/include/dt-bindings/clock/qcom,rpmh.h
> +++ b/include/dt-bindings/clock/qcom,rpmh.h
> @@ -21,5 +21,6 @@
>  #define RPMH_IPA_CLK				12
>  #define RPMH_LN_BB_CLK1				13
>  #define RPMH_LN_BB_CLK1_A			14
> +#define RPMH_CE_CLK				15
>  
>  #endif
> -- 
> 2.25.1
> 
