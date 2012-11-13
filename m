From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: cast5/cast6 - move lookup tables to shared
 module
Date: Tue, 13 Nov 2012 14:52:46 -0500 (EST)
Message-ID: <20121113.145246.1782542703964753357.davem@davemloft.net>
References: <20121113094314.23872.30309.stgit@localhost6.localdomain6>
	<20121113.135304.281580343771830320.davem@davemloft.net>
	<20121113215020.841366cnfloetcsg@www.dalek.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:48695 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMTws (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 14:52:48 -0500
In-Reply-To: <20121113215020.841366cnfloetcsg@www.dalek.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 13 Nov 2012 21:50:20 +0200

> Quoting David Miller <davem@davemloft.net>:
> 
>> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> Date: Tue, 13 Nov 2012 11:43:14 +0200
>>
>>> CAST5 and CAST6 both use same lookup tables, which can be moved shared
>>> module
>>> 'cast_common'.
>>>
>>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>>
>> Does this work if you make CAST5 modular and CAST6 static, or vice
>> versa?
>>
> 
> Yes, dependencies force common module to be built-in/static in both
> cases and will be build as module only if both cast5 and cast6 are
> also.

Fair enough:

Acked-by: David S. Miller <davem@davemloft.net>
