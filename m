Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96766CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 18:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjJTSAZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 14:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJTSAY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 14:00:24 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FAED51
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 11:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSFLeBna9ilidroeMPwRPYzZQxo9PgHjmxnCnuwquu5V42EDQbmbdvom8FxLc2NAtw1x5l45+s6RdTU1eCRr+Ah8cJAj8+SJW2Nn1MBPSqsV4h8ggZKccq+RiS6REyQNDNGIE8qJiPBhQxdtAXMFhbMZiqcYAJkOczQRBG34k3n2otAr5TsrnJF0n80H7EmG7bnaxYWl5O63EO14zTxb1TvowpKhNhuJgRJkkGTMz5Nx5l2pqupQfFy1HGlr5Ep10ZlVhUmpVVA3nG9L7Gq0eodOiQ6C3hmhX19dNXMY82VZn54eRXl6dNF+Ygbh8jDHX81tBBcIJ/gpO4PzhbSpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWsZLdnpQhI+vTUlzPaENK59wHu8UKDfbT2zyGoHjhc=;
 b=VvsLLAaF731ZdEpHlIsoFiF2NKwGMXnBjvH3216QP/Yyfj1R26mq3YAJEQQJpM/sYkR6jzepTDOvfUcCQ0xxMg+81EEakHJFF9ZnxM/nDTFo2seQNWj/E0kCYdki5WwYCnadWTWEPOKOkGt3FsKUX7OFucVxhKEmDgUj9HBUkzzOZoXDmOwQC/Ad+zkwaKlsuOq7BLkzxNUL2WO/XTWluO5S9so6F/3Bjac39Oeg0r2beUbEE7JYqY/LEQkTRV5m8gIqHsdL4qBJin8s0QNwMJgIq1y3w7g3YHv60KRIPszI239ULTMSPDLdcxSLBPBt4QCubGuIhWNEUxakkSWzow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWsZLdnpQhI+vTUlzPaENK59wHu8UKDfbT2zyGoHjhc=;
 b=c17/xVfSQsHRg6hZfixJ1N6+cs98VyjK8YlKWrJMRR5ht2LYbq/tXqVmb71iKXzF1OiGsI3WLW6LMSYJjuzTpdP1kTyOFIXy0Sfx2ueD1wQfawpxYr3EPY8nY6D5gVQY6HHUAC0Ft/LmfnsuB7BuWAZkrmn4zTSnIvSRCkuUtqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DM6PR12MB5518.namprd12.prod.outlook.com (2603:10b6:5:1b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 18:00:18 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::a13:336d:96a5:b7bf]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::a13:336d:96a5:b7bf%4]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 18:00:18 +0000
Message-ID: <1e60c9b4-a3c1-6379-6ee5-dad78b6fa28d@amd.com>
Date:   Fri, 20 Oct 2023 13:00:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 14/42] crypto: ccp/sp - Convert to platform remove
 callback returning void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-58-u.kleine-koenig@pengutronix.de>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231020075521.2121571-58-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR2101CA0010.namprd21.prod.outlook.com
 (2603:10b6:805:106::20) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DM6PR12MB5518:EE_
