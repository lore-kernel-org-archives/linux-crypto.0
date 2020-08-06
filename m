Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A387C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D2B23119
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IKSmVWoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgHFRIX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730058AbgHFRG2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:06:28 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590AC0D941D;
        Thu,  6 Aug 2020 08:43:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcTBdDcKqerGjdHRPzXDt1yNL+JGZTLZyoLzB0roQ2gft9aOvIZKdzgSCw9iG7vfTb/dDDQ16pExdB9BnXi7vvpJYjr9zLCuWNyNAOdESpKdcMrqSVxE1DEJmmx5MWMgvRs2pzzuO8n4+Ba4GUNH7HLXIQ9HEqWgJv8CryRkHBR1Zi6AL2ObtSRSgFdcpHDdcdbBGMlhltTqKGXH+JD6jTJBF/4500rozDBADcBK5D1YFilyIdq7TPF24qgUQ2bWZInBX5mv4qBUsTTPXg5Ttmj4vSqqgLUOWMTbr3bMY9zSxw+Hs7pDWPOh/3IOU2/6iWFtwrE9WaHs0Ttfv0EQ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6DWGyZrcAc23RA5Q5rukWQiiaO8jxUB3Q0Ppn4lOOc=;
 b=eE9AKSz+mZo7CEW3rDBgondRKAfrMU8UOpYPWl9oXaX3r0dn/hF8gUudp1cgYxR9Ze5ioxJMXOj4snIU//mI7lqH4XvW3fpoOyroVXTo03k99pfH6BegZJIMTDS5QuPCXLLYi/MQU4aH6WmEvfbHkfMRW7m4HOBP4qUivjbwU6curxIVfPpccQen94OQk1XWaadGHqnWlm4ZiGZpcP6S6yJibStYrAE9EqnlDQSUa11qukqzEi9i/OwWFLAO4sL5N9dyLHgqWd77oR3SpN8HR6HxD7LYWsV9IZEh1ADrmpsaEkOdCfA5s1X1qEskvinG7jVA5c3lz4T6rdpS8G1bmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6DWGyZrcAc23RA5Q5rukWQiiaO8jxUB3Q0Ppn4lOOc=;
 b=IKSmVWoNuHJImGWLblSr8uWpJ2N28Wj4oNRX7G5cV+kfTnRVKiap9sgHapewhU86q6gPrGyEeyhPWE9a/TJpFBPTfaKu/5wNRoVjxXDkw7BB41Kp6rhN5MWztqq8KOrtFrQraWUt+fGPd/xv29HApLHAKBXUgaf7ObceNCGchJc=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:54 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:54 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] crypto: caam/qi - add support for more XTS key lengths
Date:   Thu,  6 Aug 2020 14:41:23 +0300
Message-Id: <20200806114127.8650-6-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4cd6954a-5e59-4642-a947-08d839fdb769
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440B5C0936C0293F2A828BDB4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0SfD4WF0LPrHbTnYD6jqIuXmDStanNNW03KTfvQgoYE4wuPNK4Zn0wWI28bR4ZI7qvA/eWoQzA4m0lvRsYqCPjPWWa6+qv2UgNa+Gd9G9ziUjNhS/asTwT2tKDT7szOjYYnYd4VgCIqnqUiwYULpuT/NWD+e/OtjIOgpbCgHoAU9WbE8fHw1bO4tbJ0Rnk/0kQ+xkZpNZ0kU83A3657JkCIV1bwlnK0ffyPIjNoAvslKe+PDAEkgT094+EY7fczJ5pSXJz12u9P9VzEZyjOAPsN4ShrHCZ5DEnpdmaqHrfELVUUPzIQDHk39PXYlRcwX2anseIcgPZiD/5CNp/j18Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zlqgU5zyfsMvKo8ggzLqMtrF1CRStrHRXD22qWNDqoT0pHe5NbbloJKFliUbiymlsNR/COj7JpbFDa3GWiYLRqakSiZJn56vrInlX22faeKbO45W6cGSXdF1yGIWo4YJOHj/UzuVY/VWJj4GX3k7FSXHpXaohF20ZOGoVDMNfT61Lb/dJyuwJs3eRkO47dcUL8UaqhAXwrlMHHCxstJ72HljmnaAD2ua4oOu92PU9tiYe2HhsgtidiSC1YnGxN+HSgsH0P0lENcdk/nmd6z0DUN+T/VtVmSjsexZ1Or/Rh91tb/qfHtWqHrVVGX7FaZR2NAWdae2FMVLC3JxESPVqL+7NcKEzIw2TTICd38t9OejCxA3hZM9u7nqsVgHADZFq4FuTZr1JpkDxjXemAVcvJlMoU857qHq0KEsx90BoRHsRnaUz5fR2RFp2jrhP1xXXlNFTq6h6umRskzl7CPOyIZZFX/FJ965HJeZOF9+AByEXuAR/uv9Znl4E+oBNplk1qWeh7xoERkT9rkO+Y7RlRj+tQHdHIMeT1Sb9kBAFrac1BtlvQkEa0d67qx/RtMdLXcWKX8Y0J2d3+wlWqagVMzIIS0qOVmdbf2eIznAvmAtGfmuNzxEnQlnsmLCSrgOkMdpoDEYF2RBtBUp4psAeg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd6954a-5e59-4642-a947-08d839fdb769
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:54.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkhWCrFvwEZUceKxRJttaSwd5SNnnSD5S5hUi5TjflAaARkSGiBFpiQmcsDFvC3E1GuudRSveA1VXu0YWzONkw==
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

