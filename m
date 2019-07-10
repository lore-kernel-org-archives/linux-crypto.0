Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F0BC73C7C
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 10:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0C320838
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 10:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PHPeuhFw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfGJKOD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 06:14:03 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:19719
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbfGJKOD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 06:14:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzoC6DJVWAgxo7gs8Y1ki8iQC/CTyaE/2pG48ejxOM2+BfWqaMvpo5HbBkgz8LoNud+7rjnvN3B9WR1jtOkL+G+75kTkmgBLpruehiilUo5Yqiqfv0vxXUHmrguR9t5kybXBpf1hnHJFg/s7aP/FLdRiIQFB93F+4ipRXy/ZizgzN/LgMUwg2R/Np9o3DXV8W/sXj5aNOowRRSnFm075RG9mWUnXOFR7tOVHaedF+TxuTZF20Vya8nna5YhlqQK64jlRbmCnYAuHDM7V/z8UlaarC8wx1+UYdD9Jh302mHHVS2N8WieiW8L18pqozhUFs6AUg++Brl5F9CfCdQ1sVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsiuWcJOZAj1OrYZkkvNA0iXGFGHH+GqG2BWtlh9XAA=;
 b=ck2sqw5Th+Md0Op8w6Add3kOHxirZyeSYiOfCBYCg5O85KC5dErqclWND6NdUnjy0rUSRXifV4PEufjbGxZdwzXq3Q1MEp7GmnWCilxAEvtP4Eg0ugNQIyyQ84GchQPr8nhN6xxnlshrRhOOAnj4df1VDl3V83t1i2Q1i0tKKmUQYfJn1lBY0GdeLZ6+/JduPwY30CZkrtZphq40Np99Vs1RMPGC4A6LyJS8nhwiBv1z5RVTjJGidl7yYIjXhnUskpkaeu3ztLNsZ5hrEVbIvA4f0YKQCjlCWYtHbkwp/o85vwUDLT/Lx+wyLVCOUzJ+GeGv4pewOCM2q8l2vVhpvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsiuWcJOZAj1OrYZkkvNA0iXGFGHH+GqG2BWtlh9XAA=;
 b=PHPeuhFwT6icmdoqk4A8cTR7Ghgjx3Nx/qglWJhy/IikHA7TAlSdDM25ymRK2zPSRiqA4EI1A8RQPD9q9nLUW+s4rBKm1i/t9K3xO0wpOtg5hBoNhcmgO07c4ovjgnsQ3OwDxLZccVrWe0rf0pmr2IrHlrK0ST2jO1CJpVVwkEo=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.138.154) by
 DB7PR04MB4267.eurprd04.prod.outlook.com (52.135.131.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 10 Jul 2019 10:13:55 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::6d49:c523:2492:cb9f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::6d49:c523:2492:cb9f%3]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 10:13:55 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH] crypto: caam/qi2 - Add printing dpseci fq stats using debugfs
