Return-Path: <SRS0=kLV/=5W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A2BC2BA19
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Apr 2020 11:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98CAE206F8
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Apr 2020 11:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="n2pNvVdF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgDFLET (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Apr 2020 07:04:19 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:10593
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726883AbgDFLET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Apr 2020 07:04:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anxb+w5Sui8S81+t/ryK2/+OAqZ5LkiGvw8WLtnfqqHT1EYT95CnPJGWnwb+64FElwAFbFTFvvSjhhzcI9irf71Ujr8GZhXUbpnn+XhmcnJn50t8hNo68ueVipIh3wXHEoFrFtYp1VnZBX83va5vOnQU2SFDQDG1rJCrtT4KLlpgGV9qvmAeDTqkKD+ugf0k2wRtBsadrQqzqnehDFS2YJ/y2zUXpHkKgTAYxCQ7ulRUSRbxWXF97dtM3WhgCTYFLRHiTUuMXMTXjqhExYVlyjVN617wHOjzdB5eZsarzSvZABZ5OPPWjH5Hb4mf7WIsOu0BqPNtWVFWipM7MnKyDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR5HZD632/QO+lCYPyrprEY/ApP686I1Ub6hrx63uuU=;
 b=CZSRu7SW4TRklkTmBTElk7h88siqncESHGYNNtp/PEwyAplJbRs+yjREBbjBy7f5f3ahFrmY+gawAtTs1nBCKXf74p+mcGt/vHfC2gITvvcZHmkhAknOZ8BEdHiVmRnsPw3eD4KnZnhZo732Zy+RoWg/QYsoVm40hrJ+u+k1zf7b9IyVWLhbIlXPHdnjf4y0Ok/fWYOEVHjDCcpZLWYjYrdeiR87tkKNHHWHXps0sY4PsELNMYvooe5Sq2XRieptBCwVPWCbVTavUdNv2JxwRAuNhreWpH/2TuWGKyV06oski4hfm92swrZ4NXlz9G+9V2/KJpjNu7mTznQ1p3Dwxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR5HZD632/QO+lCYPyrprEY/ApP686I1Ub6hrx63uuU=;
 b=n2pNvVdFD9rRMaqyVVqxEcbcmP9fNyR6ydjMOE9ltXWQww7l1Evn4rWxSI4emi/XNnvlcghEYFrjFw4alTuaZlM1PGmW6ZkiMcMvgdB+0U2MVVbuNYJ0SmjS2ffMgIalcPF7KEErPXE+dr3E086RLiKIJABf10NYVh+hjE6i2fU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (2603:10a6:803:7::25)
 by VI1PR0402MB3568.eurprd04.prod.outlook.com (2603:10a6:803:f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Mon, 6 Apr
 2020 11:04:15 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2878.021; Mon, 6 Apr 2020
 11:04:15 +0000
Subject: Re: [PATCH 2/4] crypto: caam - fix use-after-free KASAN issue for
 AEAD algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
 <1586087411-8505-3-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <25cd577b-a690-0e7f-6c1e-6dc7430c7c69@nxp.com>
Date:   Mon, 6 Apr 2020 14:04:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <1586087411-8505-3-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::37) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM6P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Mon, 6 Apr 2020 11:04:14 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 898e79a8-11bb-4a20-8a7e-08d7da1a3e81
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3568:|VI1PR0402MB3568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3568FD3642150F73255A0C8998C20@VI1PR0402MB3568.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(956004)(16526019)(186003)(31696002)(66476007)(6486002)(66946007)(26005)(478600001)(81156014)(8676002)(81166006)(66556008)(5660300002)(31686004)(2616005)(86362001)(110136005)(4326008)(16576012)(6666004)(53546011)(6636002)(36756003)(52116002)(316002)(2906002)(8936002)(54906003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHdz4gKkY3xWrIJNWx5/WNjJFPR/D7wDmSp331LbV++2/xiAyXcX3JVyHsVB3zE+DUTaJdLV86v33Yb6YepvSFp5G7vkUPvl6QrJg9gn1yQOqEOO8qZPquuQCzGwVA+bx+HyajaY7gu60kKbW4y/X+M5w0vVn7JseEK0MfMQ6OpL7fVfZcE3Om7jrYUQiic11MviuB45ojh4YXdQYOER3zC5a+oFwz/tawsYG4zlWiKpBoiW5iD8yswO5fgtuz2ybVQDB8g9KymBxrT+wFKgrRCJOjxMm4c0hy9EsM/9sF5R9OMm2jjA38oz1BfZUgSmcbqd9cehqe3HHi+PZLNtOsSTht4qGmRH0gGoKAlpfHuSI+ZL5zSTAFgqsLIKa/YnOQhuPG5W6iOeaEu1/0JRRhW7QMy8U+psklj+SnOsJTN+Qh6WQYka5p8UXhF2oiJl
X-MS-Exchange-AntiSpam-MessageData: 1kwbsKHNKDRsCxPIFzayAmOK0mbZ6AcXHFEfrmmgmHsWiVqOUbzjI15F3d/zJrCnby+I2Kx53tC0E/KwX5otMbr6BZtJZk3TfXE8D28y2OLyvbu703GU3d4/3i08ckwKnIm0Av2NrXeRLKUsgcDbyA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898e79a8-11bb-4a20-8a7e-08d7da1a3e81
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:04:15.1175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rApnXehVZQQOe4Luxl7FukI9XhMIWgUgTP+rRu9hQsQWPQdFO0hAyJRTwyQ2UgHzRZulYcfvf1m0Yrj3MueStw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3568
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/5/2020 2:50 PM, Iuliana Prodan wrote:
> Here's the KASAN report:
> BUG: KASAN: use-after-free in aead_crypt_done+0x60/0xd8
> Read of size 1 at addr ffff00002303f014 by task swapper/0/0
> 
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc1-00163-gd88dd5c-dirty #18
This is no a public SHA1, you are probably running with patch 1/4
applied in the tree (and with a "dirty tree").

> Hardware name: LS1046A RDB Board (DT)
> Call trace:
>  dump_backtrace+0x0/0x260
>  show_stack+0x14/0x20
>  dump_stack+0xe8/0x144
>  print_address_description.isra.11+0x64/0x348
>  __kasan_report+0x11c/0x230
>  kasan_report+0xc/0x18
>  __asan_load1+0x5c/0x68
>  aead_crypt_done+0x60/0xd8
>  caam_jr_dequeue+0x390/0x608
> ...
You should provide full KASan log - shawdow bits etc.

> @@ -973,8 +973,6 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
>  
>  	aead_unmap(jrdev, edesc, req);
>  
> -	kfree(edesc);
> -
>  	/*
>  	 * If no backlog flag, the completion of the request is done
>  	 * by CAAM, not crypto engine.
> @@ -983,6 +981,8 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
>  		aead_request_complete(req, ecode);
>  	else
>  		crypto_finalize_aead_request(jrp->engine, req, ecode);
> +
> +	kfree(edesc);
I think it's better freeing all resources before calling
the completion callback, to avoid unnecessary memory strains.

Horia
