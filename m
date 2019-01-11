Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbfAKR6g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 12:58:36 -0500
Date: Fri, 11 Jan 2019 09:58:34 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 00/16] crypto: skcipher template simplifications and
 conversions
Message-ID: <20190111175833.GA77447@gmail.com>
References: <20190104041625.3259-1-ebiggers@kernel.org>
 <20190111063358.pjm776fanp4dspvl@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111063358.pjm776fanp4dspvl@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 11, 2019 at 02:33:58PM +0800, Herbert Xu wrote:
> On Thu, Jan 03, 2019 at 08:16:09PM -0800, Eric Biggers wrote:
> > Hello,
> > 
> > This series adds a function skcipher_alloc_instance_simple() that
> > greatly simplifies creating an skcipher_instance that uses a single
> > underlying block cipher.  It then converts the cbc, cfb, ctr, ecb, kw,
> > ofb, and pcbc templates to use it.  In doing so, ctr, ecb, and kw are
> > also converted from the deprecated "blkcipher" API to the skcipher API.
> > 
> > While doing this, I also found some rather silly bugs in the cfb, ofb,
> > and pcbc templates...  So I've included the fixes for these first, in
> > patches 1-4.  Please consider taking these first 4 patches through
> > 'crypto' rather than 'cryptodev'.  (But 5-16 are cleanups only, so no
> > rush on those.)
> 
> I have decided to push all of these through cryptodev because
> it's not clear whether the first four bug fixes are serious enough 
> to warrant going through straight away.  If I'm wrong please let
> me know.
> 

I'm fine with cryptodev.

- Eric
