Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE12C77B60
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 11:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjDCLIO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 07:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjDCLIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 07:08:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C59423C
        for <linux-crypto@vger.kernel.org>; Mon,  3 Apr 2023 04:08:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j24so28958052wrd.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Apr 2023 04:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680520085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bptug0IUr53yiSheFLOI8G2Iif+jS74EZZFVW0ghq4Y=;
        b=vreEWXlZbzmDkdbQfhaSTbAF0zBCQML/+uh0/XT61CID87nHXYxLi2ptmfsWCR7FZS
         rd+JBdYxMW4T1r4QbUMScNhtx09lwBNSecJlAIr7j8sZOkodTCCRv4NJpv78+eoMDyJo
         LleEmISnMK5nUIbsrLrudbyB+Ai4e5sO/70RXb5RiEhfeD997/YARfoTge/hXktX6sNS
         bs7Iq8IVtp4DrRq8Xd5HvvELojLB+4y8IDSuhxW9T3gbrjdLf+6Jg7/bUJ4tk88bM6JA
         LcBMnByuGe+3t9LxG+4fuK0E9ipAglBRPcPRiUGuJAVcmovEUl4jA5/JeFvT1zzxAB+y
         ViPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bptug0IUr53yiSheFLOI8G2Iif+jS74EZZFVW0ghq4Y=;
        b=l5yM8jIHCgrg8JqDEYNAPfZ3tQtn/pkgZml989U6ymNeTpt45JeB77bB/kxnPqxtdS
         7oQcmmU1e+vrU/iSx7+gClq/Ntn2lHruaxpi1zoVRjbXt81zfGujISMlOKlcfEq/+JrR
         4+z366St6uJBcGatIdTjFr1mnlJ7Y6ZeTkdlpGOQOdZXpYA52Tq62WYjuq3x9i4Sq2tn
         W4jytEWX+KnK9eXF5jDVfda/V/l+B/sFQXEjPPkjwjFQB+l3e843uJMwsZdbXM68S8n5
         fgeetBlonCYXvMl21Ywg3O+tyeNUfh4iZ4s6wOFTrGzp9XOPZCvmoaw9Lq9W0mYzg4BK
         i6Nw==
X-Gm-Message-State: AAQBX9d90R0O3ZQ/VBiCClLiWSOZs/j47VCsCbsePNtX6rSP7oWNtkqH
        aTA9jATdF690+0Q0i3pWgS+dHUo9OX2ZNvPq217V7w==
X-Google-Smtp-Source: AKy350a35YO64iiFVjm8L45Px3SvEHZQujkKj79U+2xxdb5LSQringWJf/gKcgWkxVo+4wghHg8fc88lKlahPBMtNCg=
X-Received: by 2002:adf:fccb:0:b0:2ce:a8d6:570f with SMTP id
 f11-20020adffccb000000b002cea8d6570fmr7454599wrs.4.1680520085453; Mon, 03 Apr
 2023 04:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
 <20230402100509.1154220-6-bhupesh.sharma@linaro.org> <21eaeea4-4f2e-5ce5-c75b-d74ded8e6e4c@linaro.org>
 <CAH=2NtzKGxzmCq2JTajxWoeRFR+mPnFY3YF5mn0tGt30T7SJoQ@mail.gmail.com> <463a9885-741e-a44a-c6c2-7cf5b0560d2d@linaro.org>
In-Reply-To: <463a9885-741e-a44a-c6c2-7cf5b0560d2d@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 3 Apr 2023 16:37:54 +0530
Message-ID: <CAH=2NtxgxrybNDm7HOBtMjcMk6WM5dMko2GWo8H8Z6F1HgKLrQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/11] dt-bindings: qcom-qce: Fix compatible
 combinations for SM8150 and IPQ4019 SoCs
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, rfoss@kernel.org, neil.armstrong@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Apr 2023 at 16:18, Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>
>
>
> On 3.04.2023 08:15, Bhupesh Sharma wrote:
> > On Mon, 3 Apr 2023 at 11:06, Vladimir Zapolskiy
> > <vladimir.zapolskiy@linaro.org> wrote:
> >>
> >> On 4/2/23 13:05, Bhupesh Sharma wrote:
> >>> Currently the compatible list available in 'qce' dt-bindings does not
> >>> support SM8150 and IPQ4019 SoCs directly which may lead to potential
> >>> 'dtbs_check' error(s).
> >>>
> >>> Fix the same.
> >>>
> >>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> >>> ---
> >>>   Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
> >>>   1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> >>> index e375bd981300..90ddf98a6df9 100644
> >>> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> >>> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> >>> @@ -24,6 +24,12 @@ properties:
> >>>           deprecated: true
> >>>           description: Kept only for ABI backward compatibility
> >>>
> >>> +      - items:
> >>> +          - enum:
> >>> +              - qcom,ipq4019-qce
> >>> +              - qcom,sm8150-qce
> >>> +          - const: qcom,qce
> >>> +
> >>>         - items:
> >>>             - enum:
> >>>                 - qcom,ipq6018-qce
> >>
> >> Two commit tags given for v2 are missing.
> >
> > Cannot get your comment. Please be more descriptive.

> https://lore.kernel.org/linux-arm-msm/333081a2-6b31-3fca-1a95-4273b5a46fb7@linaro.org/

I think Krzysztof mentioned (here:
https://lore.kernel.org/linux-arm-msm/d5821429-032d-e1e6-3a4e-ca19eb4a60ed@linaro.org/)
and I also agree that there is no need to split the enum into const.

Also, I will add the 'Fixes: 00f3bc2db351 ("dt-bindings: qcom-qce: Add
new SoC compatible strings for Qualcomm QCE IP")' tag in the next
version (waiting for more comments before spinning a new version).

Regards,
Bhupesh
