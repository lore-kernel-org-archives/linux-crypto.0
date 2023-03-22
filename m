Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293BDC6FD1F
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Mar 2023 08:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCVIcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Mar 2023 04:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCVIcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Mar 2023 04:32:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60825C10F
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 01:32:21 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n19so712849wms.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 01:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679473940;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QnZkdiX76ZN4vR+x/LMRxd2A2o1J9Wji75teHmv4ZGg=;
        b=dWVu6SIIh8b+euxhaENPGQzYd8nRA7uF26Ge6FGV3JsAUisKNWU7N5sIui2caEBk3E
         Ba10ioxVisjmg8Dn4S+t5uRM7xYas/Q7XRZkg24/J7o76yC5ABAl3D21DgHvsFdnmJvG
         mB/byZH5fhFbN5ApzqL5rLSyZXS4BYgXMbrHQKGZZ4x1oLoEuws1Fn6D/VKE9QmW59ir
         6pnV8mYg9as87TwK94YjE4vct41hXW9oUCJIw3VG7vBs4P7OciPecd7RX24CmX3us3XW
         YLDY8wwvqInAe10Br8DeqCqi9B+PnJiZdxlX77PksSVaJPhpMSlXy8fqL1VHxiWTVU77
         Nm2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679473940;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QnZkdiX76ZN4vR+x/LMRxd2A2o1J9Wji75teHmv4ZGg=;
        b=jh/o8vJAJJlelWePMKFfBap/rWa6t7+Htn1LcKnurTjKALHe7m7Vmv7ZAZ8ZEX7FBt
         n+etylePxNTwfCMNoWCeENaNcfI00yZiIgplRDa5DJT0WNg5sdBbGQDFuvhI8d0Ef2/w
         IYmWsteIzNVOb4foXufQ9hpZ8L6UOiRvzXLzrwdJpN9Y7owYq8VA69k+FHM0FGk2iX+g
         6ALJj68ko1uN6SvaklRr8KsF9A34f9z7P+yZCxLH+qtnSvsOi09EmIVRypRgDBUbUmUx
         wrsQUyOXG++GaQEyVIfElRzIUx12HrjPD/ughvk2mOqNN/JlsqoreB9cHkjb504Uf7SH
         lvTA==
X-Gm-Message-State: AO0yUKUuQs23LPK764zzRIR5NkyTqpsSRUJt+7/Db7g+N8Eh9xN+tU6x
        3jdeDX8nJa7SLWWzFKcFxtvwkqn8zVTHMzUhA0HMSw==
X-Google-Smtp-Source: AK7set9jbx6IcXCXy5IlWquYuPV9FZa4fN8gjTQ+iLZe9YDGw/vuRit6/77PtV6GsQyRt50mmKUcUXD1tooXXwhGm6o=
X-Received: by 2002:a1c:7c18:0:b0:3ed:d2ae:9aeb with SMTP id
 x24-20020a1c7c18000000b003edd2ae9aebmr1348176wmc.8.1679473940269; Wed, 22 Mar
 2023 01:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230320073816.3012198-1-bhupesh.sharma@linaro.org> <20230321213139.GA1646917-robh@kernel.org>
In-Reply-To: <20230321213139.GA1646917-robh@kernel.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Wed, 22 Mar 2023 14:02:09 +0530
Message-ID: <CAH=2NtxpREHJptSaEmAOLrVQwSJ86TaneOv-MKqnZc-AF-222Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] dt-bindings: qcom-qce: Add compatibles for SM6115 and QCS2290
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, agross@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        andersson@kernel.org, bhupesh.linux@gmail.com,
        linux-crypto@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 22 Mar 2023 at 03:01, Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Mar 20, 2023 at 01:08:16PM +0530, Bhupesh Sharma wrote:
> > Crypto Engine block on Qualcomm SoCs SM6115 and QCS2290
> > do not require clocks strictly, so add compatibles for these
> > SoCs, indicating that they are similar to the flavour
> > found on SM8150.
> >
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > index e375bd981300..e6840d124af3 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > @@ -35,10 +35,12 @@ properties:
> >
> >        - items:
> >            - enum:
> > +              - qcom,sm6115-qce
> >                - qcom,sm8250-qce
> >                - qcom,sm8350-qce
> >                - qcom,sm8450-qce
> >                - qcom,sm8550-qce
> > +              - qcom,qcs2290-qce
>
> 'q' goes before 's'

Ok, will send v2

Thanks,
Bhupesh
