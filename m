Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA499C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707C52064A
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0Aqh/Ft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfCERNH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:13:07 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38423 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfCERNG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 12:13:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id m2so6055393pgl.5;
        Tue, 05 Mar 2019 09:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gcjEsDJtJA/IYbTSY/Tl8E/nSgKLTyvijB58wynQ/z4=;
        b=o0Aqh/FtPGtCM6gV8n1Fs3/1kGHDrOI0Y7e9tVwEzQoD7++w6hC2fHlToaWfKsFHfY
         SMeuYP5LLnMnQ8J3n75KR9p5brHzxWA0iXC9hSp2mJQ4Ht9/NgHbEC94XCLGGJlqX1eY
         +n3uGKy6LUFe1VbVdNusTFpRNyTahIzSU0UMgpwkhttQZYUmX80aR+bddyIzt0eLv4n2
         VVcWYYXWItXxF29BY1ZN1iVfnBUh6cQ3AlGhBRQJ9DkYLQaTW9aJJ7/6RkTIpblJb6Mj
         yIyEB9FHM4vMdRuaWIkumRuUnSOjEzjo5s7+8L9R7W2Y99dnRuY1KxHIM/d4lzIVddYo
         PEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gcjEsDJtJA/IYbTSY/Tl8E/nSgKLTyvijB58wynQ/z4=;
        b=tKRjAORC1VII8UYofm83gXLHgdN2sXyiZ2z1lyhkLcbuRFBKXl4e6enoXg25jgsUkF
         DZwj8IK/nOXI1VnDIW7c3ajqAi501Fo+GgAgnZs1bhXdneJaO3K979q39E/X9GPk2SUf
         DnqKbynpL35SY/x0BL0qAIP6cWwNpm0RTbGpl8K9a6KAA9i4U1wp1ocLviGVzldsJVpA
         Uk9DB/wLMG5bwOsHYdOMmAv3mSCOztjwQNVc1+I3v32fea4KyC1zzMKkF8ofXJ0SQXYe
         JEf1vpr2tFLAooACpwsY8j/QUtz4eOecS1/Kgs3X9kzQZ/tmtWDcj9ZcvIFUadh5DuDU
         FBoQ==
X-Gm-Message-State: APjAAAVIdDZljv1MJ8dhtu6RUrKMto3KI6X+g/JngXH5XVFnOB0SO7fk
        ByZWF7m7VejPYMqssevELXM=
X-Google-Smtp-Source: APXvYqzofMqWTGsEj34eIkorj4U5acVNraPtJzNeIzNCOt4tIwArEAHx6FSVOSa2nj5DCZi3NphvpA==
X-Received: by 2002:a17:902:1621:: with SMTP id g30mr2295855plg.116.1551805985617;
        Tue, 05 Mar 2019 09:13:05 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u67sm13344374pfu.51.2019.03.05.09.13.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 09:13:04 -0800 (PST)
Date:   Tue, 5 Mar 2019 09:13:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 3/3] crypto: s5p: add AES support for Exynos5433
Message-ID: <20190305171303.GA29802@roeck-us.net>
References: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
 <CGME20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526@eucas1p1.samsung.com>
 <20190222122144.19024-4-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222122144.19024-4-k.konieczny@partner.samsung.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 22, 2019 at 01:21:44PM +0100, Kamil Konieczny wrote:
> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
> 
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 0064be0e3941..3f45cc5cb94a 100644
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
> +	const char			*clk_names[];

This array does not have a fixed size.

