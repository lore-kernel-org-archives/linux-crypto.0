Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C30FC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 10:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59C342087B
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 10:12:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="aduLNw7r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfHEKMw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 06:12:52 -0400
Received: from mail-eopbgr680063.outbound.protection.outlook.com ([40.107.68.63]:7258
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfHEKMw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 06:12:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NL4EgejKSu5vNMJltNdYTq7QSLr/B2/sZXnxJmrs0TyFoXoIYBS8wDDXQ35EHWO3NvNBUVZUKPiSKr//9xiV9b5gBT7jVu8P9uqiE6hY8bCrmIsO9iw60/ojWJvMjg6vl69IJCH8XOlYtam8QyVeXoRxtWOsNDcvVwQecJyIKK04ue54p6jqk5iV+6aKVK+CcrDMvVGNcWP5eac2/M7GC5UXsJfTYlncw7lq9VMWpzx20EX0kgrD+3RclRGjgObfvAJU9+HUsk5g++MZaJknQCZJNKZDYMJe8Lx0rgyKwpT5J+UXHX+9zF3TG93WYVzMSpiIHlGo7IRnPhfo2KCn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZLma031ES0vCMpLKkFTjXMM5gKvUoWW1VZxjogQsDY=;
 b=YKusEs9NJK/0crZmr4un5/UsXscKyH+7JFSafpCuj1hoJnhiTi64aRsXMsosxBp9SFGZ1ZWRPuqI2VUJvXEvGsoBfjIwi2UebNaEiQ5EXAB1938aj88Jh8mGwq5p75w/qbKvN2ZKuO0sy1/xczf5YTvVx8blE9FY7kC3gBXwH81uhZvI6VOJlKLENv50ixFKo44CXpJFF08pGl+R0aXprEQmsARQLM5YJ5OU25NoZSZj2UqEqgTmQaZYQAWnD78FLkxOFxNvnlHpL4R2ltQSmRoOuJbJ/9C/kRH8Xuh2RzCWDGiqWNE62HbKN41TVx/COq8KJ2z8PGLr6weOFUnTWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZLma031ES0vCMpLKkFTjXMM5gKvUoWW1VZxjogQsDY=;
 b=aduLNw7r0Gl5auGGUkbFHxDB4lVQTCP7S9AYYp0D/173St4lz7zvR+j5mp1JzIB7ncFFcXZnYWGepkNvJ7rP/JcukgCQtHX6hLlKA1YEJGxTLn1QnIOli9fD3KdmHCIwWJitaMmuYzv3vWx1cN5Y9NVUFoVsk0l1vwZBWypAOR8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2493.namprd20.prod.outlook.com (20.179.148.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Mon, 5 Aug 2019 10:12:07 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 10:12:07 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Topic: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Index: AQHVR7116MJ9FzpBkkuhb1mvd6XCi6bsSuqAgAADriCAAAlyAIAAAZgw
Date:   Mon, 5 Aug 2019 10:12:07 +0000
Message-ID: <MN2PR20MB2973944BBF39EB11537E3163CADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805090725.GH14470@kwain>
 <MN2PR20MB29730648846013A67753624ECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190805095424.GJ14470@kwain>
In-Reply-To: <20190805095424.GJ14470@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b5dadc7-8f25-4e32-0aae-08d7198d5f81
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2493;
x-ms-traffictypediagnostic: MN2PR20MB2493:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2493DDE190A4E46F571DB0D4CADA0@MN2PR20MB2493.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(366004)(396003)(376002)(136003)(346002)(13464003)(189003)(199004)(71200400001)(71190400001)(5660300002)(55016002)(74316002)(7736002)(6306002)(3846002)(305945005)(25786009)(8676002)(6116002)(8936002)(6916009)(76176011)(68736007)(99286004)(54906003)(81166006)(81156014)(6246003)(66574012)(478600001)(66476007)(102836004)(66446008)(66946007)(64756008)(66556008)(15974865002)(6506007)(53546011)(26005)(4326008)(966005)(7696005)(52536014)(186003)(476003)(229853002)(53936002)(11346002)(66066001)(76116006)(486006)(14454004)(86362001)(316002)(446003)(33656002)(2906002)(9686003)(6436002)(256004)(14444005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2493;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SxMrBBejzns8dRApjM3U49t/YVdLzh8mDHcUrZJwRVP6/1avjJf+yhoeZDyUOOT1vFbar+oKrNACBY3QnERFD9efh8R6lxakbhZCaw2TRzS8pc7WNwJUkEeuJmAKPJ46jp6QGtaKPfTfZhlK61IbgGbsdt1hBw/sVAXbWuYNDM6qQv2cVzBptnzit/oRm6u9uWHv+l15hFYX/b9cWToupP9i2qoKzxXcF808XozukjP3YWeSUBuciFP1isSDE3fPjVYQJlBPEOwi5qHswla0hK/kqXDEK5pcAYzA8mfGsWAGoDtePMnNYHWblc2U+7k/eBJFSSJYjNI98wmeAOJ8337jnyK7wpPbN5OToVrEjisS5P7+XQCvfXcvgcj0OSOnmlSkejEChGVuyAfWj2V1jirRRBZWl/P1O4HGMHhOWoI=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5dadc7-8f25-4e32-0aae-08d7198d5f81
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 10:12:07.8560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2493
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Monday, August 5, 2019 11:54 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCHv3 4/4] crypto: inside-secure - add support for using =
the EIP197
> without vendor firmware
>=20
> On Mon, Aug 05, 2019 at 09:48:13AM +0000, Pascal Van Leeuwen wrote:
> > > On Wed, Jul 31, 2019 at 05:29:19PM +0200, Pascal van Leeuwen wrote:
> > > >
> > > > -	/* Release engine from reset */
> > > > -	val =3D readl(EIP197_PE(priv) + ctrl);
> > > > -	val &=3D ~EIP197_PE_ICE_x_CTRL_SW_RESET;
> > > > -	writel(val, EIP197_PE(priv) + ctrl);
> > > > +	for (pe =3D 0; pe < priv->config.pes; pe++) {
> > > > +		base =3D EIP197_PE_ICE_SCRATCH_RAM(pe);
> > > > +		pollcnt =3D EIP197_FW_START_POLLCNT;
> > > > +		while (pollcnt &&
> > > > +		       (readl_relaxed(EIP197_PE(priv) + base +
> > > > +			      pollofs) !=3D 1)) {
> > > > +			pollcnt--;
> > >
> > > You might want to use readl_relaxed_poll_timeout() here, instead of a
> > > busy polling.
> > >
> > Didn't know such a thing existed, but I also wonder how appropriate it
> > is in this case, condering it measures in whole microseconds, while the
> > response time I'm expecting here is in the order of a few dozen nano-
> > seconds internally ... i.e. 1 microsecond is already a *huge* overkill.
> >
> > The current implementation runs that loop for only 16 iterations which
> > should be both more than sufficient (it probably could be reduced
> > further, I picked 16 rather arbitrarily) and at the same time take so
> > few cycles on the CPU that I doubt it is worthwhile to reschedule/
> > preempt/whatever?
>=20
> Your choice, I was just making a suggestion :)
>=20
And I appreciate that, as I now know about this=20
readl_relaxed_poll_timeout() which I'm sure I will need for something
someday. I was just asking for comments on this particular situation.

After reading the implementation code, I think using it with a=20
sleep_us value of 0 and a time-out value of 1 may be reasonable here,
as time-out means some serious error that shouldn't normally happen.
I just wouldn't want any microsecond delays for the "normal" case.

> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
