Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80811C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5879022CA1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="aTbsnZQ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHGQWY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:24 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:64918
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbgHGQWW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wq/34hehxj8LUCCirG94yDJY7hSlb/8AM5uH7rPua3Dmp9Uz/jRei2CX4nrucycT020kB/Txx3BEkyeEX/UQwrb3rL1Qg1ZoCtmmnre6k5WY8cPabNY8NL71Pg6KW4EmtEXAaWsdxQsMRZmLKgcpn1TVRabn/fng1WEl5Kl2BVFoIjd9UImxrC65XPeLH3ZjNFVTKTaALAqJf9ymO+b9G/j3qUPwJwxQ1G34ZbWBar40yTGvUwLJy2Bllhs+bbLZWqX44uev6UXxhMjtq8IbQANFuntQfrLHXUI0eSM+g0vEYno281R/4Hm0SV1SFHUyPkkjvnMT6PFK8HEKKNA28g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaNcAWlBrajSgP5CYQnMmX6wqHfPV2gSVIypIKsycZU=;
 b=TyWyhWWObRrh70ffUDdDJZfgfJlRn/PkcW0YBAnfhalfHteNA4TDe9mLN520RprmiOs4hQ7M94ISNPtohpB175Ltq5pN7PfhdJf5sqexsSoCCGoN/fVaHJKLBasdMwWdHTcA334ZXzX6tL9MlxVT20IXlIZkfOJlmblrmuRMWkyGnNftK2EPWZjGLUSjkU4V/jjpJaIILSXmnCoHgy/z7fuSOupRGMwV77Dj6d0/3VMDEI3S6yzpZuiaqFR19bLDrBv9TtubWF16FwrISps+YibYJgl/lb9zFEWhG7t7jPZaIt9Rf2eFMd/RTrTPmerHY9sBPquVK1NdzZ71jj7CWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaNcAWlBrajSgP5CYQnMmX6wqHfPV2gSVIypIKsycZU=;
 b=aTbsnZQ1pPHtraD+ZeG1N/takXbuNjOWSYf2WD5obJD2wESet/e05fTHkdCzlNtttNaicMLOj3CQR+HV99ZPJXQrA0fp2YZDl5fE5a+K04fL7PrtuB+qVgUbZe43J6cKbeqU54BwReUslhcQSJskVsiDc1Q3p5DIVx1SUn4F8cs=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:09 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:09 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Srikanth Jampala <jsrikanth@marvell.com>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH 14/22] crypto: cavium/nitrox - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:20:02 +0300
Message-Id: <20200807162010.18979-15-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:22:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48319828-eeee-450d-084e-08d83aee084f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB735952FBA11927E2DD17DB86B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pxtdA68sFf0CDnh2yxC1XWQeJGMU/0e2vcUjCGc1cE3NZ4k2h2I7Es9mn3Z6S5XFZ85Cu/MPuSm4f6Y+QUHnLaHs7QzxPWO3jVdxofhWuo2GrLxaAM0zYl0O/yI6YbJ/PN7WPu3Bx5Q2QaygGpRiwuxd2/ks6rUsbgXiuGVlenmXT4cuZjEmtHqfaT+REMGJ5gs/L9f2piT08O9NnZE+wbAGiZJ/bOGHHoaCqDoJysh3NLph6hpK8XozLIkn75jWHxF1mA8QKiulEUwF6oRV5UChPm+wnwTzs5n/FgcZLWytWXtppQpkpxXEVJrH+lDLqQfpaGArQKBDRTy/qhA/Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TYh3cA2iImoJjemUFIh4/RQrQtRrMcvIKAOw0MFqn8iku19wFhnfPvI5YUmKnX/QSvVWROEUuECrldd8IyAqm2LQz/z0duSUX3JlPTLtZo8u6EzHsk/JixajIUeZy5aeVeWr2zGaZrkV6Z5olabHT11ILQOo8JQWmU7RC7f6jEY0bARl6poQVdQCilSRyi58EUwUj+DE6WWyw3iAfH4eekql0JqJqjrFbKGQbaHmLf4YD5/myJcYBLiZJbXcK6x2K/B9CC2Fy45FZBFgINEJY5GKipT0lM3G9eOzEbzWLhp8HD57/8tkLSx5iZsKeklt17e30FE7t9aX9m95moxKzPF/lTT6JclNJHO/y0ixuiUclcloW2nB6d66wsgAen0kysB2G30Ug3n/XbbmFLgu33EU+m59HiUhJpr9da/EMn7LGJBVJMuBarKddu0KmkL8K3Jrxvah9mXojYWAV3NO/rlIACSVx45iwOuOwT03NL1c4MCdxJxZ+lkboiDerIsdTrz++rdTBO/6aYxS384CxHaRkEjfNc+mzIYV/MKjFWkBSbljw++HYJWCxwBbQiTh9kQxDjfw9q3zKGLvhcvHkv+32ev7smNQQq5yvM64vIaL1tbbUtN9VBnOLF5SdFzhoOBatGm1qABhyAW0clj+Lw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48319828-eeee-450d-084e-08d83aee084f
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:09.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpghWmS5By+srwfPPmz1Rhw+rh1jjuucxAU8WsxiXTbhN89W3MpA2NyucoTnZlvzRIN33FmS35TpPVkpr/ctQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Srikanth Jampala <jsrikanth@marvell.com>
Cc: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index a553ac65f324..d76589ebe354 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -249,10 +249,16 @@ static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(skreq);
 	struct nitrox_crypto_ctx *nctx = crypto_skcipher_ctx(cipher);
 	struct nitrox_kcrypt_request *nkreq = skcipher_request_ctx(skreq);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	int ivsize = crypto_skcipher_ivsize(cipher);
 	struct se_crypto_request *creq;
+	const char *name;
 	int ret;
 
+	name = crypto_tfm_alg_name(tfm);
+	if (!skreq->cryptlen && flexi_cipher_type(name) == CIPHER_AES_XTS)
+		return 0;
+
 	creq = &nkreq->creq;
 	creq->flags = skreq->base.flags;
 	creq->gfp = (skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-- 
2.17.1

