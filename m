Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3858EC433E3
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75DA52311B
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:38:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="jJttFqxp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHFQig (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:38:36 -0400
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:49991
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728296AbgHFQhB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:37:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaDJWDp2DmHBnR8eSsyo2iBWrWWozZktZUCrl3OgkuNYARebVgv/rc0Li/6Q/t//SYj7GFALIlMb5F84jIIAsKZItAkUeS+GoETUz/9pq9q7OqTD+L/RBY991f1s0AKXOiIF+BkgknFaWjebmjV7G5siKWkqa2GQmimpGJWbDqkAmLlbB32HMYu5GKSa28abNViHdi/m55L/SIGJX8E0wUKaRhk4c5PoyrRXWWXbQ6Tja+dXf8RRBgZoAPFfWIRKJtjHsIzoH1rj98gW2Lqr6uyEfYhTVrPhexBgN+aFcu4JAbxCG3zfOw8yH/ZN+vE/ZKU+XUOK46RUlLHpVegcmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNBBN/dlZHg6cx7Sgg/A0XQBWdADCmK/YWU/bQrtkn8=;
 b=M1fV6nLzGd3xumnTO3rWH2YpnsTBh7qsIaV7D5yZlzMedtKoz0RoOraN+QWKYdUaWseB12eeBe0wujRtsdFBOOrl/uSE7u5KeDQcuLyo71RdWmy2xkY6STEj/3hntWuMC5k/t3gq0Qtz8l4H+eWKXuQYu4AWBvKoQAAriliwuMKFpXcGESkUJP/V2RaiZKdpXRjU7Mtw6pJt/F3PArvHfyAEMgRoqwD2dv2obCjIZqqY5LyJYl7GZGjCcIhB1KC0P2V9172b3AnDaAifs+2/V0YH+bt6ZXIjISskzfvVkseTb/UnvmPKvyXH0YmjijZJ6dw0XICvDZup8ACKs7+Pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNBBN/dlZHg6cx7Sgg/A0XQBWdADCmK/YWU/bQrtkn8=;
 b=jJttFqxpT8AIeapV0UOCHqyK57jovL+sjWp2KuAAneB1rYIbfyM6xzAwlHJiCE3cDI5nrqgg9OTqeijtdU9tG7sgZnEBlXn771ZJ3PKvh3R6vKECqF44RF2d27QcguoxHnsbmUvuz5QLDfeC3KlG/82MYeVdjC5AWB0fm6Db10I=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB6959.eurprd04.prod.outlook.com (2603:10a6:803:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 16:36:22 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:22 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 7/9] crypto: caam/jr - add support for XTS with 16B IV
Date:   Thu,  6 Aug 2020 19:35:49 +0300
Message-Id: <20200806163551.14395-8-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:21 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4a774a6-8665-4e8c-973f-08d83a26da85
X-MS-TrafficTypeDiagnostic: VI1PR04MB6959:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6959519F1C4BF0F17F62532FB4480@VI1PR04MB6959.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQ8oaijAsMuHUS6eCkXQcdAgEdi8b8OjBo1vjNrtumV8JiDnTZK9c4tC47McsaJTjuo3XMgoE9iF6tSPLlKXVCElzR/NZuYRrh43b8/FLxzz+kmBItF1v9JxQP5ed5RVPEgiihzsgYNwm8Qe6ZnQcBx6Y8mpBKzev8sfRTJUr2m5zV3YBPqwjss2BlcXWoN3BqzKPJxoH5H77QRCpzX2+8ElJtuBdbwQV3D2ERSOeDh/4hIQL3ha9OXGMyx5jIGHjSVkS6EDnaCw+HR1+w/IzetkIQFDkoGdOQMKPmSy2svtWKOxqT1RFWZeeT4RXaesp+p7qpEB41JfFEgWIZmWVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(2906002)(16526019)(6486002)(8676002)(4326008)(6512007)(26005)(83380400001)(5660300002)(2616005)(956004)(6506007)(478600001)(8936002)(44832011)(66946007)(316002)(86362001)(66476007)(66556008)(110136005)(1076003)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ow/Q3uUS15ESNnZ9GrAWrcPyKG/C/+9snQ4XXhGXjK8dzOCZWAoJjjPzEyoujDimzc+oTnQP8S2eXSiyFOKOhl+QqBsukF380AVBM1in65mJyAc5D54ku1Im3AgnQq+Exr+Htw02U7yX0gXntlngflJ3g3N32yLmlRfXobZlm3XE1ssOnlgGlPaTgFr5EJSAe+gOENx6g4yOAvm6Cdn+/c/O53kFkIZsoM4gVjV8wz/Acaaa2dOXCZwkOXH1dvPxqlQ2Slnnu9DOy9YmvUauGW60+ILvHRvtlkGdX4GZEWJ7p9SVgXs8JAQkMmsCUv07kiFEonGYSRXcLleTMFPpNftBrBtBLKj88AdaTJGCoW6/l/FXmsfHHnpZ7Xag9XlC8+Z577z8Ld4nvo/m/fhruM9MD8sb6L+XE1JC6i/7DWkXKF4ISzUlAvv+Q7qb1gPaNmwAnZvlFD+JExnvLk+qCqbBm9v1KKkQb6Svrn6KEerGNHuEHdm79brngXxChQwVGHMmvH/HuwbNo4zQCZ95xo5ZhPHJr0i1Lc5CVHa1cJlgwasW8kodaxAuRWavXM1aKO7fA1GAoTLb3gEZUbAVV6WDL5TLNybfCmSd3LgRhMxlwH6eKtfTne2Setd69JGUlUqqDI8zUQ2SOJ5Y/jf5cg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a774a6-8665-4e8c-973f-08d83a26da85
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:22.3480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYWcn+e81mVuLMyzJm5pc5wuhNF+6GaICnW5hzR4f5FRzcYnMHEFadqOjyfXYpaFgoI+E4OGFWfxMbmCiU3IXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6959
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

