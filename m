From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni - Use unaligned loads from gcm_context_data
Date: Sat, 25 Aug 2018 21:28:01 +0800
Message-ID: <20180825132801.fnsr72cx4s2ohovy@gondor.apana.org.au>
References: <20180815172942.mkk56gh6poqgjgnb@davejwatson-mba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mauro Rossi <issor.oruam@gmail.com>, linux-crypto@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180815172942.mkk56gh6poqgjgnb@davejwatson-mba.local>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 15, 2018 at 10:29:42AM -0700, Dave Watson wrote:
> A regression was reported bisecting to 1476db2d12
> "Move HashKey computation from stack to gcm_context".  That diff
> moved HashKey computation from the stack, which was explicitly aligned
> in the asm, to a struct provided from the C code, depending on
> AESNI_ALIGN_ATTR for alignment.   It appears some compilers may not
> align this struct correctly, resulting in a crash on the movdqa
> instruction when attempting to encrypt or decrypt data.
> 
> Fix by using unaligned loads for the HashKeys.  On modern
> hardware there is no perf difference between the unaligned and
> aligned loads.  All other accesses to gcm_context_data already use
> unaligned loads.
> 
> Reported-by: Mauro Rossi <issor.oruam@gmail.com>
> Fixes: 1476db2d12 ("Move HashKey computation from stack to gcm_context")
> Signed-off-by: Dave Watson <davejwatson@fb.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
