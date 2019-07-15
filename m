Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5E8C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 10:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630C52064B
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 10:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="NQmqHUvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfGOKkL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 06:40:11 -0400
Received: from mail-eopbgr00057.outbound.protection.outlook.com ([40.107.0.57]:29507
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729452AbfGOKkL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 06:40:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LinxyjOM9QWGu6aI6l7G/3rAsXLYBOo3LmTT0Re24KsMtU1ieLc5Zw1NY0vUlHroA7Mim5yNjBF4BXfI4tcxp50dqBMC3kCZNvVdfoXJd2Ot6TDItWgaxv5zmr5yGSVC7f/sRX9eBhEWAKvIn7sxj33KeiO6JgAoNpS9cTFiTy0wFHFDYbch9H1DrtVJ991+sPCJW7VZalfPg4uAttAbEZWfxQweg3xOMjZSQ9iC/eGArApd3irmThhr/j6WBfaQ6MBl6HdpvN/S1+b4Zg6I84d+5z2Upw3zH944vjbcipMY3K+AvODjwsPMy52KVNrVjZ95CAy4fuqhADl59P3Xwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kA7We+5hjru+HZGfJVIRtbkoJYzoBhNFbXVRO9GhA84=;
 b=ZuposiP+O7XquajdaEe3WAhRIh1U4xRkUVKWJ+YdMSiAxFBj+tgezd211N0mI1baNcPdd1KqjXeb+tlOCb0mBGdWFDBPZ1U662Fg5LPPsjoiVgvehGcTkhe/hf7HEjB45+LUiRToxM6Xthr1qHdQsq7/eU4/evV83dcVRcbWGVDIXUlQ6Q3QgRNrPa5zlg5qN96XL8z0cDxbt6ojPBbHEGBhhehWQFgbnglh38Bk/FHMqum6/JfFwkE0hAr71m9Lwy5vbdU9ZA5pJbSIHQ3DiBuEq+NrzVteGyPT+awKd5ZhJCPRF25S7Jk67PVWQoyMgikwn7FxDml1YG5nEM4+9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kA7We+5hjru+HZGfJVIRtbkoJYzoBhNFbXVRO9GhA84=;
 b=NQmqHUvhlquTiSOE79i8UoI4YZFUt76KTr4V0xX64CoUOIb3/nvFo8Q1y5rBJEMEgoOen/Ssh8dTHRWF+hnKejjk0xYaAXfnlbH14RIsTiCpLTA41JZhwF2ypmnQb5z0F52/xdIeDPNVqjHpAZ0epp4JS8Jm/Y5rwUn7fKb16ao=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3647.eurprd04.prod.outlook.com (52.134.14.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 10:40:07 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 10:40:07 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVNwguOOkfq3/oJUq1vbSxxq5xjA==
Date:   Mon, 15 Jul 2019 10:40:06 +0000
Message-ID: <VI1PR0402MB348520DA92B7DDFBB53B14D098CF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190710100944.32477-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83ce904d-e6c3-4058-cef2-08d70910cdbb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3647;
x-ms-traffictypediagnostic: VI1PR0402MB3647:
x-microsoft-antispam-prvs: <VI1PR0402MB364715E045FC29B77D82573898CF0@VI1PR0402MB3647.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:214;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(189003)(5660300002)(66066001)(14454004)(3846002)(6116002)(305945005)(25786009)(74316002)(7736002)(68736007)(14444005)(256004)(446003)(110136005)(54906003)(316002)(476003)(91956017)(76116006)(64756008)(66446008)(66556008)(66946007)(66476007)(76176011)(33656002)(7696005)(53546011)(102836004)(6506007)(229853002)(486006)(52536014)(186003)(26005)(99286004)(2906002)(53936002)(81156014)(81166006)(8936002)(9686003)(71190400001)(2501003)(71200400001)(55016002)(478600001)(44832011)(6246003)(86362001)(8676002)(4326008)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3647;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z8DvyrQ+798R5HAJItct7S0xUEQzV02p1OYLZl+NL5ZaUZUBM/X+zN2MpxbupA/Nz63Nyic9yOe+TW+JzakrLCPMfR/qcRK8/NrAGPh+zIqtPkGOKbrUHxSrc7ZEb8udjkPp3tthdoB4IgV15AvnwWrl3vOBUj3BfIydP1FcdZi2H2TsLukod/GrglV5RHWJNSC4rkh36UaIvkCsUhtrYbJWGIoSX7FnGjTrCtyLbEN5OB0m9EV2NMBYsZqUtwAYRy9KuH0h8Azf95g484iEyJ2giX23pHcIr4C1tW5YbIKBPyAtMsmTbvAyZhLhhViE0bB8XJXVMUJ0/ftOPoqAvmnU7vCpsVZRHbmJvmmRs0Qi/tpnZmDWUeZJntvPtuSKnYbqQVBcA4VNJYqCOJrTBLGkISQ1IqiCqXs07Vspt/U=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ce904d-e6c3-4058-cef2-08d70910cdbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 10:40:07.0049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3647
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/10/2019 1:13 PM, Vakul Garg wrote:=0A=
> Add support of printing the dpseci frame queue statistics using debugfs.=
=0A=
> =0A=
Please move this into a separate file, that gets compiled only if=0A=
CONFIG_DEBUG_FS=3Dy.=0A=
=0A=
Function(s) that are needed outside this file should be called unconditiona=
lly=0A=
and should have an empty version, in case CONFIG_DEBUG_FS=3Dn.=0A=
=0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg_qi2.c | 95 +++++++++++++++++++++++++++++++++=
++++++=0A=
>  drivers/crypto/caam/caamalg_qi2.h |  3 ++=0A=
>  2 files changed, 98 insertions(+)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caam=
alg_qi2.c=0A=
> index 06bf32c32cbd..9414d2149b9a 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.c=0A=
> @@ -5009,6 +5009,87 @@ static int __cold dpaa2_dpseci_disable(struct dpaa=
2_caam_priv *priv)=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +#ifdef CONFIG_DEBUG_FS=0A=
> +static int dpseci_dbg_fqs_show(struct seq_file *file, void *offset)=0A=
> +{=0A=
> +	struct dpaa2_caam_priv *priv =3D (struct dpaa2_caam_priv *)file->privat=
e;=0A=
> +	u32 fqid, fcnt, bcnt;=0A=
> +	int i, err;=0A=
> +=0A=
> +	seq_printf(file, "FQ stats for %s:\n", dev_name(priv->dev));=0A=
> +	seq_printf(file, "%s%16s%16s\n",=0A=
> +		   "Rx-VFQID",=0A=
> +		   "Pending frames",=0A=
> +		   "Pending bytes");=0A=
> +=0A=
> +	for (i =3D 0; i <  priv->num_pairs; i++) {=0A=
> +		fqid =3D priv->rx_queue_attr[i].fqid;=0A=
> +		err =3D dpaa2_io_query_fq_count(NULL, fqid, &fcnt, &bcnt);=0A=
> +		if (err)=0A=
> +			continue;=0A=
> +=0A=
> +		seq_printf(file, "%5d%16u%16u\n", fqid, fcnt, bcnt);=0A=
> +	}=0A=
> +=0A=
> +	seq_printf(file, "%s%16s%16s\n",=0A=
> +		   "Tx-VFQID",=0A=
> +		   "Pending frames",=0A=
> +		   "Pending bytes");=0A=
> +=0A=
> +	for (i =3D 0; i <  priv->num_pairs; i++) {=0A=
> +		fqid =3D priv->tx_queue_attr[i].fqid;=0A=
> +		err =3D dpaa2_io_query_fq_count(NULL, fqid, &fcnt, &bcnt);=0A=
> +		if (err)=0A=
> +			continue;=0A=
> +=0A=
> +		seq_printf(file, "%5d%16u%16u\n", fqid, fcnt, bcnt);=0A=
> +	}=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
> +static int dpseci_dbg_fqs_open(struct inode *inode, struct file *file)=
=0A=
> +{=0A=
> +	int err;=0A=
> +	struct dpaa2_caam_priv *priv;=0A=
> +=0A=
> +	priv =3D (struct dpaa2_caam_priv *)inode->i_private;=0A=
> +=0A=
> +	err =3D single_open(file, dpseci_dbg_fqs_show, priv);=0A=
> +	if (err < 0)=0A=
> +		dev_err(priv->dev, "single_open() failed\n");=0A=
> +=0A=
> +	return err;=0A=
> +}=0A=
> +=0A=
> +static const struct file_operations dpseci_dbg_fq_ops =3D {=0A=
> +	.open =3D dpseci_dbg_fqs_open,=0A=
> +	.read =3D seq_read,=0A=
> +	.llseek =3D seq_lseek,=0A=
> +	.release =3D single_release,=0A=
> +};=0A=
> +=0A=
> +static int dpaa2_dpseci_debugfs_init(struct dpaa2_caam_priv *priv)=0A=
> +{=0A=
> +	struct dentry *res;=0A=
> +=0A=
> +	res =3D debugfs_create_dir(dev_name(priv->dev), NULL);=0A=
> +	if (IS_ERR_OR_NULL(res))=0A=
> +		return PTR_ERR(res);=0A=
> +=0A=
Error checking not needed.=0A=
See previous work done by GregKH to clean up debugfs-related error path.=0A=
=0A=
> +	priv->dfs_root =3D res;=0A=
> +=0A=
> +	res =3D debugfs_create_file("fq_stats", 0444, res, priv,=0A=
> +				  &dpseci_dbg_fq_ops);=0A=
> +	if (IS_ERR_OR_NULL(res)) {=0A=
> +		debugfs_remove_recursive(priv->dfs_root);=0A=
> +		return PTR_ERR(res);=0A=
> +	}=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +#endif=0A=
> +=0A=
>  static struct list_head hash_list;=0A=
>  =0A=
>  static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)=0A=
> @@ -5098,6 +5179,14 @@ static int dpaa2_caam_probe(struct fsl_mc_device *=
dpseci_dev)=0A=
>  		goto err_bind;=0A=
>  	}=0A=
>  =0A=
> +#ifdef CONFIG_DEBUG_FS=0A=
> +	err =3D dpaa2_dpseci_debugfs_init(priv);=0A=
> +	if (err) {=0A=
> +		dev_err(dev, "dpaa2_dpseci_debugfs_init() failed\n");=0A=
> +		goto err_debugfs;=0A=
> +	}=0A=
> +#endif=0A=
> +=0A=
>  	/* register crypto algorithms the device supports */=0A=
>  	for (i =3D 0; i < ARRAY_SIZE(driver_algs); i++) {=0A=
>  		struct caam_skcipher_alg *t_alg =3D driver_algs + i;=0A=
> @@ -5242,6 +5331,8 @@ static int dpaa2_caam_probe(struct fsl_mc_device *d=
pseci_dev)=0A=
>  =0A=
>  	return err;=0A=
>  =0A=
> +err_debugfs:=0A=
> +	dpaa2_dpseci_disable(priv);=0A=
>  err_bind:=0A=
>  	dpaa2_dpseci_dpio_free(priv);=0A=
>  err_dpio_setup:=0A=
> @@ -5265,6 +5356,10 @@ static int __cold dpaa2_caam_remove(struct fsl_mc_=
device *ls_dev)=0A=
>  	dev =3D &ls_dev->dev;=0A=
>  	priv =3D dev_get_drvdata(dev);=0A=
>  =0A=
> +#ifdef CONFIG_DEBUG_FS=0A=
> +	debugfs_remove_recursive(priv->dfs_root);=0A=
> +#endif=0A=
> +=0A=
Please get rid of the ifdeffery, debugfs_remove_recursive() should be calle=
d=0A=
unconditionally.=0A=
=0A=
>  	for (i =3D 0; i < ARRAY_SIZE(driver_aeads); i++) {=0A=
>  		struct caam_aead_alg *t_alg =3D driver_aeads + i;=0A=
>  =0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caam=
alg_qi2.h=0A=
> index 0f207b275578..74644d92f9d7 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.h=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.h=0A=
> @@ -64,6 +64,9 @@ struct dpaa2_caam_priv {=0A=
>  	struct iommu_domain *domain;=0A=
>  =0A=
>  	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;=0A=
> +#ifdef CONFIG_DEBUG_FS=0A=
> +	struct dentry *dfs_root;=0A=
> +#endif=0A=
>  };=0A=
>  =0A=
>  /**=0A=
> =0A=
=0A=
