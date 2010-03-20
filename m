From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Sat, 20 Mar 2010 09:08:49 +0800
Message-ID: <20100320010849.GA30654@gondor.apana.org.au>
References: <20100319234044.GA5127@jenkins> <20100320010115.GA30561@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46483 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301Ab0CTBI4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Mar 2010 21:08:56 -0400
Content-Disposition: inline
In-Reply-To: <20100320010115.GA30561@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Mar 20, 2010 at 09:01:15AM +0800, Herbert Xu wrote:
>
> IIRC modprobe(8) in user-space is supposed to load all dependencies
> prior to loading the main module.  So something must've gone wrong
> before bnx2/bnx2x was loaded.  Please strace it to see why libcrc32c
> wasn't loaded successfully before the kernel ever saw bnx2/bnx2x.

In fact I just tried it on my machine and modprobe bnx2x correctly
loaded libcrc32c + crc32c before loading bnx2x (you don't need the
hardware, it'll stay loaded).  My kernel is 2.6.33-rc8.

I suspect it's a user-space problem.  I'm using module-init-tools
3.4-1 from Debian.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
