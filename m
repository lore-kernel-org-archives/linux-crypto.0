Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD19C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 08:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5472239E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 08:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lj9mZELt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfGWImv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 04:42:51 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:38207
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727627AbfGWImv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 04:42:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6GlCH0FCy4idTP7vnoIK6q6B9pe6PFxnst/y8k7gxmzztfGy8N/q1lsl9qZtDP0CEWsFBsaRQL/sB9EAfHv0tk+qonuz7Samfo4Jmz2zyr9Mor/1l0s/dny7oerdbQ9YFy6NfC5cpEsXOYtKzPn4MCZHYiNzGtsqxaDoTb15EsNIjhdYNBHcpfFf8SvEZbMDPthZjaCXQ0Q9WPQfxGKZkfPPNre5ntniEn/tjSYJJmfzN0sBP04pgkrI8GpyxP75+tUwI7/08at/+E5xoys3f61zTbf59UaeuXZE2gF7aMjTFQSNlvsS6VAHdMfUq8Sg3+K9aOVpH73NRD9LD0IQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA/MEJg33ENx8z5OREE+p4EMMrxoESHgtWCPYKFIL+c=;
 b=GAkcelcT/AxQULHp90B3IwwN0sX5PEBGIfvNSO0FbaGC2B/XT9RVsEYzdF0O+LiaYsEINE0+M+IGzYUM1urXxHeUEeDkaBiEDjJNWqmaNVnIsxSyNLKimZSBo1C8etyJ2Lb+kh0UrygKCPSctGXRQ/8Cg0RKp2n0Oa7B3ReQ/YTI1wClT8j8Ld5swCZCTVUOCs8I0VfjeKqSP2eY2pctpy4+cu4s5sTFsuM50AmgGJL64f1I2XKitUKbqabnibjOnzSNaszpWZh+0KxizQeVQijm8yyxSI/Uqrtr/fW5inuH/sDiMh7I0mlwsm4MqtPxrUY27Ng2Y6gLa7MPwqgBsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA/MEJg33ENx8z5OREE+p4EMMrxoESHgtWCPYKFIL+c=;
 b=lj9mZELtYXD7rTZlzl0ic64cWKlz4yhI2V/jXkALnCwtchZP47G3q5mB/2ydqpmgM9yFYPXow0m7at/E3qhO1CYbvVhBGr34izcBCneRwHJY+7SJl/BhKjsXluKT8NRDK9njOcve2SgQX1Zz3FU0c33EdVsE1/VO2V/ZzB/B/VU=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4938.eurprd04.prod.outlook.com (20.176.235.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 08:42:46 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 08:42:46 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVQTKZYEyobdVG002zgP86IbRAmA==
Date:   Tue, 23 Jul 2019 08:42:46 +0000
Message-ID: <20190723083822.32523-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0139.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::33) To DB7PR04MB4620.eurprd04.prod.outlook.com
 (2603:10a6:5:39::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f4dfec9-a1f8-4d9b-8718-08d70f49bc54
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4938;
x-ms-traffictypediagnostic: DB7PR04MB4938:
x-microsoft-antispam-prvs: <DB7PR04MB4938D81BBBFF49C4B2B4AB268BC70@DB7PR04MB4938.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(6506007)(44832011)(14454004)(7736002)(486006)(305945005)(1076003)(8936002)(256004)(81156014)(36756003)(14444005)(8676002)(478600001)(71190400001)(81166006)(71200400001)(5660300002)(66066001)(2616005)(6916009)(86362001)(3846002)(6116002)(99286004)(6486002)(316002)(54906003)(68736007)(26005)(66946007)(2351001)(50226002)(186003)(102836004)(66476007)(53936002)(52116002)(66556008)(64756008)(66446008)(5640700003)(6436002)(25786009)(2501003)(386003)(6512007)(476003)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4938;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cnDYVNBh1jcdXVe3ABnAc8fR0PWIBgJHY+cok3Ih/Lr5kw0ArkEXozFQP7I3k2TEB0YVwc/JPrre7Fd681q1rhWqYXhGgrrOfSb9uZmmgbGAhBEyClgoIDbOHbfOk/tV4H2rK49Yr0pIN2MQHyhTTgri/Vpi5pfuTBkUfpMgH725JFWF4htFR3K+rQG6sfen+4BiqfdL0JPuDTcGQWEA50ZIdWz7tlMWWkd8x0estlhvOrisvZjvk2Dhcq+6AAIzVd1sohT4TQbgthWgvTgtr4GKZImfdm7txI/kv5AiONI6Y8wbzaM9NMKOejSXlGMmoGlXpQ0Ie9zpvEEgpnqkS+JdnwZoR7qSMuD3c6t4g0dcfUt3PGLMrCasvFyh7rc57lvjTTw9XunRVAvAfaZ7ZBlhKcb5xupimJF9afmU0O0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4dfec9-a1f8-4d9b-8718-08d70f49bc54
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 08:42:46.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4938
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support of printing the dpseci frame queue statistics using debugfs.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---

Please ignore PATCH v3.
Changes since v2:
	- Replaced CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS with
	  CONFIG_DEBUG_FS.

 drivers/crypto/caam/Makefile         |  1 +
 drivers/crypto/caam/caamalg_qi2.c    |  5 +++
 drivers/crypto/caam/caamalg_qi2.h    |  2 +
 drivers/crypto/caam/dpseci-debugfs.c | 80 ++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/caam/dpseci-debugfs.h | 19 +++++++++
 5 files changed, 107 insertions(+)
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
index 8646a7883c63..984e5d03277f 100644
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
index 000000000000..2e43ba9b7491
--- /dev/null
+++ b/drivers/crypto/caam/dpseci-debugfs.c
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
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

