Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74505C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 22:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3963C206E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 22:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="G3wsC+T2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfG2Wtn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 18:49:43 -0400
Received: from mail-eopbgr730048.outbound.protection.outlook.com ([40.107.73.48]:21120
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727576AbfG2Wtm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 18:49:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLG4yEYcIg8CtKEBTOXoJbel4WxvQ0Cw9M775J4WsBCx26DHaJPweADKMWjBnVpzdbnP3UdM4vxVnGgAZ4katDX5NW9G+Sa8Flj6hm1tPV4o1QojAS1PDZxmSx8l4Qjh2k6xRcZnU9GX2WwPmi2FPaPRTGZCyWgXMGb1li5iq70LmMlWk8bqoFQBoYZ1d+vJGt3GNvHo1hDVvGMBNVd2IT/k9WJyV6hO8x1gsTcixsItexPnsb32pI0tNww+7HL/DXXI49vTt4Ks7b+0DqWaGmym0vxDuA3cA/EkUq+pPzoSD+BDz8XZqMg1BK4aBorDixPuEUMvckCXJJERug3p1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TlwLKf//UIdKyS0dHaF8pkawFjokABoZbevbuAGres=;
 b=VqVIHVDwjYVe1+kDie1iVFnHDyFnqEQS+peZ/5XFmnS0CX/uZJbKWDyEPE98XBUo1DuGpekinWcDHdLDojIZLS3ztIOnaWZ+oKvb2rWAB5Z4YHwF0/gdziSvMZIHwtDjnzgRUnti6qgt0Bgt5MDpiEuk17YtfTGRj37/RJ4i0ZKe5+YajylDkhDRiGHsK7GoH5q2wpfr0FihcqvVi5wJ6Y0f85Eev6ZaZkxXvJTsf9ErgCGlVvxRcQGlrIrOt7zufoNscIqUkX8mXCDy5x0+RFDH0K83PUVpivydFNbOifDUeJ2oqJRV+aKRgSbbq6GAeUHz/fwTdOR9/WHho6LK3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TlwLKf//UIdKyS0dHaF8pkawFjokABoZbevbuAGres=;
 b=G3wsC+T2v/Cpu+w7SrJeQz0ArZ/RvCWfTxyoy5nDKVNv3ZDkUT0SWNqMxgLlbL8jVbdTIV+h5sGNXIbpgRdEUqGUZX60gB/mAB/BnNhBYpKYn8pgXbtfn2jaLAi9WVMiBQEcm7yjxELdd628WZtukE3KRcn+0FvWg11EGBqq2/k=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2349.namprd20.prod.outlook.com (20.179.147.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 22:49:38 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 22:49:38 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAKUVgIAAIDgwgAAmnwCAAAIuUA==
Date:   Mon, 29 Jul 2019 22:49:38 +0000
Message-ID: <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
In-Reply-To: <20190729223112.GA7529@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17de2acb-98ae-49f1-0534-08d714770944
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2349;
x-ms-traffictypediagnostic: MN2PR20MB2349:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2349E68BE00AD96C85B1C20FCADD0@MN2PR20MB2349.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(366004)(376002)(136003)(396003)(13464003)(199004)(189003)(64756008)(4326008)(229853002)(71200400001)(7696005)(14444005)(71190400001)(102836004)(74316002)(76176011)(99286004)(966005)(86362001)(256004)(446003)(11346002)(186003)(5660300002)(53546011)(26005)(2906002)(55016002)(6436002)(478600001)(8936002)(6246003)(476003)(66946007)(66066001)(68736007)(66556008)(6916009)(6116002)(54906003)(3846002)(81156014)(52536014)(6506007)(305945005)(14454004)(25786009)(81166006)(7736002)(33656002)(6306002)(15974865002)(9686003)(316002)(486006)(76116006)(66446008)(66476007)(53936002)(8676002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2349;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /iONY8dFVMshRg4RyI26S9HP/w6ebbuMUm8ijlUK/aZnX9s1/ZfcUm3wl1w4TaaMohGFslJQsKkk/SJHBR+9y0ZDWUgehXE8iq3CnyPYF1eRJfrVmjuL/CInvHgmR7bBKag/KRGw1at2J/SR+dAjRDf2Gtdc9k1jFuPD5Y/ftkcwHe0txRcMk94cdDW32JmN6920pLBM9qMxIOm5/iWo5yGy49SDje8EGwa571dqQRj3t+vxhaql3QAdBK2Oohc/282WXIMRH6K9Ml1+71KzyuMVKNvSwP0d4o+cCr0R5293NsH3JRt/0RzpUO2M09WAhOUnc4wexJxflQVeDTUdmz584gjpipEh5suMv758NfP+K4jg2V/WjXqU5nsAocVH1MYLWIrQpk+W/Jsh+rmn4/rIe/x+MpCrm860CPHON3E=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17de2acb-98ae-49f1-0534-08d714770944
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 22:49:38.3671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2349
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, July 30, 2019 12:31 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Eric Biggers <ebiggers@kernel.org>; Pascal van Leeuwen <pascalvanl@gm=
ail.com>; linux-
> crypto@vger.kernel.org; davem@davemloft.net
> Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params fo=
r AEAD fuzz testing
>=20
> On Mon, Jul 29, 2019 at 10:16:48PM +0000, Pascal Van Leeuwen wrote:
> >
> > > EINVAL is for invalid lengths while EBADMSG is for inauthentic inputs=
.
> > > Inauthentic test vectors aren't yet automatically generated (even aft=
er this
> > > patch), so I don't think EBADMSG should be seen here.  Are you sure t=
here isn't
> > > a bug in your patch that's causing this?
> > >
> > As far as I understand it, the output of the encryption is fed back in =
to
> > decrypt. However, if the encryption didn't work due to blocksize mismat=
ch,
> > there would not be any valid encrypted and authenticated data written o=
ut.
> > So, if the (generic) driver checks that for decryption, it would result=
 in
> > -EINVAL. If it wouldn't check that, it would try to decrypt and authent=
ica
> > te the data, which would almost certainly result in a tag mismatch and
> > thus an -EBADMSG error being reported.
> >
> > So actually, the witnessed issue can be perfectly explained from a miss=
ing
> > block size check in aesni.
>=20
> The same input can indeed fail for multiple reasons.  I think in
> such cases it is unreasonable to expect all implementations to
> return the same error value.
>=20
Hmmm ... first off, testmgr expects error codes to match exactly. So if
you're saying that's not always the case, it would need to be changed.
(but then, what difference would still be acceptable?)
But so far it seems to have worked pretty well, except for this now.

You're the expert, but shouldn't there be some priority to the checks
being performed? To me, it seems reasonable to do things like length
checks prior to even *starting* decryption and authentication.
Therefore, it makes more sense to get -EINVAL than -EBADMSG in this=20
case. IMHO you should only get -EBADMSG if the message was properly
formatted, but the tags eventually mismatched. From a security point
of view it can be very important to have a very clear distinction
between those 2 cases.

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
