From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Wed, 20 May 2015 11:06:42 -0400
Message-ID: <20150520150642.GJ2871@thunk.org>
References: <477328243.LmeEDk1ili@tauon>
 <20150518225807.GA25931@gondor.apana.org.au>
 <CACXcFmnZw9eS1EuokG54OYgCXnju2iD2q2o9miWmQMab5SJmDQ@mail.gmail.com>
 <3005024.K2tYVGR0qE@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47861 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbETPGp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 11:06:45 -0400
Content-Disposition: inline
In-Reply-To: <3005024.K2tYVGR0qE@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 20, 2015 at 08:29:19AM +0200, Stephan Mueller wrote:
> 
> But I see that such a change may not be warranted at this
> point. Though, I see that discussion may rise again in the future
> when such new requirements for 256 bit keys (not only AES, thanks
> Sandy for mentioning :-) ) are commonly raised.

Given that you would need a 15,360-bit RSA key to have a key strength
equivalent to a 256-bit key (and a 3072-bit RSA key is equivalent to
128-bit symmetric keys, and there are plenty of people still using
2048-bit keys), permit me to be a little skeptical about the value of
256 bit keys for anything other than marketing value...

If you trust ECC, you'd "only" need a 7,680 bit ECC key.  But the ECC
curves under discussion today are (at least) an order of magnitude
smaller.

And if it's just to make gullible rubes feel safer, I don't see the
real point of non-blocking random pool threshold larger than the
safety of the whole system is constrainted by public key crypto.

> So, let us disregard the patch until hard requirements are coming up.

Sounds like a fine idea to me.

              				- Ted
