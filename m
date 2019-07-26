Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBB9C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAE7122BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="lor450xo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfGZN2R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:28:17 -0400
Received: from mail-eopbgr810084.outbound.protection.outlook.com ([40.107.81.84]:23588
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfGZN2R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:28:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwHIziTeUda/ei6i4TUqWKa+6nWd2MYD0HYCnhG97dv42TdIjpnMsUPFAdWfWY0kN2BamPYhDXq7TFPumqdVjviYHXN+x9qHYQ2bcjEkL582RqRmlnYZ7U3MnRgP17xx+zlJPg+Rt6ozItu+vb5wbr+/Vuvx6NSrqkTd8WS98ILvMdV64XlOuOqVbHBpNmoyFtJwo06jD2UuEG1FZ6M6wua3Pxy1rb+2j1hvGsEnI4mZWQzBUcrgrhsfdoQtbX52+jurTkRaITbP1FKE8bAcnmvGPy6ARXx0wk8i63c0G3O8ae+KO6oSouSpzSV2T+uNYnMvd11IL0NgeQoCJ8rqag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knglYcB1VLdBOfE+0iusUC3ue+g8RGz2QdKRn3mwU5s=;
 b=BR8aycCkYnhl0TTvw59BKmJQsAMQj3ykCHo0lROk5uP7nyhpfrgXEAJEWb3vHD2Cwkq6ZcimZNzithOuxxq6y4tw69zqJHIWm/deUNDJpcNOVP66QIdCwNm0HhDiJp5f5d2enE/Gv2+RxcaxhsVJNoMwA2q+CyNYHlsaDIKi5uVF/cXNn+dw0Sa7/R89o3LFRMNjKMBvd2l8hm6kKUvF12nP/aJSH2euqt7MnhrkedfBfQ6sMQ54s5zssnbaOjcOkFDP9wUEmkieJHh+QXdXitUjaaC6zW4C/+5DB1Zic/Wi7nt68X3F+jSTzubIxceDlxW3sair47L2Zs7C5TovgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knglYcB1VLdBOfE+0iusUC3ue+g8RGz2QdKRn3mwU5s=;
 b=lor450xoOyzTps3ONbgUEEaO6iT6GdTdL4e+5xbhIrqqd00zbsS3PdUsMWPxnYy4nfjk67FW8Vv7adNRXCRybEyPFX93Q9A0RguPfLWGFAOzOjyqsJjwdyUw2eC6YRwIREhRFHZxqge3QqIf+bIsbAwixC3U9Pvy2VyRufaz0XU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2590.namprd20.prod.outlook.com (20.178.250.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Fri, 26 Jul 2019 13:28:13 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 13:28:13 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Thread-Topic: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Thread-Index: AQHVMwaydQ+3aJIWekiqcp1KNvSggKbc9n6AgAAHURA=
Date:   Fri, 26 Jul 2019 13:28:13 +0000
Message-ID: <MN2PR20MB2973C6D05EED9B878D2EC4B9CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726123305.GD3235@kwain>
In-Reply-To: <20190726123305.GD3235@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc3e8bd0-bff5-4d49-227d-08d711cd1c21
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2590;
x-ms-traffictypediagnostic: MN2PR20MB2590:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2590BAD2CB4E2C82329C3661CAC00@MN2PR20MB2590.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(376002)(346002)(39850400004)(189003)(199004)(966005)(25786009)(9686003)(2906002)(55016002)(316002)(6246003)(76176011)(6306002)(53936002)(71190400001)(7696005)(71200400001)(76116006)(229853002)(66066001)(4326008)(74316002)(66946007)(64756008)(66556008)(66446008)(86362001)(33656002)(8676002)(3846002)(7736002)(99286004)(8936002)(6506007)(6116002)(102836004)(54906003)(256004)(110136005)(476003)(486006)(68736007)(15974865002)(52536014)(11346002)(446003)(66574012)(5660300002)(14454004)(6436002)(81156014)(478600001)(186003)(26005)(66476007)(305945005)(81166006)(14444005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2590;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0sK+2I2Qg5uTklxrcBUIAEoEgE/U9DdCPGQFNWzncaWX8gtWQ/VGcIWsQ+kQPwTiOpHG4iJHcFU9bKqXJxv+SXfdyHHCL9ikgYm5sRv/fuc6wvE9Kq/BWsx0zQDlhdDr3O3c9ZXRno/UKl2HntxJKe5T5hRYtVPAscOL0BtdDPiuoOj9XsOnwl0GBShC98+oOthRYSd7w3Fr8tat6p9O+lNQWFo1/K7WinlsVXff6ZJvTxX2p3B04x8R/pE03rRqqqbbhPEP17CBI0Y1XygYhFPcT/yg0RY8MC4Qmvju+RZjhSAPKbnFSMgiu0UpT5xNJy4wg+2H0F+rY3Jnatvs7h5tLb+anZads2c50UXs0CzO4r7QKC8qG0toBX6dgykwihc1B+RDilRNGanAQoXnHr5oZiYPLnQrq6wY8VCd6AY=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3e8bd0-bff5-4d49-227d-08d711cd1c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 13:28:13.0747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2590
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Antoine,

> Hi Pascal,
>=20
> On Fri, Jul 05, 2019 at 08:49:23AM +0200, Pascal van Leeuwen wrote:
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
>=20
> Could you add a commit message?
>=20
I can do that. Just didn't know it was really needed.

> > -		/* H/W capabilities selection */
> > -		val =3D EIP197_FUNCTION_RSVD;
> > -		val |=3D EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
> > -		val |=3D EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT=
;
> > -		val |=3D EIP197_ALG_DES_ECB | EIP197_ALG_DES_CBC;
> > -		val |=3D EIP197_ALG_3DES_ECB | EIP197_ALG_3DES_CBC;
> > -		val |=3D EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
> > -		val |=3D EIP197_ALG_MD5 | EIP197_ALG_HMAC_MD5;
> > -		val |=3D EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
> > -		val |=3D EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
> > -		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
> > +		/* H/W capabilities selection: just enable everything */
> > +		writel(EIP197_FUNCTION_ALL,
> > +		       EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
>=20
> This should be in a separate patch.
>
It was added specifically to  get this functionality working as CTR mode wa=
s not
enabled.  So I don't see why it should be a seperate patch, really?
Instead of adding CTR mode to the list (which would have been perfectly val=
id
in this context anyway), I just chose to enable everything instead.

> I'm also not sure about it, as
> controlling exactly what algs are enabled in the h/w could prevent
> misconfiguration issues in the control descriptors.
>=20
That's not really what it's supposed to be used for. It's supposed to be us=
ed for
disabling algorithms the application is not ALLOWED to use e.g. because the=
y are
not deemed secure enough (in case you have to comply, with,  say, FIPS or s=
o).

As for misconfiguration: you may just as well hit another enabled algorithm=
, the
odds of which will increase as I add more. And I'm very busy adding ALL of =
them,
by which time you wouldn't want to disable any anyway.

> > @@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct safexcel_c=
ipher_ctx *ctx, u8 *iv,
> >  				    u32 length)
> > -	if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> > +	if (ctx->mode !=3D CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
>=20
> I think it's better for maintenance and readability to have something
> like:
>=20
>   if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC ||
>       ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD)
>=20
Not really. I *really* want to execute that for any mode other than ECB,
ECB being the *only* mode that does not require an IV (which I know
for a fact, being the architect and all :-).
And I don't believe a long list of modes that *do* require an IV would=20
be  more readable or easy to maintain than this single compare ...

> > +struct safexcel_alg_template safexcel_alg_ctr_aes =3D {
> > +	.type =3D SAFEXCEL_ALG_TYPE_SKCIPHER,
>=20
> Same comment as in patch 1 about the .engines member of the struct.
>=20
Same answer: depends on the disappearing patch I will resend shortly.

> > +	.alg.skcipher =3D {
> > +		.setkey =3D safexcel_skcipher_aesctr_setkey,
> > +		.encrypt =3D safexcel_ctr_aes_encrypt,
> > +		.decrypt =3D safexcel_ctr_aes_decrypt,
> > +		/* Add 4 to include the 4 byte nonce! */
> > +		.min_keysize =3D AES_MIN_KEY_SIZE + 4,
> > +		.max_keysize =3D AES_MAX_KEY_SIZE + 4,
>=20
> You could use CTR_RFC3686_NONCE_SIZE here (maybe in other places in the
> patch as well).
>=20
Makes sense. I did not know such a constant existed already.

> > +		.ivsize =3D 8,
>=20
> And CTR_RFC3686_IV_SIZE here.
>=20
Idem

> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
