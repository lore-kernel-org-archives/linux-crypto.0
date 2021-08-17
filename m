Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ADCC4320A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 17:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39CD60FDA
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 17:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhHQRjV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 13:39:21 -0400
Received: from mail-eopbgr30135.outbound.protection.outlook.com ([40.107.3.135]:57088
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229716AbhHQRjU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 13:39:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiFSHYXN+rg7VOKGO8eEMGQ7dMCbpvpegz1oDUStfBfb3p46OhwLC/dt7K5u9tAVFZJV/SYg54HDBnT8uP0VkmuOBWq+yQ6bB5C7svwyvv+fosjmoON3ls3mMrOVei4euBtCo5TL6wQs+sBzCMPEsSpVN6Wk/NKdV4v+/OTBza1RFwxXzshxuohkjtCaUI4Q21I56Hm42ZjVikx3eY9+v1aV22plPG2wGFlIFD6RHDx+vsaKvSwpMVLb/QDtAL+4vTtNMDX/ycPN9AfNNIWlbAIeZpHK7IB2zWhiSeAsCo8GzNVOANq7f82xcvItInOG0fzkGwwW8zES8RGKLVL6vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKQoNlbI5c5tU77EJKrQ6Ecqkhl0Wb40woRWzg5wqbg=;
 b=gx2Aaip0wi4Rm8kPMEmHpa0LmVwCq81R+82P/FJQiRe4TGcePfRifQcvpauoOzwtrAPm3w6DrjcPuowSvDM3vCDlTIPIeLU6pIB4mquWAHM0z4Mco9BmVgXLuiPrbXaX+pK32UNZQ+tZGSGbGYL1r1QOvKn9tv1M/I2RhpoE7IsNPcghyTlWbhA3OUlJ5qAZPR3sl5zpczwZwKwpzHD8jM4B3lAQ5eB/bKwRia8k6bC71bY9w44WdjMCh/p9PsQ7VH1Nnq/jXQ0NdrsaOX8ZMlwMpgVJ1L/TOxptuATY+OYOrPIxYI7AMf6IdpNu19C11hhLqLCY9Gj4SxwadmqnDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKQoNlbI5c5tU77EJKrQ6Ecqkhl0Wb40woRWzg5wqbg=;
 b=KRnnLJ8BteIGUJEyHpE8IMOY70uUV0tgsZzQXLj5ObxcKr+EkHooMUJ/ETBESAOBUNMFmHzTugt2kziSxS6aZfEtvA5sMmm6kj+aJiwjZnbJJ73cBHvyzMhlYA1LS5k9ncuFWu79XzeNA1o8es4L70S6AGgjmp0KFlsvxaKa9PU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2243.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:d6::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Tue, 17 Aug
 2021 17:38:45 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::30d6:1ff9:85e4:48d1]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::30d6:1ff9:85e4:48d1%5]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 17:38:44 +0000
Subject: Re: [PATCH v4 4/5] ARM: dts: imx6ull: add rng
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Franck Lenormand <franck.lenormand@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Martin Kaiser <martin@kaiser.cx>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20200715152604.10407-1-horia.geanta@nxp.com>
 <20200715152604.10407-5-horia.geanta@nxp.com>
 <4f30d822-9db7-4a54-c082-fa9f54982b42@kontron.de>
