Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC94C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50DF620C09
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599211068;
	bh=Z3k+bA8kO3IZhxobmWH376bAC5FOT43FtDu9S5oDfrs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=si3RC/ObI0+l/JQyzj9Sq9V5uCsJPXHL1/MvoLoS6zZg4pPdqjSCrQNPePGN940We
	 5WvTnS3IQ+l33UiCYT5bfqPZB22qj3hon0vMpC2EWzXQhKZvl12w/HeiGbKBdpsQEy
	 lg4M1I1ms9G7pZPsJp0RX50W9F8B5juNJ7kOGEzE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgIDJRo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730040AbgIDJRl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:17:41 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F420208C7;
        Fri,  4 Sep 2020 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599211060;
        bh=Z3k+bA8kO3IZhxobmWH376bAC5FOT43FtDu9S5oDfrs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NtqWR9ZrdQ23oNQrwi4r9Q4DRrbPT2le37xve7njDICv2D1PQ3Uw3ThOXP/I275YU
         vm+XptMcyEE0l0gpzBNaXOQfeVQfHpbcWpIjqc9OFTMUe9y4QIESB7XfmCc6kNQnt9
         s5JZtqFsCyrNQi6H+eP9WRzcIIq3Q07s1R5XIwW8=
Received: by mail-ej1-f44.google.com with SMTP id a15so7589417ejf.11;
        Fri, 04 Sep 2020 02:17:40 -0700 (PDT)
X-Gm-Message-State: AOAM530xfb9eDu5ZFYvmLmSc26UUdZUrTYfsEAAj6RmgfS+IsdhubB8c
        hjb72kKKedIuyFQuHPxVAv+s8wI4G20AbuCvKSk=
X-Google-Smtp-Source: ABdhPJwJGfE8pXwFD7YLIbqax+LSzRBe+8KCTVQf60jQGIYocFyzOcadCMDWhZ+17124hHHCNMwHJkOHoa7/Q2M1V/Q=
X-Received: by 2002:a17:906:af53:: with SMTP id ly19mr6165007ejb.503.1599211058977;
 Fri, 04 Sep 2020 02:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200903180412eucas1p10d854b51ba650b27265f088b07c93b15@eucas1p1.samsung.com>
 <20200903180400.2865-1-krzk@kernel.org> <3b8f5c30-a669-c228-5835-5e4efa431879@samsung.com>
In-Reply-To: <3b8f5c30-a669-c228-5835-5e4efa431879@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 4 Sep 2020 11:17:27 +0200
X-Gmail-Original-Message-ID: <CAJKOXPdWWsgG3Y2DeLctT=8y31=2ari-qN2BUAYU7CvE-pfbJg@mail.gmail.com>
Message-ID: <CAJKOXPdWWsgG3Y2DeLctT=8y31=2ari-qN2BUAYU7CvE-pfbJg@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: crypto: slimsss: Correct a typo in compatible
To:     Kamil Konieczny <k.konieczny@samsung.com>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Sep 2020 at 11:07, Kamil Konieczny <k.konieczny@samsung.com> wrote:
>
>
>
> On 9/3/20 8:03 PM, Krzysztof Kozlowski wrote:
> > Correct a typo in the compatible - missing trailing 's'.
> >
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
> > index 04fe5dfa794a..7743eae049ab 100644
> > --- a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
> > @@ -19,7 +19,7 @@ description: |+
> >  properties:
> >    compatible:
> >      items:
> > -      - const: samsung,exynos5433-slim-ss
> > +      - const: samsung,exynos5433-slim-sss
> >
> >    reg:
> >      maxItems: 1
> >
>
> Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
> Acked-by: Kamil Konieczny <k.konieczny@samsung.com>

Thanks. In this case "Reviewed" is enough, it includes the meaning of Ack.

Best regards,
Krzysztof
