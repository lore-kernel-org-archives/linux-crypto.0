From: Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+
Date: Fri, 4 Jul 2014 19:09:17 +0800
Message-ID: <CAN1soZz=VoUnhVs3JV5qdtizKnV7rYTv6Gp_zhRywRG5wPUwdA@mail.gmail.com>
References: <E1X20Rs-00082S-KI@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-1D3HCaltpLuhEniVeURVKkEOCMrvLtNR@public.gmane.org>,
        <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, <linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Kukjin
 Kim <kgene.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>,
        Magnus Damm
	<magnus.damm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Tony Lindgren
	<tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jason Cooper
	<jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
        Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>,
        Marc Zyngier
	<marc.
To: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Return-path: <davinci-linux-open-source-bounces-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
In-Reply-To: <E1X20Rs-00082S-KI-eh5Bv4kxaXIANfyc6IWni62ZND6+EDdj@public.gmane.org>
List-Unsubscribe: <http://linux.davincidsp.com/mailman/options/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=unsubscribe>
List-Archive: <http://linux.davincidsp.com/pipermail/davinci-linux-open-source>
List-Post: <mailto:davinci-linux-open-source-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
List-Help: <mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=help>
List-Subscribe: <http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=subscribe>
Sender: <davinci-linux-open-source-bounces-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
Errors-To: davinci-linux-open-source-bounces-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 1, 2014 at 11:58 PM, Russell King
<rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org> wrote:
> ARMv6 and greater introduced a new instruction ("bx") which can be used
> to return from function calls.  Recent CPUs perform better when the
> "bx lr" instruction is used rather than the "mov pc, lr" instruction,
> and this sequence is strongly recommended to be used by the ARM
> architecture manual (section A.4.1.1).
>
> We provide a new macro "ret" with all its variants for the condition
> code which will resolve to the appropriate instruction.
>
> Rather than doing this piecemeal, and miss some instances, change all
> the "mov pc" instances to use the new macro, with the exception of
> the "movs" instruction and the kprobes code.  This allows us to detect
> the "mov pc, lr" case and fix it up - and also gives us the possibility
> of deploying this for other registers depending on the CPU selection.
>
> Signed-off-by: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> ---
>  arch/arm/crypto/aes-armv4.S              |  3 ++-
>  arch/arm/include/asm/assembler.h         | 21 +++++++++++++++
>  arch/arm/include/asm/entry-macro-multi.S |  2 +-
>  arch/arm/kernel/debug.S                  | 10 ++++----
>  arch/arm/kernel/entry-armv.S             | 42 +++++++++++++++---------------
>  arch/arm/kernel/entry-common.S           | 13 +++++-----
>  arch/arm/kernel/entry-header.S           | 14 ----------
>  arch/arm/kernel/fiqasm.S                 |  4 +--
>  arch/arm/kernel/head-common.S            |  7 ++---
>  arch/arm/kernel/head-nommu.S             |  8 +++---
>  arch/arm/kernel/head.S                   | 18 ++++++-------
>  arch/arm/kernel/hyp-stub.S               |  6 ++---
>  arch/arm/kernel/iwmmxt.S                 | 10 ++++----
>  arch/arm/kernel/relocate_kernel.S        |  3 ++-
>  arch/arm/kernel/sleep.S                  |  2 +-
>  arch/arm/kvm/init.S                      |  3 ++-
>  arch/arm/lib/ashldi3.S                   |  3 ++-
>  arch/arm/lib/ashrdi3.S                   |  3 ++-
>  arch/arm/lib/backtrace.S                 |  2 +-
>  arch/arm/lib/bitops.h                    |  5 ++--
>  arch/arm/lib/bswapsdi2.S                 |  5 ++--
>  arch/arm/lib/call_with_stack.S           |  4 +--
>  arch/arm/lib/csumpartial.S               |  2 +-
>  arch/arm/lib/csumpartialcopygeneric.S    |  5 ++--
>  arch/arm/lib/delay-loop.S                | 18 ++++++-------
>  arch/arm/lib/div64.S                     | 13 +++++-----
>  arch/arm/lib/findbit.S                   | 10 ++++----
>  arch/arm/lib/getuser.S                   |  8 +++---
>  arch/arm/lib/io-readsb.S                 |  2 +-
>  arch/arm/lib/io-readsl.S                 |  6 ++---
>  arch/arm/lib/io-readsw-armv3.S           |  4 +--
>  arch/arm/lib/io-readsw-armv4.S           |  2 +-
>  arch/arm/lib/io-writesb.S                |  2 +-
>  arch/arm/lib/io-writesl.S                | 10 ++++----
>  arch/arm/lib/io-writesw-armv3.S          |  4 +--
>  arch/arm/lib/io-writesw-armv4.S          |  4 +--
>  arch/arm/lib/lib1funcs.S                 | 26 +++++++++----------
>  arch/arm/lib/lshrdi3.S                   |  3 ++-
>  arch/arm/lib/memchr.S                    |  2 +-
>  arch/arm/lib/memset.S                    |  2 +-
>  arch/arm/lib/memzero.S                   |  2 +-
>  arch/arm/lib/muldi3.S                    |  3 ++-
>  arch/arm/lib/putuser.S                   | 10 ++++----
>  arch/arm/lib/strchr.S                    |  2 +-
>  arch/arm/lib/strrchr.S                   |  2 +-
>  arch/arm/lib/ucmpdi2.S                   |  5 ++--
>  arch/arm/mach-davinci/sleep.S            |  2 +-
>  arch/arm/mach-ep93xx/crunch-bits.S       |  6 ++---
>  arch/arm/mach-imx/suspend-imx6.S         |  5 ++--
>  arch/arm/mach-mvebu/coherency_ll.S       | 10 ++++----
>  arch/arm/mach-mvebu/headsmp-a9.S         |  3 ++-
>  arch/arm/mach-omap2/sleep44xx.S          |  3 ++-
>  arch/arm/mach-omap2/sram242x.S           |  6 ++---
>  arch/arm/mach-omap2/sram243x.S           |  6 ++---
>  arch/arm/mach-pxa/mioa701_bootresume.S   |  2 +-
>  arch/arm/mach-pxa/standby.S              |  4 +--
>  arch/arm/mach-s3c24xx/sleep-s3c2410.S    |  2 +-
>  arch/arm/mach-s3c24xx/sleep-s3c2412.S    |  2 +-
>  arch/arm/mach-shmobile/headsmp.S         |  3 ++-
>  arch/arm/mach-tegra/sleep-tegra20.S      | 24 ++++++++---------
>  arch/arm/mach-tegra/sleep-tegra30.S      | 14 +++++-----
>  arch/arm/mach-tegra/sleep.S              |  8 +++---
>  arch/arm/mm/cache-fa.S                   | 19 +++++++-------
>  arch/arm/mm/cache-nop.S                  |  5 ++--
>  arch/arm/mm/cache-v4.S                   | 13 +++++-----
>  arch/arm/mm/cache-v4wb.S                 | 15 ++++++-----
>  arch/arm/mm/cache-v4wt.S                 | 13 +++++-----
>  arch/arm/mm/cache-v6.S                   | 20 +++++++--------
>  arch/arm/mm/cache-v7.S                   | 30 +++++++++++-----------
>  arch/arm/mm/l2c-l2x0-resume.S            |  7 ++---
>  arch/arm/mm/proc-arm1020.S               | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm1020e.S              | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm1022.S               | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm1026.S               | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm720.S                | 16 ++++++------
>  arch/arm/mm/proc-arm740.S                |  8 +++---
>  arch/arm/mm/proc-arm7tdmi.S              |  8 +++---
>  arch/arm/mm/proc-arm920.S                | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm922.S                | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm925.S                | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm926.S                | 34 ++++++++++++------------
>  arch/arm/mm/proc-arm940.S                | 24 ++++++++---------
>  arch/arm/mm/proc-arm946.S                | 30 +++++++++++-----------
>  arch/arm/mm/proc-arm9tdmi.S              |  8 +++---
>  arch/arm/mm/proc-fa526.S                 | 16 ++++++------
>  arch/arm/mm/proc-feroceon.S              | 44 ++++++++++++++++----------------
>  arch/arm/mm/proc-mohawk.S                | 34 ++++++++++++------------
>  arch/arm/mm/proc-sa110.S                 | 16 ++++++------
>  arch/arm/mm/proc-sa1100.S                | 16 ++++++------
>  arch/arm/mm/proc-v6.S                    | 16 ++++++------
>  arch/arm/mm/proc-v7-2level.S             |  4 +--
>  arch/arm/mm/proc-v7-3level.S             |  5 ++--
>  arch/arm/mm/proc-v7.S                    | 14 +++++-----
>  arch/arm/mm/proc-v7m.S                   | 18 ++++++-------
>  arch/arm/mm/proc-xsc3.S                  | 32 +++++++++++------------
>  arch/arm/mm/proc-xscale.S                | 34 ++++++++++++------------
>  arch/arm/mm/tlb-fa.S                     |  7 ++---
>  arch/arm/mm/tlb-v4.S                     |  5 ++--
>  arch/arm/mm/tlb-v4wb.S                   |  7 ++---
>  arch/arm/mm/tlb-v4wbi.S                  |  7 ++---
>  arch/arm/mm/tlb-v6.S                     |  5 ++--
>  arch/arm/mm/tlb-v7.S                     |  4 +--
>  arch/arm/nwfpe/entry.S                   |  8 +++---
>  arch/arm/vfp/entry.S                     |  4 +--
>  arch/arm/vfp/vfphw.S                     | 26 +++++++++----------
>  arch/arm/xen/hypercall.S                 |  6 ++---
>  106 files changed, 644 insertions(+), 607 deletions(-)
>

I tested on PXA3xx platform.

Acked-by: Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Regards
Haojian
