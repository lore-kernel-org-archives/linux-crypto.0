Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EFFC7618F
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 01:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8083021955
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 01:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="evpeTXl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfGWBJb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 21:09:31 -0400
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:7355
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727619AbfGWBJb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 21:09:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h845XCqQ8YbBPUOjdSvvDCehEeBER6nuVQ3F0wLz6EH7zlXo4v5k7vqf1nV1igO26dmZ77q9soAamSEKFQ+35fETAWJtLbxyGs53CnaYRx39y54Zvg3XH/m/D3nXoLN0gz0wTi0gv25MThzu9kd+etvT0UZce6V1AcjsoiFswOH8OYOlr+Wj7s4MDJaLwMq4XJM6qaAz7phZFBqmuj3NHNJar12R3kFNmSQGErPvAMsB13lFgPUZAQv11I0smfV78n5L36HiN7g1x90afxHUYW7NAuhHk6sOO8ExVXJe3nTP7JJG+d8P4g9XnTS/DcjEaQ6H1oGh7pvmDvnQ5X0t1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twW1X+FbV+zkvDbdvEYeTas/pk/vrlLyZM4jdtI0pV4=;
 b=lRJnTYvnwYJkfmIQGr42EhLrmGEpfetrwsqq+F3ob9nqo/3Pf9Sksc8Ti8fQamHFFWNAH+F0hKNAffHquQ/CwISWQXCxU8k41xk6c6PH6C2zMo83U8GkbJg68XoYTFdI14sC7OxpKAQqrxDfh0Tg0RfWSupvAzF91DNvradg0o95jy5KQtMPE/Uc340s0CJqkq84TS3KmyGox5CkeaMave5wGpv5J77/8F+Tv9iEYzlpqzeE5Xz/uvbeCNh5DNIdGFkfS2LtbriNtMlu/s6eRqTdWkxJTwaYxeS64e4bh8MFudt/vEyKMWeyQdauz8S1B/5jaCr6mvN2Nf5l9TQhhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twW1X+FbV+zkvDbdvEYeTas/pk/vrlLyZM4jdtI0pV4=;
 b=evpeTXl1N+U5W9WgQ48J5RQSOrnvwIvZ/nEnQQP7XtChT3PfGr2f5ZEJeHhklzaIH/kwisHLq1MmNLGqq10dloZG8jRKtoCbmYGB9/7ebINILM1m3F7bUlLjQd0656OAT2t2sdLaRe97BHCFUUcMnztifL4LIeOJnsdVR4f+hRg=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4171.eurprd04.prod.outlook.com (52.135.130.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 01:09:27 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 01:09:27 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v3] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v3] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVQPNFiUhxEGdNN0KQge8kyFpioA==
Date:   Tue, 23 Jul 2019 01:09:27 +0000
Message-ID: <20190723010445.2990-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To DB7PR04MB4620.eurprd04.prod.outlook.com
 (2603:10a6:5:39::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96234543-76f4-4d9b-f0a7-08d70f0a6838
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4171;
x-ms-traffictypediagnostic: DB7PR04MB4171:
x-microsoft-antispam-prvs: <DB7PR04MB4171B2E14B2BCCCBEEBEEDFF8BC70@DB7PR04MB4171.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(66556008)(66476007)(66946007)(2501003)(1076003)(64756008)(25786009)(66446008)(256004)(14444005)(2906002)(6486002)(7736002)(305945005)(5660300002)(86362001)(71190400001)(71200400001)(6512007)(81156014)(6436002)(81166006)(14454004)(99286004)(2351001)(6916009)(386003)(66066001)(102836004)(486006)(26005)(8676002)(8936002)(316002)(68736007)(3846002)(36756003)(2616005)(478600001)(476003)(44832011)(6116002)(54906003)(186003)(50226002)(6506007)(5640700003)(53936002)(52116002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4171;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uFN+Ps/aaNDXRcg8vKx3DX4v8kHbFwbH4djquTsBRy05XsHwNZieIdOlZ/Y+KvfTrc+Q3BNQ9y2MX9hyImgQUkXQQARWUXk0Z6lAymPwoUfU5xXRhxkZXejq0vGmljMeUTPgm9y0onPecCeZ7ujYNpG9/dQrHWTYUQ2Sz8xHTWyQTxNLzX4rZRnutVvtGU5mmOBSoebQSzUoBXa0TD2fbL1Us7+me45hgEnscbWtfEuOsr4TRnAhvVvqOVEO6xaK7DewDU0nbdZbVTYGnwAkAQMvk+h2pFa9J1BsDvvTI77LmpIEL6SlOabPTcl5gNyya4Rj0eTnq82fD01+FIO/jV5yvxPBE5HrMI67D+Y2Oj9eihsaqzMoxDkKBYa7Jgclm6/SlXMxE2SUZtHPJ7YZyYfEhDJtAK7uG87k9GqxKkY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96234543-76f4-4d9b-f0a7-08d70f0a6838
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 01:09:27.1024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4171
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support of printing the dpseci frame queue statistics using debugfs.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---

Changes v2 -> v3
	- Removed CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS
	- Moved var 'dfs_root' out of structure 'dpaa2_caam_priv'.

 drivers/crypto/caam/Makefile         |  1 +
 drivers/crypto/caam/caamalg_qi2.c    |  5 +++
 drivers/crypto/caam/caamalg_qi2.h    |  1 +
 drivers/crypto/caam/dpseci-debugfs.c | 82 ++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/caam/dpseci-debugfs.h | 19 +++++++++
 5 files changed, 108 insertions(+)
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.c
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.h

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index c7b8c537ebfa..af5f64cb5e47 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -31,3 +31,4 @@ endif
 obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) +=3D dpaa2_caam.o
=20
 dpaa2_caam-y    :=3D caamalg_qi2.o dpseci.o
+dpaa2_caam-$(CONFIG_DEBUG_FS) +=3D dpseci-debugfs.o
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamal=
g_qi2.c
index c7dad3c139e4..364206c99e6a 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -15,6 +15,7 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include "caamhash_desc.h"
+#include "dpseci-debugfs.h"
 #include <linux/fsl/mc.h>
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
@@ -5479,6 +5480,8 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dps=
eci_dev)
 		goto err_bind;
 	}
