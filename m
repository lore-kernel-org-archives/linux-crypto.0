Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:39586 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388549AbeKGGTq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 01:19:46 -0500
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date: Tue,  6 Nov 2018 13:52:28 -0700
Message-Id: <20181106205234.25792-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v23 0/6] Add io{read|write}64 to io-64-atomic headers
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is another resend:

Andrew, can you please pick this set up again so it can get into
linux-next? Or let me know if there's something else I should do.

I've been try to get this in for 15 months and I'm getting a bit tired of
submitting it repeatedly with no responses.

Thanks,

Logan

--

Changes since v22:
- Rebased onto v4.20-rc1 (No Changes)

Changes since v21:
- Rebased onto v4.19-rc6 (No Changes)

Changes since v20:
- Rebased onto v4.19-rc3 (No Changes)

Changes since v19:
- Rebased onto v4.19-rc1 (No Changes)

Changes since v18:
- Dropped the CAAM patch as it was subtly wrong and broke when people
  tested it in linux-next. Seeing the code is much trickier than it
  appears, we'll leave it to its maintainers to clean it up,
  should they chose.
- Restored the ioread64/iowrite64 extern prototypes as despite
  appearing to be unusued, they are in fact used in a rare corner case
  by the caam driver on 64bit powerpc. This was reported by Guenter testing
  on linux-next.
- Rebased onto v4.18-rc4 (No Changes)

Changes since v17:
- Rebased onto v4.18-rc1 (No Changes)

Changes since v16:
- Rebased onto v4.17-rc4 (No Changes)

Changes since v15:
- Rebased onto v4.17-rc1, dropping the powerpc patches which were
  picked up by Michael

Changes since v14:
- Rebased onto v4.16-rc7
- Replace the first two patches so that instead of correcting the
  endianness annotations we change to using writeX() and readX() with
  swabX() calls. This makes the big-endian functions more symmetric
  with the little-endian versions (with respect to barriers that are
  not included in the raw functions). As a side effect, it also fixes
  the kbuild warnings that the first two patches tried to address.

Changes since v13:
- Changed the subject of patch 0001 to correct a nit pointed out by Luc

Changes since v12:
- Rebased onto v4.16-rc6
- Split patch 0001 into two and reworked the commit log as requested
  by Luc Van Oostenryck

Changes since v11:
- Rebased onto v4.16-rc5
- Added a patch (0001) to fix some old and new sparse warnings
  that the kbuild robot warned about this cycle. The latest version
  of sparse was required to reproduce these.
- Added a patch (0002) to add io{read|write}64 to parisc which the kbuild
  robot also found errors for this cycle

Changes since v10:
- Rebased onto v4.16-rc4, this droped the drm/tilcdc patch which was
  picked up by that tree and is already in 4.16.

Changes since v9:
- Rebased onto v4.15-rc6
- Fixed a couple of issues in the new version of the CAAM patch as
  pointed out by Horia

Changes since v8:
- Rebased onto v4.15-rc2, as a result rewrote patch 7 seeing someone did
  some similar cleanup in that area.
- Added a patch to clean up the Switchtec NTB driver which landed in
  v4.15-rc1

Changes since v7:
- Fix minor nits from Andy Shevchenko
- Rebased onto v4.14-rc1

Changes since v6:
 ** none **

Changes since v5:
- Added a fix to the tilcdc driver to ensure it doesn't use the
  non-atomic operation. (This includes adding io{read|write}64[be]_is_nonatomic
  defines).

Changes since v4:
- Add functions so the powerpc implementation of iomap.c compiles. (As
  noticed by Horia)

Changes since v3:

- I noticed powerpc didn't use the appropriate functions seeing
  readq/writeq were not defined when iomap.h was included. Thus I've
  included a patch to adjust this
- Fixed some mistakes with a couple of the defines in io-64-nonatomic*
  headers
- Fixed a typo noticed by Horia.

(earlier versions were drastically different)

Logan Gunthorpe (6):
  iomap: Use non-raw io functions for io{read|write}XXbe
  parisc: iomap: introduce io{read|write}64
  iomap: introduce io{read|write}64_{lo_hi|hi_lo}
  io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros
  ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks
  ntb: ntb_hw_switchtec: Cleanup 64bit IO defines to use the common
    header

 arch/parisc/include/asm/io.h           |   9 ++
 arch/parisc/lib/iomap.c                |  64 +++++++++++
 arch/powerpc/include/asm/io.h          |   2 +
 drivers/ntb/hw/intel/ntb_hw_intel.h    |  30 +-----
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c |  36 +------
 include/asm-generic/iomap.h            |  22 ++++
 include/linux/io-64-nonatomic-hi-lo.h  |  64 +++++++++++
 include/linux/io-64-nonatomic-lo-hi.h  |  64 +++++++++++
 lib/iomap.c                            | 140 ++++++++++++++++++++++++-
 9 files changed, 366 insertions(+), 65 deletions(-)

--
2.19.0
