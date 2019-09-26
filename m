Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA75FC352A9
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 13:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 889F8222C3
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 13:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Oeh753P/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfIZNpY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:45:24 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:46700
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbfIZNpY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 09:45:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuAhqEDg0f6qQmVGK0uHbcg0tXqCw/FxuC5TCK2ds4z9aewkKCqsZK44m4NMilpGbANBGYh+KHnWuuUoIsD9f0RF6VRtDBfqOzHwH4NRkZ2QdC2yTBIlzb9IStX3US8TVIOK2zRkI8J14m2rDyzvVfvWecvSkIIW0vUVKF/vPpRWvALYRf9Naieo2QTtV0zsXvrRNPUdQnlvnkT3idf7OxLGrnGXDs9nAX6eDbTG3oYGeAulUObrXo9mlf1ed2ibzy4RBfeF0R01MEuFwocGrDijnaNgaNX0VuttNjuOiK2aWK+/RnnQ8vhELtNtmF2amijzP81Jz9PjrNRB80gCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTtYW8uvTj/5TEI9GSBTGh0QlMy+uHTj2iXaGrnmxhg=;
 b=VbmMkRgcYUucuMSSU7KLZ9TttdVFN+vF10gCHo60Q4pXljMcmmTsRV/OhQq79Roa31Xh6Y/xbo4cI/dRIrXGJMjtBisD6YW2uInpZtX4R+nORkHM78IKYhlJxhI3OcjnAxVPtgt0HkMlBBQX6IX8DHHcZbJpBTJ/dZ7xnYq2e0dEvk/x7CPmczg2v3tdK3LNrwA+N+ajy7QHah0DxpECiKsKJn+33Inpdih+FmH7s6SLsQpDP0lKm4EcXtd5azen4rX32AfMMaF2dJRh8dvbUYhnQdKHsB97BVNJe4P9KS8Pd6JtXOGRv1ljmyBgTDKwK/35ZrU5CG9VyrZmUD/Ahg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTtYW8uvTj/5TEI9GSBTGh0QlMy+uHTj2iXaGrnmxhg=;
 b=Oeh753P/LrGY6kNsDdqIrQnClMd/KXjlTqMarZAD7wnPaK+3tteZa44Mh+sW4aV83w5547wXvGkPpY/f0Uyf2jIwN0GYIzbqH6YQ0weYSzAyUME34tNR58tFZIo7LRGY6Xm6w80+oFnf14YhzGxX1K0noFJpk9eD4DCHI55Pe+Y=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3438.eurprd04.prod.outlook.com (52.134.3.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Thu, 26 Sep 2019 13:45:20 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::b84e:b20f:138a:63e9]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::b84e:b20f:138a:63e9%7]) with mapi id 15.20.2284.023; Thu, 26 Sep 2019
 13:45:20 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2] crypto: caam - use mapped_{src,dst}_nents for
 descriptor
Thread-Topic: [PATCH v2] crypto: caam - use mapped_{src,dst}_nents for
 descriptor
Thread-Index: AQHVdGWinHvuPLZHBkmmgYvaLgpxPw==
Date:   Thu, 26 Sep 2019 13:45:20 +0000
Message-ID: <VI1PR0402MB348537583DCCF4210BCA04D398860@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1569500789-7443-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16be1e0b-4c10-4710-3a45-08d74287c61e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3438;
x-ms-traffictypediagnostic: VI1PR0402MB3438:|VI1PR0402MB3438:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34388351FB961227A19F4BCD98860@VI1PR0402MB3438.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(189003)(199004)(76176011)(54906003)(91956017)(76116006)(66946007)(476003)(486006)(71190400001)(71200400001)(186003)(74316002)(66066001)(446003)(26005)(33656002)(14454004)(44832011)(66556008)(110136005)(64756008)(478600001)(558084003)(66476007)(5660300002)(316002)(6636002)(25786009)(6436002)(6246003)(7736002)(4326008)(52536014)(66446008)(2906002)(99286004)(3846002)(6116002)(305945005)(102836004)(8676002)(55016002)(86362001)(81166006)(9686003)(256004)(8936002)(81156014)(229853002)(6506007)(7696005)(53546011)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3438;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GsGxjdKlT1wWGirMsG6XGvD9kR0rWyX3WXW+h5782rW9Sm408QmBR/o2FObL8xI2Qd8Pld1Gd/TJlVNzV3SR8iV5UcVY1WUvtn1nPo0rpIpxGewZSh94s1/s/sFm6eLgIbKp1fsULujRnCJcmWcKadPXFfSdS7pgo7k+5yW3SMw+Z6VNRCKXcJJsRQx1SzxA62L3L9RroXOVEfADTFkW8epXn5jQ6RpPWS5ptrWkx4J7UUIzWgqRbI1dcwZVF3zCjywUbuDy+sLs7EBjCP42E4L/ik3P6oiwW21OIwi83SiTjLejGZTOjbISnf6G94RAxPCM109+teGbeFUtu4J50Rei2AGggAk1sBX0W8sqbjdCqAuJH8sYpR4JLA/qgeH5ExyeaRUg+2l/SlVFbj5RJjnVWMrqmZcPT2FKcjwiixQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16be1e0b-4c10-4710-3a45-08d74287c61e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 13:45:20.7083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6dadGXcXnu+5psOcj4kEsCqUt4uV5pt+ivMecgc0FASaGhZi5Al8jKBQZNgO1ip4OZUT17h0FRKIh8rmTSqHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3438
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/26/2019 3:26 PM, Iuliana Prodan wrote:=0A=
> The mapped_{src,dst}_nents _returned_ from the dma_map_sg=0A=
> call (which could be less than src/dst_nents) have to be=0A=
> used to generate the job descriptors.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
