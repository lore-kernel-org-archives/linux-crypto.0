Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F34C433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BCB4619D1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhC3U35 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:44015 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232439AbhC3U33 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YS5dnhOZ1kq2JM88mSCOF6Sr5aEHkj0DlHwhdbYRAvE=;
        b=VioZYxrjZtLyFQS/JuVp5nFxHDPeQ0q9XuoU5mla8jH6VRp16xbbNBUxrt7uP1NM+E90/x
        KZcxKoEjz3Toy+uvN474NlVqTslB2Hg9kXn8QsS3xmTOTNXOc5I0FFdAvnkOqWDBSqxaqY
        freLOZoCEn3pzByOxwuxDLWKsv+jHlI=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-25--Ae-J4dZOve2Zezl1OyKQA-1; Tue, 30 Mar 2021 22:29:27 +0200
X-MC-Unique: -Ae-J4dZOve2Zezl1OyKQA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2Tx0Xpci45I7dotcRt+N0cWpH3gZcFT+gbJMIFTn0OrUcjWlRI2bfMQkZttp1hnIvFnHL2EJAt1+rllLmWgrXVcaSiTPDvGwdPN9fFovlX4yRBIr7POtXiGOSUJHljQeMcSajpDlqek0LQ3mH1G43rIXtBPu+7D4/0tFHeGvKMS6iRvguidO6egKfcPV7dZN4FetCYckQfry3l0Jcdfzsveg2982/ckqjcd0gj1ZWWdPVu8b7v8wuHGnjhPH8xRQMapNGn1vJf+BWQ92n82cOct4/D2iVYioFQCFBiDbFApdn1jVkUTRkFKlyJbittUURz1Rbuj9TJbvVQ555JNMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnjW6jOyPK073QZdomwNsfNcxfz2d5QALxIoSAHf1b0=;
 b=RLdTeSY71Cz0dTMTT2tOecNA7LV5TO1GsfY9Mu62E3EUZGpb93KTixp3JSMZzpSpQmyog7Y7rIEQ5+Tj8gg6y/xT899vwMmaX8Pq1lcT40rfEqR5saJNKZHDriXmyb6SLrJ+B7R6aaOJl+soek/0As6EUlI26AuHEvJ1LluvuYyMPRn+0jWQse222bDwkVLrTJvf51yKzcQlxhvuR7o0BWKgYdJLizo2J8WO32vSOJjlJs7lspmUi/HglKh65YQK5qr1XGmtKwsm1FrifGv2AotKrOjsbH9uGTGcQOH2xiBlXBo5F0DgIunor+1gSzyoH1tzRJUkXwa7tZ/zr2ANWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 20:29:25 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:25 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/18] crypto: rsa: Start moving RSA common code to rsa-common
