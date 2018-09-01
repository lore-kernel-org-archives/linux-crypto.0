From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: arm/chacha20 - faster 8-bit rotations and other
 optimizations
Date: Fri, 31 Aug 2018 23:39:16 -0700
Message-ID: <20180901063915.GA6466@sol.localdomain>
References: <20180831080140.20553-1-ebiggers@kernel.org>
 <CAKv+Gu_zbuo0ApR2fPC=-w1QNXnSDu6omgALqKm7k6g_y5B51g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_zbuo0ApR2fPC=-w1QNXnSDu6omgALqKm7k6g_y5B51g@mail.gmail.com>
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

Hi Ard,

On Fri, Aug 31, 2018 at 05:56:24PM +0200, Ard Biesheuvel wrote:
> Hi Eric,
> 
> On 31 August 2018 at 10:01, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Optimize ChaCha20 NEON performance by:
> >
> > - Implementing the 8-bit rotations using the 'vtbl.8' instruction.
> > - Streamlining the part that adds the original state and XORs the data.
> > - Making some other small tweaks.
> >
> > On ARM Cortex-A7, these optimizations improve ChaCha20 performance from
> > about 11.9 cycles per byte to 11.3.
> >
> > There is a tradeoff involved with the 'vtbl.8' rotation method since
> > there is at least one CPU where it's not fastest.  But it seems to be a
> > better default; see the added comment.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  arch/arm/crypto/chacha20-neon-core.S | 289 ++++++++++++++-------------
> >  1 file changed, 147 insertions(+), 142 deletions(-)
> >
> > diff --git a/arch/arm/crypto/chacha20-neon-core.S b/arch/arm/crypto/chacha20-neon-core.S
> > index 3fecb2124c35a..d381cebaba31d 100644
> > --- a/arch/arm/crypto/chacha20-neon-core.S
> > +++ b/arch/arm/crypto/chacha20-neon-core.S
> > @@ -18,6 +18,33 @@
> >   * (at your option) any later version.
> >   */
> >
> > + /*
> > +  * NEON doesn't have a rotate instruction.  The alternatives are, more or less:
> > +  *
> > +  * (a)  vshl.u32 + vsri.u32           (needs temporary register)
> > +  * (b)  vshl.u32 + vshr.u32 + vorr    (needs temporary register)
> > +  * (c)  vrev32.16                     (16-bit rotations only)
> > +  * (d)  vtbl.8 + vtbl.8               (multiple of 8 bits rotations only,
> > +  *                                     needs index vector)
> > +  *
> > +  * ChaCha20 has 16, 12, 8, and 7-bit rotations.  For the 12 and 7-bit
> > +  * rotations, the only choices are (a) and (b).  We use (a) since it takes
> > +  * two-thirds the cycles of (b) on both Cortex-A7 and Cortex-A53.
> > +  *
> > +  * For the 16-bit rotation, we use vrev32.16 since it's consistently fastest
> > +  * and doesn't need a temporary register.
> > +  *
> > +  * For the 8-bit rotation, we use vtbl.8 + vtbl.8.  On Cortex-A7, this sequence
> > +  * is twice as fast as (a), even when doing (a) on multiple registers
> > +  * simultaneously to eliminate the stall between vshl and vsri.  Also, it
> > +  * parallelizes better when temporary registers are scarce.
> > +  *
> > +  * A disadvantage is that on Cortex-A53, the vtbl sequence is the same speed as
> > +  * (a), so the need to load the rotation table actually makes the vtbl method
> > +  * slightly slower overall on that CPU.  Still, it seems to be a good
> > +  * compromise to get a significant speed boost on some CPUs.
> > +  */
> > +
> 
> Thanks for sharing these results. I have been working on 32-bit ARM
> code under the assumption that the A53 pipeline more or less resembles
> the A7 one, but this is obviously not the case looking at your
> results. My contributions to arch/arm/crypto mainly involved Crypto
> Extensions code, which the A7 does not support in the first place, so
> it does not really matter, but I will keep this in mind going forward.
> 
> >  #include <linux/linkage.h>
> >
> >         .text
> > @@ -46,6 +73,9 @@ ENTRY(chacha20_block_xor_neon)
> >         vmov            q10, q2
> >         vmov            q11, q3
> >
> > +       ldr             ip, =.Lrol8_table
> > +       vld1.8          {d10}, [ip, :64]
> > +
> 
> I usually try to avoid the =literal ldr notation, because it involves
> an additional load via the D-cache. Could you use a 64-bit literal
> instead of a byte array and use vldr instead? Or switch to adr? (and
> move the literal in range, I suppose)

