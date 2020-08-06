Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB2AC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEEDE2086A
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Z4XwZdQZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgHFQkm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:40:42 -0400
Received: from mail-db8eur05on2082.outbound.protection.outlook.com ([40.107.20.82]:19297
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729058AbgHFQij (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ae2glBRYqV8Nnx7OrW8iHXRoTt9nO4oi0Fgm/y5n3zzQzCvBwV45MV/ThbZO9R7j+VwZ7bUKcI3+InbXRwiggm97kjI6Z8sZ6NwVOQeotgk9qHJkOxn+uXqNPIiSwdg89QeZOrY88Urx3Zu2ADzlk8UjH5rYfKkrPsrT+DtpTSvN47n7+itFSMITQ3s0kdvMeRZDIWVzM8vAdecsTkPMlaZ7FTY7B5mecB+4/r/EZG+Wdcu7kE7uqvPANcOhfa3Gr/wg/Ko9QhqJUqRnnUl/rT2wh6zWUTEUXLjBJttmZi2uTyWRbAQrCMh9jjQRJl5LAjXvVMMT1Yw05QGJiA8cfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4FFxvCtd5FGH5hWLm5Lv9sEb67r44oV0tHVJRKUXLw=;
 b=nUfmx7tDWd3rdx8vxEilP9eCZULgqagYpujmV2ZF8hUsZ41Qvz6xwZ9xSL0NqFJpyPyTU2m8qzDcD28WOjPuj9MaHIy2BWGRqL4B4D7LCeMcEaesxgOn5W65tOv/zxIHam8UX8PCC+B0Lp04j4/vPgAAtXpQiY6uXBmYjgzoAGR6X+RK30fC5XIFkLVC3d3/Y/bMZ/GiZo6Ju7ikuJfA3LfRI5gGeoxFyE4v8KfL+PzOsLfRUhfy/S8no9d4vxwZB+CH07EhhcLi05BUYN1z5DKfjNCD27xfPpZy8UVx2dc9L7bCKQQwIQrFe2+4SyG0Xa3YPwlZJf6fadIEUKPHGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4FFxvCtd5FGH5hWLm5Lv9sEb67r44oV0tHVJRKUXLw=;
 b=Z4XwZdQZcPkGHssQJbVEO0HEuVtu+LbLhAxBsHEAwiF8/23kdPNJcwNwmHXwziIm9Sks6FZojEm0bXcdl2BfECifG96Q8wXUFAaBMdmmEicICvFMD2Ihlg9pRTW00dF6nk5OT7eFX6359jTREOw7/4ReUpXE/hOsMAZaYWrIfiU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB6959.eurprd04.prod.outlook.com (2603:10a6:803:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 16:36:25 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:25 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 9/9] crypto: caam/qi2 - add support for XTS with 16B IV
Date:   Thu,  6 Aug 2020 19:35:51 +0300
Message-Id: <20200806163551.14395-10-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:25 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d34e166f-d4c3-4ef4-4ea8-08d83a26dc96
X-MS-TrafficTypeDiagnostic: VI1PR04MB6959:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6959D9913B6B3351CA4962B3B4480@VI1PR04MB6959.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQeDMSebAMkyt/T7nPVPQd5qICy4hC9FbrZiq9yoa4IcWAozardDmyVrhoqSAe9OEeOvLe3YChCOedSRmLLVkYSYZvusOVuzO9KqvfYduSjIWkmmPChwWYQoNWT/4HIyvkfTtoQa7tg/dGUxkyoOwf3GW8xBaRtkkdf0c0y/mRvI824214ZSMMe8t8KPz8jaUvKSSqfJ6hIWaa8fujcrVCHyxxl0ltyL2Tp4rk1C/AS3ZLiHqSsURtfU6zsY1crSX21sdQ4hZWZRdXlgBtHoMJcH3o+T1HzKHRSlVfKDebRlyfCU/bJZM9+BEGfawO+p3cLM0PqAidynn2H36BJrqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(2906002)(16526019)(6486002)(8676002)(4326008)(6512007)(26005)(83380400001)(5660300002)(2616005)(956004)(6506007)(478600001)(8936002)(44832011)(66946007)(316002)(86362001)(66476007)(66556008)(110136005)(1076003)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dlAJ2y4r/1shSpaGkba+43zTQ/+LKJgM1jSiH8HHn/15GSbhMvOUHj29XdeCMbkC7ppt/P4PY89eE4/uNLuvNFvAT963eFvEp8CkfF4Y/VHxgrJ9JrIu9PTeY9W8l0qpfyYQkO8MTcFlKknh5ldFpYBm4G3boXDGhP4t4tMsZO7xFvTvfbQK6zU2QQWMhOp+qu+WetH4/gRABn1hhAXIbPsTVtqCLbMgrL70U84AdJ3dApGCuC7MlWDlqJlpw9rZFZTk6OcqieRKL0lCqOSsPBU0hP1zWQWuxTN6nzeuiOfMTuK9QLZWwrkmBIKCA2sUQ+yWusJ5ojvK8RSO5L1+OOi+alKHR5MRtCc0DtT/B1cfLr5TTWEkVujKSjOW7r0OlWlGDaGUwgONVYBqOlsb8EHZdMM4U8xu3kIv3GPtfaRO38KxQHq6zpZ4obI73GrGMeEgEFp0CgSDKjbQ9t0yN72h8935gjNOqvimqBVkB6MG9jirkkM1My2ZG93hqzBo2Uc8B4dLdzkTzL6N6KkxXkvgcdFCrKB8Dn+NBnl3Cvbj8/yoLuRqCDsVNsF1bhQrh9kA9NFnN3gw1vXZCz37KQjtzuIph16qqUlUCFz3p0tB23Np4TotTJ81ooLWksD5IVbj06XvHgpzaMFKUuZ87A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34e166f-d4c3-4ef4-4ea8-08d83a26dc96
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:25.8290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyucetnUJo10RJZaGgW1RG/mjGUxuLGiHOLlfGboZCJkbbEIqDQyPnjkywhYh1Yp2SWIH/CPK9BY1NW3zkrRJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6959
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

