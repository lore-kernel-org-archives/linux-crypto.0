Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD1CC43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4D04218AC
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RyXudyZJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIUHdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:33:15 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbgIUHdJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:33:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHQ3V9DOQNFZ4eTkXVb1K79LzbcVog84ucFXihq4VTS1lbncIg5q/2dwqVe26c2e+o559ZJauJ3C+8LkxfGLfioGUrnnKZzu2p9typtL86xGOfxJFgg2sI631j3/Xafct0TFUdxvcVMgGmWn2PHGbX1Wz/fdeVTytIipDxqJ0hoeyxR4omXIFI+c2zjbsSX7tOfIC7ido53yVSoAnE1/EP3Ik5CsXwEVo2hJ/36X78ij21903nSEGguQJyFGTa4w8zAIf1Gq5OHRa2okV/wuguXXMhUerWlUQ36KwO1ugbZGYtZPMSI44PkwVXU9REC7VXRBsUDj2Qv1ItH8n7LF5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t48bUselI1r0GF/+r5CwLTQuYChjGC2OLYgTa/EBvW4=;
 b=JmU5ls8RsAoteAWa958uYFdOYpi0hCEzigO00/yFn+Mo23kKZ4leE4nsbPB6P6Mn1puS3zSTGv7v5x2CjSCfCEgTIBXB75VB2V4uyiuWFwhncZKWWEsvfJkjcPr9yzOtItlX6tWtct6fRi2KjnIiFtBNbf3XsmrPT//YCP2hj/aOHcmzY/fP2lzQgeA+cowe83v5moaN15rZ5QEsM3XBeHm8HBDHLM+SO4xQtwzZtv/mmCKCwPzRm7YreUBqYKoax6tj3gU7kuWzWvIR3ymo5lUbfporreg37sGcUnw4pe7Ders4oTTtD32FgCZo6ZDpdZPsTalcVtRq8zLv1PIWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t48bUselI1r0GF/+r5CwLTQuYChjGC2OLYgTa/EBvW4=;
 b=RyXudyZJez3JUXhK5wJPIlINfkHpICsS4G/uPcr4eeZy0A1T8XLgzSz3dOUobctPyU57gNE/3cp7M1HkG9cdHpDsJmeX04kjX0uNIvY3A8NvvGc+T5HlFtI49AuXTIEk1Ixby2IAG5z/xnBjo1/OgjAAWelzrTwPGXAc/7A2A6w=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:33 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:33 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/12] crypto: caam/qi - add support for XTS with 16B IV
Date:   Mon, 21 Sep 2020 10:32:04 +0300
Message-Id: <20200921073205.24742-12-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe7b40af-5233-4e82-67b2-08d85e0080e8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3903F6318DFF344091E8EF2CB43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ed28INyL7vdwNK1sCUWL/bxjgp1CPMIZNX7l/gkgzB/CwuN4e9KeHYwkFeWd/uqIOV1vtKwUjMxyEkcREY/01rSJu8jqsDQOlzvkuwbNvSETEpHtAvlrCpfKYw0279DEEjgZwRfdnQabxt/B2dzFj0jq53YweH0cFJz/cRW9KiYrpMsV7FJYAdBqjfpVLF+N1YoUwwIUCcg87/rCaov/7Yqn3QM3OJNyUATSFihTCxcOKE0MXY+CDP3dTp0P1Ggd2ptPbMiAW/eDLjV12wg0wwU44cov5QW8i1ysYN9rJrRthkfOYXqy36zPM+GW+55RUucncyYmFxGMQcg1GKtyIqT5gnvZ+P8RPsSfLzd5GWx1N7Sb+dsjGba/p01kE1J+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mAe7EpM+xYlCPdUsHl4b9LaOr7z+efApntnkzg279c4fMd0FrWTWI5efZQw9uD/fswlUt4W9LFOs7C5deRBTExcui8OMzHsXHNx06yQwyw/uK+DcjvHBC5ASWSKAPaQ1kF7Z65LJ3Vc9i1gzYgxJliJnUkBJ+vLuayR7flDIHmNWM5naIzHxnAkqNcUPiFdyWUcRvSWy3nXD7PmSIs66tPVtLSBlbBHFdpSOrnztOv8M8eafLQDKatp6AbU3U6ByFvezEdCiiLhk+1GrCDRA/ObSDLCRmU/GqhDki5d7t/4kwamVDh079fsPUeeu81Uybq8EWef5JUJlY5cy3SuBKKie+qTgNVQKZEQf08bWF2iJ8FM8/tVj8IxftUfr5t1XCbyUKKVlz06YrcCWmZ8yuUn/zyxWFLljKaPrMWbAMxSHYpn4VgAH8s0PEyfFlrGOeXAc9cGnRvMtvAFsf8s7lvgBvwPkGX3QAXxCJ5OHMmcQU779LgMBpjNFWS4CbXO1WHkBQYjJmY7JboL4MTV0bWWKyYfxHOn2eMH76CKsqrekDteRXyBbLQsBLYf5IsiVexaxi1dHKU63yOeMeeuqzULnNPHdKGOLeypowacSP3HyRH74iMHrYqwQM2DUE01UnPlN5vAIipLoOvjpwLv7BA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7b40af-5233-4e82-67b2-08d85e0080e8
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:33.0579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s48oNrT/8UMMVSJjhTXt3A59yFdZi68ZkHdowsdYLUCLfvNboI7It6jW4IVQomw3sqPyP9fkFVUdLhJXxV3wjA==
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
 drivers/crypto/caam/caamalg_qi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index a897eea59790..88d767910874 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -733,6 +733,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	int ret = 0;
 	int err;
 
@@ -745,9 +746,11 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
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
@@ -1406,6 +1409,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
 	int ret;
 
 	/*
@@ -1416,7 +1420,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
-- 
2.17.1

