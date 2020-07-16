Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08711C433E4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 12:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D490E2074B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 12:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="U9BJu7Cp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgGPMH6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 08:07:58 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:32627
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgGPMH5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 08:07:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NP+sYgJ6YEN5KuxP2ELm9XKr2AX9A5BGUlfTlAUa6sOrEY2CnLq1dZoKahKR62Vt8m+n0n/HXYuvLDNEgX7hoTNy9e6NRmrVhzKhvgWT043wKQ75ossbmirL3wiGF1KU4tdOLtZaBy6LSQSnGIyCW1sqkwvtpSHCCiDyPdEHsD3b0hgLN3/WZRsAk+TlJFDorccCT9G3crMWu423uXGvc6kM6MAF8YGq+7GvH7mta5iZB9bslYgQZYmaZ4qel4cGZ1LBqmxVuiIqaX4trmr7mMOCrbsJhqBTQbTuf0XF3VA6ENcdA2KfVj3u1tAjK9I4JTduH9bZBVTOPyuz8k7rfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBIeiuJcYxhf12zhZUOC+S9g4SSFMdv9VOFvE1OsZts=;
 b=l04mB4IEFCFM/KH69UUibIhSpNhK58YiuMFXE3Avh5D1E0XNPuTkkyv91RxQ3kQZQ6rJN0Jxtj0wHH+uVGYAe/K69CSj8Qw4WBjyUETcANOdrrB7VbLnP6b9EJ4dGLzfi5eN1UXKz7YCVX5ktazKFLr4CY6Yik4mFnlC1f55GayglePsOJFtS7P+iv6D8JP/ySh/VVy5qxMbQ+gSJdRCyd3tCqVTTwitk+hHB5oN2HQqxW3LApHzGaN5y9NPCjQj6lDT8KuGj4A5r6Eb1rjN+nURaSqp1ibLulAH2ZbSqVx2bv6ns7NtnlYektTAT10n6SRcVDmfVFM75Sctetljwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBIeiuJcYxhf12zhZUOC+S9g4SSFMdv9VOFvE1OsZts=;
 b=U9BJu7CpXuSA/8mz6KtdCaKqV6eXRn5WuxP2K0JeeBNjI5pmChhpqppJdjpEoaAEduDl2ixNRclKYN6kKefWeKGlUpmmfmV4NV460mrrFdSETdjGBF32gltohjeosHlKq5R80p+1cyF++ICpNE+q76ijKuNvwlklWopocuA/O50=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5709.eurprd04.prod.outlook.com (2603:10a6:803:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Thu, 16 Jul
 2020 12:07:53 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3195.018; Thu, 16 Jul 2020
 12:07:53 +0000
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher
 algorithms
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
 <20200716073610.GA28215@gondor.apana.org.au>
 <0c818beb-05e5-a6c6-717d-782b32afff26@nxp.com>
 <20200716115253.GA25035@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <59436173-9891-b857-f36b-e97c0a3264c8@nxp.com>
Date:   Thu, 16 Jul 2020 15:07:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200716115253.GA25035@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR06CA0115.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::20) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR06CA0115.eurprd06.prod.outlook.com (2603:10a6:208:ab::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 12:07:52 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b140c2e2-8a50-4440-50f9-08d82980de45
X-MS-TrafficTypeDiagnostic: VI1PR04MB5709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5709F92C42B16B2963E45603987F0@VI1PR04MB5709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umRdae2Baqz0IOjeFcSTPUrP4z4mq4CZlWcjtCYz2SlQm8HvDwNOOeKjSV0fNnIz/rgxRD4aXO7wog+LEM1GP8UxWWjXOkDGQIkRneCOw2SB0FG6ZwxMjcWxE2OZJ1ZkVzAshrczSXCJQbVpjcaSFrEM/q3mCDPXNPylEN4FPesugMYp1AhV4WLqDOkoIQooZZ+nvk8PrcVtT9uHitTGjQA9glgOvjECgOzYYn/cvKLYelOuVD2biJlS9QdEBZKOFqfVIMYBAupiEh/ub5vWLM2x2qZJIZhQlJzTunayhMnfK//pISHtjkZSsFkKiq5mcB2J9IPGA1rkCKq++wjH4h68uWMIF9hOS4jTUvWNH+i9jxu8pTOgLcdA+Pjigl/7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(8676002)(4744005)(956004)(53546011)(8936002)(66556008)(66476007)(52116002)(31686004)(4326008)(36756003)(2616005)(86362001)(16526019)(6486002)(186003)(5660300002)(66946007)(6916009)(31696002)(2906002)(54906003)(16576012)(478600001)(26005)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Gc1elD/5sryqvhpPrtXuuXBZrYj78oI4eSv/EhLXTwZ9KIpPUdf+OuFhqF1/ZQGPUEwmwTNAWFX4iu3ye91kan8HqYOrx9cq3HWcJ+D64+QSmtFo+DxMMKK+pOD/MdoNgsAT/duF85ZonmXZE6hc5N0d+pGo9AyEbo1khQD2nZ2hC2BI4uIEVrHHXkMyMe3C0H4s+h2yMQq60auqFCX2ZnD4aaOEnUvt5fFX8/L5IuqLOeMeAI2ssN4iJqirtX4IZmi+1K2VbShjKphDOWw6kRA343W7iw6Ynd6H6POeDSAtpVSx3W8Omf4X/TLnlZlh9dm6aIQzEOdvVm+Zfo61i674biwAkjcMW1VaTWeWP26ncG9LMUj4PtFl2cDrH1ZctG7c7r/MUGmlgfhkULWcYSYU2CJnBIB/2vOdVIpYBw8qY2qevS1Ab9n1Ujrn1OGpJURim1IcU2p34uf2QQ0qG8HMwUlMCS8ebNgyfuPxKkggEJk7iI0yh8hev0L/V9qh
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b140c2e2-8a50-4440-50f9-08d82980de45
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 12:07:53.7131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsvQIGy+U5gdMR1aEcuKv82a1EShb5hfJ1rEVUz9RGG7v1rS8V+b+s5nHZ/ZtKBC6+sf/+WdC+wBx62YUUBnew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5709
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/16/2020 2:53 PM, Herbert Xu wrote:
> On Thu, Jul 16, 2020 at 01:35:51PM +0300, Horia Geantă wrote:
>>
>> This patch set adds support only for some AES-based algorithms.
>> However, going further the plan is to add all keyed algorithms
>> supported by caam.
>>
>> Thus I wouldn't tie the name to AES.
> 
> Yes but it's still exactly the same underlying feature as paes.
> So I don't want to have two ways of doing the same thing in the
> Crypto API.
> 
So instead of tk(cbc(aes)) use paes(cbc(aes) or cbc(paes)?

How would this work for hmac(sha512),
paes(hmac(sha512)) or hmac(psha512), or even phmac(sha512)?

Thanks,
Horia
