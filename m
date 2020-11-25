Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB98C56201
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4846206F9
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="M8Md095U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbgKYVOK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:14:10 -0500
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:61059
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731620AbgKYVOJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:14:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLEapNHS3FKUkT4cHlvMkJl/mIfJukWfy8ecXQxyg04uo6c/gdwSVpNbw/NTKl4D5ErWStsBpet8lp2Y+kZevWmQOARymXUfD3751N8JFxuUtfsw2f/VL1l4WGMDHR+/81UzK1M1QZkIJdP8Fe/vXuhCLObIuCAvyi4ZO0v3QeHC9JIWTaOUjQqKVwJpATzrzdVAo4tMJiJFxem/ZY4QM0yUuIF5k+dWI/zBjg52M3hUR5e1tA91v3Z9hOsrpAY49O75+afeNvbUG6kPTQtAOKoMQtmJzvdp7CNY0++9ia4t/9vmxGSPaLu4/+lA+m+glZy6z/wsSNzD829ilSWIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYKtAFvRxYSZWDwUkMtts25k89Czo+yQlNPH6uXzzV8=;
 b=Y2vneyZHxFM8gOMYILTxYjSHPr3WwNwy+h6SqkazwRjpYIMmtDhVx4fDaLwryZS1I3u/KpYNQhPy+utM2SvlQc2MB3Ive5IuhJQx8H4rE0YQCKLYxUXVr8Yu5I9ntSOrs09iGlxUsKXFzNbXhI8/zphgRyPSbkngFnSyKhNlRlW1fLJa4zcThKCcfsJZHO8EfpMzc9XmG49Gmyu3e0aN1BmuzYN2FKa84xbJEamEBPpN/RQlgJqXJu6l56zwgMBqweo5rWTx2QgonflPjuDqNLq93DtrGDlxEwVq5fRTKLedLIds/WL57hv2m1cfooIFODpco1GMbOIuNDFbpaAVTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYKtAFvRxYSZWDwUkMtts25k89Czo+yQlNPH6uXzzV8=;
 b=M8Md095UF07A1+hWh2vso9/as6XN3w2mNpFYYERYiVNKuOaywCR+3C1s7ANHGVsE+oM/4UbVe94V7gEi6iBRm6cs7UTPX9LVbPIiAA5qHYWfd7up/uFhsgnDqb9NwGWRMvjBjN+HyPa8vJT6pkuVTDIQ1zhA615cfcp6IE5wSf0=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6941.eurprd04.prod.outlook.com
 (2603:10a6:803:12e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 21:14:05 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 21:14:05 +0000
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
Subject: [RFC PATCH 1/4] crypto: add CRYPTO_TFM_REQ_DMA flag
Date:   Wed, 25 Nov 2020 23:13:08 +0200
Message-Id: <20201125211311.2179-2-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::34) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 21:14:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 307897c8-1c88-4693-b522-08d891870a01
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69412E690E2B8C6623FA2E36CDFA0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSLW/n9+w9sFUnAWZ9tLGb8s76dTzLePm4FDYQ+MGC2jDTo6FKjosjOycGuFYcXGGhg99PMMjvejBoUqPlVUgtiEGxki7LCzMvU1Bd/hFsQA6vM4oAdJ8myu3KzmLX1WeCatJSGbHHm3aF/v4LNTQqlzN1Mvx4govmXK6qZ84631eG46gA8ZRH8Z/mGp05PO1Ot6QXO1hUbrUyIHsEMws8RiMwtiC/5TTp/Q+tWHeHVwbAKPdjtSlUPI2NT94bFeti9bYHzafwaecwq2G1vmUDHSSXhobO5un8K65fH4TxgmkHnpBd67iJD+D8BMFUF+JJjxgduKsnoXd3J07vDKtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(316002)(86362001)(5660300002)(66476007)(66556008)(186003)(52116002)(6512007)(66946007)(26005)(110136005)(54906003)(2906002)(8676002)(6486002)(16526019)(4326008)(83380400001)(8936002)(478600001)(1076003)(6506007)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cBvl35lu910/i6K5+NtR6nTSrNRFGaEPWbgNT/qts4YenOE9F6+hgpViAquz?=
 =?us-ascii?Q?FwJohsLIz7MpzTR3QDlSlB6y4HVbQMAKTd3MdWYmIPW10c1ucJFtYInZn84q?=
 =?us-ascii?Q?YK0hUiOEeOMjpbYKy5fqfQ+pegOegBhR4wogykV3VKSTUOaJ3/Q/uqh6qtvP?=
 =?us-ascii?Q?dxqX9kipatOrmwyuAtip57nmmaRIdzc3bi0YG5py6gIZff3Ct9sXsxRas0Ih?=
 =?us-ascii?Q?481lUGLbVXZk1vQcMbmR5ZnxJocGS10kEG+JXpfeW3hFUt+Islgrvsy9XWi6?=
 =?us-ascii?Q?dCmtC4qqwL6XqPQzKcOiz2Cn7hA+fgPY1mwe6+AojY56Ndgd2X5GlaNVedqI?=
 =?us-ascii?Q?3D/gOf4QVE3wcnKZk6jF1ZmFusgIit9LEJhPo8b2m9mIuCmu/F6XFa4S2dCw?=
 =?us-ascii?Q?OSmMBK9YHRy1zH03BZkOTVgVp0kQJ0hHUFpNIgHvboLk621XzbcLpDDvejLT?=
 =?us-ascii?Q?2GSkh/URgqvycZ3NgkqMNonu/IvcP003vLMClGhQRYDA0YoBep/yXZdUL+M5?=
 =?us-ascii?Q?5JqOZSMBqiSkKu1TpX0S3cix2F3OYDy7Om5PX/s5jUJ6qmNN5yhybUJG7huy?=
 =?us-ascii?Q?aEuoEFaUw4R1NwfE2EOowV8FQ0dcSvOEimS7mYJseZmOEoVQRWwgXwALQSzW?=
 =?us-ascii?Q?x2CtsFIbzXqmOdcaZZ6ZTywP4ipB0hp91UibErGWqTwCo+rfca1QN1lOGreF?=
 =?us-ascii?Q?K5rIVM7cTupWG53kA+mWEcnf92L8iP7oK270/quuOyNxvri7c+4TEUf1zRjF?=
 =?us-ascii?Q?D2bkqI7zosuKDw6PK/Q6c9H3o/R/oYV0rKT7vGiaDtqt7CVr45wDM8Wq2DLA?=
 =?us-ascii?Q?BaM1eslzUYNRMKdM0Nmp03Tx4ySQfmN94Tdpy6uqXGv1p27DY+AoZG5iz/cb?=
 =?us-ascii?Q?79T0jhcQq6Ls13nbA/s1MH1jSnN7b2r2K0Kiqn+awv0/LCJApwySfmG4Q5gN?=
 =?us-ascii?Q?LkHIDalr8aseZzQetlouLDHJLR173BoXIAlkrZd/PsreSOeXLB7HtKsWZRne?=
 =?us-ascii?Q?aqD3?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307897c8-1c88-4693-b522-08d891870a01
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 21:14:04.9270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6q7PHvUka6a9BgFqIfP2k1ERHD4ftlJAedYuvx3zO4+tQZpvV9T0PtHy/Z0R57M2z0unWt02TO50G+dKk/hTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

