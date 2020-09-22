Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198BCC4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C065D2388B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="f1RtOkqp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIVQEg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:36 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:27291
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbgIVQEf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9wvK7E+VoHGlz1SB74602Gil4ZPzlBTu4X4d+tjhbELHWmhYfxgCyvI52dO1mo8VoxAhjH9wCL+ghRm9YDLrNQPscsmHf7mxHpqu8MEaa5NKRdCaufR1x6i+TCVFZM43rXhgrSdPiwojgP5K0WBv82tIkSeMycbPvyGuhDdfi6DN6dO8AtaiaCFpTDVuYZqGUsixvtxICC7yiBjNj0/RsFehtLSBYXON8Ueqf9BXVb0bQ3VneFJDRjuU2zOXWsTUs+c3gioVOLOtOl1Q+e3USrM6NCCJWh26qczcEtLUkmiZG6j3ZE8WhyRV0fEBAJUFdV7LhO7BjhNr3723xqpog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eP4HS2WnZIWUkNBbirjDIRkmlqTNzjp2B6fDiruTLw=;
 b=NZp63SZBhf73adhxBaMOOMoMnup9QkoKBbzn064mNoMUeKKQKP4A77DLG2MZiLviJxf+bd9Ln7RC8hr6xb1X338PGv146hZrLngDX8cao8un7gm7+SoCDUSeqxj8LmGQwTWI/y3APx2gh7N00ZknFunvsRxlzh0Zp6PguKbQ5sEqwPC5u20GAHahAGGPn4G5LjBht5AunfryMerHKt2uoPS2hHOwdyfh/bkt/8sf10pVktH2uH79anpBP2sBKwzyHv8iqvr0OcMgQoepUI50yhXtN7qSrNA9JNfcOg/ASTSBuMxYOTrEJHpAMjByLfiCJpDsDmeg9pwdENHoBHI7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eP4HS2WnZIWUkNBbirjDIRkmlqTNzjp2B6fDiruTLw=;
 b=f1RtOkqpudOGW1OiHgAbXCU9xiHs1CpYnJZjr9HHTrxLgbWmR77YcF5JqH6ntHS6ApU4Nx3m5dP2hWTTE5ePCjgiboB/vplLcAfouQTBQgjAzYcPmC7Sh73MQnFTVhszdvjlTEK9iXkIk11+kly5XowvCvCYpu3mtlUrMe2E+bg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:07 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:07 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/10] crypto: caam/jr - add support for XTS with 16B IV
Date:   Tue, 22 Sep 2020 19:03:26 +0300
Message-Id: <20200922160328.28926-9-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:06 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1db477ec-dd9a-4bd7-8c6e-08d85f112241
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70721219F22E297894E0FA33B43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezGwZhvqP7r1woN5bg5mSy+iVZfG+T8kUgXXDyzyXupRLFShfBZUHNOqXVWesdnuS+ycuM8wtuXnJaIX7Ge+L2dihVNO1Tm5+71dvWwFGAaasjk0z7XKT1tzCAHc0/mzrUOQqfsYg2Y1gXXITx2EYofQvc3mF1hDrww5PWu9EmBjOo5Xsipy2GRxnIDxLPmG/Y8lUuF7pws0/Z3PRi96RcuCpk+VzqMP5NO/EYSuEYZ1fk4ng/V9gzGEXzvV1bdCAusW+VhTPJsrl8Txou2/sezlNjWz0NM/Irs8C+il/9Ag8g+4SYWbXedDd0ZP4SZWHw1MIsII5JN8IaaVffKMKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tlQ7/CR0TMG6tntrnZbMtQ3aytnRxuUIm/6T1wMjIad4KM4ddw3aZzJpWcC/eX+bmqumCyX6puH2pAHcJlNZbqAiHjqaebfVNTXgCPP1d2LtZfoL0uCNQ8pdpo2AfQpvLOBscopxxbknZYrLbj8q9dlY+P7/O+rmmqxuilora4qDxhw/smsuB4P5ondgIh/Vj/hDzLVVcdyutKFngAV5+0WOwvqKB2KmUGTkgR4qfZRwHunJBOKGUxHAoEksjnI+Ml5OG6fJoMGmVTnml3WX97zdPEcEeCn+sPrixFAUIq1qpx6nIznmNReFuP3tiL2NSITad/f9dHbFCl2Tl+Mhze4pF8IyuxP1y5oytLsSo37clvTNYCcTXzGN56ZlPCOZg68syWQmW7oTK96Avt7r/L+9DuTBjmmvDma2GLGWl12cGv9xSzS0zMwIKzg0HxO5BPHwdj1MgLJC6C0PjDwvFdfH+23hdSlPJwqeHBiO40Sfkma+Hh+jSNijT4to0nQ207MJrdFBcc8nUpNAmd+pkqmjN4DTMTAEalTu3TvARakK1JdlhMseByiI3ftLINZ8LlquG/oFanRkBZu1O7GgSKvF87ZBSlXiH5kxZ6jmO82YI4QzbCblF9bD20V9xvMqEzOjPxABJ0/ikjyTFoWSYQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db477ec-dd9a-4bd7-8c6e-08d85f112241
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:06.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zELyboB/5xuZf2iv9bsRk7zULKH/qGoxKB/Rlhd2eRC7wT2SqHEDMZ5aei3WQAwetYvcuL/eM+zAzp8rUzmh5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
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
index e72aa3e2e065..cf5bd7666dfc 100644
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
@@ -1784,6 +1787,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int ret = 0;
 
@@ -1795,7 +1799,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index f0f0fdd1ef32..7571e1ac913b 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1551,13 +1551,14 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
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
@@ -1566,9 +1567,11 @@ void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
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
@@ -1610,23 +1613,25 @@ void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata)
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

