Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A69C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9BD12311C
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="YCo9N4vY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHFRW3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:22:29 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:5856
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729811AbgHFRWK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:22:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5s97EfATDWCJEMSbvDLsttovRbEl+y1TJVlDERXZCns9edxRkJg/fG8g8orLbnXRGv9Lwp3+1ti7SF6k4xezzR1yZU3ih6/sgagQ+cfl/ErR015ePK3ezqqegAQIfNFuLb7HOMrmCbeLLRT5nbJd0B7hkXzVm2lVfjQld7H59kbLtFmkHNNO07iloTpErlSyEpO5sgxUhu2ozZvOSFV1rj7whSCyyj3H9X642Lc6nt+UP/6uyL09Ku09hfhYA6KUfazG1c/FPsAjoLyB8zsjvY8jdK/jg1hhYhDduwYPRdUyn8W0D9TaKOPIc/MzTwsNAxXrVcoMWjBLg7i0ycPFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4FFxvCtd5FGH5hWLm5Lv9sEb67r44oV0tHVJRKUXLw=;
 b=jNHccwq4t1uX/tnWLvAPuixDjEGK1Nzbmy4EUezXXgNy0TE8O0W88rrEhsgThiRi7MV4ZdaaDASbhia012t5SthBt4wedobouhr1QbESZwI8hI7PXV4mXES0rHcs1bhvuUU2lJUBHd27NbfRJGQtg/cRM6+iiHIRtq88LaExWwYQnknMF9W5PTI/J9Br+/fUAAKb0W02KM9CEgHJSWVerw4hXWD2VHsJgC5cndhx7I0c1+agSogBvrgSMdLI3IK/b+U+Q915nl1s3AnWAsSA13rBo96yj45ZWXRxFNtJUUzxzAOpnNSJqBfnXzpCPe+bccr22DzGMEjJ3ivOKumYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4FFxvCtd5FGH5hWLm5Lv9sEb67r44oV0tHVJRKUXLw=;
 b=YCo9N4vYTUNCuJAPrBAktKAhZpok3ST2xRLqNtTfvtPK7eR50hDrw+BcwjHFvVkn2P8SCBlrfU5RDLoiyHRnAQdZRxZ8ZIbgpkrSmpoT/FA5RfSbkhKWPmbV+9sjbV13rP7AZjKqprxmdHGppI1zu4mGLwwD6qN4xkrLugzrIU0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3440.eurprd04.prod.outlook.com (2603:10a6:803:6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:41:59 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:59 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] crypto: caam/qi2 - add support for XTS with 16B IV
Date:   Thu,  6 Aug 2020 14:41:27 +0300
Message-Id: <20200806114127.8650-10-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:56 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db75bd79-b086-4ee5-6bd9-08d839fdb95b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3440:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3440E422A9C6CF6276578D1EB4480@VI1PR0402MB3440.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfVR2x6EOP4a3KRHtlb50513VFGih+QKs4dFBaCyo33DY46lX5ay9eYbFaA29R/Kdz3DemeUu5g4r8fN6bsHozCSAvV65AlZwFirB78cUDFKlQjEuRx9QaoWB6S/2Y8cWDi0Lf9ee60tIIG7P3foF1mG6ULTkNVeVFrH9m+DclTsNx4PjGjZNR23oo5FsyA96ua5ZYEe3yCJjH8JxwH3kQq2PHVeDcGiRdxF9QU2tIBvnzeeAcjcwTOB7MVw5a1UZtIiQ9TM3xZ7o86X3K5o3W+XFdJ/ZEGvHxyrVYE5qBV2BOLykftDk5a95ky1JGL1x3gZi1vfF029Og0Q3zil4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(110136005)(316002)(6666004)(6512007)(478600001)(956004)(2616005)(6486002)(4326008)(1076003)(44832011)(52116002)(6506007)(86362001)(186003)(26005)(16526019)(66556008)(66476007)(2906002)(66946007)(83380400001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qPacvdCh9sZhvj+wQ5uYw++pkdddMC6Q2vC6rkcKKWStD5qsOsavHCc5B77lREucDO6NPrGgwomxd/QcCD0/cyiuyLvKf6a6RPJb7DIHu+7yhrwsOfRt/ZT6CqhRsTwVmhuDe6sD2wNjNJI7NBkBDZvpd9WSFNsUNei5IGu9XY6fDYZmO5lFrdmzeW7N5S0i/wdmlLB7o68UM9nw1tMt47UPl+tXTJiyMVkOeNt3D9HJPDRvmSy2APe7WB2GuWH+A/AWh9G3lmCUtZpJpQCGwo4E/MCLt1u6Gh9z9qLbInc/em/wfev4nR2HY+mMUyUfKA8OTbuen3p9ITilWBVZlepIQnYxeF1w8RAbQLxCuuzPiaF9kbQA8fd3KW3N0xC1HkBNYe/xx88Qud2EBBVN5yxoH638SkY883lXzF3tCS/1x9IYoS0KuyTbC0UbUMA6TJS96xgK5tREslM13+NI6KWAof0hW8UIVGRXVnqjs2fPdasTCNAGqlCYE35W/68SfQqdU8xGR2j90cF+2pFa+IewjNrDxKAxHC04y94ZrOBNY0Pqz7t7cUydbCwdDh4TRDYbkvn1y/DcZM6ZScFcU0GVpr3cqABHpSHnESkSJhslsFcDGoJZSU8YdEIgQt92yo1an+gOmq7DywpBEm/L/A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db75bd79-b086-4ee5-6bd9-08d839fdb95b
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:57.3519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g3tIpvG0R+26SFplJC8YPEWaq4g3G8/sAu8P/GLtJCunzzRGef1vowILlxqb1IM6UkcoBpSopc1hGegBNVavoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Newer CAAM versions (Era 9+) support 16B IVs. Since for these devices
the HW limitation is no longer present newer version should process the
requests containing 16B IVs directly in hardware without using a fallback.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index f2f137f47972..99b1267b1a0b 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1057,6 +1057,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *dev = ctx->dev;
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(dev);
 	struct caam_flc *flc;
 	u32 *desc;
 	int err;
@@ -1067,9 +1068,12 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 		return err;
 	}
 
-	err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-	if (err)
-		return err;
+	if (priv->sec_attr.era <= 8 || (keylen != 2 * AES_KEYSIZE_128 &&
+					keylen != 2 * AES_KEYSIZE_256)) {
+		err = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+		if (err)
+			return err;
+	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -1472,12 +1476,13 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(ctx->dev);
 	int ret;
 
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((priv->sec_attr.era <= 8 && xts_skcipher_ivsize(req)) ||
 			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
 			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
@@ -1517,12 +1522,13 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_request *caam_req = skcipher_request_ctx(req);
+	struct dpaa2_caam_priv *priv = dev_get_drvdata(ctx->dev);
 	int ret;
 
 	if (!req->cryptlen)
 		return 0;
 
-	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
+	if (ctx->fallback && ((priv->sec_attr.era <= 8 && xts_skcipher_ivsize(req)) ||
 			      (ctx->cdata.keylen != 2 * AES_KEYSIZE_128 &&
 			       ctx->cdata.keylen != 2 * AES_KEYSIZE_256))) {
 		skcipher_request_set_tfm(&caam_req->fallback_req, ctx->fallback);
-- 
2.17.1

