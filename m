Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996DBC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Apr 2022 10:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiDSKag (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Apr 2022 06:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242210AbiDSKaf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Apr 2022 06:30:35 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80732A72F
        for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2022 03:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEafgNDfvMi9nWVcV7qW2NMVw3K/tbXBGN4m5y+MZnYN6WhxRcCSEUUDIY/vcKuWumcD3lH+PlXtXtqJn41WHogLL96GZQtXjljrcx+xujiOow8pGAVs3ixVIpwOWHKRiXwGn8SdevMgnjTmnq2JaWmGHiwRveDcYUcO5Wak7Ebzr1zxuJq7m68HY5J/g+yLBcps3H5gmB/GduUK2OdEDySlSd0zncq02TnlaLSOeGkFgHHGV17iH0UH9+5CjADV6wnK4/p3N6jkFFObmhP9BPHvZn1hWWfoXitGkZbupv4Gvv2HZFcKb3Fs4uR9ijyKHRciicdN1ImrS+hGBAQ5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ewh1Xc9chOREcsoEr7sTd2EOWj+NJS65CBzQH2mXp1Q=;
 b=Uv9Q+EZnifi4TRFTYyR2OHwPbowpPuWGN8yiD0NexXPS+jqD6yLP9VweEgQKhPfKcLnDABuPsG1VWLRpCD4lUm7Ke4FsA42k57mJih3kP2uV1s44TqKcAA4Se+vRiXBwUzcvGTjWbgLOurwIE251zb2uyaYbn1Zmf6i1v3inxUraaEGtXFSl/QOLIs/Uxtav742R8Am15JkMWnD0UdnjV/1PlkpXuk216fdEdWORuMl0Ar9ep1kGMqSm/qbIaLDlfND7DawM5VP5diIMwqepy58rEMSPrNpAKDCqY1+Xf+l/K7yB+8xSItXKRRFDj0lYZohAr9Y+mIl0PtkV+UMYhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ewh1Xc9chOREcsoEr7sTd2EOWj+NJS65CBzQH2mXp1Q=;
 b=hjDOphVh8oyicw5bSidbg0A+NjT7pr0ROLhSKLNq4rJy1P4gzhlDVsNuhVSO9kLzdvEUX8cy6ibYbeV2gGFOEYybkvVHmbd3zj5ji4lnfZv0h8jREx2thvhini9OKIISpMwVM6jrqB27QoLefGaa2P+K3+zvs3Q4E93o75KH6i8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com (2603:10a6:102:229::20)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 10:27:49 +0000
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f]) by PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 10:27:49 +0000
Message-ID: <231ab1ae-7fb0-79dc-0784-e61e48d0f454@nxp.com>
Date:   Tue, 19 Apr 2022 13:27:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v3] crypto: caam - fix i.MX6SX entropy delay value
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Cc:     Gaurav Jain <gaurav.jain@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
References: <20220418122728.203919-1-festevam@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20220418122728.203919-1-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0135.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::40) To PAXPR04MB9517.eurprd04.prod.outlook.com
 (2603:10a6:102:229::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f96e566-59a5-4671-bf95-08da21ef40a4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6366:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB636620B36430937A9DA38F3A98F29@VE1PR04MB6366.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ez1mvReuLgMAz1SpMpLFwneh41ift4t9E34FyEGH8EhGA6EYAVM1C6O6lrF7qXkkPk7e9C1aUhi+Qi8/dUlaFpPjYQTy36Kv66MvV1dEZFxWRJxW9NDmo8A+5JnpnpTA44EmuHt173MPQZwVeTnJtf9SnBuk16IVryVqwLkP17OeaV7BwxEpVVNtyZuQWuW1Tiueqrfb3fsk7jM0G2V45TW9mg71lH1/HVKz5YM/WUtVvVnCYXdVPklyjFxt2bp8BnN2dNr5SnIjGEZR0szuALwc0CgLe4JnJ4/9kE4/tIr/xXuUR/GBky+UM8uLVlYQl/cISZ4+lw36Oyj44qh/Eu8HcKMrvRQhetskz+z5M0h6vCQPQWkZQpllo7ytS0HCq16wBvvAeA7Va9NZdEwKzhJMwyEe3/6quNeQ1VVEcvcorZT73tuyH2yRTwbfSUt2GF9E7sZWMjFYRR99fdod5xxTD6mi/kTjShwOx3Wt/b4d8vFi/dg+wGdpUbzTaCH0lwavT1F3G0BmJUphON0Va0Zx/EXz2mWHii6EYqTfkr8XHsB9zQKcEAw4B0s8vJ3pOd+2z/lioSzMEiabVm2Sjth+7xqeH6tUB0m4HwBEJ0QkFXyalx6uFS8VZN8PX4Uj+5AqC++YcV6+TIkwJ/3bC0TvgPuOJBtpJeWxWFQ19yBmsiXICY/OijS5bKT20/QH1meA3KeSjuWGLiLUuMUtVfwscogoc0KO7wimUTTxuBh4WrhhS0uRBuzLcjR2FJJnlNMjUdQqx5C2R6PsP+kzXmbFPbbmbc+CS5X+Bks5Xzb4ep6xydr38UGRPXwM+Cx9rL2Xk9awyZrqnGqCVVHKEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(110136005)(8676002)(55236004)(2906002)(86362001)(38350700002)(26005)(38100700002)(6506007)(6666004)(6512007)(83380400001)(31686004)(316002)(54906003)(4326008)(36756003)(53546011)(66556008)(66946007)(66476007)(2616005)(31696002)(6486002)(966005)(186003)(5660300002)(8936002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHUxU0RGekcvSTZ3eVpXNWdzR0t3YnpDbU5EWVJ4ZktXNFRUK2RyaGdJMHhD?=
 =?utf-8?B?TFpQODNRTlUrK0NacXJGdEJKREUydUNobmp6RjlkOC8zVElkN1UwcHNuWEor?=
 =?utf-8?B?MCtoeVhWUFBlUzZ3L3luRmszTTdHTXFvbXllZFhmZU5COFZxYWMxdGNUZldj?=
 =?utf-8?B?Z2JrWWg0VElJYlhOQXA2OHNpL3REMTU0eUhFeW0yd0pCWVhTY0p6ZVV5T2hT?=
 =?utf-8?B?VDdLaTVWWWhjUEh2OGpFV3JKWmcxSlJpZTZLNzRLMnVVbWtJSjFZbGdyR3Ny?=
 =?utf-8?B?ODE0ZGZZQ3hzMlg1WlA2NmQwb2V3TUFFdk1TdU9DTWQ1ak9WVDFUWGhsZHVq?=
 =?utf-8?B?V3Q1dFBzQWgxdHBFSUlsTU50Z3FrN2FsWTgzWDRab3hMeXJvd3U5NWYvZ2Nv?=
 =?utf-8?B?d1NwZEdhN2hKZGZ0RHdQdXRJL3N6VnR2SE1yYitHeHdMTXFGa3R2VnNxTDVK?=
 =?utf-8?B?NjRzVzhWOHlDTVZaNzAydFdNVHpKVDZNMlA2SnlKM2N2ekVqSWFxUHlkMVNY?=
 =?utf-8?B?R2VGdVdMQWk4dmJOaFZkVGR4RGNPRmorSFg0YlE1VFAyeDFoOW9DK3duUFB6?=
 =?utf-8?B?YXBoQzBxblFndzdHM0U3ZUdlRlRmUmp6ZlhhaGxzeTdyUjZJM1RUeFEzZGV1?=
 =?utf-8?B?NVFTbDI4UmJjRFNRak8vak9ZaWVDN05xcmFzWVlSS1k2cEh2NnR4RUxvOEtw?=
 =?utf-8?B?Y1pMbjdNaTRMS0VFMnIxV0l3dUlQRzFRczU3N0xVdDlFTlNxS0lLTVB0UXM4?=
 =?utf-8?B?UzV6WFV2WjNFRjBVOTQ1SWg3Y3dFTHZVWTlYZHNJMWU5NXc5ZkVleEZGRUJj?=
 =?utf-8?B?Sklxd01meHozUUlQR1hxTm51U2k1S2VGSUF1TU9TSS9SenBaZU54YWkwMHBz?=
 =?utf-8?B?enBGU3VkMUdUZDJybU1MSTRrZ1RmSk5lVVIxRzNNU3NLTmlGek1mcWppcFdT?=
 =?utf-8?B?dms2U1hFTjdoV0tBeEsrZ2ZSTGsrdFJHMVllcHg5QkdjeGtLb0hTd2tHWTZr?=
 =?utf-8?B?K3AyR1VGV21JSTlwYmFhRDR2KzdlbVVleFBjOGNKb1JOTUcrRGNMVXRuUmZP?=
 =?utf-8?B?emlGazFWbG81aEMvUjJjd1ROREcxeVNFNG81VUdVMUhHUmVONjlHUXZnZTda?=
 =?utf-8?B?WGVVWG1CTkZsTmxSZUwwWTVpT2FQU1dleGF6K04rbnl4dEJoQUxJTUhqZ1Ns?=
 =?utf-8?B?aWNrdzJFaHJ3Mm8rS0QwVmp2SGEwVWR4V0g5T2ZkekJDQ3N4b2FTQUtUYmRO?=
 =?utf-8?B?S0hNcVFISk82RmNHWUhwUlo2eTlYSU1YRlNqdTZ1aFRQUUNnaE5QS0VuK1ZP?=
 =?utf-8?B?dUgvWFVzZ3UxZHRDNGNQMm5USm5GRDhvWlBpZU8zaisvL2hrL2EybDNMOCtE?=
 =?utf-8?B?MjI4SjA2NFcwNXdKREFkcW1xVFluWE5nYlNIK0ovVWhLUDBmblNINW5Ja2pi?=
 =?utf-8?B?N0kxcVJtcTcwL2JtRnBsM3BqQzVJL1hLclpQTkMvSFRKMnZnd1QwNEEwbmg5?=
 =?utf-8?B?aVJhaG5aVjFjNlVPZ2NpR084UUNJZFNjelBaUVViZVBzMSs4S1NnZkgweHI1?=
 =?utf-8?B?bzNkd1EwM3FTdFFGY0Z1QlptcU55eDh2MGZUNjJLL2lFRU5PSC9NQnZiUXRK?=
 =?utf-8?B?WStJbGZaeFp3WXVSZG1pWG9qV2xHODBYMW15MFNXWFI2UmZhZlJmeWZBbHRk?=
 =?utf-8?B?K3oyZWNMc3RqVWRRNXhhSmdFeWtJN2hVOVIwTUNGZjRTTGtVeW95RVBxRWxO?=
 =?utf-8?B?dmNLd3pHTHZ0YVN1UWVUK2wvY2tUTkxDcFFlWm5TUWtyZW1COGJuOTh2M0NM?=
 =?utf-8?B?Q1oremxJQmlTdjNmYVFTeVNrankvN0t0azVMZmpON3dORytpN3lHV2ZySlMy?=
 =?utf-8?B?RjBZU0ptSTF4NjFLcjM5V0I0VFQ5dWdJcjNmN2tlRGtFQ0srS1lDc245d0sr?=
 =?utf-8?B?eFZjWS9kK0tDT2cyZG1NV21QTG93cWZnVDZwZis5RG54UkFkL1VKbGdNWkYz?=
 =?utf-8?B?Y1N3ZjBlR2dxT1lZM3cwSFZUOEJrUlZ2a2xKSXZhK3VmVHJjczlMc0ZONDMz?=
 =?utf-8?B?aGVIeW1FY0JTeXlVQUdSY2tnQUxScU91dW9vc0xUc1g4QkNUR2trNTd0MUVj?=
 =?utf-8?B?RnFoVU14NXlPbitWZVArdDlwTGNvSXJwcFJwOVlLU1M3QnFmcTlKZ1lpMU40?=
 =?utf-8?B?b3EyU3hHdExWcFFLVzk1WVUyeVErZ0xPNis4OHA1NzJKNTcwUmZtMG9NNllZ?=
 =?utf-8?B?QkdVQlJFckhWdWR0WTlYaW9pYmVQT1M3MUY4anlSMytDdnpsSlNHRlM4dnVT?=
 =?utf-8?B?UEZlRlhCd1htcWpuT2Z3YVh4ejJmZzI2aVFVMytOMHAvYzdXaHhuWDFSVy8w?=
 =?utf-8?Q?u+V2aXWW5U3Xthfs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f96e566-59a5-4671-bf95-08da21ef40a4
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 10:27:49.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mH+cFp30gzPEUEP3tiZvBFpzkhdjEbn4uAh5CJ/MqObH82v9W49OE8ZEM4DkRAcdq/qWeR70Nb74Lx9WfFm7lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/18/2022 3:27 PM, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
> in HRWNG") the following CAAM errors can be seen on i.MX6SX:
> 
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> 
> This error is due to an incorrect entropy delay for i.MX6SX.
> 
> Fix it by increasing the minimum entropy delay for i.MX6SX
> as done in U-Boot:
> https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/
> 
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG") 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Changes since v2:
> - Added Fixes tag. (Horia)
> 
> Change since v1:
> - Align the fix with U-Boot.
> 
>  drivers/crypto/caam/ctrl.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index ca0361b2dbb0..c515c20442d5 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -648,6 +648,8 @@ static int caam_probe(struct platform_device *pdev)
>  			return ret;
>  	}
>  
> +	if (of_machine_is_compatible("fsl,imx6sx"))
> +		ent_delay = 12000;
>  
This looks rather randomly placed in the probe() function.
I'd suggest moving it into the RNG initialization area.
Another benefit would be calling of_machine_is_compatible() only once.

>  	/* Get configuration properties from device tree */
>  	/* First, get register page */
> @@ -871,6 +873,15 @@ static int caam_probe(struct platform_device *pdev)
>  			 */
>  			ret = instantiate_rng(dev, inst_handles,
>  					      gen_sk);
> +			/*
> +			 * Entropy delay is calculated via self-test method.
> +			 * Self-test is run across different voltages and
> +			 * temperatures.
A clarification wrt. terminology:
-"self-tests" refer to HW checks done when initializing the RNG
(instantiating the RNG state handle), they are statistical tests to check
the quality of the entropy
-"TRNG characterization" is the offline process of determining the entropy delay
values that are "suitable" - i.e. allowing TRNG to work correctly across
ranges of temperature, voltage and clock frequency

> +			 * If worst case value for ent_dly is identified,
> +			 * the loop can be skipped for that platform.
> +			 */
> +			if (of_machine_is_compatible("fsl,imx6sx"))
> +				break;
>  			if (ret == -EAGAIN)
>  				/*
>  				 * if here, the loop will rerun,

Thanks,
Horia
