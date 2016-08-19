From: Omer Khaliq <okhaliq@caviumnetworks.com>
Subject: [PATCH 0/2] hwrng/PCI/IOV: Add driver for Cavium Thunder RNG
Date: Fri, 19 Aug 2016 15:32:11 -0700
Message-ID: <1471645933-3643-1-git-send-email-okhaliq@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Omer Khaliq <okhaliq@caviumnetworks.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-arm-kernel@vger.kernel.org>,
        <bhelgaas@google.com>, <mpm@selenic.com>,
        <herbert@gondor.apana.org.au>, <Ananth.Jasty@cavium.com>,
        <david.daney@cavium.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There is a hardware error rendering the FDL field incorrect for the some Thunder RNG devices.  The first patch adds infrastructure to fix the problem.

The second patch adds the driver.

David Daney (1):
  PCI/IOV: Add function to allow Function Dependency Link override.

Omer Khaliq (1):
  hwrng: thunderx: Add Cavium HWRNG driver for ThunderX SoC.

 drivers/char/hw_random/Kconfig         |  13 +++++
 drivers/char/hw_random/Makefile        |   1 +
 drivers/char/hw_random/cavium-rng-vf.c | 102 ++++++++++++++++++++++++++++++++
 drivers/char/hw_random/cavium-rng.c    | 103 +++++++++++++++++++++++++++++++++
 drivers/pci/iov.c                      |  14 +++++
 include/linux/pci.h                    |   1 +
 6 files changed, 234 insertions(+)
 create mode 100644 drivers/char/hw_random/cavium-rng-vf.c
 create mode 100644 drivers/char/hw_random/cavium-rng.c

-- 
1.9.1
