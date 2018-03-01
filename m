From: Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH 0/2] Keystone2 HW random generator
Date: Thu, 1 Mar 2018 07:54:58 -0500
Message-ID: <1519908900-10388-1-git-send-email-vitalya@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <t-kristo@ti.com>, <vitalya@ti.com>, <m-karicheri2@ti.com>
To: <mpm@selenic.com>, <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Keyston2 Security Accelerator has a hardware random generator sub-module.
This series adds the driver for the sub-module.

Vitaly Andrianov (2):
  Documentation: dt: rng: add bindings doc for Keystone SA HWRNG driver
  hw_random: keystone2: add hw_random driver

 .../devicetree/bindings/rng/ks-sa-rng.txt          |  21 ++
 drivers/char/hw_random/Kconfig                     |   7 +
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/ks-sa-rng.c                 | 257 +++++++++++++++++++++
 4 files changed, 286 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/ks-sa-rng.txt
 create mode 100644 drivers/char/hw_random/ks-sa-rng.c

-- 
2.7.4
