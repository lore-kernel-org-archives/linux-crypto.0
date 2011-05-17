From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: fix aesni build on i386
Date: Wed, 18 May 2011 09:03:44 +1000
Message-ID: <20110517230344.GA27291@gondor.apana.org.au>
References: <20110517142749.8927b65b.sfr@canb.auug.org.au> <20110517115245.5544a0d0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, davem@davemloft.net,
	Huang Ying <ying.huang@intel.com>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110517115245.5544a0d0.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 17, 2011 at 11:52:45AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build error on i386 by moving function prototypes:
> 
> arch/x86/crypto/aesni-intel_glue.c: In function 'aesni_init':
> arch/x86/crypto/aesni-intel_glue.c:1263: error: implicit declaration of function 'crypto_fpu_init'
> arch/x86/crypto/aesni-intel_glue.c: In function 'aesni_exit':
> arch/x86/crypto/aesni-intel_glue.c:1373: error: implicit declaration of function 'crypto_fpu_exit'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied.  Thanks Randy!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
