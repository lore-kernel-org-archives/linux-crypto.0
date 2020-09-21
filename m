Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FB2C43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943D5218AC
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mf0lnpYs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIUHdH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:33:07 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgIUHc5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpT2S0LRNreeg/vAAwE+dbWqtSY4v40pI5vjnplLuAe5Ipufs5wWEGscYcWDsPXasThqxQ6+wcoLdZhiGRdDL3PsdLYAU2t112CzZbf+B/QW1N8Wkz1QLaVD6YTRrZwVDYb9LfJwJ/vrdG0LDQhY07H2MEICd69OFg3beNOvwRMOCOHQMiOa6HvKGCXeE58anCcEo0eU6V+3MyKi1nFHA5HiIiA4q0RV/e3ifqPl7yBeynU5zdg0KR40IVUOx1nRoDN5kJja3oZL9BswxrLTNfNDiCrAzZi06ly/GDkfJ5d3cRRujVjLg7j0KjBcAsRqEZNetFRsX3m8+fXJDHin0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WalySUZ9lqrADHIBYHWSUWrzjygZ2lEDZ2zWFaqrvbQ=;
 b=crpIO7IZQiiVKItd/kW+oILdWhhJChKp16eFM+BSRydC17Ic9nR6FvcRxVVA0soSohEfUjNbWWSAUvdQyL+MshRtiuoI2hjNXMmXRN1LH9q61FJT8geIO8QRJtQw0HwNTNt8Cbt27FozLq0u8LbxGHnjrTQoOn2F0qhQr6Vdta0+1wF6bZpM+E4bOAT91PQI5xfZlkKLA4FccnJatrReoYkjTJf2Gl2MwPUDrLwf3z/RGupk5ErlbfaEUyMGDigmdtgqkEQey09jwD6/dEz79xaePOyR8cdGHznN1UMoPmayzr58OAonrRWhfg6RY+i8WcnG6SN4qOelCh9wBp11qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WalySUZ9lqrADHIBYHWSUWrzjygZ2lEDZ2zWFaqrvbQ=;
 b=mf0lnpYsNNbIF+YuMMpu0CZoASx7I0YGqrMpzBdZqJYTWbz01CA6ZRlGFsZpx8ZDbPIJ3/HPkuUMhH5YmxO0j7K6BaVzZAYB0PR/lnyoqSXWL3EC6W3EnfQnXThknYjDhiUn/dIXVqXOzLW3bdXRlVM4jzljMvb7/f7XGEt64WM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:32 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:32 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/12] crypto: caam/jr - add support for XTS with 16B IV
Date:   Mon, 21 Sep 2020 10:32:03 +0300
Message-Id: <20200921073205.24742-11-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:31 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a42235f-bfb1-4e37-ccf0-08d85e00805b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB390367F58E1458BE6DEEB139B43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3DUJvRir5LJ1bPRnh8FNvc2zgHq2JpKENc40QXQq6o+RJyOq/t1pGecDXxK4Pei4Ekwhb7SeWq89k+xKk8AfNL8WLTU0rg3sT035hjlpuo/9IhwsmqosWDNmHv/AdJvu0qkUA/ZoxqmeTqVfmUY/R5tuLtBflqS2cPQlYFsj38tIltNJZRC4i/I4P3bolIVDYhnzVdcskjNy8uCQsv/qWbUDvHHoo8Q0XFGlO1B4As+e7dA13XsQa1Phri2eAh0p0Zmneve1DVWZwqJ5aCvRFuN1pImMmX2DFrlvDEU10tlv9NoDzb35+Y8pAxK1+8DMYnB/TdrrA+qx5FQcYJCA+AVtpEvB4udB1H/ymEFzi93rgfP+TmHJmRAy6XL8t1b0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: i+22xdyRc2y0uCqic3nuMNc7i4ileMMrvgyGjeEhKjCCGNIGyGpnTIfxaO9CXXDuHYQ3/r53T9dbpYBPovRuN5ZuMH88Z2pExBDQLKpq71Gvx7XcN/D1DUnPjz7em3W21Afw4r207Z3/iDwZ+AQEfkf6ZK+vA4AkeHzFwHTt7CpRFr4gj2csO1LwVrlQm55DOJR4TrJfhQQkh09Rr12Ggh4ihvOFum3r+aicmyeN2MEtD9JG58dNO+yUxP9Ufu6PTXidC7CUNayhFTe/dI3eLJum5zdHRLxMok47rOGefOyACwd0cxdbPamHU2aZge8l/pdyH3KYGika/kXyI56UHsMI0Azw/X2lYzLwr32/A2yRXBz6nZghZxkDT5AyInM+ma/BqWBOTPoky+iLuOfpfcsAUcvTKwK+1fgt8Cdzaw0Y0i+NDXUa2LctjQREwRSIQ78CEcKZOgSyr4TgJGuKDPtkE0vkF5RXcFrg8OcpgKAOj8nM7Go0lw2SF3wnjCzs4R39CWXWNzLKBixlOfQM7OX3FbrM4KYa43ITUotPonsZkeXif8V1QWMoQGoNOvgAYptI116S1fj2BHJ1P71uKTlH/Y4pfqBnTGsE3uwQS03E3S/mtwMBDZjjHG1OIe5lAzMuH/4fOc3h2+6oYYcLBA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a42235f-bfb1-4e37-ccf0-08d85e00805b
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:32.1464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YE32Zqqqe3UFYRq3wWFomXoblDdv4QdgQOozG3+vAI+DG1VCxMsauzhvGxhhM9yc9Ijgy4h8+0rQJt5QAMQCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Newer CAAM versions (Era 9+) support 16B IVs. Since for these devices
the HW limitation is no longer present newer version should process the
requests containing 16B IVs directly in hardware without using a fallback.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg.c      | 12 ++++++++----
 drivers/crypto/caam/caamalg_desc.c | 27 ++++++++++++++++-----------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b5f8823e4300..d7a3b13c0c52 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -834,6 +834,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int err;
 
