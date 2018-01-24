From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH RFC 0/3] API for 128-bit IO access
Date: Wed, 24 Jan 2018 12:05:16 +0300
Message-ID: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Pinski <Andrew.Pinski@cavium.com>,
 Sunil Goutham <Sunil.Goutham@cavium.com>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Ingo Molnar <mingo@kernel.org>,
 Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
 Yury Norov <ynorov@caviumnetworks.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Laura Abbott <labbott@redhat.com>,
 "David S . Miller" <davem@davemloft.net>
To: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

Hi all,

This series adds API for 128-bit memory IO access and enables it for ARM64.
The original motivation for 128-bit API came from new Cavium network device
driver. The hardware requires 128-bit access to make things work. See
description in patch 3 for details.

Also, starting from ARMv8.4, stp and ldp instructions become atomic, and
API for 128-bit access would be helpful in core arm64 code.

This series is RFC. I'd like to collect opinions on idea and implementation
details.
* I didn't implement all 128-bit operations existing for 64-bit variables
and other types (__swab128p etc). Do we need them all right now, or we
can add them when actually needed?
* u128 name is already used in crypto code. So here I use __uint128_t that
comes from GCC for 128-bit types. Should I rename existing type in crypto
and make core code for 128-bit variables consistent with u64, u32 etc? (I
think yes, but would like to ask crypto people for it.)
* Some compilers don't support __uint128_t, so I protected all generic code
with config option HAVE_128BIT_ACCESS. I think it's OK, but... 
* For 128-bit read/write functions I take suffix 'o', which means read/write
the octet of bytes. Is this name OK?
* my mips-linux-gnu-gcc v6.3.0 doesn't support __uint128_t, and I
don't have other BE setup on hand, so BE case is formally not tested.
BE code for arm64 is looking well though.

With all that, this example code:

static int __init 128bit_test(void)
{
	__uint128_t v;
	__uint128_t addr;
	__uint128_t val = (__uint128_t) 0x1234567890abc;

	val |= ((__uint128_t) 0xdeadbeaf) << 64;

	writeo(val, &addr);
	v = reado(&addr);

	pr_err("%llx%llx\n", (u64) (val >> 64), (u64) val);
	pr_err("%llx%llx\n", (u64) (v >> 64), (u64) v);
	return v != val;
}

Generates this listing for arm64-le:

