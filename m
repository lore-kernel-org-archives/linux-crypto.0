Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40D1C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B69532238C
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="iYg53RO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfGZNin (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:38:43 -0400
Received: from mail-eopbgr680056.outbound.protection.outlook.com ([40.107.68.56]:23399
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbfGZNin (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:38:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1HdT1Ji87NbpAm+mT0ARjyK9csrnH5XGSzV7awD6+RDqFsjjkYBVoodu2BdmUPUI6IzCkaKzCQfqPAU842K/BL4/W9Jym5W6qurVjGCOqfdUzhehZ0NhvnQ4YmF4TKY0kVw5Jza1TzyD0eHUgP7om9Z1s5LKQjrN+n2Na6m/ik1QjyOecZQkmGfNvfctD7aO7sQy+SpiOc9ryORqJmjmIIhgiMQwhh6dcAnf/qffJqcOfW/xco7HKQwJCFDAnSG9bNpBlNLDXMRULjNLNfXv5xadEcHqg6662yoQ0PI6lCwJQAPDoaqobnuJSyPwN0J52I1BJzyuPPJe0eWFW2Lng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBxRsnehKokC9O4qN/+PZxjQWASFfo2k1UTDaYrX3jY=;
 b=WrAwfd24O5X+Sj6PL3L4izVOf9JQ+X3yfPahgpvpi8lTcCdhTQ5l6ltn+GMweHvhD707+VODFN/iKl4UWMfFAtC1ktRiY5K/MbifSUIDzWY3zSiriE3W/dLHDATuh4QPTBy4rgiepXOWUSwcrIDGlKLpKDnb7/2B0hq5XDbzfQF9gykS7TzC+XVCpcIjsAyl6Rsj9Z/Gt751me/aNoRCLbCIBjhfcQ0B3t9UcdOyo2fe9k1NAhSdm7M4jn2wHkluCC/iAKmjVIfFl78rXTd70dCNdCeMepzEqxQcbIPdV2A+odKOal4Jafixh8DK0S5ohVfmnshhOV1SKi+XXtZ/tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBxRsnehKokC9O4qN/+PZxjQWASFfo2k1UTDaYrX3jY=;
 b=iYg53RO9ExzNRaCPLi+aykaRCtPUnZwl5O26YoRW04nnEBZnffCvzpQVF62BwDDUzIqm+KC8HKem2cOZ+VtSYS99Xqsyjg8B7tWUjOK8vzOPEiF+vZ7+84DcvVUzeIUUkzFQgV9WrFX5s6zFeEUALXgKHheg9Y+NbjM5qLsmYBc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2975.namprd20.prod.outlook.com (52.132.172.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 13:38:37 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 13:38:37 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Thread-Topic: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Thread-Index: AQHVMwaxl7vezQ4XF0yNrfTnczMQM6bc8rsAgAAGFCCAAAdAAIAACBrQ
Date:   Fri, 26 Jul 2019 13:38:36 +0000
Message-ID: <MN2PR20MB2973B22C06721A0E880F2526CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726121938.GC3235@kwain>
 <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726130720.GC5031@kwain>
In-Reply-To: <20190726130720.GC5031@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4946f36-25c0-4629-5737-08d711ce903a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2975;
x-ms-traffictypediagnostic: MN2PR20MB2975:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB297504FF664F2452AC78E105CAC00@MN2PR20MB2975.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(396003)(376002)(366004)(136003)(189003)(199004)(13464003)(81166006)(11346002)(486006)(26005)(52536014)(446003)(478600001)(6116002)(74316002)(7696005)(316002)(476003)(81156014)(8676002)(66066001)(256004)(15974865002)(5660300002)(186003)(305945005)(54906003)(33656002)(71200400001)(66574012)(76176011)(86362001)(99286004)(8936002)(53546011)(64756008)(66446008)(66556008)(9686003)(53936002)(6436002)(6506007)(102836004)(6916009)(55016002)(7736002)(76116006)(2906002)(71190400001)(14454004)(229853002)(6246003)(14444005)(66476007)(4326008)(966005)(3846002)(68736007)(66946007)(6306002)(25786009)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2975;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /YN/LKrFLN1H2LEaSg7aaUMP09RmeIMvNyJfQbPPALPZV2cn8LhZZz7OwNnU9trHQsepEryCT9bRFrERBBzSX9nPoJ+KVzNuvai50g5Sy8EcZCcFuuskEUPh+0nuiLpaWtkzKiwcdy2C0rSxlQh8HkHFPPP9Lsnb+Zzp1snrcgQC+ZDTiINC0+wT6SfrlvpfEdU8iv7GD3KZV5UmJAH+jLqDTNwZh3Dpy8sQt4GWcLBbqYItR3Zoda0UNmsD4maVNOkmAt+HzykqpD4bwd0bU3DgMF/kZ6sAhDFukzUJtO9NwcMbVbXPMk86naINVBhfHO+ueS3egjOBBsETSpQlo3YATN3SDKbb9FvNVswjLFsmCusQc3OjXPfqTBhqQMngIKgVDaCdsDexWqVnOtmcKXT8919b1hN21mAKwDtA3Cc=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4946f36-25c0-4629-5737-08d711ce903a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 13:38:36.8637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2975
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Antoine,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Antoine Tenart
> Sent: Friday, July 26, 2019 3:07 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH 1/3] crypto: inside-secure - add support for authenc(=
hmac(sha1),cbc(des3_ede))
>=20
> Hi Pascal,
>=20
> On Fri, Jul 26, 2019 at 12:57:21PM +0000, Pascal Van Leeuwen wrote:
> > > On Fri, Jul 05, 2019 at 08:49:22AM +0200, Pascal van Leeuwen wrote:
> > > > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > >
> > > Could you provide a commit message, explaining briefly what the patch=
 is
> > > doing?
> > >
> > I initially figured that to be redundant if the subject already covered=
 it completely.
> > But now that I think of it, it's possible the subject does not end up i=
n the commit
> > at all ... if that is the case, would it work if I just copy-paste the =
relevant part of the
> > subject message? Or do I need to be more verbose?
>=20
> The subject will be the commit title. I know sometimes the commit
> message is trivial or redundant, but it's still a good practice to
> always have one (and many maintainers will ask for one). Even if it's
> only two lines :)
>=20
Ok, good to know. I'm still learning how this works. I'll try and remember =
;-)

