From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for nx842
Date: Tue, 22 Sep 2015 11:08:22 -0400
Message-ID: <CALZtONCaauoG3CBnbGWfUXTU2_QXD_F0rVxzgO24VmMTLxV0og@mail.gmail.com>
References: <1442707362.6178.11.camel@hbabu-laptop> <20150921142607.GA2405@gondor.apana.org.au>
 <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
 <20150922122117.GA11522@gondor.apana.org.au> <CALZtONBYYTnRE6FyQKVL8kyAAb8BuXJzyGA5mYNHiXtSNcDv9Q@mail.gmail.com>
 <20150922144219.GA12943@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36450 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbbIVPJD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2015 11:09:03 -0400
In-Reply-To: <20150922144219.GA12943@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 22, 2015 at 10:42 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Tue, Sep 22, 2015 at 10:39:53AM -0400, Dan Streetman wrote:
>>
>> hmm, that's true, and that would simplify the code a lot!  No need for
>> the header anymore.  But, since the sw driver is sooo much slower, it
>> would be important to be able to communicate the alignment and size
>> limits to the caller of the crypto compression api, via cra_alignmask
>> and cra_blocksize (for minimum size), as well as new fields for max
>> size (maybe cra_maxsize) and buffer length multiple - i.e. the buffer
>> length must be a multiple of N (maybe cra_blockmult or cra_blockmodulo
>> or something).  Otherwise callers would get unexpectedly slow
>> performance if they use the wrong alignment or size.
>
> Right.  So who actually uses this?

currently, zswap.  Probably nobody else.  And zswap will always
provide an input buffer that is exactly one page, and output buffer
that is exactly 2 pages.  So, it will always meet the 842 hw
requirements.

Maybe I got a little too excited about adding flexibility to the 842
hw driver? ;-)

As long as zswap is the only user of the 842 hw driver, it could be
changed to simply return error for any mis-aligned or mis-sized
buffer.  A quick git grep of crypto_comp shows the only users of it
outside of crypto itself are ubifs and ipcomp.  ubifs uses only lzo
and deflate. ipcomp appears to use only deflate (it also lists lzs and
lzjh but i don't see those implemented anywhere).

you think we should just strip out the 842-nx alignment/sizing code
and change it to fallback to the sw driver?


>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
