From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Fri, 1 Sep 2017 17:09:19 -0700
Message-ID: <20170902000919.GA139193@gmail.com>
References: <cover.1504029132.git.jpoimboe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1504029132.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Josh,

On Tue, Aug 29, 2017 at 01:05:33PM -0500, Josh Poimboeuf wrote:
> Many of the x86 crypto functions use RBP as a temporary register.  This
> breaks frame pointer convention, and breaks stack traces when unwinding
> from an interrupt in the crypto code.
> 
> Convert most* of them to leave RBP alone.
> 
> These pass the crypto boot tests for me.  Any further testing would be
> appreciated!
> 
> [*] There are still a few crypto files left that need fixing, but the
>     fixes weren't trivial and nobody reported unwinder warnings about
>     them yet, so I'm skipping them for now.
> 
> Josh Poimboeuf (12):
>   x86/crypto: Fix RBP usage in blowfish-x86_64-asm_64.S
>   x86/crypto: Fix RBP usage in camellia-x86_64-asm_64.S
>   x86/crypto: Fix RBP usage in cast5-avx-x86_64-asm_64.S
>   x86/crypto: Fix RBP usage in cast6-avx-x86_64-asm_64.S
>   x86/crypto: Fix RBP usage in des3_ede-asm_64.S
>   x86/crypto: Fix RBP usage in sha1_avx2_x86_64_asm.S
>   x86/crypto: Fix RBP usage in sha1_ssse3_asm.S
>   x86/crypto: Fix RBP usage in sha256-avx-asm.S
>   x86/crypto: Fix RBP usage in sha256-avx2-asm.S
>   x86/crypto: Fix RBP usage in sha256-ssse3-asm.S
>   x86/crypto: Fix RBP usage in sha512-avx2-asm.S
>   x86/crypto: Fix RBP usage in twofish-avx-x86_64-asm_64.S
> 

Thanks for fixing these!  I don't have time to review these in detail, but I ran
the crypto self-tests on the affected algorithms, and they all pass.  I also
benchmarked them before and after; the only noticable performance difference was
that sha256-avx2 and sha512-avx2 became a few percent slower.  I don't suppose
there is a way around that?  Otherwise it's probably not a big deal.

For reference, this was the list of affected algorithms I used:

shash: sha1-ssse3, sha1-avx, sha1-avx2, sha256-ssse3, sha256-avx, sha256-avx2,
	sha512-ssse3, sha512-avx, sha512-avx2

cipher: blowfish-asm, camellia-asm, des3_ede-asm

skcipher: ecb-blowfish-asm, cbc-blowfish-asm, ctr-blowfish-asm, ecb-cast5-avx,
	cbc-cast5-avx, ctr-cast5-avx, ecb-cast6-avx, cbc-cast6-avx, ctr-cast6-avx,
	lrw-cast6-avx, xts-cast6-avx, ecb-camellia-asm, cbc-camellia-asm,
	ctr-camellia-asm, lrw-camellia-asm, xts-camellia-asm, ecb-des3_ede-asm,
	cbc-des3_ede-asm, ctr-des3_ede-asm, ecb-twofish-avx, cbc-twofish-avx,
	ctr-twofish-avx, lrw-twofish-avx, xts-twofish-avx

Eric
