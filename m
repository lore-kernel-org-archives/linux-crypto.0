Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443DCC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 09:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376755AbjJTJU0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376636AbjJTJUT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 05:20:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B650B10C7
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 02:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9Ib9W3dacF/rI6Y7LYPyvqwiLEzJp/JI8CqFsZuuHOCfDQjmCP/kjALcKZ+B0LK0ssrMQQ79b7fBWvnN/AlG3CNbtInWoWcRHctY8RzrS1C2Wc9/6AiHy+SMVub5h3U8M1U7HBl6zXOgvJl8VWZX5Va7JCSIoAeqUAg14vhi8ryhEF6goonW/n8rceE8+qPmFKP7boAr0rrSjj3HcetBNDsL7VJwtHAX+rBDtse49HHQuoPUKqLU0l9okoQFHjzEy7CtvdlRzDyzPcEUrBoTE5Cem8caL9j2Wf7bVy60IQgMKev1uVJXOuXgZsIKko+m87RaE69CS5qgQ39JNpskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7GpXnCBcswdoN0LQ94Kp8Qg1fLqpY4hSdcRCVmUumQ=;
 b=ZEGeaXnlkq5ED948pgkpm2qgqnbvMpKTawnB2ge31LbQ+hdwXd71gxeQtkTvTcKvVTqxes3jDK6z5oczevJUHkFt2MaYJmsx1kIbV6Rz2VEh1d198rdYKymDUDRT6E+6yBuPuawHqVG/uPbBJqljMY2egfK1DAw5y1SCs+SbIqcG0VvwARmbStI1HEtMbDXf5KG/TYkinPj21swfwlmTWc9YQQUstxfYv96J0sj2Pf+w0mwiYqGzSSD0lBqvpyVJFHeKiHZP8Ceh6BkWTWBZ/OUAP0aO7cmQXiWFDZ3+b6d9a1+Odoo3pSb6Rd0yHjhhajktmhnDACXzXhX/S6jckw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7GpXnCBcswdoN0LQ94Kp8Qg1fLqpY4hSdcRCVmUumQ=;
 b=si9nDMB9qTJM4ui7MeygEBnJy8IXtxQKv2jpbdbubrCuj9drgQpH6RooCd8FMZqxNl/8VfRwcTe63nH+fDLZsXJcVBle1K+mWErLtLdqpmHvAag1KPp/HzHCcPI7go8HOfpK5tIptehZqnjooIfGsAQjW36+xoE7BPKdSdQ2zCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4758.namprd12.prod.outlook.com (2603:10b6:a03:a5::28)
 by BL0PR12MB4899.namprd12.prod.outlook.com (2603:10b6:208:1cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 09:20:04 +0000
Received: from BYAPR12MB4758.namprd12.prod.outlook.com
 ([fe80::b220:eeee:98e7:a62e]) by BYAPR12MB4758.namprd12.prod.outlook.com
 ([fe80::b220:eeee:98e7:a62e%4]) with mapi id 15.20.6907.022; Fri, 20 Oct 2023
 09:20:04 +0000
Message-ID: <dc0ff928-015c-47f9-a18f-19804350009d@amd.com>
Date:   Fri, 20 Oct 2023 11:20:02 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 42/42] crypto: xilinx/zynqmp-sha - Convert to platform
 remove callback returning void
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Harsha <harsha.harsha@amd.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-86-u.kleine-koenig@pengutronix.de>
From:   Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 3i3l5DA=
In-Reply-To: <20231020075521.2121571-86-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::8) To BYAPR12MB4758.namprd12.prod.outlook.com
 (2603:10b6:a03:a5::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4758:EE_|BL0PR12MB4899:EE_
X-MS-Office365-Filtering-Correlation-Id: c45de20a-a894-4dfc-7e7d-08dbd14dbe8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxg/kIkaJk/IX0L4DP/vLwkrYMM1vAgBC5qJ1ol9i9MoCMLorQsn1zJIfSPK7gEFmtKchNDsbSUHZ6QLSZ80fZ0VsqHrp3PAKkYOQd/1eO+emzj5BQ9p40KAHi8va0zKx4iveZRD6q6tszbgbQ118x8JTOq9Tm18vkOJJs4DxOMxqWJAuyqxNPFBqNu/JUZZUuYhRbDBQRcbFG8cgntlz5/03qKnbaYpwIwFLgZrWakurLrvN0seKpWLiDb9tfcZpkYuz6IS/48OBwODjswiiB+ziXDUAYS1AawCmht4b1u/XfJA8Nw2TZIP3Faw8JIDxmCpUtVd4cF6CAQ8XitxdlenTfeuVR7VqVPTjzxb+nMl/MRgMmG6BD/AIybeyMvavEcldpTkXwjNIhIkxY+3QD3qk25wzRJ3m6X20OVYKzOnlAi4qDDktGKHw+0S0ep0q51+h7EpNqoadDOtWpp9855uRPyb3NLE/LOFCiJtfBz3rctQVDYE9mk6TGyGtoii06kiUmlUgNEW7AZ7BoJGyN3yDJ/aVPj/AFu7rRXu/MWaXlMKNDTYNSrqCk9P7moUGdnGgnoSMYE3MVWdOREJ1pDMtdIJcbDJFQfV2RgD1VFXJlCs2pw9x91n/flm06dMVBq+hqROf48sj3tP+pjE6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4758.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(376002)(346002)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(41300700001)(26005)(2906002)(36756003)(66574015)(4326008)(8676002)(38100700002)(86362001)(31696002)(8936002)(83380400001)(2616005)(44832011)(53546011)(6506007)(6512007)(5660300002)(316002)(478600001)(6486002)(110136005)(66946007)(66476007)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dy9FeEFZb2xiaStBdlA0dlVKSVBVN2lUTzQvOTl6dzRuQWF6MmJJY09IQzhw?=
 =?utf-8?B?SXpoZjZvN05reDBsVUY5akk5ZWxhRE8zQjc2YmkxMjM5ZUVJc1Mvbm5ndXpP?=
 =?utf-8?B?NUpiSGlrTi8vc0J5c2dQaHl1SzE2M0dGYUFhNWRtQU9tbFRiWUxmdFlackc5?=
 =?utf-8?B?ZTF5NWFsbGxMbjUzdUVZTFQ1bUY3ZHorY004emthZ2EwZUVwY3ZYVjVjV3BJ?=
 =?utf-8?B?bU5PUDBNQzdrd3dOSnhzVml4NGx4UjUxMVZvelhOTm52ZXovUW4xbWpDNTJz?=
 =?utf-8?B?SGNrZGorR0ZCa05WbVM5dDhTZ0E1TE1xakk0SVdCYnZiZlVsRjVjQWdhWG15?=
 =?utf-8?B?U1NCNUNmcTVvSm03d2djUFM3aUVGZEVWOUhycjJpVklBN291amZOWm1MTGNq?=
 =?utf-8?B?QXRRS2UySGIrU094a253TEhVamw2QkxaYi9XblV5ZXhZcGtYY3dyZ2FPcmhu?=
 =?utf-8?B?c0hIZjZZQVdYRGZlMWVNQ041MkJwQW5kcCtRRlB0bVJWM0J6RzZxU1pqcWM3?=
 =?utf-8?B?Z2JRcld1RVBYblhORHJMUml5MnVXV00zTHNmR2R0Y2loRXBSd0FUV2lUdnln?=
 =?utf-8?B?SkFrQWMwY0d6Mk84cU9EMWhmdTBTLzJZZHZKdlN1eFBGOHZOOTlNYklTN0lq?=
 =?utf-8?B?dzlaS3kyU0N1UmlUR0ZCRExMVFJtbkl4Q3BGWXcrUy94N3hwRHRVSDJGMTcx?=
 =?utf-8?B?NmkzVGpFVTc1dVNsWE9TdndKZ1ZOSXBXQ294SHpNWHNhRHhRZ2g1WlJ2OUpy?=
 =?utf-8?B?Y2tPY0sxSjl3OGw4OWlvN3hDbUZyUzZPUWg1Y1VKTkJlSEFtWFl3dHFKcURS?=
 =?utf-8?B?alUwVm4xT2lrcERpWHdrRjBpS0djS2ExdithZCtSSENaWTJrQUxlUHJXSldO?=
 =?utf-8?B?WHNNNTMvVlZkaEZOdkNVeFczZ3NWY0ZwUjFkMS9QYUEzNTl6eittaER2RmtX?=
 =?utf-8?B?a3N2NlkrZnZNbENSV3Y5bkRXKzdDdUpXNXo2cGNGUC9tSFVHKzExVG5uSTR3?=
 =?utf-8?B?MENXQkVSU1VZalVGSkdTZnd2QmdXaUZjWWJkRVl3N0tHOHVQUmZ5UldhemMy?=
 =?utf-8?B?NW8rS3pocWRwMDlYbS96N2Z4M1grbXVHK1JjSmxaYzdlM3l6ZWFCZGx6UFR2?=
 =?utf-8?B?NytjWkZhaGt1VEpIZEtxbmF5RWdqdTBPQXJpeDNVV0RsdmV4anFIWEFPd1k5?=
 =?utf-8?B?dWhOU0RlWUtST29EeEJON1ZQbXVwbXdDbi8reVVoazA2TVFkMTRxOVBXamJS?=
 =?utf-8?B?SDJ2MFpaYXNLejB6d2FzUGdvSy9yMnQwVi9CL0FiOFNLcEMybzdFeWRNdU5K?=
 =?utf-8?B?eTNoSkdESU9YV0krZVllM0UxK0U2TU5qR2pxcDEzZ0FoVEZreUozdGVLVDRv?=
 =?utf-8?B?Uk05RWdiSGtOamNkQjVDa3VhT1NkaGtFeEdwandGUC9PR2Z0L3Q2R3JTaXla?=
 =?utf-8?B?SzRvUFF1Rng5Z1VHVi9qQXh6MVZzb1ZhRWpDWjdrNjY5a2FUU29ibW1veHli?=
 =?utf-8?B?S2ZFbFB2TFZZOTc1T2Fyb2NCQjQ2bmlBSDN5dWhQNXhQdStkZ3dNaGlsMisx?=
 =?utf-8?B?OEE4blFKcjB3WW5Xb0FzME1JejRKR3U2djVLSVhsL0ZVMHJYcmU2b0pwS1Fu?=
 =?utf-8?B?c3ZzM2NSM3lRcnM5cHV5dW94eUJkK0pRZ1VVUmRLODA5ai9vbkwzanV3TTB5?=
 =?utf-8?B?c3dJTHF4b3hzcnY2T2tHQm1nM25XNzlvQXJKVGJVdDZadm0zdXdZUEhpRlc2?=
 =?utf-8?B?K003Z2ZESXRIVXZyaW85Q3QrdDdHbnJHejhRcW9yY0pHZzZjZGF6VndFZzdv?=
 =?utf-8?B?N2w1aUJJTmRqc3YzdFpLQ1lSRm1wQlZud2RaeTM0RGw3a2tTZjNmbGxWWnJE?=
 =?utf-8?B?bUJqamEvbkdmSzB5OFJPeThFbWRDSWJQcjNvQlFjZDRIV1YyYW5CUnRhK0to?=
 =?utf-8?B?U1NrNitSRmJycmU1OExJejJkbDk5QWhWS3FXY3Y2T3VtdkJPWElja1hVbWZO?=
 =?utf-8?B?cnBhR0gySGlVKzVaWlR1ZTNRMkljYVdOUDdUUStUdVE1ZjF4Zm5DdElkbGh4?=
 =?utf-8?B?blRDSTRaMUxoa21tbFlweFI4ZkFVWHd5WjA5N1hkNUlPdk0zQnBJcHFoVDZ2?=
 =?utf-8?Q?xhRZR0CosaujT/yRTFAFYvh1c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45de20a-a894-4dfc-7e7d-08dbd14dbe8f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4758.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 09:20:04.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gu3l6TUqkCdGt0XVWocEOPw9JHmveKxRaMdDV1QucjmtJqvfByW8SdEtj6f13+yg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4899
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 10/20/23 09:56, Uwe Kleine-König wrote:
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
> ---
>   drivers/crypto/xilinx/zynqmp-sha.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
> index 426bf1a72ba6..e6c45ceb4bf7 100644
> --- a/drivers/crypto/xilinx/zynqmp-sha.c
> +++ b/drivers/crypto/xilinx/zynqmp-sha.c
> @@ -238,20 +238,18 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
>   	return err;
>   }
>   
> -static int zynqmp_sha_remove(struct platform_device *pdev)
> +static void zynqmp_sha_remove(struct platform_device *pdev)
>   {
>   	sha3_drv_ctx.dev = platform_get_drvdata(pdev);
>   
>   	dma_free_coherent(sha3_drv_ctx.dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
>   	dma_free_coherent(sha3_drv_ctx.dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
>   	crypto_unregister_shash(&sha3_drv_ctx.sha3_384);
> -
> -	return 0;
>   }
>   
>   static struct platform_driver zynqmp_sha_driver = {
>   	.probe = zynqmp_sha_probe,
> -	.remove = zynqmp_sha_remove,
> +	.remove_new = zynqmp_sha_remove,
>   	.driver = {
>   		.name = "zynqmp-sha3-384",
>   	},


Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal
