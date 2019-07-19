Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF8EC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F4BC2173B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="I/2z0VyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfGSPLr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 11:11:47 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:49538
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727649AbfGSPLr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 11:11:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYQyceIEtQVIzZA65JCh59MKPgZG2LiATtlM4BjSmauyuwtqNYWjImA+TpEqA1uznChp0NHflxAsNc9FoP/m6iZM3fO8Uko1BZU+2DV95Ah0BMzstY95+AjiGyDq79tzCsLSkWwCF8cQrh8RrwkA8u2ZwfDrytT2VIiXxO1NPqh9PX91Kfqo8k6TC8Bof0Fg5SoRuo9IQ/xqoCC5FAn5dzRkFC5chSHE/YfXRUWHsEX5kURr2xvto0ZqPaTf4zIMzYP3UQn0P/B1mRSigAaBnRD+8IuOv5BkXMieeaNqJXeRDKGtHzYYVnJe344U8noq+X2/C569KjAoNsgU3Xcu7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsGieUX69mXEHaMc9/njeB5TLqYm9G/KzGvYIdrF6fo=;
 b=HEs36mB54lr5/J8FII3yD46o4VPob/PGKrRDdEbUSWURbLjEPPEsZcup9PCLkx1uW+hqp2GjSesMhyU5Xd5pvGeZn8D6mDF7gxWKWsiVkxIOkr0NrpBw6wKzRjR44IwZRyLpuQCNDKaUPS+8OSX74cVqFNXfoco2sRatGcSgA8P83t2AAD9YGYUl3B7/hRZjioeuOQow89+DLdy4iW8pxRG1WE5KPhwHEH1ufvRrMJ3GKiemXUpdVzMOaTHJge45Dy6C4GngZ8RAyY+jqZrOu87d1fTvDZ6vVh56v8uESFgW4qVKA682yVNvLDkOEIreezSPnNMwJhvbKlAZIUdFIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsGieUX69mXEHaMc9/njeB5TLqYm9G/KzGvYIdrF6fo=;
 b=I/2z0VyRwGFJB0MNyhCTkhJxLthXLs29QsuO3jJUt3fJ7oL7lKOcJNXQy0KKGqfoeAp0CLpRjHv2UbCtkNPFy7Gu5WLhvUZQpjHaA/ElJobI98om+2KXYRlqqUhjtIkvGRjumqK3XS+686qYkCUiSAVI2xzWhCyJRePHnRq5Qh4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2765.eurprd04.prod.outlook.com (10.175.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Fri, 19 Jul 2019 15:11:43 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 15:11:43 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 07/14] crypto: caam - check zero-length input
Thread-Topic: [PATCH v2 07/14] crypto: caam - check zero-length input
Thread-Index: AQHVPcSro76OInywR0iiaXO8uBX07Q==
Date:   Fri, 19 Jul 2019 15:11:43 +0000
Message-ID: <VI1PR0402MB3485425C98405CBC3DD5D54098CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-8-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77665a13-0444-4291-7c3e-08d70c5b6887
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2765;
x-ms-traffictypediagnostic: VI1PR0402MB2765:
x-microsoft-antispam-prvs: <VI1PR0402MB27655BEB82F4AD0215BFB39D98CB0@VI1PR0402MB2765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(189003)(199004)(8676002)(99286004)(54906003)(71190400001)(558084003)(86362001)(6246003)(7736002)(91956017)(6636002)(71200400001)(316002)(4326008)(6506007)(74316002)(110136005)(229853002)(53546011)(52536014)(66446008)(66476007)(76116006)(68736007)(66946007)(64756008)(81166006)(66556008)(305945005)(81156014)(5660300002)(7696005)(76176011)(9686003)(8936002)(55016002)(2906002)(53936002)(26005)(102836004)(33656002)(186003)(476003)(66066001)(6116002)(3846002)(6436002)(446003)(14454004)(44832011)(486006)(25786009)(256004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2765;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b6jxwNZUex2by2OG4tV6YDWAaQXgYf3TMWBwhjEj8/LBdRICc4eehY+wgKRa2QF7Kx7rUYBX7W8He8VOu5lIYkTAWeKNwMlwyb7k/13gtJ5VRGdaUR6o5PFQ/TmJzxi9nmDZipOu/h4qu8OL13O4sjer6tU9nsJwPwgS27+ThpPsQuq5aBgprOamIiyo/iUlk2PdFoHiW5Xunkzv2NugPMkce1glxjc2ami6gsXvg+vabw1hJq2ybUvQ8QbVe7g7Ima8GKduF/AryjsLdJxepXT9KKzmHAaTjoVzKFMXkmDZEh5fNfLJDiA9PXYs5JAfvZ9drbp+8KZgbV9RUClcyDobGDOuC8Y5euY0b9Mpk9+TtvYdL0f55aB9rvI5nh3hk6sWrdIbz+27JWMPH73/VZvHvdGqGcp3ShqPfK391Ow=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77665a13-0444-4291-7c3e-08d70c5b6887
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 15:11:43.1021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2765
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> Check zero-length input, for skcipher algorithm, to solve the extra=0A=
> tests. This is a valid operation, therefore the API will return no error.=
=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Horia=0A=
