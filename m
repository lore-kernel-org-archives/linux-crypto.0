Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76BBC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 13:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6BF6218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 13:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4ODp44o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfAXNhf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 08:37:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52940 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfAXNhe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 08:37:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id m1so3161207wml.2;
        Thu, 24 Jan 2019 05:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BIDDLjD93Q01EvenNmgx9BUIgFyDjV26ppaBH0sFIj4=;
        b=X4ODp44oi24V/eF5iUqt4WipJz1jPMxQ6jmDloHS9F63EaC3TmeWpbAmVeSY+cMvgX
         mU/TjWgmqMDFXKgz2qRr7OxVxat+8h3m/umvULeEwhrPVcTENZO6qxeRXNTLb6U0VwvT
         DwQ+oFkgLrZ8GUpJloOEsSnhVBi8/0U2ufTVYqrIe1KuRX++V3ggO2meJbHj10Dt3y0+
         lO2ClFNyTUkW9tXhKKdck7UNLtMj+8uf5C1Bak/AQuElf5gu2HWHX89ukTHriBCsfCwy
         e+VDrKE8QCdAZeRftSkE77/Q/InWNzcNc6TsEEad28lra3IE9nTqUil4j3Zdxy80dj0t
         f0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BIDDLjD93Q01EvenNmgx9BUIgFyDjV26ppaBH0sFIj4=;
        b=L4Eovvh5kdq9S5VtkxmsOXlq0Ouucdpigorl17sY9RjfFPH7sFIrxw74rmidJ0IQAT
         ErG8KZ4xP+aGOJt61bxXUlLrZLRVtLPgo5L13tLcxZpZwI+BxYgHDb9ft0FDszBMEUDz
         CV0hW1jZgxPVLDhkSjBmPZx3rO5IH2U+/yFRMLz827SP6AxEXiArsWI+I8wRrCF3qSoL
         EOvAoQrwbftCyzhKcW2lcuqq8zwSX6Nhyg+J4RShNBihiLkcZOk5nYDp8M53mHJK0eZ2
         Rssw8uC8jj8xivqUEEkLD/lhf2umpXYRQxs7gy2LnyD3gHnEn92FlNqc4ZtRbKBL4RV0
         6tlQ==
X-Gm-Message-State: AHQUAuaZPod2x9/p20Oi2KLadRcsmAaSabMkrL+bWYhLKUCL+j7YXKl3
        /NPoN//Dsz6YBXuG5f4gnvY=
X-Google-Smtp-Source: AHgI3IY4yFg8qViBbgaw28arguNMik2Rsz9/FQoYLbwdwF5g7Ioc6CeQxr62tpbmR7cR97tAUZqOog==
X-Received: by 2002:a1c:1b8d:: with SMTP id b135mr2730107wmb.115.1548337052684;
        Thu, 24 Jan 2019 05:37:32 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a132sm71829930wmh.5.2019.01.24.05.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 05:37:31 -0800 (PST)
Date:   Thu, 24 Jan 2019 14:37:29 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 3/3] crypto: s5p: add AES support for Exynos5433
Message-ID: <20190124133729.GB13624@Red>
References: <20190123165533.29645-1-k.konieczny@partner.samsung.com>
 <CGME20190123165551eucas1p1cd99462e3767dbb4feb88b996225ed21@eucas1p1.samsung.com>
 <20190123165533.29645-4-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123165533.29645-4-k.konieczny@partner.samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 23, 2019 at 05:55:33PM +0100, Kamil Konieczny wrote:
> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 0064be0e3941..e2d247f59254 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -232,6 +232,7 @@
>   * struct samsung_aes_variant - platform specific SSS driver data
>   * @aes_offset: AES register offset from SSS module's base.
>   * @hash_offset: HASH register offset from SSS module's base.
> + * @clk_names: names of clocks needed to run SSS IP
>   *
>   * Specifies platform specific configuration of SSS module.
>   * Note: A structure for driver specific platform data is used for future
> @@ -240,6 +241,7 @@
>  struct samsung_aes_variant {
>  	unsigned int			aes_offset;
>  	unsigned int			hash_offset;
> +	char				*clk_names[];

Hello

this could be set as const

Regards
