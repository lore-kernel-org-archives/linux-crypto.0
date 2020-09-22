Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11782C2D0E2
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5D0208A9
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Fl4ApLcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgIVQEh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:37 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:40665
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726721AbgIVQEe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqQS5h0miMlOxmXCUpZ5hNSy6dJe2l8F4GDsPkvQCo88mXr0RrhEKK+Zx60igUTKBD174FjFdI29JIsBn1sx4pX3VB0vTr/2I7keJ/FPmfMGcsitXznvxdqcWxunI/P99TZ1OoYrxT80H+Nhvk4HAn0c6A8CfQWHKeKiU0kqjlENWdOu3ycU7PfY7rhKJmzQp0dcZytZ3yUu39wXv3BLz/WGF06eJVbeI2uPdhvXaR54S9EozsAhjSghzcAJPB0zfopnqbKjYTqCpkXX6P8KS5Vsx8l/QZqPHDYgwra3Aj76v038wjsvMp9HNKAYa4XHtqYD+5Nj3r32jAnC2ghlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/UjFOmwTRD6x38o94IyQEOLTYv2mNzSRW+3pBngMlA=;
 b=Vx4K75FZFw+F3rkx3EnIMo0kV+vZPQXceCNO8MXvVjOKR0ErfKbsH2e8fa9r7oKFwnFeL8T9Px3LjiYv0+yQyYRHOb161ihHQTK+5Ys+OfJRH0tKMPp+Dk6RIV7HOeM5oVC9xOU1wXNcL4YtxD0BLPKAf6aGFTCLKG2Mto7fAfj8JDoAmXMSx7ULHFZPKjrfdPbXnohnkj0UNLQTGYQM1AmTXvWVvnSNGXVtr46xRkFYVked58oGtmT9Fx8xHkF9sXACXbIOrPNuF+/jK56S8+aaYRvMrl0iSmH4Fp/fbe4AGcZ5m8s2mjVdNYP/Wcbcc4PV30LVUyyXPfxbwcpRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/UjFOmwTRD6x38o94IyQEOLTYv2mNzSRW+3pBngMlA=;
 b=Fl4ApLcnRtgyCaolxaM3jiA6L7wEBp8dOhoX+8sDDTOydDjVcyFJEfB3BzPjVl18WgAjVnubdKpjmYXUb1bzi+xIR2TAvmldi1jORXBW/mO7HsnW62IJJBhJpyT5W3zK2bVTKww34n+o3qMGgsrYXHPn5hvAaNfsKSS3Lq0k5v8=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:04:06 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:04:06 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/10] crypto: caam - add xts check for block length equal to zero
Date:   Tue, 22 Sep 2020 19:03:25 +0300
Message-Id: <20200922160328.28926-8-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
References: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:04:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d893ba53-c78a-4f94-3cf0-08d85f1121ae
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB70726AE0002588D3EA2BEB39B43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9M9XVU4EGk1HhwS7u1MeimoNO4LIeTGBjZuzyJSy0f0eRVCqXmeNeWLDG/vLa1Nq2U4FiLr/QvVRbXb26OR5dUC3erfFQDNrC9nv7FwWY+DwwUUSXphR4GUitm6oXvcWv0RYq4NjAOWjwf/37sb/SNENQ4aomsr8xo3ul8MPyYFHIovkhWPTYpNK7jItfM6IsoVUGIlL8v6FIc6ouWmXlgHCGdfg2jSkx9et4dQrbGeFKlwPdGzzPhcro2+onvqoiqPtN1QS5xKvMYxMP9pbJ6CO2FbbAX4zoRcW41xdkn+5lXHk3jY5C5wlyNpzp+9T0ZZkbzNhmr6YGVtWQbCEJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: j+mz2gK4pf8NhISgyid0+VwhvzsXXsRDmCQwYIqVgL3BFbrOydAYbnpjABLwzocJIdJlFXmyrr4UEol1O5NNt2ucM+3qebkKRH5u3Q2dBz0ktsKSgqFjDWaGX+2NkvdCgTeBpiPpMNUBfRbuLEJKLtFZLMTNFgll558aSFvpLtpJX8j+jqiLFcqdMfAPMUPjzchnL19VUPdpeJ7jXdXEHdhx6YoWtbP3/Wg5GUp2tVXv168u9U1+iJNgE0Q3lVvyi9UC6rKWIOZ22anEiStK9Z5c+9H1JmHn1p881vP5sL9qkMIwPY2jxwsYO7KMO/30gmbfplJPyzEmnapslKSfEfEGmangg/TYbB8w1IUHOn/BDdlB5+WDrKlqxviYQdN+JVgWzN0NO+JCnfpL/zF0Po/jPrS4FlIdSBzxU1ORmCS+5+ZuOWUcdWYkdaRyuvFqxcFQmJskSkc5C7jrH8rXd7M6HtQiTABOG3edVcuihVL3l27p9ha3MOMgk7jOT0LLE5UAFl9lS5Sl9nafN3EUwFVyQ2b+hLO8boWjCzifXWiN1Ub2BtBqgkf06eFI14OxxxfasMrBOzjweKHY2BpWTv9BR0x6GZezhUO+nDyE42y6tHJ80u4JK7IvuFfjfvZRhcAe2ENKrG7edu6DuhwrTA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d893ba53-c78a-4f94-3cf0-08d85f1121ae
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:04:05.9533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HXyD2f/EAlmCFyIzR9lWy5I/nwvagaFSrya/UMc5UrDIkEwyWGRAP3ndJm1maoxyWhvSUqatzZQTvZ4DcjVPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

XTS should not return succes when dealing with block length equal to zero.
This is different than the rest of the skcipher algorithms.

Fixes: 31bb2f0da1b50 ("crypto: caam - check zero-length input")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg.c     |  7 ++++++-
 drivers/crypto/caam/caamalg_qi.c  |  7 ++++++-
 drivers/crypto/caam/caamalg_qi2.c | 14 ++++++++++++--
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a79b26f84169..e72aa3e2e065 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1787,7 +1787,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	u32 *desc;
 	int ret = 0;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 30aceaf325d7..efcc7cb050fc 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1405,7 +1405,12 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 255b818c82b2..4cbd7e834888 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1472,7 +1472,12 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	struct caam_request *caam_req = skcipher_request_ctx(req);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
@@ -1516,7 +1521,12 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct caam_request *caam_req = skcipher_request_ctx(req);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (ctx->fallback && (xts_skcipher_ivsize(req) ||
-- 
2.17.1

