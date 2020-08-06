Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4BBC433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C011F206B2
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Nx8Ed/wB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgHFRpX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:45:23 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:21984
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728973AbgHFQid (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wq9i+MsSsbXnMznX0BrExpsutyEjWyAWMptx/r4sUGbyXJN4Oz5Kn9wtpAHZgXdh4H8Pgjrv7gm4Q5ejP9lTOhyslOtsf+Zayve4tFyDaRhZJudLf5P6X0sMh24Rs3lC0oiyFElkme+9MZhpE5BKyHgbqvmV1Si917xTtRY7AGX0XX/kbkeYswCGjGg0w1299bC/CK+aiSrzCn7v7+L+TP+zDNEEj7kj5fKGyH31vhdmKDH1+AuQUcr6bSJMrKlbH9XwaH9Lr07jUefkwV350Bj6en5hnfDRTtxC+MjA+XWDSDEgIfW8uhWvRq2pdV+YzOQigpF+Hljdfb6LlSnd8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgZtPL4Ibx4wosYkqrEpR4/2iTIOpPK1UPEReGFUPoc=;
 b=AcmFGvCSgZzgtlyFms2hZbcE+7kI/lYvdc3uBVBpTF/iJ8LLxdbeo4DouiWO1CjAjqiYWb/l0l93Jlq8yItwMBQr1BIOAa/zdOKs9KIfAvrKsso3bpUGgIzpklLsc3M2rMVntymJjb7v8i20QvCNXln39tuxCvi5SFWn+fH87hDgnP8i2WjU1wqnK72LQkFjU6s9naeihQcUtFXgisU32omzp1QtrzlF516cq2c9MXrFsG/W5szrnY/0f71VQn8kUEKTO4R0X4b5JebW5aDG/WsUBDnzk6bnkpAhPAQqGTBcDsIb6uIVeNEbAwXY9/OMYfEattuCGLXh4Eunxgzj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgZtPL4Ibx4wosYkqrEpR4/2iTIOpPK1UPEReGFUPoc=;
 b=Nx8Ed/wBrAR1SrJ2uD9weVt24bLEnUh9menpStJeRbqKEsPZnoO8t07OCykZQIRbZTCyxQcTqEnwT5nu1DEwza9xlLl0WNBLc3kxchW/UqV+nTnvhNLIctlg996k+wbcvbyBTB4GC2xIyfrR5aBcMzeIZmAiXo+I5ZMuxfmsmvs=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB6959.eurprd04.prod.outlook.com (2603:10a6:803:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 16:36:24 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:24 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 8/9] crypto: caam/qi - add support for XTS with 16B IV
Date:   Thu,  6 Aug 2020 19:35:50 +0300
Message-Id: <20200806163551.14395-9-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:23 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48ca1fea-dac6-481c-fd82-08d83a26db91
X-MS-TrafficTypeDiagnostic: VI1PR04MB6959:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6959DEA638EE58C5BE36801EB4480@VI1PR04MB6959.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGV1s/nVHnfHTaLOy0J4g3b+7ViKm5jgKcrWPknigje+z3ZZcyKw8P+YnzVwBPfxpIi6fBOA45ctvgQJCR3mULVMmahGLINs2B7W/XHqp7khyaxWUvV2jhTKUd/WhfcCh2+/rGtIIFBaOg1D/bpEweAshPtBbI5ovl7WRaKECN8IEo6uGtvThr6FyH5mRsQjYVyeVzyPwufOEoaa4zpXLS3LZ/ZB0UXBTNOLP/xsMtU5JMVmpyBDsGgcbidqnvipLQz/qNj464WZyGGytb4cpLgREseF3vlEvlJvQ88K9QOjiTwt9uDVN3g5hARiZUvHV6GqPoVpdsATStOgcIRRZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(2906002)(16526019)(6486002)(8676002)(4326008)(6512007)(26005)(83380400001)(5660300002)(2616005)(956004)(6506007)(478600001)(8936002)(44832011)(66946007)(316002)(86362001)(66476007)(66556008)(110136005)(1076003)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Muss0W++fF65bqTOVQv2LZADiRuNLRxIGLhgR+c1FQ11GiujXqBWsTB23hJ1F3sRSxSYCFWla5go3UogWTJPbmvXQwFAuwWTpuuq33F+w8Pz95jlnGPE5PAYu+zLsmZkYO4G/dwsIA2fZE+VhZefHxGWLd/c6c6nOg8ss+MKJUczHuB7QlqRwjU4fWQAOPA+YUdr4+eLzyEjBWZ2Xbdf8Oc8Gs038r+LwGx7YUbZfC5RpWR6wPkNGjtn34hJ5r3bL/5gN7rV+QtcqOw/ctb/tDStLnlWRfseWuBpQLGOjqdJAMPjw4RXd4YMuJ9kFIw9STR2HI7kgj99lU3SYCQNJ8V5LEYYRU2vKyRZSCaz6W+y1L63WbieEPuhb81lW2yII1VQBIjsHXTUpPL1qnWPji3h4YP6TohbgDvNFck4xgJHpgLQmaNWgEB+nIiDSk6P9LZ30s32y4B0NiitvPLzEapde6vBOZpjqx113cW5nL1tp1Kb7JMmyj5T6cnKWpZWNJp8rYa9ND87gGO6vTKanYMLP3mi9oRLBT8PSKXeDYS1ELuSr9if4+YiK25zeVHhE2x+jo1/B9v2/dilPg68Qq73A6lTmQMfVtQxDICN0fP1wVA5OTcXadx+tcPbnzR28RDClS22p80vE+tb5KQ8/g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ca1fea-dac6-481c-fd82-08d83a26db91
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:24.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lR+Z4cv16GoAK7ls0EzKP1A+rOPKyiiZNNugocySfnJsawINjGq6cBNFRPr7NlE009Gtb4+CJXE0EA8PY8Hcg==
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
 drivers/crypto/caam/caamalg_qi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 1d775a55fcf5..df58a899e97d 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -732,6 +732,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	int ret = 0;
 	int err;
 
@@ -741,9 +742,12 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
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
@@ -1405,12 +1409,13 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
 	int ret;
 
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
 			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
-- 
2.17.1

