From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Wed, 28 Sep 2016 13:42:08 -0300
Message-ID: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series fixes the memory corruption found by Jan Stancek in 4.8-rc7. The
problem however also affects previous versions of the driver.

Marcelo Cerri (3):
  crypto: ghash-generic - move common definitions to a new header file
  crypto: vmx - Fix memory corruption caused by p8_ghash
  crypto: vmx - Ensure ghash-generic is enabled

 crypto/ghash-generic.c     | 13 +------------
 drivers/crypto/vmx/Kconfig |  2 +-
 drivers/crypto/vmx/ghash.c | 31 ++++++++++++++++---------------
 include/crypto/ghash.h     | 23 +++++++++++++++++++++++
 4 files changed, 41 insertions(+), 28 deletions(-)
 create mode 100644 include/crypto/ghash.h

-- 
2.7.4
