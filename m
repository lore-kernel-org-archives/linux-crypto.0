Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfADRHw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 12:07:52 -0500
Date: Fri, 4 Jan 2019 09:07:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/16] crypto: pcbc - remove bogus memcpy()s with src ==
 dest
Message-ID: <20190104170748.GA67931@gmail.com>
References: <20190104041625.3259-5-ebiggers@kernel.org>
 <20190104041625.3259-1-ebiggers@kernel.org>
 <11047.1546595833@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11047.1546595833@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 04, 2019 at 09:57:13AM +0000, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > -	u8 *iv = walk->iv;
> > +	u8 * const iv = walk->iv;
> 
> Does adding this const actually gain anything?  (this is done twice)
> 
> David

It makes it clearer what's going on, especially since some modes update the 'iv'
pointer after each block (delaying the copy to 'walk.iv' until the end) but
others can't do that.  The 'const' is helpful to further distinguish these two
cases, which were confused in both the pcbc and cfb implementations.

- Eric
