Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85468C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 10:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A28721479
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 10:50:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="mThLRYXs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfIIKu2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 06:50:28 -0400
Received: from mail-eopbgr800078.outbound.protection.outlook.com ([40.107.80.78]:6778
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfIIKu2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 06:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBODqsIesDrJGlD5lS2azc8pkL2oJS2g4JxqSD/Z49chQlYne83bwdGoiRVikRfWN5otoHGPUFxnzk4SgXdTNZzsQX55zID5mUWM58dmd9AuqhqC25HT1sBLYPQeY5/V5cedC/UAflRyZuEilj1NvLHXYd7s92CYFT5GPZj76ngEe/Vc3cD3nXlFKhev6JToKL07mHCmDiQDZLxZd15t6kKIqyGbnlyL9z6Y+AU8bD0QyXpWjMs7rJY/FPJWY7AeQkiA/fIlhWHjHWOQMqd97ihYPwsL/n0f4Za0wd4Jl3TcKOR5AThmWDb6B4J1wSAtgiiKX4jHCAZaNflxcAUF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zm1X2RM5qtQrtsuKj9Sv4M4QU2l5QAwkkCcSE1YkBJs=;
 b=HEXqrGTQMzYFNLL/cg4tYW67qCGK3rQ2y/fPnICKBLvM5bUqLzmp8z1fwrrsBhyTLmI1J7HYDu/7axP2AMNp3Tm5E1VEoJHmFd/MUvFwY0vVhUF02C6zo5U2BMaoagEvPbwRq1tfjft/nDRBl0xWwr+KXXJb48Z9M51L+L8mmiRfaoITyXQneYHKE/SGOMA5eqQOw3Pm06lNxuoJkWd77S7lVpSa8s20OPLmOJibDEE7WTDs2rJHkhyFcnW9WE9ZpEpTJeplFEcQ9jKbSdAoWhEyrdVe8HJEymm4W05rOwqT6Q3h1xUt137DUFLf08wt7qu1Mnrju4o0J4Or3PlcxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zm1X2RM5qtQrtsuKj9Sv4M4QU2l5QAwkkCcSE1YkBJs=;
 b=mThLRYXsjQFmMMobM0c7qLJ3GUrbrq8+icQ9TRWGv2NxZYqh3aEQbH/uglyazpAOkpEVedJQQvndtuQeTy3stOaG7P3mW4SmQevwBo35vlYPhT8ha85NhhR+Hjylcg7cXbzNBcH2iQtog8b6o0umVjQTpE4gi4T82bA1K89YGEc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2SPR01MB0003.namprd20.prod.outlook.com (20.179.82.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Mon, 9 Sep 2019 10:50:12 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 10:50:12 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/3] crypto: inside-secure - Add support for the CBCMAC
Thread-Topic: [PATCH 0/3] crypto: inside-secure - Add support for the CBCMAC
Thread-Index: AQHVYv9asl0eADp8PE2B9pjhBKQu46ci/PoAgAAwu6CAAAPgMA==
Date:   Mon, 9 Sep 2019 10:50:12 +0000
Message-ID: <MN2PR20MB29735284B8567182E7B916D0CAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567582608-29177-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190909073752.GA20487@gondor.apana.org.au>
 <MN2PR20MB297379E80B6CD087822AD9CDCAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297379E80B6CD087822AD9CDCAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f548b586-aa19-417b-5258-08d735137d83
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2SPR01MB0003;
x-ms-traffictypediagnostic: MN2SPR01MB0003:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2SPR01MB00035CBB123E234C4CC4CEB1CAB70@MN2SPR01MB0003.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39840400004)(199004)(189003)(13464003)(14454004)(86362001)(55016002)(76176011)(8936002)(81156014)(966005)(53546011)(81166006)(6506007)(6436002)(102836004)(52536014)(478600001)(8676002)(6116002)(9686003)(3846002)(66946007)(66476007)(66556008)(6246003)(64756008)(25786009)(66446008)(66066001)(5660300002)(76116006)(74316002)(110136005)(256004)(11346002)(316002)(305945005)(7696005)(54906003)(476003)(4326008)(71190400001)(71200400001)(99286004)(6306002)(26005)(53936002)(486006)(446003)(33656002)(7736002)(229853002)(186003)(15974865002)(2906002)(2940100002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2SPR01MB0003;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gIf4wX1uf0k/Zs7iYm0WGQnwi3yMspXbKSfviLo3J3vLk44zhq2J/ifh7bhO8vXr6s8qZYso9PA2DnRIXFGFLuutONSOv1UtFYW4ff85i425+ghfgBj/x16vgkFbdqCZZja/FgvDTRhgoRMtVEw7C4BMDwsYv3X3Wwm8zYsENYdBcOLGgrXYyctwa3v7VGJUxAMPq+/Fq7qROpzEgtj0HVPdk40RNa54WCOOSgTFgH7I/8znFmILk2eilDV1SFQcK90BN1RPRtAHnsQzuZ9F6U4YHfGbvCd7ADWKpqyyOgLHo4fW2YIRQLHm/fAu9/D02Jsyl7Z1AJYpi7ZW7D4UXhyNzieZ9LalH4HiU4DWpXcYK5GPdFoJkUSwj9KNxmVXVkoiYNFXx+e8qO/I8tTm2e682Iry3b4Odh1Sayxm16E=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f548b586-aa19-417b-5258-08d735137d83
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 10:50:12.1594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +N1md9nqpO93YPnO651YKYTI9Di6F90KToDSjvdO9Q9mceDfx3T0eB27k8JtVY4LdwdOR+h6WHgsA3FL1znHzN5fPYjW0T0JtunDFHdLInE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2SPR01MB0003
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf
> Of Pascal Van Leeuwen
> Sent: Monday, September 9, 2019 12:38 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>; Pascal van Leeuwen <pascalv=
anl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net
> Subject: RE: [PATCH 0/3] crypto: inside-secure - Add support for the CBCM=
AC
>=20
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kerne=
l.org> On
> Behalf
> > Of Herbert Xu
> > Sent: Monday, September 9, 2019 9:38 AM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@dav=
emloft.net;
> > Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Subject: Re: [PATCH 0/3] crypto: inside-secure - Add support for the CB=
CMAC
> >
> > On Wed, Sep 04, 2019 at 09:36:45AM +0200, Pascal van Leeuwen wrote:
> > > This patchset adds support for the (AES) CBCMAC family of authenticat=
ion
> > > algorithms: AES-CBCMAC, AES-XCBCMAC and AES-MAC
> > > It has been verified with a Xilinx PCIE FPGA board as well as the Mar=
vell
> > > Armada A8K based Macchiatobin development board.
> > >
> > > Pascal van Leeuwen (3):
> > >   crypto: inside-secure - Added support for the AES CBCMAC ahash
> > >   crypto: inside-secure - Added support for the AES XCBC ahash
> > >   crypto: inside-secure - Added support for the AES-CMAC ahash
> > >
> > >  drivers/crypto/inside-secure/safexcel.c      |   3 +
> > >  drivers/crypto/inside-secure/safexcel.h      |   3 +
> > >  drivers/crypto/inside-secure/safexcel_hash.c | 462 +++++++++++++++++=
+++++++---
> > >  3 files changed, 427 insertions(+), 41 deletions(-)
> >
> > This does not apply against cryptodev.
> >
> Grml, looks like I forgot to include the previous commit.
> My bad, will send a fixed v2 shortly ...
>=20
Actually, I'm wondering what would be the best approach here:
1) include the CRC32 support into a v2 of this patchset
2) provide the CRC32 support as a seperate, standalone patch
 to be applied prior to this patchset

Since CRC32 has very little to do with the CBCMAC family,
I would think option 2) makes the most sense.

So my suggestion would be to supply the CRC32 patch and
then resubmit this patchset unmodified. Would that be OK?

> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>=20
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
