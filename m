Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BC1C3F68F
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 09:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC8B12176D
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 09:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DdC7YgFM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfLQJL2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 04:11:28 -0500
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:61071
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfLQJL1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 04:11:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGsachyJ2Q97NT5QZuw1rD/uoQsp87fQZspah01plFe4cT5406FeIiu5ABeK2I3trNQjVBwgmQ7HPiekMa1N/ZrmdnZ6pZhLNgymrISJJRfNdMntZVQJecUKW1ITc9iTcDX6hptB2kEeNUnuRfi+cXpUYdm6F1BCDOlpj+rIugjcgppGhj0hNFZs1VLVDWNPjkJ5eYhaATx4gZc71btalrtXudM4/rq6U3FUoR0S9XgHPAPW5XQySDw2XwFSWrR6SOi4Dr0qSldfwtHqOqjTge5ITCK8bkSl3QEZs4L6crpTw6hZXid7qsdcid473eVXun6ZElDGHhMNkaRT3jMbzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHCBa8gRB9OBzU5nYITH/A3Uc31SmwHasrBzudWtsIY=;
 b=Y5fY9S+ubS7o8cPkY9g5gKSJ29zNWpaVpwC3wBAgTTK4n/tHOL6v+c44ltrp3sXNs2nL3nHnSjeVhriLi9tSIj6YeuYr6uG3kp+EsSdUMOVrdewFDesSxl/hgP4WhDThisXElWfjoy7byXjkiVpoJ/I6Ab8dEAaUap4U70W26T+NgusGLOYi6LdR0/dlQChh4XzjiBi0yrlqNd7UyPVR6Xf87S92TTOwx6iEWY+L6FYl8nyBEbCa5sTBfEh2JsomrK4+xTLUJwBewwrMir2xN6nRNGkUTjAYz1siK0MsvcXc8/gXVlS/rP/devybm/hdXPL48SRG8nWdoiQbo99qAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHCBa8gRB9OBzU5nYITH/A3Uc31SmwHasrBzudWtsIY=;
 b=DdC7YgFMeHQsIWZwaMuL6unZyDJJwrApaWudgenRfuaubJivUehLy1Uq/onpFHkXgr7IWweXdKPrDZwuEd2nGOsa4vwD8uu+b7GymMZBh8Si4am3cM6pc8I8o/9Ec47vLw4GVxS43hnra43E59lWx78agjzg6Yhcrujzx0qFHqs=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3408.eurprd04.prod.outlook.com (52.134.4.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Tue, 17 Dec 2019 09:11:23 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 09:11:23 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Adam Ford <aford173@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH V2 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Thread-Topic: [PATCH V2 3/3] arm64: defconfig: Enable CRYPTO_DEV_FSL_CAAM
Thread-Index: AQHVscuAzDa0y7DjIUSGaSZVWPlDjw==
Date:   Tue, 17 Dec 2019 09:11:23 +0000
Message-ID: <VI1PR0402MB3485AB1908AD6B6617CFC08C98500@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191213153910.11235-1-aford173@gmail.com>
 <20191213153910.11235-3-aford173@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c1191099-a0d9-4819-d464-08d782d1169b
x-ms-traffictypediagnostic: VI1PR0402MB3408:|VI1PR0402MB3408:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34086ECE0DF642260E802CD598500@VI1PR0402MB3408.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(199004)(189003)(8676002)(8936002)(81156014)(33656002)(2906002)(86362001)(478600001)(55016002)(5660300002)(110136005)(54906003)(53546011)(7696005)(44832011)(316002)(52536014)(186003)(26005)(91956017)(66946007)(66476007)(66556008)(66446008)(64756008)(4744005)(4326008)(7416002)(71200400001)(6506007)(81166006)(9686003)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3408;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dxx+6F9fO3cShwy50BYL0Ynr7Ge0WEyjrMH9MFJSM7EeqpnhM6hHbmTUTCu12QzpynGJfsMWzjJeAZJ7MMnQWmusmTgY2yY4++qnr2Gp1WzsF5WcDS/LurYzKEfchTq1e2KSGIeWZdrsxRtA59PdDseQ68oglQHzprDzvK/Hs8zaDbwa2vVH0/sQ+mPBDq9EPNbR8YZhvcEHphKdzxZ1VLE8xlX/MfwYZoepa+JBtD0Oh1uxA9e7Rrin9mCC5t1qee17RA9cFTj03NtdND5JxUxFUcQaUv1jLXfYsRTVjuY8yBmW6xp4wJKXLrzU40pcgHRNMIpKTrXzWc81SYzx9p1sd9YRH8Qz3rIIGVLyaXO7gtEKkjxJx3Ad23q+kKGSmNudsETFTsA+L6DWn2+es0R8G2Ij9I47cm4YGVtQ1d9lfTjqAoy3MpY3sd4KJx6H
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1191099-a0d9-4819-d464-08d782d1169b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 09:11:23.3592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: naOS5Wbg2iu7uT9JYkkf1PcNTgpFP+3P8TjeOBD1xtKIeXuRb38jj+2anwU8a5290MPKvW0og1piSOXSKJNVZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/13/2019 5:39 PM, Adam Ford wrote:=0A=
> Both the i.MX8MQ and i.MX8M Mini support the CAAM driver, but it=0A=
So do the Layerscape ARMv8-based SoCs:=0A=
LS1012A, LS1028A, LS1043A, LS1046A, LS1088A, LS2088A, LX2160A=0A=
=0A=
> is currently not enabled by default.=0A=
> =0A=
> This patch enables this driver by default.=0A=
> =0A=
> Signed-off-by: Adam Ford <aford173@gmail.com>=0A=
> ---=0A=
> V2:  New to series=0A=
> =0A=
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig=
=0A=
> index 6a83ba2aea3e..0212975b908b 100644=0A=
> --- a/arch/arm64/configs/defconfig=0A=
> +++ b/arch/arm64/configs/defconfig=0A=
> @@ -845,6 +845,7 @@ CONFIG_SECURITY=3Dy=0A=
>  CONFIG_CRYPTO_ECHAINIV=3Dy=0A=
>  CONFIG_CRYPTO_ANSI_CPRNG=3Dy=0A=
>  CONFIG_CRYPTO_DEV_SUN8I_CE=3Dm=0A=
> +CONFIG_CRYPTO_DEV_FSL_CAAM=3Dy=0A=
This should probably be "m" instead.=0A=
=0A=
Horia=0A=
