From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 22:39:14 +0800
Message-ID: <20170110143913.GA3822@gondor.apana.org.au>
References: <20170110143340.GA3787@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110143340.GA3787@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 10, 2017 at 10:33:40PM +0800, Herbert Xu wrote:
> I recently applied the patch
> 
> 	https://patchwork.kernel.org/patch/9468391/
> 
> and ended up with a boot crash when it tried to run the x86 chacha20
> code.  It turned out that the patch changed a manually aligned
> stack buffer to one that is aligned by gcc.  What was happening was
> that gcc can stack align to any value on x86-64 except 16.  The
> reason is that gcc assumes that the stack is always 16-byte aligned,
> which is not actually the case in the kernel.

BTW this is with Debian gcc 4.7.2 which does not allow an 8-byte
stack alignment as attempted by the Makefile:

$ gcc -S -O2 -mno-sse -mpreferred-stack-boundary=3 a.c
a.c:1:0: error: -mpreferred-stack-boundary=3 is not between 4 and 12
$ 

Obviously this is not an issue if your compiler actually allows
the 8-byte alignment.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
