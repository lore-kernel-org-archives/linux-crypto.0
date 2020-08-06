Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9CEC433E3
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C31C20786
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="LEGL2jIv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgHFRIo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbgHFRG2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:06:28 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57457C0D941C;
        Thu,  6 Aug 2020 08:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE00Wbu3TpWsGFrVIakWIioY7YyqlplGikhvBbs7XG/zzS47zunGNassIBVj/hiPEuPMvLbmfba14czl8Wv3VCjrg7B1hzvixtkRW3DqWOLmHTxHsDzkZC36T0YfCHlFeqsmGco3xBfjpRPi60+Fq2a4IgPmBcbTfx5UW0At1xpfjmWPh5uklUg563xN7cb/4N/xBF0MqPc9TWndGTulk/4Np7lZyid4V9rezjlj83v4i/AfF3o4KjUpp3AJaeOeoqHBL0loypfBElj6OP9elL1fKygs6VwLP9sp+ZM+2951NhoCIp+NvBxuu9cJnJjE/p/n59fzK502i5dOjgZGPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+ffYIKUGyfOzudCdjp+7y6SfBjAB94NfaB8+4zOiyM=;
 b=PkSAl8HDdpzAolNFcZpFQon7AJLycEUVsbkY9X8MYtrA719yJKu7CQWlDfAEeb+vtn4vxx8NdJoJFWtJT5nBR4SUk42c0UIGkqG5DfWnVU8tk+7EDlxKemr9j5Wx4zI7tXtbSadE7vXyd/r0whb0S0G5JcbsY8U6d0UCSQ0Va+ecTKP77kiRmFtul+O4F/n/LAIoTQDo2IwP5vCbjvCGftgeNmbJ89cc+24k0seHjMCoi6JPfjZBA3hA7losaJ/gpJj7OmF+f5GvEs3/3yEirOiiWM6DHs9P6KdnDsej0ZZ7CkObG4tBdO19UMRYECN7KNOzoroDLfx2hEiEZtCPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+ffYIKUGyfOzudCdjp+7y6SfBjAB94NfaB8+4zOiyM=;
 b=LEGL2jIvYdL2vjEHwwupl2PJ6JPhBdHOPQDwjWhrk5t8AXR2fpGil7h64zCWzP9LtSft2x5aMyTCnv1MQ+uPcbTGD60NgidZODdBa5LRiFbWL9IJB4rnRe9UK4t6DUD2HztV9rXq/voG6YZKljxWciDm0hu/3Yltz9WzTu99UG4=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:53 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:53 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] crypto: caam/jr - add support for more XTS key lengths
Date:   Thu,  6 Aug 2020 14:41:22 +0300
Message-Id: <20200806114127.8650-5-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:52 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c83ebc0e-84fc-4fce-3d29-08d839fdb6eb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440E1B337CA4BAD2024E578B4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRcQCOVPpv3UYMQdCDUiU2o/NHClzY/bGYQs06S6oqedVcnARZF3QiWNXLhxIb1R6qi8zz8khb9yccOrwvzb1MTIAER+ixXcS7kR60koe84mY5UYjBhqfyW6+BJYRx0zzXcEvT2u8VpI0inHtUEUFJOMwHNFo0/qmGv3wmlFOrskSKLJfLU4EchD2MJLA5SXx84hOE85YIyaOJsAQyIypCANpYaDy1hIr8kYFEJ36+mrED0y2fvLI7DPWjtobiuJqVhSFPHYYByUxMmgzXPD/JkGTP6xwGSmG/P7jLzn/K/6AIoMKCyY28eoaxYLPo0pI4bqZ912cdAsHi21p58fzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o5KARerUuRYhj6p3NyKwwzS/BgOsH7f0QgxlxcDXdSMp+NYABYrayk2rjZL0k+K/Z5Q4/W1h7iYMV1/cmaW6HTeHghJMlFVsqE9mh1437JHX6boajSGAdUJlKiAFydD4ymhcFfoiTC65sSQUdXtcO4V0W5UBg+56Ts7KRLM45b8bzYcv17P6YjHWDI39I2b1J1+e5WcOPXrWdvWREhfOemY8TaB3+hSWRzO4taZHWg3JS25YEPos6IX9nC6Js0Dfh5dscugFWZOwLjFrPL/UFek7fVoX7f/6wTdnzE7GoUzjbe6eI3YFciFglk9CDMFt5r9YQZw6UxYT/VgBXRe1x4FkhA6bPrBUrUlXiejc7uloBKyLJptMy/wSfwOkB0XAFfr+hU89AFOAM/eqx+m123sgv7+0663m+jS94NWL44iAYDvlN6Vj6g6n1PfM40+/2sCoPsEF0hUrmSN1Klv9XgPlGfUDKpwRBXnvumufMLrs4LLK+KXjGBI/h+OyovbqqA5der0pTJyU/p0k1/+bTMWn+kIUMliS6q65/aAOynh0Fe2TYsghKOw8oGx0KbAsSDbnLQk+bd3strBXcrEno+wapgKeAtuow1YCfn/zKFQVsyJPjCIWnWmnkqPFhRDobbuO1s3DReeWNBj88wONEA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83ebc0e-84fc-4fce-3d29-08d839fdb6eb
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:53.2843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Xhm7QUE7mr9kiZZ0LkaaGoGRaYQG0OAqKFENIWUvmz3XSh5lXhAfeGNv2dOD+7+yFpyKJ8JnPYV6cRq9BKvjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
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
 drivers/crypto/caam/caamalg.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ebf4dc87ca2e..a5447ae430b0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -57,6 +57,7 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include <crypto/engine.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 /*
@@ -835,9 +836,10 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(jrdev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
@@ -1790,7 +1792,9 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
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

