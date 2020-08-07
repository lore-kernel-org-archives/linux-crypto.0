Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B53C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7BA2075D
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHGQ0u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:26:50 -0400
Received: from out28-3.mail.aliyun.com ([115.124.28.3]:44450 "EHLO
        out28-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgHGQ0u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:26:50 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0573539-0.00331743-0.939329;FP=0|0|0|0|0|-1|-1|-1;HT=e01l07447;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.IE4qTTc_1596817601;
Received: from 192.168.10.205(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.IE4qTTc_1596817601)
          by smtp.aliyun-inc.com(10.147.43.95);
          Sat, 08 Aug 2020 00:26:42 +0800
Subject: Re: [crypto:master 164/167]
 drivers/char/hw_random/ingenic-rng.c:118:1-6: WARNING: invalid free of devm_
 allocated data (fwd)
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
References: <alpine.DEB.2.22.394.2008031525120.35132@hadrien>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <e62b6518-1674-5d4d-25dc-f06f3b7bb46f@wanyeetech.com>
Date:   Sat, 8 Aug 2020 00:26:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2008031525120.35132@hadrien>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Julia,

Thanks for report this.

在 2020/8/3 下午9:26, Julia Lawall 写道:
> Hello,
>
> priv can't be kfreed because it was allocated with a devm function.
>
> julia
>
> ---------- Forwarded message ----------
> Date: Mon, 3 Aug 2020 21:16:25 +0800
> From: kernel test robot <lkp@intel.com>
> To: kbuild@lists.01.org
> Cc: lkp@intel.com, Julia Lawall <julia.lawall@lip6.fr>
> Subject: [crypto:master 164/167] drivers/char/hw_random/ingenic-rng.c:118:1-6:
>      WARNING: invalid free of devm_ allocated data
>
> CC: kbuild-all@lists.01.org
> CC: linux-crypto@vger.kernel.org
> TO: "周琰杰 (Zhou Yanjie)" <zhouyanjie@wanyeetech.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> head:   3cbfe80737c18ac6e635421ab676716a393d3074
> commit: 190873a0ea4500433ae818521cad20d37f9ee059 [164/167] crypto: ingenic - Add hardware RNG for Ingenic JZ4780 and X1000
> :::::: branch date: 3 days ago
> :::::: commit date: 3 days ago
> config: mips-randconfig-c003-20200803 (attached as .config)
> compiler: mipsel-linux-gcc (GCC) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
>
>
> coccinelle warnings: (new ones prefixed by >>)
>
>>> drivers/char/hw_random/ingenic-rng.c:118:1-6: WARNING: invalid free of devm_ allocated data
> # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/commit/?id=190873a0ea4500433ae818521cad20d37f9ee059
> git remote add crypto https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
> git remote update crypto
> git checkout 190873a0ea4500433ae818521cad20d37f9ee059
> vim +118 drivers/char/hw_random/ingenic-rng.c
>
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   82)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   83) static int ingenic_rng_probe(struct platform_device *pdev)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   84) {
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   85) 	struct ingenic_rng *priv;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   86) 	int ret;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   87)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   88) 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   89) 	if (!priv)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   90) 		return -ENOMEM;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   91)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   92) 	priv->base = devm_platform_ioremap_resource(pdev, 0);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   93) 	if (IS_ERR(priv->base)) {
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   94) 		pr_err("%s: Failed to map RNG registers\n", __func__);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   95) 		ret = PTR_ERR(priv->base);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   96) 		goto err_free_rng;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   97) 	}
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   98)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23   99) 	priv->version = (enum ingenic_rng_version)of_device_get_match_data(&pdev->dev);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  100)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  101) 	priv->rng.name = pdev->name;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  102) 	priv->rng.init = ingenic_rng_init;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  103) 	priv->rng.cleanup = ingenic_rng_cleanup;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  104) 	priv->rng.read = ingenic_rng_read;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  105)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  106) 	ret = hwrng_register(&priv->rng);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  107) 	if (ret) {
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  108) 		dev_err(&pdev->dev, "Failed to register hwrng\n");
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  109) 		goto err_free_rng;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  110) 	}
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  111)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  112) 	platform_set_drvdata(pdev, priv);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  113)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  114) 	dev_info(&pdev->dev, "Ingenic RNG driver registered\n");
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  115) 	return 0;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  116)
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  117) err_free_rng:
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23 @118) 	kfree(priv);
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  119) 	return ret;
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  120) }
> 190873a0ea4500 周琰杰 (Zhou Yanjie  2020-07-23  121)
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
