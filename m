From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 0/9] Enable hashing and ciphers for v5 CCP
Date: Fri, 4 Nov 2016 11:03:12 -0500
Message-ID: <20161104160140.18155.75618.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:41376
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935059AbcKDQDc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2016 12:03:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements new function for a version
5 CCP: Support for SHA-2, wiring of RSA using the updated
framework, additional RSA features for new devices, AES GCM
mode, and Triple-DES in ECB and CBC mode.

---

Gary R Hook (9):
      crypto: ccp - Fix handling of RSA exponent on a v5 device
      crypto: ccp - Update the command queue on errors
      crypto: ccp - Simplify some buffer management routines
      crypto: ccp - Add SHA-2 support
      crypto: Move RSA+MPI constructs into an #include file
      crypto: ccp - Add support for RSA on the CCP
      crypto: ccp - Enhance RSA support for a v5 CCP
      crypto: ccp - Enable support for AES GCM on v5 CCPs
      crypto: ccp - Enable 3DES function on v5 CCPs


 crypto/rsa.c                               |   16 -
 drivers/crypto/ccp/Makefile                |    3 
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257 ++++++++++
 drivers/crypto/ccp/ccp-crypto-des3.c       |  254 ++++++++++
 drivers/crypto/ccp/ccp-crypto-main.c       |   41 ++
 drivers/crypto/ccp/ccp-crypto-rsa.c        |  297 +++++++++++
 drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
 drivers/crypto/ccp/ccp-crypto.h            |   75 +++
 drivers/crypto/ccp/ccp-dev-v3.c            |    2 
 drivers/crypto/ccp/ccp-dev-v5.c            |   67 ++-
 drivers/crypto/ccp/ccp-dev.h               |   17 +
 drivers/crypto/ccp/ccp-ops.c               |  740 ++++++++++++++++++++++++----
 include/crypto/internal/rsa.h              |   17 +
 include/linux/ccp.h                        |   69 +++
 14 files changed, 1736 insertions(+), 141 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c

--
This is my day job.
Follow me on FB/IG/Twitter: @grhphotographer and @grhookphoto
