Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E30C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 23:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D59D52089C
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 23:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="u+uqrWx/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732597AbfGSXJr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 19:09:47 -0400
Received: from mail-eopbgr700060.outbound.protection.outlook.com ([40.107.70.60]:38912
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728747AbfGSXJr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 19:09:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cjsmr5aR21Jd734uPQaIRkiZE/jymcSYC2wmKJevbiS5/VYiU/44CX/+byqjuaSJA/dQgzUCMWz84XyaqyLymjalYLkDjIHvf4+iAtf6Yhogkfu6SZJKtKVDnmeD2gBsXVNwa9nBlgEY/izq3ctLpAEQWgJ8HZrK879zxm8bPtBi6zBZNEKDHCAhi0x85xpp2cJrqcyoRKZ9XVc58WtP2go2Cv1usACPrt+KtP5cGGp5nNaihEw7iffrA/Yr5otrd2d6msfOD2Mx9nULkHbOjDlc7D+ILE+ImlwmbBzvVSIthY9NriXCptL6R8wFL5cdw79IefFJU6DKGz0YNPNc/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8Uotq/ktYneTrsvnKuZJ7fGiKP6jJLZc6DfGxhO2Gc=;
 b=Bk5jwz/ZPnz7TPuYp9ajQQTH79/8m7bu1srd+u7JF+Az1JILcRCoPsmcsQAgzUAnT2nhTXE1QDG66+lB3OiEzBTgqvPZ2R9uZ+TcUXNWcXZYYX0+2t1GZ7aTxzcgM5YfI9mdBjfF1yFWuw1nZK8rxuJfP4Z0ECe0jjs1IcuSAf18fX3SzKBkFvkjHiPdvADC8gX7HNMCw11PtWnfFNsF07a/MiclDBhYEf+UZp+EeVRelo13YIkT2fBSVeQ41Mi2JLMxQeEi3cnnst5Xuo/Pgc1sq2SXUqIvwyivb8efYij/kr/NaEjkOmsBbFOuzZ3ZQ0SkV5+hebzQHmBuEhVj9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8Uotq/ktYneTrsvnKuZJ7fGiKP6jJLZc6DfGxhO2Gc=;
 b=u+uqrWx/DN+Ml7GnExeMS1VsJYhb8LvczKEvuGg8xT1oau5CDKyO+7PSzkI5AZ0d52SOWn8o1mp6dZ8wWiKfSkTqC3Vb5QCa/a7ZN7KqxrpLRcP5vaFy9/4PDTqzPbeCtsffpbq/cl/F5sbcYU6PHv5sifMwvctRB5QBpvWU6Z4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2624.namprd20.prod.outlook.com (20.178.253.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Fri, 19 Jul 2019 23:09:43 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 23:09:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: ghash
Thread-Topic: ghash
Thread-Index: AdU+OcccbSpphUQDQMqR1uphPmes/wAE33+AAAYsZgAAAYlpgAAAwhCgAAMhLwAAABR8oA==
Date:   Fri, 19 Jul 2019 23:09:43 +0000
Message-ID: <MN2PR20MB2973FEAD7B8015D036DC242FCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719161606.GA1422@gmail.com>
 <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719195652.GC1422@gmail.com>
 <MN2PR20MB2973FF077218AB3C2DF2E4A0CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719214811.GE1422@gmail.com>
In-Reply-To: <20190719214811.GE1422@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc8c31d4-d187-4e96-a664-08d70c9e2f3e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2624;
x-ms-traffictypediagnostic: MN2PR20MB2624:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB26248EDCDC7373053157DFEFCACB0@MN2PR20MB2624.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39850400004)(366004)(136003)(199004)(189003)(33656002)(71190400001)(71200400001)(7696005)(305945005)(74316002)(14454004)(7736002)(6506007)(256004)(3480700005)(99286004)(186003)(486006)(26005)(54906003)(102836004)(15974865002)(8676002)(446003)(11346002)(76176011)(316002)(476003)(4326008)(68736007)(8936002)(5660300002)(6116002)(6246003)(3846002)(6916009)(66946007)(76116006)(7116003)(221733001)(52536014)(81166006)(81156014)(66066001)(66446008)(64756008)(66556008)(66476007)(229853002)(55016002)(9686003)(2906002)(6436002)(86362001)(53936002)(478600001)(25786009)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2624;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 37IsulPeNUub/9nWTbJ7n5mhjKrMNKTZTgVF/RNs1Mw7TcGuF/ht6GJNK/I/uND0aSTMpwLI7AWx3zZUQ+CUNo5NKbIxmeDt4C6p+Oqo7kyFfE40iU+U6KrcUSNcZBe8PyDmfoS+TF0jJdqH6DcxrldS6GYMyNEipyEaraeenlxOUkFZwkAFLMtf5+XojBbd5Hon2bL84MwQnBlmgF+uAZN++CDZeQ1VnrhjQTcsnfFiYdwqQGsKtd3Mc/KwcZPzkRGTSs997cyOXgGl3a04BO4ZpH5m9IWxm4PrtkSwCEY+Y3QU5S4JMbmYS67vAigCB3JMA9xHEnGpKJA1vyvpgOseiXWNRx418hgwRc9M4iPpenIeSwAC54wj6TVGc9cIiqrKER1RR1uiukx5Kxt+JA6hmOmPUBxv3kPZfXCstLQ=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8c31d4-d187-4e96-a664-08d70c9e2f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 23:09:43.1726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2624
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > It's a universal keyed hash. Which you could use as a MAC, although, ad=
mittedly,
> > it would be rather weak, which is why the tag is usually additionally e=
ncrypted.
> > (which you could do externally, knowing that that's needed with GHASH)
> > In any case, the crypto API's ghash does not do what you would expect o=
f a GHASH.
>=20
> Well you could also use CRC-32 "as a MAC".  That doesn't actually make it=
 a MAC.
>=20
For one thing, CRC-32 is not keyed so I don't see how you would use it as a=
 MAC?
It's also not a cryptographic hash function as the output is biased.

And it's true GHASH by itself is not a good MAC as you can recover the key,=
 but
that is easily solved by encrypting the tag with a one-time pad. Which, adm=
ittedly,
is not included in the GHASH definition itself, which makes it rather oddba=
ll as it
is also not a cryptographic hash function if the key is known.

Then again, does it have to be? You just mentioned CRC-32 being supported b=
y
the crypto API, which is also not a cryptographic construct ...

> > I guess my constructive suggestion *for the future* would be to be more=
 careful
> > with the naming. Don't give something a "known" name if it does not com=
ply with
> > the matching specification. Renaming stuff now is probably counter-prod=
uctive,
> > but putting some remarks somewhere (near the actual test vectors may wo=
rk?)
> > about implementation x not actually being known entity X would be nice.
> > (Or even just some reference on where the test vectors came from!)
> >
>=20
> I think a comment at the top of ghash-generic.c would be helpful, similar=
 to the
> one I wrote in nhpoly1305.c explaining that particular algorithm.
>=20
That sounds good as well. Although that would be the very last place I woul=
d
(and did) look.

> I'm surprised that you spent "days" debugging this, though.  Since the AP=
I gives
> you a single data stream, surely you would have had to check at some poin=
t how
> the two formal arguments (AAD, ciphertext) were encoded into it?  Were yo=
u just
> passing the whole thing as the AAD or something? =20
>
Well, I had 2 possibilities: either everything was AAD or everything was ci=
phertext
and neither got matching results ... and then you go off into trying variou=
s byte=20
orders (9 our of 10 times it's just some endianess issue) and investigating=
 potential
bugs or limitations with the hardware itself. Of course this being crypto (=
and worse:=20
only getting a tag out of the hardware at the very end)  there's not a whol=
e lot of=20
information to work with. Basically only pass or fail. So yes, you quickly =
end up=20
wasting a lot of time.
I was NOT expecting ghash not to be GHASH as I know it, so it really was th=
e last=20
place to look.

> Also to reiterate, it actually
> does implement the GHASH algorithm correctly; the two formal parameters j=
ust
> have to be encoded into the single data stream in a particular way.
>=20
I was about to make a remark stating that that's like saying a simple block=
 XOR=20
actually does implement AES counter mode (or ARC4 or Chacha20 or other rand=
om=20
stream cipher) correctly as long as you generate the key stream data block =
in a=20
particular way ...

And then I came across a 2007 NIST specification that defines GHASH exactly=
 as it's=20
implemented here, namely with all the formatting left out, just GHASH(K, X)=
.
I've always known GHASH the way Wikipedia defines it (which comes from the
original 2005 spec by McGrew and Viega), and that's also how our hardware=20
implements it (i.e. it cannot do GHASH without the padding and  the appende=
d=20
length word), but apparently there are different opinions out  there ... so=
 I stand=20
corrected?!

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
