Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E184C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 10:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029A0207DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 10:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="i5dzPpTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgFRKzD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 06:55:03 -0400
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:63713
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727825AbgFRKzC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 06:55:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFj46QUD5Suw7lwgwzRK/4NUFhNwwIoVbfZEH83eY5uE26alA8bHMtEEKWgcR4GWwZVFU55zaVxGED1ml+NMpUdQkXjbg0W8q4YTxwqdMx5Mez5KZ4J9Jjv3upM9qOebIToeUZzmkOAIAf8Gb1uBCV2xul9M8MRapF7t71mD0ED21eWlQjcumKjMuni/DRC17PZuHY9ndoywrZ5qTLQ2b0CNSVx1aA/Bw6DM9Wg5hD42+ijXGwc+QtSRiDZZDwR2IhKPreMF+3vQEAI2DtT8yvNpMYVrvwoY3J7pCHMa0ptByKj6NmFiV8HG2mDpAC9QGqh01d3/lj8A/NnwX5zU5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZWgUEgA/jhT2eChT4eH/DWPWlu5/dUJYFoB6LOLMSs=;
 b=Q6qO689NK3AsbS2hhSt64GV7Y4SCvvUTCFTIi8dOwv6fYj+7lz8cagNBuKOqHTeGdS3EHGg++KvulyfN9kJkmgRqYemdgl33JfEBhPirKqtec/UnAc5bC3oQwr0oa2QsGiO+CiwK258EVHtNgqG2lt3m6VtTkGw+9Pv7Og1SnzUHIbg+yUbAC0XHl/lbmMxtenenaqUJkyZrkVLdapnLz5RhGJ1wz18zr5EKiaINm3+bRgVdB6dH3Wv5i9PWvODa0iwNSRUzzi2iboT2f3NI1JbsWpnWhd6GNuqxZe7tUn6dNwdzRFxAQXML8mzE7WZTDJb0OGJB5cHgAHNLaX2x2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZWgUEgA/jhT2eChT4eH/DWPWlu5/dUJYFoB6LOLMSs=;
 b=i5dzPpTfXu3EZFaib3RPllsx7iuswD+XiUWfs8xk9pe62k2uDdAwFLkw9bdLxtqxHEZFnWpyenmThJtNR1gGQCqtS574vHFBYqg7e69/u4Wy1ocHXZqcjM3y2hHY9ikQqxxGwfVia35UM6nI4wGjwe7t64W0DuOgkuLfzrlCWnU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5280.eurprd04.prod.outlook.com (2603:10a6:803:5f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 10:54:58 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 10:54:58 +0000
Subject: Re: [PATCH] crypto: caam/qi2: remove redundant assignment to ret
To:     Colin King <colin.king@canonical.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200611153934.928021-1-colin.king@canonical.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <8e08adcb-ef91-124d-d093-921fc97da3af@nxp.com>
Date:   Thu, 18 Jun 2020 13:54:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200611153934.928021-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR01CA0081.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Thu, 18 Jun 2020 10:54:57 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0871cb52-4937-490e-7e19-08d813760ad6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5280C7E347AD891A3004B260989B0@VI1PR04MB5280.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKz6SrZCldhg2FhdRNCCaEKtsevUnQxsJGFu0eTaUpkBnQj+yJ6NxqZw8RIfKP8+lv7F8hWVLpq7bItQWwffjwh3k/HVjHCVbt7R83ylmHimEqgd/wPm3797nk6rlyqpdu4Xn3zsUhzRcR996VXUVcWPUOmR/EHSt4CzDqM19iSUqjfXAnL/1r6Sb6x5pF++u2QNC6sW33ZydcSk7uV6Re/lwyyMdGeUXvNuXohuRQOUNLl6aVIvKE7+2EVSKydKRuta+AmJVPcma4l7ZIoZSlNuToHy8bX/Ho5rqN7uXY+9qJqiWXh6hhQlyqszh9wEUnaLhklbv+JiZjvMDT3cZxwDugNWQ5rTFEZiajGdPh9ECEV2C9nP+0dvx1YzYqLC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(26005)(16526019)(186003)(5660300002)(2906002)(53546011)(52116002)(6486002)(31686004)(16576012)(478600001)(8676002)(66556008)(31696002)(54906003)(36756003)(86362001)(66946007)(956004)(4326008)(110136005)(8936002)(316002)(2616005)(66476007)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 40pN8OslYHsw2lsCiUWFIa2jMtuqklLnQvATUbj+70LQGEeZfXaKO8RMYup73rlbwzhyOUu88T8n2Q+j57ZJkeLFvo7USbGBw5ruMo+g0ZgNi1ZwgLhMeZe0skuSGQP8xL2xeJmXn8v7rETvZwiMM0HXSvxBel6ZFN2fvpYbHUsVksNvGzO67LnW3lkc/a6yWb1IlQpH4Qs02h6ABvXrIc1zm10XsGnwZXSEs9ElvwyMGhIzvLpzh5YnOJwDjjV11IQCjgJ2zKi/wlIqbC9Me4R8cvtA9DlxupGJXyooDgcyVYk+pu8xSAnRFSpG29eROk5l7UqLQXSyLxSa/rOOXqt+t3OJyDXpKCH6eNdk/cIkNp6AqSgy681c/piPwJ1K5B7Zei3xm43f06DgKHE5XbBBPtH1HLif5Mq4clNIVkSVGsV+K7QW4eCNe2pjs5yhR61BQ0jEaz6ne9kznENfVomAI1deLHU28UDZ1+zTeWTYkrhdZDdpUK8Wl5SmIn8L
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0871cb52-4937-490e-7e19-08d813760ad6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 10:54:58.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OnfvY853BGsY3F26zlGouAB9A78JHZHX7TZ6ocCAJ61+WDl8zDtGLRsoY/uKbQlMyv/gQL+iwIaXLMKdUbxAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5280
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/11/2020 6:39 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being assigned a value that is never read, the
> error exit path via label 'unmap' returns -ENOMEM anyhow, so assigning
> ret with -ENOMEM is redundamt.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index 28669cbecf77..ef2c4e095db3 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -4044,7 +4044,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
>  					  DMA_TO_DEVICE);
>  	if (dma_mapping_error(ctx->dev, edesc->qm_sg_dma)) {
>  		dev_err(ctx->dev, "unable to map S/G table\n");
> -		ret = -ENOMEM;
>  		goto unmap;
>  	}
>  	edesc->qm_sg_bytes = qm_sg_bytes;
> @@ -4055,7 +4054,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
>  	if (dma_mapping_error(ctx->dev, state->ctx_dma)) {
>  		dev_err(ctx->dev, "unable to map ctx\n");
>  		state->ctx_dma = 0;
> -		ret = -ENOMEM;
>  		goto unmap;
>  	}
>  
The proper fix would be updating the ahash_finup_no_ctx() function
to return the specific error code:
	return ret;
instead of returning -ENOMEM for all error cases.

For example error code returned by dpaa2_caam_enqueue()
should be returned instead of -ENOMEM.

Horia
