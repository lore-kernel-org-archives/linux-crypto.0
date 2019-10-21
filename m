Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4262ACA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F223220873
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="WHEI0g98"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfJUMII (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:08:08 -0400
Received: from mail-eopbgr780047.outbound.protection.outlook.com ([40.107.78.47]:52426
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfJUMII (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:08:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+3TgfJms6VYWMZyVQayOrB+OqynApv9ih3OefRwyCQX4bfGwTnDe++V9rtCuQrr4djiitwuneMWxbVK4mcPTNZ+BzhGfk03RJQafltgLNpWq6Ic8z6ZZuhDZMpGypZpO1WwFNBBgQW9nXZKpci8tme/b7B2TS763OFiv3i0+pwpL5yBnZG95YXqY5fgCC5kdNLsuR7Zq/5NPydbWDXfx3mfsjaKAq3kXYHUoYraqxmVeCfuBihYYh2k6AcPPTnC1/BNuOo1XfU/bCX6GiD9KY9pu95SPm9Ge6RG9ZsZhan45fp0QwRrE/FCeVXnEC5QBpAvH6vI34gawqXAUa/hcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wyLHPPU/h7sE98QGwz9IWAgEzHDRZhJcXbvzv+llsU=;
 b=aLzGrzfsO13gy9MgBydSbeWuwZ5qRRrXU0auijQR8YNrb6rYy5T76+Yduq3SpsyP0LDLwGu3jmTH+FPV4R9uZciWQmC+RtCIHK3j6a2KgYNJenoyvPb+EFWyb79wGdgVsfZf9wy/HNhWXIAq11UsRSJ3QwFFLpO8ZcrV8tFHjUZJ+/E1GNBhvNU1EagPdHjeztbe2olYNsKaUiL4hXhiG/3motc96FYG5K1h7BKyHstyJUb2EIEKAOypcBr0gXc20lINxNYm2qDAkAU9zSHwb50+YpKRIxUdn6kahnKi9SLF2w7rjoxwBFiXNMyZ8cElKKV50w7x3SouoGvRX8r88g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wyLHPPU/h7sE98QGwz9IWAgEzHDRZhJcXbvzv+llsU=;
 b=WHEI0g98eyBuVWwk1SZRn1TQYk8WmH4JAPb/utlPYhUFGuxrAPg/gH+sIrGW3+10v8K6wLlCG9tyvsXomcAvkiynbXEHtvXIlS7UXs/jGnJNqsYt9HKU6H4AkvdfvDgRI+Sc3pC9O5Wmbp31LAeMmSNjfxbvOdlZXFXKJmsTZv8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2798.namprd20.prod.outlook.com (20.178.254.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Mon, 21 Oct 2019 12:07:23 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 12:07:23 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: Key endianness?
Thread-Topic: Key endianness?
Thread-Index: AdWH7WiyGB6aVNy7SJOkTaAoiPGHOgADxdEgAAIVQ1A=
Date:   Mon, 21 Oct 2019 12:07:23 +0000
Message-ID: <MN2PR20MB29730B2489C1A416BE8B7864CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f794fb4b-90b9-442f-5cd6-08d7561f3b1d
x-ms-traffictypediagnostic: MN2PR20MB2798:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2798009C555C7154A67092A2CA690@MN2PR20MB2798.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(136003)(39850400004)(13464003)(199004)(189003)(6436002)(14454004)(66066001)(66446008)(71190400001)(71200400001)(66476007)(9686003)(66946007)(229853002)(55016002)(14444005)(256004)(25786009)(76116006)(476003)(86362001)(66556008)(6246003)(64756008)(6116002)(3480700005)(3846002)(486006)(478600001)(2940100002)(2501003)(316002)(8936002)(81156014)(81166006)(446003)(7116003)(110136005)(26005)(186003)(5660300002)(52536014)(11346002)(2906002)(99286004)(15974865002)(6506007)(53546011)(305945005)(74316002)(102836004)(7736002)(33656002)(76176011)(7696005)(8676002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2798;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sN+I9rbXOUAKx3vIC98tFvJ0p2egXL8y1u7FrgF01RXHm+bKGgJGEKsBuOOQ6Jj/tWLoHpJClZadTq67zjTdk2wX8IgKLhhCTN9OYhLhRGntHC1/XjIwBVofeTxrYPoXmQXcv9y9LqdNLfpWc4uUcuY6cvw55Jyb7y/dBxt5sMf+uj/PNMOeg3jsPYAkRjLfMJ2wV0262oeY6cN6HMEGMd5NN3OvrJa80bRv1HSb9bDF1v5pYQuzfBv/pcLx1dQTseSWFSBdhBxd0YSAotRFOkzkl7f1Y9wwM3UMWFwvqtjSXoix8h8RV+hQO4kjEDIuYYtj/vEIWPPPo5UPbrJMx3a3TfRx4vPTXv6Qrdz262OcVbFVujXLyWeRNtcbeNva+4SeVxbuscXmOw/bR9rlj+d0E5t57phMLBOtA8eGlsUljKYsNlkqpgowC1kpQTLj
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f794fb4b-90b9-442f-5cd6-08d7561f3b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:07:23.1439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sdnwm4BemanDmvmtgELHMwb9Xe6jMyNfkRQvoRkUsXW6bHJSKuSZ1WwRAk2TgrKd4gd83Sjwkh9JlEmZSyucZsW0JMZcGb7Q95JyTQg1cj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2798
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

And now that we've opened Pandora's box of "ellendianness" (as we
say here - a combination of the Dutch word "ellende", for misery,
and endianness ;-):

The inside-secure driver uses several packed bitfield structures
(that are actually used directly by the little-endian hardware)
What happens to these on a big-endian machine?
I've seen examples that hint at having to define the bits in=20
reverse order on big-endian machines, which would require a big
"#ifdef LITTLE_ENDIAN / #else" around the whole struct definition.

And then on top of that I'll probably still have to swap the bytes
within words to get those into the correct order towards the HW.
Which is not very convenient for fields crossing byte boundaries.
(I'd probably want to use the byte swapping facilities of my HW
for that and not the CPU)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Monday, October 21, 2019 12:56 PM
> To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> Subject: RE: Key endianness?
>=20
> Another endianness question:
>=20
> I have some data structure that can be either little or big endian,
> depending on the exact use case. Currently, I have it defined as u32.
> This causes sparse errors when accessing it using cpu_to_Xe32() and
> Xe32_to_cpu().
>=20
> Now, for the big endian case, I could use htonl()/ntohl() instead,
> but this is inconsistent with all other endian conversions in the
> driver ... and there's no little endian alternative I'm aware of.
> So I don't really like that approach.
>=20
> Alternatively, I could define a union of both a big and little
> endian version of the data but that would require touching a lot
> of legacy code (unless I use a C11 anonymous union ... not sure
> if that would be allowed?) and IMHO is a bit silly.
>=20
> Is there some way of telling sparse to _not_ check for "correct"
> use of these functions for a certain variable?
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
>=20
> > -----Original Message-----
> > From: Pascal Van Leeuwen
> > Sent: Monday, October 21, 2019 11:04 AM
> > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> > Subject: Key endianness?
> >
> > Herbert,
> >
> > I'm currently busy fixing some endianness related sparse errors reporte=
d
> > by this kbuild test robot and this triggered my to rethink some endian
> > conversion being done in the inside-secure driver.
> >
> > I actually wonder what the endianness is of the input key data, e.g. th=
e
> > "u8 *key" parameter to the setkey function.
> >
> > I also wonder what the endianness is of the key data in a structure
> > like "crypto_aes_ctx", as filled in by the aes_expandkey function.
> >
> > Since I know my current endianness conversions work on a little endian
> > CPU, I guess the big question is whether the byte order of this key
> > data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
> > algorithm specification).
> >
> > I know I have some customers using big-endian CPU's, so I do care, but
> > I unfortunately don't have any platform available to test this with.
> >
> > Regards,
> > Pascal van Leeuwen
> > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > www.insidesecure.com

