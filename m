From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/7] staging: ccree: remove ccree from staging tree
Date: Thu, 11 Jan 2018 09:17:08 +0000
Message-ID: <1515662239-1714-2-git-send-email-gilad@benyossef.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Remove the ccree driver from the staging tree in preparation to
introducing it in the crypto tree.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 .../devicetree/bindings/crypto/arm-cryptocell.txt  |   27 -
 drivers/staging/ccree/Kconfig                      |   25 -
 drivers/staging/ccree/Makefile                     |    3 -
 drivers/staging/ccree/TODO                         |   30 -
 drivers/staging/ccree/cc_crypto_ctx.h              |  200 --
 drivers/staging/ccree/cc_hw_queue_defs.h           |  594 -----
 drivers/staging/ccree/cc_lli_defs.h                |   72 -
 drivers/staging/ccree/dx_crys_kernel.h             |  180 --
 drivers/staging/ccree/dx_host.h                    |  155 --
 drivers/staging/ccree/dx_reg_common.h              |   26 -
 drivers/staging/ccree/hash_defs.h                  |   36 -
 drivers/staging/ccree/ssi_aead.c                   | 2794 --------------------
 drivers/staging/ccree/ssi_aead.h                   |  117 -
 drivers/staging/ccree/ssi_buffer_mgr.c             | 1776 -------------
 drivers/staging/ccree/ssi_buffer_mgr.h             |   91 -
 drivers/staging/ccree/ssi_cipher.c                 | 1357 ----------
 drivers/staging/ccree/ssi_cipher.h                 |   84 -
 drivers/staging/ccree/ssi_config.h                 |   36 -
 drivers/staging/ccree/ssi_driver.c                 |  538 ----
 drivers/staging/ccree/ssi_driver.h                 |  206 --
 drivers/staging/ccree/ssi_fips.c                   |  126 -
 drivers/staging/ccree/ssi_fips.h                   |   49 -
 drivers/staging/ccree/ssi_hash.c                   | 2549 ------------------
 drivers/staging/ccree/ssi_hash.h                   |  103 -
 drivers/staging/ccree/ssi_ivgen.c                  |  299 ---
 drivers/staging/ccree/ssi_ivgen.h                  |   71 -
 drivers/staging/ccree/ssi_pm.c                     |  145 -
 drivers/staging/ccree/ssi_pm.h                     |   43 -
 drivers/staging/ccree/ssi_request_mgr.c            |  610 -----
 drivers/staging/ccree/ssi_request_mgr.h            |   60 -
 drivers/staging/ccree/ssi_sram_mgr.c               |  123 -
 drivers/staging/ccree/ssi_sram_mgr.h               |   79 -
 drivers/staging/ccree/ssi_sysfs.c                  |  172 --
 drivers/staging/ccree/ssi_sysfs.h                  |   55 -
 36 files changed, 12834 deletions(-)
 delete mode 100644 drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
 delete mode 100644 drivers/staging/ccree/Kconfig
 delete mode 100644 drivers/staging/ccree/Makefile
 delete mode 100644 drivers/staging/ccree/TODO
 delete mode 100644 drivers/staging/ccree/cc_crypto_ctx.h
 delete mode 100644 drivers/staging/ccree/cc_hw_queue_defs.h
 delete mode 100644 drivers/staging/ccree/cc_lli_defs.h
 delete mode 100644 drivers/staging/ccree/dx_crys_kernel.h
 delete mode 100644 drivers/staging/ccree/dx_host.h
 delete mode 100644 drivers/staging/ccree/dx_reg_common.h
 delete mode 100644 drivers/staging/ccree/hash_defs.h
 delete mode 100644 drivers/staging/ccree/ssi_aead.c
 delete mode 100644 drivers/staging/ccree/ssi_aead.h
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_cipher.c
 delete mode 100644 drivers/staging/ccree/ssi_cipher.h
 delete mode 100644 drivers/staging/ccree/ssi_config.h
 delete mode 100644 drivers/staging/ccree/ssi_driver.c
 delete mode 100644 drivers/staging/ccree/ssi_driver.h
 delete mode 100644 drivers/staging/ccree/ssi_fips.c
 delete mode 100644 drivers/staging/ccree/ssi_fips.h
 delete mode 100644 drivers/staging/ccree/ssi_hash.c
 delete mode 100644 drivers/staging/ccree/ssi_hash.h
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.c
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.h
 delete mode 100644 drivers/staging/ccree/ssi_pm.c
 delete mode 100644 drivers/staging/ccree/ssi_pm.h
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.c
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 5546839..72946bf 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -110,8 +110,6 @@ source "drivers/staging/greybus/Kconfig"
 
 source "drivers/staging/vc04_services/Kconfig"
 