@@ -846,9 +847,11 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
 		ctx->xts_key_fallback = true;
 
-	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-	if (err)
-		return err;
+	if (ctrlpriv->era <= 8 || ctx->xts_key_fallback) {
+		err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+		if (err)
+			return err;
+	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -1787,6 +1790,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int ret = 0;
 
@@ -1798,7 +1802,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index d6c58184bb57..433d6d5cd582 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1550,13 +1550,14 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/*
-	 * create sequence for loading the sector index
-	 * Upper 8B of IV - will be used as sector index
-	 * Lower 8B of IV - will be discarded
+	 * create sequence for loading the sector index / 16B tweak value
+	 * Lower 8B of IV - sector index / tweak lower half
+	 * Upper 8B of IV - upper half of 16B tweak
 	 */
 	append_seq_load(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
 			(0x20 << LDST_OFFSET_SHIFT));
-	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
+	append_seq_load(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			(0x30 << LDST_OFFSET_SHIFT));
 
 	/* Load operation */
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
@@ -1565,9 +1566,11 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
-	/* Store upper 8B of IV */
+	/* Store lower 8B and upper 8B of IV */
 	append_seq_store(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
 			 (0x20 << LDST_OFFSET_SHIFT));
+	append_seq_store(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			 (0x30 << LDST_OFFSET_SHIFT));
 
 	print_hex_dump_debug("xts skcipher enc shdesc@" __stringify(__LINE__)
 			     ": ", DUMP_PREFIX_ADDRESS, 16, 4,
@@ -1609,23 +1612,25 @@ void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata)
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/*
-	 * create sequence for loading the sector index
-	 * Upper 8B of IV - will be used as sector index
-	 * Lower 8B of IV - will be discarded
+	 * create sequence for loading the sector index / 16B tweak value
+	 * Lower 8B of IV - sector index / tweak lower half
+	 * Upper 8B of IV - upper half of 16B tweak
 	 */
 	append_seq_load(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
 			(0x20 << LDST_OFFSET_SHIFT));
-	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
-
+	append_seq_load(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			(0x30 << LDST_OFFSET_SHIFT));
 	/* Load operation */
 	append_dec_op1(desc, cdata->algtype);
 
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
-	/* Store upper 8B of IV */
+	/* Store lower 8B and upper 8B of IV */
 	append_seq_store(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
 			 (0x20 << LDST_OFFSET_SHIFT));
+	append_seq_store(desc, 8, LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			 (0x30 << LDST_OFFSET_SHIFT));
 
 	print_hex_dump_debug("xts skcipher dec shdesc@" __stringify(__LINE__)
 			     ": ", DUMP_PREFIX_ADDRESS, 16, 4, desc,
-- 
2.17.1

