From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 0/8] remove 'platform' shared NX driver
Date: Wed, 22 Jul 2015 14:26:30 -0400
Message-ID: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35081 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbGVS05 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 14:26:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The shared 'platform' driver module isn't needed, the platform drivers
can directly register with crypto instead.  It only adds unneeded
complexity and problems.

The first 4 patches are minor updates/bugfixes to the pSeries driver.

The 5th patch is a minor update to the NX crypto driver.

The last 3 patches merge the crypto and common code driver, and move
the crypto compression driver registration into the platform (pSeries
and PowerNV) drivers.  Both platform drivers use the same alg name and
driver name when registering, but since only one (at most) will register
on a system, depending on the platform, their registration will not
conflict.

Dan Streetman (8):
  crypto: nx - remove __init/__exit from VIO functions
  crypto: nx - remove pSeries NX 'status' field
  crypto: nx - move kzalloc() out of spinlock
  crypto: nx - don't register pSeries driver if ENODEV
  crypto: nx - use common code for both NX decompress success cases
  crypto: nx - merge nx-compress and nx-compress-crypto
  crypto: nx - rename nx-842-crypto.c to nx-842.c
  crypto: nx - make platform drivers directly register with crypto

 drivers/crypto/nx/Kconfig           |  17 +-
 drivers/crypto/nx/Makefile          |   8 +-
 drivers/crypto/nx/nx-842-crypto.c   | 602 ------------------------------------
 drivers/crypto/nx/nx-842-platform.c |  84 -----
 drivers/crypto/nx/nx-842-powernv.c  |  29 +-
 drivers/crypto/nx/nx-842-pseries.c  | 126 ++++----
 drivers/crypto/nx/nx-842.c          | 554 +++++++++++++++++++++++++++++----
 drivers/crypto/nx/nx-842.h          |  65 +++-
 8 files changed, 638 insertions(+), 847 deletions(-)
 delete mode 100644 drivers/crypto/nx/nx-842-crypto.c
 delete mode 100644 drivers/crypto/nx/nx-842-platform.c

-- 
2.1.0
