From: Mathias Krause <mathias.krause@secunet.com>
Subject: Re: [PATCH] padata: make the sequence counter an atomic_t
Date: Fri, 25 Oct 2013 10:20:48 +0200
Message-ID: <526A29E0.8070204@secunet.com>
References: <1380721245-5215-1-git-send-email-mathias.krause@secunet.com> <20131008120824.GN7660@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:35383 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab3JYIUv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Oct 2013 04:20:51 -0400
In-Reply-To: <20131008120824.GN7660@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08.10.2013 14:08, Steffen Klassert wrote:
> On Wed, Oct 02, 2013 at 03:40:45PM +0200, Mathias Krause wrote:
>> Using a spinlock to atomically increase a counter sounds wrong -- we've
>> atomic_t for this!
>>
>> Also move 'seq_nr' to a different cache line than 'lock' to reduce cache
>> line trashing. This has the nice side effect of decreasing the size of
>> struct parallel_data from 192 to 128 bytes for a x86-64 build, e.g.
>> occupying only two instead of three cache lines.
>>
>> Those changes results in a 5% performance increase on an IPsec test run
>> using pcrypt.
>>
>> Btw. the seq_lock spinlock was never explicitly initialized -- one more
>> reason to get rid of it.
>>
>> Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> Herbert can you take this one?

Ping, Herbert? Anything wrong with the patch?
