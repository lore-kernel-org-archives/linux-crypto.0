Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599B7C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 22:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220E121985
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 22:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Lesl7mZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbfGVW0e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 18:26:34 -0400
Received: from mail-eopbgr770079.outbound.protection.outlook.com ([40.107.77.79]:39355
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728633AbfGVW0e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 18:26:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWBAEeTaxVLNhOEyKbBCVS/2Q+KUMeHsHZvQMjV+4qmujwa7mtfaG+w9qUGMHn83xwBFQ+1TuyvKzSRjC40TWvOUVhJD5nqxSjqzK8aLlf54mbTIduGwBHsXz6Pfs3k2KlfidLDvCoKFLnzJWfzbtAm9D5xgXBj3EUS5r+rnIJCEGsd23weaJu1UnDWUgEFyMYA49WkGO/lvMTkCJ0jC37jlsRkmVnw0Lj8cuiQrNXu3twEfPeZXXjP2EMojQMTX+pTDHTQv9qec6zGcSL75tmiJy6d+OkmycTQG6m8xEEk8K9oVsCAiPTgQJ3AzY9A5PccZkoim8imzT5dWP6I7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tDodlz5JuXps3UrpzanILhjOboD54q646/sk6DnvNM=;
 b=IKVMrj7466HQ8k9YFruY64vEN6B8jNddi3xyEkPPQvJfud8Ajmtapk1ihxeUdJndtarzKCANrS9cWD5u46zY2zw+ptYawuNAohNgo7YbEJlQSzUPTKryCjZQgTYE26hxnNbdZ73yv1M+dX3nLEizEQ/BS3INjPdgTTPm01HNJG1t57gb25kGmlceLUbqp3AeXDuwM5cDz7v8Sh5Np2ejiWcLj6GQdBIc9A/7Wpmw2YKwUyRYrwBIPjO02R6TtXW9DUroULzxkQEhMaOv+F2ZL02iDNDRBlPYSx1I15m5qmBVgj22p5XaSu23B4fd8BIQI0jSWFBzzzFMyhNyiW375Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tDodlz5JuXps3UrpzanILhjOboD54q646/sk6DnvNM=;
 b=Lesl7mZIIkPkaT9q+6Pbzj/DLZM8CkQwiwrPVzNgbZqWPrtCh2MEHpz0bf8Y4m2cnxgTLGfs227PuK9pkrge0OTvraVzYfk2rZMJ7Q6Zv8cf/QV3ycMuQ+CJY6xZr42NoeN88udTgRFB8wcRkdIdywVZef8CMti8VmPNPrz7C0M=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2464.namprd20.prod.outlook.com (20.179.147.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 22:26:31 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 22:26:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: AEAD question
Thread-Topic: AEAD question
Thread-Index: AdVAg8AmA/XQEiKgTqyXrFAlioQdkwAJe5sAAAwi13A=
Date:   Mon, 22 Jul 2019 22:26:31 +0000
Message-ID: <MN2PR20MB2973B95A0C91380CF881FF25CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29734143B4A5F5E418D55001CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722162240.GB689@sol.localdomain>
In-Reply-To: <20190722162240.GB689@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ec13e95-ec71-4519-a917-08d70ef3a56f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2464;
x-ms-traffictypediagnostic: MN2PR20MB2464:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB24641869F85B6C9BCD6F56ADCAC40@MN2PR20MB2464.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(136003)(376002)(346002)(39850400004)(366004)(13464003)(189003)(199004)(2906002)(66556008)(64756008)(66446008)(9686003)(53936002)(8936002)(66476007)(52536014)(221733001)(7116003)(7736002)(55016002)(81166006)(81156014)(6436002)(6246003)(25786009)(6916009)(15974865002)(99286004)(305945005)(5660300002)(74316002)(86362001)(4326008)(8676002)(229853002)(66066001)(6506007)(53546011)(478600001)(3480700005)(6116002)(7696005)(486006)(76176011)(68736007)(54906003)(446003)(71190400001)(71200400001)(14454004)(476003)(11346002)(76116006)(66946007)(3846002)(26005)(256004)(33656002)(102836004)(186003)(316002)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2464;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nYyPWZAFEYbYNaeYMU5vqHgF+YlvB7X1qkA3SI9Y1e60wNbA/KCWFjT7SDq4WTyIsJmZptiIPfuykMPkXanHDPVEt7eASbLLfIBxd5c5c9JGqo5mw4VvQpwfOCS2CCcf7KLSrk3flOVBkZVT6RlAKcziq82WayJDLo/iNbgEhnr/fyyyLVJoKezUBKBiqJOnkUaVUKuECIIT/Fn4tNT6kQdftLexEfphV1oEA25fMTi6xYJODmSBetTz3cTDDQYCjX1tKaTySjvr3bT59zrv7RfiS7Vy6O1UUtha0EU2UEeg4wolhISDa/pQrJarh+Jht2TNu+eJk1lxU0/XvBEEp1hIMF45iXI9Hcvm4GL85aC4SnDTzTRoK3nnH8LH3kChxcGe1e4pV4/dL1d0mB0Oq+834d1nCgi8UFLi0rcvuGs=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec13e95-ec71-4519-a917-08d70ef3a56f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 22:26:31.0125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2464
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Monday, July 22, 2019 6:23 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; davem@davemloft.net
> Subject: Re: AEAD question
>=20
> On Mon, Jul 22, 2019 at 12:55:39PM +0000, Pascal Van Leeuwen wrote:
> > Eric & Herbert,
> >
> > I noticed the testmgr fuzz tester generating (occasionally, see previou=
s mail) tests cases with
> > authsize=3D0 for the AEAD ciphers. I'm wondering if that is intentional=
. Or actually, I'm wondering
> > whether that should be considered a legal case.
> > To me, it doesn't seem to make a whole lot of sense to do *authenticate=
d* encryption and then
> > effectively throw away the authentication result ... (it's just a waste=
 of power and/or cycles)
> >
> > The reason for this question is that supporting this requires some spec=
ific workaround in my
> > driver (yet again). And yes, I'm aware of the fact that I can advertise=
 I don't support zero length
> > authentication tags, but then probably/likely testmgr will punish me fo=
r that instead.
> >
>=20
> As before you're actually talking about the "authenc" template for IPSec =
and not
> about AEADs in general, right?
>
Hmmm .... for the time being yes. At the time I wrote that, I was still exp=
ecting all AEAD's to be
somewhat consistent in this respect (as our hardware is), but actually I've=
 just been trying to=20
reverse engineer the GCM template and IIRC it indeed does not allow an auth=
size of 0.
Or anything below 4 bytes, actually.

>  I'm not familiar with that algorithm, so you'll
> have to research what the specification says, and what's actually using i=
t.
>=20
To the best of my knowledge, there is no formal specification of any such t=
hing. There are
protocols that use it (e.g. IPsec) which have restrictions but other protoc=
ols beyond my=20
knowledge may have other restrictions ... 0 seems very unlikely though ...

> Using an AEAD with authsize=3D0 is indeed silly, but perhaps someone usin=
g that in
> some badly designed protocol where authentication is optional.  Also AFAI=
CS from
> the code, any authsize fits naturally into the algorithm; i.e., excluding=
 0
> would be a special case.
>=20
Again, looking at the GCM template, excluding certain authsizes is certainl=
y not
something out of the ordinary.

> But again, someone actually has to research this.  Maybe
> crypto_aead_setauthsize() should simply reject authsize=3D0 for all AEADs=
.
>=20
IMHO that would make sense. Without authentication, it's not an AEAD.
And actually executing the MAC and then throwing away the *full* result is =
really
silly. More likely to be some programming mistake than actually intended us=
e.
(but if someone knows of an actual use case for that, please do correct me)

> What we should *not* do, IMO, is remove it from the tests and allow
> implementations to do whatever they want.  If it's wrong we should fix it
> everywhere, so that the behavior is consistent.
>=20
Oh, I fully agree there. All implementations should still respond the same.

> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
