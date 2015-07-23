From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Thu, 23 Jul 2015 12:16:05 +0200
Message-ID: <1439729.2su3tGjFMy@tachyon.chronox.de>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <20150723015303.GA9777@gondor.apana.org.au> <55B07836.5050307@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>,
	linux-crypto@vger.kernel.org,
	Tudor =?utf-8?B?QW1ixINydciZ?= <tudor.ambarus@freescale.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48002 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbGWKQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jul 2015 06:16:11 -0400
In-Reply-To: <55B07836.5050307@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. Juli 2015, 22:14:30 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 07/22/2015 06:53 PM, Herbert Xu wrote:
> > On Wed, Jul 22, 2015 at 02:58:18PM +0300, Horia Geant=C4=83 wrote:
> >> OTOH, caam has SG support for all PK operations, including rsa-enc=
rypt,
> >> rsa-decrypt primitives.
> >> We are working at upstreaming - aligning our internal caam-pkc wit=
h
> >> akcipher.
> >=20
> > OK.  Then we should tweak our interface to allow SGs.  Tadeusz?
>=20
> We can add a flag to akcipher_request to say if src/dst are SGs or bu=
ffers,
> but is this really necessary?
> What we have now is two implementations that don't support SGs.
> In terms of users we have one in kernel i.e module verifier which doe=
sn't
> need SGs and proposed user space interface, which is going to copy da=
ta
> from/to user because the buffers are so small that it is cheaper to c=
opy
> than to use the splice/vmsplice calls. To be honest I don't see any b=
enefit
> in adding SG support.

Tadeusz, to also support your case, I would again suggest to use anothe=
r=20
integer akin the alignmask which indicates the requested "block size" o=
f one=20
SG entry. Simiarly to alignmask, the implementation of a cipher now has=
 two=20
code paths: one streamlined path where the caller honored the integer a=
nd only=20
has one SG list entry which gives you a linear buffer. If the caller do=
es not=20
honor the flag and uses more than one SGL entry, the implementation the=
n does=20
a memcpy to get a linear buffer.

This should allow us to convert the API to SGLs and yet maintain the ca=
se=20
where an implementation has linear buffers.

To reduce code duplication, maybe we can create a service function that=
=20
converts an SGL into a linear buffer.

--=20
Ciao
Stephan
