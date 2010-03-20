From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Sat, 20 Mar 2010 09:01:15 +0800
Message-ID: <20100320010115.GA30561@gondor.apana.org.au>
References: <20100319234044.GA5127@jenkins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59990 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628Ab0CTBBX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Mar 2010 21:01:23 -0400
Content-Disposition: inline
In-Reply-To: <20100319234044.GA5127@jenkins>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 19, 2010 at 04:40:45PM -0700, Brandon Philips wrote:
>
> Possible solutions:
> 
> 1) Figure out the right place to drop the module_lock while waiting on
> other modules to load. This boots and seems to work but who knows what
> it will break. :) This might be the right fix after investigating
> possible issues.

I'm not sure that this is the problem.

IIRC modprobe(8) in user-space is supposed to load all dependencies
prior to loading the main module.  So something must've gone wrong
before bnx2/bnx2x was loaded.  Please strace it to see why libcrc32c
wasn't loaded successfully before the kernel ever saw bnx2/bnx2x.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
