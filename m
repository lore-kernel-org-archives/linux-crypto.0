Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BEDC76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 11:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D94FF2173B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 11:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="s4ldfVJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfGSLXK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 07:23:10 -0400
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:13698
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727497AbfGSLXK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 07:23:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UG7jLOP3V3OJwqffa07C3gCALF9fIbfOp9iXFDeJ7Krd0Akh+d3kFBvFXRbX6MwdPKFRi+C09z094fz4o0LNydJ7uXu++i8PVG9RxeHm6jV33X67+vQWnpXPivL5FHSLJzza5TMRGhvwHDvTvPk2HJIqNtFAGRAd5LcZO39FXno2naLT9WmAGMOLJF4BOY06k7Ex9c3aqEy6p7MJHjyYCmpOzodWL9rYzMcVt3dHLoka/xcXgR0/pbtzLrAt1+pj0xhh0FM2prJFJhV5BARbFrd1OGAnLWZeLY/Fe3ha2v8rGn6x4qyGT63mhTLLsVZiXRHMU3t0/CatvEjLcbZ68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZjMfVZR9+ut53FZTHcKzragw/myfzsIoVDSFp+Kxbg=;
 b=ccyXMwrAojfmcnh78C3Wq/7mXgSmAZpxArhiBRMSgImZXIDSx4cSsX6T5gVBU0fiDqizitBPDBmdeo79ufz0gTNWAshao23kbv9JJu8fMjbxcnQSHdxEosqnJNPw7VqOPmIWaPXlwacrRPAzauRBvei2tYWUj7olbAV9d6yTdnbpx75loIbomVcdIJ9WYHGpvySNQQM9yDBCmMZgFNM3H6bWcRw9SUcwSgUmXeWl00zMQ87Ic+/n/w7q1Nwfbptvq1FDN03q4eCK27HNxrKPenaQ3ubRFdpdkvHiAWJPJMpSeCZyNux6E0+O+WRjde5kJLKiakKKUGAZT24z/RZX4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZjMfVZR9+ut53FZTHcKzragw/myfzsIoVDSFp+Kxbg=;
 b=s4ldfVJHVjht6BNIagJRENE6jOpOjuRlqtS2ZyDPUcBzXUARNyTaXpT6OO+GJxNMw/ISm7NIMknbfu1u5HejBvZTPDFniEuvsnlnmqC+JawqSe4sJY82//mk/yj9mAVermzNLEP5EHUUtEPhQJ2CluEFg+l/uOZPhAFCbf5vA+0=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB5035.eurprd04.prod.outlook.com (20.176.234.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 11:23:01 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2073.015; Fri, 19 Jul 2019
 11:23:01 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVPiRTTO5nYvxvX0qf2jZsStExEA==
