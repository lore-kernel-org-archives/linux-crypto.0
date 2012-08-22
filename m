From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] sparc64: Add AES driver making use of the new aes
 opcodes.
Date: Wed, 22 Aug 2012 21:40:40 +0800
Message-ID: <20120822134040.GA7440@gondor.apana.org.au>
References: <20120822.022118.64713091452626424.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120822.022118.64713091452626424.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 22, 2012 at 02:21:18AM -0700, David Miller wrote:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Nice work!

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
 
> Finally I'll probably add support at some point for the crc32c
> instruction as well.

That would be very useful, much more so than Kasumi :)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