Message-ID: <1246c765-0bbe-9143-6214-94b7ebcb6151@kontron.de>
Date:   Tue, 17 Aug 2021 19:38:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <4f30d822-9db7-4a54-c082-fa9f54982b42@kontron.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0060.eurprd04.prod.outlook.com
 (2603:10a6:20b:312::35) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.36] (89.244.183.210) by AS8PR04CA0060.eurprd04.prod.outlook.com (2603:10a6:20b:312::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 17 Aug 2021 17:38:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 071cb961-1d3f-45ff-6045-08d961a5dc6f
X-MS-TrafficTypeDiagnostic: AM0PR10MB2243:
X-Microsoft-Antispam-PRVS: <AM0PR10MB22437665E70B644E5AEB0C58E9FE9@AM0PR10MB2243.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wFV2reGVfIrmNDlxYxSumfFLxxbXl0tnWMHYtu05dhL6t59wphDie6pQHrrJRcjyH5jPk3uvhp8IUlobYD6ocY4/C5bJZOwsY8irmMY5AZhn1YxOIWbm1oZ1rt88UPo8xbgJS8du0jumCQ5WP+OTmK6H2S5JXR1UVHsCsVzDiF5N1ZtM9KlOaeoZFcG9cEirYHGQpvxyGXP6M6x2rUxgxNyjXh1wpuYgeZR8X9+SPZVtp9mSp9QoBpENSTFT3dWzbcmviwHu2EKWXNptBLsmGw0EEaQ8F3et8BTBaxLEpbUaJCmFV2fBH4UpWLbOqFhlyEXJTHkOcZeqh36+QKeCMQTfvVl6DIMFeKQMQE/bsklf9rtjBWQTYFehlQ06wbiuEsFHPlqHXjn08SOZjnnyb8eMjQq1lwSKS0gV4Jr9wy0HTI3Wfna9U6ZdMiq3SR6EptOSXhPRXPR5R3Pbwrn6JZ6dHowNUv4N3BS0+FG4i6bzo3nuJzC0pzTseTGQlulLNdCIj8RwC83T4V5CBB4s8iJ5CSR1c/6I7FGZNioHdb6O9zeQcnyrfqPYC6vXqBp+QZ0+0CBoD5dJjxjTyFCqrmQbY9bvuXJEZKsdPX3q0X55Mxh4kmpDZNk5Eyo9GVOTxbFIMKvmRta8tc+Mqi1pfRn22NM9108doF/GVXPeLH37OM5jxPxGW9aB11pbEVGB8tkr8Jko/cjSZVnLd2Dq6FbBv2tjcebJ7G6L2KmDmRw7xKfmOvR8io0LqiiOhEKyauXXZmcl/g1+bx9P9ZHCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4326008)(508600001)(31696002)(6486002)(66556008)(66946007)(66476007)(956004)(186003)(8936002)(54906003)(2616005)(53546011)(110136005)(26005)(5660300002)(44832011)(7416002)(31686004)(316002)(36756003)(16576012)(2906002)(86362001)(83380400001)(8676002)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czdpQTltV3NlNjh4NEVoaU5RN1dscDNZOUlKNEFTcnRId29ya1docTRLVmEy?=
 =?utf-8?B?dmMwV00zMlBsYWlxOFNpRHFpMDZGM2tTWmRaNndsYVdqOWxienh1WlpMRVJs?=
 =?utf-8?B?Z2JEdW0wV2w1RVgyQm5JaUp3NUFGalFyeGloWVhTeEJyZDZraW01WE1LMkxy?=
 =?utf-8?B?L3VmRHdQd3cxQVR2eXNBT3pNb2lJWlN4UnY2SjI0YSt1aU95Zm9CQUZHN01S?=
 =?utf-8?B?YzJlZDgzRmNGTzdCbm4rOVFmbkRuYm04RnB0TkswQzhLaWZyNjhKTFZiVi9R?=
 =?utf-8?B?bWNUb3J1NFdyV3lJS3RxR0FGaXRPMUVWenQ1UGg5M1VONTkrZXV2L0YyUkdT?=
 =?utf-8?B?ZXpuOVNYWTRyREhhaXFlMGo0VXRIYi9VcWNVL0lyVUthN20zZDEyVFo0Q3Yx?=
 =?utf-8?B?eHIvTWdFQThHL0NjQm5raHhTQ1Q2UEw2a2FtVU0vVWoxR0dFRVAvcVBmeHpa?=
 =?utf-8?B?aFlMeDMwRmZ5UXdDdjdWakhkY0Q0T2dDUWU4aW5KMlRaKzVwMmpZb0xhTVdO?=
 =?utf-8?B?b3BORFFRcWFQWkUrbzgwd1B6dmM2ZktqQURqUU5hVTVUa3BKbEdzTDgydi8x?=
 =?utf-8?B?TGplbGUxQUxrNGwvQzBTaUJCSkZ1SkdmT0gyWC9hZ3B0bzNhOUZObXZjVWZh?=
 =?utf-8?B?ajJraVc5QkJsaTZodmdsbVN6eGFPb2xrRWp1QzVVd24zWGFVUit5c3BZMDJ1?=
 =?utf-8?B?OXVxMkl6cGFNQVJGZC9UWkpxcC9MQ0t5V2poNzNYcmxQY3RWS3dsSEhMZVZG?=
 =?utf-8?B?Vmw4eVlseG9sWHNhdkpnTSt6NE5yZlhvK2VTN2ZZUzFLcGE3TTJlcFE4UDI5?=
 =?utf-8?B?TDhBL2NoYm84QThONFBsNGdMb00xY28zU1dLeG0yYzhsTDNUeit2OHY0d3RG?=
 =?utf-8?B?ZXg1V0NnUXQvRGJiTlFsWGc5UHNyV21rL0pDWHJsTGczVkplMzd4VElTSkZT?=
 =?utf-8?B?cVJzZ2RIR3cyRUNiR1ZEZlU0NDd6ZGV3bjNpTTNLTmFzbGs0ZlZaWTZDMlZ1?=
 =?utf-8?B?ejVsNm50c3BvRHFjam1JWHVtT2JlYmtaVmxnZnRTQjJuRDg2VW1ITTRFVU0r?=
 =?utf-8?B?d3kwU1RKeXR1RExQdjlXVUJ4eTN4VXNudGhWays4Q042bmRZN1htZW81K1Zl?=
 =?utf-8?B?eVBaaUVKelpwYmNiekhkeC9wUnNPT2RSYm12LzJRRkQ4UjBQVjR4K0pwTllZ?=
 =?utf-8?B?b1F2T29jTkZtWm1oQXlCWTlUSkRMakFTdTZZRXZndWdaVXVzVkRRenpaSnU3?=
 =?utf-8?B?N1J5MS9KanpRdDA2R2FOQjBkbjNGakFhRXdJV2JQQ0VDbTZhZmJWZVlUOS9n?=
 =?utf-8?B?aVlsbkt6R2ZwVjQvUE4wS1VUZXBJS2hGVksvMEJwZ0VlOG1ZUi9vUWFnSWtG?=
 =?utf-8?B?VGNYQVVuU3NodGc4SjRhbkpBcVhBbjhSQUZxeXF5eVRxbm1YcFNtT1A1NEQz?=
 =?utf-8?B?ZzJhenNWMklYUExNVE1KL2F2T3lUWXQ1QzFFK3hWbXp2S1hDWElCQVBkbWNj?=
 =?utf-8?B?d1BPanFldTZSVGE3YzVmUkNmcHFwZlpRam1sZmNtOTN2bExrNVVyNGx3Z3Vp?=
 =?utf-8?B?TjM2ZGFYSWRyZHh1OEthS2U5RHRxcXl6czl3NnVoZ1JzNkdNRW04bU8wQU9n?=
 =?utf-8?B?TG1SckxPRTJGZTVRQjdZZUYxR25OL2pzUXhGNXVWRkp4YTV2cmlCaWZFcU1O?=
 =?utf-8?B?YW1IYTlIajJLNjJycXpkWHBjZjR6ZkFuMWNKNncwQkdGSFNwQTB1K3lxbzlk?=
 =?utf-8?Q?AppR+XMrtLD/KlTSWEDqPCr15sJOoMip1oOItGN?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 071cb961-1d3f-45ff-6045-08d961a5dc6f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 17:38:44.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9be03aEXrVd6TMWg3T4ZVyvwk5tgkhL9Rnst228qG66Y0RNFFENXX6uYZgp/fpI2xeFznP0vbABGGZOYK1HqT8aej6S1f2K+ZIeYwN6JKTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2243
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17.08.21 17:39, Frieder Schrempf wrote:
> Hi,
> 
> On 15.07.20 17:26, Horia Geantă wrote:
>> Add node for the RNGB block.
>>
>> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
>> Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
>> ---
>>  arch/arm/boot/dts/imx6ull.dtsi | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
>> index fcde7f77ae42..9bf67490ac49 100644
>> --- a/arch/arm/boot/dts/imx6ull.dtsi
>> +++ b/arch/arm/boot/dts/imx6ull.dtsi
>> @@ -68,6 +68,13 @@
>>  				clock-names = "dcp";
>>  			};
>>  
>> +			rngb: rng@2284000 {
>> +				compatible = "fsl,imx6ull-rngb", "fsl,imx25-rngb";
>> +				reg = <0x02284000 0x4000>;
>> +				interrupts = <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&clks IMX6UL_CLK_DUMMY>;
>> +			};
>> +
> 
> My board (imx6ull-kontron-n6411-s.dts) fails to boot since this was added in v5.10-rc1. There is a crash in the RNG probe. Can anyone help?
> Below is the interesting part of the boot log from v5.14-rc6.

I just found out, that I was trying to boot on an i.MX6UL when I was assuming the board had an i.MX6ULL. That won't work of course. Sorry for the noise!
