From: David Miller <davem@davemloft.net>
Subject: Re: sha-512...
Date: Wed, 15 Feb 2012 00:11:13 -0500 (EST)
Message-ID: <20120215.001113.86424501006520715.davem@davemloft.net>
References: <20120214.225833.303014660389989764.davem@davemloft.net>
	<20120215040128.GA8738@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:52377 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2BOFLU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Feb 2012 00:11:20 -0500
In-Reply-To: <20120215040128.GA8738@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 15 Feb 2012 15:01:28 +1100

> On Tue, Feb 14, 2012 at 10:58:33PM -0500, David Miller wrote:
>> 
>> FYI, I just started seeing this on sparc32 after all those
>> sha512 "optimizations":
>> 
>> crypto/sha512_generic.c: In function 'sha512_transform':
>> crypto/sha512_generic.c:135:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> Is that with the latest patch applied?
> 
> 	crypto: sha512 - Avoid stack bloat on i386
> 
> If so then this is not good.

Yes.  And, of course, with that commit reverted it's even worse.
Reverting it makes the stack frame twice as large.

> What was the original stack usage, i.e., if you revert to the
> original percpu code?

If I revert:

commit 3a92d687c8015860a19213e3c102cad6b722f83c
commit 58d7d18b5268febb8b1391c6dffc8e2aaa751fcd
commit 51fc6dc8f948047364f7d42a4ed89b416c6cc0a3
commit 84e31fdb7c797a7303e0cc295cb9bc8b73fb872d

the stackframe goes down to 888 bytes.

More detailed, the progression is:

master						1136
revert 3a92d687c8015860a19213e3c102cad6b722f83c	2408
revert 58d7d18b5268febb8b1391c6dffc8e2aaa751fcd	2408
revert 51fc6dc8f948047364f7d42a4ed89b416c6cc0a3	1520
revert 84e31fdb7c797a7303e0cc295cb9bc8b73fb872d	888
