From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v5 00/23] crypto: arm64 - play nice with CONFIG_PREEMPT
Date: Mon, 19 Mar 2018 23:31:24 +0800
Message-ID: <CAKv+Gu8jCa7dAoXHan+3zwBt2pZjD22MaCSwiAM-bXHgvVJkmQ@mail.gmail.com>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
 <20180316155735.GJ7095@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, linux-rt-users@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, Will Deacon <will.deacon@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180316155735.GJ7095@gondor.apana.org.au>
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

On 16 March 2018 at 23:57, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Mar 10, 2018 at 03:21:45PM +0000, Ard Biesheuvel wrote:
>> As reported by Sebastian, the way the arm64 NEON crypto code currently
>> keeps kernel mode NEON enabled across calls into skcipher_walk_xxx() is
>> causing problems with RT builds, given that the skcipher walk API may
>> allocate and free temporary buffers it uses to present the input and
>> output arrays to the crypto algorithm in blocksize sized chunks (where
>> blocksize is the natural blocksize of the crypto algorithm), and doing
>> so with NEON enabled means we're alloc/free'ing memory with preemption
>> disabled.
>>
>> This was deliberate: when this code was introduced, each kernel_neon_begin()
>> and kernel_neon_end() call incurred a fixed penalty of storing resp.
>> loading the contents of all NEON registers to/from memory, and so doing
>> it less often had an obvious performance benefit. However, in the mean time,
>> we have refactored the core kernel mode NEON code, and now kernel_neon_begin()
>> only incurs this penalty the first time it is called after entering the kernel,
>> and the NEON register restore is deferred until returning to userland. This
>> means pulling those calls into the loops that iterate over the input/output
>> of the crypto algorithm is not a big deal anymore (although there are some
>> places in the code where we relied on the NEON registers retaining their
>> values between calls)
>>
>> So let's clean this up for arm64: update the NEON based skcipher drivers to
>> no longer keep the NEON enabled when calling into the skcipher walk API.
>>
>> As pointed out by Peter, this only solves part of the problem. So let's
>> tackle it more thoroughly, and update the algorithms to test the NEED_RESCHED
>> flag each time after processing a fixed chunk of input.
>>
>> Given that this issue was flagged by the RT people, I would appreciate it
>> if they could confirm whether they are happy with this approach.
>>
>> Changes since v4:
>> - rebase onto v4.16-rc3
>> - apply the same treatment to new SHA512, SHA-3 and SM3 code that landed
>>   in v4.16-rc1
>
> Looks good to me.  If more work is needed we can always do
> incremental fixes.
>
> Patches 1-22 applied.  Thanks.

Thanks Herbert.

Apologies if this wasn't clear, but there are some cross dependencies
with the arm64 tree, which receives non-trivial modifications in
patches 10 and 11, which are subsequently depended upon by patches 12
- 23.

Without acks from them, we should really not be merging this code yet,
especially because I noticed a rebase issue in patch #10 (my bad).

Would you mind reverting 10 - 22? I will revisit this asap, and try to
get acks for the arm64 patches. If that means waiting for the next
cycle, so be it.

Thanks,
Ard.
