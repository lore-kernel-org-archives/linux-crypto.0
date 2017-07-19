From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: AES-XTS key size
Date: Wed, 19 Jul 2017 08:20:07 +0000
Message-ID: <VI1PR0401MB2591C3B11125DDEF82F266E398A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr00078.outbound.protection.outlook.com ([40.107.0.78]:9548
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753162AbdGSIUJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 04:20:09 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,=0A=
=0A=
AFAICS, IEEE 1619-2007 standard mentions only XTS-AES-128 and=0A=
XTS-AES-256, meaning that the keys should be either 256 or 512 bits.=0A=
=0A=
Further, NIST SP800-38E mentions that an implementation may restrict=0A=
support to only one of XTS-AES-{128,256}, but does not explicitly allow=0A=
other cipher suites.=0A=
=0A=
I don't see this enforcement in crypto/xts.c (XTS SW implementation),=0A=
though I noticed that XTS mode is used for other ciphers besides AES.=0A=
=0A=
More, tcrypt has xts(aes) speed tests checking also for XTS-AES-192.=0A=
For HW crypto engines adhering strictly to IEEE P1619-2007 this is a=0A=
problem:=0A=
[...]=0A=
tcrypt: test 5 (384 bit key, 16 byte blocks):=0A=
caam_jr 8020000.jr: key size mismatch=0A=
tcrypt: setkey() failed flags=3D200000=0A=
[...]=0A=
=0A=
Is the kernel more permissive than the standard?=0A=
=0A=
Thanks,=0A=
Horia=0A=
