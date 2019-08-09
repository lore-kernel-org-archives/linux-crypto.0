Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11BFC31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7831220B7C
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="OtJ26TqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHIVtG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 17:49:06 -0400
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:46704
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfHIVtG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 17:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8XGCfy/kEzaGNb+9gW0w4PHZu309cC7OqmxANQMC42eUm8gqMzyaZ9bglyJNMPudcb2uwfQTm9bJh8tPESe4PSBg59css6LWaANFt0LPgN1MTvYFGyZLmG7G0jQROV7y/TnJKZTz89J+kpAiPItQiqUEGlI1XWRa8wfpXQp+PM9qDlcfOfDsUNT/qP8G1p8OPj2CJW5Z3XKnOiEZx2drPgY7HzvVAYrqCD2qjgL++5q0DJOLX8Rg13/nOhXP15GUL/qlGgLUYgh0kTrmVyNQZzepaYoMe4jz2QgWKmcok7QkMgeTuCJKmpux2jmZQ0+UjVtYr8kMSbAcjvMdBy+7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cciVWgeXzrtbIb6NSIk4CRo7udYuejx1MsQypWHOE2Y=;
 b=bdtaR9yZR8lTnHsWvAgwdeDW86Qix4+ZBsc3MKn41YY8cCsfhKc50kC6OgF/G6Eac7sydrOr7dZFpAYXH3cWjbznGtrNeIS1u5oQGlfAJzoM3Tc8Xv4y+qwkzZ3pKqNFrhc82OJ86Lei3XZDwvW72KNvicW4IQQ1I3T9i4XUapjFyEbQGlwD/gDOIpjl9te+M6exYkShce+sX8GQdU49FkU5k5/lOqCW1owMezQ/wpjY19kFHwpURsbSQFghyAprgQYK7gCbH/fSd5UaItuuzL+74AwMxwUBFPYZkBRyAGZbYsUlXo0sBSHLlx2XB93NNeJMm+LktzgfMZWWS9b/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cciVWgeXzrtbIb6NSIk4CRo7udYuejx1MsQypWHOE2Y=;
 b=OtJ26TqVPdPpAN1IDuU49LY+fkAT8nZMS/9ltsLZMfZkAWyZ9j0lEwtaAmOPZne7nqRRixd61jJjp9octno/iE03xGR/3z6cI7ZSdqg5m6e8ibBMuWY3PEfT+/7MRGCS3lDM0VoarhVX1lbOWTN7GoFXZbOygsl+bsN/sqd2Ohk=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2975.namprd20.prod.outlook.com (52.132.172.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 21:49:02 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 21:49:02 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: XTS template wrapping question
Thread-Topic: XTS template wrapping question
Thread-Index: AdVOpvQVifejpBWTRVyvNwtV/QL5zQAKv5cAAAoo/XA=
Date:   Fri, 9 Aug 2019 21:49:02 +0000
Message-ID: <MN2PR20MB297335494F2E0A07A8E6E892CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809164610.GA658@sol.localdomain>
In-Reply-To: <20190809164610.GA658@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1600a94-9914-4497-021d-08d71d136485
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2975;
x-ms-traffictypediagnostic: MN2PR20MB2975:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2975B585869AC2266FF171BFCAD60@MN2PR20MB2975.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(136003)(39850400004)(189003)(199004)(13464003)(6436002)(53936002)(186003)(99286004)(6246003)(316002)(3480700005)(305945005)(15974865002)(54906003)(74316002)(7736002)(6506007)(53546011)(102836004)(66066001)(26005)(4326008)(52536014)(55016002)(76176011)(9686003)(66476007)(8936002)(7696005)(25786009)(76116006)(3846002)(5660300002)(2906002)(486006)(66946007)(64756008)(66446008)(6116002)(66556008)(81166006)(6916009)(8676002)(81156014)(71190400001)(71200400001)(256004)(229853002)(476003)(11346002)(86362001)(14454004)(478600001)(33656002)(446003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2975;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZAA67xPNXRgvnGUR9IZxZUtGyVMqja20ZySZdLQ0ajJIP7jGvDXhzI+BrhUET4aOG5nBwIQiy7j1wlTMCcvtmDnKTzAtUYKVWOlv3i7g0DeOMl+MfyRK9w/8IMSH1jYwRNJKLp/UejC+rLThrIY3wWS3VtpPXz6Kuprj6X1KZkKD/pvvDaPUR8nEFhdBPy3cWPDJ/KZqicZ41Qw9hwXIYzAQFSuQqAfomwKUnReOjCLbVhg2iAW0Oot1PZl7H1z9GekAIoughDusYL6TWz11kdEOp3upGKljhkE6stBl9Igl4INSB0BlE8XdJNEdI4G9Fa8pos0Z2p9Ej6NEfrv+fjgukdN95qCjqtuznmznSwK4q/KGvaQFpBNpC5nG+LxnesvVmK1y5851/6TwedwcJuDIQqJor8ZqjuaJTj79gVI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1600a94-9914-4497-021d-08d71d136485
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 21:49:02.2228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xLVwAekH9xL9bQ0HalSitz0hjvFH3iZJ5HlBsZo4r/jF+a43MMs1BoBeYRwFeXY+J/Iz8unC+oucuGVzCXzO27qi4NPGo9nGED/DgKh+pHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2975
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Friday, August 9, 2019 6:46 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net
> Subject: Re: XTS template wrapping question
>=20
> On Fri, Aug 09, 2019 at 11:39:12AM +0000, Pascal Van Leeuwen wrote:
> > Herbert, Eric,
> >
> > While working on the XTS template, I noticed that it is being used
> > (e.g. from testmgr, but also when explictly exported from other drivers=
)
> > as e.g. "xts(aes)", with the generic driver actually being
> > "xts(ecb(aes-generic))".
> >
> > While what I would expect would be "xts(ecb(aes))", the reason being
> > that plain "aes" is defined as a single block cipher while the XTS
> > template actually efficiently wraps an skcipher (like ecb(aes)).
> > The generic driver reference actually proves this point.
> >
> > The problem with XTS being used without the ecb template in between,
> > is that hardware accelerators will typically advertise an ecb(aes)
> > skcipher and the current approach makes it impossible to leverage
> > that for XTS (while the XTS template *could* actually do that
> > efficiently, from what I understand from the code ...).
> > Advertising a single block "aes" cipher from a hardware accelerator
> > unfortunately defeats the purpose of acceleration.
> >
> > I also wonder what happens if aes-generic is the only AES
> > implementation available? How would the crypto API know it needs to
> > do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
> > (And I don't see how xts(aes) would work directly, considering
> > that only seems to handle single cipher blocks? Or ... will
> > the crypto API actually wrap some multi-block skcipher thing
> > around the single block cipher instance automatically??)
> >
>=20
> "xts(aes)" is the cra_name for AES-XTS, while everything else (e.g.
> "xts(ecb(aes-generic))", "xts-aes-aesni", "xts(ecb-aes-aesni)")
> is a cra_driver_name for AES-XTS.
>=20
> "xts(ecb(aes))" doesn't make sense, as it's neither the cra_name nor does=
 it
> name a specific implementation.
>=20
Hmmm ... but if xts(aes) wants to wrap around an aes skcipher implementatio=
n,
it will have to search for "ecb(aes)". Since "aes" would give it a single
cipher block (generic) implementation that wouldn't work.
And it adds the "ecb(" somewhere under water in the wrapper, which is very
confusing if you don't know about that.
As it is confusing that there is an "aes" and an "ecb(aes)", aes being a
blockcipher and ecb not being a mode at all, but just the bare cipher.

Considering my hw driver actually exports ecb(aes) and NOT aes due to this,
xts(ecb(aes)) actually would have made MORE sense, IMNSHO.
(implementation wise, not semantically)

The whole thing would have been different if "ecb(aes)" had been just "aes"=
.

> See create() in crypto/xts.c.  It allows the XTS template to be passed ei=
ther
> the string "aes", *or* a string which names an *implementation* of "ecb(a=
es)",
> like "ecb(aes-generic)" or "ecb-aes-aesni".  In the first case it allocat=
es
> "ecb(aes)" so it gets the highest priority AES-ECB implementation.
>=20
> So in both cases the XTS template uses AES-ECB via the skcipher API.
>=20
> - Eric
>
Yes, thanks I figured that out by now ...

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

