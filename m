From: David Miller <davem@davemloft.net>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Fri, 06 May 2016 15:52:46 -0400 (EDT)
Message-ID: <20160506.155246.1005161410295236920.davem@davemloft.net>
References: <20160504040731.GA25758@gondor.apana.org.au>
	<CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
	<20160505084249.GA4971@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: matorola@gmail.com, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, nicstange@gmail.com
To: herbert@gondor.apana.org.au
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20160505084249.GA4971@gondor.apana.org.au>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 5 May 2016 16:42:49 +0800

> Subject: crypto: testmgr - Use kmalloc memory for RSA input
> 
> As akcipher uses an SG interface, you must not use vmalloc memory
> as input for it.  This patch fixes testmgr to copy the vmalloc
> test vectors to kmalloc memory before running the test.
> 
> This patch also removes a superfluous sg_virt call in do_test_rsa.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Anatoly Pugachev <matorola@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I'm really surprised this didn't trigger on non-sparc64 systems, but
what do I know :-)
