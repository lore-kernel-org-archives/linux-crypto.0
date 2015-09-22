From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for
 nx842
Date: Tue, 22 Sep 2015 20:21:17 +0800
Message-ID: <20150922122117.GA11522@gondor.apana.org.au>
References: <1442707362.6178.11.camel@hbabu-laptop>
 <20150921142607.GA2405@gondor.apana.org.au>
 <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46284 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbbIVMVe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2015 08:21:34 -0400
Content-Disposition: inline
In-Reply-To: <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 11:21:14AM -0400, Dan Streetman wrote:
> 
> As far as the hw and sw drivers producing the exact same output, I
> don't think that's possible with the current hw and sw drivers,
> because the hw driver may have to add a header to the actual byte
> stream that the hw creates, depending on buffer alignment and size
> (the hw has specific restrictions).  Currently, the sw driver doesn't
> understand that header that the 842 hw driver creates, although that
> could be added to the sw driver.  And, the hw driver skips adding the
> header if the buffers are correctly aligned/sized, which would result
> in a test vector failure if it doesn't align the buffer the same way
> each time.

I guess they don't have to be exactly the same.  As long as each
can take the output of the other and compress/decompress them it
should be fine.

> Also, it might be a good time to add what we talked about a while ago,
> to push the alignment/size restrictions into the crypto compression
> layer, by adding cra_alignmask and cra_blocksize support to
> crypto/compress.c.  Since the 842 hw has requirements not only for
> specific alignment and min/max sizes, but also a requirement for
> specific length multiple (i.e. must be !(len % 8)) it might be
> worthwhile to also add a cra_sizemodulo or something like that.
> However, if the common crypto alignment/size handling code allows any
> alignment/size buffers (instead of just returning error for mis-sized
> buffers), I think a common crypto header would need to be added in
> cases of mis-sizing, which may not be appropriate for common code.
> Alternately, the common crypto code could just return error for
> mis-sized buffers; users of the crypto comp api would just have to
> check crypto_tfm_alg_blocksize() before calling.

I'd like to see another hardware implementation before we start
moving this into the API.

> In case I haven't said it before, I really hate how the 842 hw
> requires specific alignment and sizing.  How hard is it to add support
> for any alignment/size in the hw?!?

Another option is to use a software fallback for the cases that
the hardware can't handle.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
