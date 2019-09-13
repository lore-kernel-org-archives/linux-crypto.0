Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C278C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 09:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 274BF20830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 09:43:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="vyK1YJQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfIMJni (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 05:43:38 -0400
Received: from mail-eopbgr800073.outbound.protection.outlook.com ([40.107.80.73]:51657
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728521AbfIMJnh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 05:43:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFUv0CAkNoBa99+hRzvMfWy1IQ0uOGXtCvOiI+inID80c/iPrKPoYYUJB1MVPowBXz0CdB/75C/PI9DR3HG1ON7uz5/akogdV8o7kfILz2Z9mczfSggLoOXDiNnzgFEkcVsqmkreFlzQzxkDbQIVkp8kcMymFNBmrUGlCEDq6Kd/lAdTkCRGxQw592gJxLpAqWZL/uQifuPdR1AsS8WDSjAYGAzh2Uq2uR3gIPqy0jGAmCRFv0QHQg5qKYvIbK2q1uWlkehar1ap4hSjn6Hus8RryZ2bxvG/S+D9zMGja/4kr8rx4CrxbWIRLyfgSAc4IfAhYDOrJuZovU4VUuYS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/uaES6DbHbWD0Ah36yFP+HYQGUHpKa+j/rz4+TW478=;
 b=MExkhglwPE1Coc96FIJmaTLn62epktLhBODeKi7qcLtmWuLulAIqA75Q1xzOynR7grNxPiqYoK3PLhyblDPS7ipm5ZkdVq8877PD0oaMoKp2Uj+VPmUmeBkziM5HIhpkfTRLNHHomYb3gRscLqZ3LJbnNCb6ZGsBnsJbMGondMT6Rnck/4FB2t1+K+z/LV9sUvpXNxv2hw23WjLi+Mdezefs85T1Ltby7ZEoBIwNy7QDrxC6IXhJnmnfzPS4nXxeorjMZM1/i/OCmlYbKl5ejwuJ9q5vO/UTWSU/nBuicmX7FdJRwkkoqlW2MOh06N6+28R8m4abnFpXNz0LRIGHog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/uaES6DbHbWD0Ah36yFP+HYQGUHpKa+j/rz4+TW478=;
 b=vyK1YJQ/Mhx6X/LeKw7PkM30YpreZ8YsKD3T0qSrSc10Y+xfh/9j046WisbxWhAVY5WffcpGJx1WDSq84ie9GSrHfbzbNAlipqJs9ywBEy++IgHIpOow/kQMDgq6wqOe8Tepi0gSFWxb3h7ot/JkGInaRqQqrfxzIkiJOe65mkg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3087.namprd20.prod.outlook.com (52.132.174.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.20; Fri, 13 Sep 2019 09:43:34 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 09:43:32 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Thread-Topic: [PATCHv3] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Thread-Index: AQHVZNANHokwVmX0KUycRGfSB8kGnKcpX2AAgAAGChA=
Date:   Fri, 13 Sep 2019 09:43:31 +0000
Message-ID: <MN2PR20MB29730E22DDD60ED9F2B6F5B0CAB30@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567783514-24947-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190913092036.GA6645@gondor.apana.org.au>
In-Reply-To: <20190913092036.GA6645@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4100979-a004-4656-810f-08d7382ed6eb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3087;
x-ms-traffictypediagnostic: MN2PR20MB3087:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB30876FB15184544B99C63567CAB30@MN2PR20MB3087.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39850400004)(396003)(366004)(346002)(376002)(136003)(13464003)(189003)(199004)(52314003)(305945005)(7736002)(74316002)(25786009)(4326008)(5660300002)(2906002)(6436002)(66446008)(64756008)(52536014)(76116006)(66946007)(6116002)(66476007)(3846002)(66556008)(9686003)(6306002)(55016002)(256004)(14444005)(53936002)(6246003)(33656002)(966005)(486006)(14454004)(476003)(7696005)(76176011)(99286004)(53546011)(6506007)(102836004)(11346002)(446003)(71200400001)(229853002)(478600001)(8676002)(71190400001)(81156014)(81166006)(8936002)(15974865002)(110136005)(316002)(54906003)(186003)(26005)(66066001)(86362001)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3087;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gsa+y55v/zQpmhtlS1xFYv0dNGaS78P6QhWcASqNpk1lnbS0AHv6OtIt+fHjozs3tq4qZW2OAyuRPwkJCsKsxxHHl6fxSUGCokL5HRsv0dKu2PdSHdXNF+ZHPRdbhkJr0QLZ6nq8hQPcayjaEZm8i2FzDBfs6Yzd6iRBCsk+cRyug3xSFxnU18kEdzz43fi/mds2IHLCVOKjJbg6ObA4knxK/fD8LapS4SGXl11c967HfxG+F0WQKo55g+ICjvnJu3/GpoxLzJn63/my7t31IrlXmWUDZH7okGgp6lEqIx1O0UTkNADiQNo0Xd8DqthUf+NJZEb2ip7IVDPOcZYht3UlUxXmTelj00pNinUatp70/rp4yyZkf1YA3FlRMKsTbY7a7g0REEVSvmHU4fUfglxoPxsV/u1SR0O6RCg2plk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4100979-a004-4656-810f-08d7382ed6eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 09:43:32.0064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILHrGa5irIagqJFr+I6TxTutI/tlN2oPlJpKuA/IoHu+/yyVv1gEFFopELudDhTiPbPW9y3QCo9YZ0vU4Vrh4J1Z2FnZhfaB2VL3e0zA0Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3087
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf
> Of Herbert Xu
> Sent: Friday, September 13, 2019 11:21 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net;
> Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCHv3] crypto: inside-secure - Fix unused variable warnin=
g when
> CONFIG_PCI=3Dn
>=20
> On Fri, Sep 06, 2019 at 05:25:14PM +0200, Pascal van Leeuwen wrote:
> > This patch fixes an unused variable warning from the compiler when the
> > driver is being compiled without PCI support in the kernel.
> >
> > changes since v1:
> > - capture the platform_register_driver error code as well
> > - actually return the (last) error code
> > - swapped registration to do PCI first as that's just for development
> >   boards anyway, so in case both are done we want the platform error
> >   or no error at all if that passes
> > - also fixes some indentation issue in the affected code
> >
> > changes since v2:
> > - handle the situation where both CONFIG_PCI and CONFIG_OF are undefine=
d
> >   by always returning a -EINVAL error
> > - only unregister PCI or OF if it was previously successfully registere=
d
> >
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > ---
> >  drivers/crypto/inside-secure/safexcel.c | 35 ++++++++++++++++++++++---=
--------
> >  1 file changed, 24 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-
> secure/safexcel.c
> > index e12a2a3..925c90f 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -1501,32 +1501,45 @@ void safexcel_pci_remove(struct pci_dev *pdev)
> >  };
> >  #endif
> >
> > -static int __init safexcel_init(void)
> > -{
> > -	int rc;
> > -
> > +/* Unfortunately, we have to resort to global variables here */
> > +#if IS_ENABLED(CONFIG_PCI)
> > +int pcireg_rc =3D -EINVAL; /* Default safe value */
> > +#endif
> >  #if IS_ENABLED(CONFIG_OF)
> > -		/* Register platform driver */
> > -		platform_driver_register(&crypto_safexcel);
> > +int ofreg_rc =3D -EINVAL; /* Default safe value */
> >  #endif
> >
> > +static int __init safexcel_init(void)
> > +{
> >  #if IS_ENABLED(CONFIG_PCI)
> > -		/* Register PCI driver */
> > -		rc =3D pci_register_driver(&safexcel_pci_driver);
> > +	/* Register PCI driver */
> > +	pcireg_rc =3D pci_register_driver(&safexcel_pci_driver);
> >  #endif
> >
> > -	return 0;
> > +#if IS_ENABLED(CONFIG_OF)
> > +	/* Register platform driver */
> > +	ofreg_rc =3D platform_driver_register(&crypto_safexcel);
> > +	return ofreg_rc;
>=20
> If OF registration fails then you will return an error even if
> PCI registration succeeded without undoing the PCI registration.
>=20
... because the _exit does not get called. Crap, did not realise that :-(
Will fix and send a PATCHv4 shortly ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