Date:   Tue, 30 Mar 2021 22:28:17 +0200
Message-ID: <20210330202829.4825-7-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330202829.4825-1-varad.gautam@suse.com>
References: <20210330202829.4825-1-varad.gautam@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: AM3PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:207:5::24) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 089255ad-6a19-4d33-9347-08d8f3ba8262
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB339345FFC10EAB023627CE50E07D9@AM0PR0402MB3393.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RyD7J/a6ActYEYYru6+jeEbLueBxaScANtQVJn9EM/AC1T2S3TzFaTD8VyBxZR5ZpMKCA5z4BYqfToRrO2eDMgX86L7pIuFa8j9xM473Ry6S7MsrYaYviUfWhJi4gi7y7oSWiY6xYkI30IonsNNttl2ZfDfBD90ImKfKQVN3h03ZG5379XV2qytoxQMELFzF2Q7YXtLakerccQ2O3BM1fBUJ6dmcIjk+6jUJPzB8yMMaDZ7nfDdszABAXRZwmkYqjfUa+neYA2glhNguG+mFMMKhIxrra7GVBf+8EpPw9+88I67X4t99RiBjAp4iPf9nFTkAsZ3lnG0ChMKIFN/FUEbvGYIGMCMl10aMdDoKg70/gRbL/9uGOoeGZohID7hfoBxUmmJV6jV6oy16d6j7HT6vGf2uVDe68UT9sDp9eIzlCPvJtFxZ1sLUXNKH//KLL8Rdr8tgzPo2FQMW+H5JBPoBtYycr8tiffwbubf1o/Z0fAD9Uyk5aO8F4YKZHsSOyXy4bNP3Jrb/gzYkKGrdC2c9vEdppZ0iTpxHkAg655Bobmj3Nj97cpHEwYCZzLeql9VXGWohSQnezMt4atXAfI81DpwAUJs/IqZoZuelxcGlDaMTfokvQnVh8L/8fpstDfs5CBGkHV+4sA4zzecaTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(66476007)(66556008)(54906003)(66946007)(6666004)(83380400001)(8936002)(316002)(6506007)(6486002)(1076003)(52116002)(478600001)(6512007)(5660300002)(38100700001)(36756003)(4326008)(86362001)(6916009)(8676002)(2906002)(16526019)(2616005)(956004)(186003)(26005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?at/8A/UlRxFCe3YzgAV/CeXmjcDdG0MPEn791JklOxdCNCjYYeqyEZ9cVl6z?=
 =?us-ascii?Q?2EkgjaOkzypRUXPQJM09HMZiU0FAjqda7qXSId3q3JXg2W6H9sENaDSyxPfq?=
 =?us-ascii?Q?kP0L1ABoY1JMBnhqA+4scuH29zgG6pl7/xgXcHh2CJPsGiJ31zUlRb1N2QX+?=
 =?us-ascii?Q?T8aiQjjw5WN6DemOXa95UHtf6g+jIWQbvAFWhhq6augeIWczVS/kvSRmXQSH?=
 =?us-ascii?Q?3hvsLimjTXR/0FpjYR6GEG7Lb0R5pKn0VZSWySpTxPSv7u3eswpsEqLKEpFy?=
 =?us-ascii?Q?FgYwoR50H7bpqUzL4P6VPAfjUfMHiJyujAooeK6xSkrO65LlZNmfJXY3eOcz?=
 =?us-ascii?Q?pgROLFhrOvUGU3O1uBkJts8cn9CZDkmaYdhRFhTKGgezSxNRglxVe4P2+h9g?=
 =?us-ascii?Q?OaffsmUNFZgD5RHiVIkvUIV7Gd5DvJ9mhvWkLhDwCy2Ow0AvDL2sIIbS2qPj?=
 =?us-ascii?Q?jnmJ+Mh14fRKyd6IcNaEI+q9Kk5Vhlvdb0pTufjF0Yh2N7JY9+7RmRk/VGaB?=
 =?us-ascii?Q?cq8mdbhGdeSlGoK/Szgp/QotoV+V7pLKITVksM71v4PFZWcEs7QA9sOSOMTR?=
 =?us-ascii?Q?Tc7UvFL5xyVD/IId7b1nDM+lu1gm9aQPExz6AP9dTDdPLwWnEi2dRTfI3IaT?=
 =?us-ascii?Q?3q0C41yC+l3cY1JX0NFKiif9JGglB1uZFk7yIXXT2VUsjMZvBJRRuz6Sez5r?=
 =?us-ascii?Q?QHpJgZFwxjMX8Rc6FUiV5dN8K1qQj/G7bXOGltxN50SWHWM81Cs0wW9WokZP?=
 =?us-ascii?Q?aV+bCeCYzdSziVNNA23FvF18PPFLJzeMoNU1NWxZbVpZ5P+OO+MCDh5uvx6T?=
 =?us-ascii?Q?lAgQwB8jyNVUw+zLafzS8y+Lmcc1JB4UAyYFbO0puoZmfPjMyWJ+r//FzIVm?=
 =?us-ascii?Q?asUxHqVTJ5GW2Rl9jk5gE/kXdMWFifEr7S2UakGeaFpQmFx4wshAKw0hk+dJ?=
 =?us-ascii?Q?QbMkVegkmbq98DUwvnkpocilJ1PPnBVmRXIPJJPpjbS7k+b/OzlroJ7cKXp7?=
 =?us-ascii?Q?84zyjOLLKFI/LZJUIlxyIU1KgoO1+n3vVmE8pcOW5YoddUPI2yYlP49n6sRN?=
 =?us-ascii?Q?i1ebe+7H93xFbYggbpHNzbLEXwEddGayQGdsbNSI/G+Fj6/f/ZZbn4aoZDAW?=
 =?us-ascii?Q?p7/BekDbqTs/dcnldbd5fhc+WhsQXJQ9WSVk1FsdaQyxulLiDPs6wc4dasw8?=
 =?us-ascii?Q?MOk2QsRtaBV7sWKFCogltX2Ep2B7Xw3bUaHdWvJR1taxHHvbpVzoQqWDITl9?=
 =?us-ascii?Q?XLeTHZP2w1EFRJjQk2I/NpnrD2FSdW4z+GKmSx8k0XJMxLYlzGjtz7ia3bGc?=
 =?us-ascii?Q?6/l1MrIGNzjCIElDSjk6OCdu?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 089255ad-6a19-4d33-9347-08d8f3ba8262
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:25.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKvk664GLb8kl8tGb1BDqpjV8mkMS92WhoHq81pKNd2S36VWvE5i61oMUiTzRiIU/eVf5eimWxF2JWMVX/fC0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move out helpers from rsa-pkcs1pad.c which will be shared across
rsa-*pad implementations.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/Makefile                      |  1 +
 crypto/rsa-common.c                  | 76 ++++++++++++++++++++++
 crypto/rsa-pkcs1pad.c                | 97 +---------------------------
 include/crypto/internal/rsa-common.h | 37 +++++++++++
 4 files changed, 115 insertions(+), 96 deletions(-)
 create mode 100644 crypto/rsa-common.c
 create mode 100644 include/crypto/internal/rsa-common.h

