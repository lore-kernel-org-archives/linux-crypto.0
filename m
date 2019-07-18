Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A91C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 16:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C9721019
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 16:36:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="lW9+dISA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfGRQgJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 12:36:09 -0400
Received: from mail-eopbgr810048.outbound.protection.outlook.com ([40.107.81.48]:49824
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727685AbfGRQgJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 12:36:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHJM1dSYG9ffKAp1JyCnkDhEqs1ikmF1tsvwujnJokUgd6GQwyzj6tICLlSDx92apYRV3n4QpNW0M++ii8nK68dF/T6ix3b90PJscNEtqVpfZqUl5PULVRr6rXBFPLJDl/3rVVqJn51f60PZbXjG5WdWL7MpYONLSIwoIG3Wnhuce/qQjJglIRnOwqxdB//ZGU/6fQJVSiXrqnYTlLp12J8a5Egkgj+dOdsMObop4I57VhNyUD8OWiKJijpMg1/S7y/E4np+wP8OIbroyb61gQHrPcVNMrZ4hgXjLe+evXO0xrwjJAlfDFwn9fP6STrz5itQpv+y1TbTKw6zQmQzDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0epjR9DaWOazRQIynmnqUiLNgxoSDQImt23yOYXDnY=;
 b=YgfeL2AAmtwOtlF3dDkA2bj7rOR8HEmaTdyswAZEXkcT9Iyjz8bC5hD2nga2DoJ3Tu+MnEf5mdZHIa3u8OQn9e41N9fEsfBW2ufP9Nd+yTSpRZpgWume+mI0Y4qORX52zTZjOIlMO2BNMWkt3tlFPz/IM4lFPildK0VORv6BbkqZmd7bAMAr+oRkzTPaIxAo0LDK7cDBWRpbmbTTNuIz6F1uT4lOLJQW+K/sM+pXzntuYTYdEACx+mGyro1BFoWvEZV87Do9vyLcye999DrtVrgEDCq6ceo6+IrmgiqV78WwV1HpG9mgQTBsjqasDqix47zrcSIs88FCci4ptgyPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0epjR9DaWOazRQIynmnqUiLNgxoSDQImt23yOYXDnY=;
 b=lW9+dISA9FoyIeRXROugeNG8iY/FsXBB717fRrXcxoGU6nUUR0eZGyPhUUeBpn3BoWAWBoZ/ISEo0xTXEkytesGf3ORn9PIiFGFR+2dzar/VRGxk1Wog42S+PoC6QYRLc2Bfa8V4HOGTieOcU5M/oTJ/ur91OLxpwkbbV7ebwcQ=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2335.namprd20.prod.outlook.com (20.179.148.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 16:35:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 16:35:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: xts fuzz testing and lack of ciphertext stealing support
Thread-Topic: xts fuzz testing and lack of ciphertext stealing support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgABt8gCAAADKkIAABYEAgAAAS+A=
Date:   Thu, 18 Jul 2019 16:35:26 +0000
Message-ID: <MN2PR20MB2973DE83980D271CC847CA6BCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
 <MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
In-Reply-To: <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fedc79f0-c6d9-42de-45e2-08d70b9df081
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2335;
x-ms-traffictypediagnostic: MN2PR20MB2335:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB23350FEF13E1F62F373C5EE6CAC80@MN2PR20MB2335.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(136003)(366004)(346002)(396003)(199004)(189003)(99286004)(476003)(7696005)(316002)(486006)(86362001)(256004)(446003)(4326008)(33656002)(68736007)(11346002)(8676002)(6436002)(8936002)(14454004)(81156014)(81166006)(3846002)(66066001)(2906002)(6116002)(66946007)(107886003)(52536014)(6506007)(55016002)(54906003)(9686003)(6916009)(64756008)(478600001)(66556008)(966005)(66446008)(76116006)(66476007)(7736002)(305945005)(74316002)(229853002)(15974865002)(76176011)(6306002)(53936002)(5660300002)(6246003)(71200400001)(71190400001)(186003)(25786009)(102836004)(26005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2335;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XSlTTdca9t8zIgL4CriYPV12r/ALOfUtU9QkaAjXzYwxo8AHkj3UIFB5zV6QuIhIzTZ1bo8ow31THhE+/TAMlZxU4xWUE/rzVXgVRmVgCBKr5ZBYAwO11OAMRjrLrh6QJbHMOH4BAXKkCNh5druImmxjS9vdh0AtG3hNAX9LSYPA/KJv5m/DkhRiKyJ40q3GeoSG4cwVdw/PSwN1dfjhaFn37JQWrhD8Qf7rOa1fPkJh61TamHSEEI4DT0+5y39CZShzmqAvEYFiqMQqYBS6A3dhURWWvujv6rMMqYTqvLVLiAOOv9lUsv7lEjZt+AoJfwkm/h2B0U/DgCqc0Yb9knj1Btw1elb3k8cG/XMBdKJFm9NvAHa3+K9FoBjH82iN6CQdq/9AF65hOkPd65huzIp8fGpcHhU6KiCiX86aRRE=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fedc79f0-c6d9-42de-45e2-08d70b9df081
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 16:35:26.7110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2335
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> >
> > Hmmm ... so the generic CTS template would have to figure out whether i=
t is wrapped
> > around ECB, CBC, XTS or whatever and then adjust to that?
>=20
> That's not hard to do.  Right now cts only supports cbc.  IOW
> if you pass it anything else it will refuse to instantiate.
>=20

Ah, I see it now:

if (strncmp(alg->base.cra_name, "cbc(", 4))
		goto err_drop_spawn;

So you cannot even do cts(xts) at the moment.

> > For XTS, you have this additional curve ball being thrown in called the=
 "tweak".
> > For encryption, the underlying "xts" would need to be able to chain the=
 tweak,
> > from what I've seen of the source the implementation cannot do that.
>=20
> You simply use the underlying xts for the first n - 2 blocks and
> do the last two by hand.
>=20

Possible, but then you're basically pulling a generic XTS implementation in=
to cts.c,
since XTS is nothing more than the repeated application of just that.
Same thing would apply to any other mode you eventually need cts for.

But I suppose it would save you the trouble of having to add cts to all ind=
ividual
optimized software implementations of xts-which-is-not-really-xts, so I can=
 see=20
WHY you would want to do it that way ...

Tthen there's still the issue of advancing that last tweak. From what I've =
seen,
the xts implementation does not output the last tweak so you would have to=
=20
recompute it locally in cts.c as block_cipher_enc(iv) * alpha^j. Which is w=
asteful.
Of course this could be solved by redefining xts to output the last tweak
like CBC/CTR output their last IV ... Which would probably give us HW guys
trouble again because our HW cannot do *that* ... (While the HW very likely=
=20
*does* implement the cipher text stealing properly, just to be able to boas=
t
about IEEE P1619 compliance ...)

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
