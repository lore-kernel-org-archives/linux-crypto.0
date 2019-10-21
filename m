Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4308ECA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 10:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B18620873
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 10:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="zaNXeyax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfJUKz7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 06:55:59 -0400
Received: from mail-eopbgr680060.outbound.protection.outlook.com ([40.107.68.60]:27876
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727831AbfJUKz6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 06:55:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ49BUyKdqPW61XTi64ufasFosGYdKgV2COutJaX3X/j6fzgdStn3Oqi/Vc7GCK9wmSxJwrfPzlexNZcaV9Wu8nbWHtqm5PXBrUwEcLct09ExXjwtlICd4Ko0DDf0yFK8p/C/zBkKJcBzEd27k/myqnrocDC3EBfmd4eyCrs67Io7ak5gCrE4pBpxfh5iRKNMAl9N+YgVu0Ra3nHmS/DWk+44mIFpBkD1EPqXgDR77VBy/aIvser2U+vskV4q91Qw6DRPY2tNao5dEBaMme8CfFlL/9bSf9vtu3HG9iLqvUlNq6rDNlYw0qaHabkGLueS8I8qENDv7gC4bYW76hhvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwYf75MjPx31xTKvR62HiLAJ8/501UAIekaKlGthX8g=;
 b=YsgpPUwW0vJnT4cU5Dv8xGIRyUABzJBullVt62MpgGyadQGOio25khLxGoEdFyhyUQB5QcjkEvKUqpQ4h+pDmbjSB++2QeUBGYeo1Yv77+CKkFWl+VT3cFp/Q5O+2rjjoaE/vOCDAJAxpjAOknkj0zAOcGl9cYoV15xzWd2kveUsEjZ9CGbn6jCMYZc1wDKiRb2EoAN/LbNRkHWAcVx4WEe1ttM7QI5crPaioEHpniE/LlbzFVrQeWDxMrGfmoM2Okpyma1Bcmsi7FZydmI8t+Ipq67nij+z3L70vbNsnQF5Aur62sA0yx8Ve5UrNu/gdmj+IwUM/YTntIYJdXzPTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwYf75MjPx31xTKvR62HiLAJ8/501UAIekaKlGthX8g=;
 b=zaNXeyaxpwQZPRfH9leTDGvMymrdwmhBWCxmGYtGXRPI4dPEZDX/ypKo2PBmvvS2Hag53GdIwjTea/b+d6wTbnTa3BGSWnYXDoTT1eeppFWfQVCQxIvchSjR37+RS+RL4nkHPqfL92n43wlwFOgb83YLNWiQuqhYgkzgzbMUstE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2656.namprd20.prod.outlook.com (20.178.251.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 21 Oct 2019 10:55:56 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 10:55:56 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: Key endianness?
Thread-Topic: Key endianness?
Thread-Index: AdWH7WiyGB6aVNy7SJOkTaAoiPGHOgADxdEg
Date:   Mon, 21 Oct 2019 10:55:56 +0000
Message-ID: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5947232b-c8bc-4765-309b-08d756154020
x-ms-traffictypediagnostic: MN2PR20MB2656:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2656ACF323D7C42F70DF6544CA690@MN2PR20MB2656.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(136003)(376002)(366004)(396003)(199004)(189003)(13464003)(7736002)(7696005)(316002)(86362001)(2906002)(71200400001)(71190400001)(478600001)(15974865002)(5660300002)(7116003)(8936002)(476003)(305945005)(74316002)(486006)(25786009)(14444005)(6116002)(256004)(3846002)(55016002)(6436002)(229853002)(9686003)(33656002)(99286004)(76116006)(66476007)(66556008)(64756008)(66446008)(8676002)(6506007)(110136005)(53546011)(52536014)(66946007)(66066001)(14454004)(26005)(81166006)(81156014)(186003)(102836004)(6246003)(3480700005)(2501003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2656;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0J9HPgWR36fdTgjC26YjKzg0mT24Scml8QoqA/HcNNUBM/I5SNVr3Kmjr8OsaTLVzC6wbvJyOhE1Jpq8ml7ylzeQ23Hzfq+VoUvJBblkg/T1lDMI247IN5R0I3ZfLjpAkp7n8248udtsQF/xX02VjY3J8XeH4RFyZlKHfsFAqjuP3Cvx6zzE7B9XJ3Dv8n+xjrtxiwwdYa0wqEYmCammkmAfCNZzgYq/HcS9rmPbTAmv3bSyf5VafKRYEIaZjJA/B7VnNl5YiiP6mSkTHu026ZMFuTFSy/JUNZJb/YXXkrwUZYgQY228zu793CwPKRGhOEsHFDi9CrmTjswCuwbN12yzesS6lAh+Uh8J7xKG0cL8tjqGqGMWRz69yqfWrA5OUDZG/6/Ttf05YDE8f9/y26HjCS77O64J+6IoEPsOkuQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5947232b-c8bc-4765-309b-08d756154020
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 10:55:56.3919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qs0y8ze0Pxoh1eko244stbn0DlcAbf5g91jg9/aOWRglWQ4It9jSwiO1mxt1nZgMxrBWsnddif/jPZHxComyPt3qtykpjrpkkacxWvDaVac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2656
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Another endianness question:

I have some data structure that can be either little or big endian,
depending on the exact use case. Currently, I have it defined as u32.
This causes sparse errors when accessing it using cpu_to_Xe32() and
Xe32_to_cpu().

Now, for the big endian case, I could use htonl()/ntohl() instead,
but this is inconsistent with all other endian conversions in the
driver ... and there's no little endian alternative I'm aware of.
So I don't really like that approach.

Alternatively, I could define a union of both a big and little
endian version of the data but that would require touching a lot
of legacy code (unless I use a C11 anonymous union ... not sure
if that would be allowed?) and IMHO is a bit silly.

Is there some way of telling sparse to _not_ check for "correct"
use of these functions for a certain variable?

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

> -----Original Message-----
> From: Pascal Van Leeuwen
> Sent: Monday, October 21, 2019 11:04 AM
> To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> Subject: Key endianness?
>=20
> Herbert,
>=20
> I'm currently busy fixing some endianness related sparse errors reported
> by this kbuild test robot and this triggered my to rethink some endian
> conversion being done in the inside-secure driver.
>=20
> I actually wonder what the endianness is of the input key data, e.g. the
> "u8 *key" parameter to the setkey function.
>=20
> I also wonder what the endianness is of the key data in a structure
> like "crypto_aes_ctx", as filled in by the aes_expandkey function.
>=20
> Since I know my current endianness conversions work on a little endian
> CPU, I guess the big question is whether the byte order of this key
> data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
> algorithm specification).
>=20
> I know I have some customers using big-endian CPU's, so I do care, but
> I unfortunately don't have any platform available to test this with.
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