diff --git a/crypto/Makefile b/crypto/Makefile
index cf23affb1678..57a85b2b3429 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -39,6 +39,7 @@ rsa_generic-y :=3D rsapubkey.asn1.o
 rsa_generic-y +=3D rsaprivkey.asn1.o
 rsa_generic-y +=3D rsa.o
 rsa_generic-y +=3D rsa_helper.o
+rsa_generic-y +=3D rsa-common.o
 rsa_generic-y +=3D rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) +=3D rsa_generic.o
=20
diff --git a/crypto/rsa-common.c b/crypto/rsa-common.c
new file mode 100644
index 000000000000..60073c56e374
--- /dev/null
+++ b/crypto/rsa-common.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2015  Intel Corporation
+ * Copyright (C) 2021 SUSE
+ *
+ */
+
+#include <crypto/internal/rsa-common.h>
+
+/*
+ * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
+ */
+static const u8 rsa_digest_info_md5[] =3D {
+	0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
+	0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
+	0x05, 0x00, 0x04, 0x10
+};
+
+static const u8 rsa_digest_info_sha1[] =3D {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2b, 0x0e, 0x03, 0x02, 0x1a,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 rsa_digest_info_rmd160[] =3D {
+	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
+	0x2b, 0x24, 0x03, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x14
+};
+
+static const u8 rsa_digest_info_sha224[] =3D {
+	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
+	0x05, 0x00, 0x04, 0x1c
+};
+
+static const u8 rsa_digest_info_sha256[] =3D {
+	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
+	0x05, 0x00, 0x04, 0x20
+};
+
+static const u8 rsa_digest_info_sha384[] =3D {
+	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
+	0x05, 0x00, 0x04, 0x30
+};
+
+static const u8 rsa_digest_info_sha512[] =3D {
+	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
+	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
+	0x05, 0x00, 0x04, 0x40
+};
+
+static const struct rsa_asn1_template rsa_asn1_templates[] =3D {
+#define _(X) { #X, rsa_digest_info_##X, sizeof(rsa_digest_info_##X) }
+	_(md5),
+	_(sha1),
+	_(rmd160),
+	_(sha256),
+	_(sha384),
+	_(sha512),
+	_(sha224),
+	{ NULL }
+#undef _
+};
+
+const struct rsa_asn1_template *rsa_lookup_asn1(const char *name)
+{
+	const struct rsa_asn1_template *p;
+
+	for (p =3D rsa_asn1_templates; p->name; p++)
+		if (strcmp(name, p->name) =3D=3D 0)
+			return p;
+	return NULL;
+}
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index e76fc98a537a..ffb7220b3d10 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -5,104 +5,9 @@
  * Copyright (c) 2015  Intel Corporation
  */
=20
-#include <crypto/algapi.h>
-#include <crypto/akcipher.h>
-#include <crypto/internal/akcipher.h>
-#include <crypto/internal/rsa.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
+#include <crypto/internal/rsa-common.h>
 #include <linux/module.h>
 #include <linux/random.h>
-#include <linux/scatterlist.h>
-
-/*
- * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
- */
-static const u8 rsa_digest_info_md5[] =3D {
-	0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
-	0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
-	0x05, 0x00, 0x04, 0x10
-};
-
-static const u8 rsa_digest_info_sha1[] =3D {
-	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-	0x2b, 0x0e, 0x03, 0x02, 0x1a,
-	0x05, 0x00, 0x04, 0x14
-};
-
-static const u8 rsa_digest_info_rmd160[] =3D {
-	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-	0x2b, 0x24, 0x03, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x14
-};
-
-static const u8 rsa_digest_info_sha224[] =3D {
-	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
-	0x05, 0x00, 0x04, 0x1c
-};
-
-static const u8 rsa_digest_info_sha256[] =3D {
-	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x20
-};
-
-static const u8 rsa_digest_info_sha384[] =3D {
-	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
-	0x05, 0x00, 0x04, 0x30
-};
-
-static const u8 rsa_digest_info_sha512[] =3D {
-	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
-	0x05, 0x00, 0x04, 0x40
-};
-
-static const struct rsa_asn1_template {
-	const char	*name;
-	const u8	*data;
-	size_t		size;
-} rsa_asn1_templates[] =3D {
-#define _(X) { #X, rsa_digest_info_##X, sizeof(rsa_digest_info_##X) }
-	_(md5),
-	_(sha1),
-	_(rmd160),
-	_(sha256),
-	_(sha384),
-	_(sha512),
-	_(sha224),
-	{ NULL }
-#undef _
-};
-
-static const struct rsa_asn1_template *rsa_lookup_asn1(const char *name)
-{
-	const struct rsa_asn1_template *p;
-
-	for (p =3D rsa_asn1_templates; p->name; p++)
-		if (strcmp(name, p->name) =3D=3D 0)
-			return p;
-	return NULL;
-}
-
-struct rsapad_tfm_ctx {
-	struct crypto_akcipher *child;
-	unsigned int key_size;
-};
-
-struct rsapad_inst_ctx {
-	struct crypto_akcipher_spawn spawn;
-	const struct rsa_asn1_template *digest_info;
-};
-
-struct rsapad_akciper_req_ctx {
-	struct scatterlist in_sg[2], out_sg[1];
-	uint8_t *in_buf, *out_buf;
-	struct akcipher_request child_req;
-};
=20
 static int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key=
,
 		unsigned int keylen)
diff --git a/include/crypto/internal/rsa-common.h b/include/crypto/internal=
/rsa-common.h
new file mode 100644
index 000000000000..ecdce0cdafaa
--- /dev/null
+++ b/include/crypto/internal/rsa-common.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2015  Intel Corporation
+ * Copyright (C) 2021 SUSE
+ *
+ */
+#ifndef _RSA_COMMON_
+#define _RSA_COMMON_
+
+#include <crypto/algapi.h>
+#include <crypto/internal/akcipher.h>
+#include <linux/scatterlist.h>
+
+struct rsa_asn1_template {
+	const char	*name;
+	const u8	*data;
+	size_t		size;
+};
+const struct rsa_asn1_template *rsa_lookup_asn1(const char *name);
+
+struct rsapad_tfm_ctx {
+	struct crypto_akcipher *child;
+	unsigned int key_size;
+};
+
+struct rsapad_inst_ctx {
+	struct crypto_akcipher_spawn spawn;
+	const struct rsa_asn1_template *digest_info;
+};
+
+struct rsapad_akciper_req_ctx {
+	struct scatterlist in_sg[2], out_sg[1];
+	uint8_t *in_buf, *out_buf;
+	struct akcipher_request child_req;
+};
+
+#endif
--=20
2.30.2

