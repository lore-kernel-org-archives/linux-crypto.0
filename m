Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84417C32756
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 23:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FFE4208C4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 23:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="fzeqJgzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHIXCC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 19:02:02 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:18325
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfHIXCC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 19:02:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBP9sEbNapNpmvcw9iLzniLfsF4hLx3nU0mEgSl40oBQl3v9f2sTzPvXXNKMEdaSPGQlPs9Tu8G10tBCsyBCNuUaen9gnXxi1zrJ2/Gkw7VIAXutOx720W+aFiWRHbljRV1eGzfeCMvjbbvVcL57Tn6z8of2D6GHf4XqvSwsZCuSnym0RlUka9IDWkPR3S/axYTns0wv8y2tzg1+O/2Is7nkS5U5j9s/C9HfMbS80LP9FM/Ttd+nXtGgLU1NV9bC5xzQNjc938EdWMMYYy7rCPdYJBo4Etx3hYZ/Sjv0ZHjtWP1akJ/9NfcMpwidhz0Ccj7a4utabH1dmPK5DhyRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6+K+FG463kYCgPig9anct8PtsKONWwzKglZ4imbHJ8=;
 b=fpItBXI66Tv/lVbM0XfBsamhm5efiaX4s+5LVDE7JYgdIbywNAy4BBy1cEqIKWj9yfoTLLv0fxVxlyNqAbEHdoa794BM7P7KRBHkNZM4LAVDynT0C3Jb0doaGTIXZTnbC1Epv+CWBLJcvPLfjGjkiyr+nlC2VAGkVWl2Bsk6cfImuijk927EQE2QmNGyYEoVz5m8ajpqewDFjAooPmVHYDgqNMw1jz4d2kMHkUfz9pFw/tYy95b8ga4ABsfs4SnElJwwoC/GUQ+rBVoJhtmORYTSGq6H7gy5U0Tck7X9gsPvyrn55IZ1Ke6gdwCE6MVBK9m5m0N5RbW7VmDSxmSslQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6+K+FG463kYCgPig9anct8PtsKONWwzKglZ4imbHJ8=;
 b=fzeqJgzogA0hlz8HfQTFWWbdC69dvDwk6LzPkVY5HjwqAG+uYCHqv5oUSdvf8zh7bKw4LzUD9kfPxOe82caEzCYHGoT8WBe2L4ujvw2pmLULPuAKCKq8kUsmdT9SEhoHjuX4z5LcdPcwfbnet64G1UCWT/wZrrj5JGFrgo7VZok=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2543.namprd20.prod.outlook.com (20.179.147.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Fri, 9 Aug 2019 23:01:59 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 23:01:59 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Topic: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Thread-Index: AQHVTOQKWnTPkdATo0i/D1XZtRSIkqbvRQ3wgABmBgCAAAHhUIAAJeoAgAAASmCAARpFgIAAAIWQgABIkICAAAcZkIAAQkcAgAEBE3CAAJHdAIAAM6SQgAAJhoCAAAKAEIAAEK2AgAAG0QA=
Date:   Fri, 9 Aug 2019 23:01:58 +0000
Message-ID: <MN2PR20MB297355FEEE85A25AC59D6264CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
 <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808171508.GA201004@gmail.com>
 <MN2PR20MB2973387C1A083138866EE45FCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809171720.GC658@sol.localdomain>
 <MN2PR20MB2973BE617D7BC075BB7BB1ACCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809205614.GB100971@gmail.com>
 <MN2PR20MB29736FF8E67D83FEA5A52E14CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809220452.GC100971@gmail.com>
In-Reply-To: <20190809220452.GC100971@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e340577-ae82-46f1-3daf-08d71d1d953a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2543;
x-ms-traffictypediagnostic: MN2PR20MB2543:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2543A226AA5B5808206BDA0ACAD60@MN2PR20MB2543.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:530;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39850400004)(346002)(396003)(366004)(13464003)(189003)(199004)(6506007)(446003)(229853002)(476003)(99286004)(11346002)(53546011)(486006)(9686003)(102836004)(25786009)(55016002)(186003)(33656002)(53936002)(15974865002)(4326008)(26005)(6436002)(14444005)(256004)(66066001)(7696005)(76176011)(6916009)(7736002)(86362001)(305945005)(8936002)(52536014)(6246003)(316002)(2906002)(76116006)(81166006)(74316002)(5660300002)(14454004)(71200400001)(71190400001)(81156014)(478600001)(66446008)(3846002)(6116002)(66946007)(8676002)(66556008)(64756008)(66476007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2543;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qBBdAWiRdsJTFeJmNDLwPPWzOc/+Gaj2YKP58rR3cpgZmXm1auUDv73M+A45tHicyMCAyz1VCQ3X6RLV05rzJ8a9Xs+yWHJjppOhP9Nu/gfhcONJE+Ugkj8nIz/tF3uZ+MPYbILF8yekxRrzv2GChfUQHJ2VFa07rHvuALLMyVGHYQx9saO+pm3iNKZTjEJgIoi7cpW0gOkN36oOTtREaccYamOMHBDcIrYF+cySwSgqVzUwoeBbMgXziIpdLXRzMOYcviNlWGG7dsGirwW8NewNGsV3rGt6CnV49Mmh094kaOANOjstg11xy020E56et8ui/goM2cer5VK2f3Fvx7LnCrFgTryaLK27dN+ogao49rSRZsNh7FeS789Xqw83GUnQ7qk3KdHM6pJUb8Ee0cn+yfTx5HLbMaSlPvaUKuE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e340577-ae82-46f1-3daf-08d71d1d953a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 23:01:58.8175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ueQ253HGhJ6FSL3K52bGSLGrLoYjUbMbAiaSefl7K1n0xYh8vEY2evJgYlXoDVSGGntFF/zZgQLyRfwSB7N2VbQ8hqFl5gwaj/QChwv2L6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2543
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Saturday, August 10, 2019 12:05 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV gen=
eration
>=20
> On Fri, Aug 09, 2019 at 09:33:14PM +0000, Pascal Van Leeuwen wrote:
> > Real life designs require all kinds of trade-offs and compromises.
> > If you want to make something twice as expensive, you'd better have a
> > really solid reason for doing so. So yes, I do believe it is useful to
> > be sceptical and question these things. But I always listen to good
> > arguments, so just convince me I got it wrong *for my particular use
> > case* (I'm not generally interested in the generic case).
>=20
> Or rather, if you want to take shortcuts and incorrectly implement a cryp=
to
> construction, you'd better have a really solid reason for doing so.
>=20
Sure. It's called cost. Or power consumption. Or performance.
Or any other reason that's often considered important, possibly
even (much) more important than security. Welcome to the real world.
The best possible security is rarely affordable.

And a weaker implementation is not necessarily incorrect by the way,
as long as it still meets your security goals under a relevant and
realistic attack model.

As an architect, I don't set the requirements or the priorities.
I just try to make the best possible compromise. And fortunately,
I do have a real cryptographer running around here somewhere,
looking over my shoulder to ensure I don't do anything really=20
stupid ;-) But I make him work for his money.
(So no, I did not myself create any XTS solution using a single
key, in case you were wondering. I just know it has been done.)

But, yes, that's why a lot of bad crypto and other security=20
vulnerabilities exist. And, newsflash, it's not going to change
any day soon.

> It's on you to show that your crypto is okay, not me.
>=20
Reality check: unless you work for some government (been there,
done that), usually, nobody cares (until the shit hits the fan)

> - Eric



Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

