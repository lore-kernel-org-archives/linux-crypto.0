Return-Path: <SRS0=EMKO=VK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE33EC742A7
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Jul 2019 15:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81FDB2064A
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Jul 2019 15:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="BierKShe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfGMPt0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Jul 2019 11:49:26 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:56736 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727626AbfGMPt0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Jul 2019 11:49:26 -0400
X-Greylist: delayed 78850 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jul 2019 11:49:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1563032964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JfTE67nb9PEJmAzg7MKiZGUNSIZWYpdKH2PH8CIcrGs=;
        b=BierKShe25WvXk51AGxkpddO3lnbkdC2gVeZGbID0RckLWsnJ873ZUiSts3z3LqbwABphm
        grIhRodPFxoL3RFw4zb02d5Cwv5+RVk4aY8S5n6tEad7r/bYbFAA/1ro9riOAno9Vr9lHt
        VozkTDjdGgavvCMDLVnOxCgccvErlOU=
Received: from NAM05-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam05lp2053.outbound.protection.outlook.com [104.47.48.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-ZilC39luNPCO0wUWIsNwZQ-1; Sat, 13 Jul 2019 11:49:21 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB1022.NAMPRD84.PROD.OUTLOOK.COM (10.169.47.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Sat, 13 Jul 2019 15:49:18 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41%8]) with mapi id 15.20.2052.022; Sat, 13 Jul 2019
 15:49:18 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Stephan Mueller <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: CAVS test harness
Thread-Topic: CAVS test harness
Thread-Index: AdU2IaQXtQPkG6HVRT2zauBDH3qftABvXlyAAABAX4AABvU+0AAAhPaAADcrObAAAXfCAAAsR+pQ
Date:   Sat, 13 Jul 2019 15:49:18 +0000
Message-ID: <TU4PR8401MB05441A079F9CDE48CE85E143F6CD0@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <1782078.ZURsmYODYl@tauon.chronox.de>
 <TU4PR8401MB05445179722F462CD8C05AB0F6F30@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <2317418.W1bvXbUTk3@tauon.chronox.de>
 <TU4PR8401MB0544B9D0BCD4C091857A1EAFF6F20@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <20190712183528.GA701@sol.localdomain>
In-Reply-To: <20190712183528.GA701@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.109.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67547d61-29c1-44df-f823-08d707a9aa99
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:TU4PR8401MB1022;
x-ms-traffictypediagnostic: TU4PR8401MB1022:
x-microsoft-antispam-prvs: <TU4PR8401MB1022CD9F50EF560904A30310F6CD0@TU4PR8401MB1022.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(129404003)(6602003)(189003)(199004)(13464003)(66946007)(66446008)(66556008)(64756008)(66476007)(76116006)(26005)(68736007)(81166006)(478600001)(8936002)(3480700005)(8676002)(99286004)(81156014)(25786009)(305945005)(7736002)(71190400001)(71200400001)(52536014)(86362001)(186003)(78486014)(5660300002)(9456002)(14454004)(54906003)(9686003)(6506007)(53546011)(33656002)(6246003)(11346002)(66066001)(446003)(476003)(7696005)(316002)(256004)(14444005)(102836004)(55236004)(76176011)(6116002)(3846002)(229853002)(6436002)(4326008)(486006)(74316002)(6916009)(7116003)(2906002)(53936002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB1022;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XiEqBLSZBvBnk+J5ZiYVLJdpvmItbIKU7R0ln8jmDWTjirmwYsLnpWeM289UcZHTvZHOLiVEa9osfqyRaeaFUEkw2k/0Ld4i8bfezLjQeyxrwiKM+MZvx6dTSD78tTOYwNxCb/MMtseyt9y+GJjwxKJ6fkDXCO0uaTxQLGzBhrmazPnJ5xWuwVrzeKgmWuqpcnmY9/ArCJZgYP2FmtreRl850uCxJJdyr4pQXdsNh/AV6IVSaCSSyerE9CRGBeKaRtkGuKQKBN7Jt5tGm9l318LW4TKZhl8BPFhkfLyRtSekDqcV8yyxUUQbIck78+SLhBFrnpQsdRexMFbynGg8puMPFXZFlklM+BZ9EqEQ4N5UUBzA45GpCMRivGj1yv9WayF1OLd4xzoGLQsxdX/dcXNuUZuuWjXK8AX2lvXYF6c=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67547d61-29c1-44df-f823-08d707a9aa99
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2019 15:49:18.8128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1022
X-MC-Unique: ZilC39luNPCO0wUWIsNwZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi  Eric,

There are couple tests from NIST to verify the ciphers like AES, SHA etc to=
 make sure that they are in compliance with NIST standards. Such tests are

KAT -  known answer test
MMT - Multi-block Message Test
MCT - Monte Carlo Test
KAS FFC - Key Agreement Scheme, Finite Field Cryptography
KAC ECC - Elliptic Curve Cryptography

Hope this helps.

Regards,
Jaya




-----Original Message-----
From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.or=
g> On Behalf Of Eric Biggers
Sent: Saturday, July 13, 2019 12:05 AM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>
Cc: Stephan Mueller <smueller@chronox.de>; linux-crypto@vger.kernel.org
Subject: Re: CAVS test harness

On Fri, Jul 12, 2019 at 05:55:07PM +0000, Bhat, Jayalakshmi Manjunath wrote=
:
> Hi Stephan,
>=20
> Thank you very much for the suggestions, I have another question, is it p=
ossible to implement MMT and MCT using kernel crypto API's.  Also FCC and F=
CC functions.
>=20
> Regards,
> Jaya
>=20

Please stop top posting.

I don't think you can implement Modern Monetary Theory, Medium-Chain Trigly=
cerides, or Federal Communications Commission functions using the Linux ker=
nel crypto API.

Of course, if those acronyms stand for something else, it would be helpful =
if you'd explain what they are :-)

- Eric

