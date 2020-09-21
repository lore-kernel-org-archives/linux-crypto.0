Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07E0C43468
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB902085B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Cz3OIIWZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIUHck (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:40 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:32604
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbgIUHce (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FU6nYT/rG480hEQsRMd3NNK/evdmb5pdq40CCmA8YvKlFJRPT+MxMJwcPrYAYl4AbL9MeXtvJstRMZIqNxxO0AFJOTGCWkPOLOj1yuXUMcjWeZBe60TpW0mC+XvuC5S99C8KQO+FASkIeIotDDSo5XbZguMim4adpPz+iz3DD8XWZUlzv2jWBomcCT4yCAUZobu8zfRTK3+iOAcQkH2M4K+mcUjART0M8thw4gESFeqLf8DaM3EhvJ4hZDaB3mOk0L0AqXQTullusSmM1MKMzhl0G/nuLySwOnpSP8zKsOAjvoSfGNySREBdKa5Ey72kAwYdV0rvkVYwgBZzLjaktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nMobdOVawGVxOp6UamfpI/WdtNV9K3ppJ5QER+S7Go=;
 b=B3sH32DN65haq41+DvvNpDMmYzWW+GMz55BrTc2NAaji4SJMX9ylhLcqwGAWWNnVcrpLvMXRrYd2rGi+1P1p364oC+MiP8HqU6g04Q9DyhkbNeweEJg84IA7Dj7+gAnrgegiLMaKLhvF06PLLnWkBXUWjbipFTT9CZY1PFLWuFH6+fylNTto4dBwvqpM+6aJ2dPgsMZJjTHI+wvojLJarazsRqez8CyQ0oHfQw+hGPVE+oxOWmLs3UwBOzn/uURcoxGqmjToQ7IlS27OJiElqoeKk/cDnCL8yc3rQVdc+oxzfzF3ESyxocoGq3AHxHM+oP4du9OqxUp5Kwp8Oyc5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nMobdOVawGVxOp6UamfpI/WdtNV9K3ppJ5QER+S7Go=;
 b=Cz3OIIWZWl1DvjXtpF7DNMwnal1DYPUoKFbJ/ghtzKDDXIZ1geJBZz9JFbfQxicOjCn8MpcjpZaEuaPn3oJgGlyVxma7T+pdlZvLhWD200wyef0y4CpNb245BSuhv364mjNPckg1wSeU2coEbhGltZ0X/6cQHBrJIdswuiyQ6rg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:25 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:25 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/12] crypto: caam/jr - add support for more XTS key lengths
Date:   Mon, 21 Sep 2020 10:31:57 +0300
Message-Id: <20200921073205.24742-5-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72e90ea7-a9c4-462a-6f24-08d85e007c81
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3903209B49DA1BC8DB6106FCB43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hccccZviDg5C8LrtV5BAFrvbxNtnZc4bsVbMDb6CuAJq7n+3V1QOtEn8RICPUNTM5aCMtpoCS4FlKmFQwG9qJ0PFmScGm+vIuYDpw5fZvbzL4uQWMRFRVz2aSYMjWOyGaBL3mK/006PJDKCQGY1fEJk6jyxmnqKuV17pgN7m25omVZTQeN2m1h7WUMX9k5pM5KGZH05puiFPa9zoymWRnChx7xDcTeBLzSBqKMPanvrEPVXslkby9BYqnNgkFMOgyFCOpgKaIa0FtPf2SeytgL5q7/5EIs08Ov5RiYksaHCuancM/DC3XLuVQNIjGWotyRXhBVhR6iyP/JSsUH1KSgeMyf8tfKCmbG4NSlL3FhBmQsEE/YzmzC0IWYCmCG66
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rrDpgEq2nhJf8uEDGyaacgFsmNqM+YS7tY7fqTGC/aHTKu4qCZBMMh0WlwqICsOG5mg1NXvqAQGFv0Oyz03JmYfgZEvGrBn0/tDdUVcxJdMmTE9Qn3WzKzzUJNG9bPkC2VaK45+gP/+wiDtmc/1QQTXgUlGpOY805fPeYM8ZmRXGxavbTo9cavp93UXI6lj0DK8UIEOldAbbxC9NDxDlD2gD0OH69+2aleTuuXGE5rAF0787LQLXWRsLOl/utaPB+5xz/vb/y5IujnzLLsszontLsyc2EbGHyNsNwedbQ7ce3buMYW5vLXDfG7J4dKozjlUWhF0iyWq9gvjb50ccf7e6RngehuSb77DDjp9som29hxeypKj3G/gw2X8RNnEgx31bkSW8WHwmGn56R2+yewDgvRHZ5/Cwk6HecHu85Ko/4Ws4Yn1KeXh5XHhMxcqRIsXfVBM2E2XD4BGfl8tRc2wLGeIjwuRqMVELWQjaqtqZrnM9WkAktOHmuGHY+H9xhxH1bKvQkWHFbXZ7y9IxskqADjbr0c2WaPvEXqJoJmcixi47Lcv4dR/T/CbSFFigmQz0VP27QKX0Gl8PZw1UsmLwEeKsBQQCrLkAMsEwOG2Mm7NFxZDFJCRyh3UxZBLlifdC3f08DThGs2h/dZeuNw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e90ea7-a9c4-462a-6f24-08d85e007c81
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:25.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZU/fb/s533MNKmXx+65txZjsfscuomkaxs56fi1dxw8Jyu0o2ZVI3QNBuayIsiPvA6z2XtIhwRa3HpUINL9eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e85e740a5fbc..ba70db61a76d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -57,6 +57,7 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include <crypto/engine.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -115,6 +116,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -835,11 +837,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
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
@@ -1787,7 +1793,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-- 
2.17.1