=20
+	dpaa2_dpseci_debugfs_init(priv);
+
 	/* register crypto algorithms the device supports */
 	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
 		struct caam_skcipher_alg *t_alg =3D driver_algs + i;
@@ -5646,6 +5649,8 @@ static int __cold dpaa2_caam_remove(struct fsl_mc_dev=
ice *ls_dev)
 	dev =3D &ls_dev->dev;
 	priv =3D dev_get_drvdata(dev);
=20
+	dpaa2_dpseci_debugfs_exit(priv);
+
 	for (i =3D 0; i < ARRAY_SIZE(driver_aeads); i++) {
 		struct caam_aead_alg *t_alg =3D driver_aeads + i;
=20
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamal=
g_qi2.h
index 8646a7883c63..486bdaa00027 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -10,6 +10,7 @@
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
 #include <linux/threads.h>
+#include <linux/netdevice.h>
 #include "dpseci.h"
 #include "desc_constr.h"
=20
diff --git a/drivers/crypto/caam/dpseci-debugfs.c b/drivers/crypto/caam/dps=
eci-debugfs.c
new file mode 100644
index 000000000000..5a81e85f0b7e
--- /dev/null
+++ b/drivers/crypto/caam/dpseci-debugfs.c
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include "dpseci-debugfs.h"
+
+static struct dentry *dfs_root;
+
+static int dpseci_dbg_fqs_show(struct seq_file *file, void *offset)
+{
+	struct dpaa2_caam_priv *priv =3D (struct dpaa2_caam_priv *)file->private;
+	u32 fqid, fcnt, bcnt;
+	int i, err;
+
+	seq_printf(file, "FQ stats for %s:\n", dev_name(priv->dev));
+	seq_printf(file, "%s%16s%16s\n",
+		   "Rx-VFQID",
+		   "Pending frames",
+		   "Pending bytes");
+
+	for (i =3D 0; i <  priv->num_pairs; i++) {
+		fqid =3D priv->rx_queue_attr[i].fqid;
+		err =3D dpaa2_io_query_fq_count(NULL, fqid, &fcnt, &bcnt);
+		if (err)
+			continue;
+
+		seq_printf(file, "%5d%16u%16u\n", fqid, fcnt, bcnt);
+	}
+
+	seq_printf(file, "%s%16s%16s\n",
+		   "Tx-VFQID",
+		   "Pending frames",
+		   "Pending bytes");
+
+	for (i =3D 0; i <  priv->num_pairs; i++) {
+		fqid =3D priv->tx_queue_attr[i].fqid;
+		err =3D dpaa2_io_query_fq_count(NULL, fqid, &fcnt, &bcnt);
+		if (err)
+			continue;
+
+		seq_printf(file, "%5d%16u%16u\n", fqid, fcnt, bcnt);
+	}
+
+	return 0;
+}
+
+static int dpseci_dbg_fqs_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct dpaa2_caam_priv *priv;
+
+	priv =3D (struct dpaa2_caam_priv *)inode->i_private;
+
+	err =3D single_open(file, dpseci_dbg_fqs_show, priv);
+	if (err < 0)
+		dev_err(priv->dev, "single_open() failed\n");
+
+	return err;
+}
+
+static const struct file_operations dpseci_dbg_fq_ops =3D {
+	.open =3D dpseci_dbg_fqs_open,
+	.read =3D seq_read,
+	.llseek =3D seq_lseek,
+	.release =3D single_release,
+};
+
+void dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv)
+{
+	dfs_root =3D debugfs_create_dir(dev_name(priv->dev), NULL);
+
+	debugfs_create_file("fq_stats", 0444, dfs_root, priv,
+			    &dpseci_dbg_fq_ops);
+}
+
+void dpaa2_dpseci_debugfs_exit(struct dpaa2_caam_priv *priv)
+{
+	debugfs_remove_recursive(dfs_root);
+}
diff --git a/drivers/crypto/caam/dpseci-debugfs.h b/drivers/crypto/caam/dps=
eci-debugfs.h
new file mode 100644
index 000000000000..1dbdb2587758
--- /dev/null
+++ b/drivers/crypto/caam/dpseci-debugfs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP
+ */
+
+#ifndef DPSECI_DEBUGFS_H
+#define DPSECI_DEBUGFS_H
+
+#include <linux/dcache.h>
+#include "caamalg_qi2.h"
+
+#ifdef CONFIG_DEBUG_FS
+void dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv);
+void dpaa2_dpseci_debugfs_exit(struct dpaa2_caam_priv *priv);
+#else
+static inline void dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv)=
 {}
+static inline void dpaa2_dpseci_debugfs_exit(struct dpaa2_caam_priv *priv)=
 {}
+#endif /* CONFIG_DEBUG_FS */
+
+#endif /* DPSECI_DEBUGFS_H */
--=20
2.13.6

