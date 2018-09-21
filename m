From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 1/3] crypto: cavium/nitrox - added support to identify the NITROX device partname.
Date: Fri, 21 Sep 2018 17:08:00 +0530
Message-ID: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Get the device partname based on it's capabilities like,
core frequency, number of cores and revision id.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_csr.h  | 111 +++++++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_dev.h  |  17 +++-
 drivers/crypto/cavium/nitrox/nitrox_hal.c  |  57 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_hal.h  |   1 +
 drivers/crypto/cavium/nitrox/nitrox_main.c |  20 ----
 5 files changed, 184 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_csr.h b/drivers/crypto/cavium/nitrox/nitrox_csr.h
index 9dcb7fdbe0a7..1ad27b1a87c5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_csr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_csr.h
@@ -7,9 +7,16 @@
 
 /* EMU clusters */
 #define NR_CLUSTERS		4
+/* Maximum cores per cluster,
+ * varies based on partname
+ */
 #define AE_CORES_PER_CLUSTER	20
 #define SE_CORES_PER_CLUSTER	16
 
+#define AE_MAX_CORES	(AE_CORES_PER_CLUSTER * NR_CLUSTERS)
+#define SE_MAX_CORES	(SE_CORES_PER_CLUSTER * NR_CLUSTERS)
+#define ZIP_MAX_CORES	5
+
 /* BIST registers */
 #define EMU_BIST_STATUSX(_i)	(0x1402700 + ((_i) * 0x40000))
 #define UCD_BIST_STATUS		0x12C0070
@@ -111,6 +118,9 @@
 #define LBC_ELM_VF65_128_INT		0x120C000
 #define LBC_ELM_VF65_128_INT_ENA_W1S	0x120F000
 
+#define RST_BOOT	0x10C1600
+#define FUS_DAT1	0x10C1408
+
 /* PEM registers */
 #define PEM0_INT 0x1080428
 
@@ -1082,4 +1092,105 @@ union lbc_inval_status {
 	} s;
 };
 
