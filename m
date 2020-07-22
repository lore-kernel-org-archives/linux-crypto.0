Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D050C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 12:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A8D20729
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 12:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="AsyhqL49"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgGVMZT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 08:25:19 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:57696
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbgGVMZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 08:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cz5xJQjXvMJCwLyORdNMPiQ6EDu9fNR5h6IQbikoomcWnCC/BDq1RZJGYZ4+phuVIPNPM+cGKwP/vzITN8ulp9bT6KS5cVGGeRa9IS1eI7C7FmJBk8zpMKSAdD76YFL26+f+57R5z0EoCzEVtnmofKLSZFkt+j3UTCJ1OY4yVohnkJ33swRc6wFDFPQCoU9iMXCrp+QfFXoZs5YPr24kSZkR1sThzgfiQOrbbHSqpzZlTjazRXu341OPKNGnHKqsKaBu0QDCjio8dQeUzaMPWA6L63LcP1F5O1bo6EkgQVAwaAV+ha785+6tqZaaPCSoYRLFoB4I0BZOLMTK/Xf6Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArLTneIU/Zh7+7PbOXOU92k0OACXzFDQLfv7Z0Y5r3k=;
 b=DooXnVIZCWoll3r8Mter6ad4uSzm/SpfRMMfaL0CC2FPimqwZdgmCvcJ1MWaCwmq/QeISTD4wpGlJo3ACJROKX2GYbPuRjjiBmWvHdNhTGlGOhuliI+HCSthLeras3dDRTtVGRpS9dXqEc8pS/afNQ0iBpsVHs20DxdC7O7HosxSvvuHlmPzbhQhcHR1ujY0VE98le363JsRNNQ6iG0FLVguwABV6ZWe5r38S7s6kDso6XdJhr5MZdOU2YzUFyCSVDefsxjkLl+M4mmiV7sBVm7zgIdQVcWq9ZR/LO6zmsCpbmMVvHyNv3Ny9p29MDPDcEGReUDrEECca9CHPV6P6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArLTneIU/Zh7+7PbOXOU92k0OACXzFDQLfv7Z0Y5r3k=;
 b=AsyhqL49tmRT1+kqV0nBi8qcn1lazQe67nc67P1KaYcZwJnxNkUp8NQKzyjmQwgnduWrA9lUuFHO5LIHUOVlH0+IgCPq9tEsYjpQJO1suFqnMzpDZwCYc442/vKz9x+4M8dnLvZAp5pMzPIs2XynUB/eA6pJFAXNJB9MpfcVV90=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR04MB6648.eurprd04.prod.outlook.com (2603:10a6:20b:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 12:25:14 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2%7]) with mapi id 15.20.3195.028; Wed, 22 Jul 2020
 12:25:14 +0000
Subject: Re: [PATCH 6/7] crypto: caam - add more RNG hw error codes
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200722121458.8478-1-horia.geanta@nxp.com>
 <20200722121458.8478-7-horia.geanta@nxp.com>
Message-ID: <146822fe-5436-a0cb-c78a-7ecd2f8b7b16@nxp.com>
Date:   Wed, 22 Jul 2020 15:25:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200722121458.8478-7-horia.geanta@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0067.eurprd03.prod.outlook.com (2603:10a6:208::44)
 To AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR03CA0067.eurprd03.prod.outlook.com (2603:10a6:208::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Wed, 22 Jul 2020 12:25:13 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27d1831e-21a3-403e-9b39-08d82e3a4904
X-MS-TrafficTypeDiagnostic: AM6PR04MB6648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB6648341337DB2FCDAC03C6B898790@AM6PR04MB6648.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrStce0mGfqUp6vpqNv5i6TdS62EunHr6klMRCHYXXbJY+KyE/KCcVJffd2ZH2ShyxuW+GWM+Wz5i4W1OVdrsokOYw0oFyKq+IFk0ZjgPPIZ1JlEruUWEtalf5NAYpas1FNKdE88QEdJhNGv2MnQtwbEDM5+V4CeESp6PN1vTf5LSQVdAzx6zVyzvcz8SVY1UgwSdhEhBC36oyN4+mWN3POr2BBAvlWpY3G2llggSqiyiJ9JGHVwRtLum2dBqvw/abDnVT+UKEC198TvBDM20YK73TqbXg6A9EUtBReSGIQVzOnQqlSAjE3yWWvSM731eXIsyiPCBXqj6t/uC99lDmEco+AJTN9wCWRYTmLugm67HE5Ilzv2thJnaOPihb/8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(36756003)(2616005)(956004)(478600001)(16526019)(5660300002)(31696002)(186003)(4326008)(4744005)(53546011)(86362001)(6916009)(8936002)(26005)(52116002)(2906002)(316002)(8676002)(66556008)(66476007)(16576012)(66946007)(6486002)(31686004)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: f+gzu79v9taoSvfiDXywu1d5TKIxZQt5noSO8Z6JVsbNYa4vpdVzx0sMWm3a8NxaFcKaaThJt+v2bgWM76ooU49zilOr6Fagi8YKmRKjKZTNuspdOAw9LpRx0tFvUp0Wj0VT+kbLIYgl1Z3PfSRxyO+SIRrwbC4LZuXiynrvNqLRe84aAJsFghs0iNG2mpD7GFmpNJ7l5KaA9fQKQTuTBrJoVUOk7i86pN/cKR8u4tJI9O49L4p6ZQ/v/FQ6fsxlTDVr/fqIlxWdAjlXbSqkwaDpRjB4hIU7sxh2bGE2wxaJLK3A1mz2pLaMVWzLSlewMwLVkVG0X+gY0YZV9/KBjUUQe68r1BH/RvRuNYAvDjnfsgMLNBvISN0t0l+EUdUhQ6rPQwiN0jdPcpC4x7+WA9pyqloL70EBYcyhV/EaYfMe1yn2z5E6i6MmKZJtZqBvXOcxthzX9tbheI4s1I5D01yRmDfX8Pl9wDpSC/TA9J2+UbOEtwGI90uoZLP5AASe
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d1831e-21a3-403e-9b39-08d82e3a4904
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4038.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 12:25:14.3013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aH9RA1MLfNgMotR8UchXyWhrgEdUbaEs93OUAMtpNBKYB8oslTrTZF9wkC90HbwNLem9B+vDRp1sa3OYH0wKmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6648
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/22/2020 3:15 PM, Horia Geantă wrote:
> In some cases, e.g. when TRNG is not properly configured,
> the RNG module could issue a "Hardware error" at runtime.
> 
> "Continuos check" error is emitted when some of the BISTs fail.
> 
> Signed-off-by: Horia Geantă <horia.geanta@freescale.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Oops, somehow the deprecated freescale address made its way through.

If there won't be other objections to the patch set, maybe you could fix this
so that a v2 is not needed.

Thanks,
Horia
