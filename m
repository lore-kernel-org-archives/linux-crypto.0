Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581D7C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CBA0218D4
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Y3QrsQ1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfGZPZZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:25:25 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:4674
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727476AbfGZPZZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:25:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHVb/c7F6VvWGT8OtnCyc5BUDA0o1O3vea6+1jCce6GR+cIeg08sLVVd2hGME/D5ThECTjU0rr0hpsaY8UBnOq8yEhuwnTHez+PfyvHdIK+9VeXvwf12iPhclqujXgVyWLulEQoky+HlEtMla81EqWSxLY7x+2ezShk79+1NqZ7xuLwvzlYSUVSOoqE5oJiPuP6or7q55E0WT7GIKb2zjPO7qvM9y/ClS8ySckqZsl44aafs2ZsTamVukFjbgXOv4kompz8Hb5nvAbEvQIUMQrqjajC9rFajHSZS/fH80gEaZybt9VJEhjieFAkh6/avSbukEIwigeP0ldhkBIvlow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+bKdT2+COwjFBZ28cC301VbdXIIY0AMRzlju+ouLE4=;
 b=JuvEdKlEYIWqHp2x8dkqOGdnrChqmJYKsxoR5UvueRNJ9zDwMIVzaYDFdeMykChqG9blkC5ZUbqVFQ0rbObtSAfyy/K4Ue1b30NwojcH76XZtIdY8uz7k4YoKUpinjcSwHFQkyjZ3wzwS4kOGEsazQ4YSeqBde4wNj87Q6ik7bI/Dw1F4o2j+jni/lCihwRkHTkCXBtoD2N1By+hb1UL5D+XYhFRqntzk2+2D/E360PPhc8o/JNjFOtxXyC4QmCY6X/WPg6zGAhh6lQXlLpIb529PDAw4yKuX+Mz/ylslRWprblaAXVApshBbzjgeg1rrpZL2pZaogFHFPjNTqzXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+bKdT2+COwjFBZ28cC301VbdXIIY0AMRzlju+ouLE4=;
 b=Y3QrsQ1QkT+ONgKIZR1pU/V4FNXOX0d7wb5EHxS+A/OX6slYGhpN9f3iMuFT4D+QGcHO2bb5doHy1DOJrMqAOhhyzYR2l+1wgL3KMugjL8BlwsIw7u6mkAFUBtrCM39Ya2rm7iliuwY4VY8vk32JHEJGr7YOU1QRVf3OYbEAh3U=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3631.eurprd04.prod.outlook.com (52.134.7.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 15:25:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:25:21 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 05/14] crypto: caam - check authsize
Thread-Topic: [PATCH v3 05/14] crypto: caam - check authsize
Thread-Index: AQHVQvEPg1sByUmkbE2MhOZimAmAuA==
Date:   Fri, 26 Jul 2019 15:25:21 +0000
Message-ID: <VI1PR0402MB3485FC672AC806098AF0C1A998C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-6-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41e31e43-09b3-4f95-07c3-08d711dd7967
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3631;
x-ms-traffictypediagnostic: VI1PR0402MB3631:
x-microsoft-antispam-prvs: <VI1PR0402MB363106944D935D7D1B97A2E598C00@VI1PR0402MB3631.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(3846002)(6116002)(53936002)(81166006)(6436002)(9686003)(81156014)(99286004)(6506007)(86362001)(55016002)(316002)(478600001)(25786009)(26005)(71190400001)(71200400001)(6636002)(6246003)(14454004)(8676002)(558084003)(54906003)(8936002)(44832011)(66556008)(66446008)(76116006)(74316002)(66476007)(52536014)(229853002)(66946007)(5660300002)(66066001)(102836004)(7696005)(110136005)(476003)(446003)(186003)(14444005)(256004)(76176011)(68736007)(486006)(7736002)(33656002)(305945005)(4326008)(53546011)(64756008)(91956017)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3631;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YEZ7N23cv6XIR1z0EyWV03gWkYChTH/p0gVtiSrSu0ui/zq7WEvJBf4cQg5ny36lDLoZWXyfClVAz4JwUPIk532ndIZnW4nSwyufPWHfS9cqAQwFRmaRKXxgHfs+Z3u3cCVOxgEyEddu4IW/OhS9vwXRUmK1EGlxh7WhLBhoyogv66lTERI9pM+V+Dv/cDw3p0keiDwDNPeOSzsBnLRTA6nvYIHflgxVtoARFCULpRAoUD1xJNOn7/XQ+ZBEI5cbgzp+Vk3fj7GIUH4uYGNoVZevduDxN7ay/qZFwec5lh5HOEnXKtGwxTZ+fS6IBLlonOosvHxMcjSr1Hd/4r2DZa2gDrExNgFmpjwt+GcLAuh5Mk2i8NOqjsWDXzwAXXypQSXfXZlH7kG9rRP6nRz1qec5mlIUCouXLEEDUCv41Q0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e31e43-09b3-4f95-07c3-08d711dd7967
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:25:21.7355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3631
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> Check authsize to solve the extra tests that expect -EINVAL to be=0A=
> returned when the authentication tag size is not valid.=0A=
> =0A=
> Validated authsize for GCM, RFC4106 and RFC4543.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
