From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: AES-XTS key size
Date: Wed, 19 Jul 2017 11:26:52 +0200
Message-ID: <1787722.TLPNYLEBHS@tauon.chronox.de>
References: <VI1PR0401MB2591C3B11125DDEF82F266E398A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
To: Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60728 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753725AbdGSJ0y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 05:26:54 -0400
In-Reply-To: <VI1PR0401MB2591C3B11125DDEF82F266E398A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 19. Juli 2017, 10:20:07 CEST schrieb Horia Geantă:

Hi Horia,

> Hi,
> 
> AFAICS, IEEE 1619-2007 standard mentions only XTS-AES-128 and
> XTS-AES-256, meaning that the keys should be either 256 or 512 bits.
> 
> Further, NIST SP800-38E mentions that an implementation may restrict
> support to only one of XTS-AES-{128,256}, but does not explicitly allow
> other cipher suites.
> 
> I don't see this enforcement in crypto/xts.c (XTS SW implementation),
> though I noticed that XTS mode is used for other ciphers besides AES.
> 
> More, tcrypt has xts(aes) speed tests checking also for XTS-AES-192.
> For HW crypto engines adhering strictly to IEEE P1619-2007 this is a
> problem:
> [...]
> tcrypt: test 5 (384 bit key, 16 byte blocks):
> caam_jr 8020000.jr: key size mismatch
> tcrypt: setkey() failed flags=200000
> [...]
> 
> Is the kernel more permissive than the standard?

The standard(s) only define XTS for AES 128/256. It does not (according to my 
knowledge) prohibit the use of other key sizes (or even other ciphers, such as 
xts(serpent)).

Thus, I would say that the kernel implements the standard and allows a more 
flexible use than the standard specifies.

Unfortunately, the kernel crypto API only allows a min and max keysize 
specification in the cipher definition structure.

Once solution could be to introduce another flag. When that flag is set, 
xts_check_key() could deny any key other than 256 or 512 bits. But maybe that 
solution is more of a hack than a real solution.

Or tcrypt could be changed to not use XTS with 192/384 bit keys.

Ciao
Stephan