>  };
>  
>  struct s5p_aes_reqctx {
> @@ -296,6 +298,7 @@ struct s5p_aes_ctx {
>  struct s5p_aes_dev {
>  	struct device			*dev;
>  	struct clk			*clk;
> +	struct clk			*pclk;
>  	void __iomem			*ioaddr;
>  	void __iomem			*aes_ioaddr;
>  	int				irq_fc;
> @@ -384,11 +387,19 @@ struct s5p_hash_ctx {
>  static const struct samsung_aes_variant s5p_aes_data = {
>  	.aes_offset	= 0x4000,
>  	.hash_offset	= 0x6000,
> +	.clk_names	= { "secss", },

In this instantiation, there is no [1] element.

>  };
>  
>  static const struct samsung_aes_variant exynos_aes_data = {
>  	.aes_offset	= 0x200,
>  	.hash_offset	= 0x400,
> +	.clk_names	= { "secss", },

and neither is here.

> +};
> +
> +static const struct samsung_aes_variant exynos5433_slim_aes_data = {
> +	.aes_offset	= 0x400,
> +	.hash_offset	= 0x800,
> +	.clk_names	= { "pclk", "aclk", },
>  };
>  
>  static const struct of_device_id s5p_sss_dt_match[] = {
> @@ -400,6 +411,10 @@ static const struct of_device_id s5p_sss_dt_match[] = {
>  		.compatible = "samsung,exynos4210-secss",
>  		.data = &exynos_aes_data,
>  	},
> +	{
> +		.compatible = "samsung,exynos5433-slim-sss",
> +		.data = &exynos5433_slim_aes_data,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
> @@ -2208,18 +2223,39 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  			return PTR_ERR(pdata->ioaddr);
>  	}
>  
> -	pdata->clk = devm_clk_get(dev, "secss");
> +	pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
>  	if (IS_ERR(pdata->clk)) {
> -		dev_err(dev, "failed to find secss clock source\n");
> +		dev_err(dev, "failed to find secss clock %s\n",
> +			variant->clk_names[0]);
>  		return -ENOENT;
>  	}
>  
>  	err = clk_prepare_enable(pdata->clk);
>  	if (err < 0) {
> -		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
> +		dev_err(dev, "Enabling clock %s failed, err %d\n",
> +			variant->clk_names[0], err);
>  		return err;
>  	}
>  
> +	if (variant->clk_names[1]) {

This results in

[   31.721963] Unhandled fault: page domain fault (0x01b) at 0x00004000
[   31.722417] pgd = (ptrval)
[   31.722611] [00004000] *pgd=00000000
[   31.723519] Internal error: : 1b [#1] PREEMPT SMP ARM
...
[   31.753264] [<c0be9978>] (strcmp) from [<c08cad50>] (of_property_match_string+0x58/0xd0)
[   31.754012] [<c08cad50>] (of_property_match_string) from [<c061eaac>] (of_clk_get_hw+0x5c/0x114)
[   31.754731] [<c061eaac>] (of_clk_get_hw) from [<c061656c>] (clk_get+0x34/0x74)
[   31.755397] [<c061656c>] (clk_get) from [<c0615dd8>] (devm_clk_get+0x3c/0x6c)
[   31.756018] [<c0615dd8>] (devm_clk_get) from [<c08b3298>] (s5p_aes_probe+0xcc/0x508)
[   31.756892] [<c08b3298>] (s5p_aes_probe) from [<c06e6740>] (platform_drv_probe+0x48/0x98)
[   31.757571] [<c06e6740>] (platform_drv_probe) from [<c06e40a4>] (really_probe+0x2bc/0x408)
[   31.758245] [<c06e40a4>] (really_probe) from [<c06e43a4>] (driver_probe_device+0x78/0x1cc)
[   31.758913] [<c06e43a4>] (driver_probe_device) from [<c06e4764>] (device_driver_attach+0x58/0x60)
[   31.759578] [<c06e4764>] (device_driver_attach) from [<c06e483c>] (__driver_attach+0xd0/0x168)
[   31.760010] [<c06e483c>] (__driver_attach) from [<c06e1e38>] (bus_for_each_dev+0x74/0xb4)
[   31.760354] [<c06e1e38>] (bus_for_each_dev) from [<c06e3174>] (bus_add_driver+0x174/0x210)
[   31.760697] [<c06e3174>] (bus_add_driver) from [<c06e572c>] (driver_register+0x74/0x108)
[   31.761039] [<c06e572c>] (driver_register) from [<c010325c>] (do_one_initcall+0x90/0x428)
[   31.761390] [<c010325c>] (do_one_initcall) from [<c1001318>] (kernel_init_freeable+0x42c/0x4cc)
[   31.761752] [<c1001318>] (kernel_init_freeable) from [<c0bf3ae8>] (kernel_init+0x8/0x118)
[   31.762093] [<c0bf3ae8>] (kernel_init) from [<c01010b4>] (ret_from_fork+0x14/0x20)

when booting one of the "old" platforms where variant->clk_names[1]
points beyond the end of the array.

Guenter

> +		pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
> +		if (IS_ERR(pdata->pclk)) {
> +			dev_err(dev, "failed to find clock %s\n",
> +				variant->clk_names[1]);
> +			err = -ENOENT;
> +			goto err_clk;
> +		}
> +
> +		err = clk_prepare_enable(pdata->pclk);
> +		if (err < 0) {
> +			dev_err(dev, "Enabling clock %s failed, err %d\n",
> +				variant->clk_names[0], err);
> +			goto err_clk;
> +		}
> +	} else {
> +		pdata->pclk = NULL;
> +	}
> +
>  	spin_lock_init(&pdata->lock);
>  	spin_lock_init(&pdata->hash_lock);
>  
> @@ -2295,8 +2331,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	tasklet_kill(&pdata->tasklet);
>  
>  err_irq:
> -	clk_disable_unprepare(pdata->clk);
> +	if (pdata->pclk)
> +		clk_disable_unprepare(pdata->pclk);
>  
> +err_clk:
> +	clk_disable_unprepare(pdata->clk);
>  	s5p_dev = NULL;
>  
>  	return err;
> @@ -2323,6 +2362,9 @@ static int s5p_aes_remove(struct platform_device *pdev)
>  		pdata->use_hash = false;
>  	}
>  
> +	if (pdata->pclk)
> +		clk_disable_unprepare(pdata->pclk);
> +
>  	clk_disable_unprepare(pdata->clk);
>  	s5p_dev = NULL;
>  
