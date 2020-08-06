Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30B2C433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C228206B2
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hJckeh+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgHFRq4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:46:56 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:40385
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729037AbgHFQg7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:36:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMCr2iX8e47fvLXDs4LSQHOkGw8G/hp7P1LpCGRKENNAqLsFn74apJZ6chKhPGz9amGzToxrijzqwx1eMRa4Blq5wlRrSydw1WLjOIv/+9pDqZi1X/0eDU20ptFcmN86UenJ2A73Zlit/ncH/m6UHNOaPSDchzaBXJcrdQtjZdgWnLBURk6kLanBEECs7PEhGHuFOPuhys9LK63KtEy/Mm8iwStemKm4C2uDGfC8gIm7tr5NrRspq0wJXFjKnJCiraLQn0e8v6fcdwDRm7u9zTcOVX23dU2SlQw12c/W7PdxRTemVS6NKtBSCzD6M7TGmXp+uXntesirC3jHFJ/srg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIjB9Rl+VRm7VK3Tw09Xzj/S0WiJewL5eXiGQEOxIWI=;
 b=jpi4kUaZgPmN+Y4rSTsbILnaA96cysB92uSA8IULN8Sc2+re3o3NsMYYTFWvjsjYN8tLQ/UFZRHAXRqilNN8XqONiLW2ihXWs1zge+DrIZVnPDHJOArzeN7S9B7GIulUyaSONEBW8/YBjgWp+Q3jJyS9Kvb8km6LFTSbpo+cJVWdFjLWNSJ1CBW3mpKwPyc1agJU7DAge+3rVB0uUK9E2HjcaqBOmMPvCfxsRYrdNQ+f7b9LC+OMbfMo1PolqTGLqkkfHrpsx1kuS9eMQrBtMT2q1dO/ziP5iJlcWW6qF/ShPVGdWjNlk30Sok1h89EfpI/0rT6TbDA56/H8suTBOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIjB9Rl+VRm7VK3Tw09Xzj/S0WiJewL5eXiGQEOxIWI=;
 b=hJckeh+3TuV0c+NrbN0t4c/vjvEbvE6YY1oJpR3sVkBPra90HikWjJB1tNzANN0CVqbdUHlub/GF5NaC3mXszKX1ELfKII++U0SHjvUCYbAdo/nFD+wJctFYmQfwDYXVxIbVhJ4cM7tT5KVU+xDj1CAWGBOEPIHI9MYqbJs/drk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB6959.eurprd04.prod.outlook.com (2603:10a6:803:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 16:36:20 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:20 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 6/9] crypto: caam/qi2 - add support for more XTS key lengths
Date:   Thu,  6 Aug 2020 19:35:48 +0300
Message-Id: <20200806163551.14395-7-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56855689-6e1a-443c-cfb4-08d83a26d955
X-MS-TrafficTypeDiagnostic: VI1PR04MB6959:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6959E8E1F57636160BAE87ACB4480@VI1PR04MB6959.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRoMqq1z5+lXvp1C/2VL/oSKnexsrbiL9kVJ+YH9nr8krBe5i+Ot8pkr8O8E34m9AvXxYqlqUNUpXbyaXxiA5RGX+Z4oN0IdfTjMgkW9xDgpzVI7th3q+40UCLNGBBOGB7I3tcRFV9I8pg0RJ+mMjkAObqBAjx6Ky5frpWsN/ZlWCXcCVy0IXjozNUYbANf4t6hrFXuzswi+vVbeQyw4ye0TjivkOW/z76nL9TjudiC2u/btr0jnWHkp8jj3do0bsVPHRQy10NwaIYjmUq4+rTADcVfsrYtM7QCrjkzgARiVxMqmioxDFGTAnRmJZpBgGHqXk9hjK4ULcKCw394s7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(2906002)(16526019)(6486002)(8676002)(4326008)(6512007)(26005)(83380400001)(5660300002)(2616005)(956004)(6506007)(478600001)(8936002)(44832011)(66946007)(316002)(86362001)(66476007)(66556008)(110136005)(1076003)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6VrihnCoal7V1Lm4Jm4iBTLGzHL7V/EIIxzBxYaHuhAL8qYGJVhDEaWyUWRF3rP+xQU3Dpdv6ZEgx5pMuW8+O6dsNggj80UNf4BnquM9kP8Q9X9LCKtexD5bUhA6a6PXMafX833L5WIWKSt4c/mG9G7iPaD4lAkXHQBNdxJOwAeZxTJn1zwpfA1PYHqOpPNqjVuYIRbyqMCqwRRvfeLxKU8nGrzhpLHIVU0i+iyPEQClmAEVt7WfBpOXb4zB0jGaNFhSw2Hzi524tG536mQvMNpO4PXKzZc2Ygts7QcYLK1Ky/gFHrRKtBZtOBqPPfkf7Hawos3AEJbPsjRnPp8FlWIQRYiU2SBWl4fdR3nLWF9pKu1CvsQxuSoOVAvy7xBwp0DoR7G9F9U1xzgem832yZtWvyvsZ4GkPAyGvIQcUPPWOnYFCS0VIo3eWV0hKiZFczVcMLd7N0p5gUNmUivB9FE0gBx6Eq1He4qkRXkKCf56NmwDwckXYpc9Cb55DCbJ55R0eV0fEuJ5ejUcsh37RpH83Cs07nFhMXMUKwjKYiBtCcNgwwozpbJy+3fMWNA5bRUvZt4XLNSo45lcP3kSywb44oL08qneFiba2yHclyHQbekd+Kn2iprDlGHR41gan1cAwu2YbyOLIQNBEpjG7g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56855689-6e1a-443c-cfb4-08d83a26d955
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:20.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQsxy1O7n6DjQAQsJTy+zHfoEb/t5oMj4icMpEDB00OuZ7n49CBB0+rq99jCU9IZQ5nkEarYKvrtC02BM5oqvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6959
Sender: linux-crypto-owner@vger.kernel.org
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
 drivers/crypto/caam/caamalg_qi2.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a0b13bf6b528..f2f137f47972 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -19,6 +19,7 @@
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
+#include <crypto/xts.h>
 #include <asm/unaligned.h>
 
 #define CAAM_CRA_PRIORITY	2000
@@ -1060,9 +1061,10 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	int err;
 
-	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+	err = xts_verify_key(skcipher, key, keylen);
+	if (err) {
 		dev_dbg(dev, "key size mismatch\n");
-		return -EINVAL;
+		return err;
 	}
 
 	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
@@ -1475,7 +1477,9 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
+			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
@@ -1518,7 +1522,9 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && xts_skcipher_ivsize(req)) {
+	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
+			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&caam_req->fallback_req,
 					      req->base.flags,
-- 
2.17.1

