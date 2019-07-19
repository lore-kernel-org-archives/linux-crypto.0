Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CF8C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EBB22184E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="p6Qn360K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfGSTde (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 15:33:34 -0400
Received: from mail-eopbgr810085.outbound.protection.outlook.com ([40.107.81.85]:34880
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbfGSTde (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 15:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1rl6+JEwCJ4TVzMPLMPB6G5+9LjbVIR4y1fCdNpCv3xUKLuC3FG74PLc8Z3WVoWSJYGnI3SYtIKwenv65yN66oqrnbq9B7x+TKckGTwPIZa44bp2AB7nLrKIQQ9rDTOQ3pBqXz0LOF1zg/2BJa50v+EBFwSpDsAfOpji0L/EZ9Es1USughFP5hbVOBBUTPX5kbOnDvQ+psQklvHNZJ2QkYEKeFMs5lcGWI+vALXDGtuK9XsQi19xCRt3qM8po5Bq5xCn6JwzyFe8mVOSqobDbRXPm3mQ/1WkwMSvnoGZpUoENPAe2/AYmz6o+9pS5igRoONaVXiJyDDJo1hcHVsAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZhFoZ6Ep1wIe7GGaXS1JmhX8b9EZ4WsiEUFOydlKOs=;
 b=EKX6KZT6XfYyZVEs+uLjqWcL3gHei9zdqHVtIfO+ThGq2B8LEApYE+M2N4GJAAgybzXCzho9wo3AIe82Ro903qsPjo22UnLgMvwfUcgzeaa2VBiGrfueiKX0/bu8j8NIws0+CjUSCSkcMzmmOqw51AUUYBSCHp6JXUmzoGa3X+6PvPbxHjCvomOuaUzStN5SkOyKJ7UNX1Di0Wx0AqElAXzXH4XLrk5xkfU6T+mmWcP0Y9kjdTdYVntoM3+WqYI+l1DhqIzqcgqQwhUgb53t8T8pbV6AYDBW+1KwCcoPYZzA2kz/kYorHn611x8PsjH6GY3Kv9H0AHHhllmoNYeG/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZhFoZ6Ep1wIe7GGaXS1JmhX8b9EZ4WsiEUFOydlKOs=;
 b=p6Qn360K2a52g5GghQHE6Zx6L32GgI4M8+fvGvxp8GzuI6VZDKoXKhZmTBjRbhBuicbDgXUpefhBgaMK2sQEm51jjqYx5RVQXl0okYeycBM4Mgfq573t22ABZzFVMiNl5iisHOG0p4ar6U252dLbsGNS1WOGQXfd8eT35Qjd9ME=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3181.namprd20.prod.outlook.com (52.132.175.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 19:33:31 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 19:33:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: generic ahash question
Thread-Topic: generic ahash question
Thread-Index: AdU+Pz/3ICV8h5GxTo+QH6d8mlFU5QADv2sAAAZoRqA=
Date:   Fri, 19 Jul 2019 19:33:30 +0000
Message-ID: <MN2PR20MB2973067B1373891A5899ECBBCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB297347B80C7E3DCD19127B05CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719162303.GB1422@gmail.com>
In-Reply-To: <20190719162303.GB1422@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fcf2baa-d80e-4dff-e1cb-08d70c7ffb45
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3181;
x-ms-traffictypediagnostic: MN2PR20MB3181:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3181989B9B9BED96BFCCE222CACB0@MN2PR20MB3181.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39850400004)(136003)(13464003)(199004)(189003)(66066001)(76116006)(6246003)(71200400001)(71190400001)(66476007)(66556008)(305945005)(7736002)(53936002)(8936002)(4326008)(54906003)(66946007)(55016002)(15974865002)(8676002)(9686003)(68736007)(99286004)(3480700005)(6436002)(478600001)(316002)(64756008)(186003)(26005)(6916009)(446003)(11346002)(476003)(7116003)(229853002)(14444005)(3846002)(25786009)(86362001)(256004)(14454004)(6116002)(6506007)(53546011)(33656002)(486006)(52536014)(66446008)(5660300002)(102836004)(74316002)(81166006)(7696005)(2906002)(76176011)(81156014)(41533002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3181;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0m+qyNpfC2o/2HKrIbLoQ24EA62xG7iS/+tD2EyEuGuDVVoIWWMIep9R6hP5GdHZT0oNKh1RHsztwGB35cC0B2aTxz9Mdnm5yn1jmOfJHFe2gpkkJ2Y+/uqWTqPZu9kSyV7YlCnwofr2TMBND7Q6e7eTqcEYo1rcoyEr7Ut/u/6lk6UvhVJ+NbaDYc/vD3E7XcZ4NnfdCkKaMe7hVvT0e/Ic3pK9WTIB+KA9nkFyPHeTUWfZpWQLJgS4VXGqNhlUw9rewWS+qCPRhD1WkqP7X5rVmnUA8zhbnklD2ECcLGCth3flThZk2IYlss7OnEx8Ge55qApr3UGKxu8mzBDWZTRIgMFpMUFw+C9NLgalyfAjcljAL+bFg6f8u9ddD/wH97ag0w7pjCijf7x1OhlSyTxn35phR+WxJED6i8iEAuk=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fcf2baa-d80e-4dff-e1cb-08d70c7ffb45
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 19:33:30.7408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3181
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Eric Biggers
> Sent: Friday, July 19, 2019 6:23 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; David S. Miller <davem@davemloft.net>
> Subject: Re: generic ahash question
>=20
> On Fri, Jul 19, 2019 at 02:41:03PM +0000, Pascal Van Leeuwen wrote:
> > Hi,
> >
> > I recall reading somewhere in the Linux Crypto documentation that suppo=
rt for finup() and digest()
> > calls were explicitly added to support hardware that couldn't handle se=
perate init/update/final
> > calls so they could at least be used with e.g. the IPsec stack.  I also=
 noticed that testmgr *does*
> >  attempt to verify these seperate calls ...
> >
> > So I'm guessing there must be some flags that I can set to indicate I'm=
 not supporting seperate
> > init/update/final calls so that testmgr skips those specific tests? Whi=
ch flag(s) do I need to set?
> >
>=20
> Where does the documentation say that?

For finup:
"As some hardware cannot do update and final separately, this callback was =
added to allow such=20
hardware to be used at least by IPsec"

For digest:
"Just like finup, this was added for hardware which cannot do even the finu=
p, but can only do the=20
whole transformation in one run."

Those statement sort of imply (to me) that it's OK to only support digest o=
r only finup and digest.

>=20
> AFAICS, init/update/final have been mandatory for at least 9 years, as th=
at's
> when testmgr started testing it.  See:

I just spotted some [mandatory] tags as well ... must've missed those on th=
e previous read,=20
I'm not good with details, I'm more of a big picture guy.

Not that I was expecting a different answer anyway :-) Just being hopeful.

>=20
> 	commit a8f1a05292db8b410be47fa905669672011f0343
> 	Author: David S. Miller <davem@davemloft.net>
> 	Date:   Wed May 19 14:12:03 2010 +1000
>=20
> 	    crypto: testmgr - Add testing for async hashing and update/final
>=20
> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

