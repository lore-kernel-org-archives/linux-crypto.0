Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B96C76195
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B29A521849
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="I7SqGH9F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfGST0H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 15:26:07 -0400
Received: from mail-eopbgr740048.outbound.protection.outlook.com ([40.107.74.48]:13216
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727987AbfGST0H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 15:26:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LExpmjIa/y/UUVTvOrLiXrqwNy7rLt8Hzb5dxdfqkl+qHz8MsECF4E3JaVuBwrDSLVmUeYKqKFBQM36iIx3QHZ4KjD297m2PLnUQDnEom6edWus4oaT19FrNJHn0JwitxgEshGl3cCExlWbdaubrggViRM+gxBjMqK7F2i3tUnmd37M+DmxCLisAvlNJVSMN0ICEoiSMBjNdtqzs7KO/Gv5RbylfLc9nO5Ospp/U640z178Wg1+dOA98ZHT76xoZEJQ1T0msKWTMz5cleR6NbY2WmozHo3thmldUlP79kTH5t1GLaz+sZEwFBuaQhrNUpXPvyC9n5XbcUiK+WAocXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwYsEos78WrQYyVH/16nGMhup46uhnYq157HNDENcqs=;
 b=jN1JE9DvUJrU/DGIRsLgUkN0Ai3Th9WAmAmgASS5isaPXHGpaNbZ/QICd5iLAbO/AuisQcoQHQVVOqmBag2FD+Qyc8HCxUq8J7aJpsRLiWPOUH3SIcieDhr7XWpwKas/aWsZrK1DGwtMjmR0gH5WUIPr5HJbmXgHQVK4P7HzNgaxk/0YksFn6i8spPn1ZUdimCTeNPBJWCmc4mVoRG9NSj0HHAJKJPBF5vF8UIsj8NOcOWyvH6xQsRElQTaZfXLFaT+WoBvoIiXbi/i822KyclhtYWEHtiZNHgj8wOGEvoGBP3Cgw/qNv3sbKzAl+nrGrXAnoc9nGeKIn+Yjl49QLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwYsEos78WrQYyVH/16nGMhup46uhnYq157HNDENcqs=;
 b=I7SqGH9FkR3xG36gCuHkMZEO8IMwra/BehRMQw9MSanosg1+RbnM36oMIEWpr/RhxBqq7vDrdr2WdgLT5zT9ZQs3V/Bs0sfInVztyPyjBH0Iob+POoBqu1zH4LeyV9uQl/w8AoS8LwO69vhtFcCAlXkGwVTxaxfZxL72cnja/bk=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3261.namprd20.prod.outlook.com (52.132.175.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 19:26:03 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 19:26:03 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: ghash
Thread-Topic: ghash
Thread-Index: AdU+OcccbSpphUQDQMqR1uphPmes/wAE33+AAAYsZgA=
Date:   Fri, 19 Jul 2019 19:26:02 +0000
Message-ID: <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719161606.GA1422@gmail.com>
In-Reply-To: <20190719161606.GA1422@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f44f287a-828c-487d-de84-08d70c7ef026
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3261;
x-ms-traffictypediagnostic: MN2PR20MB3261:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB3261189DF6AE1EEC504A8532CACB0@MN2PR20MB3261.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39850400004)(376002)(13464003)(199004)(189003)(966005)(54906003)(6916009)(486006)(6436002)(4326008)(74316002)(6506007)(99286004)(68736007)(52536014)(33656002)(81156014)(25786009)(478600001)(53546011)(5660300002)(3480700005)(102836004)(53936002)(81166006)(76176011)(186003)(7696005)(26005)(71200400001)(71190400001)(55016002)(2906002)(8676002)(15974865002)(476003)(7116003)(11346002)(6306002)(6116002)(229853002)(3846002)(446003)(66446008)(14444005)(6246003)(66066001)(66476007)(64756008)(7736002)(66556008)(66946007)(14454004)(76116006)(305945005)(9686003)(8936002)(256004)(86362001)(316002)(221733001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3261;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fNwL41YuJSi6xaeSrOuTKZq75Ce/Slau2RCfVRhXUnzUHO3vTim+yTe+DUeIqMZJyFm/bH2O0hzzmN876ts9vVwI+Grcndu+Q1MPQW+N1N0gQmEEMgU/QcZYljJKiLBYhJEkOulKA24/lkp+dGMoEiMUoE8R7Eo0iGabh1X6QZUDCea9iUkGwKEaoc+9XAva7GoEBpH2uH1QIdRU1KLkga10aZ6Fqx3qJTPUDGuTY/dGaboNinUb/PFEUf2gu2nVX3XxrSho6gqInqsazcRjhbqf+tDhWy3KNpDuhRVMub7BCcQPnDufDzQcItw2LHma6fxvwDkw/xeEW8AYBdo4v/GymbkYsNAxEGbqghNPNL4jAm4DcURAsppa64ctZnWYFgVNWm7805PaMoGi7elGehV0gDGxFvYAuFfPkFYu8fU=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44f287a-828c-487d-de84-08d70c7ef026
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 19:26:02.7827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3261
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Eric Biggers
> Sent: Friday, July 19, 2019 6:16 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; davem@davemloft.net
> Subject: Re: ghash
>=20
> On Fri, Jul 19, 2019 at 02:05:01PM +0000, Pascal Van Leeuwen wrote:
> > Hi,
> >
> > While implementing GHASH support for the inside-secure driver and wonde=
ring why I couldn't get
> > the test vectors to pass I have come to the conclusion that ghash-gener=
ic.c actually does *not*
> > implement GHASH at all. It merely implements the underlying chained GF =
multiplication, which,
> > I understand, is convenient as a building block for e.g. aes-gcm but is=
 is NOT the full GHASH.
> > Most importantly, it does NOT actually close the hash, so you can trivi=
ally add more data to the
> > authenticated block (i.e. the resulting output cannot be used directly =
without external closing)
> >
> > GHASH is defined as GHASH(H,A,C) whereby you do this chained GF multipl=
y on a block of AAD
> > data padded to 16 byte alignment with zeroes, followed by a block of ci=
phertext padded to 16
> > byte alignment with zeroes, followed by a block that contains both AAD =
and cipher length.
> >
> > See also https://en.wikipedia.org/wiki/Galois/Counter_Mode
> >
> > Regards,
> > Pascal van Leeuwen
> > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > www.insidesecure.com
> >
>=20
> Yes that's correct.  The hash APIs don't support multi-argument hashes, s=
o
> there's no natural way for it to be "full GHASH".  So it relies on the ca=
ller to
> format the AAD and ciphertext into a single stream.  IMO it really should=
 be
> called something like "ghash_core".
>=20
> Do you have some question or suggestion, or was this just an observation?
>=20
Well, considering it's pretending to be GHASH I was more less considering t=
his a bug report ...

There's the inherent danger that someone not aware of the actual implementa=
tion tries to
use it as some efficient (e.g. due to instruction set support) secure authe=
ntication function.
Which, without proper external data formatting, it's surely not in its curr=
ent form. This is=20
not something you will actually notice when just using it locally for somet=
hing (until
someone actually breaks it).

And then there was the issue of wanting the offload it to hardware, but tha=
t's kind of hard
if the software implementation does not follow the spec where the hardware =
does ...

I think more care should be taken with the algorithm naming - if it has a c=
ertain name,=20
you expect it to follow the matching specification (fully). I have already =
identified 2 cases=20
now (xts and ghash) where that is not actually the case.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
