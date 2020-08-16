Return-Path: <SRS0=CHgJ=B2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369F2C433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 15:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073032075D
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 15:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="R/a/Q+2l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgHPPX4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Aug 2020 11:23:56 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:58646 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbgHPPXy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Aug 2020 11:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1597591431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4aUtL4WxIRgf2rrNWU7/BB0m9zyNVsoL3EJbPwNYMUc=;
        b=R/a/Q+2lg8W84ybqwZ02/8CkPgPFQPzg+tpviOIH876bTuh7qCRCt3ywEdbjAuYLysuk4o
        xKbIfHHcOm3KQxBdbvihetvlCnuqLTK8blL6c9zPSwDDGp64eSZxbBSkSjU9MB33po6PZO
        NFQ2izOdz1v1lQspfsiEjxpMYEnzsAU=
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02lp2058.outbound.protection.outlook.com [104.47.36.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-iMSKI4s1OfuA46k3FokCDA-1; Sun, 16 Aug 2020 11:23:50 -0400
X-MC-Unique: iMSKI4s1OfuA46k3FokCDA-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB1215.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7711::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Sun, 16 Aug
 2020 15:23:46 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354%8]) with mapi id 15.20.3283.027; Sun, 16 Aug 2020
 15:23:45 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Information required on how to provide reseed input to DRBG
Thread-Topic: Information required on how to provide reseed input to DRBG
Thread-Index: AdZxT90HuxgE8CzuQx++WGnAfz8h1AANP/iAAACUzxAANK7MAABhyJAg
Date:   Sun, 16 Aug 2020 15:23:45 +0000
Message-ID: <TU4PR8401MB1216D834A2D0AB0881776991F65E0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB1216EDF43D02A616A8022320F6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
 <24177500.6Emhk5qWAg@tauon.chronox.de>
 <TU4PR8401MB12168D750EEF9AB43607FE8DF6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
 <4093118.6tgchFWduM@tauon.chronox.de>
In-Reply-To: <4093118.6tgchFWduM@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.105.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76c0d30e-07be-411f-d5af-08d841f85e1b
x-ms-traffictypediagnostic: TU4PR8401MB1215:
x-microsoft-antispam-prvs: <TU4PR8401MB1215C4859A0DE4064AD567B0F65E0@TU4PR8401MB1215.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MiNCJg+/JBrAVFz1/FOglB27PebBNx7Xgdrg83uAPSG76kqyIMmHgsBQZGXGgeUbNym9Xl8O7595DsyUQUOycgfbbfuQPEQdkL99bwZELqImaPIazHlbhddArMa819l6h324+wE6TdmKzElQj1LjyL62/Ut34GJQ6KE3cTWC9cWoA5FzykiJREa/h1BpylAIKFaX1OMWYLDrWwDKOogbQ+mthV8ek0weRqXkdAzsc779LLkEMSMNi1mQe/wXkJCuA0Ca5F/YZwTDy7ZFKEoTfEWe7zY6Ra5czhWzgtYbBwUgJvVs+blL0gbyBal8e63PJv00Q7vyvw0JsSQkViqq3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(55016002)(9686003)(186003)(83380400001)(71200400001)(316002)(7696005)(8676002)(33656002)(53546011)(6506007)(478600001)(55236004)(8936002)(110136005)(5660300002)(86362001)(26005)(76116006)(2906002)(66556008)(66476007)(66946007)(52536014)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SZEMoLiqDza/WtjALXVhIQqR5W5tScVdHpTrr0kikqe04zeR2MyHHhATcmAZCCFBlevG8czrNeZI9MXD9W9nsgHW+PL0r+TJBt+PDkzPlr5WoDqHZwvYa3dsNdTSiQWBTwqpNn1L3eXECNzlNIScqlcF1GNumoTJs3YRXAFl8/gz2/mD8zgA81rMROsA0rKdOoPt3HR+NdUxsTa9dIAeCplCuqTdRJFxv2v9PKPHDplYaPNiHO1oE+zbNRvMVGhZ6xnm2a4Ry7HLhoM6R6j/L8f7uGYS9x5wFqokjRb+IaAJNX8g4Shl+loIZ1hiLxxjaWPL8uuOmr4Br4S0TtLL5UOJ8vO3MxaiQkSlabsUGAid/U2zjn8+8kTzMeArzW5Ljx9lJ2EHdoRhd/7O0DN6hz7ZwTiLIH/v/PInzwPc0VcJHdEKW4p/SzDP3AtJ8W5b2j6emRTPM2AVvO2GT1j1inACdZRYVQuA/MZGauRBkkr5fpJqCr4pwOOnSrBB3CqiiOPeWD9K5gxMgCmUujKXO0RvPX4eh0VHFkdBuY4dvzkt8nKzN6xnotZ5c06T14pCxLmh/I+MxR6mJRdWXaki+4TunRJtJl0eS8Fmh0D56lxsjCY6Ysh0fzZS8VO6/WXx1L13nMfd5cGMFzVE1PwrDw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c0d30e-07be-411f-d5af-08d841f85e1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2020 15:23:45.8003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TvYC2AA5cu9qgYFSLelGz3LUFM9Eav6G+7Gcq1PzdBMWmVa3Q3FnTJ+gbDOoyoPSOmvWIIUxEzYVO8X9QApP3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1215
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0.005
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Thank you. Initially I was thinking this is the approach. However I was con=
fused on drbg instance state.
This worked well. Thank you very much once again.

