Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A88C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 10:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AE532176D
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 10:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="VAUBSWK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfLQKFf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 05:05:35 -0500
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:14919
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbfLQKFf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 05:05:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xrm7srM+Xe4Jr986aos3VVSisI1sEo5bMa6MU6RqfPxv0TfSnJX2rjwIBGAfXmxMMGIZ9pKoIRa3mDqFLGatafMFlhlRKKMk50HgqWMVYfilATVjsnutsLlTLWarG94Nw4wiLv9UcbrY81REziGN8ES+Dqqlnd7oZjg3a+pMoUHQtEP/GrSY1hTGZGfjuwW1Uimx7xpHcFBI/ZopK9os57DclysM4fICkcklaBGj63SmL+kL9e3DiF5mvhHCQeSf/ZtXCFfUEmRZQQpWXkM62U4FMuYbJ2xgjtO9+5QPbtL8+cqb0Sa0MgwC6sf0e36nRNIERKWo3yZo+PD89lmo7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wP5vR514tAMVNEUebFaz/uvXPw9OcdmOfsZXCY63AQ=;
 b=B7761rc88+jirUu2qfr7AZIWSX3mFdSqkLtPu6Lue/toFWetOT+GnNGy9Lj+DklegpcsJpwrV3qPgh9IDqJq5jwVIUDx1ugNQeWyAk8ZYX/A8A039j5J1WJStTb26Hxi0pyvrRbaW8FlNCPWhzITXditZzEvg1SbZqMALYqJv1/RliS+LBxp2qM4rgPpdXagX1aXtqDJyOLOY74iAiJFd7TCcCH6c/aRqp6DNJkJgcxCEO/rSZStIVSlGw9/zBym9BRlylZKvSQrKUZXs1FczzpWt71NNHphB+GlKqo8JoxhXM7a4Iaul6F+xuVetWAaiv2YjBJeKWnZnr3jU50bxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wP5vR514tAMVNEUebFaz/uvXPw9OcdmOfsZXCY63AQ=;
 b=VAUBSWK1TDcPt2Nl+ZXzLiOlaQYyqTmsO2I2/10cnmlH2cHVbAZq5JiUG8XPYpOHWCWHu1JlUjHWxtp4iq/b5/iw7XhhIrfAM6EcD1wqzH+g28SOYIuqFP0FeLKAov313kNh2/wxtBUYnjRKHtQcMgT4f3Ol/zBQ2z6OqRyXXbc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3341.eurprd04.prod.outlook.com (52.134.7.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 10:05:25 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 10:05:25 +0000
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
Subject: Re: [PATCH V2 1/3] crypto: caam: Add support for i.MX8M Mini
Thread-Topic: [PATCH V2 1/3] crypto: caam: Add support for i.MX8M Mini
Thread-Index: AQHVsct+bxOq3Vv9C0WchDcVUZ6qgg==
Date:   Tue, 17 Dec 2019 10:05:25 +0000
Message-ID: <VI1PR0402MB34855AC446EBA2E2C669F75D98500@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191213153910.11235-1-aford173@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: beefb638-4ef7-4143-c4f3-08d782d8a2fc
x-ms-traffictypediagnostic: VI1PR0402MB3341:|VI1PR0402MB3341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB33418F6E399799677111324798500@VI1PR0402MB3341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(66556008)(64756008)(54906003)(66446008)(110136005)(76116006)(7696005)(186003)(316002)(91956017)(86362001)(33656002)(8936002)(81156014)(53546011)(4326008)(26005)(6506007)(558084003)(66946007)(81166006)(8676002)(52536014)(7416002)(2906002)(66476007)(478600001)(55016002)(9686003)(71200400001)(44832011)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3341;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6dNRRyyS8yfCcSgWBdIwXK6HEV6yGiio6v3VSorbGgHC8JP5v3aAAQH5OpOxL927mD+JCICsPlhd7L3qJIgCVvOCob5x4qjv8AeI+0qH7zenaTjvdfIEvTyElov3h2vknXhRta7eDoOuJhraj7sLx18wzLJn7WkrataLfbHGt4dh30QmcsH47Jscw1gmwYIgoXOp4paNfc66WTyLgM7k/9MMkvsrfAhLX1IcB0YQYjKpj1GgaYreZqP7I5vNL1TK4+f56b9erMQt4/6d24kStZzXSZ0KdQbvSNhjiGfJgqsCLyUDR8mmjICeAvb8MVR7AHrOyjMY6GbHmPo1d8/Fe3e2o9a8pfS2wft092MjYmAZEOQFme+DCtYa0/nRN7OAn72jyff5LBlc8E4T8IXehncj+zljmbMYsRzPqYNbLbY1JSwZQZgpZ/BYZVoT7wF0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beefb638-4ef7-4143-c4f3-08d782d8a2fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 10:05:25.3556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tv1rK74cnXYBfUnvN5ibtJGi0le/t8RcscAW+x/oXyhza8oRMIkhaCMKqGzgpUyT4P/McY/MAOhXKUroZ5nc+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3341
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
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
