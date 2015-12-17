From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 0/4] crypto: add precalculated hash for zero message length
Date: Thu, 17 Dec 2015 13:45:38 +0100
Message-ID: <1450356342-12971-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, davem@davemloft.net,
	geert+renesas@glider.be, herbert@gondor.apana.org.au,
	luis@debethencourt.com, maxime.ripard@free-electrons.com,
	thomas.lendacky@amd.com, vinod.koul@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34310 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbbLQMpv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 07:45:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

Some crypto drivers cannot process empty data message and so rely on
precalculated hash.
This patch series add precalculated hash in headers and
make the drivers use them.

Changes since v3
- Added missing Kconfig depends on SHA256

Changes since v2
- Added missing Kconfig depends on MD5/SHA1

Changes since v1
- Moved arrays from headers to c file and made them EXPORT.

LABBE Corentin (4):
  crypto: hash: add zero length message hash for shax and md5
  crypto: niagara: Use precalculated hash from headers
  crypto: ccp: Use precalculated hash from headers
  crypto: ux500: Use precalculated hash from headers

 crypto/md5.c                          |  6 ++++++
 crypto/sha1_generic.c                 |  7 +++++++
 crypto/sha256_generic.c               | 16 ++++++++++++++
 drivers/crypto/Kconfig                |  3 +++
 drivers/crypto/ccp/Kconfig            |  2 ++
 drivers/crypto/ccp/ccp-ops.c          | 39 +++++++----------------------------
 drivers/crypto/n2_core.c              | 33 ++++++-----------------------
 drivers/crypto/ux500/Kconfig          |  2 ++
 drivers/crypto/ux500/hash/hash_core.c | 20 ++----------------
 include/crypto/md5.h                  |  2 ++
 include/crypto/sha.h                  |  6 ++++++
 11 files changed, 60 insertions(+), 76 deletions(-)

-- 
2.4.10
