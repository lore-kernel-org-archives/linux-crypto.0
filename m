Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92208C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 06:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B812073B
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 06:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="M33wEfFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgEZGac (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 02:30:32 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:32051 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgEZGac (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 02:30:32 -0400
X-Greylist: delayed 12519 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2020 02:30:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1590474630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=alTfBvlAhNYyvFWIRKPY5dtyhkTm0acGVbiy+tCtZMk=;
        b=M33wEfFvwM3yndo1cxTQOYMkD4HePw7kR6Bz92Jh9lFq4KH+ic5WnQCBc3+EM77isdc71E
        9zUdNqBUjnmRNDHCtevrSgmsuWzqu9AYdZT1C5msnQ3NClUyo6O/PeuzX//09wni35lTrp
        RmArtAhydzN8iUijnKFxTeX2XW8pUCE=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-byDZ1wQuME26ivL6KUKmAg-1; Tue, 26 May 2020 02:30:27 -0400
X-MC-Unique: byDZ1wQuME26ivL6KUKmAg-1
Received: from CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7514::20) by CS1PR8401MB0966.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7510::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Tue, 26 May
 2020 06:30:26 +0000
Received: from CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dd57:e488:3ebd:48bd]) by CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dd57:e488:3ebd:48bd%3]) with mapi id 15.20.3021.020; Tue, 26 May 2020
 06:30:26 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Monte Carlo Test (MCT) for AES
Thread-Topic: Monte Carlo Test (MCT) for AES
Thread-Index: AdYv5DokmuoSohTcS6aV9BTI5pb2mgAA7F8wACeCS4AAKwgigAB2Gw8wAATPbYAAAlWEgA==
Date:   Tue, 26 May 2020 06:30:26 +0000
Message-ID: <CS1PR8401MB06462D6721066AC8C1727DDEF6B00@CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544BD5EDA39A5E1E3388940F6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <12555443.uLZWGnKmhe@positron.chronox.de>
 <CS1PR8401MB0646A38BBFAD7FBABE50CBECF6B00@CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM>
 <5330121.xyrNXEdPSU@tauon.chronox.de>
In-Reply-To: <5330121.xyrNXEdPSU@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.106.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6af9624b-0580-4a60-2792-08d8013e4733
x-ms-traffictypediagnostic: CS1PR8401MB0966:
x-microsoft-antispam-prvs: <CS1PR8401MB09665B1BD6C92CBAFED661DFF6B00@CS1PR8401MB0966.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 041517DFAB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ysgha40vVDHYXQGwjYKTBN/NOHFW03Aek1a0hpQNDy67Cm/QFKuP0pPErLPd1kBnTPPgaM6Fd6+8QlNvaKXvLOaN/h/IIeJS8pLJd5atBzw1MB7YG+wjAzLNxChA3pUq6rHSTsIF/HjqcM+GvOH1NzidQSFKs0VzV3BIA2xgxtcgeZiUFkO3rM846K3Y+rLs09abAlWgZEj6BRLwFI5nAXqIxMpUNLUX5I7UdDDS9J0RJhw8woKWgpYlsT+zWfCuGBN9/rYv74v2aKo8kSLRa5YUYaJv+iCkJn8ki7QY9rnIEWidbYrhEJd4BBBg6qJ7CelrtdJzJr5gvX8l3P6lJD1ux6UoozOluZfGGrAznd6T6K81nNI43Yuj/6idYc5LQfm9T0t+gFPpkv0im88zZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(66574014)(64756008)(66556008)(76116006)(66946007)(66446008)(33656002)(5660300002)(71200400001)(4326008)(9686003)(186003)(6916009)(55016002)(26005)(7696005)(6506007)(66476007)(52536014)(966005)(53546011)(55236004)(86362001)(478600001)(54906003)(8676002)(316002)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: brKwssegXWJymsepaFaPpt4luA9ecpHPV11VGQ7AX40mrucvxm/r8qYbruOk2bfIKP3pmsdSzCuUiU6YfTTbOnGOoqjcqQuP5N00/5N5Qywys0pbUTP1P7xC6nixBCwmaqyp4h3TVRoenqkDuRtYLNy62aTSo6xp+//tslwEJWlvM6TAgPq8BWcBrp0im1VVMZBsjEzudd3cV9+s2GLw3EL7byBBmHxag7DId4wBiLtchWdeG8v0KstCiRvP/GL/c8ft2ruzg87o9de7E3ro2MGD4VbOjlqt/7Mj4t5UQsW8FDfS3aH6oAcqKorCTEd/IUIQrjdSb6Rj2Bxt1NefKqMgOvXNsEbluQmRtaQlmTBrh3VJ8CZSCd/lasJZvGAnDkD7EZxuUKnSBYpwCJvW9HJ246Jz4Pk3tCDW9R0fcimaS/QqPHxyZTLP3T9aAXBiZLUl1+aYwUL2bTzn7fOjRHUnT1bTNTQfdbb1zJ9jkSgjEbLzcOK3b717VbQ7bMg1
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af9624b-0580-4a60-2792-08d8013e4733
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2020 06:30:26.6230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y0yOi100ttIc3gN2jr8sbgGStTJN3jn4ZISKfhSK/twih5zuuPh1Ug7Bly+W8M3A4VoYLWqXhtA+4Sas8THBcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CS1PR8401MB0966
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

