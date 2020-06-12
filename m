Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4DEC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 09:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEBAB206D7
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 09:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="LCXJlZ+f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgFLJEq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 05:04:46 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:27280
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbgFLJEp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 05:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vzou4E+u0hyFvZrYUrX41H8oiudBW5xqAPX8ba/9ugUIL7LBGpNipUxnEhgx6XcNL2B8/06gQ9M1iNJK2ZXROCRuQXhhGNMAOfT3zyxRCeyYfVxO47V4GObQ+VsWbKzQcGdtYxQKy8HH/irDgV6yIQ4mXbmjAZbM6j1NVqioUZkAe+4Wbd1D6a6MM1lPaoiqNHqjZ5+vpJqkaHCdmSIWsX70du9FyyJ9i8unxoeW8ufq/PlKerVJQoWM/prMUCVsEVaVsYTLMnZBES3XqdBV09oyMU9aA4tWC+z770SSNX98xiuxtF0hLUO4XqEexMX+9i5i3heVq4Dchil5k9wfwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoZArxYNLa9f5j6RLUw1gSVJH5sGQktQw726WDEXbv4=;
 b=hYdWb+fW8nGnspd1iBvXXk32fhO9fz195pzhMX+sck+qbc8kB9gBSVm2m0zEkW364jeyNVx4HviCP1w6hqISHZ0PW3dEeH+NeXN9+VylUUTaWfWqW0QpXuf5kaU9rfm3it4C87XPsK31KW9httEb3UT827kbkcdJ6F7fA2yuecK1WZVzhK+/aHNYml2/qNBUwp0lxu7ETh/QwHtxbeJj8a8tMohRBVzVyQ5t0x/Nu33bv6ZzJ6hSVHtv86VmhBSg3UExDKnu7spBtCXkSvpdXsHWT14P25eE3ApSJdWNwaR/B5TCfBB/5lHZxHLI8eGBYZqoa8YCn4u9g1cOgMvgWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoZArxYNLa9f5j6RLUw1gSVJH5sGQktQw726WDEXbv4=;
 b=LCXJlZ+fdGboIKs4kS//v7DlnZovxZBsPFW2VzS5wiNxuiuI1ePqPQP/TBcqYPq5yFddX8B0kkMaF5FSFIcQj+Sa35ZW3n+F5Wrj6fcJIRgUXza4lH719MJKWEnnri7vQOffoXlsFOWusPr7ikT3KzoscvFG2g46D9osCRnbQvI=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR0402MB3741.eurprd04.prod.outlook.com
 (2603:10a6:803:18::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Fri, 12 Jun
 2020 09:04:41 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c8c0:bf87:1424:88ae]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c8c0:bf87:1424:88ae%6]) with mapi id 15.20.3088.019; Fri, 12 Jun 2020
 09:04:41 +0000
Subject: Re: crypto: caam - Fix argument type in handle_imx6_err005766
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Radu Solea <radu.solea@nxp.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
References: <20200612060023.GA943@gondor.apana.org.au>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <92f7f3ef-2477-1f38-5406-c11a5013d491@nxp.com>
Date:   Fri, 12 Jun 2020 12:04:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200612060023.GA943@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0005.eurprd07.prod.outlook.com
 (2603:10a6:205:1::18) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.9] (188.25.212.42) by AM4PR07CA0005.eurprd07.prod.outlook.com (2603:10a6:205:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.7 via Frontend Transport; Fri, 12 Jun 2020 09:04:40 +0000
X-Originating-IP: [188.25.212.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1e1be1d-a968-4421-fb13-08d80eafa402
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3741747BEE3F0B7633A46AEA8C810@VI1PR0402MB3741.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-Forefront-PRVS: 0432A04947
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9sqs93ra2G9LL8hoDK84KNuWrT60D4VuR2bxSM35VXgDZm4/QcosiAv9lOhKV0+wTTPjHJrINlCVz0LMH8NiK97+EbBELabS9+mgVRKBfOtX5rD5P1MjOR8XLMdbJI+ocM4pIIIO+ZqnyHX3Xj3IfgLKGEimlpGkA/TizUQs0CtBJ4nOoJyg/TW/85iSZAyb7tm5dLXvJCGZ1Bd+TZ2Ff1G4x1hLWfqvz/szkHc/V0yGWINnieofxxb48b60GnJ3Ak2fkwqpDS93JHpOsgyeks8o6LlsMmqib1162AIWzx2+KNKsXXO26RSmAEuEcQWaUECkqz33GO9IuGlGnunsSUdP4dF0hyXJ5JHO5Hy3oFvlXKWmSWlaqmAeVEyQ1VG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(52116002)(16576012)(2906002)(86362001)(53546011)(31696002)(316002)(31686004)(110136005)(6486002)(66946007)(8676002)(66476007)(66556008)(478600001)(83380400001)(36756003)(5660300002)(44832011)(4744005)(26005)(186003)(956004)(16526019)(6636002)(2616005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FHCbJsV0wm06nj2uFVuIyuKFMuAdPFags0pGC1P5Tt/adbAU0UFHWW/DfqVM6SFYUStZK3nwR3h6/HzNkDPAKXCgz9G7JURAP0SJwl/2HZXyjFSEfpcd4OfhnmZWBY4Laigil9gtwIckrS+5zB8J83KdavIwuxvyrFerpQ992gFl/d7la9hSJIwxOWTFN1bSbZRnzqDfCWDAdhDTnl4RXXzoQKdvQ9h1nQM7MPkEnVr9wSFciFGK8xHoYv5ovT0z7y77FpPi3chTv3xMWCJr2exRSQDQ/nogKZqv1Jw2h8r5Cqsabzhe3DfUjvYVx/vBOrDHhY3vIf0IXhzQKOepspMUyc6IEmDzx9uPY5BYjqWWZQ96Ln4B1aZnJj/k54pznySbxHgE+qYyRuizdWMmBwGYWw11Jfar1Jq3cV8+Ab58dBIoj0De4Z/ChYF6QTvgOywZuDz6nJSMOCRuJxC/0GYmo/kQVjYMKcNiVE9OBwo=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e1be1d-a968-4421-fb13-08d80eafa402
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2020 09:04:41.4185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5EOs99hyCa/GTlPKQzYOmsoUWklvxh6Y8LqgQYPmYwfBONAgGFMis4jAbR2zVKgScLtJ+51OF8abujltUaPFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3741
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 6/12/2020 9:00 AM, Herbert Xu wrote:
> The function handle_imx6_err005766 needs to take an __iomem argument
> as otherwise sparse will generate two warnings.
> 
> Fixes: 33d69455e402 ("crypto: caam - limit AXI pipeline to a...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>

Thanks,
Iulia

> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index f3d20b7645e0..8ecfa97c3188 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -469,7 +469,7 @@ static int caam_get_era(struct caam_ctrl __iomem *ctrl)
>    * pipeline to a depth of 1 (from it's default of 4) to preclude this situation
>    * from occurring.
>    */
> -static void handle_imx6_err005766(u32 *mcr)
> +static void handle_imx6_err005766(u32 __iomem *mcr)
>   {
>   	if (of_machine_is_compatible("fsl,imx6q") ||
>   	    of_machine_is_compatible("fsl,imx6dl") ||
> 
