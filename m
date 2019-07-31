Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4200C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 14:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B008206A3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 14:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="tjPGs5sU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfGaOIZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 10:08:25 -0400
Received: from mail-eopbgr730085.outbound.protection.outlook.com ([40.107.73.85]:20864
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726607AbfGaOIZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 10:08:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6cd0KuHPi8/Qk2BE5P+HxOJ37jrZli8sTlBaH+iSszn2UqcCUdY6WcQzVJCpg0X1Hg/fmuCItHovpMYDNgMUppuixDW+g0N0fJnM0ELCUofINypc9HHoup4P9xM7aaemVU1RHG6uiCy5t6rF0TnG6Lyy8T4IWyO3L5o5ufdj3MY4Y+2pSc+eTK5YM5KFmoeYoisyoWFvkM36DuteTTXRZkz3MYDs18WSv1/6wcSwRMvCuGpVsDN71xGg7BWVlMTbD00saXb5IOaqfquthGqeUEd/aY2GE+asz/Lfmqn+JzHkDdd8Ab2cM1udSZ8EnCwqfE8e20Gsf/kvKwVwYb4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxqZ/S3m8p/TE1gjcHGMM+XokeMYNSs0iHZf1czWA6Q=;
 b=ekJGT9Ju229wPI+ZKyOdwL4ptt47KJWdgFC8uaIkNEb5G/8pvFauizaiP8HFYNyA2a/GNuPU3058WgJ7fXWxspzNLBHL8F8N7HLu96PfJ2r1mHBHRJmQeHuE1AjuIly5ekPTR+L3Gb5HgyhU0JcM5emrl/vy+VicpQh+RDcr7GXtIQJsN/UJ1KIybhfunDsPp5z3tN6IADZUdQdPWAJvnWOMcq9mxpqAeZxSi+HbNEW1R2g/Ds83L3RlVHYZUiqe/pD4HgjJ04dDZyMWlHgSA+DarauGxVgCRxva+b1uIraGSSNqnFhYAj46g8yY8AXPNPB00KkHYVjbUPmv63IpGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxqZ/S3m8p/TE1gjcHGMM+XokeMYNSs0iHZf1czWA6Q=;
 b=tjPGs5sUe4/Zs+++4ocPbWR4+gEEZoAtlbfPCuptwjVLAWUdd9dqi/TjZ82i8vmy/63n7Uv/Wcc4KVd8R+SK2LysRpHoZApQt/B9GclWerUkEcwLFpxt+FuHOfl0bgppiAHwo3+8pu4MbKWeBmIaJCThllGjWgQKX+oRNP5oGI8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3277.namprd20.prod.outlook.com (52.132.175.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 31 Jul 2019 14:08:21 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 14:08:21 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVQ7iGiGasvxZ/1k28+z4dWUzE9abi5S6AgAAAqWCAAEv+AIAADciwgAFrh4CAAAWWEA==
Date:   Wed, 31 Jul 2019 14:08:21 +0000
Message-ID: <MN2PR20MB2973F926269582FA8A10DDE0CADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730134232.GG3108@kwain>
 <MN2PR20MB2973FA07F5AB41D99A9FADD4CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190731121259.GB3579@kwain>
In-Reply-To: <20190731121259.GB3579@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c108f58-89e1-483c-682d-08d715c08bc7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3277;
x-ms-traffictypediagnostic: MN2PR20MB3277:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3277CC1BA31609560FFC6BC8CADF0@MN2PR20MB3277.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(346002)(396003)(376002)(366004)(13464003)(199004)(189003)(86362001)(11346002)(3846002)(55016002)(446003)(8936002)(476003)(66066001)(8676002)(52536014)(6246003)(486006)(81166006)(81156014)(4326008)(6436002)(33656002)(229853002)(74316002)(15974865002)(186003)(26005)(25786009)(102836004)(53546011)(6506007)(6116002)(6916009)(76176011)(305945005)(76116006)(478600001)(256004)(2906002)(66946007)(66556008)(64756008)(66446008)(66476007)(54906003)(7696005)(5660300002)(68736007)(53936002)(14454004)(9686003)(7736002)(71200400001)(71190400001)(316002)(99286004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3277;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wJizDOrZGQDCW38LnPDzvJkt6LLIyeAN5qcBXyW+3CB8dAqA3dn3EAFIdsqMN3wiNEQNARa5At2QtkKsNFJen1fiSD3JIwgEZ/A8r/g03mnWhNx8WGqrPuKomFXURvmuIZ0CDUKXWDy8Ycjcqt1PzgfrIhJABE5Nlvz/rR20jVNL14shZnXJ6QL/51LyK5WTfuWJ65XZSXpHJZ45UZXze0XDpH/Xm73eyq7IVaQHaMdmxQILe4W5Gir5MYCycpzPp3pzE6WYOBh/Lvw0Q13qCKYSeYVDlQ4HiCZwtbYh4DbmQ6ycIMlQBphOa/GNKnPPZocn3ankf0dp7/ZAPGOrT8S5ET0NhxZOFdhJ1S1RewUkmfivIZ3btxAP8zkX20m22fZFvK6C8trMj3hXYwQrH31vTG1I7lQTOW+6M1sHiyU=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c108f58-89e1-483c-682d-08d715c08bc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 14:08:21.4732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3277
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, July 31, 2019 2:13 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
> > > > > You're moving the default choice from "no firmware" to being a sp=
ecific
> > > > > one.
> > > > >
> > > > The EIP97 being the exception as the only firmware-less engine.
> > > > This makes EIP197_DEVBRD fall through to EIP197B firmware until
> > > > my patches supporting other EIP197 configs eventually get merged,
> > > > after which this part will change anyway.
> > >
> > > We don't know when/in what shape those patches will be merged, so in
> > > the meantime please make the "no firmware" the default choice.
> > >
> > "No firmware" is not possible with an EIP197. Trying to use it without
> > loading firmware will cause it to hang, which I don't believe is what
> > you would want. So the alternative would be to return an error, which
> > is fine by me, so then I'll change it into that as default.
>=20
> Sure. When you look at this it's just weird to have a specific firmware
> tied to an 'else' without having a check for a given version. Having the
> "no firmware" option as the default option or not does not change
> anything at runtime in practice here. If you prefer throwing an error if
> the version isn't supported, I'm OK with it as well.
>=20
Agree that it was weird, not loading anything was bad too.
Glad that we both agree on throwing an error :-)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
