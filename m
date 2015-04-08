From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH 09/11] crypto: remove LZO fallback from crypto 842
Date: Wed, 8 Apr 2015 10:28:23 -0400
Message-ID: <CALZtONC0WWkfaRs+0SNHaDQ1DhT+1ekgk0YXsQBi_2NRoP1e8Q@mail.gmail.com>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1428428070-17803-10-git-send-email-ddstreet@ieee.org> <20150408141600.GA30338@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150408141600.GA30338@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 8, 2015 at 10:16 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Apr 07, 2015 at 01:34:28PM -0400, Dan Streetman wrote:
>> Update the crypto 842 driver to no longer fallback to LZO if the 842
>> hardware is unavailable.  Simplify the crpypto 842 driver to remove all
>> headers indicating 842/lzo.
>>
>> The crypto 842 driver should do 842-format compression and decompression
>> only.  It should not fallback to LZO compression/decompression.  The
>> user of the crypto 842 driver can fallback to another format if desired.
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>
> Thanks for the series.  I don't know how I missed it when it was
> merged originally but crypto/842.c needs to be moved over to
> drivers/crypto.  Your software implementation should take its
> places as the reference implementation.

So, the sw implementation is only for decompression; there's no sw
compression implementation in these patches.

The hw 842 driver is currently at drivers/crypto/nx, and the
crypto/842 driver just calls the hw driver (after correctly
aligning/sizing the provided buffers to what the hw driver expects),
and falls back to the sw decompression if the hw decompression fails
(there is no compression fallback, a failure is reported to the
caller).

Is that setup ok?  If users had to directly call the hw driver,
instead of using the generic crypto_comp interface, it would
complicate things, e.g. in zswap it only expects to call
crypto_comp_compress()/decompress(), not call the 842 hw driver
directly.


>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
