Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED7AC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C6720B1F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564996715;
	bh=3y/xyKQqQxOI/5O7S65myq1HgXxKlZai9ugc4r5PFAs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=H1OfMfqNfmWAgN1g8x54h9T7LEwFYE7DhQ6F1zUC/dfFXpaGGas63+nTxpQ8fI0hq
	 y7lJ5/uBJf/l+tjvwQIJj1l3+QYuqYmwvQ5dayGZE/LFgzQEtNXgeYl3e3VNhX6cEq
	 Rtryoy2hNDBNAAWe4JeFjEhjk5TWWVxz0WIL3MsU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfHEJSb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 05:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfHEJSa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 05:18:30 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0953E21852;
        Mon,  5 Aug 2019 09:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564996710;
        bh=3y/xyKQqQxOI/5O7S65myq1HgXxKlZai9ugc4r5PFAs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZVGEXyWfKHiNU9ykvQl6iP/vhiDaIIbECZVQoz2dbKXg0o9tNCy9OFZbp1ZbwMw5u
         vtFxzrASGVSEXmSa62HUtsG05ILylao9uKfI2n+4eJuhzYlYWjorLeb1C2fe8A23w6
         pGRPWmqT9BT+nmjsc6bnzwIbMDRuMZZZ05gPQ21o=
Received: by mail-lj1-f177.google.com with SMTP id m8so45075826lji.7;
        Mon, 05 Aug 2019 02:18:29 -0700 (PDT)
X-Gm-Message-State: APjAAAVK+cI9wv6keK6YQrY4Oc3DNdk7kVDdURDfIhS26VMtI5qL25Mh
        hylr8P2uIYTSiBr9ll0a1aozz1Z5/GWYgaebzUU=
X-Google-Smtp-Source: APXvYqzggkPHLZ3va+adONzA3B+P4PCDn3noO8lcrGqBRgo8WuH7Fq5Bq7XwbmzdzXRtDWDsIpDJCC30bufng4pCbXM=
X-Received: by 2002:a2e:124b:: with SMTP id t72mr78893429lje.143.1564996708108;
 Mon, 05 Aug 2019 02:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190802132809.8116-1-yuehaibing@huawei.com> <20190802132809.8116-4-yuehaibing@huawei.com>
In-Reply-To: <20190802132809.8116-4-yuehaibing@huawei.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 5 Aug 2019 11:18:17 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfvMLehLn+iNOGDEFvsWc93eShUx0=8fn9JWiBOc7wpFw@mail.gmail.com>
Message-ID: <CAJKOXPfvMLehLn+iNOGDEFvsWc93eShUx0=8fn9JWiBOc7wpFw@mail.gmail.com>
Subject: Re: [PATCH -next 03/12] crypto: exynos - use devm_platform_ioremap_resource()
 to simplify code
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     herbert@gondor.apana.org.au, lars.persson@axis.com,
        jesper.nilsson@axis.com, davem@davemloft.net,
        thomas.lendacky@amd.com, gary.hook@amd.com, kgene@kernel.org,
        antoine.tenart@bootlin.com, matthias.bgg@gmail.com,
        jamie@jamieiles.com, agross@kernel.org, heiko@sntech.de,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        clabbe.montjoie@gmail.com, mripard@kernel.org, wens@csie.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@axis.com,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2 Aug 2019 at 15:31, YueHaibing <yuehaibing@huawei.com> wrote:
>
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/exynos-rng.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
