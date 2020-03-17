Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9D4C10F29
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 16:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19CB220738
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 16:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IsVe3PCt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgCQQpg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 12:45:36 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:62592
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgCQQpg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 12:45:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuHb2k/NpjFJD1cN+JtGXzkh2/mXHCrSpKOEH5cjDLL0g6qgZqAWzWyDJxWnTsLNvDb7xZJF1QLSQLRrQNLBqBhhvXxNIleTd4bI6NtjukAkA1PjMISU6fF6kqUW0872gdUOISXh8NrVzdloaFk053q5TbQPomFI4H57muz7q85pFloo+Ii/vA2xCel67m/kRCXFzNVbBALtNWRxr6S8Ll3e09pXxn5vicRHKv9+V1Fq4PaUrdmbreYa6bc1lIcWL2O8AuYpEjZijju/T9nDVT9cqGiHbCW9QIGvKkDhn9LudM3chbwpMFOMXRfiyTzAJW8M2xz8ZyRNWltiR0pRrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJ8q/7An/zFH2oP4PFfQd5wQwEVpidm2fZBwn7r454Y=;
 b=EvnZVJCZgZWvs6i6J96Q3WZnYG4Cl3PlUnmuhRQLw1uWCaPGd/AT8tgcrUxy76KEnMjiS4mAGTBm76uioK+US5WYpWAKsmgZyNeTDmVqqh12DQRFCaXrnWrWLVLSeQdUoJauXBy2T1Hy9jmu1nrTYJqDHC9ZDpSRs0sYzuAMu0eoDHzJU+vu8yRekIyAdhY1EFclH4Os7POBfJTXyh5njhL0DdXr/aNtmKfHTr0qhANzv8ZcZkTN38RSgvOBG48LP2f1dQgzPnzmpbD9AE0N0bqEcjmdI6r42UoDnIlOW7x7ZjoLico27wSKjEbXXxDE+9LUttmKpB5u0yNE+2Ap9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJ8q/7An/zFH2oP4PFfQd5wQwEVpidm2fZBwn7r454Y=;
 b=IsVe3PCthqRnWG5Xa4tvtLJ8KrcwdXByH+wxI+rIZ0WoeMlosA8tUR7TeABpLbYMGKtgPZotU6dKSN8kV0WzDoRbEn4B+3qW/yDVXjUZJqIzEAsnTD8+tGds/wUNGaWlQYwifkli3hmHFeoOFOTqEyuXqLBjuxpwyh9LBI96Rzc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3951.eurprd04.prod.outlook.com (52.134.13.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Tue, 17 Mar 2020 16:45:32 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 16:45:32 +0000
Subject: Re: [PATCH v8 3/8] crypto: caam - drop global context pointer and
 init_done
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-4-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <49971beb-0681-de92-95f5-b18e1be05ce3@nxp.com>
Date:   Tue, 17 Mar 2020 18:45:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-4-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:205::20)
 To VI1PR0402MB3485.eurprd04.prod.outlook.com (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:205::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Tue, 17 Mar 2020 16:45:31 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 16a3ed67-0b6f-45b3-bb33-08d7ca929b71
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3951:|VI1PR0402MB3951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3951F2CFD485F50E285B99A398F60@VI1PR0402MB3951.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(16576012)(31696002)(86362001)(52116002)(2616005)(5660300002)(956004)(2906002)(53546011)(6486002)(186003)(54906003)(16526019)(31686004)(8936002)(498600001)(26005)(36756003)(4326008)(110136005)(8676002)(81156014)(81166006)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3951;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05Axj4bRB83wPCyzSrepStSivxn8ocCmiOBTgO5o2qqN3TqrFwiXAa+KXB5bIMW1tMeP/uJ7gdAfWtTinpwj/avz4yp7hIfllh6I9QH3dPdToNuBiFHDQHt1XljUx72jPoyjjmEN7hbWrRylZkoUQnbHB8Cnt0tyvPNWTPQj/UuDFP6jHuKQhUGhvbpDWqi9FVShYUpFiDmPOXhy0edNPnAXC5Fp7aSQlFIE/ZNwZxnJW3GS5ls5xLsCqFH4YJFzEyQhdl0V3KkXbTNCRlh4HNZv32OeGNB+1iK8SB2G06Bh70zqvpwM6ofnQ+Ma6y8C5HvxOor8yIe6sh8EEjnf+BiXnL8xcps3nR4rwB82f9RULPXwFfAFKTbFTEcnNyDZOITpDP4UPgNkSOllq4qsKmxd+G4HXxHUPI+ZKwG27z0DRP8ieOWLLiuHTechvP1E
X-MS-Exchange-AntiSpam-MessageData: UxJoMBBHlOpgXZ9ir0F1y6dsuO11aVj6XvLO4v/Q+5NkFBq7DT2ZdeB3C+KL+oKqXweEOVZCcHNuvpZonMhTbWSAe6RZSXpn4E+EK+BfQCtcNS/0zq1ZoENNOXuGu6zp40OFXwZRnf818OeTxHXamQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a3ed67-0b6f-45b3-bb33-08d7ca929b71
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 16:45:32.1140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cvvf096ak7GZ3936nKRYYAt2zMViV3tgjW6yeoJANDmNGgsOZYWXVOgZWpxe2RAoz/0w3eRykFr+fZQ24GTRoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3951
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 69a02ac5de54..753625f2b2c0 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -70,6 +70,7 @@ struct buf_data {
>  
>  /* rng per-device context */
>  struct caam_rng_ctx {
> +	struct hwrng rng;
>  	struct device *jrdev;
>  	dma_addr_t sh_desc_dma;
>  	u32 sh_desc[DESC_RNG_LEN];
> @@ -78,13 +79,10 @@ struct caam_rng_ctx {
>  	struct buf_data bufs[2];
>  };
[...]
> +static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
> +{
> +	return (struct caam_rng_ctx *)r->priv;
> +}
[...]
> -static struct hwrng caam_rng = {
> -	.name		= "rng-caam",
> -	.init           = caam_init,
> -	.cleanup	= caam_cleanup,
> -	.read		= caam_read,
> -};
I would keep this statically allocated, see below.

> @@ -342,18 +332,27 @@ int caam_rng_init(struct device *ctrldev)
>  	if (!rng_inst)
>  		return 0;
>  
> -	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
> -	if (!rng_ctx)
> +	if (!devres_open_group(ctrldev, caam_rng_init, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
> +	if (!ctx)
>  		return -ENOMEM;
>  
> +	ctx->rng.name    = "rng-caam";
> +	ctx->rng.init    = caam_init;
> +	ctx->rng.cleanup = caam_cleanup;
> +	ctx->rng.read    = caam_read;
> +	ctx->rng.priv    = (unsigned long)ctx;
> +
>  	dev_info(ctrldev, "registering rng-caam\n");
>  
> -	err = hwrng_register(&caam_rng);
> -	if (!err) {
> -		init_done = true;
> -		return err;
> +	ret = devm_hwrng_register(ctrldev, &ctx->rng);
Now that hwrng.priv is used to keep driver's private data / caam_rng_ctx,
and thus container_of() is no longer needed to get from hwrng struct
to caam_rng_ctx, it's no longer needed to embed struct hwrng
into caam_rng_ctx.

Horia
