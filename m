From: David Miller <davem@davemloft.net>
Subject: Re: sha-512...
Date: Wed, 15 Feb 2012 00:23:52 -0500 (EST)
Message-ID: <20120215.002352.2053362114668441348.davem@davemloft.net>
References: <20120215040128.GA8738@gondor.apana.org.au>
	<20120215.001113.86424501006520715.davem@davemloft.net>
	<20120215051608.GA9126@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, torvalds@linux-foundation.org,
	adobriyan@gmail.com
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:52487 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2BOFX7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Feb 2012 00:23:59 -0500
In-Reply-To: <20120215051608.GA9126@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 15 Feb 2012 16:16:08 +1100

> OK, so we grew by 1136 - 888 = 248.  Keep in mind that 128 of
> that is expected since we moved W onto the stack.

Right.

> I guess we could go back to the percpu solution, what do you
> think?

I'm not entirely sure, we might have to.

sha512 is notorious for generating terrible code with gcc on 32-bit
targets, so...  The sha512 test in the glibc testsuite tends to
timeout on 32-bit sparc. :-)
