From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 0/3] crypto: omap-des: Add driver for OMAP DES module
Date: Thu, 29 Aug 2013 18:27:50 -0500
Message-ID: <1377818873-21174-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Greer <mgreer@animalcreek.com>,
	Tony Lindgren <tony@atomide.com>,
	Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

OMAP4 and AM437x SoCs have a DES3DES module which is capable of performing DES
encrypt/decrypt and 3DES ede encrypt/decrypt operations. Following patch series
adds support for the same.

Tests have been performed with crypto/testmgr and all tests are successful.

Joel Fernandes (3):
  crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
  crypto: omap-des: Add config and build options
  crypto: omap-des: Add triple DES (des3_ede) support to driver

 drivers/crypto/Kconfig    |   11 +
 drivers/crypto/Makefile   |    1 +
 drivers/crypto/omap-des.c | 1239 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1251 insertions(+)
 create mode 100644 drivers/crypto/omap-des.c

-- 
1.8.1.2