0000000000000000 <128bit_test>:
   0:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
   4:	910003fd 	mov	x29, sp
   8:	a90153f3 	stp	x19, x20, [sp, #16]
   c:	a9025bf5 	stp	x21, x22, [sp, #32]
  10:	f9001bf7 	str	x23, [sp, #48]
  14:	d5033e9f 	dsb	st
  18:	d2815797 	mov	x23, #0xabc                 	// #2748
  1c:	d297d5f6 	mov	x22, #0xbeaf                	// #48815
  20:	f2acf137 	movk	x23, #0x6789, lsl #16
  24:	f2bbd5b6 	movk	x22, #0xdead, lsl #16
  28:	f2c468b7 	movk	x23, #0x2345, lsl #32
  2c:	f2e00037 	movk	x23, #0x1, lsl #48
  30:	a9045bb7 	stp	x23, x22, [x29, #64]
  34:	a94453b3 	ldp	x19, x20, [x29, #64]
  38:	d5033d9f 	dsb	ld
  3c:	90000015 	adrp	x21, 0 <128bit_test>
  40:	910002b5 	add	x21, x21, #0x0
  44:	aa1703e2 	mov	x2, x23
  48:	aa1603e1 	mov	x1, x22
  4c:	aa1503e0 	mov	x0, x21
  50:	94000000 	bl	0 <printk>
  54:	aa1303e2 	mov	x2, x19
  58:	aa1403e1 	mov	x1, x20
  5c:	ca170273 	eor	x19, x19, x23
  60:	ca160294 	eor	x20, x20, x22
  64:	aa1503e0 	mov	x0, x21
  68:	aa140273 	orr	x19, x19, x20
  6c:	94000000 	bl	0 <printk>
  70:	f9401bf7 	ldr	x23, [sp, #48]
  74:	f100027f 	cmp	x19, #0x0
  78:	a94153f3 	ldp	x19, x20, [sp, #16]
  7c:	1a9f07e0 	cset	w0, ne  // ne = any
  80:	a9425bf5 	ldp	x21, x22, [sp, #32]
  84:	a8c57bfd 	ldp	x29, x30, [sp], #80
  88:	d65f03c0 	ret

And for arm64-be:

0000000000000000 <128bit_test>:
   0:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
   4:	910003fd 	mov	x29, sp
   8:	a90153f3 	stp	x19, x20, [sp, #16]
   c:	a9025bf5 	stp	x21, x22, [sp, #32]
  10:	f9001bf7 	str	x23, [sp, #48]
  14:	d5033e9f 	dsb	st
  18:	d2802001 	mov	x1, #0x100                 	// #256
  1c:	d2d5bbc0 	mov	x0, #0xadde00000000        	// #191168994344960
  20:	f2a8a461 	movk	x1, #0x4523, lsl #16
  24:	f2f5f7c0 	movk	x0, #0xafbe, lsl #48
  28:	f2d12ce1 	movk	x1, #0x8967, lsl #32
  2c:	f2f78141 	movk	x1, #0xbc0a, lsl #48
  30:	a90407a0 	stp	x0, x1, [x29, #64]
  34:	a94453b3 	ldp	x19, x20, [x29, #64]
  38:	dac00e73 	rev	x19, x19
  3c:	dac00e94 	rev	x20, x20
  40:	d5033d9f 	dsb	ld
  44:	d2815796 	mov	x22, #0xabc                 	// #2748
  48:	90000015 	adrp	x21, 0 <128bit_test>
  4c:	f2acf136 	movk	x22, #0x6789, lsl #16
  50:	910002b5 	add	x21, x21, #0x0
  54:	f2c468b6 	movk	x22, #0x2345, lsl #32
  58:	d297d5f7 	mov	x23, #0xbeaf                	// #48815
  5c:	f2e00036 	movk	x22, #0x1, lsl #48
  60:	f2bbd5b7 	movk	x23, #0xdead, lsl #16
  64:	aa1603e2 	mov	x2, x22
  68:	aa1703e1 	mov	x1, x23
  6c:	aa1503e0 	mov	x0, x21
  70:	94000000 	bl	0 <printk>
  74:	aa1403e2 	mov	x2, x20
  78:	aa1303e1 	mov	x1, x19
  7c:	ca160294 	eor	x20, x20, x22
  80:	ca170273 	eor	x19, x19, x23
  84:	aa1503e0 	mov	x0, x21
  88:	aa140273 	orr	x19, x19, x20
  8c:	94000000 	bl	0 <printk>
  90:	f9401bf7 	ldr	x23, [sp, #48]
  94:	f100027f 	cmp	x19, #0x0
  98:	a94153f3 	ldp	x19, x20, [sp, #16]
  9c:	1a9f07e0 	cset	w0, ne  // ne = any
  a0:	a9425bf5 	ldp	x21, x22, [sp, #32]
  a4:	a8c57bfd 	ldp	x29, x30, [sp], #80
  a8:	d65f03c0 	ret

I tested LE kernel with this, and it works OK for me. BE version adds
few extra instructions to swap bytes, but generated code looks reasonable. 
We can avoid byteswapping, if not needed, by using __raw_reado() and 
__raw_writeo().

Yury Norov (3):
  UAPI: Introduce 128-bit types and byteswap operations
  asm-generic/io.h: API for 128-bit I/O accessors
  arm64: enable 128-bit memory read/write support

 arch/Kconfig                                 |   7 ++
 arch/arm64/include/asm/io.h                  |  31 ++++++
 include/asm-generic/io.h                     | 147 +++++++++++++++++++++++++++
 include/linux/byteorder/generic.h            |   4 +
 include/uapi/asm-generic/int-ll64.h          |   8 ++
 include/uapi/linux/byteorder/big_endian.h    |   2 +
 include/uapi/linux/byteorder/little_endian.h |   4 +
 include/uapi/linux/swab.h                    |  22 ++++
 include/uapi/linux/types.h                   |   4 +
 9 files changed, 229 insertions(+)

-- 
2.11.0
