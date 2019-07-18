Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFC3C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 15:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BEF208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 15:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="pzSc8Q72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfGRPnd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 11:43:33 -0400
Received: from mail-eopbgr680083.outbound.protection.outlook.com ([40.107.68.83]:40744
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbfGRPnd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 11:43:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOItQnPw1B7dLzXhdEOtn/G1Vrzwqr+XJPVmV2NkgSNiumXfM957BYOqDYP+QQDOMuwMNiEYUhqGeKZoHqFtzPXpc5GgloS6ciYhjvLyO3Q2xxwxXNRmeXvdavmCAZ5T1rTch6RxuoRNsCFEMX01oZRtvB2YdAzTZLtM5LWbASk/DO/5Sq5CmSA9Rzyh0bnaMVieF2bOIzivu22RHVG6SLcGxrV/RZuX4LpZoknRsiJ6r3y/xfAQgppc4I8aKFOlQd5o9YcCYK3kgVn7of9H99yfTzOzi45jlssXdW9uYhAWpp5m4LqjJ0RyTYpg+Wmu3cPdWENbsmg/vvX2hNNbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV9vtRYK0Sh7ifr6sfLSYIjr4qRCgYCMeFcgNtl0+CE=;
 b=MbnlucxZbAUSRTbF8LVRpjoXX+O0QuZZNLQ4g6SS4DrmLuHJ/6KWzoLpzcjnmkOgRNMwLYxyN0AoyyTUrPYQsdiGcDjC9p3FCxU6YOLVn9IM/WzVnd8dLAwnL0djT0loYqBTRMfyNBYZXn6I1GfQbUhyfsOOvj5wdhCCJ2KQqqoPOtGpbGI+/XM0eC5532jAKtSIWbKc6y1HnuB2lUR5VaJcv/pN/edpRjU5ghuGiRpGElB58yVB1O6do9ESl/bN0xjmsm12MqLtEecaKprIed2rDsaTPntf+enXMiQ2HsDly16+rlvd8CMqAhIKZaMSwgrz6GToG95jJp9VePQ/mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV9vtRYK0Sh7ifr6sfLSYIjr4qRCgYCMeFcgNtl0+CE=;
 b=pzSc8Q72bIyjGsq0I7hM/S54XXIa7sNETH3+gG7f3+KPQ+z0rDLS94VgYkBvRndcBCTkLtKCUF7Sf01M2jRdBV0FXj6qwco8190WW3FoHuRlCBPKAr2BuPlakNgyuFaqElM/uOTTXIQmgjz+czAMA5996ABwDfxPREWPEwlOJDE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2477.namprd20.prod.outlook.com (20.179.147.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Thu, 18 Jul 2019 15:43:28 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 15:43:28 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: xts fuzz testing and lack of ciphertext stealing support
Thread-Topic: xts fuzz testing and lack of ciphertext stealing support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgABt8gCAAADKkA==
Date:   Thu, 18 Jul 2019 15:43:28 +0000
Message-ID: <MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
In-Reply-To: <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56b2faf2-01bd-4ac2-3112-08d70b96adb7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2477;
x-ms-traffictypediagnostic: MN2PR20MB2477:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB24772323BFBA19755CEE626FCAC80@MN2PR20MB2477.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(39850400004)(136003)(199004)(189003)(316002)(55016002)(9686003)(3846002)(6916009)(4326008)(2906002)(107886003)(5660300002)(6246003)(6306002)(6116002)(966005)(52536014)(66066001)(305945005)(486006)(446003)(53936002)(11346002)(229853002)(99286004)(6436002)(15974865002)(54906003)(66476007)(71200400001)(71190400001)(66446008)(64756008)(66946007)(66556008)(76116006)(8676002)(68736007)(76176011)(186003)(86362001)(8936002)(26005)(256004)(7696005)(102836004)(81156014)(7736002)(74316002)(476003)(81166006)(14454004)(25786009)(6506007)(478600001)(33656002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2477;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tHt/JkS1QillPyNdVqvqlYU2WbEYQN16D3EI3yesa9+GA2WsIayOcZI7VQGPJe6v16cC9K5YDFkIN5vNo+9wYkZXUkijZjdfXf8lIT+5HHHy3g3V3f1Hn6FErY5uZ/XL7uo/Kf0pj6ccyxlRwszuS4O2ODuo3qObGt4kg3lyqo0JGoXigkV7b+nqdQug3W81s65b+eSsSEedBwmmelQvONz858hOxJmOxsw7dpzCVF1Q0RJWsBYf42Um6xlJS08h5+AJ3GHZL4s26Szt1mQ6N/psJt100cYkg4tGAfzsI/GU/HH1JCFxg03SFfbI+GWyQclKag7xJ5d6NZgzsoqUSaopsvwStfsJKT4t4BF4iuSBZ7xoeza3B2THCn3ErYgYmC2yXeEXO+5adtIKX/kq60nkX1wjtDYFifAADsy3q84=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b2faf2-01bd-4ac2-3112-08d70b96adb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 15:43:28.2729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2477
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > In fact, using the current cts template around the current xts template=
 actually does NOT
> > implement standards compliant XTS at all, as the CTS *implementation* f=
or XTS is
> > different from the one for CBC as implemented by the current CTS templa=
te.
>=20
> The template is just a name.  The implementation can do whatever it
> wants for each instance.  So obviously we would employ a different
> implementation for xts compared to cbc.
>
Hmmm ... so the generic CTS template would have to figure out whether it is=
 wrapped=20
around ECB, CBC, XTS or whatever and then adjust to that?

For ECB and CBC I suppose that's techically possible. But then what do I ge=
t when I
try to wrap CTS around some block cipher mode it doesn't recognise? Tricky =
...

For XTS, you have this additional curve ball being thrown in called the "tw=
eak".
For encryption, the underlying "xts" would need to be able to chain the twe=
ak,
from what I've seen of the source the implementation cannot do that.

For decryption, you actually first need to decrypt the last block with the =
last
tweak before you can decrypt the 2nd last block with the 2nd last tweak.

Not sure how you intend to handle that with some generic wrapper around "xt=
s".

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
