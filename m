Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EC6C433E3
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9064A22CF8
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="gd6IPzId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHGQWT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:19 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbgHGQWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqOigEwgpG0rYl3UnxtkqMWeWQwTW/C8qUALHW0Vx1mfUEVFbSnxu34qxFOUnN+j6vVkxdnsfifqgPMSeVQdRQk+PgAK6tUgTrMLt+jJbD3XEImKyklNiTJYPNHB2K2hhDHbh7Uv+FSYeC5hW9NpE/4qLHegT941eWKnJybpwnCgzER3aCTA9gtIUFlAapKZuYytN+3l9TeRbwmsYAssf4YwwAPFZPYgviNUrNJGcPpoaHTttD2Ra7dPcVgX2Qckp5JH7a4xblxXRz9FgJm+xtBhchFEFOrqF33qs6oL7jgm9NQzGumoXZSWQkNJvwTgddurVOfdP6W2k/xNcio90w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKUbz7IwokmTEaHfqLuPQ6Re62bDmfVBxGj27TTbExw=;
 b=IaGqoReGCJJV5rl3+yiwFX8W6/MOIjwJePJh7HRh6ZenRMfm2yxIF+xTNRme92tZcQYUeVfcU46JB9gMf/o4tkuMvlLgB+CKFjdRIoqvrNhoLELTl8m5/qomk8EUYcKUrOi2iJvKAHBlnyjgSTEiWedTPoIoz4RHhZ7xBJWQPRGyFQy16eDLOQ5iWJ3+Goy6nXk4Gw5V1pv0RaLvDQQrUj7dhX8+IWDg6hUBD2rCYoN3HoV1NFE6MBbYg9JUl/slH5CLyqoGqlBoDskg8xq19e7Z+2y1J3nB+5NLpJf83Ri7962o2WbbO5QN+bb5ZBYomDGP1NOoa2Z0O6DIc+u4Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKUbz7IwokmTEaHfqLuPQ6Re62bDmfVBxGj27TTbExw=;
 b=gd6IPzId1uxHzMNgmsFcKJNDjlomAVSTW3dcjFz0lF1SBG0UuLxpAwNGtdHLUQyd5nlIQXZzk03VNA1bqyPPTMR8mhY/LLXMH1PhjKx3pZUYPKwK6a5T0rY6P2B4ZHcN2dYg5iLq8oAzPmcnn1whe/BlivMaWAKduRcMvGypPoE=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:02 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:02 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>
Subject: [PATCH 11/22] crypto: artpec6 - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:59 +0300
Message-Id: <20200807162010.18979-12-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:22:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9736d86e-1695-47ec-dbad-08d83aee0467
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB735946FFCB51EAD3597945DAB4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUTiw1FsFK5h8IO1jarwWN92L+W80dIsWjCYtxjGRz0X0CuvLOHEme7vCBYuSwnkl9rVlj1R3Ks61YYiTogtkiCqMFRZTvEBEIgINvPgZ9HrWcI+fhkzmMDZRdTMLp1OnZJla9iogD7OJ92D8SbPk64Qe0WaUW9kttIMtaFScWEg8XiUPqyTTheamehHykSa9bKzIpbUzIag6gwfxUn58i50XOutCq8dpN8ej9JCqjM5C6zXqFG3GyQG1zM6FlMvFAF9cu+17prDzpTPK+OZZlVlNmnW7kTscz9eaVfiHZABq9iiY6Ov9lbiLEohmw9Pi48RwxQEToSsdef1zre17Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G6hI3qlLow7u3mB3XZA+7xFn5wI3dQwrMA8ZEMNV7+oC8Gf75ZQxCQLYetBdz9bDaGJPlN8PZly0H8plS+gwFlY1M/7q6qabZEn54celwp/rsqOOQSswYINdvPIXU0K53KbWu5v9tm93dWRA2sA4fxdLvTieU+jzIyngvdnyZsKG6Dj50uvn/yideCzlYp16lob1jruXku/mNgSBsmclE892KG17USdBjDL+h7blIN0z0RWAtlU01U8yRrn/61YbtrH5ZXokU+PoDWC/u8OnTwEN2F/d7vqSn+GBMM9i/WfY6uBGBPiY4HePx9w2TB1BKWf6CrPGy+kL8egG3vRJxAyNRw7pQl57bly8TUCZffjSGK6pWhRxaIURdUl8MjuPsiFAH9+fyJ9Ek60KAX45l/BfgUISgOKyTjWrv1KSaPysYzxPeQfmed0BpbxinfmP/T4jjJY0mFxJJ7rSPgZcCCpWy4LTkmL1XlO1Xcy5Sh0HvPlD02L30uC5NtV7yU8pO6gFnf7mdiEQAXpbPtXoaQItE6359Swn9ke8scKltWZ/pCU2CTEqXQVNyG91MjDoT4W5q4FFN7tpgqCRpji0/bB4qPTz+DX8wqUFUpbXFNVElbNVi/A1UFftRhddSWdtPnkkBJHthV4Zjvixmb1uDA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9736d86e-1695-47ec-dbad-08d83aee0467
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:02.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltQA+Aleb/fZ10gSG4RH2omcYxmBBjuR40NT49MsUI5l3yKmWaDLanAHV40uSD9Pqwl7T37fq0bPcmJsLUSzXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 1a46eeddf082..243880c97629 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1090,6 +1090,9 @@ static int artpec6_crypto_encrypt(struct skcipher_request *req)
 	void (*complete)(struct crypto_async_request *req);
 	int ret;
 
+	if (!req->cryptlen)
+		return 0;
+
 	req_ctx = skcipher_request_ctx(req);
 
 	switch (ctx->crypto_type) {
@@ -1135,6 +1138,9 @@ static int artpec6_crypto_decrypt(struct skcipher_request *req)
 	struct artpec6_crypto_request_context *req_ctx = NULL;
 	void (*complete)(struct crypto_async_request *req);
 
+	if (!req->cryptlen)
+		return 0;
+
 	req_ctx = skcipher_request_ctx(req);
 
 	switch (ctx->crypto_type) {
-- 
2.17.1

