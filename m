From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH 09/11] crypto: remove LZO fallback from crypto 842
Date: Wed, 8 Apr 2015 10:45:45 -0400
Message-ID: <CALZtONAZenUKxJdzOFXe1hBxGCASO_GsVfG9vtKWBe5EwcftmA@mail.gmail.com>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1428428070-17803-10-git-send-email-ddstreet@ieee.org> <20150408141600.GA30338@gondor.apana.org.au>
 <CALZtONC0WWkfaRs+0SNHaDQ1DhT+1ekgk0YXsQBi_2NRoP1e8Q@mail.gmail.com> <20150408143831.GA30762@gondor.apana.org.au>
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
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35388 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbDHOqG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:46:06 -0400
In-Reply-To: <20150408143831.GA30762@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 8, 2015 at 10:38 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Apr 08, 2015 at 10:28:23AM -0400, Dan Streetman wrote:
>>
>> So, the sw implementation is only for decompression; there's no sw
>> compression implementation in these patches.
>
> As a general rule we don't add any hardware implementation unless
> there is a software implementation.  The reason is that every new
> algorithm creates an API (potentially a user-space API if the
> algorithm can be exported via algif).  But sometimes things slip
> through.
>
> So I'm not going to immediately remove 842 but it would be nice
> if we had a reference implementation so that if ever there were
> another hardware 842 implmentation added then at least we have
> something that we can judge against.

Ok I'll see if I can include a sw compression implementation.

>
>> The hw 842 driver is currently at drivers/crypto/nx, and the
>> crypto/842 driver just calls the hw driver (after correctly
>> aligning/sizing the provided buffers to what the hw driver expects),
>> and falls back to the sw decompression if the hw decompression fails
>> (there is no compression fallback, a failure is reported to the
>> caller).
>>
>> Is that setup ok?  If users had to directly call the hw driver,
>> instead of using the generic crypto_comp interface, it would
>> complicate things, e.g. in zswap it only expects to call
>> crypto_comp_compress()/decompress(), not call the 842 hw driver
>> directly.
>
> I think the only thing that needs to happen for now is moving
> crypto/842.c over to drivers/crypto/nx (perhaps merge it into
> nx-842.c) so that it's obvious that this is not a generic
> implementation.

ah ok, so you mean it can still be a crypto_comp interface, just move
its location and/or merge it into nx-842.c?

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
