Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBB7C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F3362311A
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Jy6yHHYd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgHFQkl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:40:41 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:26854
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728211AbgHFQik (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPmuvwC0Tk1nSSB2O2YKuAEr5A6U++eFK8x5qkfwS3W0EuHMzl1OGdAPXaZwA1p+XOCpC67+NO6HFUdF2wKs+nxkg2M8UawP8ZBg4TSwGmqMrrC+rmBKiLef18WQVyf/I9qq+GrU4bY2hifgYboGq8xUrXIULTSo+kSWLBp0AsY9efkZ43ttsshRHXK9f11vUFWGpECZsqgi/4Fz6hDbq9Y3cDCwa/v0xh51V8r9JWAFqsoXxNNf6v0qC5Zs+pGnFPvepHNhFrCKxxEBcF0Hyapc7ouT/UAdMfvt4xBlOi23DAXVy/I/LPUaBQ4r8j/WnMp8oiMU+B/pHrKw2wnG0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6DWGyZrcAc23RA5Q5rukWQiiaO8jxUB3Q0Ppn4lOOc=;
 b=n2IuKtMHcdMT8B8m5hErMgblSlN+VnsejLZicPJVRnq4XKsWmlKQR+p+kYQDb3D+12xcXVK3zuYyMsKQpVOnnONZTBb4FLY3eqw9iYdPRLW0Rx28t58blFAblj2v+4P7R20+y8cwr5aqwOZ59CF1PBnAFMwz2VZobYfUr7qFS9A54ULTD+RA4moE0J6mnZFoNgfyzPWnjYAWQW7D6Mjz0n026vFT06l2suSgtS7Tuazw/bdOZEOb/vVfB9eXBi4AP86yF9cyudtG1a0Nau2r6BgT0DBd5kEALL+NsNabzCpVd7fHIsssqvmJNfeXQFot+o11mJc6nxZQk4+5WdQCLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6DWGyZrcAc23RA5Q5rukWQiiaO8jxUB3Q0Ppn4lOOc=;
 b=Jy6yHHYdLUDnUVzhL4g24prjFe0l9FQWT3/GfmWawTCJle4zgm7XuMihIte3PlTHzXzp3dhov7gGEdyHeX6Hg95gBiolTi5DFLUFqirvI5USSBsZlxfiTmk+6kX8sbJC/06C6NJXYZYJI9Mi2rGWFX7it60jVKV9yut/BsSH17A=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB4992.eurprd04.prod.outlook.com (2603:10a6:803:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 6 Aug
 2020 16:36:18 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:18 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 5/9] crypto: caam/qi - add support for more XTS key lengths
Date:   Thu,  6 Aug 2020 19:35:47 +0300
Message-Id: <20200806163551.14395-6-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 300b8447-c9c1-40d6-5f36-08d83a26d822
X-MS-TrafficTypeDiagnostic: VI1PR04MB4992:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB49925CA8A111AF8725FDC0D6B4480@VI1PR04MB4992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQR5yrT0MsZvZTk7j+hK0kq1/WtWRwAMVUpoWNYUqm3z7AN643RCjHluoLcp7XqfQe3n7Hac4QrqaZe6jT2IVvxbv+qi7oCrjqMEn+mtVIM1O+/c411bm8L0VNZ20uXRQT83vZioJuRGGYt8why95lSvJdMm6matDQminKObCymb/vzFuul5Z0jaWgEK5O/pIbWdi31JXOUGyibREiSERdf4pMum85ygKLzlNDzxOqw+g8NnlzHT8rGOW548+ceTrfturoIebFrNLsLPiKcHrsweCNn3A1Y/2E1T7YsdtJ/A7Tbk/J8lvKFwyfl9BgT95pivUoilvZBYmxCYQ8tmlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(66476007)(86362001)(26005)(6512007)(16526019)(186003)(66556008)(66946007)(1076003)(110136005)(8936002)(316002)(8676002)(478600001)(2906002)(6506007)(4326008)(44832011)(2616005)(956004)(83380400001)(6486002)(6666004)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1H+n//K6n5Nx+I/122KVhPeLFUEtjoAjmhw75i9CpIxFXOZeFCDGEZU3qdbj31tNhUXTwi7WVlpLBHplHm75hDa3pr1PZmMHQpBBnA1mM0i7rVD1H9zoJ15zDM0V3cjW2dfUjAdHygc2DIU6gTGBVyG1bRgaVz4uLGQhnc7pWnoqvNxHTjUfYjee2lXUkxmIXJP8ltZzX6aDTimqMiXzgjXRi1tnPbeCP5NfFE0RRs7Bg5g3cRsLRdSN6sJens90UFBIAqd7d8ccsakAEQB1VlYlz+leso9J1iNcinqzTbf9Zq0pXC3E9akcFD9Ir1/6uUVU40VZr+GfrsL4Bc/6dzAMO2Ru8b8ZjCcmEpfMaRf2gusEXqv24jGdnzfwQeoSCfWgVlII14PxO42y+mFrSOfRJcioR8yH0Lst4BLqFnoM8IyR1X72yr2bmMyjdoV/nyN2Rhhjzns/mD9dfMIZKNBJN+RZZsfYwwid/y9A67YmEHQaFEyeUhdzNeTnKmzCJDPKk4am90JmOmVbbk9j8KxubbR9lMhF31AsU9vnWOCfEjewSFaQQzDVrAMfxlPLz7QqToufb6Z9DFiMnOrxry/MRFa6z6atXB1F/inDHE0WedAarQ1EoSIMdF6MnjqbV4RVGxtJrMsQu/Ypp/iHAg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300b8447-c9c1-40d6-5f36-08d83a26d822
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:18.3553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bMCyWRHXQcJKXBtmcVqQlnm0wMupvrhbIRumQmwhoYkHgngb03Z+G2ZC2nCcYq93W9Pk3jIqyTTHVJ7LkQL9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4992
Sender: linux-crypto-owner@vger.kernel.org
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
 drivers/crypto/caam/caamalg_qi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 05cb50561381..1d775a55fcf5 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -18,6 +18,7 @@
 #include "qi.h"
 #include "jr.h"
 #include "caamalg_desc.h"
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -734,9 +735,10 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(jrdev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
@@ -1408,7 +1410,9 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
+			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-- 
2.17.1

