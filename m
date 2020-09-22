Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343EBC2D0E2
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B3C208A9
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="jj4OOGnU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIVQET (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:19 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:40665
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbgIVQEP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXwe1E3ccCgxXpblrgBEFZS6fYvoyKN5LZoU+4OEjIWdA+dWkL4f2xf59+ZcWBXEU6MNzL/Gj+d4B4MZpBIv4WPlavzQOXkO8QnbdAvzvgxqROCUiMkOyRE1HIVIns50G+h9d7YYFtxTnjGWlaZIGTda2cN8Agpi2OvD+y5Di+zi9S9m0BQetKbUbvC4tRwEjOqBSDwvFyf/zkJ/6X6Ri6hW9btoT9L1KH/gUqJgjmqQ8lAw9NU2aRsd7o4F/x6eSQtnUypS7TBFr45fKC8HgAHw5rpTLPdf3CftYpagYxQk5G0wDMiyeaVC6LdvxGaicRlLZKloP8pkugPy4lloiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25rAbYU/5sLGxzc9ZY0sRC5+V14HYibf8FJTfunPEek=;
 b=g56COYwsSgHDJf9+69hzR6l9mMUNXOmwL76XJHG4khHIcH26iZhCxxBwhKJoP4QNrLg/bJUCcgfInLomxX2ZvDSGtKthYje421U5w9ImLxNKGtVJQOsXq9rp29LtUgAxnmw9HZZZKRFvcTIw8cdTtpnY8xiR/+XfuY8/tOYw0jG1YCphVcJUo+NU0Y5/YQy4KgMRuXrhk8X0iT60SVg7KRdk/COIQ0wwy8LkOqS397E2k2oaQXzuIdqmKiot1XHtFlvOKruv14FFGn70eNOBnLWpIxZnO4U1UmuyRrrfTf80nFnPDJcBmoN/z0uD7uv1sltJPEbSG0Gek+WY5/p4bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25rAbYU/5sLGxzc9ZY0sRC5+V14HYibf8FJTfunPEek=;
 b=jj4OOGnULVw2Ef9mOt0+/4kyHDIVXpXuR6L4ug4JYaplK3GRHRJ8WE5B+wDWat+47FPw6YiEc532//sB1JoL0WkyIjxo1h3UJ59bZrG4CPkaiIfIepxEs7MMy2tXpbnRwR5RjEgqJQNy3xLMDqe9/M4YehG+hFop5lgo5UG4+is=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:03 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:03 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/10] crypto: caam/jr - add support for more XTS key lengths
Date:   Tue, 22 Sep 2020 19:03:22 +0300
Message-Id: <20200922160328.28926-5-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 268c5f26-a828-4992-0def-08d85f111fee
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70728DEFD89CD1D3EFDE29FEB43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LOxeSEmWlqgm5vTRb+O6TcIufmbqBl/BR4czbEulxCduEyLgpVETsMJcTWZqeZY/IGKadva8U18cpATghf0AqWP1nz49zalmpGWXBn0JRqZrW3S5DJA4XS984Aq6Q6nm4uhFlPnsHKuPwfUhsjRD3tUbJw8VJVpGd1z0y3ctjCRlMG1LqDYkxke0Lk25QhYhPpklUGUVIgEblAsgvSJCNQegJaRJ6NJz0c1jOM/TQ+naARaDEzoKzjfvtrRoRnKU2zeSG3HAdXkBk9fZ/OrcgegT27KpxxYcRGloJg/o+81/MainRMzGu4GhOclSd+10/FoW4CUVxht0yBopva4Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nB6bCGjSQ6av4dcv/e/B2zIpT7cjMPGzRZVpAfI8KysPeM9bBuaNHtZnawbxq6sBIBJwNFf4kHAeYcjV4iLxpJJb5bOTiioTzSwmR8sqzX06Uk8VtBnQy7e/t0qWUMyCkrv3OPcJj2r3DIsmoXbyl/FOhoOp8IAUBQ5nhVACYPI0ulVA2IpDsWBPFZEPU+E9pdqB3Jn6XVdBnorNxbkM+gHVnpFlcfIQKX7zm0xifwPEuei6b8uUx/gPSFhZQsphb+ea546w72kXfRxlSz5elfcoKDJMqwhxLtgxIfJrMjbh6kl2PLlT7OjxZZRlPdvQUytudnF77nLEpBgGOK7NQWWzf6H3+W2UQZd30fmAgqRcBO1lmN2l9cK5/9VE5S1zlkqOiH3+miTlJF3qpmkGQSTlNHGlaJZ3K3hZdD5rtwrV8w64dzw4b/aSiYU045ssIo6P5jiunlBzSYcI8Ag35y9lL6of3HRKENsdBODWreUC3DhynLR2/NZVLMQLCRqPbeU7I/hfM1j6WtsYybaLogUFDHciR66+T58NsO1JAsQQ0JNxXHGuCz7bRtr07Cu3FHRYKqGq7kMEKap8Wc0E/bIEMZF1bEYGsbBCZKkJGHhrQDC3gRyT/rvntCHCGtlEhEhf/yT3zPLh0EGbAzZq7Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 268c5f26-a828-4992-0def-08d85f111fee
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:02.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uve9KK3eW6/BKWsbqQhxXFC/rnU+6J5mvCfM4pWwAv0J1+NNd73rMHY+yeWkfjrSQHRPUe6iTysEdjaE5pBA9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
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
index adb2c05a8bde..a79b26f84169 100644
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
@@ -1784,7 +1790,8 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      ctx->xts_key_fallback)) {
 		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-- 
2.17.1