'adr' works if I move rol8_table to between chacha20_block_xor_neon() and
chacha20_4block_xor_neon().

> >  ENTRY(chacha20_4block_xor_neon)
> > -       push            {r4-r6, lr}
> > -       mov             ip, sp                  // preserve the stack pointer
> > -       sub             r3, sp, #0x20           // allocate a 32 byte buffer
> > -       bic             r3, r3, #0x1f           // aligned to 32 bytes
> > -       mov             sp, r3
> > +       push            {r4}
> 
> The ARM EABI mandates 8 byte stack alignment, and if you take an
> interrupt right at this point, you will enter the interrupt handler
> with a misaligned stack. Whether this could actually cause any
> problems is a different question, but it is better to keep it 8-byte
> aligned to be sure.
> 
> I'd suggest you just push r4 and lr, so you can return from the
> function by popping r4 and pc, as is customary on ARM.

Are you sure that's an actual constraint?  That would imply you could never
push/pop an odd number of ARM registers to/from the stack... but if I
disassemble an ARM kernel, such pushes/pops occur frequently in generated code.
So 8-byte alignment must only be required when a subroutine is called.

If I understand the interrupt handling code correctly, the kernel stack is being
aligned in the svc_entry macro from __irq_svc in arch/arm/kernel/entry-armv.S:

		.macro  svc_entry, stack_hole=0, trace=1, uaccess=1
	 UNWIND(.fnstart                )
	 UNWIND(.save {r0 - pc}         )
		sub     sp, sp, #(SVC_REGS_SIZE + \stack_hole - 4)
	#ifdef CONFIG_THUMB2_KERNEL
	 SPFIX( str     r0, [sp]        )       @ temporarily saved
	 SPFIX( mov     r0, sp          )
	 SPFIX( tst     r0, #4          )       @ test original stack alignment
	 SPFIX( ldr     r0, [sp]        )       @ restored
	#else
	 SPFIX( tst     sp, #4          )
	#endif
	 SPFIX( subeq   sp, sp, #4      )

So 'sp' must always be 4-byte aligned, but not necessarily 8-byte aligned.

Anyway, it may be a moot point as I'm planning to use r5 in the v2 patch, so
I'll just be pushing {r4-r5} anyway...

> 
> > +       mov             r4, sp                  // preserve the stack pointer
> > +       sub             ip, sp, #0x20           // allocate a 32 byte buffer
> > +       bic             ip, ip, #0x1f           // aligned to 32 bytes
> > +       mov             sp, ip
> >
> 
> Is there a reason for preferring ip over r3 for preserving the
> original value of sp?

You mean preferring r4 over ip?  It's mostly arbitrary which register is
assigned to what; I just like using 'ip' for shorter-lived temporary stuff.

> > +
> > +       // x8..11[0-3] += s8..11[0-3]   (add orig state to 3rd row of each block)
> > +       vadd.u32        q8,  q8,  q0
> > +       vadd.u32        q10, q10, q0
> > +         vld1.32       {q14-q15}, [sp, :256]
> > +       vadd.u32        q9,  q9,  q0
> > +         adr           ip, .Lctrinc2
> > +       vadd.u32        q11, q11, q0
> > +
> > +       // x12..15[0-3] += s12..15[0-3] (add orig state to 4th row of each block)
> > +       vld1.32         {q0}, [ip, :128]        // load (1, 0, 2, 0)
> 
> Would something like
> 
>         vmov.i32        d0, #1
>         vmovl.u32       q0, d0
>         vadd.u64        d1, d1
> 
> (untested) work as well?
> 
> > +       vadd.u32        q15, q15, q1
> > +       vadd.u32        q13, q13, q1
> > +       vadd.u32        q14, q14, q1
> > +       vadd.u32        q12, q12, q1
> > +       vadd.u32        d30, d30, d1            // x12[3] += 2
> > +       vadd.u32        d26, d26, d1            // x12[2] += 2
> > +       vadd.u32        d28, d28, d0            // x12[1] += 1
> > +       vadd.u32        d30, d30, d0            // x12[3] += 1
> > +

Well, or:

	vmov.u64      d0, #0x00000000ffffffff
        vadd.u32      d1, d0, d0

And then subtract instead of add.  But actually there's a better way: load
{0, 1, 2, 3} (i.e. the original 'CTRINC') and add it to q12 *before*
re-interleaving q12-15.  That avoids unnecessary additions.
I'll send a new patch with that.

- Eric