-source "drivers/staging/ccree/Kconfig"
-
 source "drivers/staging/typec/Kconfig"
 
 source "drivers/staging/vboxvideo/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 6e53602..7612bee 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -47,6 +47,5 @@ obj-$(CONFIG_MOST)		+= most/
 obj-$(CONFIG_KS7010)		+= ks7010/
 obj-$(CONFIG_GREYBUS)		+= greybus/
 obj-$(CONFIG_BCM2835_VCHIQ)	+= vc04_services/
-obj-$(CONFIG_CRYPTO_DEV_CCREE)	+= ccree/
 obj-$(CONFIG_DRM_VBOXVIDEO)	+= vboxvideo/
 obj-$(CONFIG_PI433)		+= pi433/
diff --git a/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
deleted file mode 100644
index 2ea6517..0000000
diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
deleted file mode 100644
index 0b3092b..0000000
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
deleted file mode 100644
index ae702f3..0000000
diff --git a/drivers/staging/ccree/TODO b/drivers/staging/ccree/TODO
deleted file mode 100644
index c9f5754..0000000
diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
deleted file mode 100644
index 591f6fd..0000000
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
deleted file mode 100644
index 2ae0f65..0000000
diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
deleted file mode 100644
index a9c417b..0000000
diff --git a/drivers/staging/ccree/dx_crys_kernel.h b/drivers/staging/ccree/dx_crys_kernel.h
deleted file mode 100644
index 2196030..0000000
diff --git a/drivers/staging/ccree/dx_host.h b/drivers/staging/ccree/dx_host.h
deleted file mode 100644
index 863c267..0000000
diff --git a/drivers/staging/ccree/dx_reg_common.h b/drivers/staging/ccree/dx_reg_common.h
deleted file mode 100644
index d5132ff..0000000
diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
deleted file mode 100644
index f52656f..0000000
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
deleted file mode 100644
index ba0954e..0000000
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
deleted file mode 100644
index e85bcd9..0000000
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
deleted file mode 100644
index 1f8a225..0000000
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
deleted file mode 100644
index 1032f25..0000000
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
deleted file mode 100644
index ee85cbf..0000000
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
deleted file mode 100644
index 25e6335..0000000
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
deleted file mode 100644
index ff7597c..0000000
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
deleted file mode 100644
index 1a3c481..0000000
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
deleted file mode 100644
index 94c755c..0000000
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
deleted file mode 100644
index 4aea99f..0000000
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
deleted file mode 100644
index 63bcca7..0000000
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
deleted file mode 100644
index 1799d3f..0000000
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
deleted file mode 100644
index 2400e38..0000000
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
deleted file mode 100644
index 3f082f4..0000000
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
deleted file mode 100644
index 961aea4..0000000
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
deleted file mode 100644
index 36a4980..0000000
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
deleted file mode 100644
index 63673f6..0000000
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
deleted file mode 100644
index a8a7dc6..0000000
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
deleted file mode 100644
index bdbbf89..0000000
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
deleted file mode 100644
index 07260d1..0000000
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
deleted file mode 100644
index 9ba1d59..0000000
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
deleted file mode 100644
index 5d39f15..0000000
diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
deleted file mode 100644
index 44ae3d4..0000000
-- 
2.7.4