> > > > @@ -199,6 +201,15 @@ static int safexcel_aead_aes_setkey(struct cry=
pto_aead *ctfm, const u8 *key,
> > > >  		goto badkey;
> > > >
> > > >  	/* Encryption key */
> > > > +	if (ctx->alg =3D=3D SAFEXCEL_3DES) {
> > > > +		flags =3D crypto_aead_get_flags(ctfm);
> > > > +		err =3D __des3_verify_key(&flags, keys.enckey);
> > > > +		crypto_aead_set_flags(ctfm, flags);
> > >
> > > You could use directly des3_verify_key() which does exactly this.
> > >
> > Actually, I couldn't due to des3_verify_key expecting a struct crypto_s=
kcipher as input,
> > and not a struct crypto_aead, that's why I had to do it this way ...
>=20
> I see. Maybe a good way would be to provide a function taking
> 'struct crypto_aead' as an argument so that not every single driver
> reimplement the same logic. But this can come later if needed.
>=20
Agree. But being a newby and all, I did not dare to touch des.h itself ...

> > > > +struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_de=
s3_ede =3D {
> > > > +	.type =3D SAFEXCEL_ALG_TYPE_AEAD,
> > >
> > > You either missed to fill .engines member of this struct, or this ser=
ies
> > > is based on another one not merged yet.
> > >
> > Yes, that happened in the patchset of which v2 did not make it to the m=
ailing list ...
>=20
> :)
>=20
> So in general if there's a dependency you should say so in the cover
> letter.
>=20
I'll try to do that insofar I actually realise such a dependency exists ...

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
