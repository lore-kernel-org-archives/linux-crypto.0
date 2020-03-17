Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B84AC1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 21:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECF4420724
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 21:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aeY35MhD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgCQV6q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 17:58:46 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:57966
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726776AbgCQV6q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 17:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj0NtH+K92rT4755ja7KPiJ1cEYuCdC3Be05xP12CL+6jyAqWgVMJ5/EWKk72mnHB64xJCsANnyI9pfYkPFUhnl+Bncnvvp+LHBm2rEV52of4kkSG99px22P9TNPcIKAqHgZ9OrKVao6sPHyYAbGn775fnn/WZlsVOia+7+wNjGSYZw0X2FiH8ziA72j8RkyWffiQSAbq5MOA3Ee0nQgThMRViIf51MdoxsYlCr3IvHvi7wsIHGO+YfdN3Y/OeR/tc/owNlwSG4Boh3tREN8+XHjuafXQIn5sb7PZaxOPHuvTqvNYnFkNjigTdoL+vfXfsSeh6PX8KtzLmcR16kUDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RckPWTMjoQk8klQjLZY1ivS4ZrMxw34I/kd/PyL5P/k=;
 b=g2jLN7CkPl6LXcapq7RKXsPG2jGxxjtoJU8PoHdyuxiOFN7cOcHFEhf4TeUrCZcUiJoBNxs73T6S61MNHcNo7mW9761hN/ibml7RhbTsRS/akuSA1OLlltQXtGHAIrEOEyDwPM6NTbLsd/mKUB3U95UON+2SEl7kp9apOpL4+63Cntu/yGOkE3nXRduHAbGmVxwxh5qQQkChqDNx7E7kS/DWPRb/820CwbJSGz/47NnO3hYimgpSW77gZTeYVBEitldWhWgUsnKqzkzDGNhED3fz5QzcNm3QYCW8ZR5El++QkVBtvGZSFzBy5Y+EMMDUnwpu2Ptt35YwsHhKRAMLgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RckPWTMjoQk8klQjLZY1ivS4ZrMxw34I/kd/PyL5P/k=;
 b=aeY35MhDp3u01CQFccH4iurHmJ/2d124sb/oQd6TGfEtlGSAOhbTrCCkpzpk+GKR+QOlyWPLHEziY8MuaR7IuPLYQv7HWkOVx6DkPpxiL96nZVRxHR140orhXAE8faT3MzwlDxgt1I3UHAGGJhX8Qm4BBEyQoYndQ8bmpQSN8eY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3919.eurprd04.prod.outlook.com (52.134.17.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Tue, 17 Mar 2020 21:58:42 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 21:58:42 +0000
Subject: Re: [PATCH v8 4/8] crypto: caam - simplify RNG implementation
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-5-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <0f5819d6-3485-1d2c-effd-4ae6d54f2498@nxp.com>
Date:   Tue, 17 Mar 2020 23:58:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-5-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:200:42::27) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0701CA0017.eurprd07.prod.outlook.com (2603:10a6:200:42::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.10 via Frontend Transport; Tue, 17 Mar 2020 21:58:41 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 63420daa-5f15-4d3a-d1d7-08d7cabe5b64
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3919:|VI1PR0402MB3919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB39193CC26B3099ABF6F64C8B98F60@VI1PR0402MB3919.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(186003)(26005)(8936002)(81166006)(16526019)(81156014)(2906002)(8676002)(66476007)(6486002)(53546011)(66556008)(66946007)(4744005)(31686004)(5660300002)(31696002)(478600001)(52116002)(86362001)(2616005)(110136005)(36756003)(4326008)(54906003)(316002)(956004)(16576012);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3919;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BXWM7vuKSe2JztR2u3V5Zd0Mc3Xok9gIJxh4iHYQaLvWe6OTrknBBZ829ZmHRyFtCvNxLI4N6JBC3dZvD27eN3LAoD/+SyNiCOT1Rqy6b/R6sulgSpQ95jRNEQYjAb7EBzerkcyI8jDEo3zhsRW6x68u8gWFVvc9h9WsWSGxUPTg2//eQeaOY3iIB5li//sfwuWBfNnBmUstQDRbAwDu/Lp3ZGyfl7ZF+5Khk5ML8oF3fYuy9rebWDDwRBE8hTDPP/KS0KlXb6kAn9qk0aB3isic0FATcnXrxQUPDu/2NbFhxdxgaw5jUx9ECVJVkd8QvG338hldObfKKHSt6ZZGFQgNjNcG/cCey8XENXrqL7FPWA3cy8FmXSJ7vQSxp8B4WUBCOr8V61a9cZyl8k+YEUe554w/JbcdFhoGS8jNHUakWFBj6ar8FhFZCUe1dQx
X-MS-Exchange-AntiSpam-MessageData: wCGKkWYNo53KAVt7zXTT0L+XA7WjSper4I0Pcumj1n/h+AMnnETl4L5eZTF5Xqb2z5sOUlKFz3XzZHvmSlFwS7I7yxYi+XEL2VpgZR9VNMerccoJ/S9wXqIVc/bcG+JNqY2Xuuoygza21WOToc5t3Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63420daa-5f15-4d3a-d1d7-08d7cabe5b64
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 21:58:42.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6vSV3mI2xBSzVlLMa0fAWWc2DTfFcJqDi+IiqMprvI+LzRzlQ0vb14+doho2HkFzArm5LB4irPfmdgJB8jrQGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3919
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> @@ -335,15 +225,18 @@ int caam_rng_init(struct device *ctrldev)
>  	if (!devres_open_group(ctrldev, caam_rng_init, GFP_KERNEL))
>  		return -ENOMEM;
>  
> -	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
> +	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_KERNEL);
>  	if (!ctx)
>  		return -ENOMEM;
>  
> +	ctx->ctrldev = ctrldev;
> +
>  	ctx->rng.name    = "rng-caam";
>  	ctx->rng.init    = caam_init;
>  	ctx->rng.cleanup = caam_cleanup;
>  	ctx->rng.read    = caam_read;
>  	ctx->rng.priv    = (unsigned long)ctx;
> +	ctx->rng.quality = 1024;
>  
Nitpick: setting the quality should be moved to patch
"crypto: caam - limit single JD RNG output to maximum of 16 bytes"

Horia