Regards,
Jayalakshmi

-----Original Message-----
From: Stephan Mueller <smueller@chronox.de>=20
Sent: Friday, August 14, 2020 10:13 PM
To: linux-crypto@vger.kernel.org; Bhat, Jayalakshmi Manjunath <jayalakshmi.=
bhat@hp.com>
Subject: Re: Information required on how to provide reseed input to DRBG

Am Donnerstag, 13. August 2020, 17:56:49 CEST schrieb Bhat, Jayalakshmi
Manjunath:

Hi Jayalakshmi,

> Hi Stephen,
>=20
> Thanks you very much on the response. I actually went through the code=20
> that you mentioned. My question is on inputting reseed. Example input=20
> I have is something like this
>=20
> "entropyInput" :
> "F929692DF52BC06878F67A4DBC76471C03981B987FF09BF7E29C18AD6F7F8397", "nonc=
e"
> : "8DB5A7ECEC06078C1C41D2C80AB6CB5EDFE00EA7B1AA6F4F907E80C9BAA008CE",
> "persoString" : "C99B39DD7B8FB0F772",
> "otherInput" :
> =09 {
> =09=09"intendedUse" : "reSeed",
> =09        =09"additionalInput" :=20
> "32ED729CD8FCC001B6B2703F0DBE04D5EED127A615212FEC967566ABBFBC8913027D=20
> ", "entropyInput" :
> "6FE46781AF69B38550A4D2C3888C8E515D28A2A4F141A041F3E2E9A753E46A30" },
> =09 {
> =09=09"intendedUse" : "generate",
> =09=09 "additionalInput" :
> "3C758EC9ECFD905E5865FD8343556815FBD8A064846252CBC161BFEAAC4FA9AF4D0DB
> 8D8B9 FD2E06B2C7A3FD55", "entropyInput" : ""
> =09},
> =09{
> =09=09"intendedUse" : "generate",
> =09=09"additionalInput" :
> "8F8F3F52D2CEF7FA788E984DA152ECA82CF0493E37985E387B3CFCEC2639F610431CA
> 0A81F 740C4CD65230DD291733", "entropyInput" : ""
> =09}

Here is my code for that:


drbg_string_fill(&testentropy, entropyreseed->data,
=09=09=09=09 entropyreseed->len);
drbg_string_fill(&addtl, addtlreseed->data, addtlreseed->len); ret =3D cryp=
to_drbg_reset_test(drng, &addtl, &test_data);

>=20
> I understood
> how to use " entropyInput", " nonce" and " persoString".
> how to use " additionalInput" and " entropyInput" from generate section.
> My question is how to I use " additionalInput" and " entropyInput"=20
> from reSeed section.
>=20
> I could see only below APIs available to set the values.
> crypto_drbg_get_bytes_addtl_test { crypto_rng_set_entropy,
> crypto_rng_generate) crypto_drbg_reset_test {crypto_rng_set_entropy,=20
> crypto_rng_reset} crypto_drbg_get_bytes_addtl { crypto_rng_generate)
>=20
> I am not seeing any API to input reseed values or to trigger reseed?
>=20
> Regards,
> Jaya
>=20
>=20
> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org
> <linux-crypto-owner@vger.kernel.org> On Behalf Of Stephan Mueller Sent:
> Thursday, August 13, 2020 8:48 PM
> To: linux-crypto@vger.kernel.org; Bhat, Jayalakshmi Manjunath=20
> <jayalakshmi.bhat@hp.com> Subject: Re: Information required on how to=20
> provide reseed input to DRBG
>=20
> Am Donnerstag, 13. August 2020, 11:01:27 CEST schrieb Bhat,=20
> Jayalakshmi
> Manjunath:
>=20
> Hi Jayalakshmi,
>=20
> > Hi All,
> >=20
> > I could successfully execute the CAVS test for DRBG with=20
> > ""predResistanceEnabled" : true" reseedImplemented": false.
> >=20
> > I am trying to execute the tests with "predResistanceEnabled" :=20
> > false; "reseedImplemented" : true. But not successful.
> >=20
> > Can anyone please let me know how to provide reseed data to DRBG?
>=20
> See, for example, how drbg_nopr_sha256_tv_template is processed with
> drbg_cavs_test()
>=20
> > Regards.
> > Jayalakshmi
>=20
> Ciao
> Stephan


Ciao
Stephan


