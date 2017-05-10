From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH v1 1/3] crypto: cavium - Add support for CNN55XX adapters.
Date: Wed, 10 May 2017 18:36:38 +0530
Message-ID: <20170510130640.5838-2-Jampala.Srikanth@cavium.com>
References: <20170510130640.5838-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, George.Cherian@cavium.com,
        Nidadavolu.Murthy@cavium.com, Sreerama.Gadam@cavium.com,
        Ram.Kumar@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0075.outbound.protection.outlook.com ([104.47.33.75]:13152
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752520AbdEJNHa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 09:07:30 -0400
In-Reply-To: <20170510130640.5838-1-Jampala.Srikanth@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Physical Function driver support for CNN55XX crypto adapters.
CNN55XX adapters belongs to Cavium NITROX family series,
which accelerate both Symmetric and Asymmetric crypto workloads.

These adapters have crypto engines that need firmware
to become operational.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/Kconfig                       |    1 +
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/cavium/nitrox/Kconfig         |   21 +
 drivers/crypto/cavium/nitrox/Makefile        |    7 +
 drivers/crypto/cavium/nitrox/nitrox_common.h |   29 +
 drivers/crypto/cavium/nitrox/nitrox_csr.h    | 1080 ++++++++++++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_dev.h    |  181 +++++
 drivers/crypto/cavium/nitrox/nitrox_hal.c    |  404 ++++++++++
 drivers/crypto/cavium/nitrox/nitrox_isr.c    |  449 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_lib.c    |  170 ++++
 drivers/crypto/cavium/nitrox/nitrox_main.c   |  460 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_req.h    |  438 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c |  572 ++++++++++++++
 13 files changed, 3813 insertions(+)
 create mode 100644 drivers/crypto/cavium/nitrox/Kconfig
 create mode 100644 drivers/crypto/cavium/nitrox/Makefile
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_common.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_csr.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_dev.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_hal.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_isr.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_lib.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_main.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_req.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index fb1e60f..235554e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -529,6 +529,7 @@ config CRYPTO_DEV_MXS_DCP
 
 source "drivers/crypto/qat/Kconfig"
 source "drivers/crypto/cavium/cpt/Kconfig"
+source "drivers/crypto/cavium/nitrox/Kconfig"
 
 config CRYPTO_DEV_CAVIUM_ZIP
 	tristate "Cavium ZIP driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 463f335..14209b9 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
 obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
+obj-$(CONFIG_CRYPTO_DEV_NITROX) += cavium/nitrox/
 obj-$(CONFIG_CRYPTO_DEV_EXYNOS_RNG) += exynos-rng.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
diff --git a/drivers/crypto/cavium/nitrox/Kconfig b/drivers/crypto/cavium/nitrox/Kconfig
new file mode 100644
index 0000000..d8b979f
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/Kconfig
@@ -0,0 +1,21 @@
+#
+# Cavium NITROX Crypto Device configuration
+#
+config CRYPTO_DEV_NITROX
+	tristate
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_AES
+	select CRYPTO_DES
+	select FW_LOADER
+
+config CRYPTO_DEV_NITROX_CNN55XX
+	tristate "Support for Cavium CNN55XX driver"
+	depends on PCI_MSI
+	select CRYPTO_DEV_NITROX
+	default m
+	help
+	  Support for Cavium NITROX family CNN55XX driver
+	  for accelerating crypto workloads.
+
+	  To compile this as a module, choose M here: the module
+	  will be called n5pf.
diff --git a/drivers/crypto/cavium/nitrox/Makefile b/drivers/crypto/cavium/nitrox/Makefile
new file mode 100644
index 0000000..ef457f6
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_CRYPTO_DEV_NITROX_CNN55XX) += n5pf.o
+
+n5pf-objs := nitrox_main.o \
+	nitrox_isr.o \
+	nitrox_lib.o \
+	nitrox_hal.o \
+	nitrox_reqmgr.o
diff --git a/drivers/crypto/cavium/nitrox/nitrox_common.h b/drivers/crypto/cavium/nitrox/nitrox_common.h
new file mode 100644
index 0000000..f79be7d
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_common.h
@@ -0,0 +1,29 @@
+#ifndef __NITROX_COMMON_H
+#define __NITROX_COMMON_H
+
+#include "nitrox_dev.h"
+#include "nitrox_req.h"
+
+void nitrox_pf_cleanup_isr(struct nitrox_device *ndev);
+int nitrox_pf_init_isr(struct nitrox_device *ndev);
+
+int nitrox_common_sw_init(struct nitrox_device *ndev);
+void nitrox_common_sw_cleanup(struct nitrox_device *ndev);
+
+void pkt_slc_resp_handler(unsigned long data);
+int nitrox_se_request(struct nitrox_device *ndev, struct crypto_request *req);
+
+void nitrox_config_emu_unit(struct nitrox_device *ndev);
+void nitrox_config_pkt_input_rings(struct nitrox_device *ndev);
+void nitrox_config_pkt_solicit_ports(struct nitrox_device *ndev);
+void nitrox_config_vfmode(struct nitrox_device *ndev, int mode);
+void nitrox_config_nps_unit(struct nitrox_device *ndev);
+void nitrox_config_pom_unit(struct nitrox_device *ndev);
+void nitrox_config_rand_unit(struct nitrox_device *ndev);
+void nitrox_config_efl_unit(struct nitrox_device *ndev);
+void nitrox_config_bmi_unit(struct nitrox_device *ndev);
+void nitrox_config_bmo_unit(struct nitrox_device *ndev);
+void nitrox_config_lbc_unit(struct nitrox_device *ndev);
+void invalidate_lbc(struct nitrox_device *ndev);
+
+#endif /* __NITROX_COMMON_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_csr.h b/drivers/crypto/cavium/nitrox/nitrox_csr.h
new file mode 100644
index 0000000..988a85d
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_csr.h
@@ -0,0 +1,1080 @@
+#ifndef __NITROX_CSR_H
+#define __NITROX_CSR_H
+
+#include <asm/byteorder.h>
+#include <linux/types.h>
+
+/* EMU clusters */
+#define NR_CLUSTERS		4
+#define AE_CORES_PER_CLUSTER	20
+#define SE_CORES_PER_CLUSTER	16
+
+/* BIST registers */
+#define EMU_BIST_STATUSX(_i)	(0x1402700 + ((_i) * 0x40000))
+#define UCD_BIST_STATUS		0x12C0070
+#define NPS_CORE_BIST_REG	0x10000E8
+#define NPS_CORE_NPC_BIST_REG	0x1000128
+#define NPS_PKT_SLC_BIST_REG	0x1040088
+#define NPS_PKT_IN_BIST_REG	0x1040100
+#define POM_BIST_REG		0x11C0100
+#define BMI_BIST_REG		0x1140080
+#define EFL_CORE_BIST_REGX(_i)	(0x1240100 + ((_i) * 0x400))
+#define EFL_TOP_BIST_STAT	0x1241090
+#define BMO_BIST_REG		0x1180080
+#define LBC_BIST_STATUS		0x1200020
+#define PEM_BIST_STATUSX(_i)	(0x1080468 | ((_i) << 18))
+
+/* EMU registers */
+#define EMU_SE_ENABLEX(_i)	(0x1400000 + ((_i) * 0x40000))
+#define EMU_AE_ENABLEX(_i)	(0x1400008 + ((_i) * 0x40000))
+#define EMU_WD_INT_ENA_W1SX(_i)	(0x1402318 + ((_i) * 0x40000))
+#define EMU_GE_INT_ENA_W1SX(_i)	(0x1402518 + ((_i) * 0x40000))
+#define EMU_FUSE_MAPX(_i)	(0x1402708 + ((_i) * 0x40000))
+
+/* UCD registers */
+#define UCD_UCODE_LOAD_BLOCK_NUM	0x12C0010
+#define UCD_UCODE_LOAD_IDX_DATAX(_i)	(0x12C0018 + ((_i) * 0x20))
+#define UCD_SE_EID_UCODE_BLOCK_NUMX(_i)	(0x12C0000 + ((_i) * 0x1000))
+
+/* NPS core registers */
+#define NPS_CORE_GBL_VFCFG	0x1000000
+#define NPS_CORE_CONTROL	0x1000008
+#define NPS_CORE_INT_ACTIVE	0x1000080
+#define NPS_CORE_INT		0x10000A0
+#define NPS_CORE_INT_ENA_W1S	0x10000B8
+
+/* NPS packet registers */
+#define NPS_PKT_INT				0x1040018
+#define NPS_PKT_IN_RERR_HI		0x1040108
+#define NPS_PKT_IN_RERR_HI_ENA_W1S	0x1040120
+#define NPS_PKT_IN_RERR_LO		0x1040128
+#define NPS_PKT_IN_RERR_LO_ENA_W1S	0x1040140
+#define NPS_PKT_IN_ERR_TYPE		0x1040148
+#define NPS_PKT_IN_ERR_TYPE_ENA_W1S	0x1040160
+#define NPS_PKT_IN_INSTR_CTLX(_i)	(0x10060 + ((_i) * 0x40000))
+#define NPS_PKT_IN_INSTR_BADDRX(_i)	(0x10068 + ((_i) * 0x40000))
+#define NPS_PKT_IN_INSTR_RSIZEX(_i)	(0x10070 + ((_i) * 0x40000))
+#define NPS_PKT_IN_DONE_CNTSX(_i)	(0x10080 + ((_i) * 0x40000))
+#define NPS_PKT_IN_INSTR_BAOFF_DBELLX(_i)	(0x10078 + ((_i) * 0x40000))
+#define NPS_PKT_IN_INT_LEVELSX(_i)		(0x10088 + ((_i) * 0x40000))
+
+#define NPS_PKT_SLC_RERR_HI		0x1040208
+#define NPS_PKT_SLC_RERR_HI_ENA_W1S	0x1040220
+#define NPS_PKT_SLC_RERR_LO		0x1040228
+#define NPS_PKT_SLC_RERR_LO_ENA_W1S	0x1040240
+#define NPS_PKT_SLC_ERR_TYPE		0x1040248
+#define NPS_PKT_SLC_ERR_TYPE_ENA_W1S	0x1040260
+#define NPS_PKT_SLC_CTLX(_i)		(0x10000 + ((_i) * 0x40000))
+#define NPS_PKT_SLC_CNTSX(_i)		(0x10008 + ((_i) * 0x40000))
+#define NPS_PKT_SLC_INT_LEVELSX(_i)	(0x10010 + ((_i) * 0x40000))
+
+/* POM registers */
+#define POM_INT_ENA_W1S		0x11C0018
+#define POM_GRP_EXECMASKX(_i)	(0x11C1100 | ((_i) * 8))
+#define POM_INT		0x11C0000
+#define POM_PERF_CTL	0x11CC400
+
+/* BMI registers */
+#define BMI_INT		0x1140000
+#define BMI_CTL		0x1140020
+#define BMI_INT_ENA_W1S	0x1140018
+
+/* EFL registers */
+#define EFL_CORE_INT_ENA_W1SX(_i)		(0x1240018 + ((_i) * 0x400))
+#define EFL_CORE_VF_ERR_INT0X(_i)		(0x1240050 + ((_i) * 0x400))
+#define EFL_CORE_VF_ERR_INT0_ENA_W1SX(_i)	(0x1240068 + ((_i) * 0x400))
+#define EFL_CORE_VF_ERR_INT1X(_i)		(0x1240070 + ((_i) * 0x400))
+#define EFL_CORE_VF_ERR_INT1_ENA_W1SX(_i)	(0x1240088 + ((_i) * 0x400))
+#define EFL_CORE_SE_ERR_INTX(_i)		(0x12400A0 + ((_i) * 0x400))
+#define EFL_RNM_CTL_STATUS			0x1241800
+#define EFL_CORE_INTX(_i)			(0x1240000 + ((_i) * 0x400))
+
+/* BMO registers */
+#define BMO_CTL2		0x1180028
+
+/* LBC registers */
+#define LBC_INT			0x1200000
+#define LBC_INVAL_CTL		0x1201010
+#define LBC_PLM_VF1_64_INT	0x1202008
+#define LBC_INVAL_STATUS	0x1202010
+#define LBC_INT_ENA_W1S		0x1203000
+#define LBC_PLM_VF1_64_INT_ENA_W1S	0x1205008
+#define LBC_PLM_VF65_128_INT		0x1206008
+#define LBC_ELM_VF1_64_INT		0x1208000
+#define LBC_PLM_VF65_128_INT_ENA_W1S	0x1209008
+#define LBC_ELM_VF1_64_INT_ENA_W1S	0x120B000
+#define LBC_ELM_VF65_128_INT		0x120C000
+#define LBC_ELM_VF65_128_INT_ENA_W1S	0x120F000
+
+/* PEM registers */
+#define PEM0_INT 0x1080428
+
+/**
+ * struct emu_fuse_map - EMU Fuse Map Registers
+ * @ae_fuse: Fuse settings for AE 19..0
+ * @se_fuse: Fuse settings for SE 15..0
+ *
+ * A set bit indicates the unit is fuse disabled.
+ */
+union emu_fuse_map {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 valid : 1;
+		u64 raz_52_62 : 11;
+		u64 ae_fuse : 20;
+		u64 raz_16_31 : 16;
+		u64 se_fuse : 16;
+#else
+		u64 se_fuse : 16;
+		u64 raz_16_31 : 16;
+		u64 ae_fuse : 20;
+		u64 raz_52_62 : 11;
+		u64 valid : 1;
+#endif
+	} s;
+};
+
+/**
+ * struct emu_se_enable - Symmetric Engine Enable Registers
+ * @enable: Individual enables for each of the clusters
+ *   16 symmetric engines.
+ */
+union emu_se_enable {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz	: 48;
+		u64 enable : 16;
+#else
+		u64 enable : 16;
+		u64 raz	: 48;
+#endif
+	} s;
+};
+
+/**
+ * struct emu_ae_enable - EMU Asymmetric engines.
+ * @enable: Individual enables for each of the cluster's
+ *   20 Asymmetric Engines.
+ */
+union emu_ae_enable {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz	: 44;
+		u64 enable : 20;
+#else
+		u64 enable : 20;
+		u64 raz	: 44;
+#endif
+	} s;
+};
+
+/**
+ * struct emu_wd_int_ena_w1s - EMU Interrupt Enable Registers
+ * @ae_wd: Reads or sets enable for EMU(0..3)_WD_INT[AE_WD]
+ * @se_wd: Reads or sets enable for EMU(0..3)_WD_INT[SE_WD]
+ */
+union emu_wd_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz2 : 12;
+		u64 ae_wd : 20;
+		u64 raz1 : 16;
+		u64 se_wd : 16;
+#else
+		u64 se_wd : 16;
+		u64 raz1 : 16;
+		u64 ae_wd : 20;
+		u64 raz2 : 12;
+#endif
+	} s;
+};
+
+/**
+ * struct emu_ge_int_ena_w1s - EMU Interrupt Enable set registers
+ * @ae_ge: Reads or sets enable for EMU(0..3)_GE_INT[AE_GE]
+ * @se_ge: Reads or sets enable for EMU(0..3)_GE_INT[SE_GE]
+ */
+union emu_ge_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_52_63 : 12;
+		u64 ae_ge : 20;
+		u64 raz_16_31: 16;
+		u64 se_ge : 16;
+#else
+		u64 se_ge : 16;
+		u64 raz_16_31: 16;
+		u64 ae_ge : 20;
+		u64 raz_52_63 : 12;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_slc_ctl - Solicited Packet Out Control Registers
+ * @rh: Indicates whether to remove or include the response header
+ *   1 = Include, 0 = Remove
+ * @z: If set, 8 trailing 0x00 bytes will be added to the end of the
+ *   outgoing packet.
+ * @enb: Enable for this port.
+ */
+union nps_pkt_slc_ctl {
+	u64 value;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 raz : 61;
+		u64 rh : 1;
+		u64 z : 1;
+		u64 enb : 1;
+#else
+		u64 enb : 1;
+		u64 z : 1;
+		u64 rh : 1;
+		u64 raz : 61;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_slc_cnts - Solicited Packet Out Count Registers
+ * @slc_int: Returns a 1 when:
+ *   NPS_PKT_SLC(i)_CNTS[CNT] > NPS_PKT_SLC(i)_INT_LEVELS[CNT], or
+ *   NPS_PKT_SLC(i)_CNTS[TIMER] > NPS_PKT_SLC(i)_INT_LEVELS[TIMET].
+ *   To clear the bit, the CNTS register must be written to clear.
+ * @in_int: Returns a 1 when:
+ *   NPS_PKT_IN(i)_DONE_CNTS[CNT] > NPS_PKT_IN(i)_INT_LEVELS[CNT].
+ *   To clear the bit, the DONE_CNTS register must be written to clear.
+ * @mbox_int: Returns a 1 when:
+ *   NPS_PKT_MBOX_PF_VF(i)_INT[INTR] is set. To clear the bit,
+ *   write NPS_PKT_MBOX_PF_VF(i)_INT[INTR] with 1.
+ * @timer: Timer, incremented every 2048 coprocessor clock cycles when [CNT]
+ *   is not zero. The hardware clears both [TIMER] and
+ *   [INT] when [CNT] goes to 0.
+ * @cnt: Packet counter. Hardware adds to [CNT] as it sends packets out.
+ *   On a write to this CSR, hardware subtracts the amount written to the
+ *   [CNT] field from [CNT].
+ */
+union nps_pkt_slc_cnts {
+	u64 value;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 slc_int : 1;
+		u64 uns_int : 1;
+		u64 in_int : 1;
+		u64 mbox_int : 1;
+		u64 resend : 1;
+		u64 raz : 5;
+		u64 timer : 22;
+		u64 cnt : 32;
+#else
+		u64 cnt	: 32;
+		u64 timer : 22;
+		u64 raz	: 5;
+		u64 resend : 1;
+		u64 mbox_int : 1;
+		u64 in_int : 1;
+		u64 uns_int : 1;
+		u64 slc_int : 1;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_slc_int_levels - Solicited Packet Out Interrupt Levels
+ *   Registers.
+ * @bmode: Determines whether NPS_PKT_SLC_CNTS[CNT] is a byte or
+ *   packet counter.
+ * @timet: Output port counter time interrupt threshold.
+ * @cnt: Output port counter interrupt threshold.
+ */
+union nps_pkt_slc_int_levels {
+	u64 value;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 bmode : 1;
+		u64 raz	: 9;
+		u64 timet : 22;
+		u64 cnt	: 32;
+#else
+		u64 cnt : 32;
+		u64 timet : 22;
+		u64 raz : 9;
+		u64 bmode : 1;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_inst - NPS Packet Interrupt Register
+ * @in_err: Set when any NPS_PKT_IN_RERR_HI/LO bit and
+ *    corresponding NPS_PKT_IN_RERR_*_ENA_* bit are bot set.
+ * @uns_err: Set when any NSP_PKT_UNS_RERR_HI/LO bit and
+ *    corresponding NPS_PKT_UNS_RERR_*_ENA_* bit are both set.
+ * @slc_er: Set when any NSP_PKT_SLC_RERR_HI/LO bit and
+ *    corresponding NPS_PKT_SLC_RERR_*_ENA_* bit are both set.
+ */
+union nps_pkt_int {
+	u64 value;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 raz	: 54;
+		u64 uns_wto : 1;
+		u64 in_err : 1;
+		u64 uns_err : 1;
+		u64 slc_err : 1;
+		u64 in_dbe : 1;
+		u64 in_sbe : 1;
+		u64 uns_dbe : 1;
+		u64 uns_sbe : 1;
+		u64 slc_dbe : 1;
+		u64 slc_sbe : 1;
+#else
+		u64 slc_sbe : 1;
+		u64 slc_dbe : 1;
+		u64 uns_sbe : 1;
+		u64 uns_dbe : 1;
+		u64 in_sbe : 1;
+		u64 in_dbe : 1;
+		u64 slc_err : 1;
+		u64 uns_err : 1;
+		u64 in_err : 1;
+		u64 uns_wto : 1;
+		u64 raz	: 54;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_in_done_cnts - Input instruction ring counts registers
+ * @slc_cnt: Returns a 1 when:
+ *    NPS_PKT_SLC(i)_CNTS[CNT] > NPS_PKT_SLC(i)_INT_LEVELS[CNT], or
+ *    NPS_PKT_SLC(i)_CNTS[TIMER] > NPS_PKT_SCL(i)_INT_LEVELS[TIMET]
+ *    To clear the bit, the CNTS register must be
+ *    written to clear the underlying condition
+ * @uns_int: Return a 1 when:
+ *    NPS_PKT_UNS(i)_CNTS[CNT] > NPS_PKT_UNS(i)_INT_LEVELS[CNT], or
+ *    NPS_PKT_UNS(i)_CNTS[TIMER] > NPS_PKT_UNS(i)_INT_LEVELS[TIMET]
+ *    To clear the bit, the CNTS register must be
+ *    written to clear the underlying condition
+ * @in_int: Returns a 1 when:
+ *    NPS_PKT_IN(i)_DONE_CNTS[CNT] > NPS_PKT_IN(i)_INT_LEVELS[CNT]
+ *    To clear the bit, the DONE_CNTS register
+ *    must be written to clear the underlying condition
+ * @mbox_int: Returns a 1 when:
+ *    NPS_PKT_MBOX_PF_VF(i)_INT[INTR] is set.
+ *    To clear the bit, write NPS_PKT_MBOX_PF_VF(i)_INT[INTR]
+ *    with 1.
+ * @resend: A write of 1 will resend an MSI-X interrupt message if any
+ *    of the following conditions are true for this ring "i".
+ *    NPS_PKT_SLC(i)_CNTS[CNT] > NPS_PKT_SLC(i)_INT_LEVELS[CNT]
+ *    NPS_PKT_SLC(i)_CNTS[TIMER] > NPS_PKT_SLC(i)_INT_LEVELS[TIMET]
+ *    NPS_PKT_UNS(i)_CNTS[CNT] > NPS_PKT_UNS(i)_INT_LEVELS[CNT]
+ *    NPS_PKT_UNS(i)_CNTS[TIMER] > NPS_PKT_UNS(i)_INT_LEVELS[TIMET]
+ *    NPS_PKT_IN(i)_DONE_CNTS[CNT] > NPS_PKT_IN(i)_INT_LEVELS[CNT]
+ *    NPS_PKT_MBOX_PF_VF(i)_INT[INTR] is set
+ * @cnt: Packet counter. Hardware adds to [CNT] as it reads
+ *    packets. On a write to this CSR, hardware substracts the
+ *    amount written to the [CNT] field from [CNT], which will
+ *    clear PKT_IN(i)_INT_STATUS[INTR] if [CNT] becomes <=
+ *    NPS_PKT_IN(i)_INT_LEVELS[CNT]. This register should be
+ *    cleared before enabling a ring by reading the current
+ *    value and writing it back.
+ */
+union nps_pkt_in_done_cnts {
+	u64 value;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 slc_int : 1;
+		u64 uns_int : 1;
+		u64 in_int : 1;
+		u64 mbox_int : 1;
+		u64 resend : 1;
+		u64 raz : 27;
+		u64 cnt	: 32;
+#else
+		u64 cnt	: 32;
+		u64 raz	: 27;
+		u64 resend : 1;
+		u64 mbox_int : 1;
+		u64 in_int : 1;
+		u64 uns_int : 1;
+		u64 slc_int : 1;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_in_instr_ctl - Input Instruction Ring Control Registers.
+ * @is64b: If 1, the ring uses 64-byte instructions. If 0, the
+ *   ring uses 32-byte instructions.
+ * @enb: Enable for the input ring.
+ */
+union nps_pkt_in_instr_ctl {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz	: 62;
+		u64 is64b : 1;
+		u64 enb	: 1;
+#else
+		u64 enb	: 1;
+		u64 is64b : 1;
+		u64 raz : 62;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_in_instr_rsize - Input instruction ring size registers
+ * @rsize: Ring size (number of instructions)
+ */
+union nps_pkt_in_instr_rsize {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz	: 32;
+		u64 rsize : 32;
+#else
+		u64 rsize : 32;
+		u64 raz	: 32;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_pkt_in_instr_baoff_dbell - Input instruction ring
+ *   base address offset and doorbell registers
+ * @aoff: Address offset. The offset from the NPS_PKT_IN_INSTR_BADDR
+ *   where the next pointer is read.
+ * @dbell: Pointer list doorbell count. Write operations to this field
+ *   increments the present value here. Read operations return the
+ *   present value.
+ */
+union nps_pkt_in_instr_baoff_dbell {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 aoff : 32;
+		u64 dbell : 32;
+#else
+		u64 dbell : 32;
+		u64 aoff : 32;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_core_int_ena_w1s - NPS core interrupt enable set register
+ * @host_nps_wr_err: Reads or sets enable for
+ *   NPS_CORE_INT[HOST_NPS_WR_ERR].
+ * @npco_dma_malform: Reads or sets enable for
+ *   NPS_CORE_INT[NPCO_DMA_MALFORM].
+ * @exec_wr_timeout: Reads or sets enable for
+ *   NPS_CORE_INT[EXEC_WR_TIMEOUT].
+ * @host_wr_timeout: Reads or sets enable for
+ *   NPS_CORE_INT[HOST_WR_TIMEOUT].
+ * @host_wr_err: Reads or sets enable for
+ *   NPS_CORE_INT[HOST_WR_ERR]
+ */
+union nps_core_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz4 : 55;
+		u64 host_nps_wr_err : 1;
+		u64 npco_dma_malform : 1;
+		u64 exec_wr_timeout : 1;
+		u64 host_wr_timeout : 1;
+		u64 host_wr_err : 1;
+		u64 raz3 : 1;
+		u64 raz2 : 1;
+		u64 raz1 : 1;
+		u64 raz0 : 1;
+#else
+		u64 raz0 : 1;
+		u64 raz1 : 1;
+		u64 raz2 : 1;
+		u64 raz3 : 1;
+		u64 host_wr_err	: 1;
+		u64 host_wr_timeout : 1;
+		u64 exec_wr_timeout : 1;
+		u64 npco_dma_malform : 1;
+		u64 host_nps_wr_err : 1;
+		u64 raz4 : 55;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_core_gbl_vfcfg - Global VF Configuration Register.
+ * @ilk_disable: When set, this bit indicates that the ILK interface has
+ *    been disabled.
+ * @obaf: BMO allocation control
+ *    0 = allocate per queue
+ *    1 = allocate per VF
+ * @ibaf: BMI allocation control
+ *    0 = allocate per queue
+ *    1 = allocate per VF
+ * @zaf: ZIP allocation control
+ *    0 = allocate per queue
+ *    1 = allocate per VF
+ * @aeaf: AE allocation control
+ *    0 = allocate per queue
+ *    1 = allocate per VF
+ * @seaf: SE allocation control
+ *    0 = allocation per queue
+ *    1 = allocate per VF
+ * @cfg: VF/PF mode.
+ */
+union nps_core_gbl_vfcfg {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64  raz :55;
+		u64  ilk_disable :1;
+		u64  obaf :1;
+		u64  ibaf :1;
+		u64  zaf :1;
+		u64  aeaf :1;
+		u64  seaf :1;
+		u64  cfg :3;
+#else
+		u64  cfg :3;
+		u64  seaf :1;
+		u64  aeaf :1;
+		u64  zaf :1;
+		u64  ibaf :1;
+		u64  obaf :1;
+		u64  ilk_disable :1;
+		u64  raz :55;
+#endif
+	} s;
+};
+
+/**
+ * struct nps_core_int_active - NPS Core Interrupt Active Register
+ * @resend: Resend MSI-X interrupt if needs to handle interrupts
+ *     Sofware can set this bit and then exit the ISR.
+ * @ocla: Set when any OCLA(0)_INT and corresponding OCLA(0_INT_ENA_W1C
+ *     bit are set
+ * @mbox: Set when any NPS_PKT_MBOX_INT_LO/HI and corresponding
+ *     NPS_PKT_MBOX_INT_LO_ENA_W1C/HI_ENA_W1C bits are set
+ * @emu: bit i is set in [EMU] when any EMU(i)_INT bit is set
+ * @bmo: Set when any BMO_INT bit is set
+ * @bmi: Set when any BMI_INT bit is set or when any non-RO
+ *     BMI_INT and corresponding BMI_INT_ENA_W1C bits are both set
+ * @aqm: Set when any AQM_INT bit is set
+ * @zqm: Set when any ZQM_INT bit is set
+ * @efl: Set when any EFL_INT RO bit is set or when any non-RO EFL_INT
+ *     and corresponding EFL_INT_ENA_W1C bits are both set
+ * @ilk: Set when any ILK_INT bit is set
+ * @lbc: Set when any LBC_INT RO bit is set or when any non-RO LBC_INT
+ *     and corresponding LBC_INT_ENA_W1C bits are bot set
+ * @pem: Set when any PEM(0)_INT RO bit is set or when any non-RO
+ *     PEM(0)_INT and corresponding PEM(0)_INT_ENA_W1C bit are both set
+ * @ucd: Set when any UCD_INT bit is set
+ * @zctl: Set when any ZIP_INT RO bit is set or when any non-RO ZIP_INT
+ *     and corresponding ZIP_INT_ENA_W1C bits are both set
+ * @lbm: Set when any LBM_INT bit is set
+ * @nps_pkt: Set when any NPS_PKT_INT bit is set
+ * @nps_core: Set when any NPS_CORE_INT RO bit is set or when non-RO
+ *     NPS_CORE_INT and corresponding NSP_CORE_INT_ENA_W1C bits are both set
+ */
+union nps_core_int_active {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 resend : 1;
+		u64 raz	: 43;
+		u64 ocla : 1;
+		u64 mbox : 1;
+		u64 emu	: 4;
+		u64 bmo	: 1;
+		u64 bmi	: 1;
+		u64 aqm	: 1;
+		u64 zqm	: 1;
+		u64 efl	: 1;
+		u64 ilk	: 1;
+		u64 lbc	: 1;
+		u64 pem	: 1;
+		u64 pom	: 1;
+		u64 ucd	: 1;
+		u64 zctl : 1;
+		u64 lbm	: 1;
+		u64 nps_pkt : 1;
+		u64 nps_core : 1;
+#else
+		u64 nps_core : 1;
+		u64 nps_pkt : 1;
+		u64 lbm	: 1;
+		u64 zctl: 1;
+		u64 ucd	: 1;
+		u64 pom	: 1;
+		u64 pem	: 1;
+		u64 lbc	: 1;
+		u64 ilk	: 1;
+		u64 efl	: 1;
+		u64 zqm	: 1;
+		u64 aqm	: 1;
+		u64 bmi	: 1;
+		u64 bmo	: 1;
+		u64 emu	: 4;
+		u64 mbox : 1;
+		u64 ocla : 1;
+		u64 raz	: 43;
+		u64 resend : 1;
+#endif
+	} s;
+};
+
+/**
+ * struct efl_core_int - EFL Interrupt Registers
+ * @epci_decode_err: EPCI decoded a transacation that was unknown
+ *    This error should only occurred when there is a micrcode/SE error
+ *    and should be considered fatal
+ * @ae_err: An AE uncorrectable error occurred.
+ *    See EFL_CORE(0..3)_AE_ERR_INT
+ * @se_err: An SE uncorrectable error occurred.
+ *    See EFL_CORE(0..3)_SE_ERR_INT
+ * @dbe: Double-bit error occurred in EFL
+ * @sbe: Single-bit error occurred in EFL
+ * @d_left: Asserted when new POM-Header-BMI-data is
+ *    being sent to an Exec, and that Exec has Not read all BMI
+ *    data associated with the previous POM header
+ * @len_ovr: Asserted when an Exec-Read is issued that is more than
+ *    14 greater in length that the BMI data left to be read
+ */
+union efl_core_int {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz	: 57;
+		u64 epci_decode_err : 1;
+		u64 ae_err : 1;
+		u64 se_err : 1;
+		u64 dbe	: 1;
+		u64 sbe	: 1;
+		u64 d_left : 1;
+		u64 len_ovr : 1;
+#else
+		u64 len_ovr : 1;
+		u64 d_left : 1;
+		u64 sbe	: 1;
+		u64 dbe	: 1;
+		u64 se_err : 1;
+		u64 ae_err : 1;
+		u64 epci_decode_err  : 1;
+		u64 raz	: 57;
+#endif
+	} s;
+};
+
+/**
+ * struct efl_core_int_ena_w1s - EFL core interrupt enable set register
+ * @epci_decode_err: Reads or sets enable for
+ *   EFL_CORE(0..3)_INT[EPCI_DECODE_ERR].
+ * @d_left: Reads or sets enable for
+ *   EFL_CORE(0..3)_INT[D_LEFT].
+ * @len_ovr: Reads or sets enable for
+ *   EFL_CORE(0..3)_INT[LEN_OVR].
+ */
+union efl_core_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_7_63 : 57;
+		u64 epci_decode_err : 1;
+		u64 raz_2_5 : 4;
+		u64 d_left : 1;
+		u64 len_ovr : 1;
+#else
+		u64 len_ovr : 1;
+		u64 d_left : 1;
+		u64 raz_2_5 : 4;
+		u64 epci_decode_err : 1;
+		u64 raz_7_63 : 57;
+#endif
+	} s;
+};
+
+/**
+ * struct efl_rnm_ctl_status - RNM Control and Status Register
+ * @ent_sel: Select input to RNM FIFO
+ * @exp_ent: Exported entropy enable for random number generator
+ * @rng_rst: Reset to RNG. Setting this bit to 1 cancels the generation
+ *    of the current random number.
+ * @rnm_rst: Reset the RNM. Setting this bit to 1 clears all sorted numbers
+ *    in the random number memory.
+ * @rng_en: Enabled the output of the RNG.
+ * @ent_en: Entropy enable for random number generator.
+ */
+union efl_rnm_ctl_status {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_9_63 : 55;
+		u64 ent_sel : 4;
+		u64 exp_ent : 1;
+		u64 rng_rst : 1;
+		u64 rnm_rst : 1;
+		u64 rng_en : 1;
+		u64 ent_en : 1;
+#else
+		u64 ent_en : 1;
+		u64 rng_en : 1;
+		u64 rnm_rst : 1;
+		u64 rng_rst : 1;
+		u64 exp_ent : 1;
+		u64 ent_sel : 4;
+		u64 raz_9_63 : 55;
+#endif
+	} s;
+};
+
+/**
+ * struct bmi_ctl - BMI control register
+ * @ilk_hdrq_thrsh: Maximum number of header queue locations
+ *   that ILK packets may consume. When the threshold is
+ *   exceeded ILK_XOFF is sent to the BMI_X2P_ARB.
+ * @nps_hdrq_thrsh: Maximum number of header queue locations
+ *   that NPS packets may consume. When the threshold is
+ *   exceeded NPS_XOFF is sent to the BMI_X2P_ARB.
+ * @totl_hdrq_thrsh: Maximum number of header queue locations
+ *   that the sum of ILK and NPS packets may consume.
+ * @ilk_free_thrsh: Maximum number of buffers that ILK packet
+ *   flows may consume before ILK_XOFF is sent to the BMI_X2P_ARB.
+ * @nps_free_thrsh: Maximum number of buffers that NPS packet
+ *   flows may consume before NPS XOFF is sent to the BMI_X2p_ARB.
+ * @totl_free_thrsh: Maximum number of buffers that bot ILK and NPS
+ *   packet flows may consume before both NPS_XOFF and ILK_XOFF
+ *   are asserted to the BMI_X2P_ARB.
+ * @max_pkt_len: Maximum packet length, integral number of 256B
+ *   buffers.
+ */
+union bmi_ctl {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_56_63 : 8;
+		u64 ilk_hdrq_thrsh : 8;
+		u64 nps_hdrq_thrsh : 8;
+		u64 totl_hdrq_thrsh : 8;
+		u64 ilk_free_thrsh : 8;
+		u64 nps_free_thrsh : 8;
+		u64 totl_free_thrsh : 8;
+		u64 max_pkt_len : 8;
+#else
+		u64 max_pkt_len : 8;
+		u64 totl_free_thrsh : 8;
+		u64 nps_free_thrsh : 8;
+		u64 ilk_free_thrsh : 8;
+		u64 totl_hdrq_thrsh : 8;
+		u64 nps_hdrq_thrsh : 8;
+		u64 ilk_hdrq_thrsh : 8;
+		u64 raz_56_63 : 8;
+#endif
+	} s;
+};
+
+/**
+ * struct bmi_int_ena_w1s - BMI interrupt enable set register
+ * @ilk_req_oflw: Reads or sets enable for
+ *   BMI_INT[ILK_REQ_OFLW].
+ * @nps_req_oflw: Reads or sets enable for
+ *   BMI_INT[NPS_REQ_OFLW].
+ * @fpf_undrrn: Reads or sets enable for
+ *   BMI_INT[FPF_UNDRRN].
+ * @eop_err_ilk: Reads or sets enable for
+ *   BMI_INT[EOP_ERR_ILK].
+ * @eop_err_nps: Reads or sets enable for
+ *   BMI_INT[EOP_ERR_NPS].
+ * @sop_err_ilk: Reads or sets enable for
+ *   BMI_INT[SOP_ERR_ILK].
+ * @sop_err_nps: Reads or sets enable for
+ *   BMI_INT[SOP_ERR_NPS].
+ * @pkt_rcv_err_ilk: Reads or sets enable for
+ *   BMI_INT[PKT_RCV_ERR_ILK].
+ * @pkt_rcv_err_nps: Reads or sets enable for
+ *   BMI_INT[PKT_RCV_ERR_NPS].
+ * @max_len_err_ilk: Reads or sets enable for
+ *   BMI_INT[MAX_LEN_ERR_ILK].
+ * @max_len_err_nps: Reads or sets enable for
+ *   BMI_INT[MAX_LEN_ERR_NPS].
+ */
+union bmi_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_13_63	: 51;
+		u64 ilk_req_oflw : 1;
+		u64 nps_req_oflw : 1;
+		u64 raz_10 : 1;
+		u64 raz_9 : 1;
+		u64 fpf_undrrn	: 1;
+		u64 eop_err_ilk	: 1;
+		u64 eop_err_nps	: 1;
+		u64 sop_err_ilk	: 1;
+		u64 sop_err_nps	: 1;
+		u64 pkt_rcv_err_ilk : 1;
+		u64 pkt_rcv_err_nps : 1;
+		u64 max_len_err_ilk : 1;
+		u64 max_len_err_nps : 1;
+#else
+		u64 max_len_err_nps : 1;
+		u64 max_len_err_ilk : 1;
+		u64 pkt_rcv_err_nps : 1;
+		u64 pkt_rcv_err_ilk : 1;
+		u64 sop_err_nps	: 1;
+		u64 sop_err_ilk	: 1;
+		u64 eop_err_nps	: 1;
+		u64 eop_err_ilk	: 1;
+		u64 fpf_undrrn	: 1;
+		u64 raz_9 : 1;
+		u64 raz_10 : 1;
+		u64 nps_req_oflw : 1;
+		u64 ilk_req_oflw : 1;
+		u64 raz_13_63 : 51;
+#endif
+	} s;
+};
+
+/**
+ * struct bmo_ctl2 - BMO Control2 Register
+ * @arb_sel: Determines P2X Arbitration
+ * @ilk_buf_thrsh: Maximum number of buffers that the
+ *    ILK packet flows may consume before ILK XOFF is
+ *    asserted to the POM.
+ * @nps_slc_buf_thrsh: Maximum number of buffers that the
+ *    NPS_SLC packet flow may consume before NPS_SLC XOFF is
+ *    asserted to the POM.
+ * @nps_uns_buf_thrsh: Maximum number of buffers that the
+ *    NPS_UNS packet flow may consume before NPS_UNS XOFF is
+ *    asserted to the POM.
+ * @totl_buf_thrsh: Maximum number of buffers that ILK, NPS_UNS and
+ *    NPS_SLC packet flows may consume before NPS_UNS XOFF, NSP_SLC and
+ *    ILK_XOFF are all asserted POM.
+ */
+union bmo_ctl2 {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 arb_sel : 1;
+		u64 raz_32_62 : 31;
+		u64 ilk_buf_thrsh : 8;
+		u64 nps_slc_buf_thrsh : 8;
+		u64 nps_uns_buf_thrsh : 8;
+		u64 totl_buf_thrsh : 8;
+#else
+		u64 totl_buf_thrsh : 8;
+		u64 nps_uns_buf_thrsh : 8;
+		u64 nps_slc_buf_thrsh : 8;
+		u64 ilk_buf_thrsh : 8;
+		u64 raz_32_62 : 31;
+		u64 arb_sel : 1;
+#endif
+	} s;
+};
+
+/**
+ * struct pom_int_ena_w1s - POM interrupt enable set register
+ * @illegal_intf: Reads or sets enable for POM_INT[ILLEGAL_INTF].
+ * @illegal_dport: Reads or sets enable for POM_INT[ILLEGAL_DPORT].
+ */
+union pom_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz2 : 60;
+		u64 illegal_intf : 1;
+		u64 illegal_dport : 1;
+		u64 raz1 : 1;
+		u64 raz0 : 1;
+#else
+		u64 raz0 : 1;
+		u64 raz1 : 1;
+		u64 illegal_dport : 1;
+		u64 illegal_intf : 1;
+		u64 raz2 : 60;
+#endif
+	} s;
+};
+
+/**
+ * struct lbc_inval_ctl - LBC invalidation control register
+ * @wait_timer: Wait timer for wait state. [WAIT_TIMER] must
+ *   always be written with its reset value.
+ * @cam_inval_start: Software should write [CAM_INVAL_START]=1
+ *   to initiate an LBC cache invalidation. After this, software
+ *   should read LBC_INVAL_STATUS until LBC_INVAL_STATUS[DONE] is set.
+ *   LBC hardware clears [CAVM_INVAL_START] before software can
+ *   observed LBC_INVAL_STATUS[DONE] to be set
+ */
+union lbc_inval_ctl {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz2 : 48;
+		u64 wait_timer : 8;
+		u64 raz1 : 6;
+		u64 cam_inval_start : 1;
+		u64 raz0 : 1;
+#else
+		u64 raz0 : 1;
+		u64 cam_inval_start : 1;
+		u64 raz1 : 6;
+		u64 wait_timer : 8;
+		u64 raz2 : 48;
+#endif
+	} s;
+};
+
+/**
+ * struct lbc_int_ena_w1s - LBC interrupt enable set register
+ * @cam_hard_err: Reads or sets enable for LBC_INT[CAM_HARD_ERR].
+ * @cam_inval_abort: Reads or sets enable for LBC_INT[CAM_INVAL_ABORT].
+ * @over_fetch_err: Reads or sets enable for LBC_INT[OVER_FETCH_ERR].
+ * @cache_line_to_err: Reads or sets enable for
+ *   LBC_INT[CACHE_LINE_TO_ERR].
+ * @cam_soft_err: Reads or sets enable for
+ *   LBC_INT[CAM_SOFT_ERR].
+ * @dma_rd_err: Reads or sets enable for
+ *   LBC_INT[DMA_RD_ERR].
+ */
+union lbc_int_ena_w1s {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_10_63 : 54;
+		u64 cam_hard_err : 1;
+		u64 cam_inval_abort : 1;
+		u64 over_fetch_err : 1;
+		u64 cache_line_to_err : 1;
+		u64 raz_2_5 : 4;
+		u64 cam_soft_err : 1;
+		u64 dma_rd_err : 1;
+#else
+		u64 dma_rd_err : 1;
+		u64 cam_soft_err : 1;
+		u64 raz_2_5 : 4;
+		u64 cache_line_to_err : 1;
+		u64 over_fetch_err : 1;
+		u64 cam_inval_abort : 1;
+		u64 cam_hard_err : 1;
+		u64 raz_10_63 : 54;
+#endif
+	} s;
+};
+
+/**
+ * struct lbc_int - LBC interrupt summary register
+ * @cam_hard_err: indicates a fatal hardware error.
+ *   It requires system reset.
+ *   When [CAM_HARD_ERR] is set, LBC stops logging any new information in
+ *   LBC_POM_MISS_INFO_LOG,
+ *   LBC_POM_MISS_ADDR_LOG,
+ *   LBC_EFL_MISS_INFO_LOG, and
+ *   LBC_EFL_MISS_ADDR_LOG.
+ *   Software should sample them.
+ * @cam_inval_abort: indicates a fatal hardware error.
+ *   System reset is required.
+ * @over_fetch_err: indicates a fatal hardware error
+ *   System reset is required
+ * @cache_line_to_err: is a debug feature.
+ *   This timeout interrupt bit tells the software that
+ *   a cacheline in LBC has non-zero usage and the context
+ *   has not been used for greater than the
+ *   LBC_TO_CNT[TO_CNT] time interval.
+ * @sbe: Memory SBE error. This is recoverable via ECC.
+ *   See LBC_ECC_INT for more details.
+ * @dbe: Memory DBE error. This is a fatal and requires a
+ *   system reset.
+ * @pref_dat_len_mismatch_err: Summary bit for context length
+ *   mismatch errors.
+ * @rd_dat_len_mismatch_err: Summary bit for SE read data length
+ *   greater than data prefect length errors.
+ * @cam_soft_err: is recoverable. Software must complete a
+ *   LBC_INVAL_CTL[CAM_INVAL_START] invalidation sequence and
+ *   then clear [CAM_SOFT_ERR].
+ * @dma_rd_err: A context prefect read of host memory returned with
+ *   a read error.
+ */
+union lbc_int {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_10_63 : 54;
+		u64 cam_hard_err : 1;
+		u64 cam_inval_abort : 1;
+		u64 over_fetch_err : 1;
+		u64 cache_line_to_err : 1;
+		u64 sbe : 1;
+		u64 dbe	: 1;
+		u64 pref_dat_len_mismatch_err : 1;
+		u64 rd_dat_len_mismatch_err : 1;
+		u64 cam_soft_err : 1;
+		u64 dma_rd_err : 1;
+#else
+		u64 dma_rd_err : 1;
+		u64 cam_soft_err : 1;
+		u64 rd_dat_len_mismatch_err : 1;
+		u64 pref_dat_len_mismatch_err : 1;
+		u64 dbe	: 1;
+		u64 sbe	: 1;
+		u64 cache_line_to_err : 1;
+		u64 over_fetch_err : 1;
+		u64 cam_inval_abort : 1;
+		u64 cam_hard_err : 1;
+		u64 raz_10_63 : 54;
+#endif
+	} s;
+};
+
+/**
+ * struct lbc_inval_status: LBC Invalidation status register
+ * @cam_clean_entry_complete_cnt: The number of entries that are
+ *   cleaned up successfully.
+ * @cam_clean_entry_cnt: The number of entries that have the CAM
+ *   inval command issued.
+ * @cam_inval_state: cam invalidation FSM state
+ * @cam_inval_abort: cam invalidation abort
+ * @cam_rst_rdy: lbc_cam reset ready
+ * @done: LBC clears [DONE] when
+ *   LBC_INVAL_CTL[CAM_INVAL_START] is written with a one,
+ *   and sets [DONE] when it completes the invalidation
+ *   sequence.
+ */
+union lbc_inval_status {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz3 : 23;
+		u64 cam_clean_entry_complete_cnt : 9;
+		u64 raz2 : 7;
+		u64 cam_clean_entry_cnt : 9;
+		u64 raz1 : 5;
+		u64 cam_inval_state : 3;
+		u64 raz0 : 5;
+		u64 cam_inval_abort : 1;
+		u64 cam_rst_rdy	: 1;
+		u64 done : 1;
+#else
+		u64 done : 1;
+		u64 cam_rst_rdy : 1;
+		u64 cam_inval_abort : 1;
+		u64 raz0 : 5;
+		u64 cam_inval_state : 3;
+		u64 raz1 : 5;
+		u64 cam_clean_entry_cnt : 9;
+		u64 raz2 : 7;
+		u64 cam_clean_entry_complete_cnt : 9;
+		u64 raz3 : 23;
+#endif
+	} s;
+};
+
+#endif /* __NITROX_CSR_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
new file mode 100644
index 0000000..ff6bb09
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -0,0 +1,181 @@
+#ifndef __NITROX_DEV_H
+#define __NITROX_DEV_H
+
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+
+#define VERSION_LEN 32
+
+struct nitrox_cmdq {
+	/* command queue lock */
+	spinlock_t cmdq_lock;
+	/* in progress list lock */
+	spinlock_t pending_lock;
+	/* backlog list lock */
+	spinlock_t backlog_lock;
+
+	/* request submitted to chip, in progress */
+	struct list_head in_progress_head;
+	/* hw queue full, hold in backlog list */
+	struct list_head backlog_head;
+
+	/* doorbell address */
+	u8 __iomem *dbell_csr_addr;
+	/* base address of the queue */
+	u8 *head;
+
+	/* in progress command count */
+	atomic_t pending_count;
+
+	/* command size 32B/64B */
+	u8 instr_size;
+	/* command queue initializataion done */
+	u8 init_done;
+	/* current write index */
+	u16 write_index;
+	u32 qsize;
+
+	u8 *head_unaligned;
+	dma_addr_t dma_unaligned;
+	dma_addr_t dma;
+};
+
+struct nitrox_hw {
+	/* firmware version */
+	char fw_name[VERSION_LEN];
+
+	u16 vendor_id;
+	u16 device_id;
+	u8 revision_id;
+
+	/* CNN55XX cores */
+	u8 se_cores;
+	u8 ae_cores;
+	u8 zip_cores;
+};
+
+#define MAX_MSIX_VECTOR_NAME	20
+/**
+ * vectors for queues (64 AE, 64 SE and 64 ZIP) and
+ * error condition/mailbox.
+ */
+#define MAX_MSIX_VECTORS	192
+
+struct nitrox_msix {
+	struct msix_entry *entries;
+	char **names;
+	DECLARE_BITMAP(irqs, MAX_MSIX_VECTORS);
+	u32 nr_entries;
+};
+
+struct bh_data {
+	int qno;
+	/* slc port completion count address */
+	u8 __iomem *completion_cnt_csr_addr;
+
+	struct nitrox_device *ndev;
+	struct tasklet_struct resp_handler;
+};
+
+struct nitrox_bh {
+	struct bh_data *slc;
+};
+
+/* NITROX-5 driver state */
+#define NITROX_UCODE_LOADED	0
+#define NITROX_READY		1
+
+/* command queue size */
+#define DEFAULT_CMD_QLEN 2048
+/* command timeout in milliseconds */
+#define CMD_TIMEOUT 2000
+
+#define DEV(ndev) ((struct device *)(&(ndev)->pdev->dev))
+#define PF_MODE 0
+
+/**
+ * struct nitrox_device - NITROX Device Information.
+ * @list: pointer to linked list of devices
+ * @bar_addr: iomap address
+ * @pdev: PCI device information
+ * @status: NITROX status
+ * @timeout: Request timeout in jiffies
+ * @refcnt: Device usage count
+ * @qlen: Command queue length
+ * @nr_queues: Number of command queues
+ * @idx: device index (0..N)
+ * @node: NUMA node id attached
+ * @ctx_pool: DMA pool for crypto context
+ * @pkt_cmdqs: SE Command queues
+ * @msix: MSI-X information
+ * @bh: post processing work
+ * @hw: hardware information
+ */
+struct nitrox_device {
+	struct list_head list;
+
+	u8 __iomem *bar_addr;
+	struct pci_dev *pdev;
+
+	unsigned long status;
+	unsigned long timeout;
+	atomic_t refcnt;
+
+	u32 qlen;
+	u16 nr_queues;
+	u8 idx;
+	int node;
+
+	struct dma_pool *ctx_pool;
+	struct nitrox_cmdq *pkt_cmdqs;
+
+	struct nitrox_msix msix;
+	struct nitrox_bh bh;
+
+	struct nitrox_hw hw;
+};
+
+static inline u8 __iomem *nitrox_csr_addr(struct nitrox_device *ndev,
+					  u64 offset)
+{
+	u8 __iomem *bar_addr = READ_ONCE(ndev->bar_addr);
+
+	return (bar_addr + offset);
+}
+
+/**
+ * nitrox_read_csr - Read from device register
+ * @ndev: NITROX device
+ * @offset: offset of the register to read
+ *
+ * Returns: value read
+ */
+static inline u64 nitrox_read_csr(struct nitrox_device *ndev, u64 offset)
+{
+	return readq(ndev->bar_addr + offset);
+}
+
+/**
+ * nitrox_write_csr - Write to device register
+ * @ndev: NITROX device
+ * @offset: offset of the register to write
+ * @value: value to write
+ */
+static inline void nitrox_write_csr(struct nitrox_device *ndev, u64 offset,
+				    u64 value)
+{
+	writeq(value, (ndev->bar_addr + offset));
+}
+
+static inline int nitrox_in_use(struct nitrox_device *ndev)
+{
+	return atomic_read(&ndev->refcnt) != 0;
+}
+
+static inline int nitrox_ready(struct nitrox_device *ndev)
+{
+	return test_bit(NITROX_READY, &ndev->status);
+}
+
+#endif /* __NITROX_DEV_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
new file mode 100644
index 0000000..dce69c4
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -0,0 +1,404 @@
+#include <linux/delay.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_csr.h"
+
+/**
+ * emu_enable_cores - Enable EMU cluster cores.
+ * @ndev: N5 device
+ */
+static void emu_enable_cores(struct nitrox_device *ndev)
+{
+	union emu_se_enable emu_se;
+	union emu_ae_enable emu_ae;
+	int i;
+
+	/* AE cores 20 per cluster */
+	emu_ae.value = 0;
+	emu_ae.s.enable = 0xfffff;
+
+	/* SE cores 16 per cluster */
+	emu_se.value = 0;
+	emu_se.s.enable = 0xffff;
+
+	/* enable per cluster cores */
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		nitrox_write_csr(ndev, EMU_AE_ENABLEX(i), emu_ae.value);
+		nitrox_write_csr(ndev, EMU_SE_ENABLEX(i), emu_se.value);
+	}
+}
+
+/**
+ * nitrox_config_emu_unit - configure EMU unit.
+ * @ndev: N5 device
+ */
+void nitrox_config_emu_unit(struct nitrox_device *ndev)
+{
+	union emu_wd_int_ena_w1s emu_wd_int;
+	union emu_ge_int_ena_w1s emu_ge_int;
+	u64 offset;
+	int i;
+
+	/* enable cores */
+	emu_enable_cores(ndev);
+
+	/* enable general error and watch dog interrupts */
+	emu_ge_int.value = 0;
+	emu_ge_int.s.se_ge = 0xffff;
+	emu_ge_int.s.ae_ge = 0xfffff;
+	emu_wd_int.value = 0;
+	emu_wd_int.s.se_wd = 1;
+
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		offset = EMU_WD_INT_ENA_W1SX(i);
+		nitrox_write_csr(ndev, offset, emu_wd_int.value);
+		offset = EMU_GE_INT_ENA_W1SX(i);
+		nitrox_write_csr(ndev, offset, emu_ge_int.value);
+	}
+}
+
+static void reset_pkt_input_ring(struct nitrox_device *ndev, int ring)
+{
+	union nps_pkt_in_instr_ctl pkt_in_ctl;
+	union nps_pkt_in_instr_baoff_dbell pkt_in_dbell;
+	union nps_pkt_in_done_cnts pkt_in_cnts;
+	u64 offset;
+
+	offset = NPS_PKT_IN_INSTR_CTLX(ring);
+	/* disable the ring */
+	pkt_in_ctl.value = nitrox_read_csr(ndev, offset);
+	pkt_in_ctl.s.enb = 0;
+	nitrox_write_csr(ndev, offset, pkt_in_ctl.value);
+	usleep_range(100, 150);
+
+	/* wait to clear [ENB] */
+	do {
+		pkt_in_ctl.value = nitrox_read_csr(ndev, offset);
+	} while (pkt_in_ctl.s.enb);
+
+	/* clear off door bell counts */
+	offset = NPS_PKT_IN_INSTR_BAOFF_DBELLX(ring);
+	pkt_in_dbell.value = 0;
+	pkt_in_dbell.s.dbell = 0xffffffff;
+	nitrox_write_csr(ndev, offset, pkt_in_dbell.value);
+
+	/* clear done counts */
+	offset = NPS_PKT_IN_DONE_CNTSX(ring);
+	pkt_in_cnts.value = nitrox_read_csr(ndev, offset);
+	nitrox_write_csr(ndev, offset, pkt_in_cnts.value);
+	usleep_range(50, 100);
+}
+
+static void enable_pkt_input_ring(struct nitrox_device *ndev, int ring)
+{
+	union nps_pkt_in_instr_ctl pkt_in_ctl;
+	u64 offset;
+
+	/* 64-byte instruction size */
+	offset = NPS_PKT_IN_INSTR_CTLX(ring);
+	pkt_in_ctl.value = nitrox_read_csr(ndev, offset);
+	pkt_in_ctl.s.is64b = 1;
+	pkt_in_ctl.s.enb = 1;
+	nitrox_write_csr(ndev, offset, pkt_in_ctl.value);
+	usleep_range(100, 150);
+
+	/* wait for set [ENB] */
+	do {
+		pkt_in_ctl.value = nitrox_read_csr(ndev, offset);
+	} while (!pkt_in_ctl.s.enb);
+}
+
+/**
+ * nitrox_config_pkt_input_rings - configure Packet Input Rings
+ * @ndev: N5 device
+ */
+void nitrox_config_pkt_input_rings(struct nitrox_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < ndev->nr_queues; i++) {
+		struct nitrox_cmdq *cmdq = &ndev->pkt_cmdqs[i];
+		union nps_pkt_in_instr_rsize pkt_in_rsize;
+		dma_addr_t dma_addr;
+		u64 offset;
+
+		reset_pkt_input_ring(ndev, i);
+
+		/* configure ring base address 16-byte aligned,
+		 * size and interrupt threshold.
+		 */
+		offset = NPS_PKT_IN_INSTR_BADDRX(i);
+		dma_addr = dma_unmap_addr(cmdq, dma);
+		nitrox_write_csr(ndev, NPS_PKT_IN_INSTR_BADDRX(i), dma_addr);
+
+		/* configure ring size */
+		offset = NPS_PKT_IN_INSTR_RSIZEX(i);
+		pkt_in_rsize.value = 0;
+		pkt_in_rsize.s.rsize = ndev->qlen;
+		nitrox_write_csr(ndev, offset, pkt_in_rsize.value);
+
+		/* set high threshold for pkt input ring interrupts */
+		offset = NPS_PKT_IN_INT_LEVELSX(i);
+		nitrox_write_csr(ndev, offset, 0xffffffff);
+
+		enable_pkt_input_ring(ndev, i);
+	}
+}
+
+static void reset_pkt_solicit_port(struct nitrox_device *ndev, int port)
+{
+	union nps_pkt_slc_ctl pkt_slc_ctl;
+	union nps_pkt_slc_cnts pkt_slc_cnts;
+	u64 offset;
+
+	/* disable slc port */
+	offset = NPS_PKT_SLC_CTLX(port);
+	pkt_slc_ctl.value = nitrox_read_csr(ndev, offset);
+	pkt_slc_ctl.s.enb = 0;
+	nitrox_write_csr(ndev, offset, pkt_slc_ctl.value);
+	usleep_range(100, 150);
+
+	/* wait to clear [ENB] */
+	do {
+		pkt_slc_ctl.value = nitrox_read_csr(ndev, offset);
+	} while (pkt_slc_ctl.s.enb);
+
+	/* clear slc counters */
+	offset = NPS_PKT_SLC_CNTSX(port);
+	pkt_slc_cnts.value = nitrox_read_csr(ndev, offset);
+	nitrox_write_csr(ndev, offset, pkt_slc_cnts.value);
+	usleep_range(50, 100);
+}
+
+static void enable_pkt_solicit_port(struct nitrox_device *ndev, int port)
+{
+	union nps_pkt_slc_ctl pkt_slc_ctl;
+	u64 offset;
+
+	offset = NPS_PKT_SLC_CTLX(port);
+	pkt_slc_ctl.value = 0;
+	pkt_slc_ctl.s.enb = 1;
+
+	/*
+	 * 8 trailing 0x00 bytes will be added
+	 * to the end of the outgoing packet.
+	 */
+	pkt_slc_ctl.s.z = 1;
+	/* enable response header */
+	pkt_slc_ctl.s.rh = 1;
+	nitrox_write_csr(ndev, offset, pkt_slc_ctl.value);
+	usleep_range(100, 150);
+
+	/* wait to set [ENB] */
+	do {
+		pkt_slc_ctl.value = nitrox_read_csr(ndev, offset);
+	} while (!pkt_slc_ctl.s.enb);
+}
+
+static void config_single_pkt_solicit_port(struct nitrox_device *ndev, int port)
+{
+	union nps_pkt_slc_int_levels pkt_slc_int;
+	u64 offset;
+
+	reset_pkt_solicit_port(ndev, port);
+
+	offset = NPS_PKT_SLC_INT_LEVELSX(port);
+	pkt_slc_int.value = 0;
+	/* time interrupt threshold */
+	pkt_slc_int.s.timet = 0x3fffff;
+	nitrox_write_csr(ndev, offset, pkt_slc_int.value);
+
+	enable_pkt_solicit_port(ndev, port);
+}
+
+void nitrox_config_pkt_solicit_ports(struct nitrox_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < ndev->nr_queues; i++)
+		config_single_pkt_solicit_port(ndev, i);
+}
+
+/**
+ * enable_nps_interrupts - enable NPS interrutps
+ * @ndev: N5 device.
+ *
+ * This includes NPS core, packet in and slc interrupts.
+ */
+static void enable_nps_interrupts(struct nitrox_device *ndev)
+{
+	union nps_core_int_ena_w1s core_int;
+
+	/* NPS core interrutps */
+	core_int.value = 0;
+	core_int.s.host_wr_err = 1;
+	core_int.s.host_wr_timeout = 1;
+	core_int.s.exec_wr_timeout = 1;
+	core_int.s.npco_dma_malform = 1;
+	core_int.s.host_nps_wr_err = 1;
+	nitrox_write_csr(ndev, NPS_CORE_INT_ENA_W1S, core_int.value);
+
+	/* NPS packet in ring interrupts */
+	nitrox_write_csr(ndev, NPS_PKT_IN_RERR_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_IN_RERR_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_IN_ERR_TYPE_ENA_W1S, (~0ULL));
+	/* NPS packet slc port interrupts */
+	nitrox_write_csr(ndev, NPS_PKT_SLC_RERR_HI_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_SLC_RERR_LO_ENA_W1S, (~0ULL));
+	nitrox_write_csr(ndev, NPS_PKT_SLC_ERR_TYPE_ENA_W1S, (~0uLL));
+}
+
+void nitrox_config_nps_unit(struct nitrox_device *ndev)
+{
+	union nps_core_gbl_vfcfg core_gbl_vfcfg;
+
+	/* endian control information */
+	nitrox_write_csr(ndev, NPS_CORE_CONTROL, 1ULL);
+
+	/* disable ILK interface */
+	core_gbl_vfcfg.value = 0;
+	core_gbl_vfcfg.s.ilk_disable = 1;
+	core_gbl_vfcfg.s.cfg = PF_MODE;
+	nitrox_write_csr(ndev, NPS_CORE_GBL_VFCFG, core_gbl_vfcfg.value);
+	/* config input and solicit ports */
+	nitrox_config_pkt_input_rings(ndev);
+	nitrox_config_pkt_solicit_ports(ndev);
+
+	/* enable interrupts */
+	enable_nps_interrupts(ndev);
+}
+
+void nitrox_config_pom_unit(struct nitrox_device *ndev)
+{
+	union pom_int_ena_w1s pom_int;
+	int i;
+
+	/* enable pom interrupts */
+	pom_int.value = 0;
+	pom_int.s.illegal_dport = 1;
+	nitrox_write_csr(ndev, POM_INT_ENA_W1S, pom_int.value);
+
+	/* enable perf counters */
+	for (i = 0; i < ndev->hw.se_cores; i++)
+		nitrox_write_csr(ndev, POM_PERF_CTL, BIT_ULL(i));
+}
+
+/**
+ * nitrox_config_rand_unit - enable N5 random number unit
+ * @ndev: N5 device
+ */
+void nitrox_config_rand_unit(struct nitrox_device *ndev)
+{
+	union efl_rnm_ctl_status efl_rnm_ctl;
+	u64 offset;
+
+	offset = EFL_RNM_CTL_STATUS;
+	efl_rnm_ctl.value = nitrox_read_csr(ndev, offset);
+	efl_rnm_ctl.s.ent_en = 1;
+	efl_rnm_ctl.s.rng_en = 1;
+	nitrox_write_csr(ndev, offset, efl_rnm_ctl.value);
+}
+
+void nitrox_config_efl_unit(struct nitrox_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		union efl_core_int_ena_w1s efl_core_int;
+		u64 offset;
+
+		/* EFL core interrupts */
+		offset = EFL_CORE_INT_ENA_W1SX(i);
+		efl_core_int.value = 0;
+		efl_core_int.s.len_ovr = 1;
+		efl_core_int.s.d_left = 1;
+		efl_core_int.s.epci_decode_err = 1;
+		nitrox_write_csr(ndev, offset, efl_core_int.value);
+
+		offset = EFL_CORE_VF_ERR_INT0_ENA_W1SX(i);
+		nitrox_write_csr(ndev, offset, (~0ULL));
+		offset = EFL_CORE_VF_ERR_INT1_ENA_W1SX(i);
+		nitrox_write_csr(ndev, offset, (~0ULL));
+	}
+}
+
+void nitrox_config_bmi_unit(struct nitrox_device *ndev)
+{
+	union bmi_ctl bmi_ctl;
+	union bmi_int_ena_w1s bmi_int_ena;
+	u64 offset;
+
+	/* no threshold limits for PCIe */
+	offset = BMI_CTL;
+	bmi_ctl.value = nitrox_read_csr(ndev, offset);
+	bmi_ctl.s.max_pkt_len = 0xff;
+	bmi_ctl.s.nps_free_thrsh = 0xff;
+	bmi_ctl.s.nps_hdrq_thrsh = 0x7a;
+	nitrox_write_csr(ndev, offset, bmi_ctl.value);
+
+	/* enable interrupts */
+	offset = BMI_INT_ENA_W1S;
+	bmi_int_ena.value = 0;
+	bmi_int_ena.s.max_len_err_nps = 1;
+	bmi_int_ena.s.pkt_rcv_err_nps = 1;
+	bmi_int_ena.s.fpf_undrrn = 1;
+	nitrox_write_csr(ndev, offset, bmi_int_ena.value);
+}
+
+void nitrox_config_bmo_unit(struct nitrox_device *ndev)
+{
+	union bmo_ctl2 bmo_ctl2;
+	u64 offset;
+
+	/* no threshold limits for PCIe */
+	offset = BMO_CTL2;
+	bmo_ctl2.value = nitrox_read_csr(ndev, offset);
+	bmo_ctl2.s.nps_slc_buf_thrsh = 0xff;
+	nitrox_write_csr(ndev, offset, bmo_ctl2.value);
+}
+
+void invalidate_lbc(struct nitrox_device *ndev)
+{
+	union lbc_inval_ctl lbc_ctl;
+	union lbc_inval_status lbc_stat;
+	u64 offset;
+
+	/* invalidate LBC */
+	offset = LBC_INVAL_CTL;
+	lbc_ctl.value = nitrox_read_csr(ndev, offset);
+	lbc_ctl.s.cam_inval_start = 1;
+	nitrox_write_csr(ndev, offset, lbc_ctl.value);
+
+	offset = LBC_INVAL_STATUS;
+
+	do {
+		lbc_stat.value = nitrox_read_csr(ndev, offset);
+	} while (!lbc_stat.s.done);
+}
+
+void nitrox_config_lbc_unit(struct nitrox_device *ndev)
+{
+	union lbc_int_ena_w1s lbc_int_ena;
+	u64 offset;
+
+	invalidate_lbc(ndev);
+
+	/* enable interrupts */
+	offset = LBC_INT_ENA_W1S;
+	lbc_int_ena.value = 0;
+	lbc_int_ena.s.dma_rd_err = 1;
+	lbc_int_ena.s.over_fetch_err = 1;
+	lbc_int_ena.s.cam_inval_abort = 1;
+	lbc_int_ena.s.cam_hard_err = 1;
+	nitrox_write_csr(ndev, offset, lbc_int_ena.value);
+
+	offset = LBC_PLM_VF1_64_INT_ENA_W1S;
+	nitrox_write_csr(ndev, offset, (~0ULL));
+	offset = LBC_PLM_VF65_128_INT_ENA_W1S;
+	nitrox_write_csr(ndev, offset, (~0ULL));
+
+	offset = LBC_ELM_VF1_64_INT_ENA_W1S;
+	nitrox_write_csr(ndev, offset, (~0ULL));
+	offset = LBC_ELM_VF65_128_INT_ENA_W1S;
+	nitrox_write_csr(ndev, offset, (~0ULL));
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
new file mode 100644
index 0000000..39c3864
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -0,0 +1,449 @@
+#include <linux/pci.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_csr.h"
+#include "nitrox_common.h"
+
+#define NR_RING_VECTORS 3
+#define NPS_CORE_INT_ACTIVE_ENTRY 192
+
+/**
+ * nps_pkt_slc_isr - IRQ handler for NPS solicit port
+ * @irq: irq number
+ * @data: argument
+ */
+static irqreturn_t nps_pkt_slc_isr(int irq, void *data)
+{
+	struct bh_data *slc = data;
+	union nps_pkt_slc_cnts pkt_slc_cnts;
+
+	pkt_slc_cnts.value = readq(slc->completion_cnt_csr_addr);
+	/* New packet on SLC output port */
+	if (pkt_slc_cnts.s.slc_int)
+		tasklet_hi_schedule(&slc->resp_handler);
+
+	return IRQ_HANDLED;
+}
+
+static void clear_nps_core_err_intr(struct nitrox_device *ndev)
+{
+	u64 value;
+
+	/* Write 1 to clear */
+	value = nitrox_read_csr(ndev, NPS_CORE_INT);
+	nitrox_write_csr(ndev, NPS_CORE_INT, value);
+
+	dev_err_ratelimited(DEV(ndev), "NSP_CORE_INT  0x%016llx\n", value);
+}
+
+static void clear_nps_pkt_err_intr(struct nitrox_device *ndev)
+{
+	union nps_pkt_int pkt_int;
+	u64 value, offset;
+
+	pkt_int.value = nitrox_read_csr(ndev, NPS_PKT_INT);
+	dev_err_ratelimited(DEV(ndev), "NPS_PKT_INT  0x%016llx\n",
+			    pkt_int.value);
+
+	if (pkt_int.s.slc_err) {
+		offset = NPS_PKT_SLC_ERR_TYPE;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		dev_err_ratelimited(DEV(ndev),
+				    "NPS_PKT_SLC_ERR_TYPE  0x%016llx\n", value);
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		offset = NPS_PKT_SLC_RERR_LO;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		offset = NPS_PKT_SLC_RERR_HI;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+	}
+	if (pkt_int.s.in_err) {
+		offset = NPS_PKT_IN_ERR_TYPE;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		dev_err_ratelimited(DEV(ndev),
+				    "NPS_PKT_IN_ERR_TYPE  0x%016llx\n", value);
+		offset = NPS_PKT_IN_RERR_LO;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		offset = NPS_PKT_IN_RERR_HI;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+	}
+}
+
+static void clear_pom_err_intr(struct nitrox_device *ndev)
+{
+	u64 value;
+
+	value = nitrox_read_csr(ndev, POM_INT);
+	nitrox_write_csr(ndev, POM_INT, value);
+	dev_err_ratelimited(DEV(ndev), "POM_INT  0x%016llx\n", value);
+}
+
+static void clear_pem_err_intr(struct nitrox_device *ndev)
+{
+	u64 value;
+
+	value = nitrox_read_csr(ndev, PEM0_INT);
+	nitrox_write_csr(ndev, PEM0_INT, value);
+	dev_err_ratelimited(DEV(ndev), "PEM(0)_INT  0x%016llx\n", value);
+}
+
+static void clear_lbc_err_intr(struct nitrox_device *ndev)
+{
+	union lbc_int lbc_int;
+	u64 value, offset;
+	int i;
+
+	lbc_int.value = nitrox_read_csr(ndev, LBC_INT);
+	dev_err_ratelimited(DEV(ndev), "LBC_INT  0x%016llx\n", lbc_int.value);
+
+	if (lbc_int.s.dma_rd_err) {
+		for (i = 0; i < NR_CLUSTERS; i++) {
+			offset = EFL_CORE_VF_ERR_INT0X(i);
+			value = nitrox_read_csr(ndev, offset);
+			nitrox_write_csr(ndev, offset, value);
+			offset = EFL_CORE_VF_ERR_INT1X(i);
+			value = nitrox_read_csr(ndev, offset);
+			nitrox_write_csr(ndev, offset, value);
+		}
+	}
+
+	if (lbc_int.s.cam_soft_err) {
+		dev_err_ratelimited(DEV(ndev), "CAM_SOFT_ERR, invalidating LBC\n");
+		invalidate_lbc(ndev);
+	}
+
+	if (lbc_int.s.pref_dat_len_mismatch_err) {
+		offset = LBC_PLM_VF1_64_INT;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		offset = LBC_PLM_VF65_128_INT;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+	}
+
+	if (lbc_int.s.rd_dat_len_mismatch_err) {
+		offset = LBC_ELM_VF1_64_INT;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+		offset = LBC_ELM_VF65_128_INT;
+		value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, value);
+	}
+	nitrox_write_csr(ndev, LBC_INT, lbc_int.value);
+}
+
+static void clear_efl_err_intr(struct nitrox_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		union efl_core_int core_int;
+		u64 value, offset;
+
+		offset = EFL_CORE_INTX(i);
+		core_int.value = nitrox_read_csr(ndev, offset);
+		nitrox_write_csr(ndev, offset, core_int.value);
+		dev_err_ratelimited(DEV(ndev), "ELF_CORE(%d)_INT  0x%016llx\n",
+				    i, core_int.value);
+		if (core_int.s.se_err) {
+			offset = EFL_CORE_SE_ERR_INTX(i);
+			value = nitrox_read_csr(ndev, offset);
+			nitrox_write_csr(ndev, offset, value);
+		}
+	}
+}
+
+static void clear_bmi_err_intr(struct nitrox_device *ndev)
+{
+	u64 value;
+
+	value = nitrox_read_csr(ndev, BMI_INT);
+	nitrox_write_csr(ndev, BMI_INT, value);
+	dev_err_ratelimited(DEV(ndev), "BMI_INT  0x%016llx\n", value);
+}
+
+/**
+ * clear_nps_core_int_active - clear NPS_CORE_INT_ACTIVE interrupts
+ * @ndev: NITROX device
+ */
+static void clear_nps_core_int_active(struct nitrox_device *ndev)
+{
+	union nps_core_int_active core_int_active;
+
+	core_int_active.value = nitrox_read_csr(ndev, NPS_CORE_INT_ACTIVE);
+
+	if (core_int_active.s.nps_core)
+		clear_nps_core_err_intr(ndev);
+
+	if (core_int_active.s.nps_pkt)
+		clear_nps_pkt_err_intr(ndev);
+
+	if (core_int_active.s.pom)
+		clear_pom_err_intr(ndev);
+
+	if (core_int_active.s.pem)
+		clear_pem_err_intr(ndev);
+
+	if (core_int_active.s.lbc)
+		clear_lbc_err_intr(ndev);
+
+	if (core_int_active.s.efl)
+		clear_efl_err_intr(ndev);
+
+	if (core_int_active.s.bmi)
+		clear_bmi_err_intr(ndev);
+
+	/* If more work callback the ISR, set resend */
+	core_int_active.s.resend = 1;
+	nitrox_write_csr(ndev, NPS_CORE_INT_ACTIVE, core_int_active.value);
+}
+
+static irqreturn_t nps_core_int_isr(int irq, void *data)
+{
+	struct nitrox_device *ndev = data;
+
+	clear_nps_core_int_active(ndev);
+
+	return IRQ_HANDLED;
+}
+
+static int nitrox_enable_msix(struct nitrox_device *ndev)
+{
+	struct msix_entry *entries;
+	char **names;
+	int i, nr_entries, ret;
+
+	/*
+	 * PF MSI-X vectors
+	 *
+	 * Entry 0: NPS PKT ring 0
+	 * Entry 1: AQMQ ring 0
+	 * Entry 2: ZQM ring 0
+	 * Entry 3: NPS PKT ring 1
+	 * Entry 4: AQMQ ring 1
+	 * Entry 5: ZQM ring 1
+	 * ....
+	 * Entry 192: NPS_CORE_INT_ACTIVE
+	 */
+	nr_entries = (ndev->nr_queues * NR_RING_VECTORS) + 1;
+	entries = kzalloc_node(nr_entries * sizeof(struct msix_entry),
+			       GFP_KERNEL, ndev->node);
+	if (!entries)
+		return -ENOMEM;
+
+	names = kcalloc(nr_entries, sizeof(char *), GFP_KERNEL);
+	if (!names) {
+		kfree(entries);
+		return -ENOMEM;
+	}
+
+	/* fill entires */
+	for (i = 0; i < (nr_entries - 1); i++)
+		entries[i].entry = i;
+
+	entries[i].entry = NPS_CORE_INT_ACTIVE_ENTRY;
+
+	for (i = 0; i < nr_entries; i++) {
+		*(names + i) = kzalloc(MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
+		if (!(*(names + i))) {
+			ret = -ENOMEM;
+			goto msix_fail;
+		}
+	}
+	ndev->msix.entries = entries;
+	ndev->msix.names = names;
+	ndev->msix.nr_entries = nr_entries;
+
+	ret = pci_enable_msix_exact(ndev->pdev, ndev->msix.entries,
+				    ndev->msix.nr_entries);
+	if (ret) {
+		dev_err(&ndev->pdev->dev, "Failed to enable MSI-X IRQ(s) %d\n",
+			ret);
+		goto msix_fail;
+	}
+	return 0;
+
+msix_fail:
+	for (i = 0; i < nr_entries; i++)
+		kfree(*(names + i));
+
+	kfree(entries);
+	kfree(names);
+	return ret;
+}
+
+static void nitrox_cleanup_pkt_slc_bh(struct nitrox_device *ndev)
+{
+	int i;
+
+	if (!ndev->bh.slc)
+		return;
+
+	for (i = 0; i < ndev->nr_queues; i++) {
+		struct bh_data *bh = &ndev->bh.slc[i];
+
+		tasklet_disable(&bh->resp_handler);
+		tasklet_kill(&bh->resp_handler);
+	}
+	kfree(ndev->bh.slc);
+	ndev->bh.slc = NULL;
+}
+
+static int nitrox_setup_pkt_slc_bh(struct nitrox_device *ndev)
+{
+	u32 size;
+	int i;
+
+	size = ndev->nr_queues * sizeof(struct bh_data);
+	ndev->bh.slc = kzalloc(size, GFP_KERNEL);
+	if (!ndev->bh.slc)
+		return -ENOMEM;
+
+	for (i = 0; i < ndev->nr_queues; i++) {
+		struct bh_data *bh = &ndev->bh.slc[i];
+		u64 offset;
+
+		bh->qno = i;
+		bh->ndev = ndev;
+		offset = NPS_PKT_SLC_CNTSX(i);
+		/* pre calculate completion count address */
+		bh->completion_cnt_csr_addr = nitrox_csr_addr(ndev, offset);
+
+		tasklet_init(&bh->resp_handler, pkt_slc_resp_handler,
+			     (unsigned long)bh);
+	}
+
+	return 0;
+}
+
+static int nitrox_request_irqs(struct nitrox_device *ndev)
+{
+	struct pci_dev *pdev = ndev->pdev;
+	struct msix_entry *msix_ent = ndev->msix.entries;
+	int nr_ring_vectors, i = 0, ring, cpu, ret;
+	char *name;
+
+	/*
+	 * PF MSI-X vectors
+	 *
+	 * Entry 0: NPS PKT ring 0
+	 * Entry 1: AQMQ ring 0
+	 * Entry 2: ZQM ring 0
+	 * Entry 3: NPS PKT ring 1
+	 * ....
+	 * Entry 192: NPS_CORE_INT_ACTIVE
+	 */
+	nr_ring_vectors = ndev->nr_queues * NR_RING_VECTORS;
+
+	/* request irq for pkt ring/ports only */
+	while (i < nr_ring_vectors) {
+		name = *(ndev->msix.names + i);
+		ring = (i / NR_RING_VECTORS);
+		snprintf(name, MAX_MSIX_VECTOR_NAME, "n5(%d)-slc-ring%d",
+			 ndev->idx, ring);
+
+		ret = request_irq(msix_ent[i].vector, nps_pkt_slc_isr, 0,
+				  name, &ndev->bh.slc[ring]);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to get irq %d for %s\n",
+				msix_ent[i].vector, name);
+			return ret;
+		}
+		cpu = ring % num_online_cpus();
+		irq_set_affinity_hint(msix_ent[i].vector, get_cpu_mask(cpu));
+
+		set_bit(i, ndev->msix.irqs);
+		i += NR_RING_VECTORS;
+	}
+
+	/* Request IRQ for NPS_CORE_INT_ACTIVE */
+	name = *(ndev->msix.names + i);
+	snprintf(name, MAX_MSIX_VECTOR_NAME, "n5(%d)-nps-core-int", ndev->idx);
+	ret = request_irq(msix_ent[i].vector, nps_core_int_isr, 0, name, ndev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to get irq %d for %s\n",
+			msix_ent[i].vector, name);
+		return ret;
+	}
+	set_bit(i, ndev->msix.irqs);
+
+	return 0;
+}
+
+static void nitrox_disable_msix(struct nitrox_device *ndev)
+{
+	struct msix_entry *msix_ent = ndev->msix.entries;
+	char **names = ndev->msix.names;
+	int i = 0, ring, nr_ring_vectors;
+
+	nr_ring_vectors = ndev->msix.nr_entries - 1;
+
+	/* clear pkt ring irqs */
+	while (i < nr_ring_vectors) {
+		if (test_and_clear_bit(i, ndev->msix.irqs)) {
+			ring = (i / NR_RING_VECTORS);
+			irq_set_affinity_hint(msix_ent[i].vector, NULL);
+			free_irq(msix_ent[i].vector, &ndev->bh.slc[ring]);
+		}
+		i += NR_RING_VECTORS;
+	}
+	irq_set_affinity_hint(msix_ent[i].vector, NULL);
+	free_irq(msix_ent[i].vector, ndev);
+	clear_bit(i, ndev->msix.irqs);
+
+	kfree(ndev->msix.entries);
+	for (i = 0; i < ndev->msix.nr_entries; i++)
+		kfree(*(names + i));
+
+	kfree(names);
+	pci_disable_msix(ndev->pdev);
+}
+
+/**
+ * nitrox_pf_cleanup_isr: Cleanup PF MSI-X and IRQ
+ * @ndev: NITROX device
+ */
+void nitrox_pf_cleanup_isr(struct nitrox_device *ndev)
+{
+	nitrox_disable_msix(ndev);
+	nitrox_cleanup_pkt_slc_bh(ndev);
+}
+
+/**
+ * nitrox_init_isr - Initialize PF MSI-X vectors and IRQ
+ * @ndev: NITROX device
+ *
+ * Return: 0 on success, a negative value on failure.
+ */
+int nitrox_pf_init_isr(struct nitrox_device *ndev)
+{
+	int err;
+
+	err = nitrox_setup_pkt_slc_bh(ndev);
+	if (err)
+		return err;
+
+	err = nitrox_enable_msix(ndev);
+	if (err)
+		goto msix_fail;
+
+	err = nitrox_request_irqs(ndev);
+	if (err)
+		goto irq_fail;
+
+	return 0;
+
+irq_fail:
+	nitrox_disable_msix(ndev);
+msix_fail:
+	nitrox_cleanup_pkt_slc_bh(ndev);
+	return err;
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
new file mode 100644
index 0000000..ab77c21
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -0,0 +1,170 @@
+#include <linux/cpumask.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/delay.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci_regs.h>
+#include <linux/vmalloc.h>
+#include <linux/pci.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_common.h"
+#include "nitrox_req.h"
+#include "nitrox_csr.h"
+
+#define CRYPTO_CTX_SIZE	256
+
+/* command queue alignments */
+#define AQMQ_ALIGN	32
+#define PKT_IN_ALIGN	16
+#define ZQMQ_ALIGN	64
+#define CMDQ_ALIGN	max3(AQMQ_ALIGN, PKT_IN_ALIGN, ZQMQ_ALIGN)
+
+static int cmdq_common_init(struct nitrox_device *ndev,
+			    struct nitrox_cmdq *cmdq)
+{
+	u32 qsize;
+
+	qsize = roundup_pow_of_two(ndev->qlen) * cmdq->instr_size;
+	cmdq->head_unaligned = dma_zalloc_coherent(DEV(ndev),
+						   (qsize + CMDQ_ALIGN),
+						   &cmdq->dma_unaligned,
+						   GFP_KERNEL);
+	if (!cmdq->head_unaligned)
+		return -ENOMEM;
+
+	cmdq->head = PTR_ALIGN(cmdq->head_unaligned, CMDQ_ALIGN);
+	cmdq->dma = PTR_ALIGN(cmdq->dma_unaligned, CMDQ_ALIGN);
+	cmdq->qsize = (qsize + CMDQ_ALIGN);
+	cmdq->write_index = 0;
+	cmdq->init_done = 1;
+
+	spin_lock_init(&cmdq->pending_lock);
+	spin_lock_init(&cmdq->cmdq_lock);
+	spin_lock_init(&cmdq->backlog_lock);
+
+	INIT_LIST_HEAD(&cmdq->in_progress_head);
+	INIT_LIST_HEAD(&cmdq->backlog_head);
+
+	atomic_set(&cmdq->pending_count, 0);
+	return 0;
+}
+
+static void cmdq_common_cleanup(struct nitrox_device *ndev,
+				struct nitrox_cmdq *cmdq)
+{
+	dma_free_coherent(DEV(ndev), cmdq->qsize,
+			  cmdq->head_unaligned, cmdq->dma_unaligned);
+
+	cmdq->dbell_csr_addr = NULL;
+	cmdq->head = NULL;
+	cmdq->dma = 0;
+	cmdq->write_index = 0;
+	cmdq->qsize = 0;
+	cmdq->instr_size = 0;
+	cmdq->init_done = 0;
+}
+
+static void nitrox_cleanup_pkt_cmdqs(struct nitrox_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < ndev->nr_queues; i++) {
+		struct nitrox_cmdq *cmdq = &ndev->pkt_cmdqs[i];
+
+		if (!cmdq->init_done)
+			continue;
+		cmdq_common_cleanup(ndev, cmdq);
+	}
+	vfree(ndev->pkt_cmdqs);
+	ndev->pkt_cmdqs = NULL;
+}
+
+static int nitrox_init_pkt_cmdqs(struct nitrox_device *ndev)
+{
+	int i, err, size;
+
+	size = ndev->nr_queues * sizeof(struct nitrox_cmdq);
+	ndev->pkt_cmdqs = vzalloc_node(size, dev_to_node(&ndev->pdev->dev));
+	if (!ndev->pkt_cmdqs)
+		return -ENOMEM;
+
+	for (i = 0; i < ndev->nr_queues; i++) {
+		struct nitrox_cmdq *cmdq;
+		u64 offset;
+
+		cmdq = &ndev->pkt_cmdqs[i];
+		cmdq->instr_size = sizeof(struct nps_pkt_instr);
+		offset = NPS_PKT_IN_INSTR_BAOFF_DBELLX(i);
+		/* SE ring doorbell address for this queue */
+		cmdq->dbell_csr_addr = nitrox_csr_addr(ndev, offset);
+
+		err = cmdq_common_init(ndev, cmdq);
+		if (err)
+			goto pkt_cmdq_fail;
+	}
+	return 0;
+
+pkt_cmdq_fail:
+	nitrox_cleanup_pkt_cmdqs(ndev);
+	return err;
+}
+
+static int create_crypto_dma_pool(struct nitrox_device *ndev)
+{
+	size_t size;
+
+	/* Crypto context pool, 16 byte aligned */
+	size = CRYPTO_CTX_SIZE + sizeof(struct ctx_hdr);
+	ndev->ctx_pool = dma_pool_create("crypto-context",
+					 DEV(ndev), size, 16, 0);
+	if (!ndev->ctx_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void destroy_crypto_dma_pool(struct nitrox_device *ndev)
+{
+	if (!ndev->ctx_pool)
+		return;
+
+	dma_pool_destroy(ndev->ctx_pool);
+	ndev->ctx_pool = NULL;
+}
+
+/**
+ * nitrox_common_sw_init - allocate software resources.
+ * @ndev: NITROX device
+ *
+ * Allocates crypto context pools and command queues etc.
+ *
+ * Return: 0 on success, or a negative error code on error.
+ */
+int nitrox_common_sw_init(struct nitrox_device *ndev)
+{
+	int err = 0;
+
+	/* per device crypto context pool */
+	err = create_crypto_dma_pool(ndev);
+	if (err)
+		return err;
+
+	err = nitrox_init_pkt_cmdqs(ndev);
+	if (err)
+		destroy_crypto_dma_pool(ndev);
+
+	return err;
+}
+
+/**
+ * nitrox_common_sw_cleanup - free software resources.
+ * @ndev: NITROX device
+ */
+void nitrox_common_sw_cleanup(struct nitrox_device *ndev)
+{
+	nitrox_cleanup_pkt_cmdqs(ndev);
+	destroy_crypto_dma_pool(ndev);
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
new file mode 100644
index 0000000..ac3e9b3
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -0,0 +1,460 @@
+#include <linux/aer.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_common.h"
+#include "nitrox_csr.h"
+
+#define CNN55XX_DEV_ID	0x12
+#define MAX_PF_QUEUES	64
+#define UCODE_HLEN 48
+#define SE_GROUP 0
+
+#define DRIVER_VERSION "1.0"
+/* SE microcode */
+#define SE_FW	"cnn55xx_se.fw"
+
+static const char nitrox_driver_name[] = "CNN55XX";
+
+static LIST_HEAD(ndevlist);
+static DEFINE_MUTEX(devlist_lock);
+static unsigned int num_devices;
+
+/**
+ * nitrox_pci_tbl - PCI Device ID Table
+ */
+static const struct pci_device_id nitrox_pci_tbl[] = {
+	{PCI_VDEVICE(CAVIUM, CNN55XX_DEV_ID), 0},
+	/* required last entry */
+	{0, }
+};
+MODULE_DEVICE_TABLE(pci, nitrox_pci_tbl);
+
+static unsigned int qlen = DEFAULT_CMD_QLEN;
+module_param(qlen, uint, 0644);
+MODULE_PARM_DESC(qlen, "Command queue length - default 2048");
+
+/**
+ * struct ucode - Firmware Header
+ * @id: microcode ID
+ * @version: firmware version
+ * @code_size: code section size
+ * @raz: alignment
+ * @code: code section
+ */
+struct ucode {
+	u8 id;
+	char version[VERSION_LEN - 1];
+	__be32 code_size;
+	u8 raz[12];
+	u64 code[0];
+};
+
+/**
+ * write_to_ucd_unit - Write Firmware to NITROX UCD unit
+ */
+static void write_to_ucd_unit(struct nitrox_device *ndev, struct ucode *ucode)
+{
+	u32 code_size = be32_to_cpu(ucode->code_size) * 2;
+	u64 offset, data;
+	int i = 0;
+
+	/*
+	 * UCD structure
+	 *
+	 *  -------------
+	 *  |    BLK 7  |
+	 *  -------------
+	 *  |    BLK 6  |
+	 *  -------------
+	 *  |    ...    |
+	 *  -------------
+	 *  |    BLK 0  |
+	 *  -------------
+	 *  Total of 8 blocks, each size 32KB
+	 */
+
+	/* set the block number */
+	offset = UCD_UCODE_LOAD_BLOCK_NUM;
+	nitrox_write_csr(ndev, offset, 0);
+
+	code_size = roundup(code_size, 8);
+	while (code_size) {
+		data = ucode->code[i];
+		/* write 8 bytes at a time */
+		offset = UCD_UCODE_LOAD_IDX_DATAX(i);
+		nitrox_write_csr(ndev, offset, data);
+		code_size -= 8;
+		i++;
+	}
+
+	/* put all SE cores in group 0 */
+	offset = POM_GRP_EXECMASKX(SE_GROUP);
+	nitrox_write_csr(ndev, offset, (~0ULL));
+
+	for (i = 0; i < ndev->hw.se_cores; i++) {
+		/*
+		 * write block number and firware length
+		 * bit:<2:0> block number
+		 * bit:3 is set SE uses 32KB microcode
+		 * bit:3 is clear SE uses 64KB microcode
+		 */
+		offset = UCD_SE_EID_UCODE_BLOCK_NUMX(i);
+		nitrox_write_csr(ndev, offset, 0x8);
+	}
+	usleep_range(300, 400);
+}
+
+static int nitrox_load_fw(struct nitrox_device *ndev, const char *fw_name)
+{
+	const struct firmware *fw;
+	struct ucode *ucode;
+	int ret;
+
+	dev_info(DEV(ndev), "Loading firmware \"%s\"\n", fw_name);
+
+	ret = request_firmware(&fw, fw_name, DEV(ndev));
+	if (ret < 0) {
+		dev_err(DEV(ndev), "failed to get firmware %s\n", fw_name);
+		return ret;
+	}
+
+	ucode = (struct ucode *)fw->data;
+	/* copy the firmware version */
+	memcpy(ndev->hw.fw_name, ucode->version, (VERSION_LEN - 2));
+	ndev->hw.fw_name[VERSION_LEN - 1] = '\0';
+
+	write_to_ucd_unit(ndev, ucode);
+	release_firmware(fw);
+
+	set_bit(NITROX_UCODE_LOADED, &ndev->status);
+	/* barrier to sync with other cpus */
+	smp_mb__after_atomic();
+	return 0;
+}
+
+/**
+ * nitrox_add_to_devlist - add NITROX device to global device list
+ * @ndev: NITROX device
+ */
+static int nitrox_add_to_devlist(struct nitrox_device *ndev)
+{
+	struct nitrox_device *dev;
+	int ret = 0;
+
+	INIT_LIST_HEAD(&ndev->list);
+	atomic_set(&ndev->refcnt, 0);
+
+	mutex_lock(&devlist_lock);
+	list_for_each_entry(dev, &ndevlist, list) {
+		if (dev == ndev) {
+			ret = -EEXIST;
+			goto unlock;
+		}
+	}
+	ndev->idx = num_devices++;
+	list_add_tail(&ndev->list, &ndevlist);
+unlock:
+	mutex_unlock(&devlist_lock);
+	return ret;
+}
+
+/**
+ * nitrox_remove_from_devlist - remove NITROX device from global device list
+ * @ndev: NITROX device
+ */
+static void nitrox_remove_from_devlist(struct nitrox_device *ndev)
+{
+	mutex_lock(&devlist_lock);
+	list_del(&ndev->list);
+	num_devices--;
+	mutex_unlock(&devlist_lock);
+}
+
+static int nitrox_reset_device(struct pci_dev *pdev)
+{
+	int pos = 0;
+
+	pos = pci_save_state(pdev);
+	if (pos) {
+		dev_err(&pdev->dev, "Failed to save pci state\n");
+		return -ENOMEM;
+	}
+
+	pos = pci_pcie_cap(pdev);
+	if (!pos)
+		return -ENOTTY;
+
+	if (!pci_wait_for_pending_transaction(pdev))
+		dev_err(&pdev->dev, "waiting for pending transaction\n");
+
+	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
+	msleep(100);
+	pci_restore_state(pdev);
+
+	return 0;
+}
+
+static int nitrox_pf_sw_init(struct nitrox_device *ndev)
+{
+	int err;
+
+	err = nitrox_common_sw_init(ndev);
+	if (err)
+		return err;
+
+	err = nitrox_pf_init_isr(ndev);
+	if (err)
+		nitrox_common_sw_cleanup(ndev);
+
+	return err;
+}
+
+static void nitrox_pf_sw_cleanup(struct nitrox_device *ndev)
+{
+	nitrox_pf_cleanup_isr(ndev);
+	nitrox_common_sw_cleanup(ndev);
+}
+
+/**
+ * nitrox_bist_check - Check NITORX BIST registers status
+ * @ndev: NITROX device
+ */
+static int nitrox_bist_check(struct nitrox_device *ndev)
+{
+	u64 value = 0;
+	int i;
+
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		value += nitrox_read_csr(ndev, EMU_BIST_STATUSX(i));
+		value += nitrox_read_csr(ndev, EFL_CORE_BIST_REGX(i));
+	}
+	value += nitrox_read_csr(ndev, UCD_BIST_STATUS);
+	value += nitrox_read_csr(ndev, NPS_CORE_BIST_REG);
+	value += nitrox_read_csr(ndev, NPS_CORE_NPC_BIST_REG);
+	value += nitrox_read_csr(ndev, NPS_PKT_SLC_BIST_REG);
+	value += nitrox_read_csr(ndev, NPS_PKT_IN_BIST_REG);
+	value += nitrox_read_csr(ndev, POM_BIST_REG);
+	value += nitrox_read_csr(ndev, BMI_BIST_REG);
+	value += nitrox_read_csr(ndev, EFL_TOP_BIST_STAT);
+	value += nitrox_read_csr(ndev, BMO_BIST_REG);
+	value += nitrox_read_csr(ndev, LBC_BIST_STATUS);
+	value += nitrox_read_csr(ndev, PEM_BIST_STATUSX(0));
+	if (value)
+		return -EIO;
+	return 0;
+}
+
+static void nitrox_get_hwinfo(struct nitrox_device *ndev)
+{
+	union emu_fuse_map emu_fuse;
+	u64 offset;
+	int i;
+
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		u8 dead_cores;
+
+		offset = EMU_FUSE_MAPX(i);
+		emu_fuse.value = nitrox_read_csr(ndev, offset);
+		if (emu_fuse.s.valid) {
+			dead_cores = hweight32(emu_fuse.s.ae_fuse);
+			ndev->hw.ae_cores += AE_CORES_PER_CLUSTER - dead_cores;
+			dead_cores = hweight16(emu_fuse.s.se_fuse);
+			ndev->hw.se_cores += SE_CORES_PER_CLUSTER - dead_cores;
+		}
+	}
+}
+
+static int nitrox_pf_hw_init(struct nitrox_device *ndev)
+{
+	int err;
+
+	err = nitrox_bist_check(ndev);
+	if (err) {
+		dev_err(&ndev->pdev->dev, "BIST check failed\n");
+		return err;
+	}
+	/* get cores information */
+	nitrox_get_hwinfo(ndev);
+
+	nitrox_config_nps_unit(ndev);
+	nitrox_config_pom_unit(ndev);
+	nitrox_config_efl_unit(ndev);
+	/* configure IO units */
+	nitrox_config_bmi_unit(ndev);
+	nitrox_config_bmo_unit(ndev);
+	/* configure Local Buffer Cache */
+	nitrox_config_lbc_unit(ndev);
+	nitrox_config_rand_unit(ndev);
+
+	/* load firmware on SE cores */
+	err = nitrox_load_fw(ndev, SE_FW);
+	if (err)
+		return err;
+
+	nitrox_config_emu_unit(ndev);
+
+	return 0;
+}
+
+/**
+ * nitrox_probe - NITROX Initialization function.
+ * @pdev: PCI device information struct
+ * @id: entry in nitrox_pci_tbl
+ *
+ * Return: 0, if the driver is bound to the device, or
+ *         a negative error if there is failure.
+ */
+static int nitrox_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct nitrox_device *ndev;
+	int err;
+
+	dev_info_once(&pdev->dev, "%s driver version %s\n",
+		      nitrox_driver_name, DRIVER_VERSION);
+
+	err = pci_enable_device_mem(pdev);
+	if (err)
+		return err;
+
+	/* do FLR */
+	err = nitrox_reset_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "FLR failed\n");
+		pci_disable_device(pdev);
+		return err;
+	}
+
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
+		dev_dbg(&pdev->dev, "DMA to 64-BIT address\n");
+	} else {
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev, "DMA configuration failed\n");
+			pci_disable_device(pdev);
+			return err;
+		}
+	}
+
+	err = pci_request_mem_regions(pdev, nitrox_driver_name);
+	if (err) {
+		pci_disable_device(pdev);
+		return err;
+	}
+	pci_set_master(pdev);
+
+	ndev = kzalloc(sizeof(*ndev), GFP_KERNEL);
+	if (!ndev)
+		goto ndev_fail;
+
+	pci_set_drvdata(pdev, ndev);
+	ndev->pdev = pdev;
+
+	/* add to device list */
+	nitrox_add_to_devlist(ndev);
+
+	ndev->hw.vendor_id = pdev->vendor;
+	ndev->hw.device_id = pdev->device;
+	ndev->hw.revision_id = pdev->revision;
+	/* command timeout in jiffies */
+	ndev->timeout = msecs_to_jiffies(CMD_TIMEOUT);
+	ndev->node = dev_to_node(&pdev->dev);
+	if (ndev->node == NUMA_NO_NODE)
+		ndev->node = 0;
+
+	ndev->bar_addr = ioremap(pci_resource_start(pdev, 0),
+				 pci_resource_len(pdev, 0));
+	if (!ndev->bar_addr) {
+		err = -EIO;
+		goto ioremap_err;
+	}
+	/* allocate command queus based on cpus, max queues are 64 */
+	ndev->nr_queues = min_t(u32, MAX_PF_QUEUES, num_online_cpus());
+	ndev->qlen = qlen;
+
+	err = nitrox_pf_sw_init(ndev);
+	if (err)
+		goto ioremap_err;
+
+	err = nitrox_pf_hw_init(ndev);
+	if (err)
+		goto pf_hw_fail;
+
+	set_bit(NITROX_READY, &ndev->status);
+	/* barrier to sync with other cpus */
+	smp_mb__after_atomic();
+	return 0;
+
+pf_hw_fail:
+	nitrox_pf_sw_cleanup(ndev);
+ioremap_err:
+	nitrox_remove_from_devlist(ndev);
+	kfree(ndev);
+	pci_set_drvdata(pdev, NULL);
+ndev_fail:
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+	return err;
+}
+
+/**
+ * nitrox_remove - Unbind the driver from the device.
+ * @pdev: PCI device information struct
+ */
+static void nitrox_remove(struct pci_dev *pdev)
+{
+	struct nitrox_device *ndev = pci_get_drvdata(pdev);
+
+	if (!ndev)
+		return;
+
+	dev_info(DEV(ndev), "Removing Device %x:%x\n",
+		 ndev->hw.vendor_id, ndev->hw.device_id);
+
+	if (nitrox_in_use(ndev)) {
+		dev_warn(DEV(ndev), "Device refcnt not zero (%d)\n",
+			 atomic_read(&ndev->refcnt));
+	}
+	clear_bit(NITROX_READY, &ndev->status);
+	/* barrier to sync with other cpus */
+	smp_mb__after_atomic();
+
+	nitrox_remove_from_devlist(ndev);
+	nitrox_pf_sw_cleanup(ndev);
+
+	iounmap(ndev->bar_addr);
+	kfree(ndev);
+
+	pci_set_drvdata(pdev, NULL);
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static void nitrox_shutdown(struct pci_dev *pdev)
+{
+	pci_set_drvdata(pdev, NULL);
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver nitrox_driver = {
+	.name = nitrox_driver_name,
+	.id_table = nitrox_pci_tbl,
+	.probe = nitrox_probe,
+	.remove	= nitrox_remove,
+	.shutdown = nitrox_shutdown,
+};
+
+module_pci_driver(nitrox_driver);
+
+MODULE_AUTHOR("Srikanth Jampala <Jampala.Srikanth@cavium.com>");
+MODULE_DESCRIPTION("Cavium NITROX family CNN55XX PF Driver" DRIVER_VERSION " ");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_FIRMWARE(SE_FW);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cavium/nitrox/nitrox_req.h
new file mode 100644
index 0000000..07789e6
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -0,0 +1,438 @@
+#ifndef __NITROX_REQ_H
+#define __NITROX_REQ_H
+
+#include <linux/dma-mapping.h>
+#include <crypto/aes.h>
+
+#include "nitrox_dev.h"
+
+/**
+ * struct gphdr - General purpose Header
+ * @param0: first parameter.
+ * @param1: second parameter.
+ * @param2: third parameter.
+ * @param3: fourth parameter.
+ *
+ * Params tell the iv and enc/dec data offsets.
+ */
+struct gphdr {
+	__be16 param0;
+	__be16 param1;
+	__be16 param2;
+	__be16 param3;
+};
+
+/**
+ * struct se_req_ctrl - SE request information.
+ * @arg: Minor number of the opcode
+ * @ctxc: Context control.
+ * @unca: Uncertainity enabled.
+ * @info: Additional information for SE cores.
+ * @ctxl: Context length in bytes.
+ * @uddl: User defined data length
+ */
+union se_req_ctrl {
+	u64 value;
+	struct {
+		u64 raz	: 22;
+		u64 arg	: 8;
+		u64 ctxc : 2;
+		u64 unca : 1;
+		u64 info : 3;
+		u64 unc : 8;
+		u64 ctxl : 12;
+		u64 uddl : 8;
+	} s;
+};
+
+struct nitrox_buffer {
+	union {
+		void *addr;
+		dma_addr_t dma;
+	};
+	u32 len;
+};
+
+struct io_sglist {
+	u16 cnt;
+	struct nitrox_buffer bufs[];
+};
+
+/**
+ * struct crypto_request - Crypto request structure.
+ * @opcode: Request opcode (enc/dec)
+ * @flags: flags from crypto subsystem
+ * @gph: GP Header
+ * @ctrl: Request Information.
+ * @in: Input sglist
+ * @out: Output sglist
+ * @ctx_handle: Crypto context handle.
+ * @callback: callback after request completion.
+ * @cb_arg: callback argument
+ */
+struct crypto_request {
+	u8 opcode;
+	u32 flags;
+
+	struct gphdr gph;
+	union se_req_ctrl ctrl;
+	struct io_sglist *in;
+	struct io_sglist *out;
+
+	u64 ctx_handle;
+	void (*callback)(int status, void *arg);
+	void *cb_arg;
+};
+
+/* Crypto opcodes */
+#define FLEXI_CRYPTO_ENCRYPT_HMAC	0x33
+#define ENCRYPT	0
+#define DECRYPT 1
+
+/* IV from context */
+#define IV_FROM_CTX	0
+/* IV from Input data */
+#define IV_FROM_DPTR	1
+
+/**
+ * cipher opcodes for firmware
+ */
+enum flexi_cipher {
+	CIPHER_NULL = 0,
+	CIPHER_3DES_CBC,
+	CIPHER_3DES_ECB,
+	CIPHER_AES_CBC,
+	CIPHER_AES_ECB,
+	CIPHER_AES_CFB,
+	CIPHER_AES_CTR,
+	CIPHER_AES_GCM,
+	CIPHER_AES_XTS,
+	CIPHER_AES_CCM,
+	CIPHER_AES_CBC_CTS,
+	CIPHER_AES_ECB_CTS,
+	CIPHER_INVALID
+};
+
+/**
+ * struct crypto_keys - Crypto keys
+ * @key: Encryption key or KEY1 for AES-XTS
+ * @iv: Encryption IV or Tweak for AES-XTS
+ */
+struct crypto_keys {
+	union {
+		u8 key[AES_MAX_KEY_SIZE];
+		u8 key1[AES_MAX_KEY_SIZE];
+	} u;
+	u8 iv[AES_BLOCK_SIZE];
+};
+
+/**
+ * struct auth_keys - Authentication keys
+ * @ipad: IPAD or KEY2 for AES-XTS
+ * @opad: OPAD or AUTH KEY if auth_input_type = 1
+ */
+struct auth_keys {
+	union {
+		u8 ipad[64];
+		u8 key2[64];
+	} u;
+	u8 opad[64];
+};
+
+/**
+ * struct flexi_crypto_context - Crypto context
+ * @cipher_type: Encryption cipher type
+ * @aes_keylen: AES key length
+ * @iv_source: Encryption IV source
+ * @hash_type: Authentication type
+ * @auth_input_type: Authentication input type
+ *   1 - Authentication IV and KEY, microcode calculates OPAD/IPAD
+ *   0 - Authentication OPAD/IPAD
+ * @mac_len: mac length
+ * @crypto: Crypto keys
+ * @auth: Authentication keys
+ */
+struct flexi_crypto_context {
+	union {
+		__be64 flags;
+		struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+			u64 cipher_type	: 4;
+			u64 reserved_59	: 1;
+			u64 aes_keylen : 2;
+			u64 iv_source : 1;
+			u64 hash_type : 4;
+			u64 reserved_49_51 : 3;
+			u64 auth_input_type: 1;
+			u64 mac_len : 8;
+			u64 reserved_0_39 : 40;
+#else
+			u64 reserved_0_39 : 40;
+			u64 mac_len : 8;
+			u64 auth_input_type: 1;
+			u64 reserved_49_51 : 3;
+			u64 hash_type : 4;
+			u64 iv_source : 1;
+			u64 aes_keylen : 2;
+			u64 reserved_59	: 1;
+			u64 cipher_type	: 4;
+#endif
+		} w0;
+	};
+
+	struct crypto_keys crypto;
+	struct auth_keys auth;
+};
+
+struct nitrox_crypto_instance {
+	struct nitrox_device *ndev;
+
+	union {
+		u64 ctx_handle;
+		struct flexi_crypto_context *fctx;
+	} u;
+};
+
+struct nitrox_crypto_request {
+	struct crypto_request creq;
+	struct nitrox_crypto_instance *inst;
+	struct ablkcipher_request *abreq;
+};
+
+/**
+ * struct pkt_instr_hdr - Packet Instruction Header
+ * @g: Gather used
+ *   When [G] is set and [GSZ] != 0, the instruction is
+ *   indirect gather instruction.
+ *   When [G] is set and [GSZ] = 0, the instruction is
+ *   direct gather instruction.
+ * @gsz: Number of pointers in the indirect gather list
+ * @ihi: When set hardware duplicates the 1st 8 bytes of pkt_instr_hdr
+ *   and adds them to the packet after the pkt_instr_hdr but before any UDD
+ * @ssz: Not used by the input hardware. But can become slc_store_int[SSZ]
+ *   when [IHI] is set.
+ * @fsz: The number of front data bytes directly included in the
+ *   PCIe instruction.
+ * @tlen: The length of the input packet in bytes, include:
+ *   - 16B pkt_hdr
+ *   - Inline context bytes if any,
+ *   - UDD if any,
+ *   - packet payload bytes
+ */
+union pkt_instr_hdr {
+	u64 value;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 raz_48_63 : 16;
+		u64 g : 1;
+		u64 gsz	: 7;
+		u64 ihi	: 1;
+		u64 ssz	: 7;
+		u64 raz_30_31 : 2;
+		u64 fsz	: 6;
+		u64 raz_16_23 : 8;
+		u64 tlen : 16;
+#else
+		u64 tlen : 16;
+		u64 raz_16_23 : 8;
+		u64 fsz	: 6;
+		u64 raz_30_31 : 2;
+		u64 ssz	: 7;
+		u64 ihi	: 1;
+		u64 gsz	: 7;
+		u64 g : 1;
+		u64 raz_48_63 : 16;
+#endif
+	} s;
+};
+
+/**
+ * struct pkt_hdr - Packet Input Header
+ * @opcode: Request opcode (Major)
+ * @arg: Request opcode (Minor)
+ * @ctxc: Context control.
+ * @unca: When set [UNC] is the uncertainty count for an input packet.
+ *        The hardware uses uncertainty counts to predict
+ *        output buffer use and avoid deadlock.
+ * @info: Not used by input hardware. Available for use
+ *        during SE processing.
+ * @destport: The expected destination port/ring/channel for the packet.
+ * @unc: Uncertainty count for an input packet.
+ * @grp: SE group that will process the input packet.
+ * @ctxl: Context Length in 64-bit words.
+ * @uddl: User-defined data (UDD) length in bytes.
+ * @ctxp: Context pointer. CTXP<63,2:0> must be zero in all cases.
+ */
+union pkt_hdr {
+	u64 value[2];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 opcode : 8;
+		u64 arg	: 8;
+		u64 ctxc : 2;
+		u64 unca : 1;
+		u64 raz_44 : 1;
+		u64 info : 3;
+		u64 destport : 9;
+		u64 unc	: 8;
+		u64 raz_19_23 : 5;
+		u64 grp	: 3;
+		u64 raz_15 : 1;
+		u64 ctxl : 7;
+		u64 uddl : 8;
+#else
+		u64 uddl : 8;
+		u64 ctxl : 7;
+		u64 raz_15 : 1;
+		u64 grp	: 3;
+		u64 raz_19_23 : 5;
+		u64 unc	: 8;
+		u64 destport : 9;
+		u64 info : 3;
+		u64 raz_44 : 1;
+		u64 unca : 1;
+		u64 ctxc : 2;
+		u64 arg	: 8;
+		u64 opcode : 8;
+#endif
+		__be64 ctxp;
+	} s;
+};
+
+/**
+ * struct slc_store_info - Solicited Paceket Output Store Information.
+ * @ssz: The number of scatterlist pointers for the solicited output port
+ *       packet.
+ * @rptr: The result pointer for the solicited output port packet.
+ *        If [SSZ]=0, [RPTR] must point directly to a buffer on the remote
+ *        host that is large enough to hold the entire output packet.
+ *        If [SSZ]!=0, [RPTR] must point to an array of ([SSZ]+3)/4
+ *        sglist components at [RPTR] on the remote host.
+ */
+union slc_store_info {
+	u64 value[2];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 raz_39_63 : 25;
+		u64 ssz	: 7;
+		u64 raz_0_31 : 32;
+#else
+		u64 raz_0_31 : 32;
+		u64 ssz	: 7;
+		u64 raz_39_63 : 25;
+#endif
+		__be64 rptr;
+	} s;
+};
+
+/**
+ * struct nps_pkt_instr - NPS Packet Instruction of SE cores.
+ * @dptr0 : Input pointer points to buffer in remote host.
+ * @ih: Packet Instruction Header (8 bytes)
+ * @irh: Packet Input Header (16 bytes)
+ * @slc: Solicited Packet Output Store Information (16 bytes)
+ * @fdata: Front data
+ *
+ * 64-Byte Instruction Format
+ */
+struct nps_pkt_instr {
+	__be64 dptr0;
+	union pkt_instr_hdr ih;
+	union pkt_hdr irh;
+	union slc_store_info slc;
+	u64 fdata[2];
+};
+
+/**
+ * struct ctx_hdr - Book keeping data about the crypto context
+ * @pool: Pool used to allocate crypto context
+ * @dma: Base DMA address of the cypto context
+ * @ctx_dma: Actual usable crypto context for NITROX
+ */
+struct ctx_hdr {
+	struct dma_pool *pool;
+	dma_addr_t dma;
+	dma_addr_t ctx_dma;
+};
+
+/*
+ * struct sglist_component - SG list component format
+ * @len0: The number of bytes at [PTR0] on the remote host.
+ * @len1: The number of bytes at [PTR1] on the remote host.
+ * @len2: The number of bytes at [PTR2] on the remote host.
+ * @len3: The number of bytes at [PTR3] on the remote host.
+ * @dma0: First pointer point to buffer in remote host.
+ * @dma1: Second pointer point to buffer in remote host.
+ * @dma2: Third pointer point to buffer in remote host.
+ * @dma3: Fourth pointer point to buffer in remote host.
+ */
+struct sglist_component {
+	__be16 len[4];
+	__be64 dma[4];
+} __packed;
+
+/*
+ * strutct dma_sgtable - SG list information
+ * @map_cnt: Number of buffers mapped
+ * @nr_comp: Number of sglist components
+ * @total_bytes: Total bytes in sglist.
+ * @len: Total sglist components length.
+ * @dma: DMA address of sglist component.
+ * @dir: DMA direction.
+ * @sglist: SG list of input/output buffers.
+ * @sgcomp: sglist component for NITROX.
+ */
+struct dma_sgtable {
+	u8 map_cnt;
+	u8 nr_comp;
+	u16 total_bytes;
+	u32 len;
+	dma_addr_t dma;
+	enum dma_data_direction dir;
+
+	struct io_sglist *sglist;
+	struct sglist_component *sgcomp;
+};
+
+/* Response Header Length */
+#define ORH_HLEN	8
+/* Completion bytes Length */
+#define COMP_HLEN	8
+
+struct resp_hdr {
+	u64 orh;
+	u64 completion;
+};
+
+/**
+ * struct nitrox_softreq - Represents the NIROX Request.
+ * @in_progress: In progress list entry
+ * @backlog: Backlog list entry
+ * @ndev: Device used to submit the request
+ * @cmdq: Command queue for submission
+ * @resp: Response headers
+ * @instr: 64B instruction
+ * @in: SG table for input
+ * @out SG table for output
+ * @tstamp: Request submitted time in jiffies
+ * @callback: callback after request completion/timeout
+ * @cb_arg: callback argument
+ */
+struct nitrox_softreq {
+	struct list_head in_progress;
+	struct list_head backlog;
+
+	struct nitrox_device *ndev;
+	struct nitrox_cmdq *cmdq;
+	struct resp_hdr resp;
+	struct nps_pkt_instr instr;
+
+	struct dma_sgtable in;
+	struct dma_sgtable out;
+
+	unsigned long tstamp;
+	void (*callback)(int status, void *arg);
+	void *cb_arg;
+};
+
+#endif /* __NITROX_REQ_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
new file mode 100644
index 0000000..936cb63
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -0,0 +1,572 @@
+#include <linux/gfp.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_req.h"
+#include "nitrox_csr.h"
+#include "nitrox_req.h"
+
+/* SLC_STORE_INFO */
+#define MIN_UDD_LEN 16
+/* PKT_IN_HDR + SLC_STORE_INFO */
+#define FDATA_SIZE 32
+/* Base destination port for the solicited requests */
+#define SOLICIT_BASE_DPORT 256
+#define DEFAULT_POLL_COUNT 512
+#define PENDING_SIG	0xFFFFFFFFFFFFFFFFUL
+
+/**
+ * Response codes from SE microcode
+ * 0x00 - Success
+ *   Completion with no error
+ * 0x43 - ERR_GC_DATA_LEN_INVALID
+ *   Invalid Data length if Encryption Data length is
+ *   less than 16 bytes for AES-XTS and AES-CTS.
+ * 0x45 - ERR_GC_CTX_LEN_INVALID
+ *   Invalid context length: CTXL != 23 words.
+ * 0x4F - ERR_GC_DOCSIS_CIPHER_INVALID
+ *   DOCSIS support is enabled with other than
+ *   AES/DES-CBC mode encryption.
+ * 0x50 - ERR_GC_DOCSIS_OFFSET_INVALID
+ *   Authentication offset is other than 0 with
+ *   Encryption IV source = 0.
+ *   Authentication offset is other than 8 (DES)/16 (AES)
+ *   with Encryption IV source = 1
+ * 0x51 - ERR_GC_CRC32_INVALID_SELECTION
+ *   CRC32 is enabled for other than DOCSIS encryption.
+ * 0x52 - ERR_GC_AES_CCM_FLAG_INVALID
+ *   Invalid flag options in AES-CCM IV.
+ */
+
+/**
+ * dma_free_sglist - unmap and free the sg lists.
+ * @ndev: N5 device
+ * @sgtbl: SG table
+ */
+static void dma_free_sglist(struct nitrox_device *ndev,
+			    struct dma_sgtable *sgtbl)
+{
+	struct device *dev = DEV(ndev);
+	struct io_sglist *sglist = sgtbl->sglist;
+	int i;
+
+	if (sgtbl->len)
+		dma_unmap_single(dev, sgtbl->dma, sgtbl->len, sgtbl->dir);
+
+	if (sglist) {
+		for (i = 0; i < sglist->cnt; i++) {
+			dma_unmap_single(dev, sglist->bufs[i].dma,
+					 sglist->bufs[i].len, sgtbl->dir);
+		}
+	}
+	kfree(sglist);
+	kfree(sgtbl->sgcomp);
+
+	sgtbl->sgcomp = NULL;
+	sgtbl->len = 0;
+}
+
+/**
+ * create_sg_component - create SG componets for N5 device.
+ * @sr: Request structure
+ * @sgtbl: SG table
+ * @nr_comp: total number of components required
+ *
+ * Component structure
+ *
+ *   63     48 47     32 31    16 15      0
+ *   --------------------------------------
+ *   |   LEN0  |  LEN1  |  LEN2  |  LEN3  |
+ *   |-------------------------------------
+ *   |               PTR0                 |
+ *   --------------------------------------
+ *   |               PTR1                 |
+ *   --------------------------------------
+ *   |               PTR2                 |
+ *   --------------------------------------
+ *   |               PTR3                 |
+ *   --------------------------------------
+ *
+ *   Returns 0 if success or a negative errno code on error.
+ */
+static int create_sg_component(struct nitrox_softreq *sr,
+			       struct dma_sgtable *sgtbl, int nr_comp)
+{
+	struct nitrox_device *ndev = sr->ndev;
+	struct sglist_component *sgcomp;
+	struct nitrox_buffer *buf;
+	dma_addr_t dma;
+	size_t sz;
+	u16 cnt;
+	int i, j;
+
+	/* each component holds 4 dma pointers */
+	sz = (nr_comp * sizeof(struct sglist_component));
+	sgcomp = kzalloc_node(sz, GFP_ATOMIC, dev_to_node(DEV(ndev)));
+	if (!sgcomp)
+		return -ENOMEM;
+
+	dma = dma_map_single(DEV(ndev), sgcomp, sz, sgtbl->dir);
+	if (dma_mapping_error(DEV(ndev), dma)) {
+		kfree(sgcomp);
+		return -ENOMEM;
+	}
+	sgtbl->nr_comp = nr_comp;
+	sgtbl->sgcomp = sgcomp;
+	sgtbl->dma = dma;
+	sgtbl->len = sz;
+
+	cnt = sgtbl->sglist->cnt;
+	buf = &sgtbl->sglist->bufs[0];
+	/* populate sg component */
+	for (i = 0; i < nr_comp; i++) {
+		struct sglist_component *comp = &sgcomp[i];
+
+		for (j = 0; (j < 4) && cnt; j++, cnt--) {
+			comp->len[j] = cpu_to_be16(buf->len);
+			comp->dma[j] = cpu_to_be64(buf->dma);
+			buf++;
+		}
+	}
+	return 0;
+}
+
+/**
+ * dma_map_inbufs - DMA map input sglist and creates sglist component
+ *                  for N5 device.
+ * @sr: Request structure
+ * @req: Crypto request structre
+ *
+ * Returns 0 if successful or a negative errno code on error.
+ */
+static int dma_map_inbufs(struct nitrox_softreq *sr, struct crypto_request *req)
+{
+	struct device *dev = DEV(sr->ndev);
+	struct io_sglist *in = req->in;
+	struct io_sglist *sglist;
+	dma_addr_t dma;
+	size_t sz;
+	int nr_comp, i, ret = 0;
+
+	if (!in->cnt)
+		return -EINVAL;
+
+	sr->in.dir = DMA_TO_DEVICE;
+	/* single pointer, send in direct dma mode */
+	if (in->cnt == 1) {
+		dma = dma_map_single(dev, in->bufs[0].addr, in->bufs[0].len,
+				     DMA_TO_DEVICE);
+		ret = dma_mapping_error(dev, dma);
+		if (ret)
+			return ret;
+
+		sr->in.dma = dma;
+		sr->in.len = in->bufs[0].len;
+		sr->in.total_bytes = in->bufs[0].len;
+		sr->in.map_cnt = 1;
+	} else {
+		/* creater gather component */
+		sz = sizeof(*sglist) + (in->cnt * sizeof(struct nitrox_buffer));
+		sglist = kzalloc(sz, GFP_ATOMIC);
+		if (!sglist)
+			return -ENOMEM;
+
+		sr->in.sglist = sglist;
+		sglist->cnt = in->cnt;
+
+		for (i = 0; i < sglist->cnt; i++) {
+			dma = dma_map_single(dev, in->bufs[i].addr,
+					     in->bufs[i].len, DMA_TO_DEVICE);
+			ret = dma_mapping_error(dev, dma);
+			if (ret)
+				goto inmap_err;
+			sglist->bufs[i].dma = dma;
+			sglist->bufs[i].len = in->bufs[i].len;
+			sr->in.total_bytes += in->bufs[i].len;
+			sr->in.map_cnt++;
+		}
+		/* create NITROX gather component */
+		nr_comp = roundup(in->cnt, 4) / 4;
+
+		ret = create_sg_component(sr, &sr->in, nr_comp);
+		if (ret)
+			goto inmap_err;
+	}
+	return 0;
+
+inmap_err:
+	dma_free_sglist(sr->ndev, &sr->in);
+	return ret;
+}
+
+static int dma_map_outbufs(struct nitrox_softreq *sr,
+			   struct crypto_request *req)
+{
+	struct device *dev = DEV(sr->ndev);
+	struct io_sglist *out = req->out;
+	struct io_sglist *sglist;
+	struct nitrox_buffer *buf;
+	dma_addr_t dma;
+	size_t sz;
+	int i, ret = 0, nr_comp;
+
+	if (!out->cnt)
+		return -EINVAL;
+
+	/*
+	 * Need two extra out pointers to hold
+	 * response header and Completion bytes.
+	 */
+	sz = sizeof(*sglist) + ((out->cnt + 2) * sizeof(struct nitrox_buffer));
+	sglist = kzalloc(sz, GFP_ATOMIC);
+	if (!sglist)
+		return -ENOMEM;
+
+	sr->out.sglist = sglist;
+	sr->out.dir = DMA_BIDIRECTIONAL;
+	sglist->cnt = (out->cnt + 2);
+
+	/* Response Header */
+	dma = dma_map_single(dev, &sr->resp.orh, ORH_HLEN, DMA_BIDIRECTIONAL);
+	ret = dma_mapping_error(dev, dma);
+	if (ret) {
+		kfree(sglist);
+		return ret;
+	}
+	sglist->bufs[0].dma = dma;
+	sglist->bufs[0].len = ORH_HLEN;
+	sr->out.total_bytes = ORH_HLEN;
+	sr->out.map_cnt = 1;
+
+	buf = &sglist->bufs[1];
+	for (i = 0; i < out->cnt; i++) {
+		dma = dma_map_single(dev, out->bufs[i].addr,
+				     out->bufs[i].len, DMA_BIDIRECTIONAL);
+		ret = dma_mapping_error(dev, dma);
+		if (ret)
+			goto outmap_err;
+
+		buf->dma = dma;
+		buf->len = out->bufs[i].len;
+		sr->out.total_bytes += out->bufs[i].len;
+		sr->out.map_cnt++;
+		buf++;
+	}
+
+	/* Completion code */
+	dma = dma_map_single(dev, &sr->resp.completion, COMP_HLEN,
+			     DMA_BIDIRECTIONAL);
+	ret = dma_mapping_error(dev, dma);
+	if (ret)
+		goto outmap_err;
+
+	buf->dma = dma;
+	buf->len = COMP_HLEN;
+	sr->out.total_bytes += COMP_HLEN;
+	sr->out.map_cnt++;
+
+	/* total out count: ORH + (req out cnt) + Completion bytes */
+	nr_comp = roundup(out->cnt + 2, 4) / 4;
+
+	ret = create_sg_component(sr, &sr->out, nr_comp);
+	if (ret)
+		goto outmap_err;
+	return 0;
+
+outmap_err:
+	dma_free_sglist(sr->ndev, &sr->out);
+	return ret;
+}
+
+static void soft_request_cleanup(struct nitrox_softreq *sr)
+{
+	dma_free_sglist(sr->ndev, &sr->in);
+	dma_free_sglist(sr->ndev, &sr->out);
+	kfree(sr);
+}
+
+/**
+ * post_se_instr - Post SE instruction to Packet Input ring
+ * @sr: Request structure
+ *
+ * Returns 0 if successful or a negative error code,
+ * if no space in ring.
+ */
+static inline int post_se_instr(struct nitrox_softreq *sr)
+{
+	struct nitrox_device *ndev = sr->ndev;
+	struct nitrox_cmdq *cmdq = sr->cmdq;
+	u8 *ent;
+	int index;
+
+	/* check for command queue space */
+	if (atomic_inc_return(&cmdq->pending_count) > ndev->qlen) {
+		atomic_dec(&cmdq->pending_count);
+		/* barrier to sync with other cpus */
+		smp_mb__after_atomic();
+		return -EBUSY;
+	}
+
+	spin_lock_bh(&cmdq->cmdq_lock);
+
+	index = cmdq->write_index;
+	ent = cmdq->head + (index * cmdq->instr_size);
+	memcpy(ent, &sr->instr, cmdq->instr_size);
+	/* get the timestamp */
+	sr->tstamp = jiffies;
+
+	/* add request to in progress list */
+	spin_lock_bh(&cmdq->pending_lock);
+	list_add_tail(&sr->in_progress, &cmdq->in_progress_head);
+	spin_unlock_bh(&cmdq->pending_lock);
+
+	/* Ring doorbell with count 1 */
+	writeq(1, cmdq->dbell_csr_addr);
+
+	cmdq->write_index++;
+	if (cmdq->write_index == ndev->qlen)
+		cmdq->write_index = 0;
+
+	spin_unlock_bh(&cmdq->cmdq_lock);
+	return 0;
+}
+
+static inline void add_to_backlog_list(struct nitrox_softreq *sr)
+{
+	struct nitrox_cmdq *cmdq = sr->cmdq;
+
+	INIT_LIST_HEAD(&sr->backlog);
+	spin_lock_bh(&cmdq->backlog_lock);
+	list_add_tail(&sr->backlog, &cmdq->backlog_head);
+	spin_unlock_bh(&cmdq->backlog_lock);
+}
+
+/**
+ * nitrox_se_request - Send request to SE core
+ * @ndev: NITROX device
+ * @req: Crypto request
+ *
+ * Returns 0 on success, or a negative error code.
+ */
+int nitrox_se_request(struct nitrox_device *ndev, struct crypto_request *req)
+{
+	struct nitrox_softreq *sr;
+	dma_addr_t ctx_handle = 0;
+	int qno, ret = 0;
+	gfp_t gfp;
+
+	if (!nitrox_ready(ndev))
+		return -ENODEV;
+
+	gfp = (req->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL : GFP_ATOMIC;
+	sr = kzalloc(sizeof(*sr), gfp);
+	if (!sr)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&sr->in_progress);
+	sr->ndev = ndev;
+
+	WRITE_ONCE(sr->resp.orh, PENDING_SIG);
+	WRITE_ONCE(sr->resp.completion, PENDING_SIG);
+
+	/* map input sg list */
+	ret = dma_map_inbufs(sr, req);
+	if (ret) {
+		kfree(sr);
+		return ret;
+	}
+
+	/* map output sg list */
+	ret = dma_map_outbufs(sr, req);
+	if (ret)
+		goto send_fail;
+
+	sr->callback = req->callback;
+	sr->cb_arg = req->cb_arg;
+
+	/* get the context handle */
+	if (req->ctx_handle) {
+		struct ctx_hdr *hdr;
+		u8 *ctx_ptr;
+
+		ctx_ptr = (u8 *)(uintptr_t)req->ctx_handle;
+		hdr = (struct ctx_hdr *)(ctx_ptr - sizeof(struct ctx_hdr));
+		ctx_handle = hdr->ctx_dma;
+	}
+
+	/* select the queue */
+	qno = smp_processor_id() % ndev->nr_queues;
+
+	/*
+	 * 64-Byte Instruction Format
+	 *
+	 *  ----------------------
+	 *  |      DPTR0         | 8 bytes
+	 *  ----------------------
+	 *  |  PKT_IN_INSTR_HDR  | 8 bytes
+	 *  ----------------------
+	 *  |    PKT_IN_HDR      | 16 bytes
+	 *  ----------------------
+	 *  |    SLC_INFO        | 16 bytes
+	 *  ----------------------
+	 *  |   Front data       | 16 bytes
+	 *  ----------------------
+	 */
+
+	/* fill the packet instruction */
+	/* word 0 */
+	sr->instr.dptr0 = cpu_to_be64(sr->in.dma);
+
+	/* word 1 */
+	sr->instr.ih.value = 0;
+	sr->instr.ih.s.g = (sr->in.nr_comp) ? 1 : 0;
+	sr->instr.ih.s.gsz = sr->in.map_cnt;
+	sr->instr.ih.s.ssz = sr->out.map_cnt;
+	sr->instr.ih.s.fsz = FDATA_SIZE + sizeof(struct gphdr);
+	sr->instr.ih.s.tlen = sr->instr.ih.s.fsz + sr->in.total_bytes;
+	sr->instr.ih.value = cpu_to_be64(sr->instr.ih.value);
+
+	/* word 2 */
+	sr->instr.irh.value[0] = 0;
+	sr->instr.irh.s.uddl = MIN_UDD_LEN;
+	/* context length in 64-bit words */
+	sr->instr.irh.s.ctxl = (req->ctrl.s.ctxl / 8);
+	/* offset from solicit base port 256 */
+	sr->instr.irh.s.destport = SOLICIT_BASE_DPORT + qno;
+	sr->instr.irh.s.ctxc = req->ctrl.s.ctxc;
+	sr->instr.irh.s.arg = req->ctrl.s.arg;
+	sr->instr.irh.s.opcode = req->opcode;
+	sr->instr.irh.value[0] = cpu_to_be64(sr->instr.irh.value[0]);
+
+	/* word 3 */
+	sr->instr.irh.s.ctxp = cpu_to_be64(ctx_handle);
+
+	/* word 4 */
+	sr->instr.slc.value[0] = 0;
+	sr->instr.slc.s.ssz = sr->out.map_cnt;
+	sr->instr.slc.value[0] = cpu_to_be64(sr->instr.slc.value[0]);
+
+	/* word 5 */
+	sr->instr.slc.s.rptr = cpu_to_be64(sr->out.dma);
+
+	/*
+	 * No conversion for front data,
+	 * It goes into payload
+	 * put GP Header in front data
+	 */
+	sr->instr.fdata[0] = *((u64 *)&req->gph);
+	sr->instr.fdata[1] = 0;
+
+	sr->cmdq = &ndev->pkt_cmdqs[qno];
+	/* post instruction to device */
+	ret = post_se_instr(sr);
+	if (ret) {
+		if (!(req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			goto send_fail;
+		add_to_backlog_list(sr);
+	}
+	return 0;
+
+send_fail:
+	soft_request_cleanup(sr);
+	return ret;
+}
+
+static inline int cmd_timeout(unsigned long tstamp, unsigned long timeout)
+{
+	return time_after_eq(jiffies, (tstamp + timeout));
+}
+
+/**
+ * process_request_list - process completed requests
+ * @ndev: N5 device
+ * @qno: queue to operate
+ *
+ * Returns the number of responses processed.
+ */
+static u32 process_request_list(struct nitrox_device *ndev, int qno)
+{
+	struct nitrox_cmdq *cmdq = &ndev->pkt_cmdqs[qno];
+	struct nitrox_softreq *sr, *tmp;
+	void (*callback)(int, void *);
+	void *cb_arg;
+	u64 status;
+	u32 req_completed = 0;
+
+	while (req_completed < DEFAULT_POLL_COUNT) {
+		sr = list_first_entry_or_null(&cmdq->in_progress_head,
+					      struct nitrox_softreq,
+					      in_progress);
+		if (!sr)
+			break;
+
+		/* check both orh and completion bytes */
+		if (READ_ONCE(sr->resp.orh) == READ_ONCE(sr->resp.completion)) {
+			/* request not completed, check for timeout */
+			if (!cmd_timeout(sr->tstamp, ndev->timeout))
+				break;
+			dev_err_ratelimited(DEV(ndev),
+					    "Request timeout, orh 0x%016llx\n",
+					    sr->resp.orh);
+		}
+		atomic_dec(&cmdq->pending_count);
+		/* barrier to sync with other cpus */
+		smp_mb__after_atomic();
+
+		/* remove completed request */
+		spin_lock_bh(&cmdq->pending_lock);
+		list_del(&sr->in_progress);
+		spin_unlock_bh(&cmdq->pending_lock);
+
+		dma_free_sglist(sr->ndev, &sr->in);
+		dma_free_sglist(sr->ndev, &sr->out);
+
+		/* ORH status code */
+		status = READ_ONCE(sr->resp.orh);
+
+		callback = sr->callback;
+		cb_arg = sr->cb_arg;
+		kfree(sr);
+
+		if (callback)
+			callback((u8)status, cb_arg);
+
+		req_completed++;
+	}
+
+	/* submit any backlog requests until space available */
+	spin_lock_bh(&cmdq->backlog_lock);
+	list_for_each_entry_safe(sr, tmp, &cmdq->backlog_head, backlog) {
+		if (post_se_instr(sr) == -EBUSY)
+			break;
+		list_del(&sr->backlog);
+	}
+	spin_unlock_bh(&cmdq->backlog_lock);
+
+	return req_completed;
+}
+
+/**
+ * pkt_slc_resp_handler - post processing of SE responses
+ */
+void pkt_slc_resp_handler(unsigned long data)
+{
+	struct bh_data *bh = (void *)(uintptr_t)(data);
+	union nps_pkt_slc_cnts pkt_slc_cnts;
+	u32 slc_cnt, req_completed;
+
+	req_completed = process_request_list(bh->ndev, bh->qno);
+	/* read completion count */
+	pkt_slc_cnts.value = readq(bh->completion_cnt_csr_addr);
+	/* resend the interrupt if more work to do */
+	pkt_slc_cnts.s.resend = 1;
+
+	slc_cnt = pkt_slc_cnts.s.cnt;
+	if (req_completed)
+		pkt_slc_cnts.s.cnt = min(slc_cnt, req_completed);
+
+	/*
+	 * clear the interrupt with resend bit enabled,
+	 * MSI-X interrupt generates if Completion count > Threshold
+	 */
+	writeq(pkt_slc_cnts.value, bh->completion_cnt_csr_addr);
+}
-- 
2.9.3
