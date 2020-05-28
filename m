Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8567C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 11:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B993F207F5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 11:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="bQ5S1q6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388043AbgE1LFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 07:05:25 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:16992
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388148AbgE1LFX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 07:05:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hd6KrV3o/S4K59MykVlVyNLP1Q1Bn7y93eATP7yTFPVKA7vcfEQbtIjk/XgQ3iMkQqHdADx+/HCIrNZ/rZzgLb53GdrZUxv3FnjIaAMA3I6RSREKyTPMC9BSbpC2VeeUV8IHO5Q0fIUZUcz77Sjl5iMxtxYku1/hy69J1bYyKKgcJP1/peyEyWVX6QmNjkR3JNtZYDtLN96jOpkkluVnRDwUIXeIKPYfxiVrTiWg7tygOHWXZVHYkqO+3vCUXCCu4lWtk2viu1gVWSEgNan7BW2czMwgy7B/MTvpN1ReXebd5D3WWSQnuGiqObrd+orNDtXQm9ZvGYhSscHU7pCMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vx7BcKxHLeLCO54ROpM0unFeU4Yc4w0UNGQHCZyTWI8=;
 b=Hlux+/64+BtSCG2WI93mKK3yTJE99uF/yrCikLz6qLJ/MQTwYyB5QG0LfZMKKk+S9+28zwNHwEHWyWiyF8MUU8Y8aj2ig2C8H6flqzIFH2g8HaL0CUyQso80qsy8pnaKZq/FsVnSwK9fH1UArC2AhoX//hDK95gwhIRopEeTabJ+iCjw/JJo5raXVhyea9ognyudaATr1sUtpQVDU1SYN5re1eXH0riWAHm8wSJVibtP2VkqD+8bnIlToZ51E7QwbYDI9/nN+X7KCHd/UXnMXH9htvpanx4MeUTpbgaHRquyONyvJFkj+Ewxx7r9FPG3kW7EW3ckX9+0bbfWi3fExA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vx7BcKxHLeLCO54ROpM0unFeU4Yc4w0UNGQHCZyTWI8=;
 b=bQ5S1q6SC/rzo6I2Vvfeqln/lnDQVl3mZ5GtrfAnYmwyUZfhhbYc04TTdIdbRRtLoAkC75hhN04DzrvDAt1/l7GlKM3JC5dWF26IOUFMU/GyXUIU9MCPNYHHJruGPYG/DzVQX6dwh1GhvUBVEu6y3eS1RQLQHL2UiWAM6WpVwJM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB6558.eurprd04.prod.outlook.com (2603:10a6:803:11b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Thu, 28 May
 2020 11:05:18 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::282c:7a7:6583:903b]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::282c:7a7:6583:903b%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 11:05:18 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam/qi2 - add support for dpseci_reset()
