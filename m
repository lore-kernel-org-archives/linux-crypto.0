Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BB5C35E04
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 19:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A004F2082F
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 19:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Wd9JVSnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgBYTNn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:13:43 -0500
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:28609
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728443AbgBYTNl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 14:13:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKHODpIm8zHzSxJJ5mFlTFN0/1c5Q8O7YSIm/ZsKT7Gw2IHcbAZHMYf1eDEIiKw0UeKf/AOS14RfHB6LbimT//i8FF7C3Z4X4knzPmhCnoeXisWBHpcGH3E+6CEeuI/aofqRurE3z7FyyULDEXpKQ1ZDmdU9XpS8lu27ZX7IhBk+Qz7XxPNyrmpvy3xlklTorr9oSl1oXkCCGIhvsiZ4/yW5AuRu6x5gSTjpGquxiIgl1edpL4PjPE838fpxVu/pOsyAotzbtaP4SVv+Lg4Jmk6vd+jABOMx1sZ2RBP2ZcfNEG5wBOVIplLABznKUs3xnRnFHkgThyN36Z0v0tgL2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7890Movu/82sfKLG9cxxkX3toKwcH54/1VGlhI0JCrc=;
 b=KbVoJ/+UaYVewm8DN090E1jYOc8N+L86vrALh+kSAuMl7HJmK+IDmDl7sCsq7x4Bj50kNtEh2RR8mEuJUL5TCOqA8J+wR7DddQTfv0oCpvHEx2SJqubXw9Oeu/XNK4S+M8Nsb2DuXDnHZdgO+YEJOymv427//0K6ih2yruuboFS9r3NXtPlJYAX5G8MIuSzLRUhVc7FKs9uRrg2AKhFP+RwUXmhYDf/O3Trs9uURaP5YFxrTxH6S3hTH5+M+msYC9MSS+l7kipVId2Gk+pdJLzIBjZT8MQeCYMJFuBtqwCiFLt4AYdW32EzYKV6qwJBYVW6M2EsTWPEnRirs5I0KYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7890Movu/82sfKLG9cxxkX3toKwcH54/1VGlhI0JCrc=;
 b=Wd9JVSnNpw4vY3o6eHGly8TgfAmZunzIr7BvgUtfniaAhfub8uGaaHmkl5c0J+NG8DUqRh/SExXzBnWrsv4qnToJxU9Ctw5qyNHHoVQri/M5CYFDihAoNrptK+wGs3J2jj4rTCJLzWxRPp9ZaPzVONRuY3finBHBJ/iJJnL6xEg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3760.eurprd04.prod.outlook.com (52.134.17.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 19:13:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 19:13:37 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     "Dragos Rosioru (OSS)" <dragos.rosioru@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: dcp - fix scatterlist linearization for hash
Thread-Topic: [PATCH] crypto: dcp - fix scatterlist linearization for hash
Thread-Index: AQHV6+0mo0nTyZiybUyVCvuUuutR/w==
Date:   Tue, 25 Feb 2020 19:13:37 +0000
Message-ID: <VI1PR0402MB348546BF33366C0EA219696598ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1582643152-17278-1-git-send-email-dragos.rosioru@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8e1fc23-c50a-403b-2d6a-08d7ba26d0df
x-ms-traffictypediagnostic: VI1PR0402MB3760:|VI1PR0402MB3760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37607313282E1822D336C0E598ED0@VI1PR0402MB3760.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(199004)(189003)(33656002)(4744005)(2906002)(71200400001)(52536014)(7416002)(81166006)(316002)(86362001)(8676002)(8936002)(81156014)(110136005)(44832011)(54906003)(76116006)(4326008)(26005)(6506007)(186003)(5660300002)(478600001)(66556008)(91956017)(66946007)(55016002)(66446008)(64756008)(53546011)(9686003)(7696005)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3760;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLvnEyaxkNcMFUAgm0X5ptUOWdfze+Td3YdK+vTbF5MP5cMwEjvNRiFNSprvEl0e3Tg8tZrMQlw+GaXV5LUh/ukZkC4iR40NR4GUaVDcSRDyHR/jHgNcaPrun4DX+ByXuD/UAlg9ezt1AzdKSS/jGCWvkZKIi4+I71hD26vliqTDjUH2Rs01SpttFHGDWU4TGK3TftKZ7W34ac5o5SVcvIurz7HL+n2mGlQj0URQrn8SdguNYVxhUqBgx95nDSZ5f63+2K5BNh+PtxDEmLoucg7V5SP3hgxmq6DFwbtSAUvyLPHwWCmzGubUk4igTKIm6/VywSaqrP0gfw88gcmYmD5bsSDDTAlK++L3k8d1222Phjvltzbf090PSNIod40zItdVXVoIUjetmSzs/sstoeSLubj53g0tnETtrkkiugx2O1NFWtVY+VQWPAN4TTFa
x-ms-exchange-antispam-messagedata: hKqbyBVW3VTvJOFG8BlNwUwvr4mAHGkBV6uWKLViL7J9dI8GyqYZljuuS8o/+wSSJmlGqE7aeqOz2tg0ttlsWHWyz+V+jZNSWTiCcOX+lu+TZuFC3d6psZbegWOW23ElJALlD7joz05B3q7xawY9YQ==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e1fc23-c50a-403b-2d6a-08d7ba26d0df
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 19:13:37.0286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Di8oV8lt8/3G5/AXZ6vZDmwqp27yivqWl7aTJGKYXNnsgFrcE6qy2F3ruYcW064xA6sVBy5+Pd/IoveaNM4Obw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/25/2020 5:06 PM, Dragos Rosioru (OSS) wrote:=0A=
> From: Rosioru Dragos <dragos.rosioru@nxp.com>=0A=
> =0A=
> The incorrect traversal of the scatterlist, during the linearization phas=
e=0A=
> lead to computing the hash value of the wrong input buffer.=0A=
> New implementation uses scatterwalk_map_and_copy()=0A=
> to address this issue.=0A=
> =0A=
> Cc: <stable@vger.kernel.org>=0A=
> Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")=0A=
> Signed-off-by: Rosioru Dragos <dragos.rosioru@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
