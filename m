Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CD0C3524D
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 14:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 187AA20674
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 14:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZM5vhdmH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgBDOTn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 09:19:43 -0500
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:18190
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727218AbgBDOTn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 09:19:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGtVj6NkGUr/nDFgaJ3Tr5aGkCWbvQOqgrItUQurIsqTiGwES7XLpIJNFhLQrz02Wy7MKROL8LMFwvGCD+n2KZ5XyOiHVjG7uec+EsscNTLGlwzP5Hl6o96GawLU50yNMxsg6D4c/0tWUF/BAyZUUXyRS53Sbisgiz6MPlKvH1LYLGvQThxuIMaa2EW3I9u6HTg2N+j8tA+SEZ1yaKFha6Gsm/PbhJo9BgY3F9nOFh5/XGw0MTNrDYx5sKjzBwYCNlErnherX8/quwILkMpo5qIQhPVG57LETcTLoGiPwd5A3aE0QzGdjp7tlSSukInD6n7xsWDD0nazFonN3037hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F05s4kBN+MJ9L76cbtE8tqjeFfQAyJRLYxtlhGgVBHw=;
 b=DjtiVg6D37CqguxB9LtdrHEmWA1Rx7VlJu+aJtfXCUYKguN2v1r7Krv60SNFN5CyyEYmegqg18kW/Ms4GMPQPTK2pFXhBIRg022DzndpFs0TiZMuotLswTZ0JmnSM5JylHzkd2Lgd9HDvUNV7I6HfnhDtUKNQxtULM62ljpy3VWOYb2BvVKPWStOaQJFePFYQh2o9kExg/0TU1tP6V+g3rv2WPQI/ZzYVitQQKSMcWHFPy00LpH12L1DSbUOSlos3lqeJoBPHqFV7oY2BJyMH1EaynwcQVonHpvJ9hPeMAE3MdWYgCz1ZdbymikUBw+Ohb5ahAJSqLlMIcPPS58DzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F05s4kBN+MJ9L76cbtE8tqjeFfQAyJRLYxtlhGgVBHw=;
 b=ZM5vhdmHqWEjfp3NiUkIT3bAOq+Px4OBlJ0diH6eUBDtNHcmi+Wi5iL9G3E1b2UgSmpPO0PkFJbHnMzGOU655DWzX6+0hDurAs8nbk8T8f1u6KTokJhkkXoJ0eYYGdcy9bZnPHqVa375ed3uNulnQWzzrRgbZrox+zVEKh++2ZY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3437.eurprd04.prod.outlook.com (52.134.3.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Tue, 4 Feb 2020 14:19:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2686.028; Tue, 4 Feb 2020
 14:19:37 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [EXT] [PATCH v7 8/9] crypto: caam - enable prediction resistance
 in HRWNG
Thread-Topic: [EXT] [PATCH v7 8/9] crypto: caam - enable prediction resistance
 in HRWNG
Thread-Index: AQHV1TLWj2UNcbRh6Eu3gG1qYOVUqA==
Date:   Tue, 4 Feb 2020 14:19:37 +0000
Message-ID: <VI1PR0402MB34851402EEA516586C9B815898030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-9-andrew.smirnov@gmail.com>
 <882f76df-e5e4-0efc-20bc-e9bc3efd80f0@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10c7e026-7146-4d29-5990-08d7a97d4419
x-ms-traffictypediagnostic: VI1PR0402MB3437:|VI1PR0402MB3437:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3437BA27D2CB89564BB62B8198030@VI1PR0402MB3437.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(33656002)(186003)(2906002)(7696005)(86362001)(71200400001)(966005)(81156014)(81166006)(8676002)(26005)(4326008)(44832011)(8936002)(316002)(66556008)(54906003)(110136005)(53546011)(6506007)(478600001)(52536014)(5660300002)(76116006)(91956017)(66946007)(64756008)(66476007)(66446008)(9686003)(55016002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3437;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KahBTWCjNw/RwRu6ANdjvLu0fmFh2OzbnEdP6O1ZHN+T0sf25LFXBf0H08Cz3zjUCQ+Q6N0AJ+qDiknIqICwd9ho18us7YN3kePRRSe2SBVXuTAeHqirh1MPqk+Zqz5Thc7pQ+nBxTXFvBg3kuuXmyj4TrS2A4BQm2NmcyCOSt38U9fSsxgI9agsYq9BUs3M+yA0QxcJO/WbnNtfK9kM5mYVN+iL195Ck8GTuK5oXb6KG6IQUyGt+UdG75DJ1tTB5Xkrit93o8tjNTNFzd2ZgrXF0lt+H3UgW0LW43PmHKLr45rE7J67KsX5hYviOFfeomFPUZDVbieIdgxxwHw5vjbWJ6R8POEo6hfQkFjGxQJ9A+4qSv5U42Lhl+Pszw7ddPTal+geDoWZT0+Rij+j7n+RSldFVWIa0DW9RnRKsOL4ZwI/YO5Z/HrcpIkVm+HjEM2EqbAars0M20tnP+ML8sJdpAprLOk+zsESTjMqr8WpULh6isJSCQe4x5PQxqFt/IfQsExPXl8ysLoM9Wx3tJlPQtV7W36yYPKiFoVjPepszlui6bgyOgVcXc3CWABc
x-ms-exchange-antispam-messagedata: zueClPIw/cqugh1jA8hIprxhKjG51k74TV1k4H2VzxbtLtoL8u5KJKBzJ50RfshFjT0Ghy66Bd8eWG3g1K7DbYlUEu9yZMi7/zLAOqXzXTqtntggxo7KT/+MadzNn6j3Myxp8DAxQ5a+c9TmoS0bbg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c7e026-7146-4d29-5990-08d7a97d4419
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 14:19:37.3133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Icx4ou3S329EvrAIp2CD8gpcfXlm0I/o9bn/D4JAwF8M259/MHJg4W9tklwOJe33G3bxIbxdm60YUlWbGWn9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3437
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/4/2020 3:09 PM, Andrei Botila (OSS) wrote:=0A=
> On 1/27/2020 6:56 PM, Andrey Smirnov wrote:=0A=
>> +static bool caam_mc_skip_hwrng_init(struct caam_drv_private *ctrlpriv)=
=0A=
>> +{=0A=
>> +       return ctrlpriv->mc_en;=0A=
>> +       /*=0A=
>> +        * FIXME: Add check for MC firmware version that need=0A=
>> +        * reinitialization due to PR bit=0A=
>> +        */=0A=
>> +}=0A=
>> +=0A=
> =0A=
> Hi Andrey,=0A=
> =0A=
> Please use the following patch as a way to check for MC firmware version.=
=0A=
> This should be squashed into current PATCH v7 8/9.=0A=
> =0A=
Btw, this depends on the fsl-mc bus patch that adds fsl_mc_get_version()=0A=
bus: fsl-mc: add api to retrieve mc version=0A=
https://patchwork.kernel.org/patch/11352493/=0A=
=0A=
As already stated, I would like to take the fsl-mc bus dependency=0A=
through the crypto tree.=0A=
Greg, Herbert - are you ok with this?=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
> -- >8 --=0A=
> =0A=
> From: Andrei Botila <andrei.botila@nxp.com>=0A=
> Subject: [PATCH] crypto: caam - check mc firmware version before instanti=
ating=0A=
>   rng=0A=
> =0A=
> Management Complex firmware with version lower than 10.20.0=0A=
> doesn't provide prediction resistance support. Consider this=0A=
> and only instantiate rng when mc f/w version is lower.=0A=
> =0A=
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>=0A=
> ---=0A=
>   drivers/crypto/caam/Kconfig |  1 +=0A=
>   drivers/crypto/caam/ctrl.c  | 46 ++++++++++++++++++++++++++++---------=
=0A=
>   2 files changed, 36 insertions(+), 11 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig=0A=
> index fac5b2e26610..d0e833121d8c 100644=0A=
> --- a/drivers/crypto/caam/Kconfig=0A=
> +++ b/drivers/crypto/caam/Kconfig=0A=
> @@ -13,6 +13,7 @@ config CRYPTO_DEV_FSL_CAAM=0A=
>   	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE=0A=
>   	select SOC_BUS=0A=
>   	select CRYPTO_DEV_FSL_CAAM_COMMON=0A=
> +	imply FSL_MC_BUS=0A=
>   	help=0A=
>   	  Enables the driver module for Freescale's Cryptographic Accelerator=
=0A=
>   	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4).=
=0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index 167a79fa3b8a..52b98e8d5175 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -10,6 +10,7 @@=0A=
>   #include <linux/of_address.h>=0A=
>   #include <linux/of_irq.h>=0A=
>   #include <linux/sys_soc.h>=0A=
> +#include <linux/fsl/mc.h>=0A=
>   =0A=
>   #include "compat.h"=0A=
>   #include "regs.h"=0A=
> @@ -578,14 +579,24 @@ static void caam_remove_debugfs(void *root)=0A=
>   }=0A=
>   #endif=0A=
>   =0A=
> -static bool caam_mc_skip_hwrng_init(struct caam_drv_private *ctrlpriv)=
=0A=
> +#ifdef CONFIG_FSL_MC_BUS=0A=
> +static bool check_version(struct fsl_mc_version *mc_version, u32 major,=
=0A=
> +			  u32 minor, u32 revision)=0A=
>   {=0A=
> -	return ctrlpriv->mc_en;=0A=
> -	/*=0A=
> -	 * FIXME: Add check for MC firmware version that need=0A=
> -	 * reinitialization due to PR bit=0A=
> -	 */=0A=
> +	if (mc_version->major > major)=0A=
> +		return true;=0A=
> +=0A=
> +	if (mc_version->major =3D=3D major) {=0A=
> +		if (mc_version->minor > minor)=0A=
> +			return true;=0A=
> +=0A=
> +		if (mc_version->minor =3D=3D minor && mc_version->revision > 0)=0A=
> +			return true;=0A=
> +	}=0A=
> +=0A=
> +	return false;=0A=
>   }=0A=
> +#endif=0A=
>   =0A=
>   /* Probe routine for CAAM top (controller) level */=0A=
>   static int caam_probe(struct platform_device *pdev)=0A=
> @@ -605,6 +616,7 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>   	u8 rng_vid;=0A=
>   	int pg_size;=0A=
>   	int BLOCK_OFFSET =3D 0;=0A=
> +	bool pr_support =3D false;=0A=
>   =0A=
>   	ctrlpriv =3D devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);=
=0A=
>   	if (!ctrlpriv)=0A=
> @@ -691,16 +703,28 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>   	/* Get the IRQ of the controller (for security violations only) */=0A=
>   	ctrlpriv->secvio_irq =3D irq_of_parse_and_map(nprop, 0);=0A=
>   =0A=
> +	np =3D of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");=0A=
> +	ctrlpriv->mc_en =3D !!np;=0A=
> +	of_node_put(np);=0A=
> +=0A=
> +#ifdef CONFIG_FSL_MC_BUS=0A=
> +	if (ctrlpriv->mc_en) {=0A=
> +		struct fsl_mc_version *mc_version;=0A=
> +=0A=
> +		mc_version =3D fsl_mc_get_version();=0A=
> +		if (mc_version)=0A=
> +			pr_support =3D check_version(mc_version, 10, 20, 0);=0A=
> +		else=0A=
> +			return -EPROBE_DEFER;=0A=
> +	}=0A=
> +#endif=0A=
> +=0A=
>   	/*=0A=
>   	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,=
=0A=
>   	 * long pointers in master configuration register.=0A=
>   	 * In case of SoCs with Management Complex, MC f/w performs=0A=
>   	 * the configuration.=0A=
>   	 */=0A=
> -	np =3D of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");=0A=
> -	ctrlpriv->mc_en =3D !!np;=0A=
> -	of_node_put(np);=0A=
> -=0A=
>   	if (!ctrlpriv->mc_en)=0A=
>   		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,=0A=
>   			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |=0A=
> @@ -807,7 +831,7 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>   	 * already instantiated, do RNG instantiation=0A=
>   	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.=
=0A=
>   	 */=0A=
> -	if (!caam_mc_skip_hwrng_init(ctrlpriv) && rng_vid >=3D 4) {=0A=
> +	if (!(ctrlpriv->mc_en && pr_support) && rng_vid >=3D 4) {=0A=
>   		ctrlpriv->rng4_sh_init =3D=0A=
>   			rd_reg32(&ctrl->r4tst[0].rdsta);=0A=
>   		/*=0A=
> =0A=
