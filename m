Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD92C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 10:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC162222F
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 10:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbhARKoY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:44:24 -0500
Received: from mail-db8eur05on2108.outbound.protection.outlook.com ([40.107.20.108]:13632
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388570AbhARJTL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 04:19:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTO31zNm6KJA02jUO+q5vvFpWiKgDyz4yzxizI3DIX0Rkb2tU32dN2uVh+Zt56AIKWtH4TMt/wVk9MBxLDpc6gyaFjnakWAkwleK3R22QDCzxbfj8xJzVkf9IBtZpY07oaLwEC2flUeZ8vBlnje695040KEp8om1rfpdqj+39R/N0u5D61Iv0JgGzxV9PXUW+z0jFfRX5DhwwHHDbwtynFtYL/Mt6k/YVkuI8oiYPQUi+cx8Z1CYI+A0yV5pMLpGYnVy4zoIMJ3yUy483zRw3F+PyZVSYDFbjKGP2T3xJweZ1mDWvZoRfjFT2lW3L0qxV8X26KXo5zpPmIPVjNBzEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLa0rNrjfghI9nBHV9fJ37DkAUsK4waSLpC0OP8NuZ8=;
 b=BGrGFe5gSvo4/i5rfnTmUnOsrOJkfPgIOliUsId28PgDAJOxNBu0ncXGFScpBq2O1lFGpPde/SDQR9cO2L3eE4E4SD7+IUmpHToy9IQ436ABSCKqy1ToSSmFLOpjd4CvBeXsl/gZO5C64jkPNA0VVQHzJNrloD9CxC7kfZirnXiXHATpiTQhNY2E8j59W0lykJtyoJEqRiyHxOd6nuELetP/8gwGjEIxn3kvOaup7XvVafEnJmbyrwxjv/KMIrHArVZsnpRFCF1lohZd6Eg+Q90RWBnLnfhBy0q2VxC4ch8+vmiQCgKP/ycN9TWtLbYSIb80RRYK6NqKqw6wbyKL5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLa0rNrjfghI9nBHV9fJ37DkAUsK4waSLpC0OP8NuZ8=;
 b=BDuu7N/sCDqTB+/D4so7N4SNMHxGAvk/HgrBe191omoWpKuNWQaEUvR1cY8ivpAjTsL2jSc5adHgoBGwxMRpwqownW6xHH8YnnXkgSFwQnBe17gM/vAiA1+ft06gu9oHE/WC5JhvrJeEjjAu+UU4/NL1iuJ6Q2eg4mx1EQ+43JY=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB3923.eurprd05.prod.outlook.com (2603:10a6:208:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 09:18:22 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 09:18:22 +0000
Date:   Mon, 18 Jan 2021 10:18:08 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [BUG] marvell/cesa - Fix sparse warnings breaks driver
Message-ID: <20210118091808.3dlauqgbv5yk25oa@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM0PR03CA0057.eurprd03.prod.outlook.com (2603:10a6:208::34)
 To AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.41) by AM0PR03CA0057.eurprd03.prod.outlook.com (2603:10a6:208::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Mon, 18 Jan 2021 09:18:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4999415f-89d6-4147-ae8c-08d8bb92008d
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3923:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3923CACAB6F6E4727441E740EFA40@AM0PR0502MB3923.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Azr8TWwTtxbYCvRDwBeSzLKRRngGgkPmjuAJaWRlPHTifa4SbLVJ6bsTAzMD7b1XWOXr6CVqpdrHL7pZ1fFml1d6u+i5GC6TRy2/NwjISsfuP2d+ZzUZxgNKFXT1mkCAMWKywCkiYF2CfYn8jJ51/ai50C1BSJW+Ml3SVnq7W6gnlX6HmQkManoaF6GfiAwZobc4fDjqtGERFrXKRh6ehPkgMOitEQNgn97kUaA2o7Bk6YI1tgqnkTRohGvVDpT0Ya7ZFw2ZSlPG/4Q+H/gDL3xpllPCIxa0DJwHWQQiNi0/pHUNS9kzZ3t01Sf/SMZGr9qwZ0ZayEIJ6zS+wfDAVSwOrRBpJc0L/v4BC3qN8EjDL8wFjhvEu5iidF0UAm1jFnW9wqNHujl8+Gf4FFUNUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39830400003)(366004)(376002)(8676002)(52116002)(8936002)(5660300002)(2906002)(316002)(4744005)(7696005)(6916009)(55016002)(478600001)(6506007)(44832011)(83380400001)(956004)(16526019)(6666004)(186003)(66556008)(66946007)(4326008)(66476007)(1076003)(26005)(9686003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BUnykFQPy/N1LuOzTKVZOnztvzpWF0LnrRfD9sC39l0cn1gPx9Yv208TMdRc?=
 =?us-ascii?Q?G2XT475M/JbNlEDQObWOK8x7eJlaO26FTDmr0bTI2/JFkZeSmA7nKb0lfcxJ?=
 =?us-ascii?Q?GoBwYj8K2TO6/CRnwbiTAj+lCKkCW5ceUCp4pJmcXuY11tzoBvzUBncvGblu?=
 =?us-ascii?Q?97+AM4sUclwo+yNYVGox1aQWBDngUtYaq314q53jmm3CkuyA88o4RjxNrtKx?=
 =?us-ascii?Q?5a7f+5SaiCgAeMweBJ+5yf/7sjgrLI644A08Wmkcam4UQS7li8WOjW9/IiJY?=
 =?us-ascii?Q?erUDWbalrWb8zAnO9lTVh+eSYyOv3kE2Be7/z8YmZ4S1Igu2Ucz46DIld9ar?=
 =?us-ascii?Q?AHLxEQizYZjPlTIBFPRrmWQdwlqkUH6FN4ozeJ1Kk1pjaNZ4wSpeVCpC5Ogs?=
 =?us-ascii?Q?TDeaI0otZN+XyBYO34LIIb+YtYe7DPE6+oUEycdoO1ioWh4ATGiBHyY0MWS7?=
 =?us-ascii?Q?kWdwGdr/j8EI/TWcmZBxAthoqDtbtm7D6Wj4FwGhzFuI098We0+fuaGZ9uHm?=
 =?us-ascii?Q?elie4gMObRLW0wU3qwTRLvsyxS2wsS9w2KICR3Ri0X+2Yp3cXXyB+YABsoyv?=
 =?us-ascii?Q?+2F+U88jKLkiLM1V4aqEHNFdNLxSs3GDT/dbbbajQr3LNoJ/VnDI2ZZMe9ny?=
 =?us-ascii?Q?T0/LolIaYnYTFlqq1BMwalgscijCjvDK6NVhVLUEokRKx2d4ck6kkJZCJfL3?=
 =?us-ascii?Q?nnYmygA5TADs5HxRM8EPaqczLOGh7+oUSkp4UYEHxyHrR3HK/loWyb4b04W4?=
 =?us-ascii?Q?eqIpA1xypphew9A+OJNYcy73Vppv7NNWzeWXJmtKQQGFxsWQuGGsp4BXIzPz?=
 =?us-ascii?Q?8gRjaOJVEzfXJB1mZgZK76k3n4bQJgEz0hTxIWtGQQ7uoonW7/q4fAQOfTl+?=
 =?us-ascii?Q?G0BcbS6M86SCwZzoRv2XUGkgtEtCOCqgFT/p5GjSMoQMItp2MrtpJaQJGuvB?=
 =?us-ascii?Q?SO92jSfIQ9tqyNoQEApuSPLJnfbQ8p79sBWHDILmWIqcY/gFHXo/I0wkIiZK?=
 =?us-ascii?Q?PCnx?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4999415f-89d6-4147-ae8c-08d8bb92008d
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 09:18:22.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/k0nyVcTPXdvzVMF8QqnAibeCi/icLbw/xlsiYUB+GL/1548yS/4ovS+bVlz3XIiq/hKmOqP9O+UHJkSs4ZdarGJ+YF3RE4R2r3cfTF4W0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3923
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

your patch crypto: marvell/cesa - Fix sparse warnings unfortunately
breaks the cesa driver.

I am using it on my Armada 388 board and with that patch
applied the self test stalls indefinitely.

I tried to find out which part of the patch but it seems
all of the different changes have beaking side effects.

Removing the swab is a breaking change as well as
introducing the dst_dma and src_dma variables.

Also on my 5.10 Kernel the hash tests are failing now
but this also happens when I remove your patch:

[    6.859791] alg: ahash: mv-hmac-md5 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
[    6.883144] alg: ahash: mv-hmac-sha1 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
[    6.923069] alg: ahash: mv-hmac-sha256 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"

You might need to revert the patch.

Let me know if I can debug it in any way.

Best
Sven

