Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D1FC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 09:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3C32173E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 09:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="GMEzMiOt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbfHBJEV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 05:04:21 -0400
Received: from mail-eopbgr730070.outbound.protection.outlook.com ([40.107.73.70]:2254
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732677AbfHBJEV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 05:04:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIexEt3OysmuaS6cBUgdUYJeB0frRPjemta/S9iaILo0QAzOxH2tQahWQ0amVqNUo845bvpTOzPW6OSWTPFxov0gKEBetc5VNz/oXOgnSy3rv8FCxrHt30BfDZBIAcDJG4EwSGkJL0ob3g0jTRWApIqtO1QtD8XMhU2ovgD651qG6TGUjy/xZT/vxd76P/mxkW0UnGzy8N3KGCq5aKLM0CFzbOs3c1J8MQywgPjkn+WVWmCy8e0gvnJlX6Wxoc7hfpq3nRaj7rNc1t0oxQjTbMdh8BIcNqiBB7oxpWtL2hMuaym5DXyF+MqLoSvmzLiQtmL9TY5HUkgnlDerGWlaTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IbEaCQyHiJZ0gJshFYQgxZOlGxNbmd9fCcbHqqgqMg=;
 b=nhyG/dtM0wmSxYM38j6JkR2NYnh6/hAHNmLLQrc66QP9Krm5ix7Tid4GYVoSxmf3qspA5NwRif3+SHe2rIwRMJh+s+YhTGDiVB6UyNoXNFvzJivYRlNw3NIqQqwuET8Uxw3VWusM2kXYEXB22NMLQaGGZiUUgBLojXo9dIQxDbRNp5qiDCptPOr4Wp42y9eCqQavoEhFi0L5EJqxxqFadgVHuBzW4IcWwyiHXhI9o4vSrQhCPuaVYfx9LDeqN8A77xw6AU9Hm7uRx9TwCitmbue22uT3G3m7AkIwlrqdSxjPQsV37U0Z4OQPfs8fVExcLHn/aL78ghHi5Fu/MGEhBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IbEaCQyHiJZ0gJshFYQgxZOlGxNbmd9fCcbHqqgqMg=;
 b=GMEzMiOtBSlFz4jppGIddAEw3CYtpVXyip4Yj/af+vpVyXpKSOYzBxhTaJ0I7b8DfCO0vNo6Levfy3xGy4Acvqv3YHacNlhMAcEY7odonvwI3P9j4O/FFvZWlhlfWrn9ovaOpy3kDutKBGPGd4dQ8Jue2NNyHF2rM73/3hp+b+w=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2814.namprd20.prod.outlook.com (20.178.253.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 2 Aug 2019 09:04:19 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 09:04:19 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/2] Add support for the AES-XTS algorithm
Thread-Topic: [PATCH 0/2] Add support for the AES-XTS algorithm
Thread-Index: AQHVQ8ubtsVt4RhQiUmHqOHdPSMav6bnUqCAgABH54A=
Date:   Fri, 2 Aug 2019 09:04:19 +0000
Message-ID: <MN2PR20MB2973EA6FAB5F82484E352AC2CAD90@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190802044529.GA17763@gondor.apana.org.au>
In-Reply-To: <20190802044529.GA17763@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b4c0a5f-1e26-4941-b20d-08d717286743
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2814;
x-ms-traffictypediagnostic: MN2PR20MB2814:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2814E98E90CDEC8408965C82CAD90@MN2PR20MB2814.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(199004)(189003)(13464003)(66476007)(3846002)(7736002)(305945005)(8676002)(74316002)(81156014)(186003)(81166006)(14454004)(71190400001)(446003)(71200400001)(11346002)(966005)(486006)(6436002)(476003)(229853002)(9686003)(33656002)(54906003)(110136005)(8936002)(102836004)(256004)(53546011)(68736007)(7696005)(99286004)(76176011)(6506007)(2906002)(15974865002)(4326008)(5660300002)(6116002)(6306002)(53936002)(52536014)(6246003)(316002)(66066001)(86362001)(478600001)(64756008)(55016002)(25786009)(26005)(76116006)(66446008)(66946007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2814;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qsJ47J5xklrVsjHtPMr5BGj27vxLH08OPh085nCDrS/wHkiAsPUK2TKNzZ4l+ASQ/5QY3GuEGf3zPoQPSSToY/tk4lahtD3XQYucDpfkp6NOH+lYWmaHHoeg0mQQVnfcHIWG3AX2ZPDjlBcTJ5sV4L4fGjK4IdcNAUHRtYQT4SKMdzkZP3fIikjgIt85rRgTMBNaqUq/SVDa+jx6FFry1K2IJwFwqOdVAmj+eXI9EYru+u5b6aZ1CzXT1wZVdQiFpPjO9kahMqKRuPXmH+MRDH3foKb92c0Ods1DcQ5AMOh2Z/CvdJK/Bo7ZDYcKpCI723oBUCQrEXhSNuzkxZpUUnrMemtmk9WD3v/WQD4MdeBeAiwOK0cDq/8y8ZAlZMj7cpJ+fxEcC+0ZSKPAJP1NcQc5RJlorefLPQHEqLgnrw0=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4c0a5f-1e26-4941-b20d-08d717286743
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 09:04:19.2716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Herbert Xu
> Sent: Friday, August 2, 2019 6:45 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net; Pascal
> Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 0/2] Add support for the AES-XTS algorithm
>=20
> On Fri, Jul 26, 2019 at 05:00:31PM +0200, Pascal van Leeuwen wrote:
> > This patch set adds support for the AES-XTS skcipher algorithm.
> >
> > Pascal van Leeuwen (3):
> >   crypto: inside-secure - Move static cipher alg & mode settings to ini=
t
> >   crypto: inside-secure - Add support for the AES-XTS algorithm
> >
> >  drivers/crypto/inside-secure/safexcel.c        |   1 +
> >  drivers/crypto/inside-secure/safexcel.h        |   2 +
> >  drivers/crypto/inside-secure/safexcel_cipher.c | 360 ++++++++++++++---=
-------
> >  3 files changed, 212 insertions(+), 151 deletions(-)
>=20
> This patch series doesn't apply against cryptodev.  Please resubmit.
>=20
This may depend on my very first patchset which has not been accepted yet.
Sorry about that. I will resubmit it as soon as that gets merged.=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
