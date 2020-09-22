Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEC4C4727C
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033442388B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hUrBuvGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgIVQEb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:31 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:27291
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIVQEV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKiNRtsr/AuLcH5HbYCT2EdWlF8EdXcxkn/EAwc/IgGQdUBEEt91sqU7clBCViTIjq8Ch0nJXIgf4md0iZMUX5IsRSoU2I28bU82r6ngi6Txe74kg7+vtiSUUjGE/dnOhbl+W1LJb6M3oYe2kPaTJxo63ygNeR6wtHhxUJpbw3ipb+KcRhtuwt5KPkgihoyGC1iXBCqptPI7q6XIF/6q9dcvZ5U4BaatpSZNRWJIsgGyOKq+MHAvFciaeg3AlAiJKiJi0HK5rI+QWcbUrr+J94DqJfn6jgMGbx6sbbZt7yWrzuyL4htlVga+j9yqKZuLkKO5p+I8c30kCKhgbpjAMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeKMrVNealk6Gq5fxg6B7o4jmOP/KLoxvvcm12JqUIA=;
 b=ltryuueztyrF9fOinP7yoeJfATXpbmb9dxuI8SxKCQCmpWBttY6qI2SrsnxkoRViP7eBdtuJHKNRFcN1czNuYbk7EDD0yEqIsfW7avBoA5tGkCoHKj9qpgg2zOJkeobANAZBAkgYXDPqpH4PIIp0rjwaGi/Y0o7sFu0JCzRdAP1Btoy3dEW3aFiNiKSmFhV5D6tKRp/8kYh2/2Q3CWoS83shyvzuc5wF0z86CTveiAHsYOsV1AYRbOVfbkAz8UFyDE7HC86ayjuWgUT35r+u9b5RobLi9vcvIBfZBzzf0kd9h2O4hEcU/RuXojN2kGQfbpFen81DrFQxSRVsot/uyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeKMrVNealk6Gq5fxg6B7o4jmOP/KLoxvvcm12JqUIA=;
 b=hUrBuvGR0+L+73VLZbRD6cHBRoyRwLGWz2Axz2tMQ6p7KGM7DaWeyyqPF7SEsvyFb7TfbYBbE71VAV3l/tBBKgts1knnwbu+7hivMRMFl1cyfTF9CZVzv8/rs14FgVUnLO+I0aUvAoqrYgUVnLFPqjYHyNrrZolozn9a2Hfi34M=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:04 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:04 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/10] crypto: caam/qi - add support for more XTS key lengths
Date:   Tue, 22 Sep 2020 19:03:23 +0300
Message-Id: <20200922160328.28926-6-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:03 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b17898f6-d99d-4bd0-0656-08d85f112085
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70728AA0AD6B1D431072E7CAB43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GidvJPHKblS6CZSYxneXu2y/yDFI7M6Gsora1A0k1i2NpWHUoiqi7sFQ03qL5bbyv6+ph/jJNzQ2tU4Xc6V9S0HWllEPlbp68Ia8EIGSIXWC/NFWB0M/kkJm7tyMqxx1t+P4EhiTOW4yNFlzdQp3KCaPBfpuoVUeDT8Ylm/2AK/mB9i51CaMYQ0kFhHWG6A4SQbUnBp5TTbEcdqoNRiAXcQ7wUZOuGsmHcR82GWkrO+gauLUe3LlutjDfQ9aP6f8ASxcgVxC9MtdmvYwV8P10WHZ/Yeinj6YfElYtEgyaR9E3iEdoL5HMggyByD6rNQ0JAddsw/iT40B+w9CHjhzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3xpsDC5sq0C8ADA1hBI6hmkE0Ji4BPQWTQGtvewY6L27KiB2xHoCnA16sjDH0fazBxy4g0cSMeesfgVe6kyqvq6vim/Uk9h9un1BHL4TQaLXLsx9RSmyqMB8ublG/It3E9Yd2KFT9H28Z7zajSyc/I+quDyWPlt8jdk29+cFchPdS3EGaNU36fu7polsu1NjAz2eyrOJWOgyMAsnrbbstGkHaoPCR5qMu0HaUHmvudvFzv44jNBqU4myQllYAZ3wrm/ksG4ZUEFoeLJe3hcaFLOSh0bhl00kHPO64kN/jPF9UL3USI86BT2F+xo2xXjXYG52TR0cJD3ujMYIzIGrmDC0AbHbjacbm/LxHStRcGSuF0QalpnqClX8ZX8jqX7QwIl77IwR/uLTooYlLmsm2V9NIBjM75fufv5we3gxnYzK5jA9gIkPOe57GBRnSsV64IVyB9WSR8FT0Vy8TK4GF/Sis77NIUjq0yHBQZ7vHwD/uijCtFA3d7PmsrDAGOskoFxZncF1AEK1Y3srg0CWr5s4Ul55rGnS3Xkw4r8FsWwNOLguaVuxwhQzLJfZJgGp2kLKQNxk7EMwVkzM78T7hZolSZ9pPE6zGr/bzsdnPGzGtejWcm6SPK++WvaYD4QTlTv0SWq+io2nHZeOIpS5uA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17898f6-d99d-4bd0-0656-08d85f112085
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:03.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtXF0japkAD5o6UHmPLEzp7rNracsHouW7c27qXjjoX8ROqlzpxyX5NEYk1i67iqOtp4Ocqq84KgNja3s9KAFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index ee801370c879..30aceaf325d7 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -68,6 +69,7 @@ struct caam_ctx {
 	struct device *qidev;
 	spinlock_t lock;	/* Protects multiple init of driver context */
 	struct caam_drv_ctx *drv_ctx[NUM_OP];
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -734,11 +736,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(jrdev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1402,7 +1408,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-- 
2.17.1

