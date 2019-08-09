Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67175C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22E102089E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="MV3NVQXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfHIVzp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 17:55:45 -0400
Received: from mail-eopbgr790084.outbound.protection.outlook.com ([40.107.79.84]:44400
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbfHIVzp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 17:55:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrgghtUNq/RHPi2CGm9QFdvgK3zlsX89BCAM2HEtwmWI1cnRWMIXhcse63gO9aSqbkbgg9YFQ595QM0bCDECQl+1QDYTeJ3zWElxJNhLhiLaY91W2AWkMMEZ4JrzgHiiynxxIuIHAXbKsEZ9ZKPZfhS6qLTDTDE8IEbS6ky03BZ2QsakFus3RMSnALxMzjhL2vZ4PCMYps+jC5NKJ9+CcAgHw67dnCGkfO8cMvI7E8vERQn439TuRV6oE/SajN9Hr1kB17vA76nP/3ilNdiS7gHDH1y80Mp+MkvaOWdmU1eUuwILhls8S6jsYf/5dsAd2QM5T+WkG3KQZxyqWBLpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsvOHeR3fNO+Pn7zwoh/IGl//IxKA8O+iimbsGSB/cE=;
 b=SMQz+2d++Jipfpi92d8EYKKCa156oDT+6xz3bT6hvLpVSKuwE14HZUx+nnnVzAfpIwhPSCV99o6hBR+GiUDG02TDe/WllTf2/MH3Eq5xAQXPvz+DGa2Gm3+gjQl7qPYwWiwdu+oTXq2FAm5Drxk9uGlf6+Ood5boyrnPF55ABzx1uP1z0I6b32QIFoJC52gc5LWs1bcaVHD0P4CzRPf+osUq0gdzwvCEIDT6H2cE1iWAvc7H9EdzFHXIS2uunVUj95R/MGz6J+nn9mAkrR1jgNk+XKa/+5b+rkSKyLlwdCGsYgoyLrz7Yj4tx0cRDQw3bc0CZ6igzosyuTXu6ESlGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsvOHeR3fNO+Pn7zwoh/IGl//IxKA8O+iimbsGSB/cE=;
 b=MV3NVQXaEbmkcY2O8zvRsDIk3olgUSeO3pcGKG3kSe5Rwg9BWo8LiRMbqNKHbkbvNsT1EwYyIbs0nGegv1znP90N8mUVXAqtI9j5QaXBcaa6Ps+44+rBSTigGvLvwTj2UDc/Dvoi5RhRhL7QGMFMWJeRchpiSGqtwEuHCqKY5wI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2975.namprd20.prod.outlook.com (52.132.172.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 21:55:39 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 21:55:39 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: XTS template wrapping question
Thread-Topic: XTS template wrapping question
Thread-Index: AdVOpvQVifejpBWTRVyvNwtV/QL5zQABu5aQAASi1wAABRfaAAAJ7OhA
Date:   Fri, 9 Aug 2019 21:55:39 +0000
Message-ID: <MN2PR20MB29737B2D4F7627225805550ACAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29737E7D905FE0B9D3CE3A68CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973782AD2114D66B2A0807ECAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809170636.GB658@sol.localdomain>
In-Reply-To: <20190809170636.GB658@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df2de1dd-0b0f-4a25-1340-08d71d145132
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2975;
x-ms-traffictypediagnostic: MN2PR20MB2975:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2975219073FDF66DC8461D32CAD60@MN2PR20MB2975.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(136003)(396003)(366004)(346002)(376002)(13464003)(189003)(199004)(5660300002)(3846002)(76116006)(66946007)(2906002)(486006)(8936002)(7696005)(55016002)(66476007)(9686003)(76176011)(6306002)(25786009)(11346002)(476003)(14454004)(86362001)(229853002)(446003)(478600001)(33656002)(966005)(6916009)(66446008)(64756008)(8676002)(81166006)(66556008)(6116002)(71200400001)(71190400001)(81156014)(256004)(6246003)(305945005)(15974865002)(3480700005)(316002)(6436002)(186003)(99286004)(53936002)(102836004)(53546011)(6506007)(4326008)(52536014)(26005)(66066001)(74316002)(7736002)(54906003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2975;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6sd6GCbsWH0DjFHHW/JHD4fi6cIOHQbS6v4EP8MPAhjyNPxk3OZERqCqwRcIuJUCpvJagl7idDOHAmEOYmcw4dKdKhRU0qmShfgXGasEXjC5d4PdIZevkVLXetsUnzswhg2P0LJzFBdWc1YtfULyGvwW3eZytZ4CBpvFxrrdCzBQ+khZmMT3HGa1eEE3MhL3T4GmLfxHoxMbo0u7fdkq/6ru0aqMpUIpWaXMsCF3aRJxZfzFI7hVLk/fNswhvT/P2r8mRAHCKGrJdS13AMgPpAIQcjF3AfeZ5+zfuEbeTArU95HL10EPKmH8Yj+n8muH0FmJsbNN338IS10BGcXITxhVsasxIxTmhccX36Vvzn8ypmeSDrB3m5rAyOtvx1WCfAUBk4R1Nx5ZLozsOFhXBgKUmSSoeKt+KINTUwywbv4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2de1dd-0b0f-4a25-1340-08d71d145132
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 21:55:39.3093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OE18Oftr0HNUts2/f1XzukfOij7SjGCkPiUMvUyu5N/AAaFW+ueVZsG8yBrI58sEhV70HTaDHxXtBm4CdxnJ5LB74CAwocekaZAQSkYSK+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2975
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Friday, August 9, 2019 7:07 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net
> Subject: Re: XTS template wrapping question
>=20
> On Fri, Aug 09, 2019 at 03:06:23PM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > Sent: Friday, August 9, 2019 4:18 PM
> > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; linux-crypto@vge=
r.kernel.org;
> > > herbert@gondor.apana.org.au; davem@davemloft.net; Eric Biggers <ebigg=
ers@kernel.org>
> > > Subject: RE: XTS template wrapping question
> > >
> > > > -----Original Message-----
> > > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.k=
ernel.org> On Behalf
> > > Of
> > > > Pascal Van Leeuwen
> > > > Sent: Friday, August 9, 2019 1:39 PM
> > > > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; dave=
m@davemloft.net;
> Eric
> > > > Biggers <ebiggers@kernel.org>
> > > > Subject: XTS template wrapping question
> > > >
> > > > Herbert, Eric,
> > > >
> > > > While working on the XTS template, I noticed that it is being used
> > > > (e.g. from testmgr, but also when explictly exported from other dri=
vers)
> > > > as e.g. "xts(aes)", with the generic driver actually being
> > > > "xts(ecb(aes-generic))".
> > > >
> > > > While what I would expect would be "xts(ecb(aes))", the reason bein=
g
> > > > that plain "aes" is defined as a single block cipher while the XTS
> > > > template actually efficiently wraps an skcipher (like ecb(aes)).
> > > > The generic driver reference actually proves this point.
> > > >
> > > > The problem with XTS being used without the ecb template in between=
,
> > > > is that hardware accelerators will typically advertise an ecb(aes)
> > > > skcipher and the current approach makes it impossible to leverage
> > > > that for XTS (while the XTS template *could* actually do that
> > > > efficiently, from what I understand from the code ...).
> > > > Advertising a single block "aes" cipher from a hardware accelerator
> > > > unfortunately defeats the purpose of acceleration.
> > > >
> > > > I also wonder what happens if aes-generic is the only AES
> > > > implementation available? How would the crypto API know it needs to
> > > > do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
> > > > (And I don't see how xts(aes) would work directly, considering
> > > > that only seems to handle single cipher blocks? Or ... will
> > > > the crypto API actually wrap some multi-block skcipher thing
> > > > around the single block cipher instance automatically??)
> > > >
> > > Actually, the above was based on observations from testmgr, which
> > > doesn't seem to test xts(safexcel-ecb-aes) even though I gave that
> > > a very high .cra_priority as well as that what is advertised under
> > > /proc/crypto, which does not include such a thing either.
> > >
> > > However, playing with tcrypt mode=3D600 shows some interesting
> > > results:
> > >
> > > WITHOUT the inside-secure driver loaded, both LRW encrypt and
> > > decrypt run on top of ecb-aes-aesni as you would expect.
> > > Both xts encrypt and decrypt give a "failed to load transform"
> > > with an error code of -80. Strange ... -80 =3D ELIBBAD??
> > > (Do note that the selftest of xts(aes) using xts-aesni worked
> > > just fine according to /proc/crypto!)
> > >
> > > WITH the inside-secure driver loaded, NOT advertising xts(aes)
> > > itself and everything at cra_priority of 300: same (expected).
> > >
> > > WITH the inside-secure driver loaded, NOT advertising xts(aes)
> > > itself and everything safexcel at cra_priority of 2000:
> > > LRW decrypt now runs on top of safexcel-ecb-aes, but LRW
> > > encrypt now runs on top of aes-generic? This makes no sense as
> > > the encrypt datapath structure is the same as for decrypt so
> > > it should run just fine on top of safexcel-ecb-aes. And besides
> > > that, why drop from aesni all the way down to aes-generic??
> > > xts encrypt and decrypt still give the -80 error, while you
> > > would expect that to now run using the xts wrapper around
> > > safexcel-ecb-aes (but no way to tell if that's happening).
> > >
> > > WITH the inside-secure driver loaded, advertising xts(aes)
> > > itself and everything at cra_priority of 2000:
> > > still the same LRW assymmetry as mentioned above, but
> > > xts encrypt and decrypt now work fine using safexcel-aes-xts
> > >
> > > Conclusions from the above:
> > >
> > > - There's something fishy with the selection of the underlying
> > >   AES cipher for LRW encrypt (but not for LRW decrypt).
> > >
> > Actually, this makes no sense at all as crypto_skcipher_alloc
> > does not even see the direction you're going to use in your
> > requests. Still, it is what I consistently see happening in
> > the tcrypt logging. Weird!
>=20
> There's a known bug when the extra self-tests are enabled, where the firs=
t
> allocation of an algorithm actually returns the generic implementation, n=
ot the
> highest priority implementation.  See:
> https://lkml.kernel.org/linux-crypto/20190409181608.GA122471@gmail.com/
> Does that explain what you saw?
>=20
Ah! That must indeed be the same problem. Encrypt is first here, so
that apparently gets generic and then decrypt gets the hw version.
So I guess that bug does not just apply to the self tests then ...(!)

> >
> > > - xts-aes-aesni (and the xts.c wrapper?) appear(s) broken in
> > >   some way not detected by testmgr but affecting tcrypt use,
> > >   while the inside-secure driver's local xts works just fine
> > >
>=20
> Is this reproducible without any local patches?  If so, can you provide c=
lear
> reproduction steps?
>=20
I'm not aware of any local patches. I tried it after backing out the=20
xts.c stuff Ard and I have been working on regarding CTS and that still=20
failed.

Just try:
modprobe tcrypt mode=3D600 sec=3D1 num_mb=3D100

On a system that has aesni has the highest priority implementation.

> - Eric



Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

