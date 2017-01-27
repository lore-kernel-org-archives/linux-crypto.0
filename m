From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] crypto: camellia: add missing declarations
Date: Fri, 27 Jan 2017 05:31:04 +0000
Message-ID: <20170127053104.GB14974@osadl.at>
References: <1484582811-3505-1-git-send-email-hofrat@osadl.org>
 <20170123140237.GB19957@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170123140237.GB19957@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 23, 2017 at 10:02:37PM +0800, Herbert Xu wrote:
> On Mon, Jan 16, 2017 at 05:06:51PM +0100, Nicholas Mc Guire wrote:
> > Add declarations for the camellia substitution box to allow a clean build.
> > 
> > Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> > ---
> > Problem reported by sparse
> > arch/x86/crypto/camellia_glue.c:65:21: warning: symbol 'camellia_sp10011110' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:154:21: warning: symbol 'camellia_sp22000222' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:243:21: warning: symbol 'camellia_sp03303033' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:332:21: warning: symbol 'camellia_sp00444404' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:421:21: warning: symbol 'camellia_sp02220222' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:510:21: warning: symbol 'camellia_sp30333033' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:599:21: warning: symbol 'camellia_sp44044404' was not declared. Should it be static?
> > arch/x86/crypto/camellia_glue.c:688:21: warning: symbol 'camellia_sp11101110' was not declared. Should it be static?
> > 
> > Patch was compile tested with: x86_64_defconfig +
> > CONFIG_CRYPTO_CAMELLIA_X86_64=m
> > 
> > Patch is against 4.10-rc3 (localversion-next is next-20170116)
> 
> This is arguably a sparse bug.  These variables are only referenced
> by assembly code and already carries the __visible tag.  So sparse
> should learn to suppress this warning when __visible is present.

I had assumed that __visible only would apply to LTO not to non-LTO
builds so the externally_visible attributed would not resolve this 
and thus this warning seems correct.

Is this interpretation incorect ?

thx!
hofrat
