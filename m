From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Wed, 22 Jul 2015 22:14:30 -0700
Message-ID: <55B07836.5050307@intel.com>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <20150722013241.GA31240@gondor.apana.org.au> <55AF19D0.5040700@intel.com> <55AF855A.9000202@freescale.com> <20150723015303.GA9777@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	=?UTF-8?B?VHVkb3IgQW1ixINydciZ?= <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3819 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbbGWFPG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jul 2015 01:15:06 -0400
In-Reply-To: <20150723015303.GA9777@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/22/2015 06:53 PM, Herbert Xu wrote:
> On Wed, Jul 22, 2015 at 02:58:18PM +0300, Horia Geant=C4=83 wrote:
>>
>> OTOH, caam has SG support for all PK operations, including rsa-encry=
pt,
>> rsa-decrypt primitives.
>> We are working at upstreaming - aligning our internal caam-pkc with
>> akcipher.
>=20
> OK.  Then we should tweak our interface to allow SGs.  Tadeusz?
>=20

We can add a flag to akcipher_request to say if src/dst are SGs or buff=
ers, but
is this really necessary?
What we have now is two implementations that don't support SGs.
In terms of users we have one in kernel i.e module verifier which doesn=
't need SGs
and proposed user space interface, which is going to copy data from/to =
user because
the buffers are so small that it is cheaper to copy than to use the spl=
ice/vmsplice
calls. To be honest I don't see any benefit in adding SG support.
