Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFC1C00A89
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 10:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3E32231B
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 10:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Q3HJpQM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgKBKuA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Nov 2020 05:50:00 -0500
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:12590
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728005AbgKBKt7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Nov 2020 05:49:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONLcq+i0sKjKYDjOub5O1ls09poc+aGFgAJ8PFUOqaqoYGnfTpaLm/9GwV/LNgIMy7kYnjqkW1y20IzBrrL1/PV/ZTAcv44u8LsfRsREa4qOeF6kSUqFg/T56erHwFy3A+cDVXoLAPKxUyzvkO3/EdslyzVH24MCh38MDNqqDUSq1mGGiOSeV6XIE0wximF1DyIemA2y7nkqINxghdxwBJMboT73Vtg1ZdPtdUrlzvV07Ms4ZC/sf/4NQmzkwtgHu1yNzoymV9OG6k827wh9pKHhEwC4wT+LSQE6c3j8c/NyqjpmJRNKYgqgmB2owWx7Zag9qjnmNZhX5ruCxCC7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTrVNzec9lCw8G5xR/DMtwvsRrgX2obA6z3GjrTELX8=;
 b=P0Jy2U2ZLEj6mdmthjuJuOurTM5eMZLrENjjjuhTrCttIbe2eGiL3ccw23D6evENuCBkAgJUoy2qGI0YM8Qg8PG3sZrqjkvfWJYAlBUx32O70V4rR+bVrDQMN5wXMyym8araCjexfXFgfgxwEyoP2pgYY1AuoKivt/Jooa2AsPjhGvOJpJ3IyjzPOvMOesA/DEIIvg99ZZI++G6iC5m4HyadzThpSLvWDaX943rsa3sOVweddr8vx9Bj23rctcG3Aio5HtQLWWTZvvngs9LwoAg0PCDm/OwElhsKjXUIA1h8R+q2j0z4bul0+XONqRmOsP07gBv3Shh2hwX4CM1x6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTrVNzec9lCw8G5xR/DMtwvsRrgX2obA6z3GjrTELX8=;
 b=Q3HJpQM7tQuIBsEGe3mNVMtTTmgZNilQLubcr1IWr7CI+OsThkuO60DFtdYYg3vPgiTCrp4GRvUUzn6QJCE23WHUltDisjcZ40UtuywvhfbRKbSxe6YMiewGpl2xTDdrwYWB0I4IdHYRTaXoSoTENOug3fuX8T8AATay11xx2k0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VE1PR04MB6512.eurprd04.prod.outlook.com
 (2603:10a6:803:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 10:49:55 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 10:49:55 +0000
Subject: Re: [PATCH] crypto: caam - fix printing on xts fallback allocation
 error path
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     Andrei Botila <andrei.botila@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201101200553.25248-1-horia.geanta@nxp.com>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <e729817e-5c9d-112f-2c1d-514b91e19870@nxp.com>
Date:   Mon, 2 Nov 2020 12:49:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <20201101200553.25248-1-horia.geanta@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.26.141.79]
X-ClientProxiedBy: AM0PR10CA0071.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::24) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (188.26.141.79) by AM0PR10CA0071.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 10:49:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 32480489-ac73-4890-a6f2-08d87f1d08b9
X-MS-TrafficTypeDiagnostic: VE1PR04MB6512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6512347B8D9D5FC1B10222A38C100@VE1PR04MB6512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnjG9QfmvV63AFbh5ADLUS528A42m+VLCl4QVSfWxpVsBC/WRdxJZ7Iwk5XIc94lH/Ol8jz3koHdhybZDBydCrveMXeDsWcJDhP/vNLl+ekHH+apuNHFoCZMhNBtauWfYMKx90HU/PBmDE3O0vbl1XVbA2teyg3zV0nFVDa/a0IUv5SOZQ2Pc6T48CFF45S4GEhKUbGTWbvDWTLgb6I8I+Lr2WeR8fpKYYXQP6ZWXnjpYz74UQVQRvHrWKmXXSRfZovOZ7aNePTp3fOHYV6NAffHEC2+X4FlLZLUDk0f3kiQx2WaUFOmVMLgUn4VLQG4C4h3sUjrsq73ihZ7gMIL5+wLHb+K3t0eyO0Fl5tr8uuJN0NaWe2bisgap7OL6735
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(31686004)(83380400001)(316002)(54906003)(66946007)(110136005)(16576012)(44832011)(36756003)(478600001)(2906002)(8936002)(8676002)(16526019)(4326008)(186003)(2616005)(6486002)(26005)(956004)(52116002)(86362001)(5660300002)(66556008)(31696002)(66476007)(53546011)(6636002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vpmBgXG5fjFxDVXgma/VaNevoGzIWsDV8nb/Cd5Va1rvklzWi62qSHbKHsk1U+L0+QgfKJizA/PJytqSqjDq/EvnSgoOfcCI9SoSXUkBhI1akEmKLte/TCbKCfaBJct3d016Oe8nxcZJrjbmjBJxMcIFJrlx5dFLTtkxwiwuIdpNiP3jAPS+AF5RDAbGNNacaESoKjOs6lE6xuKXkowUGJEFesKK3sZyYOwMSey5WKq9MuEoZSXaEN+aKti8jO1pQgK/pwV5l25YXbigSVKV6FOl1N80a1A8tSfUo/2uqZDyjXiIwPaWwAWO2GKs3oSywdfnoIcQmNnlyozUObKWh2Nvk4rw9fxTjUF174s7aJ6N6nwshcTeIdVrgWeMHJlE6thyUFCyMFZ7p3vZhf17Eix9sFcenOtq+WpWc5ylRNT4G21peJWWa0a1oKs/VNNKR/4qW49UIVGOZBZc0CUMYhIrTo9ckbi7x82AO7shovYaNnafV7UqA7d5sxrJ8ldyy4W+0mO2MaDSBUNkdpnH96UwEkA/7mZ3YowlPDjTx8jYbF9JEqyNnnUQSp3QUl07mcUeSkceyF1HJ+ct213ilrh3lmd7dfw6L3/zcD/pzAaP4eqc7fQuZPU9dgdjmCgl3Evgyka67/UKEWlhl03wMQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32480489-ac73-4890-a6f2-08d87f1d08b9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 10:49:55.2437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjlGsKJLqQea1EuhevTRLYnQZ8hGFsApHhLbHN3XygudIwpN+DmhTkCLRlJ8EjlxsVM7CuxTCAvxHE9dIlMMAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6512
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/1/2020 10:05 PM, Horia Geantă wrote:
> At the time xts fallback tfm allocation fails the device struct
> hasn't been enabled yet in the caam xts tfm's private context.
> 
> Fix this by using the device struct from xts algorithm's private context
> or, when not available, by replacing dev_err with pr_err.
> 
> Fixes: 9d9b14dbe077 ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
> Fixes: 83e8aa912138 ("crypto: caam/qi - add fallback for XTS with more than 8B IV")
> Fixes: 36e2d7cfdcf1 ("crypto: caam/qi2 - add fallback for XTS with more than 8B IV")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>

> ---
>   drivers/crypto/caam/caamalg.c     | 4 ++--
>   drivers/crypto/caam/caamalg_qi.c  | 4 ++--
>   drivers/crypto/caam/caamalg_qi2.c | 3 ++-
>   3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index cf5bd7666dfc..8697ae53b063 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -3404,8 +3404,8 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
>   		fallback = crypto_alloc_skcipher(tfm_name, 0,
>   						 CRYPTO_ALG_NEED_FALLBACK);
>   		if (IS_ERR(fallback)) {
> -			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
> -				tfm_name, PTR_ERR(fallback));
> +			pr_err("Failed to allocate %s fallback: %ld\n",
> +			       tfm_name, PTR_ERR(fallback));
>   			return PTR_ERR(fallback);
>   		}
>   
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
> index 66f60d78bdc8..a24ae966df4a 100644
> --- a/drivers/crypto/caam/caamalg_qi.c
> +++ b/drivers/crypto/caam/caamalg_qi.c
> @@ -2502,8 +2502,8 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
>   		fallback = crypto_alloc_skcipher(tfm_name, 0,
>   						 CRYPTO_ALG_NEED_FALLBACK);
>   		if (IS_ERR(fallback)) {
> -			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
> -				tfm_name, PTR_ERR(fallback));
> +			pr_err("Failed to allocate %s fallback: %ld\n",
> +			       tfm_name, PTR_ERR(fallback));
>   			return PTR_ERR(fallback);
>   		}
>   
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index 98c1ff1744bb..a780e627838a 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -1611,7 +1611,8 @@ static int caam_cra_init_skcipher(struct crypto_skcipher *tfm)
>   		fallback = crypto_alloc_skcipher(tfm_name, 0,
>   						 CRYPTO_ALG_NEED_FALLBACK);
>   		if (IS_ERR(fallback)) {
> -			dev_err(ctx->dev, "Failed to allocate %s fallback: %ld\n",
> +			dev_err(caam_alg->caam.dev,
> +				"Failed to allocate %s fallback: %ld\n",
>   				tfm_name, PTR_ERR(fallback));
>   			return PTR_ERR(fallback);
>   		}
> 
