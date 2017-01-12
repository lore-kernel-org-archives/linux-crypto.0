From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Replaced gcc specific attributes with macros
 from compiler.h
Date: Fri, 13 Jan 2017 00:39:31 +0800
Message-ID: <20170112163931.GB20085@gondor.apana.org.au>
References: <1483199783-31588-1-git-send-email-gidisrael@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, nhorman@tuxdriver.com, joe@perches.com,
        akpm@linux-foundation.org
To: gidisrael@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483199783-31588-1-git-send-email-gidisrael@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Dec 31, 2016 at 09:26:23PM +0530, gidisrael@gmail.com wrote:
> From: Gideon Israel Dsouza <gidisrael@gmail.com>
> 
> Continuing from this commit: 52f5684c8e1e
> ("kernel: use macros from compiler.h instead of __attribute__((...))")
> 
> I submitted 4 total patches. They are part of task I've taken up to
> increase compiler portability in the kernel. I've cleaned up the
> subsystems under /kernel /mm /block and /security, this patch targets
> /crypto.
> 
> There is <linux/compiler.h> which provides macros for various gcc specific
> constructs. Eg: __weak for __attribute__((weak)). I've cleaned all
> instances of gcc specific attributes with the right macros for the crypto
> subsystem.
> 
> I had to make one additional change into compiler-gcc.h for the case when
> one wants to use this: __attribute__((aligned) and not specify an alignment
> factor. From the gcc docs, this will result in the largest alignment for
> that data type on the target machine so I've named the macro
> __aligned_largest. Please advise if another name is more appropriate.
> 
> Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
