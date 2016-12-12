From: Jan Glauber <jglauber@cavium.com>
Subject: [RFC PATCH 0/3] Cavium ThunderX ZIP driver
Date: Mon, 12 Dec 2016 16:04:36 +0100
Message-ID: <20161212150439.18627-1-jglauber@cavium.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Vishnu Nair <Vishnu.Nair@cavium.com>,
        Jan Glauber <jglauber@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:33319 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbcLLPFE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 10:05:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

this series adds support for hardware accelerated compression & decompression
as found on ThunderX (arm64) SOCs. I've been reviewing this driver internally
for some time and would like to get feedback on the RFC to see if this goes
into the right direction and to see if there are any concerns.

We've discussed switching to the new acomp algorithm but for the time being
decided against acomp because our test cases are not yet supported with it.

To test the ZIP driver we've used ZSWAP and IPComp.

Performance numbers from ZSWAP look promising.
The "average time" for compressing a 4KB page:

Compression Software	:  128 usec
Compression HW deflate	:   16 usec
Compression HW LZS	:   10 usec

Decompression Software	: 20 usec
Decompression HW deflate: 7 usec
Decompression HW LZS	: 5 usec

Patches are on top of 4.9.

Feedback welcome!
Jan 

---------------------

Mahipal Challa (3):
  crypto: zip - Add ThunderX ZIP driver core
  crypto: zip - Wire-up Compression / decompression HW offload
  crypto: zip - Add Compression/decompression statistics

 drivers/crypto/Kconfig                  |    7 +
 drivers/crypto/Makefile                 |    1 +
 drivers/crypto/cavium/Makefile          |    4 +
 drivers/crypto/cavium/zip/Makefile      |   11 +
 drivers/crypto/cavium/zip/common.h      |  258 ++++++
 drivers/crypto/cavium/zip/zip_crypto.c  |  243 ++++++
 drivers/crypto/cavium/zip/zip_crypto.h  |   67 ++
 drivers/crypto/cavium/zip/zip_deflate.c |  200 +++++
 drivers/crypto/cavium/zip/zip_deflate.h |   62 ++
 drivers/crypto/cavium/zip/zip_device.c  |  209 +++++
 drivers/crypto/cavium/zip/zip_device.h  |  138 ++++
 drivers/crypto/cavium/zip/zip_inflate.c |  223 ++++++
 drivers/crypto/cavium/zip/zip_inflate.h |   62 ++
 drivers/crypto/cavium/zip/zip_main.c    |  698 ++++++++++++++++
 drivers/crypto/cavium/zip/zip_main.h    |  141 ++++
 drivers/crypto/cavium/zip/zip_mem.c     |  120 +++
 drivers/crypto/cavium/zip/zip_mem.h     |   78 ++
 drivers/crypto/cavium/zip/zip_regs.h    | 1326 +++++++++++++++++++++++++++++++
 18 files changed, 3848 insertions(+)
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
2.9.0.rc0.21.g7777322
