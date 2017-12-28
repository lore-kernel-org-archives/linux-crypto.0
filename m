From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/twofish-3way - Fix %rbp usage
Date: Thu, 28 Dec 2017 18:02:22 +1100
Message-ID: <20171228070222.GB9639@gondor.apana.org.au>
References: <001a113f2cd26f3532055f0f4a79@google.com>
 <20171219004026.170565-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219004026.170565-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 18, 2017 at 04:40:26PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Using %rbp as a temporary register breaks frame pointer convention and
> breaks stack traces when unwinding from an interrupt in the crypto code.
> 
> In twofish-3way, we can't simply replace %rbp with another register
> because there are none available.  Instead, we use the stack to hold the
> values that %rbp, %r11, and %r12 were holding previously.  Each of these
> values represents the half of the output from the previous Feistel round
> that is being passed on unchanged to the following round.  They are only
> used once per round, when they are exchanged with %rax, %rbx, and %rcx.
> 
> As a result, we free up 3 registers (one per block) and can reassign
> them so that %rbp is not used, and additionally %r14 and %r15 are not
> used so they do not need to be saved/restored.
> 
> There may be a small overhead caused by replacing 'xchg REG, REG' with
> the needed sequence 'mov MEM, REG; mov REG, MEM; mov REG, REG' once per
> round.  But, counterintuitively, when I tested "ctr-twofish-3way" on a
> Haswell processor, the new version was actually about 2% faster.
> (Perhaps 'xchg' is not as well optimized as plain moves.)
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
