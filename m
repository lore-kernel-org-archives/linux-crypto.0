Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664FBC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A6692089F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="vf4FFtUr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfIKPtw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:49:52 -0400
Received: from mail-eopbgr790059.outbound.protection.outlook.com ([40.107.79.59]:32542
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728641AbfIKPtw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:49:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyBU8LwJljQG4I1ZcgJMzZ+dtRUSBEjz2eu3mvh1v0MMLU3q9Hq/A/bmOJir8OD0M2+g6BkCaIkoP2Rmy/XsvX7S/6raKidoWUhmRVkjzFrZBUsnM0L/dS2yNRlGf5sMPzuQgL5cYgYOq60PIblnD4+wgG0eZeTgipTCHfzHL7YisU5S1fC+mxjtTehBTI0CZ33SK/E9xB9KVgPptkGjAGgdlUAWAtf0gV1h+PoFDbamxcxUHBz4RD5uBrjYKOsV6K2WmJS5ZQxU1EyFsQ6gdTUFjiiUSpw9WBP9KppOiYFYbNkanZZd7tPpjDaNGHH90QZiDFlRGCar2jjZQ5eAWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycpDtaSGVFciCN6goy4z4Nq89BvqmWIzuAZbLJ5L4ro=;
 b=LzrwQ/CM0cmI3EkX7TIrZA3BZXFeIx5EfOIQbXcBHHkmC+JQ8X3gLEHbR7mxTGzDB5NdoKcAjB7HL04XhyZnJ6dCHmw74Asefhzt0GemEMPOFvtl+l3PcAo77k1X+cK4Ge/D8Re/5vuV6EGgxzCZrnAzA2vSJhF56NmCSDutRuEKqUrlT23u6Spy7Cp99ZlQCeAmEs8c7CV/ycfL7I6aCQZUgzyeBrwvfiTRQsepls2eoE1LkQ5PNrQDmkvFg3KzjCSThEX0j9Kbx6xAGJsTBKq6TWdQgRfXnkQ2887gSrdYDRuzga2QT/4tw1s+QW6jJM8ja2GFsfrjepajnzubGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycpDtaSGVFciCN6goy4z4Nq89BvqmWIzuAZbLJ5L4ro=;
 b=vf4FFtUrcftda4WxjhHlqoiicARyLaz2VdyM8DxkZPuBZarBj516jxUk/Qc1fE1RAG2CXU+fS4PwO6vLEuIGS/OLF7kEkMkm+A5SUIF8fw9KeLbqQ84ZdU5OmvL4FrY7AFsNoJz+o90UTTGkdEUPoiPtXfDbUdjA4sf0QQ1TKlU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2719.namprd20.prod.outlook.com (20.178.252.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Wed, 11 Sep 2019 15:49:48 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 15:49:48 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/2] crypto: inside-secure - Add support for the
 Chacha20-Poly1305 AEAD
Thread-Topic: [PATCH 2/2] crypto: inside-secure - Add support for the
 Chacha20-Poly1305 AEAD
Thread-Index: AQHVZ+4ol4/3NLRDH0mF4MnFPC9b36cmm6CAgAAAuWCAAAOYAIAAAQLg
Date:   Wed, 11 Sep 2019 15:49:48 +0000
Message-ID: <MN2PR20MB29736EBD0F025DFDB5CF53D9CAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911152947.GB5492@kwain>
 <MN2PR20MB297364B0CA33E6B03041D9DECAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190911154514.GE5492@kwain>
In-Reply-To: <20190911154514.GE5492@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2080732-4b0b-4950-804e-08d736cfad4b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2719;
x-ms-traffictypediagnostic: MN2PR20MB2719:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2719670F1D4224F31479CF75CAB10@MN2PR20MB2719.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(366004)(39850400004)(189003)(199004)(13464003)(66556008)(64756008)(66476007)(478600001)(66946007)(76116006)(52536014)(71200400001)(71190400001)(14454004)(86362001)(66446008)(966005)(9686003)(7696005)(76176011)(6306002)(66574012)(5660300002)(476003)(186003)(6916009)(53546011)(6506007)(55016002)(66066001)(26005)(102836004)(256004)(6246003)(99286004)(53936002)(15974865002)(486006)(229853002)(11346002)(446003)(4326008)(6436002)(25786009)(74316002)(54906003)(8676002)(3846002)(6116002)(316002)(81156014)(81166006)(2906002)(7736002)(33656002)(305945005)(8936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2719;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6CuvxspMlMeov/RUz6sJczjqSPby7VOb0mG1dFCHzzParpCLjAhb3sPHfdCjETXY40DvAjD26gHzpHpSstRB8BS8DgcU3LoQy1c74aRGjV/rnWurBJsLPcFF5NnLNEMF2hbC7ukCG381E+MpzPZiY6pUh3GmhcOm9ciVDyOjPWJLS+k5Ju8hXec7al1NF3+NqmMlIKoRTXZh3bCfgrlPa/QpKfExx/m5YCkKMxFs9ak/wKbULmGHE3KqKsw8LbC/2U+aQu3Ng0Vafhnh1yRZNcTOgJ2eYPAhtLE4SMZcCOYxoTZHHKqS48DP+ShaAGRSfD8dRNdU/1ojTrZcUWj/iuqLGJ0gejOrYszOnfHp1pG8p3Ch2/ZRLz07puxBFXv9uou0vCDrIzqQjdyfndV1CFNuAhYjB+/q/HhRdODA2g0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2080732-4b0b-4950-804e-08d736cfad4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 15:49:48.9041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EN6ITYV9gFeKFzXwl8LvLBiFttCZs7CnJobs2EJxU7jVZDVO4mFQJLLgk7BZNI63MCWg/jZw9wrAg2w/t7vYnkWmXXCV9iX/s7CU3wulLxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2719
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, September 11, 2019 5:45 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCH 2/2] crypto: inside-secure - Add support for the Chac=
ha20-Poly1305
> AEAD
>=20
> On Wed, Sep 11, 2019 at 03:37:25PM +0000, Pascal Van Leeuwen wrote:
> > > On Tue, Sep 10, 2019 at 04:38:13PM +0200, Pascal van Leeuwen wrote:
> > > > @@ -43,8 +44,8 @@ struct safexcel_cipher_ctx {
> > > >
> > > >  	u32 mode;
> > > >  	enum safexcel_cipher_alg alg;
> > > > -	bool aead;
> > > > -	int  xcm; /* 0=3Dauthenc, 1=3DGCM, 2 reserved for CCM */
> > > > +	char aead; /* !=3D0=3DAEAD, 2=3DIPSec ESP AEAD */
> > > > +	char xcm;  /* 0=3Dauthenc, 1=3DGCM, 2 reserved for CCM */
> > >
> > > You could use an u8 instead. It also seems the aead comment has an
> > > issue, I'll let you check that.
> > >
> > I don't see what's wrong with the comment though?
> > Anything unequal to 0 is AEAD, with value 2 being the ESP variant.
>=20
> OK, that wasn't clear to me when I first read it. Maybe you could say
> that 1: AEAD, 2: IPsec ESP AEAD; and then of course the check of this
> value being > 0 would mean it's one of the two.
>=20
OK, agree that that's clearer so I will change it to that.

> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

