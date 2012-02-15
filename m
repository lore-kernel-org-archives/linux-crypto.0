From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: sha-512...
Date: Wed, 15 Feb 2012 22:27:52 +0300
Message-ID: <20120215192751.GA27144@p183.telecom.by>
References: <20120215040128.GA8738@gondor.apana.org.au>
 <20120215.001113.86424501006520715.davem@davemloft.net>
 <20120215051608.GA9126@gondor.apana.org.au>
 <20120215.002352.2053362114668441348.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32862 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2BOT16 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Feb 2012 14:27:58 -0500
Received: by bkcjm19 with SMTP id jm19so1292167bkc.19
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2012 11:27:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20120215.002352.2053362114668441348.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 15, 2012 at 12:23:52AM -0500, David Miller wrote:
> From: Herbert Xu <herbert@gondor.hengli.com.au>
> Date: Wed, 15 Feb 2012 16:16:08 +1100
> 
> > OK, so we grew by 1136 - 888 = 248.  Keep in mind that 128 of
> > that is expected since we moved W onto the stack.
> 
> Right.
> 
> > I guess we could go back to the percpu solution, what do you
> > think?
> 
> I'm not entirely sure, we might have to.
> 
> sha512 is notorious for generating terrible code with gcc on 32-bit
> targets, so...  The sha512 test in the glibc testsuite tends to
> timeout on 32-bit sparc. :-)

Cherrypicking ror64() commit largely fixes the issue (on sparc-defconfig):

	00000000 <sha512_transform>:
	       0:       9d e3 bc 78     save  %sp, -904, %sp

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
b85a088f15f2070b7180735a231012843a5ac96c
"crypto: sha512 - use standard ror64()"
