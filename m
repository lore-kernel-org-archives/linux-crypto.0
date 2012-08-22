From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] sparc64: Add AES driver making use of the new aes
 opcodes.
Date: Wed, 22 Aug 2012 14:31:11 -0700 (PDT)
Message-ID: <20120822.143111.2226960299830142976.davem@davemloft.net>
References: <20120822.022118.64713091452626424.davem@davemloft.net>
	<20120822134040.GA7440@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:58301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2HVVbM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Aug 2012 17:31:12 -0400
In-Reply-To: <20120822134040.GA7440@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 22 Aug 2012 21:40:40 +0800

> On Wed, Aug 22, 2012 at 02:21:18AM -0700, David Miller wrote:
>> 
>> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Nice work!
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks for reviewing.

>> Finally I'll probably add support at some point for the crc32c
>> instruction as well.
> 
> That would be very useful, much more so than Kasumi :)

Ok, I'll keep that in mind :-)
