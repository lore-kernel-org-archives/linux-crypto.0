Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAE4C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 05:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67866323D
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 05:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhKOFKf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 00:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhKOFKb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 00:10:31 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EA6C061766
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 21:07:34 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so25459992otl.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 21:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JfbO/Vsh+loj1RG89WTf7VdfBOnW42pFflx7PRsRXkQ=;
        b=n/JM7h3e9nwNeSPzaXE9vbItKL57qAgSDSFiAdRX7cZ3odTsOfWExwxqIjf5ANgn89
         dtnt8SijDs+SGqg/vwZyhuwB/nq4MB66Dq8jNKP9Hcf4FqxRGjGdxfiehpXcaeGkAup0
         aSQHUFoWo/8IjMwykkYNFLVRqtmuvgQW2z/iOA8+cDu3kuEeLLSaJdY/r7mxjqbtDlku
         aBN+rTJZhV+RsYE9LPR7mvTjIVtf6J0vPTieP5xDwj49fzFO/rx34HBzMp5GN/FrKyBS
         /rD8Q7Kv5L7goFMHKpPz9ij9vjtV3ewzW4658VQ+9NwG/IoFLc57t6/Oc5eUYqlXdLvl
         AtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JfbO/Vsh+loj1RG89WTf7VdfBOnW42pFflx7PRsRXkQ=;
        b=WmIx1N+QWsMwZXEDLmzQe4HeBo/not7OgCJNIy8DYC4JHIeOfIC3zXZ0r++DsrHOsm
         JZTBmGrdSZjSvos7PmkA/+IXIc0aHdNnhMufBChqL8WNCFODBEjNuUYFWLV3JQ3mow2U
         yQdxBNzDWf6W3l4r/pjuAu71alEMGy3VbHR+7xgIeJ6gXaM0PfkY0a3PdpURNNvz6Hn5
         /Wf1d2P6CP0+9ACuNQ2UMJWgq+DV1XMf4CLKP/qjCjRyMaGeX2JQx3iGjOzsVHSYXbjQ
         ruNv22oTuYjUTsoCdf4cqC0ejLG3Ct33B6MzQooHwm/X+lAfP/ZxKxKDZ2p7guDp+jKk
         BtVQ==
X-Gm-Message-State: AOAM533xKqyaASMxOGPub3PBvo2+30+S/oIHJpOxm1HYy9P/qScubPCz
        eLjxqpxtY+vlnKIt7TncORLHnJk3NTPVBacLErlq8LuncrxViA==
X-Google-Smtp-Source: ABdhPJw3u81Kp1TNb6DCto2dC/etUsCZ6hNczuHJzqRM5aSBXNUvVPYDuPkWOK3meU2MTfmU/j5HCkrMB33k2ahSfHE=
X-Received: by 2002:a9d:63d2:: with SMTP id e18mr15420810otl.28.1636952853539;
 Sun, 14 Nov 2021 21:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-16-bhupesh.sharma@linaro.org> <f5b7c89c-3bdd-1e1e-772e-721aa5e95bbf@linaro.org>
In-Reply-To: <f5b7c89c-3bdd-1e1e-772e-721aa5e95bbf@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 15 Nov 2021 10:37:22 +0530
Message-ID: <CAH=2Ntww_yOQL_xE+X=kqpR7j9gzVf4MBjVYntzqBvdcFgw6Hg@mail.gmail.com>
Subject: Re: [PATCH v5 15/22] crypto: qce: Add new compatibles for qce crypto driver
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vladimir,

On Fri, 12 Nov 2021 at 16:06, Vladimir Zapolskiy
<vladimir.zapolskiy@linaro.org> wrote:
>
> Hi Bhupesh,
>
> On 11/10/21 12:59 PM, Bhupesh Sharma wrote:
> > Since we decided to use soc specific compatibles for describing
> > the qce crypto IP nodes in the device-trees, adapt the driver
> > now to handle the same.
> >
> > Keep the old deprecated compatible strings still in the driver,
> > to ensure backward compatibility.
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >   drivers/crypto/qce/core.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> > index 89d9c01ba009..dd2604f5ce6a 100644
> > --- a/drivers/crypto/qce/core.c
> > +++ b/drivers/crypto/qce/core.c
> > @@ -297,8 +297,12 @@ static int qce_crypto_remove(struct platform_device *pdev)
> >   }
> >
> >   static const struct of_device_id qce_crypto_of_match[] = {
> > +     /* Following two entries are deprecated (kept only for backward compatibility) */
> >       { .compatible = "qcom,crypto-v5.1", },
> >       { .compatible = "qcom,crypto-v5.4", },
> > +     /* Add compatible strings as per updated dt-bindings, here: */
> > +     { .compatible = "qcom,ipq6018-qce", },
> > +     { .compatible = "qcom,sdm845-qce", },
> >       {}
> >   };
> >   MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> >
>
> and two more compatibles should be added to the list, see my review
> comment on v5 11/22.

Ok, I will fix this in v6.

Regards,
Bhupesh
