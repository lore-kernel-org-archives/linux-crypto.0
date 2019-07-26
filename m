Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72119C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 21:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EC3D229F3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 21:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="mlv6nO+B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfGZVnT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 17:43:19 -0400
Received: from mail-eopbgr680049.outbound.protection.outlook.com ([40.107.68.49]:63382
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727934AbfGZVnT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 17:43:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ixm93IiYgPRzbg73PTAqFX/nvkJsByeMEXr0+3Fog/YYaCOU564+apwxfhT2FVXJA4lDP1AiyDLbKGjNalaUIgWr8aDiIsLwHwuBmmyx34X55BrChZXrdz1MNF83klwdmYm3ZqrYOAsQe655eDhg05P5ZsYV2nx84FCy5PdCLIKjL22gFwEiIVAInnMA3Z2kM2+6tASxKwVcAAZV23PkqbVz3TO+3kdzBgLOARuso4PdfGG0Vxw9gqAEKqdWKtZ/w5SLic1yWIFZOCNmE/QwnWam4DGokt8b/ti622cLuxe80Wlr/1bUyWohYml9uMBVQ+3cXPMg2ioQA7oZQGRc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2LwHDgOo+QVSkS1mFclhpiStrHhEJBsEmk7FZ1Qs9M=;
 b=TD8SBL4JNs8SaUpbibdnWKhqNAC8qi1o4b8FxLCl1eM1xYJEZ5M6AYhslO6DMOxyvZE6Me8wH0nNa3qS0jG1KAVXwrXkwidDvd9T15TuKWYFBlcnOhD9XHfirIwMhAV64m8M2fFOrB6PolqZBGqKBYYSNBiPjuCTeUrbFnP5vK33ytaj6/e5mFXzAGFJlb/kZ/bywN13EDfXU4d/qpubdkDesj9tc2n1dVMEnLZY2Z7GJr3PV4Hzhgu7wJhzrmQrHihvg5VRbROq5zENXEdQlmRPK86Rx3v1R6yrJMkIDeo6m826+RRQAHNYIhQiloP8RQ0qZ/aF8cThhVYQZz2ozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2LwHDgOo+QVSkS1mFclhpiStrHhEJBsEmk7FZ1Qs9M=;
 b=mlv6nO+BYaYY690KSAVfmme7RC0q/4s4kXzfe79gfIest+vSwHsC/o2Hbu0ob8RHn+WdI8GII8vyyiwOe3p2r3rydJWRExQX0iSyfc0MSEFLlKOUgQzhQWJqljRHI5dt4DFur03pTDWAd0vHivYJ8PcLRi1D7lFRqdAGknbds1U=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3151.namprd20.prod.outlook.com (52.132.174.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 21:43:15 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 21:43:15 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbde3tw
Date:   Fri, 26 Jul 2019 21:43:15 +0000
Message-ID: <MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
 <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
 <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 240da9a0-f306-4dd9-c02a-08d7121243ef
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3151;
x-ms-traffictypediagnostic: MN2PR20MB3151:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3151B61584463C456B23AD13CAC00@MN2PR20MB3151.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39840400004)(366004)(376002)(346002)(396003)(189003)(199004)(13464003)(52536014)(6116002)(446003)(6436002)(3846002)(66946007)(86362001)(5660300002)(76116006)(66446008)(64756008)(66556008)(66476007)(76176011)(6506007)(53546011)(102836004)(7696005)(11346002)(2906002)(229853002)(478600001)(14454004)(14444005)(305945005)(256004)(476003)(8936002)(7736002)(9686003)(71190400001)(71200400001)(68736007)(99286004)(81156014)(8676002)(55016002)(110136005)(54906003)(316002)(81166006)(74316002)(6246003)(15974865002)(186003)(66066001)(4326008)(33656002)(53936002)(26005)(486006)(25786009)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3151;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AK28QrHKKCkOxtqc9kfbYuanZapLXSRiDCm1eW1j/5yHlLX88KuCZflJOLHPTZmKzcMuW0ClPyEXM+NAcTvFNeaJXmwZFwP9lWM17Ry191I94ZeVTjSX3EvOA9rEzh78Ix6kIt//Zsm/d8AYqqAjL3gPR14oBxRjiEatDWkuNZxt0n8aqmOFlOB0xT4X4UTG7FWeoireuuio3M7EO4Crh9sz8lIPLTlxG/JstkQIVcdrapAuVrQvyLFypAPZem1V8/LWChvt69prAY2iyW0vNzmLX2DWRIDfudhYUXQKnpfjOBhhZXMAldXiBF72x3QHiZzuSFU0XLjeIujSKfZCa4cEIc4AxzwcTLyKm4Tplv7M52kY4nacp5yUAHFNn0B6Xr9NNdMGFMow5xfy3XAioA24ib2CdBqb/yDDYIxWGzU=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240da9a0-f306-4dd9-c02a-08d7121243ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 21:43:15.3742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3151
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Horia Geanta <horia.geanta@nxp.com>
> Sent: Friday, July 26, 2019 9:59 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel <ard.=
biesheuvel@linaro.org>
> Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.or=
g.au>; dm-devel@redhat.com; linux-
> crypto@vger.kernel.org
> Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing =
support
>=20
> On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
> > Ok, find below a patch file that adds your vectors from the specificati=
on
> > plus my set of additional vectors covering all CTS alignments combined
> > with the block sizes you desired. Please note though that these vectors
> > are from our in-house home-grown model so no warranties.
> I've checked the test vectors against caam (HW + driver).
>=20
> Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18")
> are fine.
>=20
> caam complains when /* Additional vectors to increase CTS coverage */
> section starts:
> alg: skcipher: xts-aes-caam encryption test failed (wrong result) on test=
 vector 9, cfg=3D"in-place"
>=20
> (Unfortunately it seems that testmgr lost the capability of dumping
> the incorrect output.)
>=20
> IMO we can't rely on test vectors if they are not taken
> straight out of a spec, or cross-checked with other implementations.
>=20

First off, I fully agree with your statement, which is why I did not post t=
his as a straight
patch. The problem is that specification vectors usually (or actuaclly, alw=
ays) don't cover
all the relevant corner cases needed for verification. And "reference" impl=
ementations=20
by academics are usually shady at best as well.

In this particular case, the reference vectors only cover 5 out of 16 possi=
ble alignment
cases and the current situation proves that this is not sufficient. As we h=
ave 2 imple-
mentations (or actually more, if you count the models used for vector gener=
ation)
that are considered to be correct that disagree on results.

Which is very interesting, because which one is correct? I know that our mo=
del and
hardware implementation were independently developed (by 2 different engine=
ers)
from the IEEE spec and match on results. And our hardware has been used "ou=
t in
the field" for many years already in disk controllers from major silicon ve=
ndors.
But that's still not a guarantee .... So how do we resolve this? Majority v=
ote? ;-)

> Horia
>=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

