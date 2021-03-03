Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468A1C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2070464F4B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhCDAHr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:47 -0500
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:40613
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1580092AbhCCSdP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 13:33:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITwrcRPuXHg3FrR8QhabW1I06Pwbe7P44LqmAzPBGXy+pAxsEUaSxj/pNlM2rJ6gxRLBDRrmDbNQst9Z9Np+vv+yfVgWyeShYkZz1026yD+GkI4yAPxuXsLynHaMHI6g8SoTJY+DwmTgApwGf8YLGoCas2aQ7Dv7Tqgjb3BmY7lsAIh3kN2fLEpe9RYykBpqGrlg1ldvn/+C6mG++v3kSmnjwXfXx9wDXf0BFmhjmcqGP6jnsv4i/k5WZUdN3EkH5iZGd7qcYUDayaEmTUpEkIFNQ/aGCqhRf5NoZamGzaDgoiG4OUuQppQ948q8u34KSX2FZia8jsMlC8e8OsEuwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xvmo4a3cJ63GD1w8nhoTm/1QRCwJZDFDwAWzx/7uHfg=;
 b=aUixMc7JGA7vjMPuRk5aGBrGFtOP4abkad975TjuwK0MlRi5mmT5G4KTnHmNAMExOkodxkuTJfo7OdcA4yFRzpkAUIScnKHrx2awpLD35qecMpRluZNcC6p8NAoMF5qd4cO9me2S8SCZCvI35xoIds/QHHS4vtZJCgTZ9sQ4eVgIXoj22baejOt1uABfiAf61pkuh+xnLenXFa5hOKaDHjl30Yjr7hkv63J25iQcQiTDhINwTc2Sih2JY+nEpXrcCYFil2cA2kca+XtntyHNotVp9VWLVJSqKlaEi7MtHT1xYJ9Njgrv6qqVxVfgubRSudUNC+MGusWzrExIsM2aOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xvmo4a3cJ63GD1w8nhoTm/1QRCwJZDFDwAWzx/7uHfg=;
 b=XKcK9I1kk+qryZ3F22f9iezdLw7CLa55IGk0TSIZpPMlw6uhXtZQIaelhTJYa97jXxNI9iBNXM0TFy2aYOCEBYQdEYsRkoOexqgLaqwddNX7x/zOCtAa+kPpG8k1+6Xu0n6iSADfd+lZ5vh4Q7Ku0cIkOJVK6mcZu07Q0FrnBoM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VE1PR04MB7486.eurprd04.prod.outlook.com (2603:10a6:800:1b2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 17:52:54 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba%5]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 17:52:54 +0000
Subject: Re: [PATCH 07/10] crypto: caam: caampkc: Provide the name of the
 function and provide missing descriptions
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
 <20210303143449.3170813-8-lee.jones@linaro.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <dce6a65b-fa84-beee-8e00-12d4b08e53ef@nxp.com>
