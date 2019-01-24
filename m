Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4108C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E0F2184C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548340756;
	bh=4duOeQSex3XwiwRKUwmpYPoGccLYgHg9ZxkXUYHxtX4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=bYtCQz1SlLv7sAuFt2dnxL7V3svT4UnQ9lB3hDAYaG57JsG5xqDEeWfmLaOmjOsb1
	 byOi4dCEZvOftpoag9uHeasT97oTOv+dAVoQa+dAwAdTunghHyklYgClRV5AEXY6JX
	 48oKCUtdMAf6/z3XenAmqkPHNuV5N0dG8c+yrJ0E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfAXOjP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbfAXOjP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 09:39:15 -0500
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66056218C3;
        Thu, 24 Jan 2019 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548340754;
        bh=4duOeQSex3XwiwRKUwmpYPoGccLYgHg9ZxkXUYHxtX4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=K4EcFmutw6O/0d8BtTHIHx8DAljV6i4/fcUuMCqyaC284ODGqJ3AgoodMRxUCnW/o
         L+c5hrWoEkpKKohKLERvoub8Pf+cYfH8J6jeW/pDrFE6ogsqTIulmCs2injuNFpYuh
         3W2vkH7lU57clSPJFAUDtKEpBuxAxBx/3iAN6En4=
Received: by mail-lf1-f41.google.com with SMTP id a8so4470591lfk.5;
        Thu, 24 Jan 2019 06:39:14 -0800 (PST)
X-Gm-Message-State: AJcUukfoGL0bdum/U97eG73Dx6upUGPYD985sptnLTHb0j2M4+90FYgY
        ocrFsey6pTqpZcOJO4ezsjX+9Kn9VeC2Ru2k1EU=
X-Google-Smtp-Source: ALg8bN50jp7Hcd7+65Oo5SDKZ6C5iDjFlR1EeKfqXx123CBvkoOlGgNr07N7n7QXJKU6YesC7ax0Uabhv+c3mI+xSjg=
X-Received: by 2002:a19:4948:: with SMTP id l8mr5894422lfj.156.1548340752471;
 Thu, 24 Jan 2019 06:39:12 -0800 (PST)
MIME-Version: 1.0
References: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
 <CGME20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21@eucas1p1.samsung.com>
 <20190123165533.29645-4-k.konieczny@partner.samsung.com> <20190124133729.GB13624@Red>
 <75f3be00-8035-0586-1611-99e5da53a8e7@partner.samsung.com>
In-Reply-To: <75f3be00-8035-0586-1611-99e5da53a8e7@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 24 Jan 2019 15:39:01 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdPM_PpVPjJUTdg2_nJ1R2o2Rt1-XA8rPi=bLMrXeQeqw@mail.gmail.com>
Message-ID: <CAJKOXPdPM_PpVPjJUTdg2_nJ1R2o2Rt1-XA8rPi=bLMrXeQeqw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] crypto: s5p: add AES support for Exynos5433
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Jan 2019 at 15:34, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
>
>
> On 24.01.2019 14:37, Corentin Labbe wrote:
> > On Wed, Jan 23, 2019 at 05:55:33PM +0100, Kamil Konieczny wrote:
> >> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
> >>
> >> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> >> ---
> >>  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
> >>  1 file changed, 46 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> >> index 0064be0e3941..e2d247f59254 100644
> >> [...]
> >> @@ -240,6 +241,7 @@
> >>  struct samsung_aes_variant {
> >>      unsigned int                    aes_offset;
> >>      unsigned int                    hash_offset;
> >> +    char                            *clk_names[];
> >
> > Hello
> >
> > this could be set as const
>
> Definitions sets const:
>
> grep "static const" drivers/crypto/s5p-sss.c
>
> static const struct samsung_aes_variant s5p_aes_data = {
> static const struct samsung_aes_variant exynos_aes_data = {
> static const struct samsung_aes_variant exynos5433_slim_aes_data = {
>
> so it is not needed at struct declaration, or am I missing something ?

The struct contains the pointer, so the pointer will be const. However
the pointer can point to either const string or non-const string.
That's the Corentin's comment about. So in fact as he says - this
should be a pointer to a const string.

Best regards,
Krzysztof
