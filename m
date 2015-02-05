From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 0/7] Add VMX module for PPC64
Date: Thu, 5 Feb 2015 15:14:57 -0200
Message-ID: <20150205171454.GA12869@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

VMX cryptographic acceleration instructions were added to the POWER8
CPU. These instructions implement portions of AES and GHASH in hardware. 

This patch set adds a new module for PPC64, vmx, that support
cryptographic routines such as AES and GHASH on hardware. In order to 
access VMX instructions on Power 8 CPU this module uses scripts 
implemented in colaboration with OpenSSL.

Leonidas S. Barbosa (2):
  Add support for VMS instructions by ASM
  Enabling VMX module for PPC64

Marcelo H. Cerri (5):
  Adding VMX module for Power 8
  Adding AES routines for VMX module
  Adding CBC routines for VMX module
  Adding CTR routines for VMX module
  Adding GHASH routines for VMX module

 drivers/crypto/Kconfig            |   12 +
 drivers/crypto/Makefile           |    1 +
 drivers/crypto/vmx/Kconfig        |    9 +
 drivers/crypto/vmx/Makefile       |   21 +
 drivers/crypto/vmx/aes.c          |  139 +++
 drivers/crypto/vmx/aes_cbc.c      |  184 ++++
 drivers/crypto/vmx/aes_ctr.c      |  167 ++++
 drivers/crypto/vmx/aesp8-ppc.h    |   20 +
 drivers/crypto/vmx/aesp8-ppc.pl   | 1940 +++++++++++++++++++++++++++++++++++++
 drivers/crypto/vmx/ghash.c        |  214 ++++
 drivers/crypto/vmx/ghashp8-ppc.pl |  234 +++++
 drivers/crypto/vmx/ppc-xlate.pl   |  226 +++++
 drivers/crypto/vmx/vmx.c          |   88 ++
 13 files changed, 3255 insertions(+)
 create mode 100644 drivers/crypto/vmx/Kconfig
 create mode 100644 drivers/crypto/vmx/Makefile
 create mode 100644 drivers/crypto/vmx/aes.c
 create mode 100644 drivers/crypto/vmx/aes_cbc.c
 create mode 100644 drivers/crypto/vmx/aes_ctr.c
 create mode 100644 drivers/crypto/vmx/aesp8-ppc.h
 create mode 100755 drivers/crypto/vmx/aesp8-ppc.pl
 create mode 100644 drivers/crypto/vmx/ghash.c
 create mode 100755 drivers/crypto/vmx/ghashp8-ppc.pl
 create mode 100755 drivers/crypto/vmx/ppc-xlate.pl
 create mode 100644 drivers/crypto/vmx/vmx.c

-- 
2.1.0
