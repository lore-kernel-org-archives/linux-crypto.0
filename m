From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/5] crypto: arm64 - disable NEON across scatterwalk API calls
Date: Fri,  1 Dec 2017 21:19:22 +0000
Message-ID: <20171201211927.24653-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-rt-users-owner@vger.kernel.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

As reported by Sebastian, the way the arm64 NEON crypto code currently
keeps kernel mode NEON enabled across calls into skcipher_walk_xxx() is
causing problems with RT builds, given that the skcipher walk API may
allocate and free temporary buffers it uses to present the input and
output arrays to the crypto algorithm in blocksize sized chunks (where
blocksize is the natural blocksize of the crypto algorithm), and doing
so with NEON enabled means we're alloc/free'ing memory with preemption
disabled.

This was deliberate: when this code was introduced, each kernel_neon_begin()
and kernel_neon_end() call incurred a fixed penalty of storing resp.
loading the contents of all NEON registers to/from memory, and so doing
it less often had an obvious performance benefit. However, in the mean time,
we have refactored the core kernel mode NEON code, and now kernel_neon_begin()
only incurs this penalty the first time it is called after entering the kernel,
and the NEON register restore is deferred until returning to userland. This
means pulling those calls into the loops that iterate over the input/output
of the crypto algorithm is not a big deal anymore (although there are some
places in the code where we relied on the NEON registers retaining their
values between calls)

So let's clean this up for arm64: update the NEON based skcipher drivers to
no longer keep the NEON enabled when calling into the skcipher walk API.

Note that the remaining crypto drivers simply operate on fixed buffers, so
while the RT crowd may still feel the need to disable those (and the ones
below as well, perhaps), they don't call back into the crypto layer like
the ones updated by this series, and so there's no room for improvement
there AFAICT.

Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-rt-users@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

Ard Biesheuvel (5):
  crypto: arm64/aes-ce-ccm - move kernel mode neon en/disable into loop
  crypto: arm64/aes-blk - move kernel mode neon en/disable into loop
  crypto: arm64/aes-bs - move kernel mode neon en/disable into loop
  crypto: arm64/chacha20 - move kernel mode neon en/disable into loop
  crypto: arm64/ghash - move kernel mode neon en/disable into loop

 arch/arm64/crypto/aes-ce-ccm-glue.c    | 47 +++++-----
 arch/arm64/crypto/aes-glue.c           | 81 +++++++++---------
 arch/arm64/crypto/aes-modes.S          | 90 ++++++++++----------
 arch/arm64/crypto/aes-neonbs-glue.c    | 38 ++++-----
 arch/arm64/crypto/chacha20-neon-glue.c |  4 +-
 arch/arm64/crypto/ghash-ce-glue.c      |  9 +-
 6 files changed, 132 insertions(+), 137 deletions(-)

-- 
2.11.0

