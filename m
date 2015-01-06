From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GCM aesni and 192/256-bit keys
Date: Wed, 7 Jan 2015 10:18:41 +1100
Message-ID: <20150106231841.GA23651@gondor.apana.org.au>
References: <20150105100644.GA24595@gondor.apana.org.au>
 <54AACF27.6090300@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51201 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbAFXSp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jan 2015 18:18:45 -0500
Content-Disposition: inline
In-Reply-To: <54AACF27.6090300@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 05, 2015 at 09:51:35AM -0800, Tadeusz Struk wrote:
> On 01/05/2015 02:06 AM, Herbert Xu wrote:
> > 
> > It appears that the GCM aesni implementation does not support
> > 192/256-bit keys.  This is not allowed as accelerated drivers
> > must support everything supported by the software implementation.
> > 
> > Could we add 192/256-bit support to it please? If for some reason
> > this cannot be done then at least implement a software fallback
> > so that it continues to work.

> Yes, you are right. I'll look into it.

While you're at it, can you please run some speed tests to show
that this is actually faster than the generic gcm on top of
ctr-aes-aesni and ghash-clmulni?

If it isn't any faster (it really shouldn't be as far as I can
see) then we can just kill it.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
