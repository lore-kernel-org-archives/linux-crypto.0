From: Mahipal Challa <mahipalreddy2006@gmail.com>
Subject: [RFC PATCH v2 0/3] Cavium ThunderX ZIP driver
Date: Wed, 15 Feb 2017 10:45:07 +0530
Message-ID: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan.Glauber@cavium.com,
        Vishnu.Nair@cavium.com, pathreya@cavium.com,
        Mahipal.Challa@cavium.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33499 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdBOFP0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:15:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This series adds support for hardware accelerated compression & decompression
as found on ThunderX (arm64) SOCs.

As per your suggestion, we've switched to the new crypto acomp/scomp interface.

To test the ZIP driver, we modified the kernel's ZSWAP to use acomp API's.

Performance numbers from ZSWAP look promising.
The "average time" for compressing a 4KB page:

Compression Software    : 278 usec
Compression HW deflate  :  17 usec
Compression HW LZS      :  11 usec

Decompression Software  : 20 usec
Decompression HW deflate:  8 usec
Decompression HW LZS    :  6 usec

Addressed the review comments from the RFC v1.
 - Added acomp/scomp crypto interface support.
 - Improved the error handling.
 - ZIP command completion codes are renamed suitably.
 - Removed some un-used code.
 - raw_smp_processor_id() replaced with smp_processor_id().
 - Some more miscellaneous changes. 

Patches are on top of "kernel/git/herbert/crypto-2.6.git" repository

Please provide your feedback.

Regards,
Mahipal 
------------

Mahipal Challa (3):
  crypto: zip - Add ThunderX ZIP driver core
  crypto: zip - Wire-up Compression / decompression HW offload
  crypto: zip - Add Compression/Decompression statistics

 drivers/crypto/Kconfig                  |    7 +
 drivers/crypto/Makefile                 |    1 +
 drivers/crypto/cavium/Makefile          |    4 +
 drivers/crypto/cavium/zip/Makefile      |   11 +
 drivers/crypto/cavium/zip/common.h      |  202 +++++
 drivers/crypto/cavium/zip/zip_crypto.c  |  314 +++++++
 drivers/crypto/cavium/zip/zip_crypto.h  |   79 ++
 drivers/crypto/cavium/zip/zip_deflate.c |  200 +++++
 drivers/crypto/cavium/zip/zip_deflate.h |   62 ++
 drivers/crypto/cavium/zip/zip_device.c  |  202 +++++
 drivers/crypto/cavium/zip/zip_device.h  |  108 +++
 drivers/crypto/cavium/zip/zip_inflate.c |  223 +++++
 drivers/crypto/cavium/zip/zip_inflate.h |   62 ++
 drivers/crypto/cavium/zip/zip_main.c    |  729 +++++++++++++++++
 drivers/crypto/cavium/zip/zip_main.h    |  121 +++
 drivers/crypto/cavium/zip/zip_mem.c     |  114 +++
 drivers/crypto/cavium/zip/zip_mem.h     |   78 ++
 drivers/crypto/cavium/zip/zip_regs.h    | 1347 +++++++++++++++++++++++++++++++
 18 files changed, 3864 insertions(+)
 create mode 100644 drivers/crypto/cavium/Makefile
 create mode 100644 drivers/crypto/cavium/zip/Makefile
 create mode 100644 drivers/crypto/cavium/zip/common.h
 create mode 100644 drivers/crypto/cavium/zip/zip_crypto.c
 create mode 100644 drivers/crypto/cavium/zip/zip_crypto.h
 create mode 100644 drivers/crypto/cavium/zip/zip_deflate.c
 create mode 100644 drivers/crypto/cavium/zip/zip_deflate.h
 create mode 100644 drivers/crypto/cavium/zip/zip_device.c
 create mode 100644 drivers/crypto/cavium/zip/zip_device.h
 create mode 100644 drivers/crypto/cavium/zip/zip_inflate.c
 create mode 100644 drivers/crypto/cavium/zip/zip_inflate.h
 create mode 100644 drivers/crypto/cavium/zip/zip_main.c
 create mode 100644 drivers/crypto/cavium/zip/zip_main.h
 create mode 100644 drivers/crypto/cavium/zip/zip_mem.c
 create mode 100644 drivers/crypto/cavium/zip/zip_mem.h
 create mode 100644 drivers/crypto/cavium/zip/zip_regs.h

-- 
1.8.3.1
