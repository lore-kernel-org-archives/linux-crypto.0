Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231D7C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78E022ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:34:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="U1S8U4wc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfGZMeK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:34:10 -0400
Received: from mail-eopbgr710068.outbound.protection.outlook.com ([40.107.71.68]:34272
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbfGZMeK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3eVYsrgh9GPq+T+6vQcoWdeAMOy45aYE8S3MPf1NQDq2uw6Ju92DtgGvrsDcTvXNj7Q6V2Q6bUwUKyO0Qj8LkzSoK/r0XrHhD6VCvEHHJoDs/pdkgGJaE6Ztb6tQi5ZT34YnHTLysnUABIAl6fFt1RaAlzURwYKV6bSq7ehSqP1+OmGuR82f45eZ+M4umcxczHNA/GJ/kZH+HiHxhpWpQJP0GLLPjrw97XnrOhYxWmySvezW9tNLzG7GhqanpLWKlXD9cWleGKVh6CZ+pCVTYaptAhzJ5iMCiyeXSEfEqRaq2WVFA6os3VCTLat5vyKaowA3ZhaUnyPaZRU3K8lGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rke+ekjF4yQNg2Srn/dT4lR4yCp4qeyyA/S42ZrZaf0=;
 b=Ab1u4OR0ccTtb9ukOIjG608qbrobYstbAIRs+tWaYJa9wUt7kTQkuQp1HbPkAzeyPXC48+WhNoEtWZ6in74Pt9aJ6g7vhnKd6rpT2xQRODZpwRXDYh/giV+bL8cflWlW5U+N6acR2ennGvi7KjrlM89jiB7c+mqI1mnbcNRWVWpINyHfaKuDKDydwZVGas/PvKnT3B9QWDG9pjrdn97vNNs/BMzWBo6eIkNTYVByeE/fDKN0v9HP6u1tb4b+jpWt/YKXZw0aO6nke7TCpMRawEDqFs/150nSNTu+lve2SlEgchuDM5B8ijTbLVJ3Ejj+UKhQvGl8+7DyQXKOesQJ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rke+ekjF4yQNg2Srn/dT4lR4yCp4qeyyA/S42ZrZaf0=;
 b=U1S8U4wcDFvyniq/Je4l+Qf19dR8DBbzuU414Zq6OqFkUQzCaRjsBZCSZX8TSaYjbn/YsLu3w5Qb43AdM12p4nzn/8qtPdl0c+2cZNQSzRr9tTMx4Wba/HjV711oVHRO4o/URd6iWaxsKkAbYUU5qWt+In+IAsS0v5TxYIMSI7U=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2942.namprd20.prod.outlook.com (52.132.172.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 12:34:06 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 12:34:06 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Thread-Topic: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Thread-Index: AQHVK2PPZerQVZ6WRkuW8hpHhbt/sKbc9NLQgAAIeQCAAAOZEIAAAniAgAABvNA=
Date:   Fri, 26 Jul 2019 12:34:06 +0000
Message-ID: <MN2PR20MB297370D86ADB8A099818D3BCCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1561469816-7871-1-git-send-email-pleeuwen@localhost.localdomain>
 <MN2PR20MB2973DAAEF813270C88BB941CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726120246.GA6956@gondor.apana.org.au>
 <MN2PR20MB297317829CB71379F92D9514CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726122429.GA7866@gondor.apana.org.au>
In-Reply-To: <20190726122429.GA7866@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d393ced9-fe3c-43b8-3de7-08d711c58cd2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2942;
x-ms-traffictypediagnostic: MN2PR20MB2942:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB294227232F793D5BFA4FE63FCAC00@MN2PR20MB2942.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(346002)(136003)(376002)(396003)(13464003)(199004)(189003)(33656002)(55016002)(76176011)(74316002)(7696005)(966005)(5660300002)(6916009)(26005)(15974865002)(86362001)(6246003)(316002)(66066001)(99286004)(81156014)(81166006)(54906003)(6116002)(4326008)(68736007)(186003)(14454004)(478600001)(52536014)(8936002)(66476007)(8676002)(6306002)(53936002)(486006)(305945005)(446003)(476003)(7736002)(66946007)(76116006)(71200400001)(71190400001)(229853002)(6506007)(9686003)(66556008)(6436002)(25786009)(256004)(2906002)(14444005)(53546011)(66446008)(102836004)(3846002)(64756008)(11346002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2942;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ptTdGqBDyKVK77GkPWQXnYo9eponRlucc+2pDURMXFj4ezg2gyyrEkI8iH2fCvtJxTtlU3+1XrIEHKSJmXYJ0J2TSV+oTeCkkDkRz6GyHlivlbV2sCKZFzGcHwNtgOVPfetV9iUPTBXadLqRk50rSK0Yxh2BRM2TxYTKqwjMVb5lR+D0JxhVLCGn97M3h5LQLucZIRm/MqvKSXQt66Sbw0WORpAF1FJeXxyZpurYBTxzlcp30lNObNhXeDdArqd4bp4htq0JItGNN83auyjztuliKcew/emAz0XrdXzYIx93/nHVJkEZrvlQPT1ueerW0+p/4/dSFUFnH2SZZLxlmIAc0HWG0kz2JrLl8UDd6eSewMia99jhyV8RVmL2q403GuaAJDkzM67wXmmIaRyStX1gqywVKX13zQifD+poL/0=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d393ced9-fe3c-43b8-3de7-08d711c58cd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 12:34:06.3883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2942
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, July 26, 2019 2:24 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net
> Subject: Re: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
>=20
> On Fri, Jul 26, 2019 at 12:21:40PM +0000, Pascal Van Leeuwen wrote:
> >
> > Actually, I did receive them back through the mailing list. In fact I d=
epend
> > on the mailing list to get them into my own regular company mailbox as
> > I have to send them through gmail from my Linux dev system ...
> > So I'm 100% confident they got sent out correctly.
>=20
> I just checked my linux-crypto archive and your patches are not
> in there.

On more careful observation, I noticed I also put my corporate e-mail on
the cc-list, so that's probably how I received them instead ...

They were sent to the mailing list, however. But I noticed that, for some
reason, they were sent from pleeuwen@localhost.localdomain instead
of my gmail, so I'm guessing the mailing list rejected them because of that=
?

Which now makes me wonder which of the patches I sent out ended up
on the mailing list at alll ...

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
