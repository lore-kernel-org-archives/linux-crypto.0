Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0920C072B1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 09:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66A9208C3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 09:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FJV+vbNn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfE1JR4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 05:17:56 -0400
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:5764
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfE1JR4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 05:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWj5naSzV0ySCY1ZNrovPMjNnQtCqGhYnXGehj0aWog=;
 b=FJV+vbNnNMhJZJmUnGDbo8Kf7dY5d1wX0nBDeOkRsGlftG7UdrnCBn6bkrun7sJ+h5TwRKwLyWHL6xClLAZV827pXKTIkxN5GOEiZa2C3PLR+gOqChPsCZr2zBqMW9mC+6G62MYazs23NUNTsyfGALSDNcBqkxzqXWZXvrnumkA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3885.eurprd04.prod.outlook.com (52.134.17.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 09:17:52 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 09:17:52 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v1 00/15] Fixing selftests failure on Talitos driver
Thread-Topic: [PATCH v1 00/15] Fixing selftests failure on Talitos driver
Thread-Index: AQHVD9neuB3rF5DbdU6FGGdK8ciL0Q==
Date:   Tue, 28 May 2019 09:17:52 +0000
Message-ID: <VI1PR0402MB34850975FDD8F5F1CE366A9C981E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6462515-2c1f-44c4-b3cd-08d6e34d5cd4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3885;
x-ms-traffictypediagnostic: VI1PR0402MB3885:
x-microsoft-antispam-prvs: <VI1PR0402MB3885CA9DEAB69658D6DE6EE9981E0@VI1PR0402MB3885.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(68736007)(486006)(476003)(4326008)(186003)(446003)(53936002)(6246003)(9686003)(5660300002)(55016002)(66066001)(76176011)(478600001)(4744005)(316002)(74316002)(26005)(66946007)(76116006)(73956011)(52536014)(25786009)(66446008)(66476007)(66556008)(64756008)(6506007)(14444005)(14454004)(99286004)(8676002)(81156014)(256004)(81166006)(110136005)(6116002)(3846002)(54906003)(33656002)(71190400001)(53546011)(44832011)(71200400001)(7696005)(305945005)(7736002)(102836004)(2906002)(6436002)(8936002)(229853002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3885;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dRJv2WAxvIzDvLYch559MunUOf5sxswNfkQ6O4ceognW7o5TCBPliiPn3i/0jvJ5VoYTGyDDy1MTqumAjBwEx7FOKaautF4t2bsy+BIZI2Y+ghEywTcK/IRf+Zw7zUrFOSJisrqyaIey8eJzh3IIb0pjv2NLD6qDh/DgRTllCW8YuGgZM3AW1a/ENj53/vTLShbS/WAWg4O3tbcI1GrJNmJy80W1nW+fWcWidYCvYkr+XeZcgQ92vVtSWywSidPIfa9BKUn7+Uo5IGEXeyRCfm65mof4vfcijT+omLQFJ0BZnMURy32FE4+KZjSxYBs5sChvvU593IEMPjYlJyIIHNvMDR+TGjM2cQRcZmmeums0uNQ5u0+Vl2ovb1EBLNEbOiO2srX55paaVlrinQgy4WFat6lqrlM+d/VN08p6cko=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6462515-2c1f-44c4-b3cd-08d6e34d5cd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 09:17:52.7205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3885
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/21/2019 4:34 PM, Christophe Leroy wrote:=0A=
> Several test failures have popped up following recent changes to crypto=
=0A=
> selftests.=0A=
> =0A=
> This series fixes (most of) them.=0A=
> =0A=
> The last three patches are trivial cleanups.=0A=
> =0A=
Thanks Christophe.=0A=
=0A=
For the series:=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Have you validated the changes also on SEC 2.x+?=0A=
Asking since IIRC you mentioned having only HW with SEC 1 and changes in pa=
tch=0A=
"crypto: talitos - fix AEAD processing." look quite complex.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