Date:   Wed, 3 Mar 2021 19:52:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210303143449.3170813-8-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Wed, 3 Mar 2021 17:52:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26c088cb-a3fd-4117-45f5-08d8de6d2c13
X-MS-TrafficTypeDiagnostic: VE1PR04MB7486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74869680968EDDB2FCFE5E2898989@VE1PR04MB7486.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRbkRrKHILPOLBHzLG6cYmAaQ1zkYn+qbQxlUBVw74zkWm7oWnVYnQ6wmnYAKo0vlr7t79K7HCNWn8ye161xUhQNrWZ37YL92wkSQqiZyzYMcmCdH4B7p85gDDvdxsKyrZliNslyFjvItVuqhriIMYo/mdFztFj3Bx000Sv9P5ORcW0qoRqpSse8E+GvhsKADkUT9EhfyhqRGwsoKC//F+Z1/wOX8AgATwF7BSSQRCJKvxTtuFMT5+iQALctgInx7Rxe4PKtmbj5JhFY8JC8hzLvqD2ez4F+7vXTAsOSJUiqIEQ7Yr2zxhRUxaia+euop0csk0Jv27v/mdHXBQg4/ddtqX9L3X6Otf45xsOUuD5ce3fSzUrHxeZx0Klm0QbZlc15FqlFwS/ktKwJkGx74rtLx8zFkkzlvgahjHdlwVUeo4az0Xj5o9yz8MEPmsvqWazrI+pRo00dxCkB5Mar+EpZ9dH7VE1UuCySjnwm7ih8qS7AqJkYgwk/+hIKOfALRT5bpiIyigRoT05N3CIx+/hdK6ABmtiVZvn1VMUg6VHm/sJvVSN422KTFxOlz2mq1xyyRPsBYtD/PXL0+d3nd5nAYyXXrFxRNJytH7+DWDFcu15clhm7q4njpp7Ls6bVt5qRVmSteKXG8JCWGbrc+r7K4prMNfIEOq5LUCo5U6VART15TvlbXr32JxJpiWgg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(478600001)(5660300002)(52116002)(2906002)(83380400001)(31686004)(66556008)(66476007)(54906003)(36756003)(66946007)(8676002)(2616005)(4326008)(966005)(16526019)(186003)(31696002)(26005)(8936002)(86362001)(956004)(316002)(16576012)(6916009)(6486002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFprSEVmTFJTZ3RpckdpN08rRUJEVnRyZEV4QXJMTU5jd2V6SldLeDJHaDRD?=
 =?utf-8?B?VzAvZ3JLdTVzZk1oQ1poUGY1WG9YakVud2dGWUlXMm44bElwV0hmVGVhTVJD?=
 =?utf-8?B?czBSUk43QTU3RHM2b2JhU2ZwUVJHNGJqRDdrUjdDekxtazJTNEhndzlTamRj?=
 =?utf-8?B?TTg2Qy9BVUV6WHgvQU5PY05ycng0N3REeGNDWktsMXZnRXJvUXVsR0pTVkdy?=
 =?utf-8?B?RnJsb0hQK2VuR0U0enZKc1h4azBuQnorRmxMTkRkeWVjS1JVNE1aYklRNWEw?=
 =?utf-8?B?N1JqeTQ5UTFZamNmRktSYjB0cElnOWo1OTQxYXZwWGZCQklpNEpMTGl5VkRq?=
 =?utf-8?B?YWRSZGJiL1dkQSsrc3phYmp5M0MvcWtzQ2pXUVhuL0xzWXRKRWNRNW1HUVBV?=
 =?utf-8?B?MFVsbWtYNG0wVXlYU0VLanVxRHhuZGNTaUNMU2gwZG4xOGgva1N4cFRQc2Nk?=
 =?utf-8?B?VDN2ckdZU3UzVzNIRUJSc2FacjBSbVRVbkdFc0lxQlcyeDdDL2ZlYnlYdTkz?=
 =?utf-8?B?N2pnSmVVVE5xSDk3VEhoYnBrRG5HRTc2dzhlQTRKRzRHNjloS0wyWmt5TFB5?=
 =?utf-8?B?NGhOc3NqTHdISDZsL1RycjhzVHBpTDcvNTE1Rk9aVGlCY282QTVuRjR2cHNS?=
 =?utf-8?B?WlJWVE53RlpuaHdXU0RIUkxrUXhPZWlZeXY5aE5LclBVZGp1bDZnenVLdWFw?=
 =?utf-8?B?ZXB3RHZqd3lwb2JXL3krY1FidzZtbW5qNlgrWXc5WU0wYnpDSk9qN3BTY29Z?=
 =?utf-8?B?ZXZRZVZPOVlicnlxazl6Zm54cFVGWEVOd1FHeG9FbTlhMFJFVkhMRHBmSmRY?=
 =?utf-8?B?R255aGNsTHNOalphTnoxMzRUb05xRHlFaXRUanlPWHZ4Smh3SVNjNHFPNHpk?=
 =?utf-8?B?aS9oZktRZThYQnUzdWdiRGtaR3M2K1pRcmNJUzVUS242czBZNys5SW5tT3M1?=
 =?utf-8?B?djRiYkEyOTB3NmhQdHJyN0M2MU1FTTZ4TzhERjhLNDVPRFNrWEx0VlBpcWhl?=
 =?utf-8?B?cG5qZnE5blU4UnZ2UlZqV2NKQmtZZ0NOWnRVS3RTdTdISWFkZVNPRGJsOTJy?=
 =?utf-8?B?dEFZdklFU3R2ejd2dE9zdzlDRjJvZ0kwOWIwODlCeUdsSWtRVUgyeGxHMnQv?=
 =?utf-8?B?Z2JQZXplcWpUcWRTaDAwQU0yYUsycmk2S1IrL2xLQzdCeDdhdFhIMHlRWUFS?=
 =?utf-8?B?VWdoaUJJd0FKT25PNGNXNEUyenZrVCtQOGxMREFlcnlYVk9teDNpQXJUWS92?=
 =?utf-8?B?RHB3U1hEWi9YbThraFlxanhsZ1NrWTRaNU1uYVdFdkNtbTZuQzE4WGZYQmpu?=
 =?utf-8?B?N291L01CL2QvaDFLRlg5c0FIV3RqTkpHcmRWeWRKSUdVN0pNMFdFZWlVOWo3?=
 =?utf-8?B?TzlsclE4NFNxTE81Mkw3Rkprdnpmd2RsQnNodGNXM0dQUFE4cGJJOXNUbFdl?=
 =?utf-8?B?NWV5MUJUUzRkZzltZW5JKzVlU3Y1ejFNY01YZDJoakxic1R5ZUxCTWZJUVdz?=
 =?utf-8?B?d0o4eXpjU0RuYUhFRlI0V3c1b25CN0lzVGh0bTdIbW14T0RJZExTZmFtL1BN?=
 =?utf-8?B?NWhOckxKYUNkMHlPVlZuN1NuazFnOTU3NU1OMEQvL1p0MnVxeFFoYzh1cCtM?=
 =?utf-8?B?bG5jWE1iN2huV0kyNktJbjJaV05YWjhQdXIrRFNiOTJWdk13RUxFNkZwcm05?=
 =?utf-8?B?Q2RFWURXQncyanZvc2RkRHVNMndhS2Z5cENuS1FoMmFNTEJkM2ZkVXI4TUlK?=
 =?utf-8?Q?ubZRbbEh9av1KLFNaazPF5Nro1gkW67iYMQwBrA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c088cb-a3fd-4117-45f5-08d8de6d2c13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 17:52:54.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXXFHS9rYmTXyYVBu55VoA9D2ZbyXKPlp5H57CAXhaeZWXJ8AVpBrjFjyPKhIGoZJs4jnbqgKCD5pUzz6GTIZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7486
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/2021 4:35 PM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/crypto/caam/caampkc.c:199: warning: expecting prototype for from a given scatterlist(). Prototype was for caam_rsa_count_leading_zeros() instead
>  drivers/crypto/caam/caamalg_qi2.c:87: warning: Function parameter or member 'xts_key_fallback' not described in 'caam_ctx'
>  drivers/crypto/caam/caamalg_qi2.c:87: warning: Function parameter or member 'fallback' not described in 'caam_ctx'
> 
> Cc: "Horia Geantă" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 2 ++
>  drivers/crypto/caam/caampkc.c     | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index a780e627838ae..22e45c5bf2023 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -71,6 +71,8 @@ struct caam_skcipher_alg {
>   * @adata: authentication algorithm details
>   * @cdata: encryption algorithm details
>   * @authsize: authentication tag (a.k.a. ICV / MAC) size
> + * @xts_key_fallback: whether to set the fallback key
> + * @fallback: the fallback key

I'd prefer having the doc updated as mentioned in v1:
https://lore.kernel.org/linux-crypto/963b9e57-8077-5392-1d91-a5971e8d8ac5@nxp.com

Thanks,
Horia
