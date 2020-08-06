Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F5BC433E8
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB868221E2
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="VgE7Wz5W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgHFRpX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:45:23 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:52034
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729031AbgHFQij (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIC8c3Ut8ZgU/2ZEnF9wToi/lnN9PHKduRh8NJrTHhGI5zY0kPU3BvkthSCe5R5Zx23bPPMR/bLMYywNt+U3JNsENTj0+L6U/9d5U3E1OBaEYrlIbdc5T4G7crWtQAMbs7Pvjm3F3rcAqodnH/k421ytPmD/cxFMlODecV83AK1AofI/RWG8AN+vu/n1GK6l919uXz/7XxETbJEnHqn6f6lJYvFIX4JafmKkQr/5yP1NL8fzHlJZlr8Ytax4aihxqb4HphG+e4I2hQlj7ixES5e8731tYrjc6zJf8UpfWaVwoFbuSpvcI0ZZr1OKqUglC9rfOrnY2YTAm/3+GfEn4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+ffYIKUGyfOzudCdjp+7y6SfBjAB94NfaB8+4zOiyM=;
 b=AU9jv03Qv+Mc7Et96q3AmvMtzf8xcxbwVx4B6kbNOyDq8Bruy9eIXr7T2LXfZ97SgcMlIG4n0N6wCXHzK4Ry9zGwyJW91GoykwuWDrq8Mrlh5T+kw+8IaZLZaBFNgjXvu0KLFFv/ECiseEGKhlCkM1e0FglHrjnszspeBohquFWAYmBl/uwKQtpyRbiL7qFMakt7Lvh9aYUWetTozRU4/BG/bfztUGCDtsMa2IdG/AP1u6VZvd1vjfgKrUjtLbtvhjbN8dDByTFhY0BCf3JmdkX6QHzE8GYKVHqe1OMxV4HVN4ZHxo50yeI6F37troQnNEq339xQGTuseVvAuVvaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+ffYIKUGyfOzudCdjp+7y6SfBjAB94NfaB8+4zOiyM=;
 b=VgE7Wz5W4DMPNwCJoxGXNiYofXpCMVd7sbIJ2qWu6B3f1WjtsFnw7aYN25jdmFwcOasc7qzPI9N42ISYyg2nXOwdFU4QkKInbMAD8ECkGbjHGNXWR2OuaGrxU2H6y3UeoicdeTdlYmVPu/vfy3rrOE2JNqsljbd6WassTNtj+Ro=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB4992.eurprd04.prod.outlook.com (2603:10a6:803:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 6 Aug
 2020 16:36:16 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:16 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 4/9] crypto: caam/jr - add support for more XTS key lengths
Date:   Thu,  6 Aug 2020 19:35:46 +0300
Message-Id: <20200806163551.14395-5-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8f3d148e-6473-4d1c-a8fa-08d83a26d6f3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4992:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4992D4AB73EC96D4A7801398B4480@VI1PR04MB4992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zzRqUEoelWi/z8TdYbW830O4uzgJLxJ9TZeEapQn1UxAA9WrzdkIHFWutumP7IOqwP7/9APTEdREVVePwrjGHAfA4L1xtuljp32JZ+Is8hBXJ1IGlt3Cu4is4OikKBgqRPqHjFFd4qDqRjtbIWQe+iXmHRO0MPufACR3vRHrLUmMVcvSEh2rSs4bo8cA6pxnDP5xLKuh43LP9QRn4iIgVLTKCBoDxdiRlQ8dfPi1vJ/8uwpCgyhbeov6hqGnJfRfBlV/6L2/LPaj3Iq8EC7B63iNlILFd+orNdchmGR/3Lktl6k0QhHWJfM6CETESTLfkRygAlzp2aS3qaG94Bg4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(66476007)(86362001)(26005)(6512007)(16526019)(186003)(66556008)(66946007)(1076003)(110136005)(8936002)(316002)(8676002)(478600001)(2906002)(6506007)(4326008)(44832011)(2616005)(956004)(83380400001)(6486002)(6666004)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wUSmC6vrm2knwlf2bMgYyay7k/kAQWyg9ZEIGw5C4ZNj8aJkvU3KI/H3l8EvJhuiaAmMP7L5RXuwd6M3RTJPu1qhVvtCm1a5wVQiZm7klfI4V+fzNRzfLvg8pigMzJZYMi6c0LWX+ndd7cDpt1LEnKFuW25AkbjjKFh75K86n9F13iVhVh09ft3w2f24lDUR1B55CKWZODePUBKN8nAxElYw1kMBYAp283iyuJaXWh1SLtNclS2TZdE9l3jRcliEV9pbiwEtYhVja5nVvRim+xv0iSxXIfKe4hkC9+qD2APxxMnoMxHgVhm8vAj0lX/JcGxmwLTA6il/Y2K+9Cfy8HHaxYeMaOzdedajQfN5y37BBUfzklvp60kKKlYif2J910+fo4nV1iZKl4kzzHRFXrqnBgKfOslgt7x1P/c+qMZwKYTBoNv0xvFQHzplulNjT+3Vv/7i3h+iBGIJc3LsHD7rsNyjTxyfqLhUQfVMe4FQniP3/riFV9fPy/XRBNELmhxE2Ff1mH7/N2rfHWGmvBOfYCwvGBStwfkEQLKH37xHcfvwdd9vzZD1/aJ+48+DyRSw83gBW1ebTDJhPOffRhTVv+agrfNsqGvhpjnuRwBWRmIjSY/LM49DCCLC7n6OQzdu2Yw6bxjaW4Obt1c0nQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3d148e-6473-4d1c-a8fa-08d83a26d6f3
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:16.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O8RWMxSCN5qMi4paFnmf49vG5DzhkbJLToCtw7i39JiDbgNjAoR34XvR/cFB5bZ7ShF9kJica9HanHZWgSPlsA==
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

