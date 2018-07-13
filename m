From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [v18,3/7] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Fri, 13 Jul 2018 16:38:31 -0700
Message-ID: <20180713233831.GA2946@roeck-us.net>
References: <20180622194752.11221-4-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180622194752.11221-4-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Fri, Jun 22, 2018 at 01:47:48PM -0600, Logan Gunthorpe wrote:
> In order to provide non-atomic functions for io{read|write}64 that will
> use readq and writeq when appropriate. We define a number of variants
> of these functions in the generic iomap that will do non-atomic
> operations on pio but atomic operations on mmio.
> 
> These functions are only defined if readq and writeq are defined. If
> they are not, then the wrappers that always use non-atomic operations
> from include/linux/io-64-nonatomic*.h will be used.
> 

This patch causes a build failure in -next when building
ppc:corenet64_smp_defconfig.

In file included from drivers/crypto/caam/qi.c:14:0:
drivers/crypto/caam/regs.h: In function 'wr_reg64':
drivers/crypto/caam/regs.h:143:3:
	error: implicit declaration of function 'iowrite64'; did you mean 'iowrite32'?

Several files are afected; this is only the first error reported.

Bisect log is attached.

Guenter

---
# bad: [483d835c8189f0566a4cbbe47e74ffa314430e98] Add linux-next specific files for 20180713
# good: [1e4b044d22517cae7047c99038abb444423243ca] Linux 4.18-rc4
git bisect start 'HEAD' 'v4.18-rc4'
# good: [a5da8bf5df4436f40f4e28f0be51a4678830fe23] Merge remote-tracking branch 'crypto/master'
git bisect good a5da8bf5df4436f40f4e28f0be51a4678830fe23
# good: [34f19afdf1f94450c325da94559d07f746e9043d] Merge remote-tracking branch 'tip/auto-latest'
git bisect good 34f19afdf1f94450c325da94559d07f746e9043d
# good: [7aac4471307ac631685599b820616fd4c47edf29] Merge remote-tracking branch 'staging/staging-next'
git bisect good 7aac4471307ac631685599b820616fd4c47edf29
# good: [6b674574d58a738035fdf29008a308bee9235a16] Merge remote-tracking branch 'ntb/ntb-next'
git bisect good 6b674574d58a738035fdf29008a308bee9235a16
# bad: [013d0c6f50169c75eb37549f705604103cbeaa0b] module: allow symbol exports to be disabled
git bisect bad 013d0c6f50169c75eb37549f705604103cbeaa0b
# good: [205a106bac127145a4defae7d0d35945001fe924] kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN
git bisect good 205a106bac127145a4defae7d0d35945001fe924
# good: [89ce5b41242240e43de867b0469b71c6b8aa9d5f] mm, swap: fix race between swapoff and some swap operations
git bisect good 89ce5b41242240e43de867b0469b71c6b8aa9d5f
# good: [9760a955e6173bd0c2f58f1507fec8c88aaffc68] proc: fix BUILD_BUG_ON breakage on powerpc64-allyesconfig
git bisect good 9760a955e6173bd0c2f58f1507fec8c88aaffc68
# good: [696b14958b4d620ae7431351b667fd79397d550d] include/asm-generic/bug.h: clarify valid uses of WARN()
git bisect good 696b14958b4d620ae7431351b667fd79397d550d
# good: [e018a02ca17fbe4c34515bec58eceb8b0be94ec6] parisc: iomap: introduce io{read|write}64
git bisect good e018a02ca17fbe4c34515bec58eceb8b0be94ec6
# bad: [e18963b65c6397fdba51416ff70c33197f6c1a84] ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
git bisect bad e18963b65c6397fdba51416ff70c33197f6c1a84
# bad: [8f6432de3dbe1d1d222d2998380a495e04ba5fef] io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
git bisect bad 8f6432de3dbe1d1d222d2998380a495e04ba5fef
# bad: [d189c7f6b4a0dec224652af6d868eebb57553345] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
git bisect bad d189c7f6b4a0dec224652af6d868eebb57553345
# first bad commit: [d189c7f6b4a0dec224652af6d868eebb57553345] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