+/**
+ * struct rst_boot: RST Boot Register
+ * @jtcsrdis: when set, internal CSR access via JTAG TAP controller
+ *   is disabled
+ * @jt_tst_mode: JTAG test mode
+ * @io_supply: I/O power supply setting based on IO_VDD_SELECT pin:
+ *    0x1 = 1.8V
+ *    0x2 = 2.5V
+ *    0x4 = 3.3V
+ *    All other values are reserved
+ * @pnr_mul: clock multiplier
+ * @lboot: last boot cause mask, resets only with PLL_DC_OK
+ * @rboot: determines whether core 0 remains in reset after
+ *    chip cold or warm or soft reset
+ * @rboot_pin: read only access to REMOTE_BOOT pin
+ */
+union rst_boot {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_63 : 1;
+		u64 jtcsrdis : 1;
+		u64 raz_59_61 : 3;
+		u64 jt_tst_mode : 1;
+		u64 raz_40_57 : 18;
+		u64 io_supply : 3;
+		u64 raz_30_36 : 7;
+		u64 pnr_mul : 6;
+		u64 raz_12_23 : 12;
+		u64 lboot : 10;
+		u64 rboot : 1;
+		u64 rboot_pin : 1;
+#else
+		u64 rboot_pin : 1;
+		u64 rboot : 1;
+		u64 lboot : 10;
+		u64 raz_12_23 : 12;
+		u64 pnr_mul : 6;
+		u64 raz_30_36 : 7;
+		u64 io_supply : 3;
+		u64 raz_40_57 : 18;
+		u64 jt_tst_mode : 1;
+		u64 raz_59_61 : 3;
+		u64 jtcsrdis : 1;
+		u64 raz_63 : 1;
+#endif
+	};
+};
+
+/**
+ * struct fus_dat1: Fuse Data 1 Register
+ * @pll_mul: main clock PLL multiplier hardware limit
+ * @pll_half_dis: main clock PLL control
+ * @efus_lck: efuse lockdown
+ * @zip_info: ZIP information
+ * @bar2_sz_conf: when zero, BAR2 size conforms to
+ *    PCIe specification
+ * @efus_ign: efuse ignore
+ * @nozip: ZIP disable
+ * @pll_alt_matrix: select alternate PLL matrix
+ * @pll_bwadj_denom: select CLKF denominator for
+ *    BWADJ value
+ * @chip_id: chip ID
+ */
+union fus_dat1 {
+	u64 value;
+	struct {
+#if (defined(__BIG_ENDIAN_BITFIELD))
+		u64 raz_57_63 : 7;
+		u64 pll_mul : 3;
+		u64 pll_half_dis : 1;
+		u64 raz_43_52 : 10;
+		u64 efus_lck : 3;
+		u64 raz_26_39 : 14;
+		u64 zip_info : 5;
+		u64 bar2_sz_conf : 1;
+		u64 efus_ign : 1;
+		u64 nozip : 1;
+		u64 raz_11_17 : 7;
+		u64 pll_alt_matrix : 1;
+		u64 pll_bwadj_denom : 2;
+		u64 chip_id : 8;
+#else
+		u64 chip_id : 8;
+		u64 pll_bwadj_denom : 2;
+		u64 pll_alt_matrix : 1;
+		u64 raz_11_17 : 7;
+		u64 nozip : 1;
+		u64 efus_ign : 1;
+		u64 bar2_sz_conf : 1;
+		u64 zip_info : 5;
+		u64 raz_26_39 : 14;
+		u64 efus_lck : 3;
+		u64 raz_43_52 : 10;
+		u64 pll_half_dis : 1;
+		u64 pll_mul : 3;
+		u64 raz_57_63 : 7;
+#endif
+	};
+};
+
 #endif /* __NITROX_CSR_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index 4f560cedd0aa..1059495ee541 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -5,6 +5,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/if.h>
 
 #define VERSION_LEN 32
 
@@ -48,15 +49,27 @@ struct nitrox_cmdq {
 	dma_addr_t dma;
 };
 
