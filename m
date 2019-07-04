Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26025C0651F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 15:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA9BA218A0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 15:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="TdugGllT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfGDPnY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 11:43:24 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:2371
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbfGDPnY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 11:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMoDb23DBgdwAiZYV97JvjmivyvdpVI/gMzTCG+2ze8=;
 b=TdugGllTmLd2T/R8mViLxEcWagpD6ntgb6v5iU/aMiOopbtsyTUD3a+vIV2zjaFTqeaynqWZklGYtQ+aiQO9TVd9Mozb+vTCt1GAJw33qUrw3z1Fj30sUCMT61Yi7QXDTZ7XFfO2dwSrWYKfd4TLuyykwnOyIWs8lbNpyOakFLs=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4767.eurprd04.prod.outlook.com (20.177.48.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 15:43:14 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac%3]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 15:43:14 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/16] crypto: caam - simplify clock initialization
Thread-Topic: [PATCH v4 02/16] crypto: caam - simplify clock initialization
Thread-Index: AQHVMXd2j2Eg3x6mzEeC4FmOfA22vg==
Date:   Thu, 4 Jul 2019 15:43:14 +0000
Message-ID: <VI1PR04MB44452213E0EB98FA1FCC31688CFA0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02521557-5559-41ff-513f-08d700965383
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4767;
x-ms-traffictypediagnostic: VI1PR04MB4767:
x-microsoft-antispam-prvs: <VI1PR04MB4767E91668BD64815FE9A8BF8CFA0@VI1PR04MB4767.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(3846002)(6116002)(66066001)(478600001)(71190400001)(71200400001)(2501003)(486006)(44832011)(316002)(81156014)(68736007)(256004)(14444005)(81166006)(9686003)(8676002)(14454004)(186003)(53936002)(5660300002)(6436002)(8936002)(229853002)(33656002)(55016002)(74316002)(110136005)(99286004)(305945005)(6246003)(476003)(54906003)(102836004)(26005)(52536014)(2906002)(7736002)(7696005)(76176011)(446003)(6506007)(53546011)(64756008)(66446008)(66556008)(66476007)(91956017)(66946007)(86362001)(76116006)(73956011)(25786009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4767;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oBxLT18/HxyZKJgKwlnDA5mXib1g0r3gQp/OI4T0E4ZFBrsEI20VhySY2wH5RbxBbbZhkynqPVzEL+7SncbZ4axHBZiVdsrIocPrvqYMa4/OnYIZBwUjV21I6SCToL9mgdJ4MMEUr3vVaP44HosUJX1nMDonTuFwLJfW6jhg5SB3uJGNYBBkffGsbXyL0Y3bTXTWUKV00Ob1GnhF4povkODz1gHrvKOh74jMhH3AAOokGcFlS4rNI/AMu/54CYw2g6ldfDcMz0DTLfDnxfd9JuAqMl3XWxijw8dvcacFNLoN52WcEMlF+KbCI5yWiNwGE6IibKh2oPkzeRSo5bJvC5lXmBOOxDErnCBls/wDJW1co3JfdVxxYf14XhFlrAS8oiltm+eMotwR3/tNCCQT+fEfyZ0Q4gRPIh90P2GqNKc=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02521557-5559-41ff-513f-08d700965383
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 15:43:14.0464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4767
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/3/2019 11:15 AM, Andrey Smirnov wrote:=0A=
> Simplify clock initialization code by converting it to use clk-bulk,=0A=
> devres and soc_device_match() match table. No functional change=0A=
> intended.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> Cc: Cory Tusar <cory.tusar@zii.aero>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> ---=0A=
>   drivers/crypto/caam/ctrl.c   | 203 +++++++++++++++++------------------=
=0A=
>   drivers/crypto/caam/intern.h |   7 +-=0A=
>   2 files changed, 98 insertions(+), 112 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index e674d8770cdb..908d3ecf6d1c 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -25,16 +25,6 @@ EXPORT_SYMBOL(caam_dpaa2);=0A=
>   #include "qi.h"=0A=
>   #endif=0A=
>   =0A=
> -/*=0A=
> - * i.MX targets tend to have clock control subsystems that can=0A=
> - * enable/disable clocking to our device.=0A=
> - */=0A=
> -static inline struct clk *caam_drv_identify_clk(struct device *dev,=0A=
> -						char *clk_name)=0A=
> -{=0A=
> -	return caam_imx ? devm_clk_get(dev, clk_name) : NULL;=0A=
> -}=0A=
> -=0A=
>   /*=0A=
>    * Descriptor to instantiate RNG State Handle 0 in normal mode and=0A=
>    * load the JDKEK, TDKEK and TDSK registers=0A=
> @@ -342,13 +332,6 @@ static int caam_remove(struct platform_device *pdev)=
=0A=
>   	/* Unmap controller region */=0A=
>   	iounmap(ctrl);=0A=
>   =0A=
> -	/* shut clocks off before finalizing shutdown */=0A=
> -	clk_disable_unprepare(ctrlpriv->caam_ipg);=0A=
> -	if (ctrlpriv->caam_mem)=0A=
> -		clk_disable_unprepare(ctrlpriv->caam_mem);=0A=
> -	clk_disable_unprepare(ctrlpriv->caam_aclk);=0A=
> -	if (ctrlpriv->caam_emi_slow)=0A=
> -		clk_disable_unprepare(ctrlpriv->caam_emi_slow);=0A=
>   	return 0;=0A=
>   }=0A=
>   =0A=
> @@ -497,20 +480,102 @@ static const struct of_device_id caam_match[] =3D =
{=0A=
>   };=0A=
>   MODULE_DEVICE_TABLE(of, caam_match);=0A=
>   =0A=
> +struct caam_imx_data {=0A=
> +	const struct clk_bulk_data *clks;=0A=
> +	int num_clks;=0A=
> +};=0A=
> +=0A=
> +static const struct clk_bulk_data caam_imx6_clks[] =3D {=0A=
> +	{ .id =3D "ipg" },=0A=
> +	{ .id =3D "mem" },=0A=
> +	{ .id =3D "aclk" },=0A=
> +	{ .id =3D "emi_slow" },=0A=
> +};=0A=
> +=0A=
> +static const struct caam_imx_data caam_imx6_data =3D {=0A=
> +	.clks =3D caam_imx6_clks,=0A=
> +	.num_clks =3D ARRAY_SIZE(caam_imx6_clks),=0A=
> +};=0A=
> +=0A=
> +static const struct clk_bulk_data caam_imx7_clks[] =3D {=0A=
> +	{ .id =3D "ipg" },=0A=
> +	{ .id =3D "aclk" },=0A=
> +};=0A=
> +=0A=
> +static const struct caam_imx_data caam_imx7_data =3D {=0A=
> +	.clks =3D caam_imx7_clks,=0A=
> +	.num_clks =3D ARRAY_SIZE(caam_imx7_clks),=0A=
> +};=0A=
> +=0A=
> +static const struct clk_bulk_data caam_imx6ul_clks[] =3D {=0A=
> +	{ .id =3D "ipg" },=0A=
> +	{ .id =3D "mem" },=0A=
> +	{ .id =3D "aclk" },=0A=
> +};=0A=
> +=0A=
> +static const struct caam_imx_data caam_imx6ul_data =3D {=0A=
> +	.clks =3D caam_imx6ul_clks,=0A=
> +	.num_clks =3D ARRAY_SIZE(caam_imx6ul_clks),=0A=
> +};=0A=
> +=0A=
> +static const struct soc_device_attribute caam_imx_soc_table[] =3D {=0A=
> +	{ .soc_id =3D "i.MX6UL", .data =3D &caam_imx6ul_data },=0A=
> +	{ .soc_id =3D "i.MX6*",  .data =3D &caam_imx6_data },=0A=
> +	{ .soc_id =3D "i.MX7*",  .data =3D &caam_imx7_data },=0A=
> +	{ .family =3D "Freescale i.MX" },=0A=
> +};=0A=
=0A=
You need to add a {/* sentinel */} in caam_imx_soc_table, otherwise will =
=0A=
crash for other than i.MX targets, when trying to identify the SoC.=0A=
=0A=
> +=0A=
> +static void disable_clocks(void *data)=0A=
> +{=0A=
> +	struct caam_drv_private *ctrlpriv =3D data;=0A=
> +=0A=
> +	clk_bulk_disable_unprepare(ctrlpriv->num_clks, ctrlpriv->clks);=0A=
> +}=0A=
> +=0A=
> +static int init_clocks(struct device *dev,=0A=
> +		       struct caam_drv_private *ctrlpriv,=0A=
> +		       const struct caam_imx_data *data)=0A=
> +{=0A=
> +	int ret;=0A=
> +=0A=
> +	ctrlpriv->num_clks =3D data->num_clks;=0A=
> +	ctrlpriv->clks =3D devm_kmemdup(dev, data->clks,=0A=
> +				      data->num_clks * sizeof(data->clks[0]),=0A=
> +				      GFP_KERNEL);=0A=
> +	if (!ctrlpriv->clks)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	ret =3D devm_clk_bulk_get(dev, ctrlpriv->num_clks, ctrlpriv->clks);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev,=0A=
> +			"Failed to request all necessary clocks\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D clk_bulk_prepare_enable(ctrlpriv->num_clks, ctrlpriv->clks);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev,=0A=
> +			"Failed to prepare/enable all necessary clocks\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>   /* Probe routine for CAAM top (controller) level */=0A=
>   static int caam_probe(struct platform_device *pdev)=0A=
>   {=0A=
>   	int ret, ring, gen_sk, ent_delay =3D RTSDCTL_ENT_DLY_MIN;=0A=
>   	u64 caam_id;=0A=
> -	static const struct soc_device_attribute imx_soc[] =3D {=0A=
> -		{.family =3D "Freescale i.MX"},=0A=
> -		{},=0A=
> -	};=0A=
> +	const struct soc_device_attribute *imx_soc_match;=0A=
>   	struct device *dev;=0A=
>   	struct device_node *nprop, *np;=0A=
>   	struct caam_ctrl __iomem *ctrl;=0A=
>   	struct caam_drv_private *ctrlpriv;=0A=
> -	struct clk *clk;=0A=
>   #ifdef CONFIG_DEBUG_FS=0A=
>   	struct caam_perfmon *perfmon;=0A=
>   #endif=0A=
> @@ -527,91 +592,25 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>   	dev_set_drvdata(dev, ctrlpriv);=0A=
>   	nprop =3D pdev->dev.of_node;=0A=
>   =0A=
> -	caam_imx =3D (bool)soc_device_match(imx_soc);=0A=
> -=0A=
> -	/* Enable clocking */=0A=
> -	clk =3D caam_drv_identify_clk(&pdev->dev, "ipg");=0A=
> -	if (IS_ERR(clk)) {=0A=
> -		ret =3D PTR_ERR(clk);=0A=
> -		dev_err(&pdev->dev,=0A=
> -			"can't identify CAAM ipg clk: %d\n", ret);=0A=
> -		return ret;=0A=
> -	}=0A=
> -	ctrlpriv->caam_ipg =3D clk;=0A=
> -=0A=
> -	if (!of_machine_is_compatible("fsl,imx7d") &&=0A=
> -	    !of_machine_is_compatible("fsl,imx7s") &&=0A=
> -	    !of_machine_is_compatible("fsl,imx7ulp")) {=0A=
> -		clk =3D caam_drv_identify_clk(&pdev->dev, "mem");=0A=
> -		if (IS_ERR(clk)) {=0A=
> -			ret =3D PTR_ERR(clk);=0A=
> -			dev_err(&pdev->dev,=0A=
> -				"can't identify CAAM mem clk: %d\n", ret);=0A=
> -			return ret;=0A=
> +	imx_soc_match =3D soc_device_match(caam_imx_soc_table);=0A=
> +	if (imx_soc_match) {=0A=
> +		if (!imx_soc_match->data) {=0A=
> +			dev_err(dev, "No clock data provided for i.MX SoC");=0A=
> +			return -EINVAL;=0A=
>   		}=0A=
> -		ctrlpriv->caam_mem =3D clk;=0A=
> -	}=0A=
>   =0A=
> -	clk =3D caam_drv_identify_clk(&pdev->dev, "aclk");=0A=
> -	if (IS_ERR(clk)) {=0A=
> -		ret =3D PTR_ERR(clk);=0A=
> -		dev_err(&pdev->dev,=0A=
> -			"can't identify CAAM aclk clk: %d\n", ret);=0A=
> -		return ret;=0A=
> -	}=0A=
> -	ctrlpriv->caam_aclk =3D clk;=0A=
> -=0A=
> -	if (!of_machine_is_compatible("fsl,imx6ul") &&=0A=
> -	    !of_machine_is_compatible("fsl,imx7d") &&=0A=
> -	    !of_machine_is_compatible("fsl,imx7s") &&=0A=
> -	    !of_machine_is_compatible("fsl,imx7ulp")) {=0A=
> -		clk =3D caam_drv_identify_clk(&pdev->dev, "emi_slow");=0A=
> -		if (IS_ERR(clk)) {=0A=
> -			ret =3D PTR_ERR(clk);=0A=
> -			dev_err(&pdev->dev,=0A=
> -				"can't identify CAAM emi_slow clk: %d\n", ret);=0A=
> +		ret =3D init_clocks(dev, ctrlpriv, imx_soc_match->data);=0A=
> +		if (ret)=0A=
>   			return ret;=0A=
> -		}=0A=
> -		ctrlpriv->caam_emi_slow =3D clk;=0A=
> -	}=0A=
> -=0A=
> -	ret =3D clk_prepare_enable(ctrlpriv->caam_ipg);=0A=
> -	if (ret < 0) {=0A=
> -		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);=0A=
> -		return ret;=0A=
> -	}=0A=
> -=0A=
> -	if (ctrlpriv->caam_mem) {=0A=
> -		ret =3D clk_prepare_enable(ctrlpriv->caam_mem);=0A=
> -		if (ret < 0) {=0A=
> -			dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",=0A=
> -				ret);=0A=
> -			goto disable_caam_ipg;=0A=
> -		}=0A=
> -	}=0A=
> -=0A=
> -	ret =3D clk_prepare_enable(ctrlpriv->caam_aclk);=0A=
> -	if (ret < 0) {=0A=
> -		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);=0A=
> -		goto disable_caam_mem;=0A=
> -	}=0A=
> -=0A=
> -	if (ctrlpriv->caam_emi_slow) {=0A=
> -		ret =3D clk_prepare_enable(ctrlpriv->caam_emi_slow);=0A=
> -		if (ret < 0) {=0A=
> -			dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",=0A=
> -				ret);=0A=
> -			goto disable_caam_aclk;=0A=
> -		}=0A=
>   	}=0A=
> +	caam_imx =3D (bool)imx_soc_match;=0A=
>   =0A=
>   	/* Get configuration properties from device tree */=0A=
>   	/* First, get register page */=0A=
>   	ctrl =3D of_iomap(nprop, 0);=0A=
>   	if (ctrl =3D=3D NULL) {=0A=
>   		dev_err(dev, "caam: of_iomap() failed\n");=0A=
> -		ret =3D -ENOMEM;=0A=
> -		goto disable_caam_emi_slow;=0A=
> +		return -ENOMEM;=0A=
>   	}=0A=
>   =0A=
>   	caam_little_end =3D !(bool)(rd_reg32(&ctrl->perfmon.status) &=0A=
> @@ -899,16 +898,6 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>   #endif=0A=
>   iounmap_ctrl:=0A=
>   	iounmap(ctrl);=0A=
> -disable_caam_emi_slow:=0A=
> -	if (ctrlpriv->caam_emi_slow)=0A=
> -		clk_disable_unprepare(ctrlpriv->caam_emi_slow);=0A=
> -disable_caam_aclk:=0A=
> -	clk_disable_unprepare(ctrlpriv->caam_aclk);=0A=
> -disable_caam_mem:=0A=
> -	if (ctrlpriv->caam_mem)=0A=
> -		clk_disable_unprepare(ctrlpriv->caam_mem);=0A=
> -disable_caam_ipg:=0A=
> -	clk_disable_unprepare(ctrlpriv->caam_ipg);=0A=
>   	return ret;=0A=
>   }=0A=
>   =0A=
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h=
=0A=
> index ec25d260fa40..1f01703f510a 100644=0A=
> --- a/drivers/crypto/caam/intern.h=0A=
> +++ b/drivers/crypto/caam/intern.h=0A=
> @@ -94,11 +94,8 @@ struct caam_drv_private {=0A=
>   				   Handles of the RNG4 block are initialized=0A=
>   				   by this driver */=0A=
>   =0A=
> -	struct clk *caam_ipg;=0A=
> -	struct clk *caam_mem;=0A=
> -	struct clk *caam_aclk;=0A=
> -	struct clk *caam_emi_slow;=0A=
> -=0A=
> +	struct clk_bulk_data *clks;=0A=
> +	int num_clks;=0A=
>   	/*=0A=
>   	 * debugfs entries for developer view into driver/device=0A=
>   	 * variables at runtime.=0A=
> =0A=
=0A=
Iulia=0A=
