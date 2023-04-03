Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD13C761AF
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 06:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjDCGPb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 02:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjDCGPa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 02:15:30 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D18A65BB
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 23:15:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h17so28036009wrt.8
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 23:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680502526;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OYr1/KuS7kMHwn46ltI5HEmCt5k4aJgWKClGbWF133s=;
        b=NTT03Lm8sZsH76eTG3jdAAaurDzfPUGB/iUpyvrJJCgS/iHAOeP0mrd1UJgq2TUEf4
         PHikextz4mHfKRXGZ4176flEtQA/gWpe9qSMGNQywQtYGkfXzsQxACYuZL2EPyY1WuLH
         zfgdDB7IP0Cq5JaR/05zHCo8WFZZANccGr8a3VV3/ATQhd2bPMp2PGSd3VuyW3TytX/9
         SsoAXEjVr4cLrtTZfufguHJhwRPZxbI4dOyUo11D3Sp2U35r1NGH4GBoT5loZVl4ey+j
         QwbzVdgsaj55u3lJQXWm+Nlm9GErX/1dT51kDE6G5ziC++k4jRAkazihgt5lJheHXYgP
         H1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680502526;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYr1/KuS7kMHwn46ltI5HEmCt5k4aJgWKClGbWF133s=;
        b=hWG+imrgS0xg1Ppnh6x2Cf5JA19pYlzzYTdSrHfVHdjB8pgPHwCixIArrosM6a0r6c
         MBTblrJOW3z8wBH0Jd6yP/PznoZNhwQUCDKTrqnYtBm6iXTgppFUiczlIAeFklezAjnG
         Hne7R2pvlQ1uY9QnFnKGwCh1uPCTm7w8KJ3mjCf47+ToAHxWnMvK9GxRPu17Siw+6voX
         ZFmS4U/UAMv/fd3aq3eZS710WpUosKsBXKyrLlpg+uYN/t5NUwGf0kW3sh+yu9Ro7rje
         ZbcwGCD8Q+HQWmosSF4Xzlb932y67sKGTrkWzgMrEugmgbmRQeEDNz3yOlCjmek2Pm9T
         3CNA==
X-Gm-Message-State: AAQBX9flnt/m5nenqJjPt8oTA7k7R6L5ZW9tjYXTCsELnN9kYwOB4YSS
        YhQOVZSlxxCouhSN40hQSerJ3JdVENdHuZrLNkO+Ow==
X-Google-Smtp-Source: AKy350acf1mfzrEPgp1c2mLaWyYaPeg8MW/g55MD0k5rk9VLpt+743GauRSVo2/m6TW4qS0GzGWVj+lSeid5yNUguIM=
X-Received: by 2002:a05:6000:5c1:b0:2d7:9771:fc4b with SMTP id
 bh1-20020a05600005c100b002d79771fc4bmr4955083wrb.5.1680502526512; Sun, 02 Apr
 2023 23:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
 <20230402100509.1154220-6-bhupesh.sharma@linaro.org> <21eaeea4-4f2e-5ce5-c75b-d74ded8e6e4c@linaro.org>
In-Reply-To: <21eaeea4-4f2e-5ce5-c75b-d74ded8e6e4c@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 3 Apr 2023 11:45:05 +0530
Message-ID: <CAH=2NtzKGxzmCq2JTajxWoeRFR+mPnFY3YF5mn0tGt30T7SJoQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/11] dt-bindings: qcom-qce: Fix compatible
 combinations for SM8150 and IPQ4019 SoCs
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, konrad.dybcio@linaro.org, rfoss@kernel.org,
        neil.armstrong@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Apr 2023 at 11:06, Vladimir Zapolskiy
<vladimir.zapolskiy@linaro.org> wrote:
>
> On 4/2/23 13:05, Bhupesh Sharma wrote:
> > Currently the compatible list available in 'qce' dt-bindings does not
> > support SM8150 and IPQ4019 SoCs directly which may lead to potential
> > 'dtbs_check' error(s).
> >
> > Fix the same.
> >
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >   Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > index e375bd981300..90ddf98a6df9 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > @@ -24,6 +24,12 @@ properties:
> >           deprecated: true
> >           description: Kept only for ABI backward compatibility
> >
> > +      - items:
> > +          - enum:
> > +              - qcom,ipq4019-qce
> > +              - qcom,sm8150-qce
> > +          - const: qcom,qce
> > +
> >         - items:
> >             - enum:
> >                 - qcom,ipq6018-qce
>
> Two commit tags given for v2 are missing.

Cannot get your comment. Please be more descriptive.

Thanks,
Bhupesh
