From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: random: Wake up all getrandom(2) callers when pool is ready
Date: Fri, 22 May 2015 08:23:08 +0800
Message-ID: <20150522002302.GC29073@gondor.apana.org.au>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
 <12904468.qCSNRrkb6t@tachyon.chronox.de>
 <20150520214408.GA17264@gondor.apana.org.au>
 <9182932.rX0DhQWPrJ@tachyon.chronox.de>
 <20150521081953.GA22301@gondor.apana.org.au>
 <20150521191739.GP2871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150521191739.GP2871@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 21, 2015 at 03:17:39PM -0400, Theodore Ts'o wrote:
>
> Yes, this should definitely be wake_up_all()

Thanks for the confirmation.  Can I push this patch through the
cryptodev tree since Stephan's work is probably going to depend
on it?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
