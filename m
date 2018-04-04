From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v15 0/9] Add io{read|write}64 to io-64-atomic headers
Date: Wed, 04 Apr 2018 20:38:16 +1000
Message-ID: <87r2nvmf3b.fsf@concordia.ellerman.id.au>
References: <20180327230834.5931-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327230834.5931-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Logan Gunthorpe <logang@deltatee.com> writes:

> This is v14 of my cleanup series to push a number of instances of people
> defining their own io{read|write}64 functions into common headers seing
> they don't exist in non-64bit systems. This series adds inline functions to the
> io-64-nonatomic headers and then cleans up the drivers that defined their
> own copies.
>
> This cleanup was originally requested by Greg after he reviewed my
> Switchtec NTB code. And I hope someone can pick it up or at least give
> feedback on it soon as it's been around relatively unchanged for a few
> cycles now and I'm getting a bit tired of resubmitting it with little to
> no interest.

Yeah fair enough.

What's the plan for getting it merged? Seems we don't have one?

Given it touches two arches and generic stuff and drivers and crypto,
it's a bit of a mess to merge. It's not really something I want to merge
via the powerpc tree.

Is there any way to split it? I couldn't immediately see what the hard
dependencies were between the patches.

eg. It looks like I could take the two powerpc patches on their own for
4.17, and then the rest could go via other trees?

Is patch 1 stand alone?

The other option is to ask Andrew Morton to take it, as he often carries
these cross-tree type series.

cheers

> Changes since v14:
> - Rebased onto v4.16-rc7
> - Replace the first two patches so that instead of correcting the
>   endianness annotations we change to using writeX() and readX() with
>   swabX() calls. This makes the big-endian functions more symmetric
>   with the little-endian versions (with respect to barriers that are
>   not included in the raw functions). As a side effect, it also fixes
>   the kbuild warnings that the first two patches tried to address.
>
> Changes since v13:
> - Changed the subject of patch 0001 to correct a nit pointed out by Luc
>
> Changes since v12:
> - Rebased onto v4.16-rc6
> - Split patch 0001 into two and reworked the commit log as requested
>   by Luc Van Oostenryck
>
> Changes since v11:
> - Rebased onto v4.16-rc5
> - Added a patch (0001) to fix some old and new sparse warnings
>   that the kbuild robot warned about this cycle. The latest version
>   of sparse was required to reproduce these.
> - Added a patch (0002) to add io{read|write}64 to parisc which the kbuild
>   robot also found errors for this cycle
>
> Changes since v10:
> - Rebased onto v4.16-rc4, this droped the drm/tilcdc patch which was
>   picked up by that tree and is already in 4.16.
>
> Changes since v9:
> - Rebased onto v4.15-rc6
> - Fixed a couple of issues in the new version of the CAAM patch as
>   pointed out by Horia
>
> Changes since v8:
> - Rebased onto v4.15-rc2, as a result rewrote patch 7 seeing someone did
>   some similar cleanup in that area.
> - Added a patch to clean up the Switchtec NTB driver which landed in
>   v4.15-rc1
>
> Changes since v7:
> - Fix minor nits from Andy Shevchenko
> - Rebased onto v4.14-rc1
>
> Changes since v6:
>  ** none **
>
> Changes since v5:
> - Added a fix to the tilcdc driver to ensure it doesn't use the
>   non-atomic operation. (This includes adding io{read|write}64[be]_is_nonatomic
>   defines).
>
> Changes since v4:
> - Add functions so the powerpc implementation of iomap.c compiles. (As
>   noticed by Horia)
>
> Changes since v3:
>
> - I noticed powerpc didn't use the appropriate functions seeing
>   readq/writeq were not defined when iomap.h was included. Thus I've
>   included a patch to adjust this
> - Fixed some mistakes with a couple of the defines in io-64-nonatomic*
>   headers
> - Fixed a typo noticed by Horia.
>
> (earlier versions were drastically different)
>
> --
>
> Logan Gunthorpe (9):
>   iomap: Use non-raw io functions for io{read|write}XXbe
>   parisc: iomap: introduce io{read|write}64
>   powerpc: io.h: move iomap.h include so that it can use readq/writeq
>     defs
>   powerpc: iomap.c: introduce io{read|write}64_{lo_hi|hi_lo}
>   iomap: introduce io{read|write}64_{lo_hi|hi_lo}
>   io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
>   ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
>   crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
>   ntb: ntb_hw_switchtec: Cleanup 64bit IO defines to use the common
>     header
>
>  arch/parisc/include/asm/io.h           |   9 +++
>  arch/parisc/lib/iomap.c                |  64 +++++++++++++++
>  arch/powerpc/include/asm/io.h          |   6 +-
>  arch/powerpc/kernel/iomap.c            |  40 ++++++++++
>  drivers/crypto/caam/regs.h             |  30 +------
>  drivers/ntb/hw/intel/ntb_hw_intel.c    |  30 +------
>  drivers/ntb/hw/mscc/ntb_hw_switchtec.c |  36 +--------
>  include/asm-generic/iomap.h            |  26 ++++--
>  include/linux/io-64-nonatomic-hi-lo.h  |  64 +++++++++++++++
>  include/linux/io-64-nonatomic-lo-hi.h  |  64 +++++++++++++++
>  lib/iomap.c                            | 140 ++++++++++++++++++++++++++++++++-
>  11 files changed, 409 insertions(+), 100 deletions(-)
>
> --
> 2.11.0
