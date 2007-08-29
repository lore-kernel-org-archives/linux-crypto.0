From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: Re: [Cbe-oss-dev] [patch 1/1] spufs: SPU-AES support
	(kspu+ablkcipher user)
Date: Wed, 29 Aug 2007 11:09:18 +0200
Message-ID: <20070829090918.GA24782@Chamillionaire.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc> <20070816200137.867399000@ml.breakpoint.cc> <20070828154637.GA21007@Chamillionaire.breakpoint.cc> <18132.43463.753224.982580@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>, cbe-oss-dev@ozlabs.org,
	linux-crypto@vger.kernel.org, arnd@arndb.de, jk@ozlabs.org
To: Paul Mackerras <paulus@samba.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48274 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbXH2JJb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 05:09:31 -0400
Content-Disposition: inline
In-Reply-To: <18132.43463.753224.982580@cargo.ozlabs.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Paul Mackerras | 2007-08-29 09:03:35 [+1000]:

>Sebastian Siewior writes:
>
>> CBC has one limitiation: The IV is written back in the notification
>> callback. That means that it is not available for crypto requests that
>> depend on the previous IV (as well as crypto requests >16 KiB). Herbert Xu
>> pointer out, that this is currently not the case. For instance:
>> - IPsec brings its own IV on with every packet. A packet is usually <=
>> 	1500 bytes. Jumbo frames should not exceed 16 KiB.
>> - EcryptFS changes the IV on page bassis (every enc/dec request is
>> 	PAGE_SIZE long).
>
>The page size could be 64kB.

Yes, I am aware of this. That's why I mentioned it here. The only way
way how I could fix it is by caching the IV the same/similar way I do
it for the key. I had no time to implement this so far and it should not
break IPsec or EcryptFS if you don't force it :)

>Paul.

Sebastian
