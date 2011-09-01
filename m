From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Date: Thu, 1 Sep 2011 22:59:02 +0800
Message-ID: <20110901145902.GA31834@gondor.apana.org.au>
References: <20110901133952.GB14522@orbit.nwl.cc> <20110901141445.GA31447@gondor.apana.org.au> <CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, cryptodev-linux-devel@gna.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41907 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab1IAO7M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 10:59:12 -0400
Content-Disposition: inline
In-Reply-To: <CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 01, 2011 at 04:56:56PM +0200, Nikos Mavrogiannopoulos wrote:
> On Thu, Sep 1, 2011 at 4:14 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> 
> > Are you maxing out your submission CPU? If not then you're testing
> > the latency of the interface, as opposed to the throughput.
> 
> I think it is obvious that a benchmark of throughput measures
> throughput. If however, you think that AF_ALG is in disadvantage in
> this benchmark, because it is a high latency interface, you're free to
> propose and perform another one. I haven't seen anywhere how is this
> interface was supposed to be used, nor about its qualities (high
> latency, maybe(?) high throughput or so). Thus, I designed this
> benchmark with a use-case in mind, i.e., a TLS or DTLS tunnel
> executing in a system with such an accelerator. There might be other
> benchmarks with other use cases in mind, but I haven't seen any.

Putting TLS data-path in user-space is always going to be less
than optimal, especially with hardware crypto offload, since you'll
be crossing the user-space/kernel boundary multiple times.

The data-path should reside in the kernel so as to avoid that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
