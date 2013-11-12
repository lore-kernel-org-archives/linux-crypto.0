From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 00/10] AMD Cryptographic Coprocessor support
Date: Tue, 12 Nov 2013 11:45:59 -0600
Message-ID: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Resending because of typo in mailing list address...

The following series implements support for the AMD Cryptographic
Coprocessor (CCP).  The AMD CCP provides hardware encryption, hashing
and other related operations.

This patch series is based on the 3.12 kernel.

---

Tom Lendacky (10):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: CCP device driver and interface support
      crypto: crypto API interface to the CCP device driver
      crypto: CCP AES crypto API support
      crypto: CCP AES CMAC mode crypto API support
      crypto: CCP XTS-AES crypto API support
      crypto: CCP SHA crypto API support
      crytpo: CCP device driver build files
      crypto: CCP maintainer information


 MAINTAINERS                              |    7 
 crypto/authenc.c                         |    7 
 drivers/crypto/Kconfig                   |   12 
 drivers/crypto/Makefile                  |    1 
 drivers/crypto/ccp/Kconfig               |   23 
 drivers/crypto/ccp/Makefile              |   10 
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |  355 +++++
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |  285 ++++
 drivers/crypto/ccp/ccp-crypto-aes.c      |  375 ++++++
 drivers/crypto/ccp/ccp-crypto-main.c     |  432 ++++++
 drivers/crypto/ccp/ccp-crypto-sha.c      |  497 +++++++
 drivers/crypto/ccp/ccp-crypto.h          |  191 +++
 drivers/crypto/ccp/ccp-dev.c             |  582 +++++++++
 drivers/crypto/ccp/ccp-dev.h             |  272 ++++
 drivers/crypto/ccp/ccp-ops.c             | 2020 ++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-pci.c             |  360 +++++
 include/crypto/scatterwalk.h             |    1 
 include/linux/ccp.h                      |  525 ++++++++
 18 files changed, 5952 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/ccp/Kconfig
 create mode 100644 drivers/crypto/ccp/Makefile
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-cmac.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-xts.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-main.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto-sha.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto.h
 create mode 100644 drivers/crypto/ccp/ccp-dev.c
 create mode 100644 drivers/crypto/ccp/ccp-dev.h
 create mode 100644 drivers/crypto/ccp/ccp-ops.c
 create mode 100644 drivers/crypto/ccp/ccp-pci.c
 create mode 100644 include/linux/ccp.h

-- 
Tom Lendacky
