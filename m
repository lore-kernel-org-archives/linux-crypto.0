Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EC0C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3124522BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="KYNgo0Rl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfGZMVo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:21:44 -0400
Received: from mail-eopbgr730063.outbound.protection.outlook.com ([40.107.73.63]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbfGZMVo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:21:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTm/DWEJU5OUnREO61vPvoMtas6rzfn56Gt8uXQYokmGSt5FNBhuRpcF6fm7r0F+Uz0xDW9u7XGGwHh75kahpXHwhhqdmcoJHS6MeqbupQVuzbo9WCOYgo6PU5MU3YyhQflOk9msyu+T9p9F2N2xaMAOs7C/GM0IKT+3TYrmHvPov8AsFazsixm51LYOfhPItSRqR8cGXLEcaBI55+B9s6i7ICaX/H1PxOBitiyFdZ4j6wtVvEKEseYfOeIjeKXlywog1dklSzR8Yuc9CmfyEee5IUONDw3/BuC3lirWIThz17tQ6vSDPub4086BDJZ5zgpyoQddeylFNLPvaXuvmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lm9gESTPH6VK/tK9jyp0uxlx1sLfIWPdKev3R1RmkjI=;
 b=OY/BJTldSEQFM1PR7W7hC6jjMtBH5PzpmGv1YuSm3hDNnGG+z8QsyOrFWH3uI6on+w2Xf+rGL7edjka7t/qe83RCjGbk7xmSWZ/5D/HTvO7C//M7QDDtpsjNwlxY1F606JRgcLOcdpianx+UU+2J4UE68OX95KFg66T807QBYgc2vzLZFZ8f+6TnJzgECVB+vwp40QCKle4Ckga4tm7uUihgi16Y/w/wyB0WRwO4TiFNii/gNn5FjG01j4rl1Hm4J5rM5rL6kKz9xCYk1whoXJpRQbR0lpiGNodhA8TLjHp8JhjeGbCLAz4OeHJQGdWnJGgpmFHRO/2o3YS/JSRqIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lm9gESTPH6VK/tK9jyp0uxlx1sLfIWPdKev3R1RmkjI=;
 b=KYNgo0RlQACxhsgH2tIXZWEBkEyV/x7L4eB8UZROMIv7mTqmsBr0FzYbFtQLcSXr2AgrI+ZAyv7Bq0GLv4cd+hhOnaa0hMWplJPbSQBCCfd1/CESwJwZRf+6HvNSy8Irx0CMYOgcUFG+ogwr9afv/96U6hMfqYloJxORFKrxVlk=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2320.namprd20.prod.outlook.com (20.179.145.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 12:21:40 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 12:21:40 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Thread-Topic: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
Thread-Index: AQHVK2PPZerQVZ6WRkuW8hpHhbt/sKbc9NLQgAAIeQCAAAOZEA==
Date:   Fri, 26 Jul 2019 12:21:40 +0000
Message-ID: <MN2PR20MB297317829CB71379F92D9514CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1561469816-7871-1-git-send-email-pleeuwen@localhost.localdomain>
 <MN2PR20MB2973DAAEF813270C88BB941CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726120246.GA6956@gondor.apana.org.au>
In-Reply-To: <20190726120246.GA6956@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5edb12ba-f0e9-45af-f8c2-08d711c3d006
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2320;
x-ms-traffictypediagnostic: MN2PR20MB2320:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2320EC5A11B21FE18B3E8808CAC00@MN2PR20MB2320.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(366004)(346002)(136003)(13464003)(199004)(189003)(55016002)(66476007)(86362001)(9686003)(66946007)(6306002)(66556008)(64756008)(26005)(102836004)(305945005)(7736002)(3846002)(76116006)(6116002)(4326008)(99286004)(6246003)(6436002)(52536014)(5660300002)(53936002)(66066001)(7696005)(76176011)(66446008)(316002)(229853002)(68736007)(486006)(8676002)(14454004)(71190400001)(71200400001)(15974865002)(476003)(33656002)(2906002)(478600001)(81166006)(6916009)(6506007)(81156014)(446003)(74316002)(8936002)(14444005)(186003)(256004)(25786009)(54906003)(53546011)(11346002)(966005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2320;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F5CQ/0RwWN7suX13FRnLLrPkn3mJLzo3y7d1jgvj0M2cBuYRT1n5+jEDFKTB6SIyaY47D4wOcSrulKu2treyr1AQYXwNWQF+IpEXnvKiuMqzXNhKbZC4zMq3vXSUS8EljYdD9hcQc6h5XGyjADz7MTV8ai/MfQv3WqN8llMt8lYOED6hoppb3barA7i80RwZo5S3kGGks2d82tJrsmxM9kje9FxwRN1o1Pqjlwcl0gI6m4v4gk4StS3HYJkUkc0LymPvHbeXD0nxFwSBKOSG42Dq/Qsy/hRKgfiElEsXjx4AHyPXCWy/avsES5QVALnemiXTf62H1ni74aHQCXMN0yexN50CPFVSnVPd/tWmWdBlNRXneQw0Gq2nPq+dCLeDf7mMMMGApHobaZDssRX6tcvRPJE+0Z5XDhyIcNvDyPs=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5edb12ba-f0e9-45af-f8c2-08d711c3d006
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 12:21:40.1807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2320
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Herbert Xu
> Sent: Friday, July 26, 2019 2:03 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net
> Subject: Re: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
>=20
> On Fri, Jul 26, 2019 at 11:33:07AM +0000, Pascal Van Leeuwen wrote:
> > Hi,
> >
> > Just a gentle ping to remind people that this patch set - which incorpo=
rates the feedback I
> > got on an earlier version thereof - has been pending for over a month n=
ow without
> > receiving any feedback on it whatsoever ...
>=20
> Your patches are not in patchwork.  If they're not there then
> they won't be applied.  You need to find out why your emails
> weren't accepted by the mailing list or patchwork.kernel.org.
>=20

Actually, I did receive them back through the mailing list. In fact I depen=
d
on the mailing list to get them into my own regular company mailbox as=20
I have to send them through gmail from my Linux dev system ...
So I'm 100% confident they got sent out correctly.

I don't really know why they did not end up in patchwork? Is there
anything wrong with the formatting of the patches? If so, please
let me know so I can fix that prior to resending them(!) ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
