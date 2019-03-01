Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB09C43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 14:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E9292084F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551449966;
	bh=t99BW6mR9B3G7g9uDs5UKsOOZe7MrNKyijbNAv48ZY8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=a93hFZnTevwpUWVC3bX+tsVK9hsdtzAH4Z5f36oJ4o37/hJh5DwQW2l0geMERprwd
	 0QOsps6n8EKlRJwfqYfSDp4hTOxfnGhKYwWtvt4v4cBZQ6icNd+favmCHVFV0U0LHq
	 Wvptv4cbIDTIzWqXBxzTuEdtiD2OFANzCsXK1PW0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbfCAOTZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbfCAOS0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 09:18:26 -0500
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE432186A;
        Fri,  1 Mar 2019 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551449905;
        bh=t99BW6mR9B3G7g9uDs5UKsOOZe7MrNKyijbNAv48ZY8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ct01i9Vx/TfZQAq7ZC03Gt/2zM7EghWpqRjuLxDEfzva/qlrYWUjEuU1bH0JjxdIX
         OJg8eeVNjZdV8BI96xjNqaQPSdjIDSwAp82khQM5/osIqyby2L/W0ZSUonYMqZn+0w
         rQWhYw2wmTMinf3zd6cxkUi3Bd2DZPh+G2S+Tkqo=
Received: by mail-lj1-f169.google.com with SMTP id v16so20500037ljg.13;
        Fri, 01 Mar 2019 06:18:25 -0800 (PST)
X-Gm-Message-State: APjAAAWPc77qehiHiYPMDhLgiwWDZRELvTELprqX/Tn/I1F9oaCRKwBK
        s4XGAHvbRBa/K5P5FFxYVBA66cTQ2svjQhGOx8E=
X-Google-Smtp-Source: APXvYqxm0kjq+nlbZi5KOWINFcK/d8bEEg8N1K2JS0rBeHTaQgEYCH5hY27x+ZJIjO86TUZP0jYNKnanwPDDuGPg22Q=
X-Received: by 2002:a2e:780a:: with SMTP id t10mr2499245ljc.19.1551449903224;
 Fri, 01 Mar 2019 06:18:23 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190301140321eucas1p2bf17a6e35d29e8d5f582a2d99fbf4c83@eucas1p2.samsung.com>
 <20190301140254.19341-1-k.konieczny@partner.samsung.com>
In-Reply-To: <20190301140254.19341-1-k.konieczny@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 1 Mar 2019 15:18:11 +0100
X-Gmail-Original-Message-ID: <CAJKOXPc_=Y=FNZXuDnVh72Wxt_+MS+jonVW7pb+vXiJ-ctGCvw@mail.gmail.com>
Message-ID: <CAJKOXPc_=Y=FNZXuDnVh72Wxt_+MS+jonVW7pb+vXiJ-ctGCvw@mail.gmail.com>
Subject: Re: [PATCH] crypto: s5p-sss - fix AES support for Exynos5433
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 1 Mar 2019 at 15:03, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Commit 0918f18c7179 ("crypto: s5p - add AES support for Exynos5433")
> introduced bug in dereferencing clk_names[1] on platforms different from
> Exynos5433. On Exynos board XU3 call trace is:
>
> "Unable to handle kernel paging request at virtual address 00004000"
> (strcmp) from [<c0774014>] (of_property_match_string+0x58/0xd0)
> ...
> (devm_clk_get) from [<c075c248>] (s5p_aes_probe+0xd4/0x4a0)
> (s5p_aes_probe) from [<c059dbc4>] (platform_drv_probe+0x6c/0xa4)
>
> Fix this by setting array clk_names size to 2.
>
> Fixes: 0918f18c7179 ("crypto: s5p - add AES support for Exynos5433")
> Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for fast fix!

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested on Exynos5422 Odroid HC1:
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