The CRYPTO_TFM_REQ_DMA flag can be used by backend implementations to
indicate to crypto API the need to allocate GFP_DMA memory
for private contexts of the crypto requests.

For public key encryption add the needed functions to
set/get/clear flags.

Signed-off-by: Horia Geanta <horia.geanta@nxp.com>
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 include/crypto/aead.h     |  4 ++++
 include/crypto/akcipher.h | 21 +++++++++++++++++++++
 include/crypto/hash.h     |  4 ++++
 include/crypto/skcipher.h |  4 ++++
 include/linux/crypto.h    |  1 +
 5 files changed, 34 insertions(+)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index fcc12c593ef8..ae2ef87cfb0d 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -416,6 +416,10 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 {
 	struct aead_request *req;
 
+	if (crypto_aead_reqsize(tfm) &&
+	    (crypto_aead_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
 
 	if (likely(req))
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 1d3aa252caba..c06c140d1b7a 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -158,6 +158,23 @@ static inline unsigned int crypto_akcipher_reqsize(struct crypto_akcipher *tfm)
 	return crypto_akcipher_alg(tfm)->reqsize;
 }
 
+static inline u32 crypto_akcipher_get_flags(struct crypto_akcipher *tfm)
+{
+	return crypto_tfm_get_flags(crypto_akcipher_tfm(tfm));
+}
+
+static inline void crypto_akcipher_set_flags(struct crypto_akcipher *tfm,
+					     u32 flags)
+{
+	crypto_tfm_set_flags(crypto_akcipher_tfm(tfm), flags);
+}
+
+static inline void crypto_akcipher_clear_flags(struct crypto_akcipher *tfm,
+					       u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_akcipher_tfm(tfm), flags);
+}
+
 static inline void akcipher_request_set_tfm(struct akcipher_request *req,
 					    struct crypto_akcipher *tfm)
 {
@@ -193,6 +210,10 @@ static inline struct akcipher_request *akcipher_request_alloc(
 {
 	struct akcipher_request *req;
 
+	if (crypto_akcipher_reqsize(tfm) &&
+	    (crypto_akcipher_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
 	if (likely(req))
 		akcipher_request_set_tfm(req, tfm);
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index af2ff31ff619..cb28be54569a 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -599,6 +599,10 @@ static inline struct ahash_request *ahash_request_alloc(
 {
 	struct ahash_request *req;
 
+	if (crypto_ahash_reqsize(tfm) &&
+	    (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(struct ahash_request) +
 		      crypto_ahash_reqsize(tfm), gfp);
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 6a733b171a5d..3c598b56628b 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -493,6 +493,10 @@ static inline struct skcipher_request *skcipher_request_alloc(
 {
 	struct skcipher_request *req;
 
+	if (crypto_skcipher_reqsize(tfm) &&
+	    (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
 	req = kmalloc(sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(tfm), gfp);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ef90e07c9635..87d7f0563c13 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -141,6 +141,7 @@
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_DMA			0x00000800
 
 /*
  * Miscellaneous stuff.
-- 
2.17.1

