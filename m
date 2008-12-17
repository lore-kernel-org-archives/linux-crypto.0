From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI instructions
Date: Wed, 17 Dec 2008 14:39:58 +1100
Message-ID: <20081217033958.GA13219@gondor.apana.org.au>
References: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au> <1229484819.5936.337.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	"linux-crypto@ml.breakpoint.cc" <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45353 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751757AbYLQDkL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Dec 2008 22:40:11 -0500
Content-Disposition: inline
In-Reply-To: <1229484819.5936.337.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 17, 2008 at 11:33:39AM +0800, Huang Ying wrote:
> 
> - Now an AES core block algorithm is implemented with AES-NI as
> CRYPTO_ALG_TYPE_CIPHER, which can benefit all modes (CBC, LRW, etc). But
> because it seems that there is no asynchronous interface for
> CRYPTO_ALG_TYPE_CIPHER, the AES core block algorithm can not use a
> thread to defer real operations.
> 
> - To take full advantage of AES-NI pipeline implementation, at least
> "cbc(aes)", "ecb(aes)" and "ctr(aes)" should be implemented as
> CRYPTO_ALG_TYPE_ABLKCIPHER. So a thread can be used to defer real
> operation upon soft_irq.
> 
> Because the combination that kernel process context FPU usage + soft_irq
> AES usage is fairly rare, I think the above combination is acceptable.
> That is,
> 
> - In AES core block algorithm implementation with AES-NI, use x86_64
> implementation for the combination above.
> 
> - In "cbc(aes)", "ecb(aes)" and "ctr(aes)", use thread deferring for the
> combination above.

Yes that's pretty much what I'd like to see.

Ideally we should implement all the commonly used modes of
oeprations so that the simple AES cipher itself is never used
except on small chunks of data.  However, for now I think doing
just cbc should be sufficient since that's the most common use
case.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
