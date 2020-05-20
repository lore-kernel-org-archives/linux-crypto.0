Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14975C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 08:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17542065F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 08:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GvRsV3Un"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETIRy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 04:17:54 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:3583
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbgETIRx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 04:17:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntLUXTA6n6ndgFJ2FNaTYsORCeW0nvSmzeYmfDIkvxcwq+l4lEcqy5YlRA84Xgt8xLVv8TZ0ZUoZCzNl8a5oLevnbAhiM8J2NvEniUryj+Q+qGc9JW8hBun2Wx+Pi145ECqYd5WBjPPgGjpgOskN3OuxxSnSoDJ76gsMcms96N1of8blYlCROFYFDbo1k1scB7M9z/FfcflThKIPrgnEWZ1azmcpq1MKM5Yd4j46Rs2RpSbfzs9YCvEvi7NOglI3+twYwmxAfy9hmniCpuZQ927nsI4f5kDiygGU+y0yFadUp+02PM2Ipk+1ubA2449WSBv4WTMQ1A8QndW1z3Mztw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgQ4W8a5enBsXawiIyDQaeEEweUOE+ZzsYGBSLSmaeA=;
 b=lyZ3F3AbBshpmhZ9RxpD7wwNOEyYL8Ph60lLrNXZthx2ITWMU1bWyLhzYkCL8BiPZNQMPN0HyeH1+A+Tf3w8jiozU0HUFUQgWi2Gq7Ic7+Jjl2E+MZ9xtLwvH4RNEYqB/7RfVKlDI5EwhtDRsb44jSNDCSeKyU3MAlcW9vPjGn6wAB78CDCNH0W/p0MlQrWdxeZxSRvCkxN5VpTvHOeL4J8yaDrYfeU3emZmiybA62MNrl+eIURHQq04b5BTMdxdukmtn+0APYtflJqcFnHXLeRgXHu2+gDgEDv7FdN8zBFT9IN5vprlJsjPOUqQbgLdYmvAJhoKDiUi2jZeH7urCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgQ4W8a5enBsXawiIyDQaeEEweUOE+ZzsYGBSLSmaeA=;
 b=GvRsV3UnU9eBrkBUErR+XRfAAsyGQZc07vXYMOCfPF0UHBloAYjS1uOOx0PAENcFMAu7jDz1PizgJnZU7v30WqidxtzSrtkbwmjwEYnMv+WELUuNKhkT8Dj6RebRig+hwVbeCemNP1bCIQjhjWoma/ehupZBDmrQaz07Dq/JDE8=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR04MB6600.eurprd04.prod.outlook.com (2603:10a6:20b:fa::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 08:17:49 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::a915:1f41:6468:75ea]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::a915:1f41:6468:75ea%7]) with mapi id 15.20.3021.020; Wed, 20 May 2020
 08:17:49 +0000
Subject: Re: [PATCH] crypto: engine - do not requeue in case of fatal error
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1589926645-32686-1-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <98058a95-ce97-4d3b-a2b5-acfe750ce3c7@nxp.com>
Date:   Wed, 20 May 2020 11:17:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <1589926645-32686-1-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6PR0202CA0055.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::32) To AM6PR04MB4038.eurprd04.prod.outlook.com
 (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM6PR0202CA0055.eurprd02.prod.outlook.com (2603:10a6:20b:3a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Wed, 20 May 2020 08:17:48 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a302e84-8aac-4f22-e162-08d7fc964890
X-MS-TrafficTypeDiagnostic: AM6PR04MB6600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB66005D1C8936F3633AB6EC5398B60@AM6PR04MB6600.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwamilyUFIlzJ8pyJr7gtQ+5QZ/JHXfinSOUiXnot7WBGNfXglqUpznbgZeqg2fjXlFpWm8ushelaMLRfDCk6pf/KYH8ShljSBKbbOojw5WMHwt1vvdMsD9hbmP1yw8mouD2hUmp87jqLOD1qwJDxbgJkkk9dj4wbZzOUyyr/8Nxdev/LUyhvrReitwNIAWGqaYtigFY6+v7/LLh43LpJ3FmnKuwxa3NnFtbjQVLzQzB+2L0dFaUGWAMNxWtFdIQtTKXl2N7NnbPy1YkS+jYkeCvujgfxau/gHGIyFOyP+NWlOJndtb96aWHWqATXAGVhvOA1wwhyApduh4OJgLMTzIu05My9d3n4IUbBBrZur/RU9PSs1CEJLJcw1xDggg4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(16526019)(4326008)(52116002)(66946007)(186003)(31686004)(4744005)(26005)(478600001)(6486002)(5660300002)(36756003)(6666004)(16576012)(8936002)(316002)(54906003)(110136005)(66556008)(66476007)(2616005)(31696002)(8676002)(86362001)(2906002)(956004)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OkBvWfFEFopGBW6ObtRbeJVii0vM0iI8sJ2BWqP3HNlmpDywqeosOS/4ZgprBWV7kFVt1CGVI/rSjVIeF1V817KYiZiNvPvDMMZ8KVsDOxLsCpXa/UyEmOzgBvbHXF5g+LwUvuOIwKX0s56QAER+nY/kpodiHewKO+XufGhcJVfzrL8VsCow3zWt3I/fxpRnOIGuDD3a4510p8pFdHWNMVeB2klVMjDoMCb/Z/oDdJdlxi7XGW9JbuW/06oQSwK2p6ODoVIe9pAvdKoAhANJ5eGWgsCBVblxqeVLZNYz30z2XEUphMrau5o+0IWO0zEhMyIalSCT0z8G1pDyrDMyW15sy0NiXH37xhS9YEA/OfSFI+5slPLR6K/2QPSkx0qcnOI0VkCtwUZ3eZiux0H1H4G9n7AToZ2zGLs15Z4RMsR2dbp9a1mmsr9Hvnh1bebmjt2JUG6KUEQxNEvKGpEyTH59McuK5bDCiBHCz8tfepOBrPrShsnlKvfg+T0l/vlZ
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a302e84-8aac-4f22-e162-08d7fc964890
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 08:17:49.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMAnpKl8tw7aMH9QiEiBHMn046ZQZeNCfGRWvQ29pFWET/w092tiUIl9QZzJcq2LlpspWijYWrbc9izpTSr0uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6600
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/20/2020 1:17 AM, Iuliana Prodan wrote:
> Now, in crypto-engine, if hardware queue is full (-ENOSPC),
> requeue request regardless of MAY_BACKLOG flag.
> If hardware throws any other error code (like -EIO, -EINVAL,
> -ENOMEM, etc.) only MAY_BACKLOG requests are enqueued back into
> crypto-engine's queue, since the others can be dropped.
> The latter case can be fatal error, so those cannot be recovered from.
> For example, in CAAM driver, -EIO is returned in case the job descriptor
> is broken, so there is no possibility to fix the job descriptor.
> Therefore, these errors might be fatal error, so we shouldn’t
> requeue the request. This will just be pass back and forth between
> crypto-engine and hardware.
> 
> Fixes: 6a89f492f8e5 ("crypto: engine - support for parallel requests based on retry mechanism")
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
