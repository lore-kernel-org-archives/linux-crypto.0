Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34841C433C1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 16:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 003FA61939
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 16:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhCUQ0p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Mar 2021 12:26:45 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:43076
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229952AbhCUQ01 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Mar 2021 12:26:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6/pVyPe0wRd4msopMrKjlH4EAuzc/xMBEhB0wc0C7uzZyNdlCaQQeUEqvWNNZ1mi+bADcVqbGgt17bOucJwDl4sdSwCPBVqJOcu/GwAZ8dRmR7HQb+Uw7dGRpbftybPIr/Bpvx0985moZ+dGw7GsD5/Zzhy1ohswuuHmtsLM9mPxkGtOhozRUU8CvgXNirAp37ahtmZlS/CudpBLgnJ0K38d67ophdNY8RrNurEtRSHBnO3dfobv9LMWQ5o3ZB6z5xcMbdNn7Bxn8Yyt9DJCo4rvUvifccwMfwY8wsuB4i+XNy9wT8OqAEm0/CRAee3Fu0PdFNzYppJoawZ1Gnj8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+gxtsv4v3fsL/wq4CbH9weApvLmFlK6+PM9Z0qRet4=;
 b=I40V03Nzq1yJ8wSdFHfNoq7U9IGy0uYtOy0Xe6YgNrZpTWMOfpOyJaLoouq5s9aruJ5msWpz1iU9tq1GIzxk7BboNvlw8Hv8bnuTFs54U3HbOHrbEXbpbRN1sHCXihV4gUtjvBZWEsKc/NTZIuKbncex6osqM1fFiemLEXYpjJxMcx/BoXTLiUD1PXtrsBWOttpfbdpvrIvtTFRwxSbfGR0JAQQzAqymppVGZCo8g4uaIyQir2deyV/rktngzYxi5IglbCUg9xXTQH/p/cnKzPlk8ZehejFkKXCW8APc70yUiUOJaEiOMceZS7nZDDlerZmdYJBP0cMobcv14ngsKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+gxtsv4v3fsL/wq4CbH9weApvLmFlK6+PM9Z0qRet4=;
 b=k0MrOwhqGsPkirLhdALOvLRjzQHxtLHEK2yAiU+oPIknZpt0RMvyjlxwRUvRETbohDG58sHmYwJTCEGYf2Zn32/RJGKxlcMNVELWJZAXZqCjMx8BvKlpvGz6unbf3UI4brjbIbFBv2t3IIhfrNxr0N+diTk8p0ZSpGIRsjK2Z5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR04MB5415.eurprd04.prod.outlook.com (2603:10a6:20b:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Sun, 21 Mar
 2021 16:26:24 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::ec5b:262e:8c27:c742]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::ec5b:262e:8c27:c742%3]) with mapi id 15.20.3955.024; Sun, 21 Mar 2021
 16:26:24 +0000
Subject: Re: [PATCH 07/10] crypto: caam: caampkc: Provide the name of the
 function and provide missing descriptions
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
 <20210318124422.3200180-8-lee.jones@linaro.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <47275875-a9b0-4b78-30d4-eedc6d360d3b@nxp.com>
