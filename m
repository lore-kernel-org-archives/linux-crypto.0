From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] x86/crypto/sha256-mb: fix panic due to unaligned
 access
Date: Fri, 3 Nov 2017 21:42:03 +0800
Message-ID: <20171103134203.GA8811@gondor.apana.org.au>
References: <20171016155131.10118-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeffrey Walton <noloader@gmail.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171016155131.10118-1-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 16, 2017 at 06:51:30PM +0300, Andrey Ryabinin wrote:
> struct sha256_ctx_mgr allocated in sha256_mb_mod_init() via kzalloc()
> and later passed in sha256_mb_flusher_mgr_flush_avx2() function where
> instructions vmovdqa used to access the struct. vmovdqa requires
> 16-bytes aligned argument, but nothing guarantees that struct
> sha256_ctx_mgr will have that alignment. Unaligned vmovdqa will
> generate GP fault.
> 
> Fix this by replacing vmovdqa with vmovdqu which doesn't have alignment
> requirements.
> 
> Fixes: a377c6b1876e ("crypto: sha256-mb - submit/flush routines for AVX2")
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: <stable@vger.kernel.org>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
