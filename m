From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 00/20] crypto: arm64 - play nice with CONFIG_PREEMPT
Date: Wed,  6 Dec 2017 19:43:26 +0000
Message-ID: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
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

This is the second followup 'crypto: arm64 - disable NEON across scatterwalk
API calls' sent out last Friday.

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

As pointed out by Peter, this only solves part of the problem. So let's
tackle it more thoroughly, and update the algorithms to test the NEED_RESCHED
flag each time after processing a fixed chunk of input.

Changes since v2:
- Drop logic to yield only after so many blocks - as it turns out, the
  throughput of the algorithms that are most likely to be affected by the
  overhead (GHASH and AES-CE) only drops by ~1% (on Cortex-A57), and if that
  is inacceptable, you are probably not using CONFIG_PREEMPT in the first
  place. (Speed comparison at the end of this cover letter)
- Add yield support to the AES-CCM driver
- Clean up macros based on feedback from Dave
- Given that I had to add stack frame logic to many of these functions, factor
  it out and wrap it in a couple of macros
- Merge the changes to the core asm driver and glue code of the GHASH/GCM
  driver. The latter was not correct without the former.

Changes since v1:
- add CRC-T10DIF test vector (#1)
- stop using GFP_ATOMIC in scatterwalk API calls, now that they are executed
  with preemption enabled (#2 - #6)
- do some preparatory refactoring on the AES block mode code (#7 - #9)
- add yield patches (#10 - #18)
- add test patch (#19) - DO NOT MERGE

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

Ard Biesheuvel (20):
  crypto: testmgr - add a new test case for CRC-T10DIF
  crypto: arm64/aes-ce-ccm - move kernel mode neon en/disable into loop
  crypto: arm64/aes-blk - move kernel mode neon en/disable into loop
  crypto: arm64/aes-bs - move kernel mode neon en/disable into loop
  crypto: arm64/chacha20 - move kernel mode neon en/disable into loop
  crypto: arm64/aes-blk - remove configurable interleave
  crypto: arm64/aes-blk - add 4 way interleave to CBC encrypt path
  crypto: arm64/aes-blk - add 4 way interleave to CBC-MAC encrypt path
  crypto: arm64/sha256-neon - play nice with CONFIG_PREEMPT kernels
  arm64: assembler: add utility macros to push/pop stack frames
  arm64: assembler: add macros to conditionally yield the NEON under
    PREEMPT
  crypto: arm64/sha1-ce - yield NEON after every block of input
  crypto: arm64/sha2-ce - yield NEON after every block of input
  crypto: arm64/aes-ccm - yield NEON after every block of input
  crypto: arm64/aes-blk - yield NEON after every block of input
  crypto: arm64/aes-bs - yield NEON after every block of input
  crypto: arm64/aes-ghash - yield NEON after every block of input
  crypto: arm64/crc32-ce - yield NEON after every block of input
  crypto: arm64/crct10dif-ce - yield NEON after every block of input
  DO NOT MERGE

 arch/arm64/crypto/Makefile             |   3 -
 arch/arm64/crypto/aes-ce-ccm-core.S    | 150 ++++--
 arch/arm64/crypto/aes-ce-ccm-glue.c    |  47 +-
 arch/arm64/crypto/aes-ce.S             |  15 +-
 arch/arm64/crypto/aes-glue.c           |  95 ++--
 arch/arm64/crypto/aes-modes.S          | 562 +++++++++-----------
 arch/arm64/crypto/aes-neonbs-core.S    | 305 ++++++-----
 arch/arm64/crypto/aes-neonbs-glue.c    |  48 +-
 arch/arm64/crypto/chacha20-neon-glue.c |  12 +-
 arch/arm64/crypto/crc32-ce-core.S      |  44 +-
 arch/arm64/crypto/crct10dif-ce-core.S  |  32 +-
 arch/arm64/crypto/ghash-ce-core.S      | 113 ++--
 arch/arm64/crypto/ghash-ce-glue.c      |  28 +-
 arch/arm64/crypto/sha1-ce-core.S       |  42 +-
 arch/arm64/crypto/sha2-ce-core.S       |  37 +-
 arch/arm64/crypto/sha256-glue.c        |  36 +-
 arch/arm64/include/asm/assembler.h     | 144 +++++
 crypto/testmgr.h                       | 259 +++++++++
 18 files changed, 1275 insertions(+), 697 deletions(-)

-- 
2.11.0



BEFORE
======

testing speed of async ctr(aes) (ctr-aes-ce) encryption
tcrypt: test  0 (128 bit key,   16 byte blocks): 5891675 operations in 1 seconds (  94266800 bytes)
tcrypt: test  1 (128 bit key,   64 byte blocks): 5169493 operations in 1 seconds ( 330847552 bytes)
tcrypt: test  2 (128 bit key,  256 byte blocks): 3430554 operations in 1 seconds ( 878221824 bytes)
tcrypt: test  3 (128 bit key, 1024 byte blocks): 1433293 operations in 1 seconds (1467692032 bytes)
tcrypt: test  4 (128 bit key, 8192 byte blocks):  214314 operations in 1 seconds (1755660288 bytes)
tcrypt: test  5 (192 bit key,   16 byte blocks): 5845561 operations in 1 seconds (  93528976 bytes)
tcrypt: test  6 (192 bit key,   64 byte blocks): 5051812 operations in 1 seconds ( 323315968 bytes)
tcrypt: test  7 (192 bit key,  256 byte blocks): 3135307 operations in 1 seconds ( 802638592 bytes)
tcrypt: test  8 (192 bit key, 1024 byte blocks): 1308804 operations in 1 seconds (1340215296 bytes)
tcrypt: test  9 (192 bit key, 8192 byte blocks):  174947 operations in 1 seconds (1433165824 bytes)
tcrypt: test 10 (256 bit key,   16 byte blocks): 5711495 operations in 1 seconds (  91383920 bytes)
tcrypt: test 11 (256 bit key,   64 byte blocks): 4931516 operations in 1 seconds ( 315617024 bytes)
tcrypt: test 12 (256 bit key,  256 byte blocks): 3057619 operations in 1 seconds ( 782750464 bytes)
tcrypt: test 13 (256 bit key, 1024 byte blocks): 1205799 operations in 1 seconds (1234738176 bytes)
tcrypt: test 14 (256 bit key, 8192 byte blocks):  174553 operations in 1 seconds (1429938176 bytes)

testing speed of async ghash (ghash-ce)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 6043898 opers/sec,  96702368 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 1654308 opers/sec, 105875712 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 4610615 opers/sec, 295079360 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  440479 opers/sec, 112762624 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 1225272 opers/sec, 313669632 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 2282970 opers/sec, 584440320 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  111741 opers/sec, 114422784 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  590457 opers/sec, 604627968 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  781719 opers/sec, 800480256 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   56889 opers/sec, 116508672 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  301876 opers/sec, 618242048 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  392222 opers/sec, 803270656 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  417255 opers/sec, 854538240 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   28383 opers/sec, 116256768 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  152114 opers/sec, 623058944 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  197840 opers/sec, 810352640 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  214064 opers/sec, 876806144 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   14173 opers/sec, 116105216 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   76121 opers/sec, 623583232 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   99424 opers/sec, 814481408 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  107896 opers/sec, 883884032 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  107200 opers/sec, 878182400 bytes/sec

AFTER
=====

testing speed of async ctr(aes) (ctr-aes-ce) encryption
tcrypt: test  0 (128 bit key,   16 byte blocks): 5991064 operations in 1 seconds (  95857024 bytes)
tcrypt: test  1 (128 bit key,   64 byte blocks): 5146397 operations in 1 seconds ( 329369408 bytes)
tcrypt: test  2 (128 bit key,  256 byte blocks): 3398949 operations in 1 seconds ( 870130944 bytes)
tcrypt: test  3 (128 bit key, 1024 byte blocks): 1423337 operations in 1 seconds (1457497088 bytes)
tcrypt: test  4 (128 bit key, 8192 byte blocks):  212705 operations in 1 seconds (1742479360 bytes)
tcrypt: test  5 (192 bit key,   16 byte blocks): 5859040 operations in 1 seconds (  93744640 bytes)
tcrypt: test  6 (192 bit key,   64 byte blocks): 5043498 operations in 1 seconds ( 322783872 bytes)
tcrypt: test  7 (192 bit key,  256 byte blocks): 3117600 operations in 1 seconds ( 798105600 bytes)
tcrypt: test  8 (192 bit key, 1024 byte blocks): 1297050 operations in 1 seconds (1328179200 bytes)
tcrypt: test  9 (192 bit key, 8192 byte blocks):  174041 operations in 1 seconds (1425743872 bytes)
tcrypt: test 10 (256 bit key,   16 byte blocks): 5722483 operations in 1 seconds (  91559728 bytes)
tcrypt: test 11 (256 bit key,   64 byte blocks): 4908481 operations in 1 seconds ( 314142784 bytes)
tcrypt: test 12 (256 bit key,  256 byte blocks): 2969432 operations in 1 seconds ( 760174592 bytes)
tcrypt: test 13 (256 bit key, 1024 byte blocks): 1196411 operations in 1 seconds (1225124864 bytes)
tcrypt: test 14 (256 bit key, 8192 byte blocks):  173121 operations in 1 seconds (1418207232 bytes)

testing speed of async ghash (ghash-ce)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 5756550 opers/sec,  92104800 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 1652111 opers/sec, 105735104 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 4471887 opers/sec, 286200768 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  437829 opers/sec, 112084224 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 1223258 opers/sec, 313154048 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 2274306 opers/sec, 582222336 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  111543 opers/sec, 114220032 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  589121 opers/sec, 603259904 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  768426 opers/sec, 786868224 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   55944 opers/sec, 114573312 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  299002 opers/sec, 612356096 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  387658 opers/sec, 793923584 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  410061 opers/sec, 839804928 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   28007 opers/sec, 114716672 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  150661 opers/sec, 617107456 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  195701 opers/sec, 801591296 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  211312 opers/sec, 865533952 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   14017 opers/sec, 114827264 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   75569 opers/sec, 619061248 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   98301 opers/sec, 805281792 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  106329 opers/sec, 871047168 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  106061 opers/sec, 868851712 bytes/sec