X-MS-Office365-Filtering-Correlation-Id: 18047c7f-1983-4a66-9ed3-08dbd1966b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t699Xv4KRj6spQg0Rb0GaEjudxmcY7DUAQDQ1ahoPkB+yFAPCP5TJLH+ag4quFKeflnGbgRKsXI7rR2nJzL68dGYX4M+ApWJMEjh4zzWo1vqx04KGLDsQ4vthM6cae5qDVu7jhsCUs/3HloHQiW67N8Yt0jziFP4eXrs6S7//eql5u5XWIZyp4LZIDYHf/dejDziaS3/eBsPF0lcxFIYz3ocHOOwZm9vC6JbYnuFxiBkG1tN17jj0Go8PGBlqZoctfeGY6i6NkyUMHFarlCqaqy015nL+wO6+7OA9namMMrJ0NUcdL8lyvafdG5VptGVbEin4WZ6UH21p7XEHMEe7GpaneXLkqgp3LJ66k1KKoyeV+d91N+LVBsVrHHpyHPeWzY7WKHFkz6jcehzprusMKJRYUFlOF9xYC40Iiayw4cIBwozMofLybtmu1/Hwh0umX64YTDVttiFlY00XoNiFWdGF7ymNG3UR501j0GpQp8TcXr35aKUc/IQkOA6kdfjPZzHCYvos4zTCRMQadLLxZTQ+pLdQAYGwWNFCl4bOPU4i1d62uvLOZpSlDCe6cjYzz2Fz8Q0pUUi8wtSLye36f6cNrrwbFiBTli3APXowR7HwIevGlwwTs2UvWrGF9o76Gr4Wwf6i6JogBChiwkZpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(376002)(396003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(2906002)(66476007)(66946007)(66556008)(110136005)(6486002)(316002)(8936002)(8676002)(6666004)(478600001)(4326008)(41300700001)(86362001)(83380400001)(36756003)(5660300002)(31696002)(38100700002)(6506007)(26005)(53546011)(2616005)(6512007)(66574015)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzE2NytqMnFmVUUzQ0J5V3JzSDZNcG1vZVg0RXBnbkZxVEo1cEltRFNDWHpQ?=
 =?utf-8?B?bDBtNFZXRHJMNWRObjJ5aEVmL1MyYmdTemxXN3pxWTF1QWJpZ3dPclAyNk83?=
 =?utf-8?B?bjlBSUxhT1RaUXBjMEsrSXlCaGJZUFlQbmVwcm8xZ2sxN1ZTYWI0RmJoMy9V?=
 =?utf-8?B?SzdkZ0lrQ0F2NllRRWVQWkxqeDF3dWQxSFlGOHNENzhjck1WYi9xd0d2VVZv?=
 =?utf-8?B?SDRUSWZscEozVXlEckszdDJTaXBrdTJvTG1yRFN4WCs4bXdzcWRTcGFrM1li?=
 =?utf-8?B?Z2pkUmRLNWdMSVdtV1pGMHF4UmlmdTdIUkxqSFdJSHBrN0hjRGVDQUJXelZs?=
 =?utf-8?B?WEFCa2lWVnZYb0RKUmttSnFwNHlNUSt3Mm0xeld3MEhsUjNMdmQ2NHp2ZzIr?=
 =?utf-8?B?Z1hGcEU3Q0Y4OFloR1VCTjdOMlcyUmoxcnlZd01iaXlTZy9RVk5SM1J5VjVO?=
 =?utf-8?B?MHVqRGN0WFhoSjV2bDV0RXlLRjJlUHcwTFdZQjV3QzdJcWFtTHEzWmpHalpY?=
 =?utf-8?B?L3dxZVN1TSs3cGZiS25NN2VzZUMzMk90QS9mUklubUVPbWhFQlkxOW5CZk9s?=
 =?utf-8?B?UUYvcUtqblhlNlhvMFVRZVIrbU5wWGFiYmpmZHlZMWNEMThlVytoUS9iVW1G?=
 =?utf-8?B?ak82d2h6UHdFRlIydStyYmtrcTU1TE5ycmNJbll1L2pxTER5Q04yLzd4Vkly?=
 =?utf-8?B?YVNYbjhNTzU4a05pU1J5V2I4NXJsTFVLd045TWhvd0FrbFl4RFkrWlp2akVR?=
 =?utf-8?B?cXBxTDBoZFZUVm9KbUN1SHpCZGpxNjVGbDhhcFNhbVhIbWtZRDBVa3gzQlN0?=
 =?utf-8?B?dXR1bXlGOE5UY0F3OXZLUndSS3VQQUI5Q2w4VDhLQWx1b3REZTNvR2kyREM5?=
 =?utf-8?B?N0dtUUtOT2hKbXVDODhRWlB6L2FPdFNMRlI4M3RjZjloZ0g4T0w2QXRqNEYy?=
 =?utf-8?B?ZnViOHVCODduYXRtTGFLNzhFaDdLSTZFVm9DKzhKeXNaZ2pYWFJaYUZuQ1l3?=
 =?utf-8?B?ZmZhck5OSUJLRkpabzFVZ0s3dHI0c1Vud1lXSGN4d0R2cUVON1RQZjNuc3No?=
 =?utf-8?B?WE90WnhPY3VtUkdYbCs4QnIrWDdZcWRsSUwvT2ZNQUxqdHJMTnRzbVpKNjdN?=
 =?utf-8?B?dFhDY0pPUVBFOEZBODZZOEkvbmdCckJ5QTlSKzN0WjY5S2NpSnRsNTE3NFFa?=
 =?utf-8?B?aVpQUkE3d0tabHo2WU5aSWhURzhxb1YyR1piNi9TQ21RdTViRytLalBQT0xB?=
 =?utf-8?B?QjFGQUJ2OFBGaklYYTBVUUJyVFloVEpSSHJYdmhoMVlaRnlpdEdyQVJBY2xL?=
 =?utf-8?B?RUl5R3RXUHRIWndXemNyU2czQWpxV1hFK2VHZ2IxNVZOR1RqWEJKME9qa1Nx?=
 =?utf-8?B?VUVrMWlXWjFNM25KZ3BDcXpvVlZMNENsMVFsQ1R1WTRvTFVQc0NEckk4OVJN?=
 =?utf-8?B?dEIzMkxVVDdVS1pGVkNuSE9ZZTJRbE1sL0VSaVZVdERBQ2FXNzU1a0s5MVVJ?=
 =?utf-8?B?d29YUFFPUE44VW9sNURxRzkzbDlnOEM1RHpkNzhVTGR1MGdlK1p1d3h3T3Iv?=
 =?utf-8?B?VWFkaWFSVnMwaUhwNk5sanFjTWtaZ3lmSTU4NjdmZStIM1JzcldFdk5SWnZS?=
 =?utf-8?B?cU9qSGVZRHlOZ25jYlE2aEY2aGYrYjI3UnBJTzJmeC9ZSVg4S1VKYUlKSWFm?=
 =?utf-8?B?ZXJSTTZ2clFiTUdTVnQweXJHNGxuU0E0aDB0WTRocG1lKzRDWmZrcjZUNUQ1?=
 =?utf-8?B?cGIxUWtCcDM2NUxUY3VZb1FCNzFNM3NEUG9ZVWs1dkIwbmxjajhoY1BWeTBy?=
 =?utf-8?B?eTNIZmNROW9NU0VBbmJyVHA4VUk0K1JWM2NmOExxNG40Rk4zNjNQRUpRSldS?=
 =?utf-8?B?bDAxVnhNOFloRDlybnlOalNtaFhwT2l3K1JyaHdxWExxYnlCVU5EbHpjajJn?=
 =?utf-8?B?RndCN1ViWGR6cVAzMVhTV08zVFNFVUxEYzZRT1phNVduS2RWdncvWHRBdUhw?=
 =?utf-8?B?OHJZSVNyVzRNVjIrdDBQNEJob3ZFdzgza3ZSajNYVm9GMlcwNkFiaUNMemho?=
 =?utf-8?B?SGNGOTZUNGdlTmZaSWhQMUZ1TlhoTGlqcWV2cVlFNmY3S0JmOTBUYWpoMW9K?=
 =?utf-8?Q?KIYltzg82I5vGDAr6FPUnp6dw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18047c7f-1983-4a66-9ed3-08dbd1966b7b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 18:00:18.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWGb1ynndiPxf8XECclwVELfkyYShzx0Vjr72EeD4wF7tZVumofAVywfO2cDpKDWzLgwdpYvhrHhxFHKU/BWEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5518
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/20/23 02:55, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/sp-platform.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
> index 7d79a8744f9a..473301237760 100644
> --- a/drivers/crypto/ccp/sp-platform.c
> +++ b/drivers/crypto/ccp/sp-platform.c
> @@ -180,7 +180,7 @@ static int sp_platform_probe(struct platform_device *pdev)
>   	return ret;
>   }
>   
> -static int sp_platform_remove(struct platform_device *pdev)
> +static void sp_platform_remove(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct sp_device *sp = dev_get_drvdata(dev);
> @@ -188,8 +188,6 @@ static int sp_platform_remove(struct platform_device *pdev)
>   	sp_destroy(sp);
>   
>   	dev_notice(dev, "disabled\n");
> -
> -	return 0;
>   }
>   
>   #ifdef CONFIG_PM
> @@ -222,7 +220,7 @@ static struct platform_driver sp_platform_driver = {
>   #endif
>   	},
>   	.probe = sp_platform_probe,
> -	.remove = sp_platform_remove,
> +	.remove_new = sp_platform_remove,
>   #ifdef CONFIG_PM
>   	.suspend = sp_platform_suspend,
>   	.resume = sp_platform_resume,
