From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 0/2] Introduce AMD Secure Processor device
Date: Thu, 19 Jan 2017 13:07:50 -0500
Message-ID: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <brijesh.singh@amd.com>
To: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <lambert.quentin@gmail.com>, <gary.hook@amd.com>,
        <linux-kernel@vger.kernel.org>, <Julia.Lawall@lip6.fr>,
        <weiyongjun1@huawei.com>, <linux-crypto@vger.kernel.org>,
        <umgwanakikbuti@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
which is not dedicated solely to crypto. The AMD Secure Processor includes
CCP and PSP (Platform Secure Processor) devices.

This patch series moves the CCP device driver to the misc directory and
creates a framework that allows functional component of the AMD Secure
Processor to be initialized and handled appropriately.

The patch series leaves the CCP cryptographic layer (ccp-crypto* files) in
their current directory.

The new interface will be used to integrate Secure Encrypted Virtualzation [1]
key management and Trusted Execution Environment (TEE) services provided
by PSP device.
 
http://marc.info/?l=linux-mm&m=147190938124206&w=2

Brijesh Singh (2):
      crypto: move CCP device driver to misc
      misc: amd-sp: introduce the AMD Secure Processor device


 drivers/crypto/Kconfig              |   11 
 drivers/crypto/Makefile             |    2 
 drivers/crypto/ccp/Kconfig          |   22 
 drivers/crypto/ccp/Makefile         |    9 
 drivers/crypto/ccp/ccp-dev-v3.c     |  574 -----------
 drivers/crypto/ccp/ccp-dev-v5.c     | 1021 -------------------
 drivers/crypto/ccp/ccp-dev.c        |  588 -----------
 drivers/crypto/ccp/ccp-dev.h        |  647 ------------
 drivers/crypto/ccp/ccp-dmaengine.c  |  728 --------------
 drivers/crypto/ccp/ccp-ops.c        | 1876 -----------------------------------
 drivers/crypto/ccp/ccp-pci.c        |  354 -------
 drivers/crypto/ccp/ccp-platform.c   |  293 -----
 drivers/misc/Kconfig                |    1 
 drivers/misc/Makefile               |    1 
 drivers/misc/amd-sp/Kconfig         |   22 
 drivers/misc/amd-sp/Makefile        |    9 
 drivers/misc/amd-sp/ccp-dev-v3.c    |  578 +++++++++++
 drivers/misc/amd-sp/ccp-dev-v5.c    | 1017 +++++++++++++++++++
 drivers/misc/amd-sp/ccp-dev.c       |  611 +++++++++++
 drivers/misc/amd-sp/ccp-dev.h       |  618 ++++++++++++
 drivers/misc/amd-sp/ccp-dmaengine.c |  728 ++++++++++++++
 drivers/misc/amd-sp/ccp-ops.c       | 1876 +++++++++++++++++++++++++++++++++++
 drivers/misc/amd-sp/ccp-pci.c       |  354 +++++++
 drivers/misc/amd-sp/ccp-platform.c  |  293 +++++
 drivers/misc/amd-sp/sp-dev.c        |  309 ++++++
 drivers/misc/amd-sp/sp-dev.h        |  141 +++
 drivers/misc/amd-sp/sp-pci.c        |  325 ++++++
 drivers/misc/amd-sp/sp-platform.c   |  269 +++++
 include/linux/ccp.h                 |    3 
 29 files changed, 7159 insertions(+), 6121 deletions(-)
 delete mode 100644 drivers/crypto/ccp/ccp-dev-v3.c
 delete mode 100644 drivers/crypto/ccp/ccp-dev-v5.c
 delete mode 100644 drivers/crypto/ccp/ccp-dev.c
 delete mode 100644 drivers/crypto/ccp/ccp-dev.h
 delete mode 100644 drivers/crypto/ccp/ccp-dmaengine.c
 delete mode 100644 drivers/crypto/ccp/ccp-ops.c
 delete mode 100644 drivers/crypto/ccp/ccp-pci.c
 delete mode 100644 drivers/crypto/ccp/ccp-platform.c
 create mode 100644 drivers/misc/amd-sp/Kconfig
 create mode 100644 drivers/misc/amd-sp/Makefile
 create mode 100644 drivers/misc/amd-sp/ccp-dev-v3.c
 create mode 100644 drivers/misc/amd-sp/ccp-dev-v5.c
 create mode 100644 drivers/misc/amd-sp/ccp-dev.c
 create mode 100644 drivers/misc/amd-sp/ccp-dev.h
 create mode 100644 drivers/misc/amd-sp/ccp-dmaengine.c
 create mode 100644 drivers/misc/amd-sp/ccp-ops.c
 create mode 100644 drivers/misc/amd-sp/ccp-pci.c
 create mode 100644 drivers/misc/amd-sp/ccp-platform.c
 create mode 100644 drivers/misc/amd-sp/sp-dev.c
 create mode 100644 drivers/misc/amd-sp/sp-dev.h
 create mode 100644 drivers/misc/amd-sp/sp-pci.c
 create mode 100644 drivers/misc/amd-sp/sp-platform.c

-- 

Brijesh Singh
