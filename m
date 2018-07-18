From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 15:17:52 -0400
Message-ID: <20180718191752.GG30706@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
 <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
 <20180718142625.GA5942@thunk.org>
 <822ef031e3589a5cda5972eeeb457bbad69ecde6.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: Yann Droneaud <ydroneaud@opteya.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <822ef031e3589a5cda5972eeeb457bbad69ecde6.camel@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 18, 2018 at 05:29:58PM +0200, Yann Droneaud wrote:
> Sure, but, AFAICT, RDRAND is already in use through arch_get_random_*()
> functions when CONFIG_ARCH_RANDOM is enabled.
> 
> From an outside PoV, there's a conflict: why one would want its kernel
> to use CPU hwrng if one has purposely disabled CONFIG_RANDOM_TRUST_CPU
> ?

Yes, but we use it to mix in RDRAND into the entropy pool.  So we're
not depending solely on RDRAND's output.  The trust model that we're
using is this.  The presumption is that (at least for US-based CPU
manfacturers) the amount of effort needed to add a blatent backdoor
to, say, the instruction scheduler and register management file is
such that it couldn't be done by a single engineer, or even a very
small set of engineers.  Enough people would need to know about it, or
would be able to figure out something untowards was happening, or it
would be obvious through various regression tests, that it would be
obvious if there was a generic back door in the CPU itself.  This is a
good thing, because ultimately we *have* to trust the general purpose
CPU.  If the CPU is actively conspiring against you, there really is
no hope.

However, the RDRAND unit is a small, self-contained thing, which is
*documented* to use an AES whitener (e.g., it does an AES encryption
as its last step).  So presumably, a change to make the RDRAND unit
effectively be:

	AES_ENCRYPT(NSA_KEY, COUNTER++)

Is much easier to hide or introduce.

So that's why people are comfortable using RDRAND mixed into the
output of the entropy pools.  Yes, in theory, if the CPU has
backdoored the XOR instruction if it sees an RDRAND just before it,
you're sunk.  But in if you don't trust the CPU to that level, you
should simply not be using that CPU at all.  Period.

So personally, I probably would never chose to use a CPU that was
manufactured by a company owned or controlled by a PLA general or one
of Putin's Oligarchs.  But I'm not going to tell other people what to
do; they should make their own decisions.

Now, there is one exception to this, and that is the CPU has RDRAND
support, it will use that exclusively for get_random_{u32, u64, int, long}.
But kernel code shouldn't be using this for cryptographic purposes.  If you
need to generate a random key, you should be using get_random_bytes().
get_random_u32, et. al, are designed for things like stack canaries or
TCP sequence numbers.

Regards,

					- Ted
