Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C75FC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 22:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 243A321852
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 22:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="CYuGVSgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbfGZWYt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 18:24:49 -0400
Received: from mail-eopbgr720047.outbound.protection.outlook.com ([40.107.72.47]:24985
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387400AbfGZWYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 18:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0LaWXfXpJtj4Gf4m8qHeDg4zmakqsMFy/xQ/ZdpKuIkc1qjGx4TVafy6yaGb+scqGXb+tMjxMjld1xfS8ok+QsyxiddMo+LJJwVcXqvpn3vAj2u8eMzGfVYrhLS5K9kif66Ebibes99Epf9Ucq8k+qe+k0ZjDD5MT3Q+EekJ+A6FEZobw/uzcJD/AOJrWLrx5KYoDwjGetnHNJp+gciPccPQ+ZptEpYVincH8Q2SEMVyXX4zAEf3p5fLCzI01rwKC0xnWld2zqlEV0xTTrfWv0kYdqnPXSw9nL2lgWWXKK0uSFzV7ZSrRujKAPfSUkClcQT96rSdnyIagluxdTfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYUGlgSbJUggxSopEp4eR0lrBrTK2j/xj8CG5AGtew8=;
 b=DIxCGNNByTirjm3sbmlQO7xAQVcK2Q3Um9o6ou4vT+Ts4iMTapmValmqT0CywdC292vp0x5ItkXQ680gU45HTkxgwE/Uv9Uu0TIShDJ1k9NswknLeRWXNW1E65ihBp85yyFauRcdAvKUnih7CFr9JWwTiJi1OcOgeisnH3lJ+mWXpuqdwzkQpk4EF5xh2cMoDaljGJCMgyQDJiGeqyu9qON0mE7z2luqRicshqtRMyrFd5Gn+JjagZb2PK3czpaBxVOksWb9Pp6FTbj7tuecpxlFzDI8M5Vo3QgT/wl+0Eaf78UYpS04v0J9pkPRwmrRYagNzOMiDMYEWQXowHfF5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYUGlgSbJUggxSopEp4eR0lrBrTK2j/xj8CG5AGtew8=;
 b=CYuGVSguuyIq2lQKiFsnspgaMABVghCrbopLX9APnSo7ERAzVV/7l8nnGzSImYw7uj+Tjq3RY9GKKDqO84Vl4iRXaZYMHJdSB4FjC/naGlxe8iffI2v/tah8BRQfmwVrd6IU2HE07WNaSbYxAph7mo8bSKFbN9ef8Jk+xMk/Hho=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3119.namprd20.prod.outlook.com (52.132.174.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 22:24:05 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 22:24:05 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mhl@iki.fi" <mhl@iki.fi>
Subject: RE: gcm.c question regarding the rfc4106 cipher suite
Thread-Topic: gcm.c question regarding the rfc4106 cipher suite
Thread-Index: AdVDye9KM2tcbGm7SBqcTnCLF/Sp0QANXztw
Date:   Fri, 26 Jul 2019 22:24:05 +0000
Message-ID: <MN2PR20MB297389290059B35D4025182CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29732701865BDB3860142CD1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485F5C63904F1E87F5193E998C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485F5C63904F1E87F5193E998C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d044016-08a9-43e6-bd1c-08d71217f843
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3119;
x-ms-traffictypediagnostic: MN2PR20MB3119:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB31191B6FA726479130A3FBD2CAC00@MN2PR20MB3119.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(366004)(39840400004)(189003)(199004)(129404003)(13464003)(2906002)(7696005)(102836004)(55016002)(14454004)(76116006)(86362001)(3846002)(99286004)(71190400001)(26005)(8936002)(6436002)(66066001)(6246003)(52536014)(71200400001)(68736007)(66476007)(64756008)(76176011)(66946007)(66446008)(6506007)(66556008)(81156014)(2501003)(81166006)(7736002)(54906003)(9686003)(305945005)(8676002)(110136005)(186003)(229853002)(316002)(53546011)(25786009)(486006)(74316002)(4326008)(478600001)(5660300002)(476003)(14444005)(256004)(53936002)(6116002)(33656002)(446003)(15974865002)(11346002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3119;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e9xUkhAQ2Z14DawrARnapbgN65MEgQf6i1elUHUHKO6X4E1OsiovO+9ZgqandOGEfj9VvItbkJ2CuMDGyR3BT+cMcsvL+HydVzmQBXBww2p4sLuH4eb+0OQcGf0wHc3XTyHwbG4eWK4zgv4B/mYOysXO1Cq2bnMckcmK6bqo+5SJ7BDwYrjq43TUNGV2UfY8t93O57KvCHy/7DyXjPHchfguSlMV44BDv4rtxA7OaQXUd97nzo8ieoSg5I7ZRZ+kvWW+odZ0pRADNiVdW2iLSCdWYMgjtvfMwXUIYHFL5iBJ6vvYjRf1HpO7lnEHVLtPhhKAD1JutVIJMsF23Up7hjYLsQ2pvRDLP65bXvOmezcirEzxgd8BuLMDgMDeNRjRJ72peMz6RhMk1eScTVrTQk5XQ1YPkW6UJsJqixTB3f8=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d044016-08a9-43e6-bd1c-08d71217f843
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 22:24:05.3741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3119
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Horia Geanta <horia.geanta@nxp.com>
> Sent: Friday, July 26, 2019 9:17 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; linux-crypto@vger.ke=
rnel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; davem@davemloft.net; mhl@ik=
i.fi
> Subject: Re: gcm.c question regarding the rfc4106 cipher suite
>=20
> On 7/26/2019 6:55 PM, Pascal Van Leeuwen wrote:
> > Hi,
> >
> > I recently watched some patches fly by fixing issues in other drivers r=
egarding the checking
> > of supposedly illegal AAD sizes - i.e. to match the generic implementat=
ion there.
> > I followed that with some interest as I'm about to implement this for t=
he inside-secure
> > driver.
> >
> > And something puzzles me. These patches, as well as the generic driver,=
 seem to expect
> > AAD lengths of 16 and 20. But to the best of my knowledge, and accordin=
g to the actual
> > RFC, the AAD data for GCM for ESP is only 8 or 12 bytes, namely only SP=
I + sequence nr.
> >
> > The IV is NOT part of the AAD according to the RFC. It's inserted in th=
e encapsulated
> > output but it's neither encrypted nor authenticated. (It doesn't need t=
o be as it's
> > already authenticated implicitly as its used to generate the ciphertext=
. Note that GMAC
> > (rfc4543) *does* have to authenticate the IV for this reason. But GCM d=
oesn't ...)
> >
> > So is this a bug or just some weird alternative way of providing the IV=
 to the cipher?
> > (beyond the usual req->iv)
> >
> Try to track the aead assoclen and cryptlen values starting from IPsec ES=
P
> (say net/ipv4/esp4.c) level.
> At this point IV length is part of cryptlen.
>=20
> When crypto API is called, for e.g. seqiv(rfc4106(gcm(aes))), IV length
> accounting changes from cryptlen to assoclen.
>=20
> In crypto/seqiv.c, seqiv_aead_encrypt():
>         aead_request_set_crypt(subreq, req->dst, req->dst,
>                                req->cryptlen - ivsize, info);
>         aead_request_set_ad(subreq, req->assoclen + ivsize);
> thus the subrequest - rfc4106(gcm(aes)) - has to check for a 16 / 20-byte=
 AAD.
>=20
> Hope this helps,
>
Yes and no. So it's what the ESP implementation expects but that stil doesn=
't
tell me whether the IV is authenticated or not. Although if the ESP impleme=
ntation
actually interoperates with anything, I would have to assume that it doesn'=
t.
I tried reverse engineering gcm.c, but I find the code difficult to follow.=
 It looks
like it's actually *inserting* the IV there (from ctx->nonce and req->iv) b=
ut indeed=20
not authenticating it? Not sure though.

> Horia

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