Thread-Topic: [PATCH] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVNwguOOkfq3/oJUq1vbSxxq5xjA==
Date:   Wed, 10 Jul 2019 10:13:55 +0000
Message-ID: <20190710100944.32477-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0008.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:d::18) To DB7PR04MB4620.eurprd04.prod.outlook.com
 (2603:10a6:5:36::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [92.120.1.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 091f3a7f-a379-43ac-95a9-08d7051f5092
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4267;
x-ms-traffictypediagnostic: DB7PR04MB4267:
x-microsoft-antispam-prvs: <DB7PR04MB42677610732457B1ED0594E28BF00@DB7PR04MB4267.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(199004)(189003)(6436002)(4326008)(26005)(5640700003)(6486002)(7736002)(305945005)(52116002)(6512007)(53936002)(99286004)(81156014)(68736007)(50226002)(8936002)(102836004)(186003)(316002)(386003)(54906003)(6506007)(44832011)(81166006)(86362001)(71190400001)(6116002)(3846002)(71200400001)(25786009)(2501003)(486006)(478600001)(66946007)(476003)(6916009)(2351001)(14444005)(256004)(2906002)(14454004)(8676002)(1076003)(5660300002)(2616005)(66066001)(66476007)(66556008)(64756008)(66446008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4267;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SMOfBS67dEC60ku6fDP7pDHgagXobsJht7mOyhZxf2Fm2+iwdfIYHJ9hX990ApvQ/vBP65jO8tWjqtsfuM+p8vD/G8LG5T1z2/hKQXSW69smRnghhsT7Hkyc66Wu51ZnKP29rZAyfaLcgKgvhd8zUcD6CQItrKbUD1nUiAHvaRoOGr4LQtMrz+UqZLuGU45Kz+dD6KONbMcG2CApN9BxyB0L39+rxi+ILukRqWhJcOYKfw1NkPiDLrBCB2yl6vU6/eDKvAGp6Thf1Spjbo7jNfDms7tcTqBkURmbXbqbOvBonrFYMA1bSS0Q58Vy0C1PkkGF7LYA8WYdvn97UzXsMntcVkNMrME8bZzsGQpznO3MZsLTrYMdoJ++V2N68b0Jz/dBUmBawPd/cKA7uSWBciKP0mHyHatFARcrTqUEtak=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091f3a7f-a379-43ac-95a9-08d7051f5092
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 10:13:55.2352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4267
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support of printing the dpseci frame queue statistics using debugfs.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 95 +++++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/caam/caamalg_qi2.h |  3 ++
 2 files changed, 98 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamal=
g_qi2.c
index 06bf32c32cbd..9414d2149b9a 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5009,6 +5009,87 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_=
caam_priv *priv)
 	return 0;
 }
=20
+#ifdef CONFIG_DEBUG_FS
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
+static int dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv)
+{
+	struct dentry *res;
+
+	res =3D debugfs_create_dir(dev_name(priv->dev), NULL);
+	if (IS_ERR_OR_NULL(res))
+		return PTR_ERR(res);
+
+	priv->dfs_root =3D res;
+
+	res =3D debugfs_create_file("fq_stats", 0444, res, priv,
+				  &dpseci_dbg_fq_ops);
+	if (IS_ERR_OR_NULL(res)) {
+		debugfs_remove_recursive(priv->dfs_root);
+		return PTR_ERR(res);
+	}
+
+	return 0;
+}
+#endif
+
 static struct list_head hash_list;
=20
 static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)
@@ -5098,6 +5179,14 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dp=
seci_dev)
 		goto err_bind;
 	}
=20
+#ifdef CONFIG_DEBUG_FS
+	err =3D dpaa2_dpseci_debugfs_init(priv);
+	if (err) {
+		dev_err(dev, "dpaa2_dpseci_debugfs_init() failed\n");
+		goto err_debugfs;
+	}
+#endif
+
 	/* register crypto algorithms the device supports */
 	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {
 		struct caam_skcipher_alg *t_alg =3D driver_algs + i;
@@ -5242,6 +5331,8 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dps=
eci_dev)
=20
 	return err;
=20
+err_debugfs:
+	dpaa2_dpseci_disable(priv);
 err_bind:
 	dpaa2_dpseci_dpio_free(priv);
 err_dpio_setup:
@@ -5265,6 +5356,10 @@ static int __cold dpaa2_caam_remove(struct fsl_mc_de=
vice *ls_dev)
 	dev =3D &ls_dev->dev;
 	priv =3D dev_get_drvdata(dev);
=20
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(priv->dfs_root);
+#endif
+
 	for (i =3D 0; i < ARRAY_SIZE(driver_aeads); i++) {
 		struct caam_aead_alg *t_alg =3D driver_aeads + i;
=20
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamal=
g_qi2.h
index 0f207b275578..74644d92f9d7 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -64,6 +64,9 @@ struct dpaa2_caam_priv {
 	struct iommu_domain *domain;
=20
 	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dfs_root;
+#endif
 };
=20
 /**
--=20
2.13.6

