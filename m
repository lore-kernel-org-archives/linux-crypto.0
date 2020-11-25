Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E40C63777
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086DA206F9
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="csNEOeyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgKYVN6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:13:58 -0500
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:41543
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731620AbgKYVN6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:13:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwOpa9ojIg2UYCk/vwGK4lbkC2DZjPYaLRjV/e+pS+mIGXgbpE25hqtoR/HSXD0bfo/Z8G2ImOO4Doq061zLXxS4GPxQR4VAWhshUC3j/h1/YKmoQq1KdNREnIBgVqKRV91IJVmyxgCgzznuSN2uNWC4PSv0sfyoAZn0DRP8/KcM9FAO8tCYQv09Cwaxi621daLGNe44ThoazKdBro7rEw+kElx+Z93VDInrtHMH386mvSg69PVKM4DWnayKfM99J3ISoCMZclj8e1FzHLS44q4XEmNyB+ODRqCFSjK0vZ8MSMsTbMdHUWnfJH1zq+d2UmePQgrHhjPWg5uplf5vMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dI8AdtWRDOfFQ/45mta7yP0VTIxsh3j6gmm7J3AvQ0=;
 b=ayc0iQvUQtcexmcdrCJ/92FGXZDh55me1If+RKcEFKvTNnWG9s/cyaMUH3QELN+ePMynSiJ+6YtZJmdXA7juM4+nQh+FfYTCzkO2rxZsVweE3cwGs7r2QGHgPBqrCvL6guYfpzggrNFRX891bB/kewCb53OYJ4mB7JLIsWEDRGE1kFcrn033JioGXi3dM4Kt8UrenuuOK6tqsS0Iz5rDuSEagigTgHg3KHMpYYJW5X1gtsfHky/H6+SlqC1MactKfB+7dkT7DR0Mu8RkJMu8bmuKW90CVFr2d6tHkOs2CPRpYNjjYYXVHlxKGMw8MO3w6ZlVT7mEuezfFgsmiPL0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dI8AdtWRDOfFQ/45mta7yP0VTIxsh3j6gmm7J3AvQ0=;
 b=csNEOeyuCsewfvQTTYKlJYkOsPTzSagePAzr7pO8jkicBfo71TTpYMif+3YVxhPGCfLTKqEGjR/TjmLELpFoqUTsnazLqSThSzBLXpnPafoiH1bUwr0OL2kmodU2xE8geL0DGRdWyW7/GwQRNtyMtSn5757EltrBW4/fPAaHlf4=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6941.eurprd04.prod.outlook.com
 (2603:10a6:803:12e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 21:13:53 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 21:13:53 +0000
From:   "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
Date:   Wed, 25 Nov 2020 23:13:07 +0200
Message-Id: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::34) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 21:13:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc3c2ceb-59fc-41ea-c065-08d8918702cc
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69412D60300105104D9D8303CDFA0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0i8+fteuY8rozY1ddXUrSUvlZLlICGnk+HSQ/am6ljnuz40AzUeiOFEmiJ6cSSMhDvzYBt73/UeZK5uRZwK6SXEmWpGq1xCJ1FXquTp2c1kbxv1gqBUv4NyoEHowgdqpAlcYnPs4RljT5kDnM2q3RURXr/nB9CFbGJksqjnogmW1DNdI+vnPoExNn514tebYipZ48KtUkLbjMCfdNXnxXGTTmPkVbJYBEu+vEoApnE9a8YzyltEshIuh/54rSZoePBfOogF29Fzw/t016YehMIvy2qOrxOg8U2Em8Uv9ikZr/IM+RPHE6pf5Nx+PviRPM+EV06FWmpkvT/dDc0I5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(316002)(86362001)(5660300002)(66476007)(66556008)(186003)(52116002)(6512007)(66946007)(26005)(110136005)(54906003)(2906002)(8676002)(6486002)(16526019)(4326008)(83380400001)(8936002)(478600001)(1076003)(6506007)(956004)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ka0eQat1pFZE958ii8nUnFk3q+i793Y6FAsDl33tsjYDexfXCJhvW+8g4tNC?=
 =?us-ascii?Q?2YSLpkYH55hlPqdSCq8B4AcWj93Gz25BaNBt4UuhzONmYvOePMRkqeWY8Gcr?=
 =?us-ascii?Q?pxcT6SePQ7cUWMm0Fe9gH0IGtK/hNKPWPssCJy/R/LT106WT6kOjI3H1XNAu?=
 =?us-ascii?Q?cgFw69AfbrrWGxR5yxJUGDNKNPPPdlQZ0VLTm9lWujETsz+V789Xlpl0cAtB?=
 =?us-ascii?Q?NsIxdQlfqPAg9diy3F2dAQe06ath75bUydEdUN+1JRyJ33w7r3cOpZjSgKKD?=
 =?us-ascii?Q?zfYGYV4ZxjcLHRtFEACTKpYpkyH5OTc0uor70UQZZipnc45hTGu0g9qBCSxz?=
 =?us-ascii?Q?O+LiqDQCWdChvBtuhVJjwpgvh4j8C14I5xc6V36wZChfxhBx0AnVSNSTfFpo?=
 =?us-ascii?Q?UTTT0Aoa245bpDeAYI4d543yYPiwx8bLUQq0sf3cc7WnvCV9QSPIN/meNZ91?=
 =?us-ascii?Q?LgSEVF0YdHbeKAKDRonWLKktNu1Ia2XPP9SiV3kODDrsXNLoeH9DjkZZtaW6?=
 =?us-ascii?Q?FanG4IT6b7QXBImY2DJgtAecU4Rp+pZVhj8EggseL8u31hGHuiBqnhqMha2l?=
 =?us-ascii?Q?ERaItbFmKHjqauzV3J0dt0bnJSlYQt4VR/2qIAKMPxV6iAMqXZLJ2RKrfAaS?=
 =?us-ascii?Q?rzSTaCktt1rCHzby4POa0v/qMHd6c1q9yRlaq5v4UzrcFB+K/552txFHIQku?=
 =?us-ascii?Q?MSlnz3tmCz35T4246jaVzj0kEYo/zj3OsWNMe+yrnFXLv5zH4mKq/gI0EZNu?=
 =?us-ascii?Q?N7TGvwMnnu+AeVk1b9JOqIDHmn72tSJ3ICH6BrfCv8MSxH1lKzVw2zDkQ6Eu?=
 =?us-ascii?Q?ziEjkv+h1y7WSx6jgxgntor49xfxMUXVYDTCaujzuVGYLHIWcavvX+vPhuKO?=
 =?us-ascii?Q?5GvL5aTAEUrzZ+KipSHc3vPZ2zTfiA+qwHkV6+L1/UROogVZWfA6lB6/qf+f?=
 =?us-ascii?Q?0TUp1a4pyXOeJk44DijI3YjD+a/VDUU0p6sxkmE+BfgftBRslyRBiGzRaFPD?=
 =?us-ascii?Q?/Xej?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3c2ceb-59fc-41ea-c065-08d8918702cc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 21:13:52.9349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqsO+DMCozi3D49174zIT1+PWJrRb6O/qXfZhiSXfLXk3k+cvw5VCpZGsXE1P+wOXjJopwpCPCPo8fSxD0A5Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Add the option to allocate the crypto request object plus any extra space
needed by the driver into a DMA-able memory.

Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
indicate to crypto API the need to allocate GFP_DMA memory
for private contexts of the crypto requests.

For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
esp_alloc_tmp() function for IPv4 and IPv6.

This series includes an example of how a driver can use
CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
to avoid allocating memory at crypto request runtime.
The extra size needed by the driver is added to the reqsize field
that indicates how much memory could be needed per request.

Iuliana Prodan (4):
  crypto: add CRYPTO_TFM_REQ_DMA flag
  net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
  crypto: caam - avoid allocating memory at crypto request runtime for
    skcipher
  crypto: caam - avoid allocating memory at crypto request runtime for
    aead

 drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++---------
 include/crypto/aead.h         |   4 ++
 include/crypto/akcipher.h     |  21 ++++++
 include/crypto/hash.h         |   4 ++
 include/crypto/skcipher.h     |   4 ++
 include/linux/crypto.h        |   1 +
 net/ipv4/esp4.c               |   7 +-
 net/ipv6/esp6.c               |   7 +-
 8 files changed, 144 insertions(+), 34 deletions(-)

-- 
2.17.1

