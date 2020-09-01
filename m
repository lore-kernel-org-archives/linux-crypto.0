Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759FAC433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 15:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1F820FC3
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 15:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Lo6ZAfnL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgIAPFj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:05:39 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:49313
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbgIAPFf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 11:05:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZE3Xe9AUrUctBtkky4KaXl2CjJRhkoAbAjAQsctXe0vmwfOnhBtIMq+DApfLSQj9Yo5knI3HCe05mtsdROLqnMSDNGM3MkZ/3Dvg8dOJQeyhXRzKEVBaWBOkq63Bac+BXvbKZngA1x1ElMnN1xwpX8eCxxo63t4xRRDmeXvYTOlF6J8p7hrYCgI59V6r4tIBN14BEAlpCFdRh9qXgzGJDCOmyu061ab0Wd6wf5SrJihAI8JZJESUWrDC7CV4JsgkyAtmQL3yFtdMoOSQ+KrtCMNlO9DaATvvyzf+w2szSG0c9i3pOD6Dn2DzP8wiGf1xQba+3Jbp+n0K/z1wT7GPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU3b0c/XTj8rj66YVJ8p+pWeAt5egagKsyONv0mz8zQ=;
 b=WAUyH7FrbnnIu3AeB0OY8eqoAkct+GcU7XhuOF7MFVM834rqmmfK2ynDMKGXTyhpcNcYrDLsK+wllGJ/mivyejVKhU+a1e/1ggWRsS71nxhtkNkx1JZhGmMxyl5a1Tl3VFGRz7KnTDunCtLgl9rk/PBv1Elo+aV8IIzElgMCff/E5vpXAF/X/Kxng/pJkZ7lK6IvN/l9eP5Ycv/94VEYOHd9s2gGgHv10eWxAnFs/xpSVLuhJS5cEXwaozOqrPTUtshGrTfQ9GBByD1EthvsRQzC/b0HB61+3hrMI/GwDOm7G4kQB4B3zlSTnTeIqlBcVRcI8FUcARVSlMlUFRXeYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU3b0c/XTj8rj66YVJ8p+pWeAt5egagKsyONv0mz8zQ=;
 b=Lo6ZAfnL+UdFyt0V7a70ccjOvTLR/gtt4c+im4bjT2c9VuOuk5UNUso6GWcisqUuJFpQb0VktJMsWxkR5xmaKnRqZ8tYpBBctaowfOXd/M16yVruqX7L/ssQZjj773krE3vDO5jmfcUid0ACdmlsFnqwgBm8hJf21bjfyT4GC5s=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR0401MB2688.eurprd04.prod.outlook.com
 (2603:10a6:800:59::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Tue, 1 Sep
 2020 15:05:31 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::2951:31f4:4e49:9895]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::2951:31f4:4e49:9895%5]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 15:05:31 +0000
Subject: Re: [PATCH v1] crypto: caam - use traditional error check pattern
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
References: <20200831075832.3827-1-andriy.shevchenko@linux.intel.com>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <2306619d-66e4-6f37-8e16-6d97075081ed@nxp.com>
Date:   Tue, 1 Sep 2020 18:05:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200831075832.3827-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0018.eurprd03.prod.outlook.com
 (2603:10a6:208:14::31) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.13] (86.127.128.228) by AM0PR03CA0018.eurprd03.prod.outlook.com (2603:10a6:208:14::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.20 via Frontend Transport; Tue, 1 Sep 2020 15:05:30 +0000
X-Originating-IP: [86.127.128.228]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1dbe261c-9693-41ea-f4a7-08d84e887814
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26881A6BD0ECDDE24095C1BC8C2E0@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTcTPGGGbdFKT/iDbKM0eEq2FgDOkRq7mVb9Todfwo9gpfTOlAJeeXcQBALwQDLxlv1vuyXJ7/4SgVHvdAQuOj6l7XQwSNNDR4qlWb2ixT1d/lemZOuWiXCL4R6vncQgMhcLUgqDGfjYLbMsJLAi3V6fpnAJN3zPbdcUaPYwbGMekubux5EbDTh2sqAspyMsKySKGMP4s8//vspAPljPOgzGnD7uZwBGyfq6zmT5jCiUUZnXgnlII0jSSexxHWwjDO8l8gO5mDR+lKMXzz/N8wYJPFBmjXhe7XFBn0oL7Dv3lUPiWprvKYGTDP++vxVLADTYDVkY58A1uURrouALuUieILiKh+77HBuFXIpXvLcBdbQGA0qcqgTeaZ6viUD/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(26005)(316002)(66556008)(2906002)(110136005)(36756003)(6666004)(53546011)(478600001)(6486002)(186003)(956004)(8676002)(16526019)(86362001)(31696002)(66946007)(5660300002)(2616005)(66476007)(52116002)(8936002)(4744005)(31686004)(44832011)(16576012)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: osjaPi2eBYTmwY0OsLbGkdAqtUINZ6e+AqkJQREDTw47/pky5r7T6NPE82RQGuc6tReRQIvamf9Hq0UstefZoflEiYfAeQrOjlaK0nN9qoqHU5RUH13dL9ji1ux82pkmPznowjHo/dB68CxgmMAkbKfxO1JCG9E2F5BKxlM9GJA+dQuJ/9icr3p6SuNm+UCXA5o8w8Z+ApLzkB1OjZ/u0ZA3KS6es7/Di/+JnyZBQMjyFZ8ZGEPgFYGqwF6JfxyQwMWL+nPEpmlKf79QrkgBjr67ZcJ7GT/ZTZdoHy/BlcoGXrn7his40ti7TlzSNOekP5mEtbI4pR5z9U6TvUOPApWlUaKzCpg+YGj4QuUeX3+foVdZtwuLTtxak/U3fn+26oKEb09vr6gvKlnOgVVocTYV00ArJYpbR1sDPrrPqdYNbXGJfeYt1rb14zf9Lb4SLNcNeV0B9IJxW8x9wCY8YnByBhji1eTKt3NvonQ3JNze8HHyNwNMFbOdLqEg1xkzWWP4GL3/gVudpmSZvOYddcnsq3D+NjhIdgz2iG5VsLddPmmWmoH8fSlrtU3IkQ63UICgrTINOSMcxbihQjujOuZmrQ6N3u/BPJDdzI3OuSIPIFmmrYLUMh0cDFCql1mgKT6kvRG47iwWKWunFIPA5Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbe261c-9693-41ea-f4a7-08d84e887814
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2020 15:05:31.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3lz41E5oO99kYgQVwHVrMvk+dhXjg37jJu3tvmoTl0qMqreEB3s2VuqP52lZ5LcNi9rayzINlF/s0/GbLaFZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 8/31/2020 10:58 AM, Andy Shevchenko wrote:
> Use traditional error check pattern
> 	ret = ...;
> 	if (ret)
> 		return ret;
> 	...
> instead of checking error code to be 0.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>

> ---
>   drivers/crypto/caam/ctrl.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 65de57f169d9..25785404a58e 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -333,11 +333,10 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
>   
>   	kfree(desc);
>   
> -	if (!ret)
> -		ret = devm_add_action_or_reset(ctrldev, devm_deinstantiate_rng,
> -					       ctrldev);
> +	if (ret)
> +		return ret;
>   
> -	return ret;
> +	return devm_add_action_or_reset(ctrldev, devm_deinstantiate_rng, ctrldev);
>   }
>   
>   /*
> 
