Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E89C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E9C216B7
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OFtWV+bB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfGZPTW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:19:22 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:42469
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbfGZPTW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:19:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+oNplWQAaolRCP+bxsHDba066ndJh7f7MY6cJdeKq2fg3j9MBxI61Lp6J8R6s4krPOb7sfarUwwan1GHMpS5nW9Ux5gmxcA1tNTducpDUKvWIB/ucnONaVglz3C2REnU5qcZq8Gx1ppt3Mx/Sg2ncbjfW+szB0YtjFJIUjN8lF/Ps7OVPv7oTWj8NAPVRAVdt+mYGKrXXGse+iy0qsaEEyYVNTCIJbGqcQ5tUG2tHCVxlrOvtvMpWnY1RHy1TYGsl0+r4LQb+ytN1J7nEVFxjxhRWXFMkQWK297AZQ+zPTI/xVsOUmUAzM3oPDNr0nnZavMpX8of9DXiF2AdDJLYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xjs7Bp6nmdbHMVAEZ3BZ3jW1f5VMrUB9oWN0BudQTNk=;
 b=gZ3wBE55S9So21vvV+HTyL5JDodnGeBDWO0AGct8FkfaAkeMO8W3YEFk7WsoB1hokdW5Oxzi+t/cBjtdnPf1u7gJqXFcDnXAQk/V/b4Jj6fPyXchULRoNXr/NSyqT1iQVDey/xqVStv2fFvYffxH4MT6mXbw/maconrXgyYKs7qOUh6qASN4L0ukciQQdU9BCGQJgVd/hGXE2FcvCI0TDpXB1ovSQPWLDVtoYymmeKnc5uUZAs8cbiDrHFdg3YpMdlQQKJuzrhIvv95EQW10UpOCW3bHVQ56ut0hn5p+QFonrmhn4+o0TGLqT/0Dn+r/IYihBeIS06GlRm1m6LvoRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xjs7Bp6nmdbHMVAEZ3BZ3jW1f5VMrUB9oWN0BudQTNk=;
 b=OFtWV+bBM36mXwFMdJ0/aVTjwRlplBdBrvjNdf39utEU6MZHvS6cIe8DmGHzugzHIQ1mmKoasRbGoxGm4/rOCO62y6ZgI8DPDPSBFLAWP6Y8s7rbwPdLr/uG1ynxGrk3tLkDeQa8KDVPV0bEfvcIIHYpElCxq9F062zfF65l6eU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3742.eurprd04.prod.outlook.com (52.134.15.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 15:19:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:19:18 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 04/14] crypto: caam - check key length
Thread-Topic: [PATCH v3 04/14] crypto: caam - check key length
Thread-Index: AQHVQvEQZTrNEftHI0aaBTmv2mddVQ==
Date:   Fri, 26 Jul 2019 15:19:18 +0000
Message-ID: <VI1PR0402MB3485A18BFAC50302DB3DF72F98C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-5-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f30882d2-1a4b-4a46-f765-08d711dca11e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3742;
x-ms-traffictypediagnostic: VI1PR0402MB3742:
x-microsoft-antispam-prvs: <VI1PR0402MB37427F7291C747E11EF2382298C00@VI1PR0402MB3742.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52536014)(6116002)(6436002)(3846002)(86362001)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(91956017)(14454004)(53546011)(6506007)(102836004)(76176011)(2906002)(7696005)(229853002)(478600001)(486006)(305945005)(14444005)(256004)(44832011)(476003)(7736002)(9686003)(71190400001)(99286004)(68736007)(71200400001)(81166006)(81156014)(8676002)(55016002)(110136005)(54906003)(316002)(8936002)(6636002)(74316002)(25786009)(558084003)(6246003)(186003)(66066001)(4326008)(446003)(53936002)(26005)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3742;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PgrQTZwRu/IOMxnM28HOgf8n+XnxT25ABNxHarBE5ldfcco14jTuG2Uyif5p6W45tColbmlVcFo53Y8zHd2m+0LanmInnZuFZVMHPlpzFDRkLl63K7UVf/8L6lzmKUEV0bOhaUcBLdgPFKb9MN37DPrL/+rcdZT1+0N9FLrfAWC4JedWl/+uYhDccDmtrRXMyggNi4Hl5sQJmodvRQZilNxvXprT9vKsyHWgiNJThbkbkzDnPkcFAz1mlHeazFO9553fYvq2r2t+LXSo+biTLx6Jo0vyt0Y+b8Up5EeInTtkUzatvmq8xRe3cJhmqMzcuT5q1TvZOLHhkXGydZLeprQBNg4LisppXwTKiUsuXdhwn8vqKZ9EVPcMqqWjw5z026vqmqMCJ4Wn2y1tHE/gI0YqioLVVP48zpILzQxm1Ug=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f30882d2-1a4b-4a46-f765-08d711dca11e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:19:18.9403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3742
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> Check key length to solve the extra tests that expect -EINVAL to be=0A=
> returned when the key size is not valid.=0A=
> =0A=
> Validated AES keylen for skcipher, ahash and aead.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
