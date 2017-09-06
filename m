From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 06/12] x86/crypto: Fix RBP usage in sha1_avx2_x86_64_asm.S
Date: Wed, 6 Sep 2017 09:11:55 -0700
Message-ID: <42e729e6-ef1e-9ab5-f3af-2daad017384e@linux.intel.com>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <12db8df183584a6c605d233c22b1ca0a19e08c56.1504029132.git.jpoimboe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30738 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbdIFQMD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 12:12:03 -0400
In-Reply-To: <12db8df183584a6c605d233c22b1ca0a19e08c56.1504029132.git.jpoimboe@redhat.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/29/2017 11:05 AM, Josh Poimboeuf wrote:
> Using RBP as a temporary register breaks frame pointer convention and
> breaks stack traces when unwinding from an interrupt in the crypto code.
> 
> Use R11 instead of RBP.  Since R11 isn't a callee-saved register, it
> doesn't need to be saved and restored on the stack.

These changes seem okay.

Thanks.

Tim

> 
> Reported-by: Eric Biggers <ebiggers@google.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> index 1eab79c9ac48..9f712a7dfd79 100644
> --- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> +++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> @@ -89,7 +89,7 @@
>  #define	REG_RE	%rdx
>  #define	REG_RTA	%r12
>  #define	REG_RTB	%rbx
> -#define	REG_T1	%ebp
> +#define	REG_T1	%r11d
>  #define	xmm_mov	vmovups
>  #define	avx2_zeroupper	vzeroupper
>  #define	RND_F1	1
> @@ -637,7 +637,6 @@ _loop3:
>  	ENTRY(\name)
>  
>  	push	%rbx
> -	push	%rbp
>  	push	%r12
>  	push	%r13
>  	push	%r14
> @@ -673,7 +672,6 @@ _loop3:
>  	pop	%r14
>  	pop	%r13
>  	pop	%r12
> -	pop	%rbp
>  	pop	%rbx
>  
>  	ret
> 
