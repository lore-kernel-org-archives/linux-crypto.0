Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B041C433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BB172086A
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="bqXbDYjJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgHFQ7d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbgHFQkk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:40:40 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-ve1eur03on0616.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe09::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06682C002161;
        Thu,  6 Aug 2020 09:04:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIOGUPi59+CXJwUOBYDnIUH8XrVbxDtYowQsG8WI5aUep10yOCZDouz0tAURLitiUhIYDp15gxdB/rsWrNAgFF1Yy7GKIQo0pbMKs6zxjx+hyy3bgdPGX1dNfW+E3IaWcfob645S8Di8m27tP8LQ8Lsj6o9tNauiMOOlPEk4lsZKX5WQUM9xKj+wBMPWB7BtY3GlPQShcYpD4TV71BoDCDaVj2tXS9JrL7Xk0alECgJyjBszVmfe/0/J+n18WE09mW8SmXIK4J1Z817ej+ja0u7VKnmZyljy9+M3MxRuJRR9jL1/i6XLoyxyFlvO3lTzLQFImyxQ5tHShs0cJAgLdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNBBN/dlZHg6cx7Sgg/A0XQBWdADCmK/YWU/bQrtkn8=;
 b=R7zGcE5nLlDjNkm3dyyLdoHXfqZbqRWZ7016GRHZ60jlRdlRsyKnGXOqnZaNDUIl4Ln47YjAmZn5VGGvxLXFsouR+MxJAvmsTdHhjIlmkvRlimTcYhl24P0KjGI/mogmrQxp3PIudrcPBD8QegpYsEorRX/LGChW8K6P6IDOpUAkc+mv/7bsHdqT5hyOjXzSnzviW35lE3WeC/sNRc4ivrH+FRlQDWbg0hM3RCRYZOGoffo5lMeuKXlaCkQ0CHmzwFY11aCZRciRKozE9EtorozUJUxhRpxAHeqrkhIGC6wTuO4fhVFUH2gnrxNJlljTZR7emMvOvFC4JrGlzDcDiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNBBN/dlZHg6cx7Sgg/A0XQBWdADCmK/YWU/bQrtkn8=;
 b=bqXbDYjJS8VnFlcIMrKpZejPI0lA/Oo+/DPPAljNzdTIful/DtFvV0miyXEcBW3jzbfq9zlJGllKbIk5jePKVKbrIzYX5j4KxUcxkhUya1j6tn0xn8llcZLQ7eZ0TkIfolSWnVQbugIf9iH9Ad1qF/3Ko0sUlKK0hrbnHms53Vw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:57 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:57 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] crypto: caam/jr - add support for XTS with 16B IV
Date:   Thu,  6 Aug 2020 14:41:25 +0300
Message-Id: <20200806114127.8650-8-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 986d1839-cbeb-4fac-4948-08d839fdb865
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440EC1D5A398D60AF302F61B4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O++reUXOap61eD/NCN2LR75x+CB+Hw1k9QJF8bfGh/I9rQMHmkRyQa94PPqt++PzQ78Ib7g4Xmw/Vfp4GiT7ecOHFhMY+D51WEeFEBiI7ryRdrevjg0rvzTokBKCfigivat4NL35FmAIqyJcqWVluiX9QX7nnNS5Zg639mLoPxLlSle9Rmh2MICWKzdlUVlk+P+FrDROVvZi7t0BMzZ/zd7aUcpPZ4EJ14yBKgItx6FB5BomBu1TjECm6DNKywoNmoAJqyTe3XteKq+mPC+I99Kr7gk5U1MrYS+o0al59oJ0fQlcHbP29v/TqfiUY9xOUtHCtVJKgYRj19T2qffX9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6G+WfOgWvtHi8CQax6+MXY/AoduSNjfjemyH/cUch9tbwwvVA+rsobUzRCLPZFwOmPwoECctD/BDUMVa/nRYcuQoBMxCY61toM6ztC14/gqYwrvLgbEGq4+IgqaAM6frXMPhNG7Dt4+w5fEL3vHdY36eIAh5dXkUO59+rRkOYGL9C1mP5VejwnFfBqPxMcwL1FQDG2boc3HPl5SUg5DhKft/RhqLCdqWWyM9yEVfsXWYmugMm6/16O4fYct3oCvspfQH/NcXBldsP6R+WZQMZMebbD0OV0NOb+GfsZfCv09I1m9mu1Z5R4lGgxrRWccdA1V7NO3amDwHtdc5lJhaX8lPqEfPJZPzlVa2t5nAyc3cX7w3tTY/Ol+VeRYP1ydp6zaN7KN5DWw5RBWCjP1LS0A7NXEIH8CRlSuvhNdmgUnl2pZmCowiicLMFMVR9zN/SWl4fsB90LoLnYa/6NLx2uGmaYjKHwztUatyuiSocOUOjEeiu7AjyXNU9mcmfxfbYj1KlIFCLjBxfwU6gMjz69ZJPpE+/BXnPZXN9tgOUU29PK/ljJ4VrbHaIcM9wo+28aDccO78eXNzzQvNul3CQQF7K+uY6/9/CPQfQ/kj9HwpkUTmVSZNhdQ2nrTB2fVFEeYEEmA3hibx3M5QP9BJcA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986d1839-cbeb-4fac-4948-08d839fdb865
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:55.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYfWlP4nTM1cSE/+0ZVu7Bfu7lCZbbHpe8OLxg0+45+YOjtbBtFMeSxToUifnuT+sW+PU8vretLiGwuFwa+22g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Newer CAAM versions (Era 9+) support 16B IVs. Since for these devices
the HW limitation is no longer present newer version should process the
requests containing 16B IVs directly in hardware without using a fallback.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg.c      | 13 +++++++++----
 drivers/crypto/caam/caamalg_desc.c | 27 ++++++++++++++++-----------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a5447ae430b0..7e03854252b0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -833,6 +833,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int err;
 
@@ -842,9 +843,12 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 		return err;
 	}
 
-	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-	if (err)
-		return err;
+	if (ctrlpriv->era <= 8 || (keylen != 2 * AES_KEYSIZE_128 &&
+				   keylen != 2 * AES_KEYSIZE_256)) {
+		err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+		if (err)
+			return err;
+	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -1786,13 +1790,14 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int ret = 0;
 
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
 			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
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

