Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AF9C47097
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 03:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA6F6140C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 03:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFDDWD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 23:22:03 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:43945 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhFDDWC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 23:22:02 -0400
Received: by mail-oi1-f182.google.com with SMTP id x196so8043193oif.10
        for <linux-crypto@vger.kernel.org>; Thu, 03 Jun 2021 20:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTLBAwmqsG3vEJ4E4BdrtXVL2NeOeIgl+wmT0+LyvMk=;
        b=AQvU2E2DBR78Ykvj2qLHtpb2LgMH7EVti1dRcbTmuhm5gNebiFl5ExGpyRLziKTFZp
         E95YFVmuiqVwABsG3QViv2WD3FMnjyYBrtHRxXBggGg/+egbDA32c0TVIUdm8KCXJVhi
         x+3T7L/CHVFKHY5dAaLkcx+s+jaxxfvZwWqWfzMapHj6SGcUC6qMRh1IupTyAdWXgdc/
         oFdikrJpH6WKufIMZMVbt49C2FJopa7z6LcOyqGEEQpUaqFqGT7rG93RUz6DWT/4VaKP
         DcL5BwQEWI62dNFNrCC/grf3xmcAEXaBySnaTHppUz4gK9Ed4gJ4MMEIxDAozUOt/cQT
         jADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTLBAwmqsG3vEJ4E4BdrtXVL2NeOeIgl+wmT0+LyvMk=;
        b=t6DEMEWjdhnVs9GosPdJtVfiIlFk3BuxCggq6IrVuQCMUw36+YKpUk/dsy+1op9jH1
         9hjebSB5YRvj2oFV/g6iUh9ODHXpJkBWDRyku7HySZyYqkimDB63SVTVmyd2e/NnJ4Zb
         fpj/7eR20CWLAH4pzoWTqfXXJp8oiRQ8hVEH1K2KsBIbGunKHYf/FFoUJloiPbsEfpnC
         vMf3MbFom1Xhm0JP2trD2bgtrSVt9VrxvITwzVfsBMjyjI9WcuqNHKtTmdsvennXm4Ih
         t4MilFytTzT3UnkSr73aphozWAYblm6otL0KANTcQ8kAw5meHkHVKPWHRPEQlkI167mT
         JJVQ==
X-Gm-Message-State: AOAM531Z+dYBt3BIPBESbftxk3+L3i/eNXx8CsM2lf5ee6H20uJ3uxJp
        9e6WtM/IQK/hbOyQuh6n/5CD5re99k0ZfLQlVLM1fg==
X-Google-Smtp-Source: ABdhPJzcMqINfAPFcCbEC12gkbN5NqzJM1RhTsVmVuiZUMohZbipEZxJMYUD0qnQChKUKe6fRlpUPJq80TheN/gzEcs=
X-Received: by 2002:a05:6808:f0b:: with SMTP id m11mr9178581oiw.12.1622776740786;
 Thu, 03 Jun 2021 20:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org> <162261866806.4130789.17734233133141728573@swboyd.mtv.corp.google.com>
In-Reply-To: <162261866806.4130789.17734233133141728573@swboyd.mtv.corp.google.com>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Fri, 4 Jun 2021 08:48:49 +0530
Message-ID: <CAH=2Ntz7=e8w1fvXtpe-aXUFAreOiyb=xxKvU_1pmzBHyVXitA@mail.gmail.com>
Subject: Re: [PATCH v3 00/17] Enable Qualcomm Crypto Engine on sm8250
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

On Wed, 2 Jun 2021 at 12:54, Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Bhupesh Sharma (2021-05-19 07:36:43)
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Andy Gross <agross@kernel.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Cc: Michael Turquette <mturquette@baylibre.com>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Cc: dmaengine@vger.kernel.org
> > Cc: linux-clk@vger.kernel.org
>
> Can you stop Cc-ing the clk list? It puts it into my review queue when
> as far as I can tell there isn't anything really clk related to review
> here. Or do you need an ack on something?

Sure, I will drop the clk-list from Cc-list of future patchset versions.
Since I had a couple of clk driver changes in v1 which were dropped
starting from v2, I thought it would be good to Cc clk-list for v2
(and so on..)

Thanks,
Bhupesh
