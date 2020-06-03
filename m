Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF7DC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 08:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 353B420674
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 08:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Qv8dDTxr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgFCIrx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 04:47:53 -0400
Received: from mail-eopbgr00069.outbound.protection.outlook.com ([40.107.0.69]:4580
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbgFCIrx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 04:47:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGnCA07kO80IOJ7Fut324LNuU8m3xBCOHzjVkyHy+fS7dhr1wUEr9b6mHAEmaKvdrs64/rKPZw6A1jciGfMmoxkxAdI+NHwfn59QXX8llj5+wlensj2M6mB+Sl0C+aE7z+duKXjuD15JsCSoTxreMnk45RStu/CbrR/nWTwbCS2/rs0BfkK1p9mamCjhgMGjKIUwXRA2pKa8jsiAgIcZCgG/R9aSJjjkO8K6GOufMRtbufoXViJX0ee54w2X5/d+6h4lr0AzwWEUtLYiq6sJNvPMWquAcVBHdnP5SsXzPjsl50kSg3Kiwl9ZWHs8MivLZpzhMK/D+6fcbyh2FnxDeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8oD6OfFbid7QuysL1f+Awyww+09nTWcETqpTLRYgS8=;
 b=Ps6l+kiW9C2Hkl1wcZH/0IF/2LoBqu3137O1cph1CJz84Hu94LBiSWiYCPTiu3qWXCNlF3pCAG6/ANtDifnv5OJIu8Cf7Qet1sq8toqnlK/sd4WfN5yFwERjVY/ClmK5RWCmD6SutC/VBcylGPboigcLuijJM+pPk3Kcf7MSa0EkfWsNn+hbYUuahz6D7hTs5a0dARqBiR3DPaoZdkaH5T98tDdfI71jw7m9FLT87rnGDQW7pZjses7Z5kgDyaR9aYk3ecmjjyc1wGIY2k2YvdzkGSkuQkLdNII3HOGAtNtqoxE+5G/kGGV0L5lBBSmzLE7IT4n3a0sSHLieQ82SEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8oD6OfFbid7QuysL1f+Awyww+09nTWcETqpTLRYgS8=;
 b=Qv8dDTxrJ6q7L3GCB+sSGQGipdkYKHMQj248v4bwBQSaPVwhp3HQ5bxTUVIwb16AnsUrSKUecqVM6p1v9WfazFncY3juepIFrHvm6OC2CD9eoKb87xPb9zEeEQB/mB2Eu5DjN+Xh+uJOsw04eG7SO+RLZpKQQVSBBxzrJ76L6fY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB6542.eurprd04.prod.outlook.com (2603:10a6:803:123::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Wed, 3 Jun
 2020 08:47:49 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::282c:7a7:6583:903b]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::282c:7a7:6583:903b%7]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 08:47:49 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: caam/qi2 - add support for dpseci_reset()
Date:   Wed,  3 Jun 2020 11:47:04 +0300
Message-Id: <20200603084704.5895-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0121.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::26) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0121.eurprd06.prod.outlook.com (2603:10a6:208:ab::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 08:47:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eddf6449-c6fe-4c99-8aaf-08d8079acb74
X-MS-TrafficTypeDiagnostic: VE1PR04MB6542:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB65425FBD59938F90310F28EDB4880@VE1PR04MB6542.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWilhAmng8OgfEADs9sI7mIFYr+LPejafXC+fFfnHp8yqiAc8id/VwsXWE7yUAcNGnaXloQtO2iD3BzLbJgLaWQJEgXGa3Ejvm7htRyY7xn2IrkLM4B1bzsWTlmHLoCgyUjN3WC+EE49KxNQdIatywCUGREVOii2JrkNeZnOvLRYkfM2XfobCMRim/A5RTkq68Jv5NPYJIvjyQmtlsua3bfTdUtfEa4ugjn3szHb1SpN4ujNtOS7RLNGwL6TiiLtcTVq2ryO6zIE5qCPXTNGUW0iXqor0cqCmRVeU88CMPGHA3ferInaAX1dRMW3iF1D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(6666004)(66556008)(52116002)(66476007)(6512007)(1076003)(66946007)(110136005)(8936002)(83380400001)(86362001)(2616005)(316002)(26005)(8676002)(5660300002)(478600001)(44832011)(956004)(186003)(4326008)(16526019)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x/BLfplBIDpJYiciarxSLpa5kDkxgcAp33dvAO6XxmTkXBBL5YcMOvdlnJ+qUguuU00P6qlyu9p3nlUHlHaLIB9eWJeavmoHMUqVyiL8LvpKHBqu+frolaiYTqCMuHe67L0fJ7Aq0bj5rGrOZ1Y6RvMrzN9EhE/tXp0C4Z8OQPbOQv31/528uLranq16UtWyedrBba9GE/pw8ipNoPulp0uzZ1NwT8/7ZqExp7aKXDpyktejwI7KAnYx2Mico4WDMDn44EBBTHQi62HkUli5jRhSHLcM4bPNMBveVbFTlWdJrZrEVgQjz5o/VqinpOy0KpXMVHJu2wgdU9q+zpf2Y1cjqAxBPo/6lgMt0kuCo4XnjDemqRyB+P86sdeHFZhxiKtBkS8xop4sj/jC68yr9MwDiSjZQMkYq+RtQWqK9OvoIogozpME7FQjO7mtV+DnTs0nnDTXYitv25eCnlkhLtD658YHbGBGz28P7mCJBkE=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eddf6449-c6fe-4c99-8aaf-08d8079acb74
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 08:47:49.4424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4T3LXva6wn4B8akHtoeAEfMfP+oyoI2p8l25ujhQ3+1t1CigySculRXh7ThNLzck4euvjMmEt5MyY0YFWvgpNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6542
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
Changes since V1:
- added, in dpaa2_dpseci_free function an error message in case dpseci_reset() fails.

 drivers/crypto/caam/caamalg_qi2.c | 15 +++++++++++++++
 drivers/crypto/caam/dpseci.c      | 18 ++++++++++++++++++
 drivers/crypto/caam/dpseci.h      |  2 ++
 drivers/crypto/caam/dpseci_cmd.h  |  1 +
 4 files changed, 36 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 28669cbecf77..35fbb3a74cb4 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4697,6 +4697,13 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 {
 	struct device *dev = priv->dev;
 	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
+	int err;
+
+	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
+		err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
+		if (err)
+			dev_err(dev, "dpseci_reset() failed\n");
+	}
 
 	dpaa2_dpseci_congestion_free(priv);
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
@@ -4894,6 +4901,14 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 
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

