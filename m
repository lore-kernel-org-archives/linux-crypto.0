Return-Path: <SRS0=5TcX=2G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D898C2D0C3
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 15:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 541662082E
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 15:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qjZW5/0s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfLPPPX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Dec 2019 10:15:23 -0500
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:48998
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728008AbfLPPPX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Dec 2019 10:15:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivb153RFAgzIYrqZBO1s+zGgvrJIjwaLt0L64QJfi7IC9yv9Uban4N5rSqrgr6AJHaGehAJcqM4CO/4IQPmowpZLSp/dXfXIv6aq7m2hW3SKeS/1aSMgGwejfQiGiEDX+U2rUHDJ9LnWH8yt/Yqew5DKPVhRDqnL1cMeiM4bAJQqKEW+PuXP381o3+8/T5MwafHF6fVyvEB3ffrPl93ySD+YwgY5QmDxQJ1EMZic5dQItUGTHGZPEuY9yaGBAn+53Z1qXz0IyfYu/twigJTKHpYWFrxe4tQ3lOPf2AktIZ0vbq9X7kxfRKiE4/+5QfzvRxt7lnJ8c+rsyVAf4Aijvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6MbaWIFwA+Otf0jXkJMmU3vBcJKD8H03ALxUVCXqu4=;
 b=Xe3+aO3vgoYWiV3rGusVV3ISD9hP9fVzSEKT651Wp0h0GmUGOTN7yHLcghnwnQix9pj4FKdrziMC9ovGFWFBUK/ke2hOv9GcWw+8T3SCuWizZAyJn2xnyvSXKty9UQ1OGZP2PrbBZUdS1TFvsrXxaDy3CDc6ClV9SRsrxLOsEQAgnTk5k4kNCIQV4PYROiJYYpLHipD0+S4irMtwxE4ONiim8oIXopd8FXLjUnYtgP3IM6CQXpywvtYE4vvy3JCdvMOWttmwowaC19R8q/Z6VuoMNplQoMHeNe5VjtCENE8khxg8xOdecApZ1IbG640PF0sUhV5i+pO0Vs4n9p+EFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6MbaWIFwA+Otf0jXkJMmU3vBcJKD8H03ALxUVCXqu4=;
 b=qjZW5/0szZdjoUejXFJFOizdL/vQTC2hX35/MUKrRdqq0f5goAF3WLThXOHI5Xa+EovUOyhM3sl8q/JP9pYncAoy6wLr7KFSI8ToIVmdgJF+fxNlct/tHSXZftAH31nJ395xjKjg6Dn1Wx1unf3+RdES8p0y7FAFwRmA1+8CyTw=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB6317.eurprd04.prod.outlook.com (20.179.28.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 15:15:19 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 15:15:19 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Adam Ford <aford173@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] crypto: caam: Add support for i.MX8M Mini
Thread-Topic: [PATCH V2 1/3] crypto: caam: Add support for i.MX8M Mini
Thread-Index: AQHVsct+SXIDv4fpXk+kA2HSOm06vg==
Date:   Mon, 16 Dec 2019 15:15:19 +0000
Message-ID: <VI1PR04MB444575F41B9C8A5E58E666258C510@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20191213153910.11235-1-aford173@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad63df01-e72a-4b80-62fc-08d7823ac35d
x-ms-traffictypediagnostic: VI1PR04MB6317:|VI1PR04MB6317:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6317F787EF456ACBF78BBCC68C510@VI1PR04MB6317.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(8936002)(2906002)(478600001)(9686003)(55016002)(26005)(81166006)(316002)(4326008)(33656002)(7416002)(71200400001)(110136005)(54906003)(81156014)(86362001)(186003)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(91956017)(44832011)(6506007)(52536014)(53546011)(5660300002)(7696005)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6317;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nOT6DQAZgT62Yfc1cJUbVVtRfP7Rtl3OOYQ1/Z6t7Pgrd86snXlMSBZtVku53Nqcqq41xba6PKfIe5wp5/eJZlIQIj65AKVi93H9joMUm5MpQVICljY4RCUgXwtodTYY5sTGig5OTEx1Q1QwngsKplUxsrFEbLxv5aw/vtE10Xu8XshwUcTRCTJdKyhqNvHES7Ci8ew5Br3qdtGqiCiO25JHo2Pdo9nZyX2Gmr1MjnFkxjUEvgVfRErCSLD7B3y5RkaXLShKSTWD/MtDldyAqtAucbNqp5+Mi4vRtfIRuGicpO4qZETC2iUTVQO1z+LzOgmu5miJ6JJYA4pP2jmaFcGPansorjASz1eZtcZaQmTvgnP9MoyDI8bjv0RHIWtOYndTlDIpK21UkBxDbyKjAybmUg1RXrBu0JOgg8kEq2h8mbt59N2b/Tl+p1GaOW8d
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad63df01-e72a-4b80-62fc-08d7823ac35d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 15:15:19.0127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlMhYztTcZyFtr3qlKG6f5spHYh5CW1OBDfRKpUT69x6NI7ocIyFqfIcPlK4ujpuX3EszcDY4GDo5CCSXcrvfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6317
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/13/2019 5:39 PM, Adam Ford wrote:=0A=
> The i.MX8M Mini uses the same crypto engine as the i.MX8MQ, but=0A=
> the driver is restricting the check to just the i.MX8MQ.=0A=
> =0A=
> This patch expands the check for either i.MX8MQ or i.MX8MM.=0A=
> =0A=
> Signed-off-by: Adam Ford <aford173@gmail.com>=0A=
> =0A=
=0A=
For the series:=0A=
=0A=
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
> ---=0A=
> V2:  Expand the check that forces the setting on imx8mq to also be true f=
or imx8mm=0A=
>       Explictly state imx8mm compatiblity instead of making it generic to=
 all imx8m*=0A=
>        this is mostly due to lack of other hardware to test=0A=
> =0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index d7c3c3805693..c01dda692ecc 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -102,7 +102,8 @@ static inline int run_descriptor_deco0(struct device =
*ctrldev, u32 *desc,=0A=
>   	     * Apparently on i.MX8MQ it doesn't matter if virt_en =3D=3D 1=0A=
>   	     * and the following steps should be performed regardless=0A=
>   	     */=0A=
> -	    of_machine_is_compatible("fsl,imx8mq")) {=0A=
> +	    of_machine_is_compatible("fsl,imx8mq") ||=0A=
> +	    of_machine_is_compatible("fsl,imx8mm")) {=0A=
>   		clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);=0A=
>   =0A=
>   		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&=0A=
> @@ -509,6 +510,7 @@ static const struct soc_device_attribute caam_imx_soc=
_table[] =3D {=0A=
>   	{ .soc_id =3D "i.MX6*",  .data =3D &caam_imx6_data },=0A=
>   	{ .soc_id =3D "i.MX7*",  .data =3D &caam_imx7_data },=0A=
>   	{ .soc_id =3D "i.MX8MQ", .data =3D &caam_imx7_data },=0A=
> +	{ .soc_id =3D "i.MX8MM", .data =3D &caam_imx7_data },=0A=
>   	{ .family =3D "Freescale i.MX" },=0A=
>   	{ /* sentinel */ }=0A=
>   };=0A=
> =0A=
=0A=
