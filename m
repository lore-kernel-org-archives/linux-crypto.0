From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] sparc64: Add CRC32C driver making use of the new
 crc32c opcode.
Date: Thu, 23 Aug 2012 16:36:54 +0800
Message-ID: <20120823083654.GA13395@gondor.apana.org.au>
References: <20120822.022118.64713091452626424.davem@davemloft.net>
 <20120822134040.GA7440@gondor.apana.org.au>
 <20120822.143111.2226960299830142976.davem@davemloft.net>
 <20120822.205231.113785660704668571.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120822.205231.113785660704668571.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 22, 2012 at 08:52:31PM -0700, David Miller wrote:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Looks good to me.

> This was largely straightforward, except for two things.
> 
> 1) The tests assume that the 32-bit crc is stored in the context in
>    cpu endian.  The sparc64 crc32c opcode wants to work with a little
>    endian mode, but sparc64 is big-endian.

We can still change this as nothing outside the kernel relies
on the format of the context.  For the time being all that's
required is that it be identical between software and hardware
implementations.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
