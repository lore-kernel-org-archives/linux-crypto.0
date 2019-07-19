Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3536FC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 21:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C6120880
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 21:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="iAyO4hcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfGSVaZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 17:30:25 -0400
Received: from mail-eopbgr740047.outbound.protection.outlook.com ([40.107.74.47]:22329
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727603AbfGSVaY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 17:30:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdWYbyCSzBnrkiteVy5eBHCFomJzejStAozcvFkq3RPlq29SBmnFpOq7P370Vlmk89SvQHwrkKZ8z0NnCby6ftjxp3SI9FQcatLrElcdg3dWXpkNV49cI460d8kWsbEy1ldjQ5pLk/Kv4Uo919Fcy6medIXGgor7JWqu8u8Cd+hK50T6btdJtVEP7aFysEvCcu0qeyaHSPmsn+s5ZsyeBbdE8i9Cs5pgaMO+GYLAZDlTbZ3zivw7Dn+JKM88QPanq+etxESCWnzcSuTE0GqsoteYN0BfUYe+vXkgSufU+67EBX5g3Dp91fJqEP69Kp/kNpbZ4dxuhGAROeO84gGILA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozAkjPm+liby2xLcQVOIVPyqIrCnD0W33vtOCR/WGVE=;
 b=HRFUJXj4WshYB1mGXtoYWeVU8KQGSaF//7myyDXWawYSejZmzS0A3+Jd0/++3AYQp53D+ZveWo5M6iwV/LzGUPeqBS+TEGdsQR/aS+fq7O2jJJotEfkT6VI2aZnzgHf+d/lNkdYdrspPl4mbCu8PpCYDp98NxtJTk0RwOwCNTtfrWuzZYuSy24u0AJJ0Ye7ObVC7ea+zxkv8Rv83bRB52MfYX3rpA4PA66jOvE3l2lcQmJOZIVEzrgqLUq/Bx3vYqVbHb6a9eldxHO7xoBd6bjBqkQHN3X61bdeXoI4RzDMMfSc+Jn/vuY829EKHchLFYzYbEfHpAtm8zBr4SCeQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozAkjPm+liby2xLcQVOIVPyqIrCnD0W33vtOCR/WGVE=;
 b=iAyO4hcb7eLUMawb96GHJEvmXqhVtIthNOZC94DKOHxY1Jx04uLl5twa42wvl3vcgGiMNgnqNRqAYPtKFQI16cES+6z33KzkkpI5PLd/p+MkJs5x6iviuw/cgwzhdoc3M3YxidI8oBTQDqtHu41E91s/PFLrCgHB4ckQ1S1TvMg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3167.namprd20.prod.outlook.com (52.132.175.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Fri, 19 Jul 2019 21:30:20 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 21:30:20 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: generic ahash question
Thread-Topic: generic ahash question
Thread-Index: AdU+Pz/3ICV8h5GxTo+QH6d8mlFU5QADv2sAAAZoRqAAAWujAAACfEgg
Date:   Fri, 19 Jul 2019 21:30:20 +0000
Message-ID: <MN2PR20MB29737E72B082B6CAA43189FACACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB297347B80C7E3DCD19127B05CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719162303.GB1422@gmail.com>
 <MN2PR20MB2973067B1373891A5899ECBBCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719200711.GD1422@gmail.com>
In-Reply-To: <20190719200711.GD1422@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a27a63b0-15a9-4cb9-3922-08d70c904d38
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3167;
x-ms-traffictypediagnostic: MN2PR20MB3167:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB31677EDA58AC2547D6583A5BCACB0@MN2PR20MB3167.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(199004)(189003)(13464003)(7116003)(76116006)(81156014)(66476007)(66556008)(64756008)(66446008)(66066001)(81166006)(52536014)(5660300002)(66946007)(6916009)(3846002)(6246003)(6116002)(53936002)(478600001)(25786009)(9686003)(2906002)(229853002)(55016002)(86362001)(6436002)(14454004)(53546011)(3480700005)(14444005)(256004)(7736002)(6506007)(33656002)(7696005)(71200400001)(71190400001)(74316002)(305945005)(316002)(476003)(8676002)(446003)(76176011)(11346002)(68736007)(8936002)(4326008)(486006)(26005)(99286004)(186003)(102836004)(54906003)(15974865002)(41533002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3167;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: at4xrIrJJ3UOHA6bAnvcnKLN0CNNJ8zDDLUxyVmxsecO+20N7X4viHh1y75G8XYVVG+GCZKDrUXSZCmp4Y75pmck9MChFuZ4f85Kwl9KZi4nXInjgDcTPYw/hWciMlkDf4CRJrL/jdu8b+Wdh3E3WrFTk9eXD1q+gatC9NGBGlZLmMS9TmPYiDUpSbn0HlefKjul+wWXqiMrkfpn8vOQHmikXNRgdvfTSrtK0Aqr7PnZNLCULfHcrusFCRmeJQ3/l5cU62vYNYff3THOb7SNW6kpGl5GRi2SaTKiBlm0cfuqJgGy7uiF6aeNj+hM9iZ00fAxYt06Xdjc6+rGXz7dRUMWIe0qs9LcLXijVQfrdiJCMmJXEJvumT4FIQSw4oi/KqsXQHerO7MWmElbY51qaNDzew33DTD0qtkHZodL6hY=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a27a63b0-15a9-4cb9-3922-08d70c904d38
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 21:30:20.4579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3167
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Eric Biggers
> Sent: Friday, July 19, 2019 10:07 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; David S. Miller <davem@davemloft.net>
> Subject: Re: generic ahash question
>=20
> On Fri, Jul 19, 2019 at 07:33:30PM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> On Behalf Of Eric Biggers
> > > Sent: Friday, July 19, 2019 6:23 PM
> > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.or=
g.au>; David S. Miller <davem@davemloft.net>
> > > Subject: Re: generic ahash question
> > >
> > > On Fri, Jul 19, 2019 at 02:41:03PM +0000, Pascal Van Leeuwen wrote:
> > > > Hi,
> > > >
> > > > I recall reading somewhere in the Linux Crypto documentation that s=
upport for finup() and digest()
> > > > calls were explicitly added to support hardware that couldn't handl=
e seperate init/update/final
> > > > calls so they could at least be used with e.g. the IPsec stack.  I =
also noticed that testmgr *does*
> > > >  attempt to verify these seperate calls ...
> > > >
> > > > So I'm guessing there must be some flags that I can set to indicate=
 I'm not supporting seperate
> > > > init/update/final calls so that testmgr skips those specific tests?=
 Which flag(s) do I need to set?
> > > >
> > >
> > > Where does the documentation say that?
> >
> > For finup:
> > "As some hardware cannot do update and final separately, this callback =
was added to allow such
> > hardware to be used at least by IPsec"
> >
> > For digest:
> > "Just like finup, this was added for hardware which cannot do even the =
finup, but can only do the
> > whole transformation in one run."
> >
> > Those statement sort of imply (to me) that it's OK to only support dige=
st or only finup and digest.
> >
>=20
> Can you send a patch to fix this documentation?
>=20
I could add some big fat disclaimer somewhere, but admittedly I just did no=
t read or
remember thoroughly enough. And perhaps my memory was just being selective,
only remembering the parts that suited me well (it usually does :-).

Still, it seems rather odd to on the one hand acknowledge the fact that the=
re is=20
hardware out there with these limitations, and add  specific support for th=
at, and=20
on the other hand burden their drivers with implementing all these fallback=
s.
That's why I assumed there must be some flags somehere to indicate to the A=
PI
that it should not bother my driver with requests requiring init/update/fin=
al.
Which I now know is not the case, so fine, I either implement the fallbacks=
 or I
just don't bother supporting the algorithm.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

