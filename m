Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A09CC48BD5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 06:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A55620656
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 06:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.com header.i=@insidesecure.com header.b="mDD1SubO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfFYGlK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:41:10 -0400
Received: from mail-eopbgr80119.outbound.protection.outlook.com ([40.107.8.119]:5697
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727141AbfFYGlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 02:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=insidesecure.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UU8Xvu7Rban/YsR+rkyJrUrC/X+EqMbYIRQgUmJpEsI=;
 b=mDD1SubOHgolhCMOOt+Z591c0UzKylm+z0w6lYZNi9+LaKzrWIAvn++WwHa7ncEWWbPhBJAAWlaWYm/K/IipPbw3QZtcKOS8x2TkoffzBRwKHyi+JDoMjVmesGhVjs2lpqAzSEiPjE29HZ09kifRlCRrXjp9YNwEOz6ihBkmkcI=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3333.eurprd09.prod.outlook.com (20.179.245.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Tue, 25 Jun 2019 06:41:05 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::c1ca:f973:dad2:a91f]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::c1ca:f973:dad2:a91f%6]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 06:41:05 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Thread-Topic: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Thread-Index: AQHVJaNNu6u4U0xf7kGF/n6JpxvKYaai6XuAgAAgPJCAAX9kAIAAGfRAgAAPVoCABjI2gIABEFAw
Date:   Tue, 25 Jun 2019 06:41:05 +0000
Message-ID: <AM6PR09MB35233FB062FFEAABAF7671C9D2E30@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619122737.GB3254@kwain>
 <AM6PR09MB3523D2FEC3A543FF037812DCD2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620131512.GB4642@kwain>
 <AM6PR09MB35236CA6971A1B6D03AB9BD4D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620154259.GE4642@kwain>
 <20190624142015.udlec3ho57a47hps@gondor.apana.org.au>
In-Reply-To: <20190624142015.udlec3ho57a47hps@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 076df896-9abb-46a3-14f5-08d6f938191f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3333;
x-ms-traffictypediagnostic: AM6PR09MB3333:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB3333C4FFC6E3BD44BCC9F2A5D2E30@AM6PR09MB3333.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(39850400004)(396003)(13464003)(199004)(189003)(3846002)(6116002)(446003)(486006)(6246003)(99286004)(76116006)(7696005)(256004)(76176011)(476003)(11346002)(53546011)(102836004)(26005)(6506007)(316002)(66476007)(66556008)(64756008)(66446008)(14454004)(66066001)(52536014)(110136005)(5660300002)(66946007)(73956011)(4744005)(54906003)(4326008)(74316002)(33656002)(71200400001)(7736002)(15974865002)(25786009)(71190400001)(478600001)(186003)(81166006)(81156014)(8676002)(8936002)(86362001)(68736007)(9686003)(6436002)(55016002)(2906002)(53936002)(229853002)(305945005)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3333;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BaFww7FR6DKL75NC31cTZkU0RHQZxU6cDlfB2Qg2zjvr7d5ibTg8WMJS6cjAyus8GveayOOBPQ41+NglzD4zwNH1JkMZcFaxg2gR5V/P9E+diiUdDjJlBfMVfL64zJ+KShl+r/RgXhr5wBfNWdOdSqXHOm9nzdVbazlkl9H9najC+z3uTgjX4LQG9WIF/8e6ImtwJhVo8qnmigEpxFuA1/GZhJs4DhzQOK6d3p/pVXSKkfvB47w3/rz+not58StOb8kBU1P01OAOQAA0v48aOpkAi9hDXdWJonO29p+o7nT0zdm/OB2OeJygeI0H+IiSwec2zbZHcjHhSPRRnYHAxf+5xMWgNKg1a+OcNcdBfxXthsNlrV+p5YIYy04ewbNddgChmPkZf9pQB8FAloySszoDfb9cT/27NvQaWTqJdGw=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076df896-9abb-46a3-14f5-08d6f938191f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 06:41:05.4096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3333
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, June 24, 2019 4:20 PM
> To: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>; Pascal van Leeuwen=
 <pascalvanl@gmail.com>; linux-
> crypto@vger.kernel.org; davem@davemloft.net
> Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using th=
e EIP197 without firmware images
>=20
> On Thu, Jun 20, 2019 at 05:42:59PM +0200, Antoine Tenart wrote:
> >
> > Yes, you either have to choice to put it in /lib/firmware (and in the
> > linux-firmwares project!) or to convince people to allow releasing this=
.
>=20
> I agree.  We should not be adding firmware into the driver itself.
>=20

OK, so I guess the alternative would be to get the firmware binaries into t=
he linux-firmwares=20
project? I can do that ...

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

