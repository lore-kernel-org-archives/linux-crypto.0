Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0A5C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3454620709
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ZL8QI6vB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIUHcr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:47 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:32604
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbgIUHcl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPLQo6EEzLwBxoCMcVDMKaX2EZ7S6HrZLHNuNoNtpyj9e7l2ASm/7K6hiJD8F1BLbASoUleHks6BRK+cRfHS0t2JW50mmgsyyaZ7xYFvZJr6G08hdOk1OJoHUQI/KzzuCQESf8iXY9HASHu3ZO6exCYUHPBQF0GmdyIgmdDwyXYXnfJ81GFzcGY2gsUn07uocAKOfjQ3XulQ2hEdwav/kIl6d9ASB07p9VF9nJ541DYFhc+5nTHmwhAQdFuq8msnefcHlg0DQnJcL/XqGUEAVXjtqsa2vKJkm3knQzgu9JGyJcGsZpUgJGZryBCaVDhTvnXPfcysQ1u+VqOWBy9O4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOCaSLPSl1cbuw2fC3MU/bwkJ1zDeTkbIYnCB4Dr3cY=;
 b=NStwnTrlyvhBT/5qd0A/vsypozRh/OeOqvS4TLZfqKS2dLMtlcO323kJ6FBzacrNSo3/31iYaeKpn7IuMmVInfzFM8F07bTx8YGtUPykIE7PR40utZ7we3MbbcuILtOl0E3/Jk7Y7Zh+SqLfI8eL75jW4yzvsr9YUb3IAsr2NOHpwN41+DNmmbYinh9uebQHTlyN1OKA6W79fQJGRTyE7Y9IpzgSk5ZouNnPpxspt5TjkDPFZQjgM0MZo6ff1HZzL8s1md0VxGobHvAqZYLdn2nekBJYbhbjcOTK1CQaCDMJ5V+nfVmrpA6Bi/K8dKJ2DHgkQU8EAw/m9fCsWGkTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOCaSLPSl1cbuw2fC3MU/bwkJ1zDeTkbIYnCB4Dr3cY=;
 b=ZL8QI6vBFalJc80Uqlkz4H4NSKFOVYOfBaXUoNMn3jPkogFh8GWt57YAwc6/idoWn4xRaqBd98/tMYXYBCwrQGOaCsOni5oYqYoBN3c4MddyDcost82eohbWMhBs56z82ymbyN3ehJPfwUPYTbpUa3NVtQd2OqNzMyZOhmQG9xs=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:28 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:28 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/12] crypto: caam/qi2 - add support for more XTS key lengths
Date:   Mon, 21 Sep 2020 10:31:59 +0300
Message-Id: <20200921073205.24742-7-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:27 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: afbc2dd2-05f0-47ad-0e20-08d85e007e00
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3903322690F71B7088EB10D4B43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uc1S0V0B9isZM3+2JklCGFGgAqKVr36z5yW+X9Ea0YeqCXNAwBTx0A4XfgT1l6KWdPknC7Q9fQ6oAwi8z5vJuQIeXU4NGVyrsCP5V06gPfxW+bGcOOwIU+4Adf+XW1wt5f1OeXgiFJYw8ylEtK68nZpvdwN2agJJtroqH3Ar7p53lrk6ljxGiuxQd56sgJWAO5LI+Z1j2sCprTdpv6/KPyn5VZWQG2QPP6vwlUNi+AtOQn+2gL/QSaonUQYNFG2ylP0c+Xv1T3jzt2DMASHqBY2levoe89DYYn5dYpDwUrIjaDx1azwf/i3JYEQAfjokY0qwzgQDw+n20fpAf3hIE3zt8XDha3FoAMwsi+COENa24nj1YC/7WTxex6WRDaT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hrLCVz7pp+MNJvF6EzQF1Yh0+LmNafR/jS7EXOLHdZ8Ne86QmQFM6hJ0IP/ZYmU0s0iluMpMkXunBEKDk8Q2vfvYBNKAa/MojCgzIWpXe3qDXTgebDklzwavQpdGUF2vboReULAlkzH/yjdSc1YZdZUl/Wkg7aqoSga3shWG4Wf2ijUAxYB7jnEHq1yI1URRh61+vQHwtv7WJpcMy7q0m8FtB2BowV58+3cQpDWmGQ6DKp86xKT7ODNWRub4Vo9luD+a6T8tF5iG2E4E7DH5h4lt3RsLI5MoXQjoiEAhr3lMlVHCYbjlOdJUaP6ZhqZdhyRQGgL7F9n1dRdVXObhtlIMy86N3KNoq9TgBCO7VQ8ruy6I3ARlCkulw8hq0CHmDUFXUUNorkyfMI9Z7bniHDdTpV4eGmJauiUmDLMicOD4eUijPoaHNICXXRSFctLFO6d3L+UfZHG0GK1LT6F50lJMLfzEQe5ERLKBgiKaXndlkGMeYLxhrq8Ra6ftReuJzguxtOuP1/E86Vdj9O9sABipkTAUMyh3lclhVKaGVclhX+gKBqfGaQrmbrEQw3SkMf63RbPeqXr9jTeeqUojSTQjrDozQzFml1ElcS3LQXY0gebHRmSbnQauY+AosEYMOGh8NCkf6xC6E0tGj/3QaQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afbc2dd2-05f0-47ad-0e20-08d85e007e00
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:28.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 97rLDDCMUafaYVYdu4G2GFZC0EINBPCPkShHxF4l0/rLEZE6hL4lTZF1aZ9GnDHj2raVnmH4pvF1KKBqBLCHEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

CAAM accelerator only supports XTS-AES-128 and XTS-AES-256 since
it adheres strictly to the standard. All the other key lengths
are accepted and processed through a fallback as long as they pass
the xts_verify_key() checks.

Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 2e37e6e63c8c..5d2e554774c9 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
@@ -81,6 +82,7 @@ struct caam_ctx {
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
+	bool xts_key_fallback;
 	struct crypto_skcipher *fallback;
 };
 
@@ -1060,11 +1062,15 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(dev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
+	if (keylen != 2 * AES_KEYSIZE_128 && keylen != 2 * AES_KEYSIZE_256)
+		ctx->xts_key_fallback = true;
+
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (err)
 		return err;
@@ -1472,7 +1478,8 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
@@ -1515,7 +1522,8 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
-- 
2.17.1

