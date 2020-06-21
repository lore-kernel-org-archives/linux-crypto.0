Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E260C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 12:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3549F248E7
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 12:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="cgZCDMkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgFUMxp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 08:53:45 -0400
Received: from mail-eopbgr30056.outbound.protection.outlook.com ([40.107.3.56]:4480
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730033AbgFUMxo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 08:53:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BS6U1kowSr3nRlxM5JIrJqTjFFPUctXuVv11ZyqgT5yR4HT1XkjalAh1VrXl0Hx1CPtYi4yOJ/2QVI8SMFGTk1pBxkSqTCr0GCCyGqe9/krZL6UX4p5MM7QL94r3g290hqXX+z+z3f/VmyTYsC3ctJTL7EGbl0QSwWCV4tjurwFJWV6OB2lqyHeFegdTSEfAzQhJD+DWTv2b2lqN3be6KB2HklUoYwokW76jIj8nT7Uw3AvIrjOlwgt6bOtovl0YG5y7pOARhOEsfzAerL8sJGW+a1IHXWB/1cIKihNydezk2meLik3Prob50TQzWlA/Bdt0qsozt7A3xgEoh4qqPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/Ht9CsVjnxiXK7pZO3+qJrh7tR7AJv0cVCFSCVNNVc=;
 b=ILjZySG0kAc0v0ZzPBTg7kyHDg64hKWLXFH/wIWWYPRZ3fLtk5jp9MQ820QC+r0741Wl/OSu19kcohBxDxJccMGeaSVScAiVVM5H3gYkMeyqSYYQixmo7lCTISSszNYfRLaDDdyY3smE0d65P2yuJI93pGLfoCXoVm1cOYQdEIRrDcggil1h4Yr66rQ08na6NaaoYIRi86CKyLdGosoud2fXff4JF6BdYqUyt6YEXkW1zjRIh2sxPvHBE+N6O9S2z2WCGju5s8b/9YxHNZMzZ3c7bkcNF4kvY0/rvqtYGDQDPQEKlZrNaBR3tLd7k2u8LJrH1hn2ksUzbTQghx/7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/Ht9CsVjnxiXK7pZO3+qJrh7tR7AJv0cVCFSCVNNVc=;
 b=cgZCDMkmmq0qoUO9wOq13JHjQUTLFXBMhqEXpL9NP2tt3VxEaq65qPqCtp3cM173Qlejsp0CcDzc3kNKzeeq87SAnOFyefaWbk2TRhvzCHc/yP3KqADQbHHvKvy0IVQdXDDkWJ8g/i+jY5sWEvBpokXWOxuHgUZfp5FPIwRkbO0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6894.eurprd04.prod.outlook.com (2603:10a6:803:13a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sun, 21 Jun
 2020 12:53:39 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3109.026; Sun, 21 Jun 2020
 12:53:39 +0000
Subject: Re: [PATCH 4/4] hwrng: imx-rngc: enable driver for i.MX6
To:     Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200619213347.27826-1-horia.geanta@nxp.com>
 <20200619213347.27826-5-horia.geanta@nxp.com>
 <CAOMZO5AZLUxXhX-Maop8iQc0Qan5YqH2QFXaDpYq0hL+BP-L+w@mail.gmail.com>
 <CAOMZO5BMS2RgRm2t7qDZnhiFBWE3pPZmHW7-kn-0KOq5NVYKfg@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <292aafd1-7249-5b76-ccc3-77b153594ef9@nxp.com>
Date:   Sun, 21 Jun 2020 15:53:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CAOMZO5BMS2RgRm2t7qDZnhiFBWE3pPZmHW7-kn-0KOq5NVYKfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:205::20)
 To VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:205::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Sun, 21 Jun 2020 12:53:36 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78cf8555-6593-4567-d11d-08d815e21e17
X-MS-TrafficTypeDiagnostic: VI1PR04MB6894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB689476985F56C1AF5E89587098960@VI1PR04MB6894.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 04410E544A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FduWZW/pqPERAiLj7GpO1Om5cPIVtiFc9OYjKVBwxGq8Z+7Fh6gVysz/QLG1zx2SQZKtPM3NdMOKK8eerwAOqMKPhvHDZoBphaR+yS1/SDJXnRrD+AUHMrabu6dpcUnna9ot2AQ/H6k3xotwNSySCldBW1IVljbjWtRgi452B9uWg+FfpHQzB+N9M/f3YAqGTVKKK3Q8ki0lhM7qechb5gtUDLQZLVSl9Qky6bVIN2I21Jw6fCZTjlJm+pUuXR/3zvkQbuCD3Vk62SXlK96+XIZsIZiUqwW+wTPSuHrR2xqV4/H0KfJSnPJq0es/UIP88o9pNHqYpEH/EByKdPjXqb2XIghaD9S0vs5fnS1BfCn6+sRlLOIebCRVbY3rsarC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39850400004)(396003)(346002)(136003)(376002)(2906002)(16576012)(5660300002)(31686004)(316002)(110136005)(54906003)(8936002)(36756003)(8676002)(4326008)(26005)(186003)(16526019)(4744005)(52116002)(478600001)(53546011)(956004)(86362001)(66946007)(31696002)(66476007)(2616005)(6486002)(66556008)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SV3zbpHRxCsV2X8ARODkB6agHVLMswssLJD+GcI89QP7NZlXIpM94qry0ayI1zo0w6tRn9lXHuj19FIf767wlXRdf9RAVissGwsP/R+58VJtXm9l2wRMTFwbtUw17fTcMYMjIeg3leJOMqSqRpGzrKtR00QIpYPgRDfrKsnlaJSPEOhlHMblNMugNEEuSPuINekkK9iTqd2HaI+Zfgj6GX42VR94A2IbLJwCXOqUe81WQ+8tRyCcObAFO9Ka3wXrGtoe0ZdrrW0mKNBCPGnS04hQYBvN4Ka4NpNszU+nunKExHPsAHKwNQGmKVqUqWYc3m2NeqgFSXXdCa89L67wMtw9n7+R9VWT3wTianWZ04y7j9YX80uUeIDOWYinTBUJt1Hweou8tz1bAyswqWp3r3y1guk3dvUGUFCVD5PVzKzHlrKpZTNUBKLWj5h//VvXPDKsoqvjn07FJVq1QmBgUuNJWjJRaefxTh9WJIoAA73iBmJ7BIUoINCrGEQg3G10
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cf8555-6593-4567-d11d-08d815e21e17
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2020 12:53:38.8112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Swaaz9L5qeOYWMDInLOYjREu4g73+59ZWGPcy6nLLY+zJZiDBN0Akpx3QhDkYiuTiTyDhO6SjV50hUpc39MBSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6894
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/20/2020 12:49 AM, Fabio Estevam wrote:
> On Fri, Jun 19, 2020 at 6:46 PM Fabio Estevam <festevam@gmail.com> wrote:
> 
>> If in the future more SoCs will use this IP, then we will need to keep
>> extending this list over and over again.
>>
>> Maybe you could use:
>>
>> depends on MACH_IMX || COMPILE_TEST
> 
> MACH_MXC is what I meant ;-)
> 
Probably ARCH_MXC.

ARCH_MXC was originally the dependency for this driver, until it was changed
to a more specific one by
commit fcdba3c33a4d ("hwrng: imx-rngc - improve dependencies")

I don't think we'll see too many RNGB deployments in the future,
thus the list of SoCs shouldn't change that often.

Horia
