Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2252FC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 13:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B3E206BB
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 13:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="goRlJ/cA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390567AbfIFNCC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 09:02:02 -0400
Received: from mail-eopbgr800042.outbound.protection.outlook.com ([40.107.80.42]:1184
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728507AbfIFNCC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 09:02:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCgVTbAbm7dXpvr4kHaYepkWVIiJ7H7oFhduzCol3aRvmgDB3pvCNSBeH0TeNPELqupECLBYpZCMkwEwB1M9PapUkVe/sOHUBcSNnaRxeReWk9BUmyBIisjRSaTk972B6WZ+SYT1BEk9I29GM66Vb37xUJPmI6VibGZ7JNR/L9BXDtv/k5XoIiRMqB+uKRkHewTEZCCGyeCPFnI16zhFONGAXzg1Gpq0k8/qzRG1U/nvkeu8eRESwalKYrimw8eRbrVmZNqtMQkLL1+JMlJCGEiaquSBNCq9dQKb7fWD+qGy7ARJWViDRj754LJMcNzRu0+0k306WkfHuXQ6UwIoFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkekO87vb5RPRB9nisxs73TKxu4Mk485Ag3DU3g42CA=;
 b=Lq+Y+SnIu/a2JmgsowY6RFGPwSS1Ib4zy2xJIvBu4+8kZt/+ScGeGgTAY9d7zSBWj2++zmyHoSywfLwi7HHrqiFBPRlKQO2ZHzhJtNvi1FDh/iDMeYcfy5TaphBNXcYSDdMOc0CL9jVxROMVCM118e5ighGjWAX6UlYnVrH1cBBNEP7l0XHO4kzwlG8he50S8gY0dyrhT4Ftk2qrr1fhFd11KIvOTqVDUqj4EStGr2JFd2gbso6A9FFQ6RDBCnpbocN5f4E7NcEyRVVvwjwXjTp1UybaPHSBD6VMRm2i+YHKstcgmoeg/Bx93pJC631ELpSfG3CwFa5MFuiJyKOd/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkekO87vb5RPRB9nisxs73TKxu4Mk485Ag3DU3g42CA=;
 b=goRlJ/cAJyHd27FV+EIN5FAV0Pe3Need5zFJ+ebKbshnTig+D21HVUvi5F771/vlejrJS7aZkJCSeSuSLMhUehmD87jwG0PyOaiIfWBL7GhwL4o0zp1bCjGq7QG43aMkqqKE8PCbwMkZAETCgakcuguo1uifHNie82vPNIMOV+M=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3277.namprd20.prod.outlook.com (52.132.175.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Fri, 6 Sep 2019 13:01:20 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 13:01:19 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: RE: [PATCHv2] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Thread-Topic: [PATCHv2] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Thread-Index: AQHVZJLkcblhpiNCdkqzLJoi3G2RDacekUyAgAAKwpA=
Date:   Fri, 6 Sep 2019 13:01:19 +0000
Message-ID: <MN2PR20MB2973DC6D4E1DC55EB1AF2825CABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567757243-16598-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190906121843.GA22696@gondor.apana.org.au>
In-Reply-To: <20190906121843.GA22696@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1e57a1f-ad35-4b01-4e64-08d732ca4fc9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB3277;
x-ms-traffictypediagnostic: MN2PR20MB3277:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB32778B1E14917272D5E6EEAECABA0@MN2PR20MB3277.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(136003)(396003)(366004)(346002)(199004)(189003)(13464003)(6246003)(26005)(6506007)(53546011)(102836004)(76116006)(6436002)(99286004)(76176011)(186003)(7696005)(25786009)(66946007)(66476007)(66556008)(64756008)(66446008)(3846002)(6116002)(4326008)(9686003)(55016002)(6306002)(53936002)(52536014)(966005)(478600001)(71190400001)(71200400001)(446003)(11346002)(476003)(486006)(14454004)(14444005)(256004)(33656002)(81166006)(81156014)(8676002)(5660300002)(74316002)(305945005)(7736002)(86362001)(2906002)(66066001)(229853002)(8936002)(316002)(54906003)(110136005)(15974865002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3277;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TBYeLl+OYnF3UG/G8yMykBwAhA3Fe2FJ0Fo+PeEp5CWTvr3qQQ+l+FVjO9/SImDo1cutA+z6zFJbNwtmRGpEzqZyCoSO+CeCxHPru+nDIQcqwrGofMrIpIM4LFNiEtY/SpgHMvWP2ps3eMtAIrEB5Kmbv4dFc3t9nlhyDMxirAjzs6Yavu0C5o7eXz2uOs3IfhENE2alPWr+XW3qQZGpyb+0C8+mU6d8FxitxXi5p9zVPV8oEtt4ZbeuIyJFqI5QrlPfgKiYEKWSVpin0zmKslWOVrbBwACDbbJsMjjsH81X0I4vVsaKE1GeNmABCvihztbeIr63zictTG4JrS6EL7oyMiVtHbjgIpUW6UYtYcBQcytcBi4QVzawkfk3W969LQ8rMNi8HnAlXJ1yVVt+v/R+jSdcyatI+jgnbFtlISQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e57a1f-ad35-4b01-4e64-08d732ca4fc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 13:01:19.8820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +UgS0ohogf3pvGBFR3EupxPr9NXld2wpTwnhufMVDRazVQKdH2oyWYXBRhkACaGkokXB9KzzIoPY9DSktVRFf7ZqIWYA6RdFTYL9sW50B2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3277
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf
> Of Herbert Xu
> Sent: Friday, September 6, 2019 2:19 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net;
> Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Bjorn Helgaas <helgaas@k=
ernel.org>
> Subject: Re: [PATCHv2] crypto: inside-secure - Fix unused variable warnin=
g when
> CONFIG_PCI=3Dn
>=20
> On Fri, Sep 06, 2019 at 10:07:23AM +0200, Pascal van Leeuwen wrote:
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-
> secure/safexcel.c
> > index e12a2a3..2331b31 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -1505,29 +1505,29 @@ static int __init safexcel_init(void)
> >  {
> >  	int rc;
> >
> > -#if IS_ENABLED(CONFIG_OF)
> > -		/* Register platform driver */
> > -		platform_driver_register(&crypto_safexcel);
> > +#if IS_ENABLED(CONFIG_PCI)
> > +	/* Register PCI driver */
> > +	rc =3D pci_register_driver(&safexcel_pci_driver);
> >  #endif
> >
> > -#if IS_ENABLED(CONFIG_PCI)
> > -		/* Register PCI driver */
> > -		rc =3D pci_register_driver(&safexcel_pci_driver);
> > +#if IS_ENABLED(CONFIG_OF)
> > +	/* Register platform driver */
> > +	rc =3D platform_driver_register(&crypto_safexcel);
> >  #endif
> >
> > -	return 0;
> > +	return rc;
> >  }
>=20
> According to the Kconfig it is theoretically possible for both
> PCI and OF to be off (with COMPILE_TEST enabled).  So you should
> add an rc =3D 0 at the top.
>=20
Ok

> You also need to check rc after each registration and abort if
> an error is detected.  After the second step, aborting would
> also require unwinding the first step.
>=20
I explicitly DON'T want to abort if the PCI registration fails,
since that may be irrelevant if the OF registration passes AND
the device actually happens to be Device Tree.
So not checking the result value is on purpose here.

> So something like:
>=20
> 	int rc =3D 0;
>=20
> #if IS_ENABLED(CONFIG_PCI)
> 	/* Register PCI driver */
> 	rc =3D pci_register_driver(&safexcel_pci_driver);
> #endif
> 	if (rc)
> 		goto out;
>=20
> #if IS_ENABLED(CONFIG_OF)
> 	/* Register platform driver */
> 	rc =3D platform_driver_register(&crypto_safexcel);
> #endif
> 	if (rc)
> 		goto undo_pci;
>=20
> undo_pci:
> #if IS_ENABLED(CONFIG_PCI)
> 	pci_unregister_driver(&safexcel_pci_driver);
> #endif
> out:
> 	return rc;
>=20
> As you can see, these ifdefs get out-of-control pretty quickly.
> In fact, we can remove all the CONFIG_PCI ifdefs by adding just
> one more stub function in pci.h for pcim_enable_device.
>=20
I'm fine with that, too. I did not want these ifdef's in the first
place, I was asked to put them in.

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

