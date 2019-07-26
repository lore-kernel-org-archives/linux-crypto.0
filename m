Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CE1C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D336321871
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="AWXPbbtw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfGZM5Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:57:24 -0400
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:51427
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfGZM5X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:57:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1QZdBl5CfezvZS0GR7XIt9z9CZuiHC8puOtATCT7Ny851uNgw3pt53philxQgt7PCWMFQwkCkXmU53HyPxQNoEnPmpoCya6aFvZFD1pXakomnGcP7oo94NkZpOZSTxH8V5pwjqpDTSDoNaxHRrOesXcL1QxXP/GOEISdLZ2oMApb0bucc2xfKmQ64eRJxFcL+wjWGxlFsqwtnz95m+I+n9Kuj550Dm99IDQmWS48hdluGkIzV6GZ62ro2gO0VpwrQpKCosD75nE+l/U0IDeNqUIBTkDqypmNIR+1sLvGaEx32hGL9mudg257x1ul/xqkhoIW+XaxHhzlNaA8M7HCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fy//ZlcMDe8aRqaEO/8ESMO59qqPd4w4eXbAIAjIOfY=;
 b=hkX5g7NdJBuVxfBTRa5BCf16oauZCM23ic1jFYXWJfwwdcf4JecBXSanS5PIlzi6Wv5dEOmY5I0X4A08QfoGgYQbLgkgCVvCPzfe0v8mFlZuvjaJp9t1R+zC3u59zg/3kx/NO83k/DR6BOeOZh2IVu30hxfEYOJqTIMwzWdf0TfSKXgEygtIFRjrqoGarskFE9CU9I4deIVZTgNx7DeUALCQYH44WGlm5q12qCSdWaenPHSaIODMqhXPVKzSizTo8lCrl/rMI/WQ6Vr9XA82ytjh75QQImCQTCgx2aG5ZqtRS4oVCkNVeWna92JUiHgkJQz2Da3XfoVGS13mFKfwDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fy//ZlcMDe8aRqaEO/8ESMO59qqPd4w4eXbAIAjIOfY=;
 b=AWXPbbtwE9j6Zjk14vCsFFCOhUYJBATGFWCKYgyRc5LfGEuX2vmqCzREKuNdTFsf9E8a03E0B42D4MRe28dVIa2eb1WqLmIPj+icS/ChshQBs96GDHPDPlv+7tox1ShGkrEPLBeV8uBzt/rYTawiApk/fB8KuZMhxnPNm2qbAaU=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3056.namprd20.prod.outlook.com (52.132.173.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 12:57:21 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 12:57:21 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Thread-Topic: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Thread-Index: AQHVMwaxl7vezQ4XF0yNrfTnczMQM6bc8rsAgAAGFCA=
Date:   Fri, 26 Jul 2019 12:57:21 +0000
Message-ID: <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726121938.GC3235@kwain>
In-Reply-To: <20190726121938.GC3235@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dec6079-9e8e-4af3-0797-08d711c8cc38
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3056;
x-ms-traffictypediagnostic: MN2PR20MB3056:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB3056A32BF23FBC8D5FA65BE9CAC00@MN2PR20MB3056.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39850400004)(376002)(366004)(199004)(189003)(13464003)(66946007)(486006)(110136005)(476003)(54906003)(11346002)(99286004)(446003)(6246003)(25786009)(66066001)(26005)(8936002)(81156014)(55016002)(53936002)(9686003)(71190400001)(71200400001)(68736007)(7736002)(6306002)(81166006)(8676002)(15974865002)(316002)(186003)(14444005)(6506007)(256004)(102836004)(76176011)(7696005)(53546011)(74316002)(14454004)(33656002)(76116006)(86362001)(6116002)(3846002)(6436002)(966005)(478600001)(64756008)(66446008)(66556008)(66574012)(5660300002)(4326008)(52536014)(66476007)(305945005)(229853002)(2906002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3056;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MjDa/kMRt5BKSLJUwiAtfpt5exAL3HJwovsB7s2KSoDv7OWcLHwIThr7aKeRQA27OLIQehQLgbHN+ZpgRqxqSPu1RfaorCrWmLjR3pUd4Lm22dkNRilyLbT8S1snVw+LKLlznfPetUs9GjlIzWbeMf5soyLE9ZSOwxMTDRiGmwNPfJdAwH/OSBcdvHOEh2bFboUg4P3xvY6T6uAa8afAWxXluvOCrcKXFECyIhpKraZxidtrpCXSk8iNsRqvqBsbVLdcVGTXk5N2N6k8VkLvu/FRLqVPCTEMDKkq0bBrEieinqA1n0L3rE6ibTy8s4+Jda/TnoihPWXUv2Tth+pd2hoz2yW6l3psXEHj7KuTxdxmgV6tIqktF6FeWk9Ru31/OtiRaQ+lXBLYu9B/59WEqPYvhEFqzFnZrvMeZmhgohs=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dec6079-9e8e-4af3-0797-08d711c8cc38
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 12:57:21.1201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3056
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Antoine,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Antoine Tenart
> Sent: Friday, July 26, 2019 2:20 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au; davem@davemloft.net; Pascal Van
> Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 1/3] crypto: inside-secure - add support for authenc(=
hmac(sha1),cbc(des3_ede))
>=20
> Hi Pascal,
>=20
> On Fri, Jul 05, 2019 at 08:49:22AM +0200, Pascal van Leeuwen wrote:
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
>=20
> Could you provide a commit message, explaining briefly what the patch is
> doing?
>=20
I initially figured that to be redundant if the subject already covered it =
completely.
But now that I think of it, it's possible the subject does not end up in th=
e commit
at all ... if that is the case, would it work if I just copy-paste the rele=
vant part of the
subject message? Or do I need to be more verbose?

