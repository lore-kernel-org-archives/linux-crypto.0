Return-Path: <SRS0=KDyu=3C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE62C33CAD
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 14:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46811207E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 14:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BVjuQ4zs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgAMOKy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jan 2020 09:10:54 -0500
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:6642
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728734AbgAMOKy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jan 2020 09:10:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brJi9jpCTOsF4GOoTyE/sFgG+qn6QAFDxrGiIeVbVo8Dc7zc5sZxQYFhR7R1Vgw5HCHSFvqqF8SFy6dVhnqqoR5My1H+2OAFe6/fQ63PO9G6nY91M+q6On0arBIQtlNV66txY3SnJXuQuvIVfriLcYRN63NNJ05XgPGsEg5cCqvVXTYFx0h1qVAsQMYsc+vgQM3LCNIL1CE2x5EFmv+F5hEbGzcV3tEOeH/2KxfErcx50mtuz26mxDv5v9nDCuRjYH8r0JYmHz+RxaZBGpCpBfiZ4tE8BlQXCPEqiaBhjoeoSp0AHZw4KlbpeTH62E4GHo1zMWA+EM/TM0/MOFKYDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9DMPCovZ+xXPYNT7l96Ad1GW7sy5NoWEhcnlbNAhBE=;
 b=gIlman79Fy/D267HKTe5ruX7/pjn6MNrnaGJV07hbm70ZEYaxb6xgCWiMEDdRyhaPJls7VWSghfQ9WB/c7FhZqR0TwsW+R4TUQUHsRXGjzYbYj4Ql45wIWSw+ZFyy34AyXogUyP/A9VHDCAOTR/7UZ3hwbM04rOWZJjuIeNnc4fhgqnH636Rw2Tjtf2GvHqC5eToZ52rafWC7OzZpUJeXN/6OKNh/++X3Xi4HCRlY6RD+oEQrtHF2/UN77bZHfp8mRxdaX18pxeqYP8oNAZoUSHRBwJvdnAw+srcGjzruKOfjlCtWUSpYvECi/Gj8WLCZuvcvM6fgzRxRnCNPFg6iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9DMPCovZ+xXPYNT7l96Ad1GW7sy5NoWEhcnlbNAhBE=;
 b=BVjuQ4zsEmQyvh1/OPZ50/8iR1WraJjOh7uuOI0Ijdhc0s3jlY07WHAEOulgZrDJDgPkJdLnn62J/8mnucD9pWQL6YTV8fRsGa84HcgnqA452O++kiC6JfCNOUuVKDWR6ukkVEePKz+2i32Ka4HJH+P8UbYAwuKAxZEHARGscN4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3918.eurprd04.prod.outlook.com (52.134.16.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 14:10:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 14:10:51 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 7/7] crypto: caam - limit single JD RNG output to
 maximum of 16 bytes
Thread-Topic: [PATCH v6 7/7] crypto: caam - limit single JD RNG output to
 maximum of 16 bytes
Thread-Index: AQHVxjovOVxhRz2BlkaaDb9wDSI3Mw==
Date:   Mon, 13 Jan 2020 14:10:51 +0000
Message-ID: <VI1PR0402MB3485E327703191780AC68BFE98350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-8-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 939ab4a3-7d0e-4645-537f-08d798326555
x-ms-traffictypediagnostic: VI1PR0402MB3918:|VI1PR0402MB3918:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3918CDC682C82D71124350E998350@VI1PR0402MB3918.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(54906003)(44832011)(110136005)(71200400001)(186003)(2906002)(53546011)(8676002)(81156014)(8936002)(33656002)(6506007)(81166006)(966005)(76116006)(66946007)(52536014)(66476007)(316002)(64756008)(55016002)(91956017)(86362001)(45080400002)(478600001)(4326008)(7696005)(26005)(66556008)(5660300002)(9686003)(66446008)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3918;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t4v/B52QhFFj8FojVD2QwwFwYtgPrZcOqEYTUFNA7Rlt+txDSGUHOrOZbFY+bmJDoOWLDg0WG9ePfXLu81r4gvFyIU45T02hHtZ7RCWRMkETlg8cxHS8CULi37Sa4aLnBp7AXS6JDdNOMzZmORrW3Df8vPJvCFu5ehVT5vSJbEr7f0flWFfmnEwiHqxNWXK/0KUrnS3BuKmFxR5F6KRSQIbueV+qxnM1BcAsaHmdu+w7RkTR1RrxeVvTzdEoa20p5vBwUybq/9f3/AkcNubsLcASXVe5LhCqbVpZSgp0997ZGZQD87Y3OdpUX8wgWBayMc2RbHPRMPQX0/O4S9Q/2bA17F0KvvHyauxP7wysqBKKxv2iKtGoiANHz9x+fQ+MxkDQI/YJEGlbytj5oEzhPSLlcgr4G04ivjrF7dLum4WRX9TBC9rSHRsBbs3liEwY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939ab4a3-7d0e-4645-537f-08d798326555
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 14:10:51.0402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DFTuM6SiU06MvKw1zU32GLZdXFtOxBMQRYO5c5kmxB2tWH0vQ96KKpeOxBv1nHjIji2LUrMPbC+XNx2pZlA/JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3918
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/8/2020 5:42 PM, Andrey Smirnov wrote:=0A=
> In order to follow recommendation in SP800-90C (section "9.4 The=0A=
> Oversampling-NRBG Construction") limit the output of "generate" JD=0A=
> submitted to CAAM. See=0A=
> https://lore.kernel.org/linux-crypto/VI1PR0402MB3485EF10976A4A69F90E5B0F9=
8580@VI1PR0402MB3485.eurprd04.prod.outlook.com/=0A=
> for more details.=0A=
> =0A=
> This change should make CAAM's hwrng driver good enough to have 999=0A=
> quality rating.=0A=
> =0A=
[...]=0A=
> @@ -241,6 +241,7 @@ int caam_rng_init(struct device *ctrldev)=0A=
>  	ctx->rng.init    =3D caam_init;=0A=
>  	ctx->rng.cleanup =3D caam_cleanup;=0A=
>  	ctx->rng.read    =3D caam_read;=0A=
> +	ctx->rng.quality =3D 999;=0A=
>  =0A=
AFAICS the maximum value of hwrng.quality is 1024.=0A=
=0A=
Any reason why it's configured to be lower, now that CAAM RNG-based DRBG=0A=
is configured to reseed as requested by FIPS spec to behave as a TRNG?=0A=
=0A=
Horia=0A=
