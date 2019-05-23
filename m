Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2408EC282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 19:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC2FF20851
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 19:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="tFFspnZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389255AbfEWToO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 15:44:14 -0400
Received: from mail-eopbgr40096.outbound.protection.outlook.com ([40.107.4.96]:19470
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389795AbfEWToM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 15:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yukUyGAvebJU4XAGGSPiSwed0CAYxDW98FnkbVMR3Q=;
 b=tFFspnZvdIaw1HHhRQow7q31xCxm/JC1IzTTrb1uyQ9+FRggUOXs9jvYwu23C5lkgslKfLV5Tbrm3Lpdt2zt8vPe6ffPAKxNwr37FEUA2RK3dUsiRvveVbb4iIa4ZVDv4KRG7YSg8D3DPWYdblYTgG5qfJLF/rKyXdJc81cL52c=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3011.eurprd09.prod.outlook.com (10.255.96.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.26; Thu, 23 May 2019 19:44:08 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 19:44:08 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: testmgr question
Thread-Topic: testmgr question
Thread-Index: AQHVELtKP84dFEilq0iFiqYO3+2dVaZ5E5TpgAAHQ2A=
Date:   Thu, 23 May 2019 19:44:08 +0000
Message-ID: <AM6PR09MB3523BE1CDAE2E25AC47A3FD6D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523DA127897A981C9E0074FD2000@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190522162737.GA132972@google.com>
 <AM6PR09MB3523F1C423891763D4B3BF7CD2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523190534.GB243994@google.com>
In-Reply-To: <20190523190534.GB243994@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05f5765b-c107-4cfa-70a6-08d6dfb705d0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3011;
x-ms-traffictypediagnostic: AM6PR09MB3011:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB30117A733D3756DACEA166A8D2010@AM6PR09MB3011.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(396003)(346002)(39850400004)(199004)(189003)(13464003)(2906002)(11346002)(4326008)(256004)(14444005)(3846002)(71190400001)(71200400001)(74316002)(6436002)(6116002)(25786009)(229853002)(446003)(476003)(76176011)(186003)(7116003)(81166006)(81156014)(486006)(53936002)(55016002)(6246003)(14454004)(8676002)(6506007)(53546011)(9686003)(110136005)(102836004)(8936002)(5660300002)(99286004)(7736002)(305945005)(3480700005)(478600001)(76116006)(73956011)(66946007)(86362001)(15974865002)(66476007)(66556008)(64756008)(66446008)(316002)(7696005)(2501003)(66066001)(26005)(52536014)(221733001)(68736007)(33656002)(111123002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3011;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 37BcSnR6lEvzxW+8Nj+3rsrIhsSetQdKADGvWGb7TVAzq5/lIcs5DwS4eG9qMfza/NRU8afjT6oYQmjqcBiY5FsY39hxsblRcJeu79YgMhqkTAN2TCJ5JIGqOUNIP3GAlhtmLrKdhFia3Axat3zOsUdewf0YisqC1PWSiSfL3yBaCisd7hcIRRZFbOUsXUKE72Qfkh/zJNBx0tKsRwvLzI25PP/IRqW6ix7u/8bG4UCOW4LTCPIwlouPo77Xn9XXI9yyOU37/g0nLFr3C25vUP1ncNuaXhVLjRvsPVAVrJKru8FJTkwLjW2Tg6u1HZnEHLcEHCJ+qXadKi0srwzVh3kFWa7mAXcAHWsosDyR8P25Rr+sYC8TC4GZmxiqjdkTe6PkzgNlaqCh52pCumDUe8tA1Gfrs9IhRXaOc2RR0ZU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f5765b-c107-4cfa-70a6-08d6dfb705d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 19:44:08.7600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3011
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers [mailto:ebiggers@google.com]
> Sent: Thursday, May 23, 2019 9:06 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: linux-crypto-owner@vger.kernel.org; Herbert Xu
> <herbert@gondor.apana.org.au>
> Subject: Re: testmgr question
>
> On Thu, May 23, 2019 at 07:01:46AM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: Eric Biggers [mailto:ebiggers@google.com]
> > > Sent: Wednesday, May 22, 2019 6:28 PM
> > > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > > Cc: linux-crypto-owner@vger.kernel.org; Herbert Xu
> > > <herbert@gondor.apana.org.au>
> > > Subject: Re: testmgr question
> > >
> > > On Wed, May 22, 2019 at 01:32:43PM +0000, Pascal Van Leeuwen wrote:
> > > > Ugh,
> > > >
> > > > I just synced my development branch with Linus' mainline tree (5.2-=
rc1)
> and
> > > > apparently inherited some new testmgr tests that are now failing on=
 the
> > > Inside
> > > > Secure driver. I managed to fix some trivial ones related to non-ze=
ro
> IV
> > > size
> > > > on ECB modes and error codes that differed from the expected ones, =
but
> now
> > > I'm
> > > > rather stuck with a hang case ... and I don't have a clue which
> particular
> > > test
> > > > is hanging or even which algorithm is being tested :-(
> > > >
> > > > Is there, by any chance, some magical debug switch available to mak=
e
> > > testmgr
> > > > print out which test it is actually *starting* to run?
> > > >
> > > > Regards,
> > > >
> > > > Pascal van Leeuwen
> > > > Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> > > > www.insidesecure.com
> > > >
> > >
> > > Not currently, but you can easily add some debugging messages to test=
mgr
> > > yourself.  E.g.,
> > >
> > > Print 'alg' and 'driver' at beginning of alg_test() to see which
> algorithm is
> > > starting to be tested.
> > >
> > > Print 'vec_name' and 'cfg->name' at beginning of test_hash_vec_cfg(),
> > > test_skcipher_vec_cfg(), and test_aead_vec_cfg() to see which test ve=
ctor
> is
> > > starting to be tested and under what configuration.
> > >
> > Thanks. I guess adding such debugging statements to testmgr is what I'v=
e
> been
> > doing all along. Like everyone else having to debug these issues, I gue=
ss
> ...
> > Therefore I assumed by now, there might have been some standard
> infrastructure
> > for that. Or maybe it was just a hint that such a thing might be useful=
 ;-)
> >
>
> testmgr already prints information when a test fails which is enough for =
most
> cases, and in my experience when it's not I need to add messages specific=
 to
> tracking down the particular issue anyway.  So that's why I haven't
> personally
> added more messages.  Feel free to send a patch, though.  Also, please
> continue
> any further discussion of this on linux-crypto.
>
When developing hardware drivers, when things go wrong, odds are fairly
significant that the whole thing just hangs (or is that just me? :-).
So I can imagine I'm not the only one adding these debug print statements,
which means effort is probably wasted here. But I do notice that I keep
adding and removing them/commenting them out as they're pretty annoying whe=
n
things don't actually hang ...

Usually just knowing which specific case fails is enough for me  to reason =
about
why it's failing. I rarely need more debugging information than that. Follo=
wing
a hash/HMAC operation is pretty impossible anyway unless you have a referen=
ce
implementation standing by to compare with.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

