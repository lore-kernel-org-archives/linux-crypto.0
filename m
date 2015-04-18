From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: Fix aead_{sendmsg,recvmsg}() signatures.
Date: Fri, 17 Apr 2015 23:45:38 -0400 (EDT)
Message-ID: <20150417.234538.847376450312501965.davem@davemloft.net>
References: <20150417.151953.196971237843380420.davem@davemloft.net>
	<20150418013317.GB1329@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49745 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbDRDpl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 23:45:41 -0400
In-Reply-To: <20150418013317.GB1329@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 18 Apr 2015 09:33:17 +0800

> On Fri, Apr 17, 2015 at 03:19:53PM -0400, David Miller wrote:
>> 
>> The kiocb argument is no longer present.
>> 
>> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> I think Linus has already fixed this with
> 
> commit eccd02f32a2c25139da2d5e72ebab1fee7b5baab
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Apr 15 14:09:46 2015 -0700
> 
>     crypto: fix mis-merge with the networking merge

Awesome, thanks Herbert.
