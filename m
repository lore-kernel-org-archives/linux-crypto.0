From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v5 00/23] crypto: arm64 - play nice with CONFIG_PREEMPT
Date: Sun, 11 Mar 2018 08:55:09 +0000
Message-ID: <CAKv+Gu9scoJo=MVXyavCthF6Y0eAQc0MSQwy7fRMzSd8Wv3a4A@mail.gmail.com>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
 <DB7PR04MB4252A16D177E13E1A26D1F788BDC0@DB7PR04MB4252.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Dave Martin <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
To: Vakul Garg <vakul.garg@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <DB7PR04MB4252A16D177E13E1A26D1F788BDC0@DB7PR04MB4252.eurprd04.prod.outlook.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 11 March 2018 at 05:16, Vakul Garg <vakul.garg@nxp.com> wrote:
> Hi
>
> How does this patchset affect the throughput performance of crypto?
> Is it expected to increase?
>

This is about latency not throughput. The throughput may decrease
slightly (<1%), but spikes in scheduling latency due to NEON based
crypto should be a thing of the past.

Note that if you require maximum throughput without regard for
scheduling latency, you should disable CONFIG_PREEMPT in your kernel,
in which case these patches do absolutely nothing.

>> -----Original Message-----
>> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
>> owner@vger.kernel.org] On Behalf Of Ard Biesheuvel
>> Sent: Saturday, March 10, 2018 8:52 PM
>> To: linux-crypto@vger.kernel.org
>> Cc: herbert@gondor.apana.org.au; linux-arm-kernel@lists.infradead.org;
>> Ard Biesheuvel <ard.biesheuvel@linaro.org>; Dave Martin
>> <Dave.Martin@arm.com>; Russell King - ARM Linux
>> <linux@armlinux.org.uk>; Sebastian Andrzej Siewior
>> <bigeasy@linutronix.de>; Mark Rutland <mark.rutland@arm.com>; linux-rt-
>> users@vger.kernel.org; Peter Zijlstra <peterz@infradead.org>; Catalin
>> Marinas <catalin.marinas@arm.com>; Will Deacon
>> <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>; Thomas
>> Gleixner <tglx@linutronix.de>
>> Subject: [PATCH v5 00/23] crypto: arm64 - play nice with CONFIG_PREEMPT
>>
>> As reported by Sebastian, the way the arm64 NEON crypto code currently
>> keeps kernel mode NEON enabled across calls into skcipher_walk_xxx() is
>> causing problems with RT builds, given that the skcipher walk API may
>> allocate and free temporary buffers it uses to present the input and output
>> arrays to the crypto algorithm in blocksize sized chunks (where blocksize is
>> the natural blocksize of the crypto algorithm), and doing so with NEON
>> enabled means we're alloc/free'ing memory with preemption disabled.
>>
>> This was deliberate: when this code was introduced, each
>> kernel_neon_begin() and kernel_neon_end() call incurred a fixed penalty of
>> storing resp.
>> loading the contents of all NEON registers to/from memory, and so doing it
>> less often had an obvious performance benefit. However, in the mean time,
>> we have refactored the core kernel mode NEON code, and now
>> kernel_neon_begin() only incurs this penalty the first time it is called after
>> entering the kernel, and the NEON register restore is deferred until returning
>> to userland. This means pulling those calls into the loops that iterate over the
>> input/output of the crypto algorithm is not a big deal anymore (although
>> there are some places in the code where we relied on the NEON registers
>> retaining their values between calls)
>>
>> So let's clean this up for arm64: update the NEON based skcipher drivers to
>> no longer keep the NEON enabled when calling into the skcipher walk API.
>>
>> As pointed out by Peter, this only solves part of the problem. So let's tackle it
>> more thoroughly, and update the algorithms to test the NEED_RESCHED flag
>> each time after processing a fixed chunk of input.
>>
>> Given that this issue was flagged by the RT people, I would appreciate it if
>> they could confirm whether they are happy with this approach.
>>
>> Changes since v4:
>> - rebase onto v4.16-rc3
>> - apply the same treatment to new SHA512, SHA-3 and SM3 code that landed
>>   in v4.16-rc1
>>
>> Changes since v3:
>> - incorporate Dave's feedback on the asm macros to push/pop frames and to
>> yield
>>   the NEON conditionally
>> - make frame_push/pop more easy to use, by recording the arguments to
>>   frame_push, removing the need to specify them again when calling
>> frame_pop
>> - emit local symbol .Lframe_local_offset to allow code using the frame
>> push/pop
>>   macros to index the stack more easily
>> - use the magic \@ macro invocation counter provided by GAS to generate
>> unique
>>   labels om the NEON yield macros, rather than relying on chance
>>
>> Changes since v2:
>> - Drop logic to yield only after so many blocks - as it turns out, the
>>   throughput of the algorithms that are most likely to be affected by the
>>   overhead (GHASH and AES-CE) only drops by ~1% (on Cortex-A57), and if
>> that
>>   is inacceptable, you are probably not using CONFIG_PREEMPT in the first
>>   place.
>> - Add yield support to the AES-CCM driver
>> - Clean up macros based on feedback from Dave
>> - Given that I had to add stack frame logic to many of these functions, factor
>>   it out and wrap it in a couple of macros
>> - Merge the changes to the core asm driver and glue code of the
>> GHASH/GCM
>>   driver. The latter was not correct without the former.
>>
>> Changes since v1:
>> - add CRC-T10DIF test vector (#1)
>> - stop using GFP_ATOMIC in scatterwalk API calls, now that they are
>> executed
>>   with preemption enabled (#2 - #6)
>> - do some preparatory refactoring on the AES block mode code (#7 - #9)
>> - add yield patches (#10 - #18)
>> - add test patch (#19) - DO NOT MERGE
>>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> Cc: Russell King - ARM Linux <linux@armlinux.org.uk>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-rt-users@vger.kernel.org
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>
>> Ard Biesheuvel (23):
>>   crypto: testmgr - add a new test case for CRC-T10DIF
>>   crypto: arm64/aes-ce-ccm - move kernel mode neon en/disable into loop
>>   crypto: arm64/aes-blk - move kernel mode neon en/disable into loop
>>   crypto: arm64/aes-bs - move kernel mode neon en/disable into loop
>>   crypto: arm64/chacha20 - move kernel mode neon en/disable into loop
>>   crypto: arm64/aes-blk - remove configurable interleave
>>   crypto: arm64/aes-blk - add 4 way interleave to CBC encrypt path
>>   crypto: arm64/aes-blk - add 4 way interleave to CBC-MAC encrypt path
>>   crypto: arm64/sha256-neon - play nice with CONFIG_PREEMPT kernels
>>   arm64: assembler: add utility macros to push/pop stack frames
>>   arm64: assembler: add macros to conditionally yield the NEON under
>>     PREEMPT
>>   crypto: arm64/sha1-ce - yield NEON after every block of input
>>   crypto: arm64/sha2-ce - yield NEON after every block of input
>>   crypto: arm64/aes-ccm - yield NEON after every block of input
>>   crypto: arm64/aes-blk - yield NEON after every block of input
>>   crypto: arm64/aes-bs - yield NEON after every block of input
>>   crypto: arm64/aes-ghash - yield NEON after every block of input
>>   crypto: arm64/crc32-ce - yield NEON after every block of input
>>   crypto: arm64/crct10dif-ce - yield NEON after every block of input
>>   crypto: arm64/sha3-ce - yield NEON after every block of input
>>   crypto: arm64/sha512-ce - yield NEON after every block of input
>>   crypto: arm64/sm3-ce - yield NEON after every block of input
>>   DO NOT MERGE
>>
>>  arch/arm64/crypto/Makefile             |   3 -
>>  arch/arm64/crypto/aes-ce-ccm-core.S    | 150 ++++--
>>  arch/arm64/crypto/aes-ce-ccm-glue.c    |  47 +-
>>  arch/arm64/crypto/aes-ce.S             |  15 +-
>>  arch/arm64/crypto/aes-glue.c           |  95 ++--
>>  arch/arm64/crypto/aes-modes.S          | 562 +++++++++-----------
>>  arch/arm64/crypto/aes-neonbs-core.S    | 305 ++++++-----
>>  arch/arm64/crypto/aes-neonbs-glue.c    |  48 +-
>>  arch/arm64/crypto/chacha20-neon-glue.c |  12 +-
>>  arch/arm64/crypto/crc32-ce-core.S      |  40 +-
>>  arch/arm64/crypto/crct10dif-ce-core.S  |  32 +-
>>  arch/arm64/crypto/ghash-ce-core.S      | 113 ++--
>>  arch/arm64/crypto/ghash-ce-glue.c      |  28 +-
>>  arch/arm64/crypto/sha1-ce-core.S       |  42 +-
>>  arch/arm64/crypto/sha2-ce-core.S       |  37 +-
>>  arch/arm64/crypto/sha256-glue.c        |  36 +-
>>  arch/arm64/crypto/sha3-ce-core.S       |  77 ++-
>>  arch/arm64/crypto/sha512-ce-core.S     |  27 +-
>>  arch/arm64/crypto/sm3-ce-core.S        |  30 +-
>>  arch/arm64/include/asm/assembler.h     | 167 ++++++
>>  arch/arm64/kernel/asm-offsets.c        |   2 +
>>  crypto/testmgr.h                       | 259 +++++++++
>>  22 files changed, 1392 insertions(+), 735 deletions(-)
>>
>> --
>> 2.15.1
>
