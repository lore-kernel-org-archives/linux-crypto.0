Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13561C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 09:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376641AbjJTJUC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 05:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376643AbjJTJUB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 05:20:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FE4D55
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 02:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCivNqyxHco4Q0jgr3QnpTxaHYuTGKAq5YyfI6xyV2hBiK18fdsjw0ykIveHWYT8JXEVDtnra/VM8BJ0n6kPCrsm4cbQ66A63dDFM69z+QIsgVpK3LrSeaLOE+IVhafOxCkd+v0C4kR8W9qpI0vk0pq9c/vUWs9zx/BFIV1fEZvLnA6y7RDKbxer+Ijp6HMei4CXZP5Pv4V3nQZzf8NYofOnb9Lw6S4MLx/2O2rEzaiu4VyKwPvP/36osO4u3EjBIJcE7dRbW6L3cjnwNrAf3a9zYlR2ZR6Ell6ulTuu728Sc4oxub5jwA3H4tgPo/QwiJtf39oBee8sRMbgc4HIdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kmir7jTlbbifC/V/WR5uZ80Axy0Pmc4PftBMM9t5jjA=;
 b=DCExdvV08Tpt1WbeM4r1CVEYgvmxOY8kPRHQfFCRoSyUBzrfvyC1IHceGR7owCj/Ox00Vgovji5EkIUOlBPjrXb8yIBlu6sYUDMLGkuVxHSOYSpMWk856iIN/Xwqrja2pWPbCVrFnb6TnDMb8NEGydOlLMKFbsjfQ+f3fivcPomiQC1VfyADsu88taKqEb+GcghHXb3zJ1a14bHNUJFBBTQOVJIy0wV9jzGbHeqf5lhAvzNPUYVMEIMy+P77AiFXlxsyaBJBL5H9xbI+RxetKUNX2HaO2Ct7Yo9aKmx+Q6Yj3ePFDmNXYoyoAgHD+Q1bh/u5kyJ08fw0Hhtt9s1+nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kmir7jTlbbifC/V/WR5uZ80Axy0Pmc4PftBMM9t5jjA=;
 b=AWwPTGc86Qz1Pqy+el8ODtc+Us0XMO9p9KAPwv54SwhwWRwaP1OrSjwLe0qnz9yiaBq7pSi8TYdN1KMfHJ8iTBfZTGif+9myyix9RF9EAYTBFnETX88UmBKHAyYjmdbhwoCvxM0rixrEqOZMocVnIploMXSW1NU9JHKQ27+WTWs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4758.namprd12.prod.outlook.com (2603:10b6:a03:a5::28)
 by BL0PR12MB4899.namprd12.prod.outlook.com (2603:10b6:208:1cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 09:19:56 +0000
Received: from BYAPR12MB4758.namprd12.prod.outlook.com
 ([fe80::b220:eeee:98e7:a62e]) by BYAPR12MB4758.namprd12.prod.outlook.com
 ([fe80::b220:eeee:98e7:a62e%4]) with mapi id 15.20.6907.022; Fri, 20 Oct 2023
 09:19:56 +0000
Message-ID: <ec0ac601-84ea-4cd4-856a-c92915934b5d@amd.com>
Date:   Fri, 20 Oct 2023 11:19:51 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 41/42] crypto: xilinx/zynqmp-aes-gcm - Convert to platform
 remove callback returning void
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-85-u.kleine-koenig@pengutronix.de>
From:   Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 3i3l5DA=
In-Reply-To: <20231020075521.2121571-85-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::8) To BYAPR12MB4758.namprd12.prod.outlook.com
 (2603:10b6:a03:a5::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4758:EE_|BL0PR12MB4899:EE_
X-MS-Office365-Filtering-Correlation-Id: f7ad1adc-62b5-4c52-923c-08dbd14db9b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUkWdkC7YAi6y3ZgIsQbdbsXOpZoii6QUITV6QibEkm1Kaf/Q1eN2UzvKoOtBgGTSlbkROpZnGV/oD5x5WlFwYu2tvhY/Y3qyqC4QE6suY2EX2bNA/Af78y7cubQ48TsXbPLHz2SHp9ZpBADgTkaqE2Qp52s3JVQlpiHk/kuMTuxS1I2uHzbbAzglCXZQps1reZNZS7CIfBwIJ/rpKgM4kOgmLi0tit1IvczOOfxgTXmT9GSY7VB4VdLdAnzQyTXMRZ0W6XhuyGOOn/WYEoNlkqbngFcnuwYP/ZWhpCNOVgTFU7m5cVD05jWcggSunkOoinPIbnG1enJoIVpa8pl64nvp+lZ1QSeDXeLHISZNemKZxnTUB0Msqekapsq8y4BbrCDdA0lpouddLTaCQEJx1x0x0S9QeswpHAdYJ9XNNzLkcaUL4v2UHhAqCcFjm4Psl8Czr3C/VI7A3oPpYFZIH65SLZhsuJANleaCnirqSracSBesNvZC9kakFc68b2ikSFJkKu+4g1dI/mz8CqAuAbOUNigMc+H2bw+tuQjL668GrFeWfiqJIoQ373U5L8vLocatI8WWGIel33QohgeX0nQWttn4laFiAQPauxDjR6FnyDcKsUSoVZFyripnI1mxiahjMXF7ff8r/sDMg++hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4758.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(376002)(346002)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(41300700001)(26005)(2906002)(36756003)(66574015)(4326008)(8676002)(38100700002)(86362001)(31696002)(8936002)(83380400001)(2616005)(44832011)(53546011)(6666004)(6506007)(6512007)(5660300002)(316002)(478600001)(6486002)(110136005)(66946007)(66476007)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGhpUmpYbmE4OU5VSGhGV1djOTNSWVNPZWdUdDlPMFpmK0ZyR3lCQzQrdmFa?=
 =?utf-8?B?MXhKRTl5T25hQ3A0enMvNytJdmlueVQ1cUQyYTlLV0hvdDlod2Jld3NVckQy?=
 =?utf-8?B?WEY0MHJ1NVBGOElQeTFrVUZDajV0UFA3a2I1VVRZTGVHZzBZQzF2U3AvY2ZJ?=
 =?utf-8?B?bVNmY2c1Y3AxaGxqZEZUQStVN2pnZVB1VzRHczNuNXJDSFRhWHpISXFldU10?=
 =?utf-8?B?ZkVJNi9zYVFvcElSV0dDTXhIa3lhRlVuRlRrc0dsbThxbmMwS1ljWXpPUEFX?=
 =?utf-8?B?TXFxVWF0aFBQQTh3aktzZ1lQUWxSYWRnU3EvdnpTZnhSQURQLzQ0UTFmSmRG?=
 =?utf-8?B?dzQyVVlPRVpmL3ZDV3pOaHRKaUlIMnNSLzd5SjJITTZXVzBaZXJxeE5GZyt6?=
 =?utf-8?B?WWVBQnZHZWtUQVA2VkE3SDBiM2V1M09HekI2Ymp4L1h2WDlLY2RJOHVxRWxF?=
 =?utf-8?B?QkZCN0EyNmR4NUZQbzUyb083VTAvQnFZZittVlZUR0wvMTRNQ3F4ZzV2VVNz?=
 =?utf-8?B?NzJ1Q0VHUERMYzJZblZ2SHpNTENyTEoyLy9keFRscGlQMzdzZk1OMm05aWpw?=
 =?utf-8?B?OVE1MHlDc3ZvbUkwakZuQnU1dHNLK1BDWi9PWXRMdm13VW1FN3NDdjlvZWNM?=
 =?utf-8?B?M2k3cXBCd3dyR2h0bVZnYnRQdjdRRm5OUXJIWm1vTzRXUFE2a1FmeHpRT1Qv?=
 =?utf-8?B?aTJSWXRQR3hITGlvNFdPRTdwc3lwcE5JaHhrd2IwZzJ2UUpJMFkxM0VFcWF4?=
 =?utf-8?B?TXZOeDJwZUlMYzFWVkxpSldyT2VET0xRcmZqaEhNRjZZRlFHcjFqVkljTEdo?=
 =?utf-8?B?TVdhbkhlZ29haGM5UnNvenRndlJVK1lrNjFRTnNObHd1OEgrbTBOaDFzczc4?=
 =?utf-8?B?ckRmazFILzh0Y3ZVNnQ2Vm1LUTVkRW9VMXVxd3AwbERVRUQzaTBmMXNQazll?=
 =?utf-8?B?czVVdTgzNFo3UlBEaUlJOWNpVWY4MjJWN3J1amZJUTlzYkJQZXcxMlBBdUgz?=
 =?utf-8?B?RlBrdVRveHAzb1FPdjM5VldhQ3JIenBjQlVwQURKcEVlbXB4aEs2WDJuNDNK?=
 =?utf-8?B?WU5PQ096aTVLSWdnM2c3YVVvRWdjeU5EZkhlbDZyODVVbmVrbGFKU01xSUZR?=
 =?utf-8?B?MVF4d2E4dWM0T01IS2hGSUw3VFVDb1ZWdlZ5aFQ0N2trblpKZ0hXVkJHaFJI?=
 =?utf-8?B?eGZ6SmVZMWxVcjZvK05Oakh5aDZNNHJVa2ZISVFaTlhNMVhSclZFNTZoZERv?=
 =?utf-8?B?bGhIRXQwWnJBZ0ZYUXRPd0NpWDh4VzdwdkJnT2FZc3U5bVcyQ1FaWUNoMHg0?=
 =?utf-8?B?OEZjSmd2bDdUL1A4S1pFT0owU2psYlgrRTJVMS9SNTM1UndWNlFLM1ArWitS?=
 =?utf-8?B?d3hhM1g4ZDhPZFhYd2RwOHNhakFqN1pNK3M0bC8vVXFRRi8vUStwNXVmY1FC?=
 =?utf-8?B?ZlNqcDAwYmdJYUdVV3AxUjhWTnFNdnM0TEtqckFxeERkSE1kV2h2cUVCSGRo?=
 =?utf-8?B?QkVzZWV4UTJScFhMbWtKck5LcGQ5N0R5U3VYWmxTc1FES3M0NVlZa2VTTkVr?=
 =?utf-8?B?bGVlZ1ovbzlrSG1KSlJwZmx1MHJpRWVhOVJzQXF2RmRrS045YXVyRDlkSEU2?=
 =?utf-8?B?RWlSYVNob0tkWDV0YVZxT1ltY0pualVESWN4ZzU1NDZkaGFIUzR5OUdZbWxi?=
 =?utf-8?B?ZU9ON0JzZVJWSkwyYlZKWmVzNDhianBBWC9lc2ovT29RWVlINnZMK3dPMVlV?=
 =?utf-8?B?Z3RpMUJCb0syVC9nMmhJbXV6eWM5czBodVJLaTBhMmVzaEFMWEZBeEJpUE9t?=
 =?utf-8?B?VXk3aXJqY2hFVWtGOUVIWjFRcmYvTk9Nd09QeWpDSU4vZW53d1dYNVgrdnpl?=
 =?utf-8?B?TityelgrMk80R3pZTDBBaTdHN1QyVWd6elF2MzM5THhPcWRQYU9YUmEvMCtP?=
 =?utf-8?B?NG41M2Zrd1JRR01peGRBdW9qN0QyT0twUTk2YUFwTEdGT1J6UENOaDlXbGpZ?=
 =?utf-8?B?cDA3eGpwWGNSOVB5NEU2QjlXbmlRU1ZFSmNqRTVMdFFUY01JREhFSTFpTHlm?=
 =?utf-8?B?ZHRVNTh6bEFTQTlBVUN5ZlJ2R0E2c29lOUxSekVBWHRWTjdnYmdVeDExaDNn?=
 =?utf-8?Q?0K5uF0fzQNpVSPoNjA7xTYJuP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ad1adc-62b5-4c52-923c-08dbd14db9b0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4758.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 09:19:56.3128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 974/NVqGMebHQHCsQqgdbKrdQCGuM/GCXyhSTVD82KCctvFdkLCbJkl1MuvYOkGk
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
>   drivers/crypto/xilinx/zynqmp-aes-gcm.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> index ce335578b759..3c205324b22b 100644
> --- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> +++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> @@ -421,12 +421,10 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
>   	return err;
>   }
>   
> -static int zynqmp_aes_aead_remove(struct platform_device *pdev)
> +static void zynqmp_aes_aead_remove(struct platform_device *pdev)
>   {
>   	crypto_engine_exit(aes_drv_ctx.engine);
>   	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
> -
> -	return 0;
>   }
>   
>   static const struct of_device_id zynqmp_aes_dt_ids[] = {
> @@ -437,7 +435,7 @@ MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
>   
>   static struct platform_driver zynqmp_aes_driver = {
>   	.probe	= zynqmp_aes_aead_probe,
> -	.remove = zynqmp_aes_aead_remove,
> +	.remove_new = zynqmp_aes_aead_remove,
>   	.driver = {
>   		.name		= "zynqmp-aes",
>   		.of_match_table = zynqmp_aes_dt_ids,


Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal
