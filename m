Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B70C43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E633B20874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="BH6EGFKy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIUHcy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:54 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726503AbgIUHcs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWe1PGP31Bnd9MZJQAzwf1p3B2aqrHgGTD//8vu3hMsgvIyvCtpc9cXFsfOOIBGiz+zxzG3ZFLDCqR3WOJFo6qjnPbc+iBW/0P4o/gcxNmorshyXZW5KjL3+mkD4hjxDf2pW7hW/kTmaUNzvOFQLa66VyN+yIbNKuBsDYnzSY30xSH/zHkSA3gu0MFsYn6lBseIfe0x6vy0YO3/joGdUi2oy/mtjCs5N0sFOx59uwjr0SBkbdFvTOsivcGMqnRajOOcMT9dfFgJOXtumV2KCwqwlmmav2VQtHaG8yrKU3mgFyr0ZbZbaIIV+m4EyRnTR4+692jI7hRi4oEp2RSoHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS1yV9os3Ty8N468x7XG1hAh3a47TnEB83v8a6v6KsQ=;
 b=oQeV1LWIv1sbnvdA85XPhQRgcut6VhSHF9tlRecxmT9tZVNzSoxgrRSPvlIWmTAyU4OYtO8VBugegVB6rkqWczMTxuX4kvPsBxNPBAM6ZCZSyYAycoZER/kZMyQhNjJyTDjMyT7ANWzDWys62dSaOdW/CUnp/IJ35JNtkSjiGSOk7FgK1DtWnnxW8KmXVhU/E9nTwO1NSLVIuCBpH0hLxtXIII+hFF4EOdDQoiW5v3TlhsGZQqaBw2hUmxKRV+2xBFkmV5gIp3hMmLeHgP3sauucWPx3HlzJwe6nmeVNWSYEnA4NE3LHzhohVtS8d6DwtNB4RgdaIXBxH7zzVuLfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS1yV9os3Ty8N468x7XG1hAh3a47TnEB83v8a6v6KsQ=;
 b=BH6EGFKyUEHpzXehtqynoTLfuDhU2CaXCclOSIHAHWEb03Jhg8nKOS+jEXKq9/WmW9jtONKT6U2504MCkMXsXX1oZmbM6/ydeoV1zlgBKK0LB+SYwNcGE+pxFIiom3C/iQa3EqyuqRpb735kQayTxOnnU5o7qz7Q1rlIs6SQTuw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:31 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:31 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/12] crypto: caam/qi2 - add xts check for block length equal to zero
Date:   Mon, 21 Sep 2020 10:32:02 +0300
Message-Id: <20200921073205.24742-10-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f287febb-7e84-498e-c9de-08d85e007fd1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3903CC30CBCD89D003E10F33B43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pep1j9F9s7aVVduWrjVvC+CJcs8ptO8pvIflB66FYdNTTjUGEq7AeRfACGXadMtDI6ITGsNhKfvLi+vRpzk878QNkUQ6A8nCp/5p1LL52pzOVnS0aq9PWcIv6BjtVzcasSwUwG70ZCYgzzWO98GvqND9tCh9VWI8fO925DKQE/fPJpO736vsZ1utOGXCgo9h3J+Tw3LKxlOGKabv5SzbVNt91LEeZtNyHUx3MjU/KZrukY62np3ymlmE6OkqALVU6Fc/gtXm3WOIOxkK3XwgHAbcoouKcLp+MScrX9tWN+dLogDwQyd5/oEEqpLWtgzAYdaIqQx64uODwFzG5utTkaSxSG2fVrzdcq288fjCRoTol0pQuOH2+gExduzYu8ug
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jBzKk+2Fw0fwHAWxxYxGB11lQR7O656RJuCyPeDLX5kKEBfQOkPsTwHfdMukrMnMkPmiTCZBtvEKKnU8PxbtcEAOOHxS3e2QE77chmEmVBG2dvY4RRe4KAh5jv6iKsfeX0V4zMyGVkRXt2D1wYmTm+mJLgonRzWbj5RmrbaUtzBxGhYr7Fo9ltqiH8AVTTHoiTtVct4QsC6iE//8C44Rz4TCa/dRa68ks0t1D6gxppk4SIAMavgcpA+0lXlnc5LtlBGuZ0Ehm4rp7hBC9hdnYeiqYBSBhGBG3yJoFumPyCeK65UjhhmMVtoU5WK8zrvxXXlNZFNe21RF6Y1kjFgJOxSuIabMBm2pCx6dvBxc2yhx8slZblmFTSpniTuivIXM1x7T3razto4aBwS8FkgfNEif7EAhSujuS0+NIskzQSIBnnyv3UWV+sPV0DMIEe8SoWPnkqF2y3y3jPV3hd/KI0giqx6Wyyj0D476ursOCKSRI35TT48kRhH1EpcI8phfDvXfbXLJueC74YCMo3BiOhOaIdTbVTHhxxFMWmlMiCpsvaDmPk+OmYimCeyKkNwmpeJYKxdtLorCDkXhgDIZHFHWsXIYPpfQodnXLDuV0oRreBwrd6DtA46+KtqTJ/5Cu520LXsmiWLwyOx4/zMUBg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f287febb-7e84-498e-c9de-08d85e007fd1
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:31.2320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djDOvyHv8+1054BuhlPVLLeQCKrf+fBn/jb+XCsz1glUmSZZBCVdwqgsiGNSI1eKUGtq7gH1FoT3/tgHzJ94mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
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
 drivers/crypto/caam/caamalg_qi2.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 5d2e554774c9..592f4a0344ff 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1475,7 +1475,12 @@ static int skcipher_encrypt(struct skcipher_request *req)
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
@@ -1519,7 +1524,12 @@ static int skcipher_decrypt(struct skcipher_request *req)
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

