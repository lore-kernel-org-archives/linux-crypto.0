Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1073CC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEC642089F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="HoihYahH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfIKPrY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:47:24 -0400
Received: from mail-eopbgr750059.outbound.protection.outlook.com ([40.107.75.59]:28738
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728271AbfIKPrX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:47:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnxRcojjFrDWKR1HOYC6VIoI1bWyvGDuilKyCManrXxsBKs+ciJ+/yEkyLyXqD4MUYFgyWaTad81n1OxMHO/8nAoVU1mnVG3YtQTtxeewfk8c7pwLNGNcsISfp0WDsUIBSGPyentzwjeTpDeIA5gwU0z/ffK15+XH+dda0Z0MzP021znNvaoAFn38KJzpfa1ZoOl4Y/3YBh7EhcJ9pzS5BOyKjR4xxJYezPlOOec2rNelO6Rl4LW/MS9dP4FTROmy3Vu4jriqvc4Qsq/X4Jwa1+dOcRn/PKkHKq5/zFwRI2BcFy52gyh+XDPy5uZXT80c9fNjDFVE7fvtjG6cRRlcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiEf8wbaApSmoMgD0DHTDqrTIqYK7to6FnHn2J7oclI=;
 b=iRGDI190uj+R+VKffv526g11/81IMPttS9YGtAxdcHslUWR4+A3ze6rdB/bVVTASVbz/f6GjwKLm0fTz1v866nteiS2ITOQBTlYnV7oWkQKiCzqOaG9zLANog7mTYz4uN7DoJ85CI2p9d4s96R7kydnp170knKJIQmytrSbNSxg01SdUgt8GiIpsPkSGgBb1q/LKV1XLv5/xj0AE4MRU1diFY7u6w1Z7eYwZ+UdwRDNYG/eyNGD0j2RPmRZMbc0pWFYG7HfmIKlBomLe3JVZu/RpIi0/UtGpIsBKfRXDkWII1IgoAzTHmJzbo7mgJbkrsO9C4VbCfWO/lG/XIqbAnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiEf8wbaApSmoMgD0DHTDqrTIqYK7to6FnHn2J7oclI=;
 b=HoihYahHC4XsRHTRQB8xu+7iRw45InKc4Zq9DEAHCIqxdXWyO5aQiyrpl3JerV4jISFA5vRizEIAAr8puIVAHmAJgJc62DFs+2zS8x7KQVtVJy8RYHVSysgA4paD05vVAPDq2c6R2Vka1Pt6suxUq69RQ9XEi/DYugkTpYqiWSg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3197.namprd20.prod.outlook.com (52.132.175.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Wed, 11 Sep 2019 15:47:21 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 15:47:21 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/3] crypto: inside-secure - Added support for basic SM3
 ahash
Thread-Topic: [PATCH 1/3] crypto: inside-secure - Added support for basic SM3
 ahash
Thread-Index: AQHVaH0Po6qZvUsKdkm5AUBk0oX4CKcmnZ6AgAAAqaA=
Date:   Wed, 11 Sep 2019 15:47:21 +0000
Message-ID: <MN2PR20MB2973F633782C5B9DC9E509CBCAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568187671-8540-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911154055.GC5492@kwain>
In-Reply-To: <20190911154055.GC5492@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5eb54ef9-ada0-456f-1007-08d736cf5557
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3197;
x-ms-traffictypediagnostic: MN2PR20MB3197:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB3197B339B925FA960B9FD1BCCAB10@MN2PR20MB3197.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(366004)(136003)(376002)(346002)(13464003)(189003)(199004)(54906003)(26005)(110136005)(229853002)(71190400001)(71200400001)(81156014)(81166006)(5660300002)(33656002)(6246003)(52536014)(478600001)(66476007)(66556008)(14454004)(64756008)(66446008)(66946007)(53546011)(25786009)(66574012)(86362001)(76116006)(8936002)(8676002)(4326008)(6506007)(966005)(2906002)(9686003)(486006)(99286004)(6116002)(476003)(7696005)(6306002)(55016002)(74316002)(446003)(11346002)(102836004)(66066001)(53936002)(3846002)(15974865002)(6436002)(76176011)(316002)(256004)(305945005)(186003)(7736002)(14444005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3197;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kn22+Vw3Xo0IU4/8CgxW7TTRWWgoZTtKRfm8eq5wvGKOVZvfidG+kkYDovlSq29AGQh2LrCAZ5jjUwf17Pa/XLSrHPwGNyYKXIiCqkblC45DM9B8YvAdTNgbFx1ncErgpbQtEe2bcJfDhcNRTqeaGBgCwsiPnTOegFN00htbVKFRnuRk3htjHyEQZHSgjt1JwCTBr2Eb91NJpcGNHJf0osXyurfRTxI6xNdQzUFmz+GGeWOHuw6kcVag1AKNFWLUAdEITeLoj5stPOjSl2obA8zOZnttSfMAPRuGdgXOcc8F+8MaMS8BK/XpfF/EERwNhzOCK5FnxRRTEPtOS5udE+OeA58o48BLA9Joyl7nw2eOxpo3cXw2Bt6QCEOtgbVpeQPP+owqD2uCYxtQqXU3hHieVOw3oQytnqV/MJBKd5s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb54ef9-ada0-456f-1007-08d736cf5557
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 15:47:21.3074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K/YJbczgrqAU3O6K4QJ2A8s+eCOWJp40DdXyb30o2C1ruSxj8Szn87HhGXylksA+jt63WYoFxTszYx1rjVYZGf97yjuox0mqB23W6jBxoMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3197
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, September 11, 2019 5:41 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com;
> herbert@gondor.apana.org.au; davem@davemloft.net; Pascal Van Leeuwen
> <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 1/3] crypto: inside-secure - Added support for basic =
SM3 ahash
>=20
> Hi Pascal,
>=20
> On Wed, Sep 11, 2019 at 09:41:09AM +0200, Pascal van Leeuwen wrote:
> >  static int safexcel_register_algorithms(struct safexcel_crypto_priv *p=
riv)
> > diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/i=
nside-
> secure/safexcel.h
> > index 282d59e..fc2aba2 100644
> > --- a/drivers/crypto/inside-secure/safexcel.h
> > +++ b/drivers/crypto/inside-secure/safexcel.h
> > @@ -374,6 +374,7 @@ struct safexcel_context_record {
> >  #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC192	(0x2 << 23)
> >  #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC256	(0x3 << 23)
> >  #define CONTEXT_CONTROL_CRYPTO_ALG_POLY1305	(0xf << 23)
> > +#define CONTEXT_CONTROL_CRYPTO_ALG_SM3		(0x7 << 23)
>=20
> Please order the definitions (0x7 before 0xf).
>=20
While I generally agree with you that having them in order is
nicer, the other already existing algorithms weren't in order
either (i.e. SHA224 is 4 but comes before SHA256 which is 3,=20
same  for SHA384 and SHA512), hence I just appended at the=20
end of the list in the order I actually added them.

Do you want me to put them *all* in order? Because otherwise
it doesn't make sense to make an exception for SM3.

> Otherwise the patch looks good, and with that you can add:
>=20
> Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>
>=20
> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