Date:   Thu, 28 May 2020 14:04:50 +0300
Message-Id: <20200528110450.11279-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::49) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0101CA0081.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 11:05:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 54e79a73-b42f-4668-2f4a-08d802f701c4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6558:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB65584BC87C8E091259D74330B48E0@VE1PR04MB6558.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDolNckV1U+6LSIaYqHAVtfXC83FDYGMLPC6lE6Ajpp3P5GRWKkIzab6bQ3WRDR+TUH19LPfc3eL+CZPRDI8OY8kqr7P8HvZIoJXbg6gFOp+ShXr3WIcCnWulmLyughFlzYW35M/y/4DIXgbRwgPrqLQwxxE6kckv0oVdaH2zlJUS0fmlXbVkhQdwa8SVcF4Mf0HqNos/KZDc09A/6ghg8o7lqupL+W+eGxaAzdw70VBt+tebsILSEbr8tEwMo4iycPhrRL+dywd1rEHzOfNBljFpwBFknkk4xn5iuiMWJlyobVOrDfVUH2hgFvUFM7M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(44832011)(66556008)(66476007)(6666004)(4326008)(86362001)(2906002)(83380400001)(6486002)(316002)(6512007)(1076003)(66946007)(8936002)(110136005)(5660300002)(26005)(478600001)(52116002)(6506007)(16526019)(956004)(8676002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dedseuTg+Kf44Y7FSvtBi5djQu2MHpjx5+wZEUaQ/uFfqtkyGaGLSMducd8fvW9kz483BFaX6S+k4YjD2bM3t+m+KguHBD6Q8wxVO8/f7cEgAALYFttvJhrBxWSmJOHkyblbjEnpZ/BDRHg26tVhuF/32gi1xhiJ1hs8ROqLx9stfyfTma4t56kNj6PBJe97txsNlaafkWjBgBouRQub8Hmum1MtNykkNs4xlY5yuLlOxIXD5pvBlIiABPENfDjQvxSsc5sgOD+4SO7DbT6vnubq2U1FVRK5LOG5WXgmnNsgbfTZr+EnCTQqRoZclLMLm2tPGYf+IDNIUNqFW7wVK/lTp/nILH84+3ztE2YeGWrDTFkxV0G3/fuZO5xCKn6k/3l89Nw1tXNgCYg3iqFdEnFToB3+LoCovJt93g+3xMthFQk3m+2HY1z9c21kYOrtRhp7UCm3QIIXvNOThQDjrX/S/xYavGVQK8JSnTrmDfo=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e79a73-b42f-4668-2f4a-08d802f701c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 11:05:18.4176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roMIyF3BC6g6LSmeeWcijuQzwaAb1h/TkpThYKBHg8SG/AXblPPw4Ra254Gl2YpLnRlPLk1QgqEOPxWG7KuhBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6558
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Add support for dpseci_reset() command for DPSECI objects.
For DPSECI DPAA2 objects with version lower than v5.4 reset command
was broken in MC f/w.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 11 +++++++++++
 drivers/crypto/caam/dpseci.c      | 18 ++++++++++++++++++
 drivers/crypto/caam/dpseci.h      |  2 ++
 drivers/crypto/caam/dpseci_cmd.h  |  1 +
 4 files changed, 32 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 28669cbecf77..ed52f0f4fb2c 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4698,6 +4698,9 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 	struct device *dev = priv->dev;
 	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
 
+	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3))
+		dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
+
 	dpaa2_dpseci_congestion_free(priv);
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 }
@@ -4894,6 +4897,14 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 
 	dev_info(dev, "dpseci v%d.%d\n", priv->major_ver, priv->minor_ver);
 
+	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
+		err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
+		if (err) {
+			dev_err(dev, "dpseci_reset() failed\n");
+			goto err_get_vers;
+		}
+	}
+
 	err = dpseci_get_attributes(priv->mc_io, 0, ls_dev->mc_handle,
 				    &priv->dpseci_attr);
 	if (err) {
diff --git a/drivers/crypto/caam/dpseci.c b/drivers/crypto/caam/dpseci.c
index 8a68531ded0b..039df6c5790c 100644
--- a/drivers/crypto/caam/dpseci.c
+++ b/drivers/crypto/caam/dpseci.c
@@ -103,6 +103,24 @@ int dpseci_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpseci_reset() - Reset the DPSECI, returns the object to initial state
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSECI object
+ *
+ * Return:	'0' on success, error code otherwise
+ */
+int dpseci_reset(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSECI_CMDID_RESET,
+					  cmd_flags,
+					  token);
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpseci_is_enabled() - Check if the DPSECI is enabled.
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/crypto/caam/dpseci.h b/drivers/crypto/caam/dpseci.h
index 4550e134d166..6dcd9be8144b 100644
--- a/drivers/crypto/caam/dpseci.h
+++ b/drivers/crypto/caam/dpseci.h
@@ -59,6 +59,8 @@ int dpseci_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
 
 int dpseci_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
 
+int dpseci_reset(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
+
 int dpseci_is_enabled(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		      int *en);
 
diff --git a/drivers/crypto/caam/dpseci_cmd.h b/drivers/crypto/caam/dpseci_cmd.h
index 6ab77ead6e3d..71a007c85adb 100644
--- a/drivers/crypto/caam/dpseci_cmd.h
+++ b/drivers/crypto/caam/dpseci_cmd.h
@@ -33,6 +33,7 @@
 #define DPSECI_CMDID_ENABLE				DPSECI_CMD_V1(0x002)
 #define DPSECI_CMDID_DISABLE				DPSECI_CMD_V1(0x003)
 #define DPSECI_CMDID_GET_ATTR				DPSECI_CMD_V1(0x004)
+#define DPSECI_CMDID_RESET				DPSECI_CMD_V1(0x005)
 #define DPSECI_CMDID_IS_ENABLED				DPSECI_CMD_V1(0x006)
 
 #define DPSECI_CMDID_SET_RX_QUEUE			DPSECI_CMD_V1(0x194)
-- 
2.17.1

