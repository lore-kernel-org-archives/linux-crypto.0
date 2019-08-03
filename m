Return-Path: <SRS0=Wt+L=V7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2701CC31E40
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Aug 2019 14:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D705A2166E
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Aug 2019 14:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jamieiles-com.20150623.gappssmtp.com header.i=@jamieiles-com.20150623.gappssmtp.com header.b="yve9gbrh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388544AbfHCONE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Aug 2019 10:13:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40235 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388759AbfHCONE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Aug 2019 10:13:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so80015968wrl.7
        for <linux-crypto@vger.kernel.org>; Sat, 03 Aug 2019 07:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jamieiles-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NH76ZaePsP0z4l5OXFKg/g6flaC7aHRV+c6EeQ9kS6o=;
        b=yve9gbrhv6FJmbJUZg2guU8pzriDoGRPtUNSqiUWlqQ4TkPhE7DfhQZ1Lvl6wlYKgn
         CUij4lT37fx3UBTzDkqS1of8xRypgfYdRJr/ZTXH9n4ogxbAsHcYxCGIrI95URXflv1g
         FJP9gYfinhrvwugGqlcrYzi3n2ruWV0GhOFk8DMONyy7mf8VlBaevDWMWbiu3MutmmwQ
         QmpvFm+ZUvNuHH0b4aYZwIypRKx4k7GEt4Eb0TgahitiT6Dp+zPrFxSJt1f2evofobtU
         wg0yc6oNTEOJez1sFjYfahVNfvSfG3X1JEqTzitL04k5N+LcsbHTEjXGJOyHEMLK2GEh
         3LLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NH76ZaePsP0z4l5OXFKg/g6flaC7aHRV+c6EeQ9kS6o=;
        b=YQLUvjB6k3Wsr+Gq1maugFe0x+edL/LAhxAAC8rSrTuJYzlP6D+CfAdScgU25Mn/7G
         CYl/pGydMjEPd2UMtQTg9kpUogm82yUnorFtu+NzE0rsTjC5+qB0Q7puD+kKY8Co69BI
         j6XImnnMQ2DY43CZ3StImmrn+Wd7Ht03VPjsFiwn/Lpury4REv4Osm6AJOhEqQzsUHIu
         aK8FAdOAll5iFygDiWzl1J3keRWaNXwL4iQA2fU72gISN5CuFYm1ezupYPAVad41alkU
         4gKK6+DL0TD8+G9FMkk5Ao8v3MV7NGTsIeOYMbxPSyQCkMa/0mWWjKzudw/xfL5OgGIy
         G7Wg==
X-Gm-Message-State: APjAAAV1JqSm0X1rX9wudE6FvE50VEiEmazk1KQrJMg91kxdGw8xWNjC
        Lgi7Z0j7pKQSFwFIJRRZI7k=
X-Google-Smtp-Source: APXvYqwdvvXxz41HQ2tdGIQL/JsFnK1YhppKjv+IAl3mDZiell5PlMgO40s/vhGd/eO9sYQEnXx8mQ==
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr143525518wrs.132.1564841581912;
        Sat, 03 Aug 2019 07:13:01 -0700 (PDT)
Received: from localhost (cpc128704-hawk17-2-0-cust94.know.cable.virginm.net. [82.38.213.95])
        by smtp.gmail.com with ESMTPSA id c65sm80532453wma.44.2019.08.03.07.13.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 03 Aug 2019 07:13:00 -0700 (PDT)
Date:   Sat, 3 Aug 2019 15:13:00 +0100
From:   Jamie Iles <jamie@jamieiles.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     herbert@gondor.apana.org.au, lars.persson@axis.com,
        jesper.nilsson@axis.com, davem@davemloft.net,
        thomas.lendacky@amd.com, gary.hook@amd.com, krzk@kernel.org,
        kgene@kernel.org, antoine.tenart@bootlin.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com, agross@kernel.org,
        heiko@sntech.de, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, clabbe.montjoie@gmail.com,
        mripard@kernel.org, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@axis.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH -next 07/12] crypto: picoxcell - use
 devm_platform_ioremap_resource() to simplify code
Message-ID: <20190803141300.GA26817@willow>
References: <20190802132809.8116-1-yuehaibing@huawei.com>
 <20190802132809.8116-8-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802132809.8116-8-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 02, 2019 at 09:28:04PM +0800, YueHaibing wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Jamie Iles <jamie@jamieiles.com>

> ---
>  drivers/crypto/picoxcell_crypto.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
> index b985cb85..9a939b4 100644
> --- a/drivers/crypto/picoxcell_crypto.c
> +++ b/drivers/crypto/picoxcell_crypto.c
> @@ -1624,7 +1624,7 @@ MODULE_DEVICE_TABLE(of, spacc_of_id_table);
>  static int spacc_probe(struct platform_device *pdev)
>  {
>  	int i, err, ret;
> -	struct resource *mem, *irq;
> +	struct resource *irq;
>  	struct device_node *np = pdev->dev.of_node;
>  	struct spacc_engine *engine = devm_kzalloc(&pdev->dev, sizeof(*engine),
>  						   GFP_KERNEL);
> @@ -1653,8 +1653,7 @@ static int spacc_probe(struct platform_device *pdev)
>  
>  	engine->name = dev_name(&pdev->dev);
>  
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	engine->regs = devm_ioremap_resource(&pdev->dev, mem);
> +	engine->regs = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(engine->regs))
>  		return PTR_ERR(engine->regs);
>  
> -- 
> 2.7.4
> 
> 
