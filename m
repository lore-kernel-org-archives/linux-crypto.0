Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F23C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9A5206F7
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qYP73Lap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787363AbgJZRLf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 13:11:35 -0400
Received: from mail-eopbgr10087.outbound.protection.outlook.com ([40.107.1.87]:58755
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1787216AbgJZRLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 13:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+A3iZPS6dTif+K82Vqu7akIh1hq8u9chbGp17LZbngQQOfpvt2EhB9Bt9faZu4U458nRX2ItjMI6yUTb+JHBPiHnQp7Bny+xogtO/oyCXO2OP2evK3r32zCoclwP+73GRIgiv4Frs4v1YY6FXScFh5CaZCWm6UbHrweWeZoNhJbrHiiJLbP5zx/3aKxCy7qL28XHedVXbGo1jtpaO70D5EvXyoothKL0jOaJEDvlX7v7N4GTSgRDKAq6LH/T9n/7uHYZwlsiIlORZ5qNixKScr6rzeG98X1CwcQoSsx4Vdikebr3Qx2RqcY/5S+tZp2wRvfNWFMaMHV2JRuzIpYEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9pIzmHmR2sRkjD5GnLwChBjnt5nFXUXP/E01AYxHhY=;
 b=R3JiEs5ktduGpHnYRGyDQoOh5EPJnITygsN3pXT3zDbszSaWnC/E03SsnLdlBIKMWK/JDFVNEPR9JUT0eV3T7R25WE5hOpEg0HksZfrT1Nmzu6drMQ1HRPoUy+nFbMqHex4cvNNkhFiTti46V0ObacgwA3+si8RHp8MrGKofhauVta6ygDBd3ssA6Z82xqDKamYxYHe2C8jpiaIbsDcgPGxmYEHMys7gdl8tUrxB9v8rNtLyEy/DGrxoRiRFrzAGD1D+sdpozP+TpHmli/JqsKViG+lF17vCzyvqybnemM810UmZ1UQXg7v4ASPRyFbut/o/Vgpgo+6kdFEXKeFDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9pIzmHmR2sRkjD5GnLwChBjnt5nFXUXP/E01AYxHhY=;
 b=qYP73LapfbPyYD8czXXyfHtr+ccrPOfgn1fWI0t5yYvzovpfvmW8Xfm+FkdFTp5aVj9SB09zYIui97GGrFmg5oz99NWKpcKkZw9zrFM09J16dKESVoO2zT/GyQ8vDJqVQPfHARdR3+wD0wLeNBBr/5Ta0dQ3/nt/1sAY6qlYEHE=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6271.eurprd04.prod.outlook.com
 (2603:10a6:803:f7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 26 Oct
 2020 17:11:30 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3499.018; Mon, 26 Oct 2020
 17:11:30 +0000
Subject: Re: [PATCH] crypto: caam - enable crypto-engine retry mechanism
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Dragos Rosioru <dragos.rosioru@nxp.com>
References: <1603310810-25307-1-git-send-email-iuliana.prodan@nxp.com>
 <d54a2528-11a4-8a54-6454-a0d0fe06f39d@nxp.com>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <ebdad102-fe91-7324-8096-dc1dc2313786@nxp.com>
Date:   Mon, 26 Oct 2020 19:11:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <d54a2528-11a4-8a54-6454-a0d0fe06f39d@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.25.202.39]
X-ClientProxiedBy: AM0PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::15) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.4] (188.25.202.39) by AM0PR07CA0002.eurprd07.prod.outlook.com (2603:10a6:208:ac::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.8 via Frontend Transport; Mon, 26 Oct 2020 17:11:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2cb7b4d6-1dec-4e69-1e82-08d879d22e50
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB62718E6A94DF2043AAB093378C190@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gq8/wV1uMdHZVuaBOmSDtp5PToWKCZwPWzPllwJvWWEYJyXKqKQXt5av5XxMcROcppMb0B0b6yDh6QHgSvtiaHLmULdraFl8fll0Wt7iHvudXRhIDQmIOUUF1kob93dtJa/lSThfzyJRO2Lhd/XcwZjFp4ViR/uo2e/FVSHD+OGYgLHYX9ayPenaJGSI0Jt8zCkJzp/AXkZuQHqklJRdu1YF06be6k7vOnSwNAbQ4xPxmUAyI/vrbV7Z1zF/DiynRNsL5AOlO/AkSe7qfVVtAfL9HMWAM6faQ1uv3jp9+tKbY/Dsez9VHK6rwvfqgv5PXRYzKnzwpkXwCuqaUOn6tC5pJ05OMNylNX+A5tySsa2mjrZKLtiUf34/mYrH6uHN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(66556008)(66946007)(31696002)(8676002)(86362001)(8936002)(44832011)(6486002)(2906002)(956004)(66476007)(83380400001)(110136005)(186003)(16576012)(6636002)(52116002)(4326008)(53546011)(478600001)(26005)(36756003)(316002)(31686004)(2616005)(54906003)(16526019)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: l1zWSGhT7qIjsyP6nv6qqmEFCMFDzejwaSvEf2jrm5IAtsjtv7quUa8E4Hmd/Sb1KMMrX1eH7Xo6GsEnMaAgXnitEysc+lROvYd8PdcuXYo7tLUNkInVk7/yTKYoo5n6/QRLAtlxWqOe450oZnkTJbmCGEhwtoVAvW/RCAVMUKp+DFWb4o/uKFlhHBDM9MXXTR0Top2KsuE50V6qSU6v8Ui2c9Igplp6sUcY9rjzHX0e2zxwM65jWYssO8YsL3FZbUIW5LTQ1EZermxpfwO6ewV3cQfWW5if0E0vhF57mXli5K28+J8SYcLYhiABZ+QbHeauTik3tZvrn1ZkTa7TDKrc9qhgsJULp9dKe0TY/jxM1Q0txQ8A8xmI7ebJHfbYHKKYhKECjyXptJCWcbK6Wwx2ZzcY9kL6zOub5oWKPUJrG/6DMulv6KtaNRqnAFPz3WxH88vuZ5iYcQmZcl8UiMpPl0A3CZYSg2u6yHxhpjzSBUoAlSRoyzUgCccMMmWd2nnaeKgWtOw6OrtaPne/n4AdjVdC6y/x9s/vOgvM/Y3sAnnGleL6PO++rWRkK2cRfquPGcyJOGSMWPCnEa817nTQS/V+qi24STl+uwXcBoGIFReuz3oCd5lPpw1pUS5+DoGPwLzzBXNejSRTOQL95Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb7b4d6-1dec-4e69-1e82-08d879d22e50
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 17:11:30.1789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3dHPp8i9PJpqAyvgXIngrYlWYgBbKAvYXgRk+UnbtZTOnjn0U8icEvWEDM7ZoS4LKQv4h+V+ZD1HJHSQLRVqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/26/2020 5:36 PM, Horia Geantă wrote:
> On 10/21/2020 11:07 PM, Iuliana Prodan wrote:
>> Use the new crypto_engine_alloc_init_and_set() function to
>> initialize crypto-engine and enable retry mechanism.
>>
>> Set the maximum size for crypto-engine software queue based on
>> Job Ring size (JOBR_DEPTH) and a threshold (reserved for the
>> non-crypto-API requests that are not pass through crypto-engine).
> 				       ^ passed
> 
>>
>> The callback for do_batch_requests is NULL, since CAAM
>> doesn't support linked requests.
>>
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
>> ---
>>   drivers/crypto/caam/intern.h | 3 +++
>>   drivers/crypto/caam/jr.c     | 6 +++++-
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
>> index 9112279..44fe6ee 100644
>> --- a/drivers/crypto/caam/intern.h
>> +++ b/drivers/crypto/caam/intern.h
>> @@ -16,6 +16,9 @@
>>   /* Currently comes from Kconfig param as a ^2 (driver-required) */
>>   #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
>>   
>> +#define THRESHOLD 15
> Unless there's a comment added for THRESHOLD (e.g. what's in the
> commit message), I don't think the define is helpful.
> 
>> +#define CRYPTO_ENGINE_MAX_QLEN (2 * (JOBR_DEPTH - THRESHOLD))
>> +
> What's the logic behind multiplying by 2?

I added the 2 as the number of Job Rings.
My logic was that crypto-engine is one per CAAM (x no of JRs), while 
JOB_DEPTH is per JR.
I know there are targets with other than 2 JRs. Therefore, is there a 
way to get this number automatically?


Thanks,
Iulia

>>   /* Kconfig params for interrupt coalescing if selected (else zero) */
>>   #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_INTC
>>   #define JOBR_INTC JRCFG_ICEN
>> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
>> index 6f66996..88540c9 100644
>> --- a/drivers/crypto/caam/jr.c
>> +++ b/drivers/crypto/caam/jr.c
>> @@ -550,7 +550,11 @@ static int caam_jr_probe(struct platform_device *pdev)
>>   	}
>>   
>>   	/* Initialize crypto engine */
>> -	jrpriv->engine = crypto_engine_alloc_init(jrdev, false);
>> +	jrpriv->engine = crypto_engine_alloc_init_and_set(jrdev,
>> +							  true,
>> +							  NULL,
>> +							  false,
>> +							  CRYPTO_ENGINE_MAX_QLEN);
> Let's make the argument list more compact.
> 
> Horia
> 
