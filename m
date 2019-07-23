Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA80C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE9F4227BF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="jjwyhpc+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388799AbfGWJO3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 05:14:29 -0400
Received: from mail-eopbgr50052.outbound.protection.outlook.com ([40.107.5.52]:55623
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388800AbfGWJO3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 05:14:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2D5aMWUUeoW+kTLd9XL8qXPKV9CceJispKmOb7UV2DcnZnJtpI6HOce80e2SYx9KeYwGuQI1RcLXZOiQFnC6eqXKJ4XsKepKFT1eWpIzSwFATA4qWOB3Rs+NQTgS5sCmMD+b0w9po2QjY55mckEGn7P9w3TV6EHpeH+jN/131MQ3hkmRb7iKtv2EzMfnA9KLbEaj8Yo7JUOPiCyeZCrMBSbd/yDzMtnBxUOu/57t40Y1nJdVKcTLRQ3GnUaZWl2cMNoQOkFW1inDmWWyfvZ/TWhKt8jsiVxwpdMhdM9bqbAAKtDVc7cf8Qqk19m3Klsw+B7/sOAg1YZPZ4+PibuqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OFLoU3/opHq18+o4QwaUu5lCEjmmzRPBU8mJDlk9rg=;
 b=U5iWKuO75j4LhwUy5J89JsiD1u8ZJy42JC/5lrEHVN//z2xDxssHcctzhNKY2tAjJ/tEjdDpiSD+i0d/Cze/uaxr6jHRk6I84FcBFu5FyhfNm5pWbfi1eZVU9sPBjRdb296Ye+cNcJUs56D11BS9V6kRTulP0k2kU7/n9mKufE2g1AOdEeGUcZ5HfpPz3vLz73C3fDDdYDCn7bQ8+K/uXDKuYWAifeWhrzk6QnuyHZ1kTBwEmKHUGC7C+knJzw0I6JHpahqTPuhFRorz9ekd3lbGwA+Ym6dUSOasIO7lvZzLuaukmFtNtqSEz4gSYpP4EkfvBZPfgHMP+ZgV4P5GBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OFLoU3/opHq18+o4QwaUu5lCEjmmzRPBU8mJDlk9rg=;
 b=jjwyhpc+j6tLlfcp+mypBC0kBKyve0F9TtIV5OIUuomjq2Z8RxjAhmJK7+RCq6QrgPSUUn8npSLX3nWEXtKdCkQjfkozCoXuKYKfc7zdP6SGdZ5FSwjSfXnJHQ1PKVd+izLw916l1S7g3d4i5frHETeJD/UfiqOoFKfL90RBy5I=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4457.eurprd04.prod.outlook.com (52.135.141.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 09:14:24 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:14:24 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH v5] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v5] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVQTcF+gEt00n54EefuTviasufew==
Date:   Tue, 23 Jul 2019 09:14:24 +0000
Message-ID: <20190723091005.827-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0131.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::25) To DB7PR04MB4620.eurprd04.prod.outlook.com
 (2603:10a6:5:39::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88526cf8-1e92-4b92-eaf3-08d70f4e2776
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4457;
x-ms-traffictypediagnostic: DB7PR04MB4457:
x-microsoft-antispam-prvs: <DB7PR04MB4457AFB658415492D7569A3C8BC70@DB7PR04MB4457.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(199004)(189003)(305945005)(256004)(14444005)(478600001)(54906003)(36756003)(3846002)(8936002)(6116002)(86362001)(81156014)(476003)(50226002)(7736002)(81166006)(2616005)(316002)(8676002)(26005)(71200400001)(66066001)(71190400001)(2501003)(6506007)(2906002)(186003)(5660300002)(1076003)(66556008)(6512007)(102836004)(6436002)(66476007)(5640700003)(66946007)(386003)(64756008)(66446008)(14454004)(6916009)(4326008)(486006)(52116002)(53936002)(44832011)(25786009)(2351001)(99286004)(68736007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4457;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /QcdpLr2e83lj0T29egVNzak97sBcaR3ip9V7L1VXhdzGi1VeELw6yFQEXTC8CE5jjkevxlak7zR5FAOJ+oVXDSuTgj2qsToUBxjz33AL7Iz9toM8EIvNJOGSTyDJI+FQWnO4c9t2rLz79xN2E7XFglDQtUy7eN6uPiR6yDcX3V5X1U03BYxhjk+zhDGRPMYjm8eTfUjaKg83+tkQ5JRBPL/amjj4bqTUfZWBGZiKN5zwJEPO1fFvnFmETsfCbcZYlFt0KiBKy1GsyvV+9rfKOgpin1mKD+akLrB7wgC7uJNXGeZd2QUUUSza/dtdkCgaznMt56gYa/JaAPT6NeBjZ7u09sv+Dnlm6RyS1bCxfcv0ejID3AX2K/QFcYHeC344r3RXWvGyQJ/bU42LROTkz9u5Za3mxGnXgHDS5rkYBQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88526cf8-1e92-4b92-eaf3-08d70f4e2776
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:14:24.1894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4457
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support of printing the dpseci frame queue statistics using debugfs.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---

Changes since v4:
	- Corrected license header commenting style

 drivers/crypto/caam/Makefile         |  1 +
 drivers/crypto/caam/caamalg_qi2.c    |  5 +++
 drivers/crypto/caam/caamalg_qi2.h    |  2 +
 drivers/crypto/caam/dpseci-debugfs.c | 79 ++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/caam/dpseci-debugfs.h | 18 ++++++++
 5 files changed, 105 insertions(+)
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.c
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.h

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 9ab4e81ea21e..68d5cc0f28e2 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -30,3 +30,4 @@ endif
 obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) +=3D dpaa2_caam.o
=20
 dpaa2_caam-y    :=3D caamalg_qi2.o dpseci.o
+dpaa2_caam-$(CONFIG_DEBUG_FS) +=3D dpseci-debugfs.o
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
index be5085451053..17130dbe6465 100644
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
index 000000000000..c5bfc923abd8
--- /dev/null
+++ b/drivers/crypto/caam/dpseci-debugfs.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2019 NXP */
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
index 000000000000..bc22af7bec37
--- /dev/null
+++ b/drivers/crypto/caam/dpseci-debugfs.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP */
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

