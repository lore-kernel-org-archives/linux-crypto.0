Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2F2C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 14:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DF462171F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 14:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="a72NAgqw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406412AbfHIOSb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 10:18:31 -0400
Received: from mail-eopbgr780088.outbound.protection.outlook.com ([40.107.78.88]:12153
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbfHIOSb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 10:18:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rm/aU9Z+Z6bKq2xwZOAKFFyEb53PpnWA2GDkbNgRhtAIq/Tqq//EJH8fldMjw31jt1W9okGTAldIUeCAC+4woFWYXJ7KFhJPhhLFPpDbRCgkg1YUPGNDb/C7/WHYNIW7IN5szkUlawF/0ZfXk+8XRrJRzovLAjJr6PNc64XqPE+JXDSVw8xhcqWAn+VPcsQ4OW+oWdfq4MhnbeltlDRB2bEzsq+VgQROTl2ckvZiA8Uw95muPgSG6R8x4Q+l/6zzTxWb474QybzpAQH6Vuo3HlFY4TyyqYi2rMocI7UnbrSjqjBzlPzs3VLL9Vu9vEGJkUThr9FOgaLcG/NACbdqTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0t0K+IswDg5i3UEXAEPxjGUZlU/BrNEbXpm7GOdRyKY=;
 b=WcF8hiABpsnBDgyWNcp861bFiv9KOOg+/be6KkheIlUhpk1u+kGrLPd9/G3RKrpLLdOJCqxRyFspueex6FhwvTrark5WUpo+Bymsh0uvfKYd9OwWlDsSDGcCSNtUz2gJ6a8zrSCkIiIbjFDHCcp2W2Gx4dKpvzOr/nQhCSoY/ze/57l9I4TaXqqemCb2KIR/8JT4aVtw2c1OPe4z4rRNeMyd/RfYqn5zHcTg0U21ZLV1VUd+LeKq0aVnizTvcYoSfaxtywJPqJUcG32W1jautDsrKSqIzACPU0sPRiSpAjI+bWpcvTHDhf2DnfLSYr1PGCPywxRA1BDD3N8IMwjSvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0t0K+IswDg5i3UEXAEPxjGUZlU/BrNEbXpm7GOdRyKY=;
 b=a72NAgqwYR000emjhSxplssOISB2+49fpsdABLQ+NmSprkt2bTpETiLeQ4FlzauH3UcfR+YtZtGclw32gysavACOOovYH2dVKgKzrLNDwc61J7vQ14i3UdiHyZ0AlsTCp/7+SiKMn7gaBJCtqgT1yja0iUs2Yz0A9ZOQBUHIqMA=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3086.namprd20.prod.outlook.com (52.132.174.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 9 Aug 2019 14:18:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 14:18:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Subject: RE: XTS template wrapping question
Thread-Topic: XTS template wrapping question
Thread-Index: AdVOpvQVifejpBWTRVyvNwtV/QL5zQABu5aQ
Date:   Fri, 9 Aug 2019 14:18:26 +0000
Message-ID: <MN2PR20MB29737E7D905FE0B9D3CE3A68CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcc62e9b-19a5-46f1-8c35-08d71cd471ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3086;
x-ms-traffictypediagnostic: MN2PR20MB3086:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3086AEB4D322AF9AD41D0FA5CAD60@MN2PR20MB3086.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(366004)(376002)(396003)(136003)(199004)(189003)(13464003)(9686003)(2906002)(7696005)(81166006)(110136005)(66066001)(66946007)(476003)(81156014)(8936002)(11346002)(15974865002)(3480700005)(52536014)(305945005)(2501003)(8676002)(102836004)(446003)(55016002)(33656002)(7736002)(53936002)(66446008)(2940100002)(86362001)(14454004)(6436002)(74316002)(26005)(3846002)(66476007)(256004)(229853002)(6246003)(64756008)(478600001)(71190400001)(186003)(99286004)(71200400001)(53546011)(6116002)(5660300002)(76176011)(6506007)(76116006)(316002)(486006)(66556008)(25786009)(2201001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3086;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0UV9z0qcebviyAgbEdzqN0OvY+OG2l0dPYqLfRqtG1yyD9VYAEumoa1zvBZQxyzgrJ4sw5hD41mMBOyoCWO8bA52MaS/2KytHW4RsKVCPxej2q7Z/njdvWCrbQx+Jy+OYdLll5r+yqVgdwyIqEgfYtxFtcaFD91QESzXwuwwYseugmjRfRU+qjmrUv08QFzuIUZrxAy1iBs/cmUf6o3MKw7NS99kTboo7q93Pb4a6pLnieVfRSCWs32XWEPfeAFYbZdfg9zDUpH1Kqwv8jZIZSL4BKZNdI/dl7Tlu/60jbXKagmVs5Rmaa0wV/mOKEgRU+/sklWNBEHIujF+pvRcixh0JSuogvjzLC5TsKM2MW1fARjyd5LXjdSa7f+Ex0yOM5LkvpgtQAbpJGRW+ESkX8a0Xgj6CPTghcI6buljJDk=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc62e9b-19a5-46f1-8c35-08d71cd471ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 14:18:26.1162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1QPv4V0QAt1Yl1xWnLV9WmwtmPfZNGhGewf/CZkzrD838JuyYWiPjMXxFNc7fGx2RaPmlW0Fu3Zlt97RZAB0fuJYv6aorOlA7d/HDYqLO34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3086
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Friday, August 9, 2019 1:39 PM
> To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net; Eric
> Biggers <ebiggers@kernel.org>
> Subject: XTS template wrapping question
>=20
> Herbert, Eric,
>=20
> While working on the XTS template, I noticed that it is being used
> (e.g. from testmgr, but also when explictly exported from other drivers)
> as e.g. "xts(aes)", with the generic driver actually being
> "xts(ecb(aes-generic))".
>=20
> While what I would expect would be "xts(ecb(aes))", the reason being
> that plain "aes" is defined as a single block cipher while the XTS
> template actually efficiently wraps an skcipher (like ecb(aes)).
> The generic driver reference actually proves this point.
>=20
> The problem with XTS being used without the ecb template in between,
> is that hardware accelerators will typically advertise an ecb(aes)
> skcipher and the current approach makes it impossible to leverage
> that for XTS (while the XTS template *could* actually do that
> efficiently, from what I understand from the code ...).
> Advertising a single block "aes" cipher from a hardware accelerator
> unfortunately defeats the purpose of acceleration.
>=20
> I also wonder what happens if aes-generic is the only AES
> implementation available? How would the crypto API know it needs to
> do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
> (And I don't see how xts(aes) would work directly, considering
> that only seems to handle single cipher blocks? Or ... will
> the crypto API actually wrap some multi-block skcipher thing
> around the single block cipher instance automatically??)
>=20
Actually, the above was based on observations from testmgr, which
doesn't seem to test xts(safexcel-ecb-aes) even though I gave that
a very high .cra_priority as well as that what is advertised under=20
/proc/crypto, which does not include such a thing either.

However, playing with tcrypt mode=3D600 shows some interesting=20
results:

WITHOUT the inside-secure driver loaded, both LRW encrypt and
decrypt run on top of ecb-aes-aesni as you would expect.
Both xts encrypt and decrypt give a "failed to load transform"=20
with an error code of -80. Strange ... -80 =3D ELIBBAD??
(Do note that the selftest of xts(aes) using xts-aesni worked=20
just fine according to /proc/crypto!)

WITH the inside-secure driver loaded, NOT advertising xts(aes)
itself and everything at cra_priority of 300: same (expected).

WITH the inside-secure driver loaded, NOT advertising xts(aes)
itself and everything safexcel at cra_priority of 2000:
LRW decrypt now runs on top of safexcel-ecb-aes, but LRW
encrypt now runs on top of aes-generic? This makes no sense as
the encrypt datapath structure is the same as for decrypt so
it should run just fine on top of safexcel-ecb-aes. And besides
that, why drop from aesni all the way down to aes-generic??
xts encrypt and decrypt still give the -80 error, while you
would expect that to now run using the xts wrapper around
safexcel-ecb-aes (but no way to tell if that's happening).

WITH the inside-secure driver loaded, advertising xts(aes)
itself and everything at cra_priority of 2000:=20
still the same LRW assymmetry as mentioned above, but
xts encrypt and decrypt now work fine using safexcel-aes-xts

Conclusions from the above:

- There's something fishy with the selection of the underlying
  AES cipher for LRW encrypt (but not for LRW decrypt).
- xts-aes-aesni (and the xts.c wrapper?) appear(s) broken in=20
  some way not detected by testmgr but affecting tcrypt use,
  while the inside-secure driver's local xts works just fine

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
