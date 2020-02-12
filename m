Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB836C352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 19:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F7B82168B
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 19:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="abiDbTK2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgBLTvv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 14:51:51 -0500
Received: from mail-eopbgr130072.outbound.protection.outlook.com ([40.107.13.72]:64420
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727361AbgBLTvu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 14:51:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1vWHeucYVCNNxWXeFeI1Y2GI4F0cDfDYE9T1dKAeH2ye+pgAckpyHmw3XkiWZVQixGqYNnzlSH1v87oZvzAynXMNQeEtfG/bjRow6gY8i5ee9hUjl8UNwT9kb6HvEzR+U2sYMXr3L4oPTDM+fn9vGWN58oKswswRjNCrodg5spDyLanTfSKyeVhK9XG7rSZXdQ4O7KsO3TKyrdThczS+DLQZsk779LY4AqVYTW+a6eytR6Sra8OrPSaKlRfftw7FF8nN/k8Vpv/m3pP4pguGSLfl4z3rr0GKdBzzYPSbzU36jfcup9n5dKBSJQpYJX7+Q9xfapiF+6YMSg0AWU9iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ks9yfFTA9KOmKycy+bzBYnJWLtmP0r+eULJipOEHbL8=;
 b=EldSVlKom/pPoYPS7B4vnAxvlcWGsJdNOWy91Udd6Ak3fV25/8AMqjTjanO9Mzs0ozIyjsL/oi0r044pStRKkfCWmerGe8m83D51DEIL0GzN7Zw6fHZMf0QBWEUf9OQIQyKk0JRBo3vBCp0N+ECwYvHDoztfs5vLAhKkhgxsKGgvklfCVPgsb35PVi+AnHPhjxvTh2lTRVcxpi7jH/dcpQsuSUOROiguHPZnw5pfc06nYfoeiC4+o/SmXzUYjfoWBt6tdLaXmmdUNB605z5rT3Yda6qKK1LH8u48nFMJxti9b01Tk8yqLw57f92uB92jmMaw0Kvwn3XVVpee9V/zIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ks9yfFTA9KOmKycy+bzBYnJWLtmP0r+eULJipOEHbL8=;
 b=abiDbTK2eh6kQxQrNgCKQnyS+kyx+PMzTwD8bf6yEDuq5rz0TGIR+yX4WPrdpG2blMyA7UvpD2w/m7IEoaUEjNOehIhcBKloUWfEQdS9CfOBZoEM2wPKagVP6oS34I+7sMPZSTN4cWaH8CdkbsOu6CVp1uCV2WekO2UdPI7196w=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3392.eurprd04.prod.outlook.com (52.134.3.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 19:51:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 19:51:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] hwrng: imx-rngc: improve dependencies
Thread-Topic: [PATCH] hwrng: imx-rngc: improve dependencies
Thread-Index: AQHV3CyZf46rLUY5mEWMn5o+blkpmA==
Date:   Wed, 12 Feb 2020 19:51:46 +0000
Message-ID: <VI1PR0402MB3485267DA0BBAD58556611D1981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200205140002.26273-1-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: af489882-d007-422c-c873-08d7aff4fded
x-ms-traffictypediagnostic: VI1PR0402MB3392:|VI1PR0402MB3392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB33928424A28E6988FE2D7572981B0@VI1PR0402MB3392.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(199004)(189003)(66946007)(53546011)(26005)(52536014)(186003)(91956017)(76116006)(44832011)(316002)(71200400001)(478600001)(55016002)(9686003)(6506007)(8676002)(81166006)(8936002)(110136005)(4326008)(54906003)(81156014)(86362001)(2906002)(33656002)(66446008)(66556008)(64756008)(66476007)(66574012)(7696005)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3392;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zmCaLrnJcMFdfggpSiuz5ofhWtYP6hBOtxtiHhRwZNIoRhRiEmvWzFL9o9xESnqTkL4LHfL32U5OrIfPTYgEaYUBN6tbtYmq1Xwd+i40lxQghqX2j48WrkII1q/0bVDm2kJYTez4vP9aYyiZJ09ynlJN9VZqe/glRzASWAbU5+00+/6aFtB0VsgEyhdO6R3DzyE93f2lrzToLIGhh7e2CUS7meqMubTghZ5AiJCVbTVO6ArszDY+T2tI98eN4YxbBEaMPuvfIiGXK7C9SIdEOGg0j7cp/JrOlQckr/7KPG2aHZTGeJEfBd064GCtr+6/yG5FZzFTIXcalpuOnM/cL9SlGWolOt/vTdUvxyN+v6bTRNzJbf4T9Il47BV7A5cWjSYRVbxvO4KAJ3rL087kfJPEXFB4/lhS3618Q4g0cjQj/IvYHCHCMud7+RTgIq46
x-ms-exchange-antispam-messagedata: BJ87Nj/gGWrtNxDyJV/LWsSivhA90ZNR6UxrlB92SWmC1OGPHsEXFTxNzkQbWhCBKJJ6nc74ptuuGKPInzmrBvDVY8iIhgrb8sfXHEpWlWMVFJ6typFuH1VuNy+rI84Wnt23HjOG2v6dBWk0pDDepA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af489882-d007-422c-c873-08d7aff4fded
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 19:51:46.1985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lS7fUfGk/BtsRPZTRPslNCNT9NNq7T0GJeXa46fk95JygK8r1OFmaZ333tWV5tsgvxK3lHraIVnh6Q5E9iOotg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3392
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/5/2020 4:00 PM, Uwe Kleine-K=F6nig wrote:=0A=
> The imx-rngc driver binds to devices that are compatible to=0A=
> "fsl,imx25-rngb". Grepping through the device tree sources suggests this=
=0A=
> only exists on i.MX25. So restrict dependencies to configs that have=0A=
The driver could also be used by some i.MX6 SoCs (SL, SLL),=0A=
that have a compatible rngb.=0A=
=0A=
Actually i.MX6SL has a rngb node in the DT, but unfortunately it lacks=0A=
a compatible string.=0A=
=0A=
I am planning to address this short term.=0A=
=0A=
> this SoC enabled, but allow compile testing. For the latter additional=0A=
> dependencies for clk and readl/writel are necessary.=0A=
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>=0A=
> ---=0A=
>  drivers/char/hw_random/Kconfig | 3 ++-=0A=
>  1 file changed, 2 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kcon=
fig=0A=
> index 8486c29d8324..17fe954fccde 100644=0A=
> --- a/drivers/char/hw_random/Kconfig=0A=
> +++ b/drivers/char/hw_random/Kconfig=0A=
> @@ -244,7 +244,8 @@ config HW_RANDOM_MXC_RNGA=0A=
>  =0A=
>  config HW_RANDOM_IMX_RNGC=0A=
>  	tristate "Freescale i.MX RNGC Random Number Generator"=0A=
> -	depends on ARCH_MXC=0A=
> +	depends on HAS_IOMEM && HAVE_CLK=0A=
> +	depends on SOC_IMX25 || COMPILE_TEST=0A=
I guess SOC_IMX6SL and SOC_IMX6SLL will have to be added.=0A=
Does this sound good?=0A=
=0A=
Thanks,=0A=
Horia=0A=
