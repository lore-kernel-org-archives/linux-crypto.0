Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71472C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 21:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 313212168B
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 21:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="EQU4aUJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbfEWVn7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 17:43:59 -0400
Received: from mail-eopbgr20106.outbound.protection.outlook.com ([40.107.2.106]:24484
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387709AbfEWVn6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 17:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RGeybYcFbvFsYEM3x6Rje5P0BKU1W9mqRevrXwSFBs=;
 b=EQU4aUJfbqdZVKjj2Oxr5nscAOLLHs5uNQMt4ms5UzEylhWX2DrtSeaj9DG3C4JcXLw3vPiSm7+OQ04g1PogjYG4SZrxaQSYmMKdaXr0SjIhbIke/1Woub60bfyxG4XgsuQdHauCcCehc8X76GEhknfVjqsuevHZx8E5n5QabMc=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3508.eurprd09.prod.outlook.com (10.255.99.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 23 May 2019 21:43:54 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 21:43:54 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wA==
Date:   Thu, 23 May 2019 21:43:53 +0000
Message-ID: <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
In-Reply-To: <20190523200557.GA248378@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 253953c8-3b7f-4773-05ee-08d6dfc7c08f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3508;
x-ms-traffictypediagnostic: AM6PR09MB3508:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB3508885239A66A3DE5446375D2010@AM6PR09MB3508.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(376002)(366004)(136003)(396003)(346002)(13464003)(51914003)(199004)(189003)(52314003)(8936002)(186003)(3480700005)(55016002)(8676002)(26005)(7736002)(81166006)(53546011)(6916009)(7116003)(6436002)(5660300002)(305945005)(102836004)(74316002)(6506007)(76116006)(52536014)(486006)(86362001)(476003)(64756008)(229853002)(446003)(73956011)(66946007)(66556008)(7696005)(25786009)(81156014)(71190400001)(71200400001)(11346002)(66476007)(66066001)(68736007)(9686003)(14444005)(6246003)(99286004)(316002)(76176011)(14454004)(6116002)(256004)(53936002)(2906002)(66446008)(33656002)(478600001)(3846002)(4326008)(15974865002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3508;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yCubog1hMa8FMb/PIhLnYSxlJc+kw+Tiir9beyoLiXgnGeXwfz/++/1VeMOPgLlvT4fAeGdQ2vn6VzhHQSymVOHv/f0Rx52RQDfD8sziI8SHThlJQ37gEZaT8TwYX0zf+3p9klyDqKHlCXiM9BY8fRsSapg5TAO/ezw46QpK2VVN6mjsMo8QU2A7lvJcFR3LRRB1wnhJrxvzOmA9mQ+9UUkkc83NG4LiTqv5jtMwCXqKfkMofvkHa5KPeQvu0EfrvpZPugVNPP+qGmLCHC3NWIi2CC+nLiMt7ix1MF7p8753VAM8WIT2nbfHcRBk3DMqq17W5kJUrPHN994/SSWhoNRtesNDrY3Rbw2TA+c80MWYHm6k17ftQ3INWyVj8tb8iesESlb6v0X8wdeU0vgR4P57zwrE3Fq88KtGRt6v+oM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253953c8-3b7f-4773-05ee-08d6dfc7c08f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 21:43:54.0838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3508
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers [mailto:ebiggers@kernel.org]
> Sent: Thursday, May 23, 2019 10:06 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: another testmgr question
>
> On Thu, May 23, 2019 at 01:07:25PM +0000, Pascal Van Leeuwen wrote:
> > Eric,
> >
> > I'm running into some trouble with some random vectors that do *zero*
> > length operations. Now you can go all formal about how the API does
> > not explictly disallow this, but how much sense does it really make
> > to essentially encrypt, hash or authenticate absolutely *nothing*?
> >
> > It makes so little sense that we never bothered to support it in any
> > of our hardware developed over the past two decades ... and no
> > customer has ever complained about this, to the best of my knowledge.
> >
> > Can't you just remove those zero length tests?
> >
>
> For hashes this is absolutely a valid case.  Try this:
>
> $ touch file
> $ sha256sum file
> e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  file
>
> That shows the SHA-256 digest of the empty message.
>
Valid? A totally fabricated case, if you ask me. Yes, you could do that,
but is it *useful* at all? Really?
No, it's not because a file of length 0 is a file of length 0, the length
in itself is sufficient guarantee of its contents. The hash does not add
*anything* in this case. It's a constant anyway, the same value for *any*
zero-length file. It doesn't tell you anything you didn't already know.
IMHO the tool should just return a message stating "hashing an empty file
does not make any sense at all ...".

>
> For AEADs it's a valid case too.  You still get an authenticated cipherte=
xt
> even
> if the plaintext and/or AAD are empty, telling you that the (plaintext, A=
AD)
> pair is authentically from someone with the key.
>
Again, you could *theoretically* do that, but I don't know of any *practicl=
e*
use  case (protocol, application) where you can have *and* 0 length AAD *an=
d*
0 length payload (but do correct me when I'm wrong there!)
In any case, that would result in a value *only* depending on the key (same
thing applies to zero-length HMAC), which is likely some sort of security
risk anyway.

As I mentioned before, we made a lot of hashing and authentication hardware
over the past 20+ years that has never been capable of doing zero-length
operations and this has *never* proved to be a problem to *anyone*. Not a
single support question has *ever* been raised on the subject.

>
> It's really only skciphers (length preserving encryption) where it's
> questionable, since for those an empty input can only map to an empty out=
put.
>
True, although that's also the least problematic case to handle.
Doing nothing at all is not so hard ...

> Regardless of what we do, I think it's really important that the behavior=
 is
> *consistent*, so users see the same behavior no matter what implementatio=
n of
> the algorithm is used.
>
Consistency should only be required for *legal* ranges of input parameters.
Which then obviously need to be properly specified somewhere.
It should be fair to put some reasonable restrictions on these inputs as to
not burden implementions with potentially difficult to handle fringe cases.

> Allowing empty messages works out naturally for most skcipher
> implementations,
> and it also conceptually simplifies the length restrictions of the API (e=
.g.
> for
> most block cipher modes: just need nbytes % blocksize =3D=3D 0, as oppose=
d to
> that
> *and* nbytes !=3D 0).  So that seems to be how we ended up with it.
>
I fail to see the huge burden of the extra len>0 restriction.
Especially if you compare it to the burden of adding all the code for
handling such useless exception cases to all individual drivers.

> If we do change this, IMO we need to make it the behavior for all
> implementations, not make it implementation-defined.
>
I don't see how disallowing 0 length inputs would affect implementations th=
at
ARE capable of processing them. Unless you would require them to start
throwing errors for these cases, which I'm not suggesting.

> Note that it's not necessary that your *hardware* supports empty messages=
,
> since you can simply do this in the driver instead:
>
>       if (req->cryptlen =3D=3D 0)
>               return 0;
>
For skciphers, yes, it's not such a problem. Neither for basic hash.
(And thanks for the code suggestion BTW, this will be a lot more efficient
then what I'm doing now for this particular case :-)
For HMAC, however, where you would have to return a value depending on the
key ... not so easy to solve. I don't have a solution for that yet :-(

And I'm pretty sure this affects all Inside Secure HW drivers in the tree:
inside-secure, amcc, mediatek and omap ...

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines, Inside Secure
www.insidesecure.com
