Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A416DC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C962217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="m8iBwDz8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbfEXIoO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 04:44:14 -0400
Received: from mail-eopbgr50126.outbound.protection.outlook.com ([40.107.5.126]:13214
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389448AbfEXIoO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 04:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bjfxdw2bcUiovf0H79FDanZYdHksyCk1Q8hdznSWeCM=;
 b=m8iBwDz8t019qvpIGS8NR+surbX245AKqea+Z064IcdHKOI3+PCeGopF5gfZeyFrLaCXOq4W3VCaU8Iz7DQ+DBvgZM40t5dddMDUI02F9sP7px6s/+jw4RVetx6BSWgkQMNj890H6zkF63/bpKjXQXfQjULp6RZBHKxZl0El/xU=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3554.eurprd09.prod.outlook.com (10.255.99.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Fri, 24 May 2019 08:44:10 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 08:44:10 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vA=
Date:   Fri, 24 May 2019 08:44:09 +0000
Message-ID: <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
In-Reply-To: <20190523234853.GC248378@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21b3405c-8c3b-4b29-1ca9-08d6e023fd76
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3554;
x-ms-traffictypediagnostic: AM6PR09MB3554:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <AM6PR09MB3554FEE580F85FFBB9E4BC6ED2020@AM6PR09MB3554.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(39850400004)(346002)(366004)(52314003)(189003)(199004)(966005)(6436002)(71200400001)(55016002)(71190400001)(6506007)(68736007)(486006)(81156014)(8676002)(478600001)(76176011)(25786009)(8936002)(26005)(186003)(6306002)(256004)(6116002)(5660300002)(99286004)(9686003)(446003)(476003)(316002)(11346002)(102836004)(3846002)(7696005)(66066001)(7736002)(52536014)(229853002)(53936002)(6246003)(66946007)(66446008)(64756008)(81166006)(7116003)(86362001)(73956011)(76116006)(3480700005)(74316002)(4326008)(33656002)(66556008)(305945005)(2906002)(6916009)(14454004)(15974865002)(66476007)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3554;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xH0pGEbjPIpidm0/fP1nEk+wCaT8et1979CLWcVgD5KbQo/tb4DrGfbCPQx+DUOvH0qsvYSrD9L1B5XbRCsKoJ2ObF+1Hcjcpjeqmdo2EjL54uZybRm6O7glgcTtN/ZvOd5SLRLvUq8UsZMnG8nxDEK9wdIH02TV0Zpz1jVllB7ahdZBb+ZFL41/adnYLtrw1ZINzQMCNgMhR0H0c1la0+KVQEVPFQakd8bUB2hfyr3czmBzXPEs28nyO/INGcl2vKRd1I+brUB87UqPwLUdZ58dqVmAy98iMQATkSFXTbOZHzQyRy+8xVL+nvZe8lu85xda5uaGfpPQP+zl5crMAvX7ptS7aWoBHSRWat5JPbZBcrx8uSCOIPfSG4WkqNFJ9zS27Cmubzzt7RkBubc19906SKAka+TM54iL81TU7nQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b3405c-8c3b-4b29-1ca9-08d6e023fd76
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 08:44:09.9088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3554
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > Valid? A totally fabricated case, if you ask me. Yes, you could do that=
,
> > but is it *useful* at all? Really?
> > No, it's not because a file of length 0 is a file of length 0, the leng=
th
> > in itself is sufficient guarantee of its contents. The hash does not ad=
d
> > *anything* in this case. It's a constant anyway, the same value for *an=
y*
> > zero-length file. It doesn't tell you anything you didn't already know.
> > IMHO the tool should just return a message stating "hashing an empty fi=
le
> > does not make any sense at all ...".
> >
>
> Of course it's useful.  It means that *every* possible file has a SHA-256
> digest.  So if you're validating a file, you just check the SHA-256 diges=
t;
> or
> if you're creating a manifest, you just hash the file and list the SHA-25=
6
> digest.  Making everyone handle empty files specially would be insane.
>
As I already mentioned in another thread somewhere, this morning in the
shower I realised that this may be useful if you have no expectation of
the length itself. But it's still a pretty specific use case which was
never considered for our hardware. And our HW doesn't seem to be alone in
this.
Does shaXXXsum or md5sum use the kernel crypto API though?

>
> The standard attack model for MACs assumes the attacker can send an arbit=
rary
> (message, MAC) pair.  Depending on the protocol there may be nothing
> preventing
> them from sending an empty message, e.g. maybe it's just a file on the
> filesystem which can be empty.  So it makes perfect sense for the HMAC of=
 an
> empty message to be defined so that it can be checked without a special c=
ase
> for> empty messages, and indeed the HMAC specification
> (https://csrc.nist.gov/csrc/media/publications/fips/198/1/final/documents=
/fip
> s-198-1_final.pdf)
> clearly says that 0 is an allowed input length.  Note that the algorithmi=
c
> description of HMAC handles this case naturally; indeed, it would be a
> special case if 0 were *not* allowed.
>
> Essentially the same applies for AEADs.
>
Oh, it's defined all right. I never argued that it wasn't.
But just because the *algorithm* allows it doesn't necessarily mean that yo=
u
*have* to support it from your API. Even FIPS allows for not supporting zer=
o
length for validation - zero length support is optional there.

And I'm just not aware of any real use case - usually some standard non-zer=
o
header is included as AAD - so why bother going out of your way to support =
it.
If something fails because of this, you can always fix it right there and t=
hen.

>
> People can develop weird dependencies on corner cases of APIs, so it's be=
st
> to
> avoid cases where the behavior differs depending on which implementation =
of
> the
> API is used.  So far it's been pretty straightforward to get all the cryp=
to
> implementations consistent, so IMO we should simply continue to do that.
>
I want to bet the people having to implement all these workarounds and fixe=
s
in those drivers would argue that it's not so straightforward at all ...

> What might make sense is moving more checks into the common code so that
> implementations need to handle less, e.g. see how
> https://patchwork.kernel.org/patch/10949189/ proposed to check the messag=
e
> length alignment for skciphers (though that particular patch is broken as=
-
> is).
>
That goes without saying.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

