From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 1/2] x86/crypto/sha256-mb: fix panic due to unaligned
 access
Date: Tue, 17 Oct 2017 09:18:59 -0700
Message-ID: <8e4b8f0a-bc36-ae0b-f85d-4a7def031fe9@linux.intel.com>
References: <20171016155131.10118-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeffrey Walton <noloader@gmail.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016155131.10118-1-aryabinin@virtuozzo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/16/2017 08:51 AM, Andrey Ryabinin wrote:
> struct sha256_ctx_mgr allocated in sha256_mb_mod_init() via kzalloc()
> and later passed in sha256_mb_flusher_mgr_flush_avx2() function where
> instructions vmovdqa used to access the struct. vmovdqa requires
> 16-bytes aligned argument, but nothing guarantees that struct
> sha256_ctx_mgr will have that alignment. Unaligned vmovdqa will
> generate GP fault.
> 
> Fix this by replacing vmovdqa with vmovdqu which doesn't have alignment
> requirements.

Using vmovdqu will be a bit slower if the structure is unaligned.
However, flush is done on the non performance critical path so
I don't expect this will be an issue to performance.  

Thanks.

Tim

Acked-by: Tim Chen 

> 
> Fixes: a377c6b1876e ("crypto: sha256-mb - submit/flush routines for AVX2")
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
> index 8fe6338bcc84..16c4ccb1f154 100644
> --- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
> +++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
> @@ -155,8 +155,8 @@ LABEL skip_ %I
>  .endr
>  
>  	# Find min length
> -	vmovdqa _lens+0*16(state), %xmm0
> -	vmovdqa _lens+1*16(state), %xmm1
> +	vmovdqu _lens+0*16(state), %xmm0
> +	vmovdqu _lens+1*16(state), %xmm1
>  
>  	vpminud %xmm1, %xmm0, %xmm2		# xmm2 has {D,C,B,A}
>  	vpalignr $8, %xmm2, %xmm3, %xmm3	# xmm3 has {x,x,D,C}
> @@ -176,8 +176,8 @@ LABEL skip_ %I
>  	vpsubd	%xmm2, %xmm0, %xmm0
>  	vpsubd	%xmm2, %xmm1, %xmm1
>  
> -	vmovdqa	%xmm0, _lens+0*16(state)
> -	vmovdqa	%xmm1, _lens+1*16(state)
> +	vmovdqu	%xmm0, _lens+0*16(state)
> +	vmovdqu	%xmm1, _lens+1*16(state)
>  
>  	# "state" and "args" are the same address, arg1
>  	# len is arg2
> @@ -234,8 +234,8 @@ ENTRY(sha256_mb_mgr_get_comp_job_avx2)
>  	jc	.return_null
>  
>  	# Find min length
> -	vmovdqa	_lens(state), %xmm0
> -	vmovdqa	_lens+1*16(state), %xmm1
> +	vmovdqu	_lens(state), %xmm0
> +	vmovdqu	_lens+1*16(state), %xmm1
>  
>  	vpminud	%xmm1, %xmm0, %xmm2		# xmm2 has {D,C,B,A}
>  	vpalignr $8, %xmm2, %xmm3, %xmm3	# xmm3 has {x,x,D,C}
> 
