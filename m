From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH 10/10] drivers/crypto/nx: add hardware 842 crypto comp alg
Date: Thu, 7 May 2015 11:06:06 -0400
Message-ID: <CALZtONBBoy=sM8Qt43-_k8BWTwSKA3FaJg9JMfJHzJ3wh5+kvQ@mail.gmail.com>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org> <1430931066-4536-11-git-send-email-ddstreet@ieee.org>
 <20150507031238.GC29395@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36500 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbEGPG1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2015 11:06:27 -0400
In-Reply-To: <20150507031238.GC29395@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 6, 2015 at 11:12 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, May 06, 2015 at 12:51:06PM -0400, Dan Streetman wrote:
>> Add crypto compression alg for 842 hardware compression and decompression.
>>
>> This crypto compression alg is named "nx842" to indicate it uses hardware
>> to perform the compression and decompression, while the software 842
>> compression alg is named "sw842".  However, since before this split there
>> was only one 842 compression alg named "842" which only used hardware,
>> this is also aliased "842" for backwards compatibility.
>
> This should still be called 842.  You can set the driver name to
> nx842 or 842-nx.

ah, ok, will do.

So, I'm wondering about the common NX 842 frontend driver, for the
pSeries and PowerNV platform drivers.  The current setup is:

[ crypto "842-nx" driver ]
           v
[ nx-842 main driver ]
          v
[ nx-842 pSeries driver | nx-842 PowerNV driver ]

The main reason for that is that the HW has specific constraints,
specifically each input and output buffer passed to it for comp or
decomp has to:
-be located at a specific alignment
-have a length of a specific multiple
-have a length between a specific minimum and maximum

The crypto 842-nx has (significant) code in it to handle any alignment
and length input buffers, to match them to what the driver requires.
Would it be better to move that into the crypto code, so that any
crypto compression hw driver can request buffers be specifically
aligned/sized?  I did have to use a header on each compressed buffer
that needed re-alignment or re-sizing, so maybe it's not appropriate
for common crypto compression code.

Since there doesn't seem to be any other hw compression drivers (yet),
maybe it should stay in the 842-nx code, at least for now.  Hopefully
any future compression hw won't have alignment or length multiple
restrictions...

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
