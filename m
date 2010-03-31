From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Thu, 1 Apr 2010 09:55:45 +1030
Message-ID: <201004010955.45284.rusty@rustcorp.com.au>
References: <20100320010849.GA30654@gondor.apana.org.au> <201003300936.58300.rusty@rustcorp.com.au> <20100331190351.GG25587@jenkins.home.ifup.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Tim Abbott <tabbott@mit.edu>
To: Brandon Philips <brandon@ifup.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:38197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab0CaXZs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Mar 2010 19:25:48 -0400
In-Reply-To: <20100331190351.GG25587@jenkins.home.ifup.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 1 Apr 2010 05:33:51 am Brandon Philips wrote:
> On 09:36 Tue 30 Mar 2010, Rusty Russell wrote:
> > The real fix here is to drop the lock, like Brandon suggested, but
> > we need to do it more carefully: when we re-acquire the lock we need
> > to re-lookup the symbol in case the module has vanished or changed.
> > 
> > Brandon, I can't see how libcrc32c's module_init calls
> > crypto_alloc_shash, but the problem is reproducible with simple
> > example modules.  Does it fix your problem?
> 
> Did you see my email yesterday explaining how this came about? Does
> that answer your question?

Yep, thanks.

> Reviewed the patch and it looks good and I tested it on the machine
> and it works. A couple of trivial things inline below if you care.
> 
> Signed-off-by: Brandon Philips <brandon@ifup.org>
> Cc: stable@kernel.org
> 
> Thanks Rusty.

Thanks; already had the two caught by checkpatch; changing the other
printk is not something I like to do in the same patch.

Thanks!
Rusty.