Date:   Sun, 21 Mar 2021 18:26:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210318124422.3200180-8-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM4PR0202CA0023.eurprd02.prod.outlook.com
 (2603:10a6:200:89::33) To AM6PR04MB4038.eurprd04.prod.outlook.com
 (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM4PR0202CA0023.eurprd02.prod.outlook.com (2603:10a6:200:89::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Sun, 21 Mar 2021 16:26:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c12f1f16-26f1-46fd-7c7a-08d8ec8611e0
X-MS-TrafficTypeDiagnostic: AM6PR04MB5415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB54157F26EE8DC13AE1FB482298669@AM6PR04MB5415.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62PNHKYngb+XbWlLq0CQhM2MQexlH3KDuh2E15O7BvUndh2zzEGZhDTAWGaKM6sM4a/rl+b9hda8hCzxXOoEr7wiWXWsQ2B4kl/TT2sJs0gBSf/XWXEvORXZ0zXPLCywg9Sh3cVAsoXvOp5SFI9K1e9i86Lyw6ttOSxqxWd8MVp/71+VEjL71AkegL2UgF3K9mJtpJMgh/yMrp+s2qrq+SGf1+4wzEsNfXPxV4mvTtMZC7bGbisbMjzC9aWjEnfAx39rG/g+nfC1GrUFW7QMuDp9vLaQBuE5vR02JI9ODt/Kak92NkW+qirN63AoNZ1YEhY/TbJ3TKD7V+VfikyeZHlqJ2uztAPTOWUxdcc98Z9H9f9ztFWh3tSWRQ66QRWQeqZl37DqoKRcCkR8Y7qEW7nn0axMBoSD9dxXjTZltH7ZhVf613GzWDqg1/zwSEaXZenAj61EWpxyM5xXM2RLVqapsXPjf++72rYr49L0RhCIIDH/XFVzjOMAlMpxzspeAszRNKB313la//bf9ruHpFWQU9wbFZqaD58JxAZUt5eM/D+vvMzeDx6756uPkj4rgDoxa4pHQD+whZ+uiE2q+LF874oCpqvz1G8Q/NxtcNIDNZSo9yebAIsJd1Rij8lRcimS+Gw+/EpvaabZfeiTX9LGX98bTOYREj0zP3ZrAkhIEBC3yl3IqXmFTheXN9syZFe/r6PnML7gDJ9kaPNd0J8rQn7C9RCTl+P47GUGkiM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(956004)(6486002)(66476007)(66556008)(2616005)(26005)(16576012)(38100700001)(316002)(54906003)(6916009)(16526019)(186003)(2906002)(86362001)(36756003)(31696002)(66946007)(31686004)(8936002)(8676002)(83380400001)(4744005)(478600001)(5660300002)(4326008)(53546011)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dGpOVVd1LzBQWW5Fblh2UlVnRGhYaElGNXRiT0d3dmFlakFneElxR2ZHTkFp?=
 =?utf-8?B?RUJrVUhuZ21ZWWdNNVFRb01vbW42dDlkT2U4L2lPTU1BV0JEbjdxOW1zdGtt?=
 =?utf-8?B?YzJzRVZURW8vWnlxcENqZlZoTjdXeHlWeHNBUnVKdmpCSVA4aEZKWkg3VWMr?=
 =?utf-8?B?cXRZWnMxWTNvdmoyTHVubXVsSUVGSjVpREthMk96UHFleEQ1amJSMmNlZUNZ?=
 =?utf-8?B?cThqdVhnMmprUys5aThxZjJPYWJXcGRQNXRKVnUxQlRkT2cwV1dJeHBISWhP?=
 =?utf-8?B?ZWNlSkJ1bEREeGV1VVlwcDd0dm9ubkdLamQ0NHMzOHNDTkM5YkU1ZE5hYUJp?=
 =?utf-8?B?YjRJem9nR2NYTG9kSEtsNW4yN3BveWRNb3ZjUUJiVFRtWTJGWUN2dDdaV1FK?=
 =?utf-8?B?Mjc1eFV0SG50WjQxYU53eW1nOFl3TzdiRkpnRjZVVkFrNHgwaVkrMHNaV0xX?=
 =?utf-8?B?TlZLUTdoOW51TDdaUks4WHR0cEpUNGJ0REluZDFkVE1IK1lNTkRGaXRva3lz?=
 =?utf-8?B?dFdkbzhuR1VON2xneU5SNHBZK3BaWHJiM2dYSGUxdk1xVy9OU0g3SUV3akQ1?=
 =?utf-8?B?M1BoZ3g1dkxVUFBXZzdGd2YvOFRiUnc4MExIK2I3N3o0NG4rSlVWOWUvdFYv?=
 =?utf-8?B?Q3QxZTdhZmN5bEhnQ2xYZU1YeGI1cWRWSjBrcE9DY1gxdUFHVVNyN3JQdUtm?=
 =?utf-8?B?YmVoTnFtMjRxZ2xla3FMMG1rN0RCQ2oyRWppZWwxODFzYjZJSzg5dVo5a0dG?=
 =?utf-8?B?UXB6MCtJTzM5a2hPL0s2dUtMTEwyOHNoRkZBK2pkam1vWHNJV2VJc2ZER28w?=
 =?utf-8?B?bjhuYmhHWVk2UkdraWRYYkZGTnBITlRSd1ZXWkxQRVljVTVuTnNKa2lnMkQz?=
 =?utf-8?B?aE1yd0JPM3oyNmtKUWhrOFhOaG1kUnUvMldacXVwMDBqV3FPa2Q5d0dQcG9n?=
 =?utf-8?B?R01xdHNVTXN1TDdZRFJpNzJXMGhWRlVoSENWUXVuMVBSVGRqM1pkaW5Ed0M3?=
 =?utf-8?B?Vlo1T3RkaHhNWGU0VnpzNDhtYUZ2ajk2MWwxU1NKdlBTOVJpMlZxaHBxRXhG?=
 =?utf-8?B?c1JEUGMrOU1JVGg0aFVFOVRKZFJSNFpTQ2hrWHUyVDcwdGlaTUd3dG0rL0dk?=
 =?utf-8?B?emtUdWRONGtocndLR0d1NkFkb1Fsb1laOGJQcWovWlJaSnZCeitmZzg1TDEv?=
 =?utf-8?B?TlVsSjFKZUVza0tSWEYyQTUvMXZFRnJ5SGZaQmNUbWpqQ2ducyt4am5EU2pO?=
 =?utf-8?B?V0NIQ3lLL2FyYVY4UUFRcWlFS0NXOTlTSG1RTG12TUh6LzVJUmV2bnU5bndR?=
 =?utf-8?B?azNja0wzZTVmNU50UWd3YjdvOWtGdXpWTC9VRFJBYmtYa0NkdXJPS01JMFZD?=
 =?utf-8?B?eXJnRGc4NXBibUNxYnpuQzE4ZmdvWEkwSFhESEFidTZWNFhGUGpVblFjeVBO?=
 =?utf-8?B?QUxoYzFpNUJSNFFLdStUdjZNb05xNzhKQUNYZVR4U0hoUFhIMVFRWWxFcWc0?=
 =?utf-8?B?YzVKdUFRYUFlcTR1N1FGOGR0SHFzRE5Bblo3OUVGNHpYRnFLdFEwTHQyTzNK?=
 =?utf-8?B?ZGxhUlJST3RCUGVBRXlldUFDK3lkdEFQZzFHazB1QllhbjRHcmdwVVRZcSs4?=
 =?utf-8?B?SGpVV01FMlg1UnMrS2hoWU83YStyZVREOXQrUm1Nc0E2UHg5dXNNa2l3UzVX?=
 =?utf-8?B?ZTBUWDY3eWt6YzBSd2RtR2pkTFlsVHhubEJMQndtcTRtZ2h4MFdmUjBWVTFK?=
 =?utf-8?Q?kIpnFel/YCc3c6ZYfVtJMZ1qXDRfziS06Hr4HI6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c12f1f16-26f1-46fd-7c7a-08d8ec8611e0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4038.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2021 16:26:24.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNJ8mPz5/FlRhkPCjAtzBTx55TrrKZNRChXcj6yk6jbgIhgrWg8fUarjwlUCqnGwlZTwHgeqQ3VFpm+oZLITIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5415
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/18/2021 2:44 PM, Lee Jones wrote:
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
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
