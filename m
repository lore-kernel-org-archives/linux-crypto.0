Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70ADC6369E
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A28B221EB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 01:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLCBgi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:36:38 -0500
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:53706
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbgLCBgi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 20:36:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIQTeL/OTc2rAxPLW+l3hLUIbFMQ+07qpgV5DN+h0wUqCibgmfyBmQdiaaSYB1tRFztbI5K65ez0l0TQsvTNneojSpQILjSb6JNbj0XPLYnhRcnAHlqk326whhYQnQ3VNBheHylrG5N62uvxTTxcHcjvBLUH5qB0bEuruKFAJL3sN0PsrPb43xqVQ6JG2+V2JjADZ5x75qVK32DNh0uqlNwx7c4TA5oYjvP5YNCPIz5RfMEtpxlkmzjcbJcbZDXeoFxI4bDEyQq6NTIzy2es2kyw+JddqRUTls0+s7ey9awpYwQ70Kiwz3Tx+UjBQiyjJdJTEQkezHeBV3JOCJcW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua/gHjkPkxXoiHmpW4h7tUwffCzJ5L0REIL3iDJPibM=;
 b=LXpCrllkb77YJj5tDuXQtdLpiydZ7UQHm6HXIgmZ7/tTLnEJzw4T+XJpQVebHD4is2fU0hBq7mVueNYriycoLJJDw52OwTD5uRoatWFXce46Q4Rc9wtrx80E+V0oK5qh8oIh4pzC6Vc61bMvOaxLuTiTymU9XLdPzCngQM2fWSwb5c7bMPIp5Mz+tzPpS7re0Lplr/VT3HbOJVfcLp2BLE7HkEIn/lGm7BkUHIy1SBQRjQ99+OShhMChZKzWeRvjEz+sE2+AusEQR7+iYoQmmjVrZBd9om06kMb/D92tPZBJg+bUgVnvBAHEx3rqd0p909yhkCyApw61n9DN4ne7AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua/gHjkPkxXoiHmpW4h7tUwffCzJ5L0REIL3iDJPibM=;
 b=SUgyfgVJZqYwMt6qA3383ZTzZi8losxM7pbCIL9qc2lQH6DqGMtSeETB1/MLmW3dT0VlzVL2vmC0dqsGxmbsSZ075d7sjB1Qu3uYVo9r7t2vOeVVYJYOUOOUweD4rNL95NVi464xsziL/PA0II1s8YewGspMC2dMLKSPth42Pks=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB4430.eurprd04.prod.outlook.com
 (2603:10a6:803:65::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 01:35:47 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 01:35:47 +0000
From:   "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 0/5] crypto: caam - avoid allocating memory at crypto request runtime
Date:   Thu,  3 Dec 2020 03:35:19 +0200
Message-Id: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 01:35:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c09c5bbf-cc71-4e93-7e72-08d8972bc269
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB443082F9F12AC6409D8A69A5CDF20@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mz71iZHqHXyNzaEhkFa8+CnMEXTZU8cNgRgpP/VZUfhGPQt9HQxqJQonP0baanzFa7FFImdYGkAjqDKX+TKTSTui1E9EMhZ5YF0cZpu+CpiWQOFgAANOpYbERoXNM8eAs/em8ylih1rzgDjUKWgw4HeOd7413TovKrkQ7AVxVoiTVnU4FwDkpw2UAS1xc/hdlTAUpj9oueIUjjnzRsLydIOnpLwhL/J3oYixKMbhFaAkv49cFGleI46+qUTI/xWIeljtqZxQJBEzAB/NDgEk8657NPSlSHMgtvrUa+WEGFbn/Y1rzqpcq1xJT88SMF5Q4tBDB0E77s5sWQRXVNAOzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(54906003)(1076003)(110136005)(2906002)(316002)(2616005)(83380400001)(8676002)(52116002)(6506007)(8936002)(5660300002)(66946007)(26005)(66476007)(956004)(16526019)(86362001)(186003)(6512007)(4326008)(478600001)(66556008)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/rMawMeFWsQZtTvu1kwjXqoM+opx9TgpyyHqQroNRpT8QOrCgPz1KNGEYtNt?=
 =?us-ascii?Q?r4LFKaraZK4dGsx2bR0nn0IstdxfA7tqpDOAZ/Ozptu+xwIO0PBg20q4yKHn?=
 =?us-ascii?Q?MXnV7rxC1j2dBMqJAkdR8AIDG4XI6iLmFsayXW6uFRtfvy+v8zdURuOEDsvu?=
 =?us-ascii?Q?5TaBUHG2z0vYzg4HHsVgWBh3b5CMdhVGE9Sl6bLGAi0LdCNTZcVphx7EGDxX?=
 =?us-ascii?Q?yg2uef3E9YKeRIYORGIgdwvLehyzkiGVZtdhm6kC66NZF52UmkFGwzjlqzDf?=
 =?us-ascii?Q?dG0nKaPJL+hlmllfOns5zyz2xlrfquAXbl979LmubuH+nQ/otTOaKZ8uGd48?=
 =?us-ascii?Q?I8Pgam2bJ9fhiYIWpGh60qZS56sb1k/b9gFhNSiK7qzLA4fowwKribAm9ZOj?=
 =?us-ascii?Q?PTZYIfgkAUsqoBnjwFVZ618b4l4PdD2jlTGbMObGrNJL6PHpVVZprwH+HoTT?=
 =?us-ascii?Q?fSEK3cVHIXBNmC2t1a55AZSuBcQcW8t4rNghnY5TNR9+yH1iaSWt45VSDL56?=
 =?us-ascii?Q?97dphUt5g4SUjQF/s366ON79cSS2BXOaZjaSBHn5vsMJBTNcVuO0lHK7aTUh?=
 =?us-ascii?Q?pU8fajaKPBiE7ScuNi7CA7T6CAHuJJArOlwiL8t7U9mJ97oQrsJnLhe5iF/G?=
 =?us-ascii?Q?TxlTyrC1jtWp7oUcyzfbbtBWn0yksX8A7dfpDmXG9LT5S/dY9z5cqCFVfGFX?=
 =?us-ascii?Q?R86lW4ps4K/5OOl6PkDrcu3MEAiDX7wK+XpmbgnfkEt+Vi1G9Zsc4fNVaZvg?=
 =?us-ascii?Q?1Ygm+ujX47uJJHj9WZGzY2Vjp5ok+SzJmSs2zHDxuzpE9Rqk0Bt6tnwNskq0?=
 =?us-ascii?Q?zSuobXaU06pC9eqQXvx7t/+mqZ1oO8kDs73Z+8WX8DagKTYMKEx/SWhulUld?=
 =?us-ascii?Q?5Aqwby7L0CBqOcEiw6CBhkOBWYbXqv07B9gHgKi2jxzocMwJh1KS0ETDevz0?=
 =?us-ascii?Q?AXSsiSoVXQRLGvGVmYDl04fzrGhkTkomHMEo7HLAQrlOMRZAunv0Y8g6PuKH?=
 =?us-ascii?Q?tdqs?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09c5bbf-cc71-4e93-7e72-08d8972bc269
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 01:35:47.6715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQ7w0u2nGms2cibS72f0RxqdNWBM6OKE1ue9VfyptNES22tTWsUBGO6aCGYLt425pPQE4x7Cys4IEEsoydHDdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

This series removes CRYPTO_ALG_ALLOCATES_MEMORY flag and
allocates the memory needed by the driver, to fulfil a
request, within the crypto request object.
The extra size needed for base extended descriptor, hw
descriptor commands and link tables is added to the reqsize
field that indicates how much memory could be needed per request.

CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
dm-crypt use-cases, which seems to be 4 entries maximum.
Therefore in reqsize we allocate memory for maximum 4 entries
for src and 4 for dst, aligned.
If the driver needs more than the 4 entries maximum, the memory
is dynamically allocated, at runtime.

Iuliana Prodan (5):
  crypto: caam/jr - avoid allocating memory at crypto request runtime
    for skcipher
  crypto: caam/jr - avoid allocating memory at crypto request runtime
    for aead
  crypto: caam/jr - avoid allocating memory at crypto request runtime
    fost hash
  crypto: caam/qi - avoid allocating memory at crypto request runtime
  crypto: caam/qi2 - avoid allocating memory at crypto request runtime

 drivers/crypto/caam/caamalg.c     | 141 +++++++---
 drivers/crypto/caam/caamalg_qi.c  | 134 ++++++----
 drivers/crypto/caam/caamalg_qi2.c | 415 ++++++++++++++++++++----------
 drivers/crypto/caam/caamalg_qi2.h |   6 +
 drivers/crypto/caam/caamhash.c    |  77 ++++--
 5 files changed, 538 insertions(+), 235 deletions(-)

-- 
2.17.1