> > @@ -199,6 +201,15 @@ static int safexcel_aead_aes_setkey(struct crypto_=
aead *ctfm, const u8 *key,
> >  		goto badkey;
> >
> >  	/* Encryption key */
> > +	if (ctx->alg =3D=3D SAFEXCEL_3DES) {
> > +		flags =3D crypto_aead_get_flags(ctfm);
> > +		err =3D __des3_verify_key(&flags, keys.enckey);
> > +		crypto_aead_set_flags(ctfm, flags);
>=20
> You could use directly des3_verify_key() which does exactly this.
>=20
Actually, I couldn't due to des3_verify_key expecting a struct crypto_skcip=
her as input,
and not a struct crypto_aead, that's why I had to do it this way ...

> > +struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_e=
de =3D {
> > +	.type =3D SAFEXCEL_ALG_TYPE_AEAD,
>=20
> You either missed to fill .engines member of this struct, or this series
> is based on another one not merged yet.
>=20
Yes, that happened in the patchset of which v2 did not make it to the maili=
ng list ...

> > +	.alg.aead =3D {
> > +		.setkey =3D safexcel_aead_setkey,
> > +		.encrypt =3D safexcel_aead_encrypt_3des,
> > +		.decrypt =3D safexcel_aead_decrypt_3des,
> > +		.ivsize =3D DES3_EDE_BLOCK_SIZE,
> > +		.maxauthsize =3D SHA1_DIGEST_SIZE,
> > +		.base =3D {
> > +			.cra_name =3D "authenc(hmac(sha1),cbc(des3_ede))",
> > +			.cra_driver_name =3D "safexcel-authenc-hmac-sha1-cbc-des3_ede",
>=20
> You could drop "_ede" here, or s/_/-/.
>=20
Agree the underscore should not be there.
Our HW does not support any other form of 3DES so EDE doesn't
really add much here, therefore I will just remove "_ede" entirely.

> Apart from those small comments, the patch looks good.
>=20
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
