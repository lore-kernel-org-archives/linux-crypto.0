Return-Path: <SRS0=W2UY=RH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EFEC43381
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Mar 2019 18:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D2920675
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Mar 2019 18:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eXR8x68N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfCDSNY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Mar 2019 13:13:24 -0500
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:50104
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfCDSNX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Mar 2019 13:13:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usmKllLOihlIjDso4xpyYgGvJbcRVHLABJhQkRH/uwQ=;
 b=eXR8x68N4mDmtcPNlrjje0tgSmary6keFYm3Ls01FVI2E+cmuXj1Z1DTNTDu7aeHSsStCr0ywJ3tZZP8TrKrP/zuzJxM2OCsjGF+0/zw9dDUrIgsDNrXapnnfA4/piD2jF4c1gL+Wi5rqo212fWQkiaf5ynxOkil/txuayVe9h4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3631.eurprd04.prod.outlook.com (52.134.7.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.19; Mon, 4 Mar 2019 18:13:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1665.019; Mon, 4 Mar 2019
 18:13:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Chris Spencer <spencercw@gmail.com>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
Thread-Topic: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
Thread-Index: AQHUypZsrSD4izM7BUuBqlVaxZEyMQ==
Date:   Mon, 4 Mar 2019 18:13:19 +0000
Message-ID: <VI1PR0402MB3485DD524A658329D51258F498710@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk>
 <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRTvXVU7vRicF=mR7xxCj=p+Sqj3aNnL2TezLZXhHFkvzA@mail.gmail.com>
 <VI1PR0402MB34857504705A898A59085B4B987B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRRcaiGAaKkUs2Tw_aZD4QKHtJMFLwkfu92pMu3jCBo5gw@mail.gmail.com>
 <CAGUNXRTR3=xbj-scY=t4jqErcxQTsWHJM=sVESKZxNVHrLB_0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caf178c1-11e3-4338-292d-08d6a0cd14d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3631;
x-ms-traffictypediagnostic: VI1PR0402MB3631:
x-ms-exchange-purlcount: 1
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB3631;23:Ya0vJOblGTM9kr2GYnzw9+RowfZIWKUhQBiWf6X?=
 =?us-ascii?Q?zjIXpKZuIfUoqkBtYe1J6TJISVE9byBgpJdxXNGYsHc4d1uNjPl3VpcYBi60?=
 =?us-ascii?Q?fGQdwl3zwq3PrdkO5lDU3un7gUmwwXX5u4p/cQHeEevNpFbulD/P9oB37w78?=
 =?us-ascii?Q?Xym41+ljzSymLjULfgsScRLL0ELmTk2abb1cHqgJmk5nPo8DH7NThfzZYeBR?=
 =?us-ascii?Q?uYnpXDgx1XnQrHMCOiANewNPxF5iyztkJ2upcOdzenrYG/KDArLHbjSKWMQN?=
 =?us-ascii?Q?vENGiHiR7RZt/O1rbqqTkU60DWe3KzlqcP3H5jdsd/Q4JUo+6/N6SDQJqb4L?=
 =?us-ascii?Q?GoFYWO5lnyzWrxZHk+mTyuCVKYjkk6aANc+csStuArrA/NNCL+B4skOyeC/d?=
 =?us-ascii?Q?KFCSb+IPqcTqPmoIon8Q0gXIpDrJ9fEpSCxn156/FVw4SsPJnINMLA7KI6/6?=
 =?us-ascii?Q?iCt90MxY1VdtQeBlYGsg3oiJoegcr6C/Kct77DDyiuK9uM4gKITEglWxue3/?=
 =?us-ascii?Q?RnOBpg2PAMrLT6ZvQrlMYWKl1ePNxHDD2wXBp3wpBAULYfrUCJ7CYg8fzXh2?=
 =?us-ascii?Q?Z7hMojoC45Pk8xUUAQTeejGAIG6UQtdrCaTxUAfTxIs9u4YcNpgakKkNsSOE?=
 =?us-ascii?Q?wMmBZNnKNc3pXos7zqN8n1lLHrkiZvinksRE0pOM3smWbqfnvFN5adPdmcJ2?=
 =?us-ascii?Q?MfSBlMAo9dW9OfihDVaoTJ6cISaNfb+dnVVi+/cZuat4sLTjb9ATq3C0PWxW?=
 =?us-ascii?Q?Yq3nCZcEYjEpVjdqAdncE/bjOJQRp4FLUnbN9FFDe2qVFiM/sR08NzNyehYm?=
 =?us-ascii?Q?8sm5C9Tkhsn4OpJNuiRzzt2P7iX766Xxp/6GhBRDm770FiwQL4sfcWkYhJD4?=
 =?us-ascii?Q?ZMkG+eG356jnOCkFGMydSEHllD4CJUEo0pnuIUq0y4WGQwr8wQH9i2uiSZX2?=
 =?us-ascii?Q?PmqhvdLyM7O5NBHL68LMpwvDiZ0Q3qcRCsv3BDs6p7hmVeMrJ+thR2YVwaZk?=
 =?us-ascii?Q?1uSCfjLSMireFrfVElzKF09TXdESTqq5xO+KzDAz1Tkxxq2wrsMYlqGFkj/R?=
 =?us-ascii?Q?f+5BLeWdIbZLYpdRqLdl7rG50txTOnwbzGlN383nG/LyXWCOw98+N5YHv8CN?=
 =?us-ascii?Q?Av0I5HU2gK6pxAasTTpufgnVyqvzXaI651KzlnWNXSrgHoXqbtXXP65lmGCg?=
 =?us-ascii?Q?HdaLaKCAtf/gtvI2RvEBLX7s3RQjyXByccHrBO/XB9PuRLWAysAPyke6fon9?=
 =?us-ascii?Q?2y/SLbEBVpRMW0Hv7Orgm3qiA+T9+wmF+8SC8bY7M0PT0bjemTDmEEVh27ah?=
 =?us-ascii?Q?9a0yBuuOq1fwn0fWCV9chRiTEKqnDiuMq/HwZkewStmJD?=
x-microsoft-antispam-prvs: <VI1PR0402MB3631253911BAE91FCEECCCB898710@VI1PR0402MB3631.eurprd04.prod.outlook.com>
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(346002)(376002)(366004)(189003)(199004)(54906003)(5660300002)(52536013)(229853002)(4326008)(93886005)(8936002)(8676002)(55016002)(6306002)(106356001)(305945005)(9686003)(74316002)(81166006)(81156014)(33656002)(105586002)(6246003)(6916009)(14444005)(966005)(256004)(1411001)(14454004)(478600001)(25786009)(68736007)(71190400001)(71200400001)(97736004)(316002)(53546011)(6506007)(186003)(102836004)(86362001)(26005)(76176011)(2906002)(3846002)(6116002)(99286004)(53936002)(6436002)(7696005)(7736002)(486006)(476003)(44832011)(446003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3631;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2geKSiFXINIkS+Idrl9+bP15w9virg46+pntgHQQYY+0I79FLkkxjKFD/uth0tF20HtALCNIMCgHxkKoYprnT5s2DXTkpfHFl/LlxAdYLtkTBQVovben103UkL+f64EkSwRqX/K9QI1822Ov5k3G7kDEpkCDZQ+Nrq6EmQT/dfuPMVI2jjcmpnTQzpHYSqtGykJTrRhZ26aHki6BZ5ztyXG+N8ZCswshPw/HOgVJkz2cR70ftDdd/dX7+diKTSmkHByL0ZGHOMAbKks63+xoEbmb6p5/2ZHW0RoBgjPE59Vk5mU+cYhQAOCeg/uhh7gYf3jH8DialrLvYszeY3lb4pXg3zWUoAl5IzQJUAAo0X1L5hXDHEHjSmm45/ck/4CV+5mDFhDKgUh6D40hX02Lp4Bey42pD8bla0Unx7a0v9s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf178c1-11e3-4338-292d-08d6a0cd14d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2019 18:13:19.6328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3631
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/28/2019 1:34 PM, Chris Spencer wrote:=0A=
> What I have found is that if I set virt_en =3D 1 then the RNG is able to=
=0A=
> initialise correctly via the DECO. The register values I am seeing=0A=
> are:=0A=
> =0A=
> comp_params =3D 01914201=0A=
> scfgr =3D 00000001=0A=
> =0A=
> So:=0A=
> VIRT_EN_INCL =3D 1 & VIRT_EN_POR =3D 0 & SCFGR_VIRT_EN =3D 0=0A=
> =0A=
> I don't have the i.MX8 security reference manual so there's only so=0A=
RM should be available from here:=0A=
https://www.nxp.com/webapp/sps/download/mod_download.jsp?colCode=3DIMX8MDQL=
QSRM&location=3Dnull&appType=3Dmoderated=0A=
=0A=
> much analysis I can do, but it seems that virtualisation is enabled in=0A=
> hardware without the registers reflecting that appropriately. If I=0A=
> patch the TF-A to set SCFGR_VIRT_EN =3D 1 in the same place it sets=0A=
> CAAM_JRxMID =3D 1 then everything seems to work, but I've got no idea if=
=0A=
> that is an appropriate change to make.=0A=
> =0A=
RNG initialization should work in both cases.=0A=
=0A=
The root cause for the failure in case virtualization is disabled is probab=
ly=0A=
the lack of setup of DECO DID registers (offsets A0h, A4h).=0A=
=0A=
Section "Register-based service interface" mentions:=0A=
"But before requesting a DECO, software must specify the DID and SDID value=
s=0A=
that will be used when executing descriptors under direct software control.=
 When=0A=
virtualization is disabled (SCFGR[VIRT_EN]=3D0), these values are specified=
 by=0A=
writing DID and SDID values into the appropriate DECO DID_MS and DECO DID_L=
S=0A=
registers."=0A=
=0A=
Horia=0A=