Thank you very much

Regards,
Jaya

From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.or=
g> On Behalf Of Stephan Mueller
Sent: Tuesday, May 26, 2020 10:53 AM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>
Cc: Ard Biesheuvel <ardb@kernel.org>; linux-crypto@vger.kernel.org
Subject: Re: Monte Carlo Test (MCT) for AES

Am Dienstag, 26. Mai 2020, 05:07:15 CEST schrieb Bhat, Jayalakshmi Manjunat=
h:

Hi Jayalakshmi,

> Hi Stephen,
>=20
> I to add the backend support using libkcapi APIs to exercise Kernel CAVP.
> Can you please confirm if my understanding is correct?

You would need to implement an equivalent to backend_openssl.c or=20
backend_nettle.c=20
>=20
> Regards,
> Jaya
>=20
> From: mailto:linux-crypto-owner@vger.kernel.org
> <mailto:linux-crypto-owner@vger.kernel.org> On Behalf Of Stephan M=FCller=
 Sent:
> Sunday, May 24, 2020 12:14 AM
> To: Bhat, Jayalakshmi Manjunath <mailto:jayalakshmi.bhat@hp.com>; Ard Bie=
sheuvel
> <mailto:ardb@kernel.org> Cc: mailto:linux-crypto@vger.kernel.org
> Subject: Re: Monte Carlo Test (MCT) for AES
>=20
> Am Samstag, 23. Mai 2020, 00:11:35 CEST schrieb Ard Biesheuvel:
>=20
> Hi Ard,
>=20
> > (+ Stephan)
> >=20
> > On Fri, 22 May 2020 at 05:20, Bhat, Jayalakshmi Manjunath
> >=20
> > <mailto:jayalakshmi.bhat@hp.com> wrote:
> > > Hi All,
> > >=20
> > > We are using libkcapi for CAVS vectors verification on our Linux kern=
el.
> > > Our Linux kernel version is 4.14. Monte Carlo Test (MCT) for SHA work=
ed
> > > fine using libkcapi. We are trying to perform Monte Carlo Test (MCT) =
for
> > > AES using libkcapi. We not able to get the result successfully. Is it
> > > possible to use libkcapi to achieve AES MCT?
>=20
> Yes, it is possible. I have the ACVP testing implemented completely for A=
ES
> (ECB, CBC, CFB8, CFB128, CTR, XTS, GCM internal and external IV generatio=
n,
> CCM), TDES (ECB, CTR, CBC), SHA, HMAC, CMAC (AES and TDES). I did not yet
> try TDES CFB8 and CFB64 through, but it should work out of the box.
>=20
> AES-KW is the only one that cannot be tested through libkcapi as AF_ALG h=
as
> one shortcoming preventing this test.
>=20
> The testing is implemented with [1] but the libkcapi test backend is not
> public. The public code in [1] already implements the MCT. So, if you wan=
t
> to use [1], all you need to implement is a libkcapi backend that just
> invokes the ciphers as defined by the API in [1].
>=20
> [1] https://github.com/smuellerDD/acvpparser
>=20
> Ciao
> Stephan


Ciao
Stephan

