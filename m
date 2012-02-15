From: David Miller <davem@davemloft.net>
Subject: Re: sha-512...
Date: Wed, 15 Feb 2012 16:00:10 -0500 (EST)
Message-ID: <20120215.160010.95041058128954427.davem@davemloft.net>
References: <20120215051608.GA9126@gondor.apana.org.au>
	<20120215.002352.2053362114668441348.davem@davemloft.net>
	<20120215192751.GA27144@p183.telecom.by>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org
To: adobriyan@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:60663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2BOVAY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Feb 2012 16:00:24 -0500
In-Reply-To: <20120215192751.GA27144@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Wed, 15 Feb 2012 22:27:52 +0300

> On Wed, Feb 15, 2012 at 12:23:52AM -0500, David Miller wrote:
>> From: Herbert Xu <herbert@gondor.hengli.com.au>
>> Date: Wed, 15 Feb 2012 16:16:08 +1100
>> 
>> > OK, so we grew by 1136 - 888 = 248.  Keep in mind that 128 of
>> > that is expected since we moved W onto the stack.
>> 
>> Right.
>> 
>> > I guess we could go back to the percpu solution, what do you
>> > think?
>> 
>> I'm not entirely sure, we might have to.
>> 
>> sha512 is notorious for generating terrible code with gcc on 32-bit
>> targets, so...  The sha512 test in the glibc testsuite tends to
>> timeout on 32-bit sparc. :-)
> 
> Cherrypicking ror64() commit largely fixes the issue (on sparc-defconfig):
> 
> 	00000000 <sha512_transform>:
> 	       0:       9d e3 bc 78     save  %sp, -904, %sp
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> b85a088f15f2070b7180735a231012843a5ac96c
> "crypto: sha512 - use standard ror64()"

I'm happy with a solution that involves pushing this change to Linus's
tree, it's pretty clear why it helps so much although I'm disappointed
that gcc can't se that the u64 shift argument passed in is always a
constant and therefore way within the range of a 32-bit value, ho hum
:-)

In fact, in my tree, this change brings the stack allocation instruction
down to:

        save    %sp, -824, %sp  !

which is actually BETTER than what the old per-cpu code got:

        save    %sp, -984, %sp  !

Therefore I highly recommend we apply that ror() change to Linus's
tree now. :-)
