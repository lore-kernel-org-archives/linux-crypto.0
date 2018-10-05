From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/9] patchable function pointers for pluggable crypto routines
Date: Fri,  5 Oct 2018 10:13:24 +0200
Message-ID: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Linux's crypto API is widely regarded as being difficult to use for cases
where support for asynchronous accelerators or runtime dispatch of algorithms
(i.e., passed in as a string) are not needed. This leads to kludgy code and
also to actual security issues [0], although arguably, using AES in the wrong
mode can be done using any kind of crypto abstraction.

At the moment, the Zinc library [1] is being proposed as a solution for that,
and while it does address the usability problems, it does a lot more than
that, and what we end up with is a lot less flexible than what we have now.

Currently, arch specific implementations (based on SIMD or optimized
assembler) live in arch/*/crypto, where each sub-community is in charge
of its own specialized versions of the various primitives (although still
under the purview of the crypto maintainer). Any proposal to change this
model should be judged on its own merit, and not blindly accepted as the
fallout of cleaning up some library code.

Also, Zinc removes the possibility to plug different versions of a routine,
and instead, keeps all versions in the same module. Currently, the kernel's
module support permits user land to take charge of the policies that decide
which version to use in which context (by loading or blacklisting modules).
Instead, Zinc moves to a model where the policy is hardcoded into the module
(e.g., ChaCha20 on ARM uses NEON unless on Cortex-A5 or A7). In the ARM
community, we have always attempted to avoid hardcoding policy like that:
the ARM SoC space is a very heteregeneous one, and putting policy like that
into the code will lead to an endless stream of patches from silicon vendors
that want tweaks for their cores into various parts of the kernel.

Creating monolithic modules for algorithms also makes it very difficult to
support driver based implementations. The kernel's driver model is heavily
based on modules, using alias strings to match drivers against the hardware.
As an example, there ARM ST platforms that support synchronous hardware based
CRC32, and plugging that into the monolithic Zinc model is difficult if not
impossible.

The primary justification for moving away from the module system is that it
depends heavily on function pointers, and in the post-Spectre world, those
are vulnerable and costly. For this reason, this series proposes a patchable
function pointer abstraction that, in its generic incarnation, consists
simply of function pointers and some plumbing to set or reset them (patch #1)

Patch #2 illustrates how architectures could optimize these abstractions by
using code patching techniques to get rid of the indirect calls, and use
fixed jumps instead. This has the side effect of making the function
pointer const, making it more robust as well.

The remainder of the series shows how we can use this abstraction to clean
up the CRC-T10DIF handling in the kernel, which is a pretty depressing
example of how cumbersome it is to expose crypto API algorithms as library
routines.

Note that the various arch specific implementations are kept in their
original place as modules, which can be automatically dispatched by udev
(as before) based on CPU feature bits.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org

[0] commit 428490e38b2e ("security/keys: rewrite all of big_key crypto")
[1] https://lore.kernel.org/lkml/20180925145622.29959-3-Jason@zx2c4.com/

Ard Biesheuvel (9):
  kernel: add support for patchable function pointers
  arm64: kernel: add arch support for patchable function pointers
  crypto: crc-t10dif - make crc_t10dif a static inline
  crypto: crc-t10dif - use patchable function pointer for core update
    routine
  crypto: crc-t10dif/arm64 - move PMULL based code into core library
  crypto: crc-t10dif/arm - move PMULL based code into core library
  crypto: crct10dif/generic - switch crypto API driver to core library
  crypto: crc-t10dif/powerpc - move PMULL based code into core library
  crypto: crc-t10dif/x86 - move PMULL based code into core library

 arch/Kconfig                                |   3 +
 arch/arm/crypto/crct10dif-ce-glue.c         |  78 +++-------
 arch/arm64/Kconfig                          |   1 +
 arch/arm64/crypto/crct10dif-ce-glue.c       |  61 ++------
 arch/arm64/include/asm/ffp.h                |  35 +++++
 arch/arm64/kernel/insn.c                    |  22 +++
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c |  55 +-------
 arch/x86/crypto/crct10dif-pclmul_glue.c     |  98 ++-----------
 crypto/Kconfig                              |   1 +
 crypto/Makefile                             |   2 +-
 crypto/crct10dif_common.c                   |  82 -----------
 crypto/crct10dif_generic.c                  |   4 +-
 include/linux/crc-t10dif.h                  |  24 +++-
 include/linux/ffp.h                         |  43 ++++++
 lib/Kconfig                                 |   2 -
 lib/crc-t10dif.c                            | 149 +++++++-------------
 16 files changed, 235 insertions(+), 425 deletions(-)
 create mode 100644 arch/arm64/include/asm/ffp.h
 delete mode 100644 crypto/crct10dif_common.c
 create mode 100644 include/linux/ffp.h

-- 
2.11.0
