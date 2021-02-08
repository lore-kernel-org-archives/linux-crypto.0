Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3576C433E9
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 19:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD41164E60
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 19:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhBHTv6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 14:51:58 -0500
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:27328
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236337AbhBHTuQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 14:50:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmv45th85F85rDtCP2MEd9iPdK1nwyXuXvpc9AdBkFga4jDPhEJ0gpaqlP8LAz9YimKojiUptOqw0Kj+2f7vBAB1BIbboe0miDEpZlW7ICKO+bC/83XWvlBXq0/TM4mXC1BKpVMu3aRkIvpTAVi4hYu5s2B4fGoAFpLa4M7aG5fvmPWZg85uCPrmKHfyrHY+dxAeNbn6S10RH+elAdSfZVhYxXPIHpxjqluHXUuN7ue22958Fa2/td3QnfySYAPC9JGBCPgHNSmuwNEfhOAnxd9F5pYaV8hXGfNKohgqZdTtsy3S6Bo0cH2fkrOHhYt5xUswtWOHJvodFbGrCQPtmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpf+xxQoXNUJ96ScAF1rApqoZSwoQXawPQEr0Y71Ndg=;
 b=JLRoudCJ2CL8Hfaw3ovV6PleFvalRE1sMlyYEt2+Pp6Ixl5J3IRj4MVpjxd47S9WAhxpMMa7GHfoQda5ZhbSQlPE1Fow0qgKvkHVhZercEZ+YeJPHSMf3Si2gkMZcPy3+DrRYfN46uIhEvf/HvuzGJ9RJFfv9t3vKheG5FxPElGXOB/Ye4nuBUYN5eehm1FJ4APHYZtFu1UYgSjJOrPaWRcZDg13yNkl84UrugVOOLXJzKwACkahFgok24Myj3g/PmB5GSRT1bEFO5jj4mE1bcyIvG7DjM0iTGb0TRVAiMbQatSi7EtuBZerS3njZyvxEhMIZBIn2FVdFRqmGfxrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpf+xxQoXNUJ96ScAF1rApqoZSwoQXawPQEr0Y71Ndg=;
 b=ZOV8gPhoNuQlqsdNLTV34sy91Y98bFZLG6kFubtLvAz10Yqs8blKeGDuTZ7FKESLpbsrA2+EIjjsxjWBkteZTKrAc1xTuA2bTJ+48H8riP+i8HYpnHb8+0TfrVocu1vB47yM6IXtP+ZfGR8srZdggkvhCTZ9hnUmExt4C/jOX7E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5040.eurprd04.prod.outlook.com (2603:10a6:803:60::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 19:49:27 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 19:49:27 +0000
Subject: Re: [PATCH 15/20] crypto: caam: caamalg_qi2: Supply a couple of
 'fallback' related descriptions
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
 <20210204111000.2800436-16-lee.jones@linaro.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <963b9e57-8077-5392-1d91-a5971e8d8ac5@nxp.com>
Date:   Mon, 8 Feb 2021 21:49:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210204111000.2800436-16-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR10CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::20) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR10CA0010.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 19:49:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f07ead86-9c4a-4939-28a9-08d8cc6aa42c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5040:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5040FE090E2C5695F8BF44D5988F9@VI1PR04MB5040.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LDEAhFaVcbxUauiCVqI1tsN5HIKYjeP5rJubBWsYjJXR9t84/adivz3gcilOj7VH3z2veVIfvkxRgCmnTnRE5tsGtIuCtFKSXx5GtJgQe0b4RHkLsUtwsXAxuF+qGjpIrPuB5WybTPLXR4fgiISo8g7tWa/HjdG/XsCm6xsU+doe9KW/O1gBEgIJk/KXrNoQvgVZBI1xgLZrA8iGeIe25EPbgy7C41IU82rfZKjLVwNufjs67Z5nynDqr7ijtaEesOQ4sEQcP8ku0i1YWwXkRxd6FOWi4jdH3xlNDkeEMCNKGL3MQdpDaLeAIt95BVfAcLOSGq/ZXU4/gymod2NmQx1pyxz/nFEH15VoxC8uoFMbCUFdeL4speOmhyFuBC9LHjz9kfhJ9lbYD5nsW6qWJA83fjas/yT3fTegE8hjRwUVh5vKUT4EfCp+sObNh4PQXegkGSa5Th7gatjVpuSVUEWeQLK8o3enoTv3anudRV8cbOR6I++ngG0KGW9u6nczbnzHhA42BElesKGh0AWNOs/pzcMkxUZhkjc6OySF0xmh9GUOoTIzONWty2yU+lm239fJR5Jms2TdD4vJKklh23BpD+sjwozbfFLZR1HleP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(54906003)(6486002)(2616005)(31686004)(2906002)(5660300002)(66476007)(66946007)(4326008)(8676002)(16576012)(66556008)(6916009)(53546011)(83380400001)(8936002)(16526019)(186003)(26005)(956004)(86362001)(31696002)(316002)(478600001)(52116002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YzNMblhCb1F3b0E2Rzgxd0hwRU9LQTlzUzFid1ZnbFJsZ2xnNUwwTHBJU2l1?=
 =?utf-8?B?YlZVeis0Myt5Wm4wQmtSVm53ZDk3Y0J6Qjg2Y0lhQVFFb0ZocFl1WTdpU05y?=
 =?utf-8?B?VkI3anhzQXEzLzlJd21KZEpyK3ZFbVNIM3dMeVdxZzBqM1ZEWld4UnJIK2pP?=
 =?utf-8?B?QW93U1gzdksxZlJTckhQUXVlVGE3ckZqdEFMZ3dZVWovT0NQWXlOWG9mUVN2?=
 =?utf-8?B?UERmMkRBMXk4M2ZJTnhQTUwwVUZyVjRTSlRVVkF3TS9PamJLNXlYUzE5bU9p?=
 =?utf-8?B?THllUkV6V0lucW5qcHF2LzVqY3JENUp1VDdWc0dDR3ZpQ0hiM2RVTjE3WWRw?=
 =?utf-8?B?eWszRHVaTk1CeWxaTVNpdnU2SGprYXhXVnpSQVFhOVhaS3ZqV1VnUjBudmVV?=
 =?utf-8?B?NEVUS2FVbnZ3YmVNRnM2NGY1S2NqNWhobW44L3BqNHQzZ1hzTHBBUEhta2g3?=
 =?utf-8?B?SURRMEJOVmtlcVhXSUZ4MkZRK0dBL2UxT3FkOHVFZ1VhNDF2blNRc2FMT0tB?=
 =?utf-8?B?cWN2NlZBOUZXczRYZ2toODlpSVZaMTB6ZVIybmpFZEpsWWJTb05wRlVia0c4?=
 =?utf-8?B?TlN6SUM5cWZja0ZXZ3RuRGhibTNONHU4a21lOWg5VS8yN0VWTXhGc0ZZNnlS?=
 =?utf-8?B?dzEwRXlHNVNTQzZtVjJyTVZYcmx4YjF3OVpWYzJaTTZ3L1BPdEtLZ2JmWjha?=
 =?utf-8?B?MUFtYklOTWgyYnNYN3RQQnN1NFpjejhiUEJmaVRMRXovTnQzWk9venhlNjlM?=
 =?utf-8?B?STFSeGVVRWNTTDlrdTMrMGh1VExNNm9PVFRmRS9iZDZMVWxpT2lTR2E4WlZ4?=
 =?utf-8?B?S1pvY2J0L0NtRjcwbkFDejJQemRmNGEzZ05xQWZZVkZRSWpUMWRsZ002cjFW?=
 =?utf-8?B?N2EvNk9qNi9HL08rUWZhaFV3ZnlzTTVqa0M4dlJxakJDV0F3N3NDZlp3aDFT?=
 =?utf-8?B?SFdRTVRyZ0RkdHB3cTNaUEFpakc0VTl0VDVTV25iczJIazVIbzR0YldCNHRo?=
 =?utf-8?B?bzdBYVZ5ZmlwK2gxL2tBWlkxd3Y3L0d0QWFBL3pjT3p2a1U1UEtqemRsTkVZ?=
 =?utf-8?B?QmtDbDB1aUMxOWlTdXcxRDFJTkFUOE1WNlFGVHVuSG1nK2R6TnNUcHpWWm5H?=
 =?utf-8?B?eFZMaEc3SVVxaVlVZVBTcEZacFBHSHlndGt6TG56SlRRUlZqMFVqZWpGZkVC?=
 =?utf-8?B?ZnB1WFY3dlVSTmp2dUtKSzZoZGtLWkc1bFA0NmY5dVFEZEg5UVhpZGViTFFZ?=
 =?utf-8?B?Njk0RERxSlZHZXdDOXVDVlM2dTVoekpidmcxZGVVKyt4OEVPamVHY3NOdXIw?=
 =?utf-8?B?c1hlRndxL1h0SnkzeUlDL2dGaGlHWUUzQ1RBU05TN2IwbkQ4L1ViZ3RmNnNp?=
 =?utf-8?B?ekJrdThpZlFzY0dRb2pEdnJOanZMZUVxQWZodG05Q0NxWCtHRFNoUGp6cEtT?=
 =?utf-8?B?UE9SdktPNHhPUk1QWkkxZWE0Rm04cTF2UmNUTk9IUXhsWlJtMUxla1RlUHMy?=
 =?utf-8?B?SlZxejVaNkFleXhJSUQyS1lEWXFDVnlkeWs2b3pJOG1YUW1OaVV4TmNJbkhW?=
 =?utf-8?B?N2ZLWjBubjZlOGszQXc5YUZnMnlxZHMwc29UbnJuVTNPaFo5MCtSaytUREd3?=
 =?utf-8?B?K1ZQQVpVeUVUNmU5ZmVYSXBEc1ZTelF0TElJeFFDMG5uUWxKSGlSUkxOdTVa?=
 =?utf-8?B?akk5dHJtbytmTjB2RzBtWllBL3crS2pEV0phTEtwTWRTWTcrSGhpd0hBUXJI?=
 =?utf-8?Q?ZsJNo+X5tc9NoxtjJLpA3Ll8Kog5on2AOXsrUjN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f07ead86-9c4a-4939-28a9-08d8cc6aa42c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 19:49:26.7541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hE4uONDzD4tEhL/fBP7wrdopNJ+PXHXT6312MAbtTN/1kLylr79r4lL/Zk5FLewXUUb3DyN633ftLIk6PQmy0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5040
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/4/2021 1:10 PM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
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
>  1 file changed, 2 insertions(+)
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
true if fallback tfm needs to be used due to unsupported xts key lengths.

> + * @fallback: the fallback key
xts fallback tfm

Horia