Date:   Fri, 19 Jul 2019 11:23:01 +0000
Message-ID: <20190719111821.21696-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR01CA0105.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::21)
 To DB7PR04MB4620.eurprd04.prod.outlook.com (2603:10a6:5:39::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22dec288-2d65-4140-2ff9-08d70c3b75cc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5035;
x-ms-traffictypediagnostic: DB7PR04MB5035:
x-microsoft-antispam-prvs: <DB7PR04MB50357716E7C4FAF81F90AC318BCB0@DB7PR04MB5035.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(199004)(189003)(66446008)(5660300002)(66476007)(66946007)(44832011)(4326008)(66556008)(6512007)(486006)(6116002)(2351001)(14454004)(102836004)(14444005)(256004)(53936002)(1076003)(3846002)(68736007)(81166006)(8936002)(64756008)(50226002)(316002)(54906003)(2501003)(36756003)(99286004)(305945005)(81156014)(6486002)(6436002)(5640700003)(26005)(478600001)(25786009)(6916009)(8676002)(2906002)(86362001)(2616005)(66066001)(186003)(6506007)(386003)(71190400001)(52116002)(71200400001)(7736002)(476003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5035;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CVW+/m1gkY9/wj7pdF0wGodd2bWxKOpysh7EvxPolp1Q5lBedF3VU9Q4P0/xxCA8VLuKXN4Ie4jEKzYUy6EHgtmAXXYccnT07KiJbIWx7Y8mqzn9vpg2738JNGHhXchBaiKhxYq3TAM5Kiw1vZ8JvVy5+01GoLKr+CjESkegb0TiXhiSvT2zpvE8lJmJrPRtx+suQjUuNtVDKFOCuEoigj4BSyzXeVYSZ6mCFXurzbEcZ6OMeDXBn0w6pLHKL5/nD3JKv1ZotzNlPtZqpgGRQS1gbpotwsmfBUWkGB31BFRQ6dEBw7zkW34+IeZ3hN02d2kYCSsNv2fD6ZHntg68MM86YInZPr3sd5eznUvjKc2w1JOs5eRyymOXKy+jxWNbfWIoesaXrwLPJTd/gJXTflov3weluFyXDSZCgVAdLmQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22dec288-2d65-4140-2ff9-08d70c3b75cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 11:23:01.7652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5035
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support of printing the dpseci frame queue statistics using debugfs.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
 drivers/crypto/caam/Kconfig          | 11 +++++
 drivers/crypto/caam/Makefile         |  1 +
 drivers/crypto/caam/caamalg_qi2.c    |  5 +++
 drivers/crypto/caam/caamalg_qi2.h    |  2 +
 drivers/crypto/caam/dpseci-debugfs.c | 80 ++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/caam/dpseci-debugfs.h | 19 +++++++++
 6 files changed, 118 insertions(+)
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.c
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.h

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 3720ddabb507..383e167e7272 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -168,3 +168,14 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM
=20
 	  To compile this as a module, choose M here: the module
 	  will be called dpaa2_caam.
+
+if CRYPTO_DEV_FSL_DPAA2_CAAM
+
+config CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS
+	depends on DEBUG_FS
+	bool "Enable debugfs support"
+	help
+	  Selecting this will enable printing of various debug information
+          in the DPAA2 CAAM driver.
+
+endif
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 9ab4e81ea21e..e4e9fa481a44 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -30,3 +30,4 @@ endif
 obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) +=3D dpaa2_caam.o
=20
 dpaa2_caam-y    :=3D caamalg_qi2.o dpseci.o
+dpaa2_caam-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS) +=3D dpseci-debugfs=
.o
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamal=
g_qi2.c
index 06bf32c32cbd..a78a36dfa7b9 100644
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
@@ -5098,6 +5099,8 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dps=
eci_dev)
 		goto err_bind;
 	}
=20
+	dpaa2_dpseci_debugfs_init(priv);
+
 	/* register crypto algorithms the device supports */
 	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
 		struct caam_skcipher_alg *t_alg =3D driver_algs + i;
@@ -5265,6 +5268,8 @@ static int __cold dpaa2_caam_remove(struct fsl_mc_dev=
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
index 973f6296bc6f..b450e2a25c1f 100644
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
@@ -64,6 +65,7 @@ struct dpaa2_caam_priv {
 	struct iommu_domain *domain;
=20
 	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;
+	struct dentry *dfs_root;
 };
=20
 /**
diff --git a/drivers/crypto/caam/dpseci-debugfs.c b/drivers/crypto/caam/dps=
eci-debugfs.c
new file mode 100644
index 000000000000..a6b67e4499aa
--- /dev/null
+++ b/drivers/crypto/caam/dpseci-debugfs.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2019 NXP
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include "dpseci-debugfs.h"
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
+	priv->dfs_root =3D debugfs_create_dir(dev_name(priv->dev), NULL);
+
+	debugfs_create_file("fq_stats", 0444, priv->dfs_root, priv,
+			    &dpseci_dbg_fq_ops);
+}
+
+void dpaa2_dpseci_debugfs_exit(struct dpaa2_caam_priv *priv)
+{
+	debugfs_remove_recursive(priv->dfs_root);
+}
diff --git a/drivers/crypto/caam/dpseci-debugfs.h b/drivers/crypto/caam/dps=
eci-debugfs.h
new file mode 100644
index 000000000000..9f90819a7adf
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
+#ifdef CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS
+void dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv);
+void dpaa2_dpseci_debugfs_exit(struct dpaa2_caam_priv *priv);
+#else
+static inline void dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv)=
 {}
+static inline void dpaa2_dpseci_debugfs_exit(struct dpaa2_caam_priv *priv)=
 {}
+#endif /* CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS */
+
+#endif /* DPSECI_DEBUGFS_H */
--=20
2.13.6