+/**
+ * struct nitrox_hw - NITROX hardware information
+ * @partname: partname ex: CNN55xxx-xxx
+ * @fw_name: firmware version
+ * @freq: NITROX frequency
+ * @vendor_id: vendor ID
+ * @device_id: device ID
+ * @revision_id: revision ID
+ * @se_cores: number of symmetric cores
+ * @ae_cores: number of asymmetric cores
+ * @zip_cores: number of zip cores
+ */
 struct nitrox_hw {
-	/* firmware version */
+	char partname[IFNAMSIZ * 2];
 	char fw_name[VERSION_LEN];
 
+	int freq;
 	u16 vendor_id;
 	u16 device_id;
 	u8 revision_id;
 
-	/* CNN55XX cores */
 	u8 se_cores;
 	u8 ae_cores;
 	u8 zip_cores;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index 2b256ba36dff..4627a1976176 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -4,6 +4,8 @@
 #include "nitrox_dev.h"
 #include "nitrox_csr.h"
 
+#define PLL_REF_CLK 50
+
 /**
  * emu_enable_cores - Enable EMU cluster cores.
  * @ndev: N5 device
@@ -410,3 +412,58 @@ void config_nps_core_vfcfg_mode(struct nitrox_device *ndev, enum vf_mode mode)
 
 	nitrox_write_csr(ndev, NPS_CORE_GBL_VFCFG, vfcfg.value);
 }
+
+void nitrox_get_hwinfo(struct nitrox_device *ndev)
+{
+	union emu_fuse_map emu_fuse;
+	union rst_boot rst_boot;
+	union fus_dat1 fus_dat1;
+	unsigned char name[IFNAMSIZ * 2] = {};
+	int i, dead_cores;
+	u64 offset;
+
+	/* get core frequency */
+	offset = RST_BOOT;
+	rst_boot.value = nitrox_read_csr(ndev, offset);
+	ndev->hw.freq = (rst_boot.pnr_mul + 3) * PLL_REF_CLK;
+
+	for (i = 0; i < NR_CLUSTERS; i++) {
+		offset = EMU_FUSE_MAPX(i);
+		emu_fuse.value = nitrox_read_csr(ndev, offset);
+		if (emu_fuse.s.valid) {
+			dead_cores = hweight32(emu_fuse.s.ae_fuse);
+			ndev->hw.ae_cores += AE_CORES_PER_CLUSTER - dead_cores;
+			dead_cores = hweight16(emu_fuse.s.se_fuse);
+			ndev->hw.se_cores += SE_CORES_PER_CLUSTER - dead_cores;
+		}
+	}
+	/* find zip hardware availability */
+	offset = FUS_DAT1;
+	fus_dat1.value = nitrox_read_csr(ndev, offset);
+	if (!fus_dat1.nozip) {
+		dead_cores = hweight8(fus_dat1.zip_info);
+		ndev->hw.zip_cores = ZIP_MAX_CORES - dead_cores;
+	}
+
+	/* determine the partname CNN55<cores>-<freq><pincount>-<rev>*/
+	if (ndev->hw.ae_cores == AE_MAX_CORES) {
+		switch (ndev->hw.se_cores) {
+		case SE_MAX_CORES:
+			i = snprintf(name, sizeof(name), "CNN5560");
+			break;
+		case 40:
+			i = snprintf(name, sizeof(name), "CNN5560s");
+			break;
+		}
+	} else if (ndev->hw.ae_cores == (AE_MAX_CORES / 2)) {
+		i = snprintf(name, sizeof(name), "CNN5530");
+	} else {
+		i = snprintf(name, sizeof(name), "CNN5560i");
+	}
+
+	snprintf(name + i, sizeof(name) - i, "-%3dBG676-1.%u",
+		 ndev->hw.freq, ndev->hw.revision_id);
+
+	/* copy partname */
+	strncpy(ndev->hw.partname, name, sizeof(ndev->hw.partname));
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.h b/drivers/crypto/cavium/nitrox/nitrox_hal.h
index 3baef865b17c..489ee64c119e 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.h
@@ -18,5 +18,6 @@ void invalidate_lbc(struct nitrox_device *ndev);
 void enable_pkt_input_ring(struct nitrox_device *ndev, int ring);
 void enable_pkt_solicit_port(struct nitrox_device *ndev, int port);
 void config_nps_core_vfcfg_mode(struct nitrox_device *ndev, enum vf_mode mode);
+void nitrox_get_hwinfo(struct nitrox_device *ndev);
 
 #endif /* __NITROX_HAL_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 6d7a421bddb8..acce0f0b9c7a 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -291,26 +291,6 @@ static int nitrox_bist_check(struct nitrox_device *ndev)
 	return 0;
 }
 
-static void nitrox_get_hwinfo(struct nitrox_device *ndev)
-{
-	union emu_fuse_map emu_fuse;
-	u64 offset;
-	int i;
-
-	for (i = 0; i < NR_CLUSTERS; i++) {
-		u8 dead_cores;
-
-		offset = EMU_FUSE_MAPX(i);
-		emu_fuse.value = nitrox_read_csr(ndev, offset);
-		if (emu_fuse.s.valid) {
-			dead_cores = hweight32(emu_fuse.s.ae_fuse);
-			ndev->hw.ae_cores += AE_CORES_PER_CLUSTER - dead_cores;
-			dead_cores = hweight16(emu_fuse.s.se_fuse);
-			ndev->hw.se_cores += SE_CORES_PER_CLUSTER - dead_cores;
-		}
-	}
-}
-
 static int nitrox_pf_hw_init(struct nitrox_device *ndev)
 {
 	int err;
-- 
2.17.1
