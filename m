Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:51040
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbeLDM4A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 07:56:00 -0500
From: "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
Subject: [PATCH] crypto: cavium/nitrox - Enabled Mailbox support
Date: Tue, 4 Dec 2018 12:55:54 +0000
Message-ID: <20181204125521.4714-1-Jampala.Srikanth@cavium.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enabled the PF->VF Mailbox support. Mailbox message are interpreted
as {type, opcode, data}. Supported message types are REQ, ACK and NACK.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/Makefile         |   3 +-
 drivers/crypto/cavium/nitrox/nitrox_csr.h     |  12 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h |  22 ++
 drivers/crypto/cavium/nitrox/nitrox_dev.h     |  61 +++++-
 drivers/crypto/cavium/nitrox/nitrox_hal.c     | 114 +++++++---
 drivers/crypto/cavium/nitrox/nitrox_hal.h     |   2 +
 drivers/crypto/cavium/nitrox/nitrox_isr.c     |   8 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c    |   3 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c     | 204 ++++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_mbx.h     |   9 +
 drivers/crypto/cavium/nitrox/nitrox_sriov.c   |  57 ++++-
 11 files changed, 441 insertions(+), 54 deletions(-)
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_debugfs.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_mbx.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_mbx.h

diff --git a/drivers/crypto/cavium/nitrox/Makefile b/drivers/crypto/cavium/=
nitrox/Makefile
index e12954791673..ad0546630ad8 100644
--- a/drivers/crypto/cavium/nitrox/Makefile
+++ b/drivers/crypto/cavium/nitrox/Makefile
@@ -6,7 +6,8 @@ n5pf-objs :=3D nitrox_main.o \
 	nitrox_lib.o \
 	nitrox_hal.o \
 	nitrox_reqmgr.o \
-	nitrox_algs.o
+	nitrox_algs.o	\
+	nitrox_mbx.o
=20
 n5pf-$(CONFIG_PCI_IOV) +=3D nitrox_sriov.o
 n5pf-$(CONFIG_DEBUG_FS) +=3D nitrox_debugfs.o
diff --git a/drivers/crypto/cavium/nitrox/nitrox_csr.h b/drivers/crypto/cav=
ium/nitrox/nitrox_csr.h
index 1ad27b1a87c5..a2a452642b38 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_csr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_csr.h
@@ -54,7 +54,13 @@
 #define NPS_STATS_PKT_DMA_WR_CNT	0x1000190
=20
 /* NPS packet registers */
-#define NPS_PKT_INT				0x1040018
+#define NPS_PKT_INT			0x1040018
+#define NPS_PKT_MBOX_INT_LO		0x1040020
+#define NPS_PKT_MBOX_INT_LO_ENA_W1C	0x1040030
+#define NPS_PKT_MBOX_INT_LO_ENA_W1S	0x1040038
+#define NPS_PKT_MBOX_INT_HI		0x1040040
+#define NPS_PKT_MBOX_INT_HI_ENA_W1C	0x1040050
+#define NPS_PKT_MBOX_INT_HI_ENA_W1S	0x1040058
 #define NPS_PKT_IN_RERR_HI		0x1040108
 #define NPS_PKT_IN_RERR_HI_ENA_W1S	0x1040120
 #define NPS_PKT_IN_RERR_LO		0x1040128
@@ -74,6 +80,10 @@
 #define NPS_PKT_SLC_RERR_LO_ENA_W1S	0x1040240
 #define NPS_PKT_SLC_ERR_TYPE		0x1040248
 #define NPS_PKT_SLC_ERR_TYPE_ENA_W1S	0x1040260
+/* Mailbox PF->VF PF Accessible Data registers */
+#define NPS_PKT_MBOX_PF_VF_PFDATAX(_i)	(0x1040800 + ((_i) * 0x8))
+#define NPS_PKT_MBOX_VF_PF_PFDATAX(_i)	(0x1040C00 + ((_i) * 0x8))
+
 #define NPS_PKT_SLC_CTLX(_i)		(0x10000 + ((_i) * 0x40000))
 #define NPS_PKT_SLC_CNTSX(_i)		(0x10008 + ((_i) * 0x40000))
 #define NPS_PKT_SLC_INT_LEVELSX(_i)	(0x10010 + ((_i) * 0x40000))
diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h b/drivers/crypto=
/cavium/nitrox/nitrox_debugfs.h
new file mode 100644
index 000000000000..7b701ea6227a
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __NITROX_DEBUGFS_H
+#define __NITROX_DEBUGFS_H
+
+#include "nitrox_dev.h"
+
+#ifdef CONFIG_DEBUG_FS
+int nitrox_debugfs_init(struct nitrox_device *ndev);
+void nitrox_debugfs_exit(struct nitrox_device *ndev);
+#else
+static inline int nitrox_debugfs_init(struct nitrox_device *ndev)
+{
+	return 0;
+}
+
+static inline int nitrox_sriov_debugfs_init(struct nitrox_device *ndev)
+{
+	return 0;
+}
+#endif /* !CONFIG_DEBUG_FS */
+
+#endif /* __NITROX_DEBUGFS_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cav=
ium/nitrox/nitrox_dev.h
index 247df32f687c..0338877b828f 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -8,6 +8,8 @@
 #include <linux/if.h>
=20
 #define VERSION_LEN 32
+/* Maximum queues in PF mode */
+#define MAX_PF_QUEUES	64
=20
 /**
  * struct nitrox_cmdq - NITROX command queue
@@ -103,13 +105,58 @@ struct nitrox_q_vector {
 	};
 };
=20
+/**
+ * mbox_msg - Mailbox message data
+ * @type: message type
+ * @opcode: message opcode
+ * @data: message data
+ */
+union mbox_msg {
+	u64 value;
+	struct {
+		u64 type: 2;
+		u64 opcode: 6;
+		u64 data: 58;
+	};
+	struct {
+		u64 type: 2;
+		u64 opcode: 6;
+		u64 chipid: 8;
+		u64 vfid: 8;
+	} id;
+};
+
+/**
+ * nitrox_vfdev - NITROX VF device instance in PF
+ * @state: VF device state
+ * @vfno: VF number
+ * @nr_queues: number of queues enabled in VF
+ * @ring: ring to communicate with VF
+ * @msg: Mailbox message data from VF
+ * @mbx_resp: Mailbox counters
+ */
+struct nitrox_vfdev {
+	atomic_t state;
+	int vfno;
+	int nr_queues;
+	int ring;
+	union mbox_msg msg;
+	atomic64_t mbx_resp;
+};
+
 /**
  * struct nitrox_iov - SR-IOV information
  * @num_vfs: number of VF(s) enabled
- * @msix: MSI-X for PF in SR-IOV case
+ * @max_vf_queues: Maximum number of queues allowed for VF
+ * @vfdev: VF(s) devices
+ * @pf2vf_wq: workqueue for PF2VF communication
+ * @msix: MSI-X entry for PF in SR-IOV case
  */
 struct nitrox_iov {
 	int num_vfs;
+	int max_vf_queues;
+	struct nitrox_vfdev *vfdev;
+	struct workqueue_struct *pf2vf_wq;
 	struct msix_entry msix;
 };
=20
@@ -226,17 +273,9 @@ static inline bool nitrox_ready(struct nitrox_device *=
ndev)
 	return atomic_read(&ndev->state) =3D=3D __NDEV_READY;
 }
=20
-#ifdef CONFIG_DEBUG_FS
-int nitrox_debugfs_init(struct nitrox_device *ndev);
-void nitrox_debugfs_exit(struct nitrox_device *ndev);
-#else
-static inline int nitrox_debugfs_init(struct nitrox_device *ndev)
+static inline bool nitrox_vfdev_ready(struct nitrox_vfdev *vfdev)
 {
-	return 0;
+	return atomic_read(&vfdev->state) =3D=3D __NDEV_READY;
 }
=20
-static inline void nitrox_debugfs_exit(struct nitrox_device *ndev)
-{ }
-#endif
-
 #endif /* __NITROX_DEV_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cav=
ium/nitrox/nitrox_hal.c
index a9b82387cf53..c08d9f33a3b1 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -5,10 +5,11 @@
 #include "nitrox_csr.h"
=20
 #define PLL_REF_CLK 50
+#define MAX_CSR_RETRIES 10
=20
 /**
  * emu_enable_cores - Enable EMU cluster cores.
- * @ndev: N5 device
+ * @ndev: NITROX device
  */
 static void emu_enable_cores(struct nitrox_device *ndev)
 {
@@ -33,7 +34,7 @@ static void emu_enable_cores(struct nitrox_device *ndev)
=20
 /**
  * nitrox_config_emu_unit - configure EMU unit.
- * @ndev: N5 device
+ * @ndev: NITROX device
  */
 void nitrox_config_emu_unit(struct nitrox_device *ndev)
 {
@@ -63,29 +64,26 @@ void nitrox_config_emu_unit(struct nitrox_device *ndev)
 static void reset_pkt_input_ring(struct nitrox_device *ndev, int ring)
 {
 	union nps_pkt_in_instr_ctl pkt_in_ctl;
-	union nps_pkt_in_instr_baoff_dbell pkt_in_dbell;
 	union nps_pkt_in_done_cnts pkt_in_cnts;
+	int max_retries =3D MAX_CSR_RETRIES;
 	u64 offset;
=20
+	/* step 1: disable the ring, clear enable bit */
 	offset =3D NPS_PKT_IN_INSTR_CTLX(ring);
-	/* disable the ring */
 	pkt_in_ctl.value =3D nitrox_read_csr(ndev, offset);
 	pkt_in_ctl.s.enb =3D 0;
 	nitrox_write_csr(ndev, offset, pkt_in_ctl.value);
-	usleep_range(100, 150);
=20
-	/* wait to clear [ENB] */
+	/* step 2: wait to clear [ENB] */
+	usleep_range(100, 150);
 	do {
 		pkt_in_ctl.value =3D nitrox_read_csr(ndev, offset);
-	} while (pkt_in_ctl.s.enb);
-
-	/* clear off door bell counts */
-	offset =3D NPS_PKT_IN_INSTR_BAOFF_DBELLX(ring);
-	pkt_in_dbell.value =3D 0;
-	pkt_in_dbell.s.dbell =3D 0xffffffff;
-	nitrox_write_csr(ndev, offset, pkt_in_dbell.value);
+		if (!pkt_in_ctl.s.enb)
+			break;
+		udelay(50);
+	} while (max_retries--);
=20
-	/* clear done counts */
+	/* step 3: clear done counts */
 	offset =3D NPS_PKT_IN_DONE_CNTSX(ring);
 	pkt_in_cnts.value =3D nitrox_read_csr(ndev, offset);
 	nitrox_write_csr(ndev, offset, pkt_in_cnts.value);
@@ -95,6 +93,7 @@ static void reset_pkt_input_ring(struct nitrox_device *nd=
ev, int ring)
 void enable_pkt_input_ring(struct nitrox_device *ndev, int ring)
 {
 	union nps_pkt_in_instr_ctl pkt_in_ctl;
+	int max_retries =3D MAX_CSR_RETRIES;
 	u64 offset;
=20
 	/* 64-byte instruction size */
@@ -107,12 +106,15 @@ void enable_pkt_input_ring(struct nitrox_device *ndev=
, int ring)
 	/* wait for set [ENB] */
 	do {
 		pkt_in_ctl.value =3D nitrox_read_csr(ndev, offset);
-	} while (!pkt_in_ctl.s.enb);
+		if (pkt_in_ctl.s.enb)
+			break;
+		udelay(50);
+	} while (max_retries--);
 }
=20
 /**
  * nitrox_config_pkt_input_rings - configure Packet Input Rings
- * @ndev: N5 device
+ * @ndev: NITROX device
  */
 void nitrox_config_pkt_input_rings(struct nitrox_device *ndev)
 {
@@ -121,11 +123,14 @@ void nitrox_config_pkt_input_rings(struct nitrox_devi=
ce *ndev)
 	for (i =3D 0; i < ndev->nr_queues; i++) {
 		struct nitrox_cmdq *cmdq =3D &ndev->pkt_inq[i];
 		union nps_pkt_in_instr_rsize pkt_in_rsize;
+		union nps_pkt_in_instr_baoff_dbell pkt_in_dbell;
 		u64 offset;
=20
 		reset_pkt_input_ring(ndev, i);
=20
-		/* configure ring base address 16-byte aligned,
+		/**
+		 * step 4:
+		 * configure ring base address 16-byte aligned,
 		 * size and interrupt threshold.
 		 */
 		offset =3D NPS_PKT_IN_INSTR_BADDRX(i);
@@ -141,6 +146,13 @@ void nitrox_config_pkt_input_rings(struct nitrox_devic=
e *ndev)
 		offset =3D NPS_PKT_IN_INT_LEVELSX(i);
 		nitrox_write_csr(ndev, offset, 0xffffffff);
=20
+		/* step 5: clear off door bell counts */
+		offset =3D NPS_PKT_IN_INSTR_BAOFF_DBELLX(i);
+		pkt_in_dbell.value =3D 0;
+		pkt_in_dbell.s.dbell =3D 0xffffffff;
+		nitrox_write_csr(ndev, offset, pkt_in_dbell.value);
+
+		/* enable the ring */
 		enable_pkt_input_ring(ndev, i);
 	}
 }
@@ -149,21 +161,26 @@ static void reset_pkt_solicit_port(struct nitrox_devi=
ce *ndev, int port)
 {
 	union nps_pkt_slc_ctl pkt_slc_ctl;
 	union nps_pkt_slc_cnts pkt_slc_cnts;
+	int max_retries =3D MAX_CSR_RETRIES;
 	u64 offset;
=20
-	/* disable slc port */
+	/* step 1: disable slc port */
 	offset =3D NPS_PKT_SLC_CTLX(port);
 	pkt_slc_ctl.value =3D nitrox_read_csr(ndev, offset);
 	pkt_slc_ctl.s.enb =3D 0;
 	nitrox_write_csr(ndev, offset, pkt_slc_ctl.value);
-	usleep_range(100, 150);
=20
+	/* step 2 */
+	usleep_range(100, 150);
 	/* wait to clear [ENB] */
 	do {
 		pkt_slc_ctl.value =3D nitrox_read_csr(ndev, offset);
-	} while (pkt_slc_ctl.s.enb);
+		if (!pkt_slc_ctl.s.enb)
+			break;
+		udelay(50);
+	} while (max_retries--);
=20
-	/* clear slc counters */
+	/* step 3: clear slc counters */
 	offset =3D NPS_PKT_SLC_CNTSX(port);
 	pkt_slc_cnts.value =3D nitrox_read_csr(ndev, offset);
 	nitrox_write_csr(ndev, offset, pkt_slc_cnts.value);
@@ -173,12 +190,12 @@ static void reset_pkt_solicit_port(struct nitrox_devi=
ce *ndev, int port)
 void enable_pkt_solicit_port(struct nitrox_device *ndev, int port)
 {
 	union nps_pkt_slc_ctl pkt_slc_ctl;
+	int max_retries =3D MAX_CSR_RETRIES;
 	u64 offset;
=20
 	offset =3D NPS_PKT_SLC_CTLX(port);
 	pkt_slc_ctl.value =3D 0;
 	pkt_slc_ctl.s.enb =3D 1;
-
 	/*
 	 * 8 trailing 0x00 bytes will be added
 	 * to the end of the outgoing packet.
@@ -191,23 +208,27 @@ void enable_pkt_solicit_port(struct nitrox_device *nd=
ev, int port)
 	/* wait to set [ENB] */
 	do {
 		pkt_slc_ctl.value =3D nitrox_read_csr(ndev, offset);
-	} while (!pkt_slc_ctl.s.enb);
+		if (pkt_slc_ctl.s.enb)
+			break;
+		udelay(50);
+	} while (max_retries--);
 }
=20
-static void config_single_pkt_solicit_port(struct nitrox_device *ndev,
-					   int port)
+static void config_pkt_solicit_port(struct nitrox_device *ndev, int port)
 {
 	union nps_pkt_slc_int_levels pkt_slc_int;
 	u64 offset;
=20
 	reset_pkt_solicit_port(ndev, port);
=20
+	/* step 4: configure interrupt levels */
 	offset =3D NPS_PKT_SLC_INT_LEVELSX(port);
 	pkt_slc_int.value =3D 0;
 	/* time interrupt threshold */
 	pkt_slc_int.s.timet =3D 0x3fffff;
 	nitrox_write_csr(ndev, offset, pkt_slc_int.value);
=20
+	/* enable the solicit port */
 	enable_pkt_solicit_port(ndev, port);
 }
=20
@@ -216,12 +237,12 @@ void nitrox_config_pkt_solicit_ports(struct nitrox_de=
vice *ndev)
 	int i;
=20
 	for (i =3D 0; i < ndev->nr_queues; i++)
-		config_single_pkt_solicit_port(ndev, i);
+		config_pkt_solicit_port(ndev, i);
 }
=20
 /**
  * enable_nps_interrupts - enable NPS interrutps
- * @ndev: N5 device.
+ * @ndev: NITROX device.
  *
  * This includes NPS core, packet in and slc interrupts.
  */
@@ -284,8 +305,8 @@ void nitrox_config_pom_unit(struct nitrox_device *ndev)
 }
=20
 /**
- * nitrox_config_rand_unit - enable N5 random number unit
- * @ndev: N5 device
+ * nitrox_config_rand_unit - enable NITROX random number unit
+ * @ndev: NITROX device
  */
 void nitrox_config_rand_unit(struct nitrox_device *ndev)
 {
@@ -361,6 +382,7 @@ void invalidate_lbc(struct nitrox_device *ndev)
 {
 	union lbc_inval_ctl lbc_ctl;
 	union lbc_inval_status lbc_stat;
+	int max_retries =3D MAX_CSR_RETRIES;
 	u64 offset;
=20
 	/* invalidate LBC */
@@ -370,10 +392,12 @@ void invalidate_lbc(struct nitrox_device *ndev)
 	nitrox_write_csr(ndev, offset, lbc_ctl.value);
=20
 	offset =3D LBC_INVAL_STATUS;
-
 	do {
 		lbc_stat.value =3D nitrox_read_csr(ndev, offset);
-	} while (!lbc_stat.s.done);
+		if (lbc_stat.s.done)
+			break;
+		udelay(50);
+	} while (max_retries--);
 }
=20
 void nitrox_config_lbc_unit(struct nitrox_device *ndev)
@@ -467,3 +491,31 @@ void nitrox_get_hwinfo(struct nitrox_device *ndev)
 	/* copy partname */
 	strncpy(ndev->hw.partname, name, sizeof(ndev->hw.partname));
 }
+
+void enable_pf2vf_mbox_interrupts(struct nitrox_device *ndev)
+{
+	u64 value =3D ~0ULL;
+	u64 reg_addr;
+
+	/* Mailbox interrupt low enable set register */
+	reg_addr =3D NPS_PKT_MBOX_INT_LO_ENA_W1S;
+	nitrox_write_csr(ndev, reg_addr, value);
+
+	/* Mailbox interrupt high enable set register */
+	reg_addr =3D NPS_PKT_MBOX_INT_HI_ENA_W1S;
+	nitrox_write_csr(ndev, reg_addr, value);
+}
+
+void disable_pf2vf_mbox_interrupts(struct nitrox_device *ndev)
+{
+	u64 value =3D ~0ULL;
+	u64 reg_addr;
+
+	/* Mailbox interrupt low enable clear register */
+	reg_addr =3D NPS_PKT_MBOX_INT_LO_ENA_W1C;
+	nitrox_write_csr(ndev, reg_addr, value);
+
+	/* Mailbox interrupt high enable clear register */
+	reg_addr =3D NPS_PKT_MBOX_INT_HI_ENA_W1C;
+	nitrox_write_csr(ndev, reg_addr, value);
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.h b/drivers/crypto/cav=
ium/nitrox/nitrox_hal.h
index 489ee64c119e..d6606418ba38 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.h
@@ -19,5 +19,7 @@ void enable_pkt_input_ring(struct nitrox_device *ndev, in=
t ring);
 void enable_pkt_solicit_port(struct nitrox_device *ndev, int port);
 void config_nps_core_vfcfg_mode(struct nitrox_device *ndev, enum vf_mode m=
ode);
 void nitrox_get_hwinfo(struct nitrox_device *ndev);
+void enable_pf2vf_mbox_interrupts(struct nitrox_device *ndev);
+void disable_pf2vf_mbox_interrupts(struct nitrox_device *ndev);
=20
 #endif /* __NITROX_HAL_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cav=
ium/nitrox/nitrox_isr.c
index c5b797808680..3dec570a190a 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -7,6 +7,7 @@
 #include "nitrox_csr.h"
 #include "nitrox_common.h"
 #include "nitrox_hal.h"
+#include "nitrox_mbx.h"
=20
 /**
  * One vector for each type of ring
@@ -220,7 +221,8 @@ static void nps_core_int_tasklet(unsigned long data)
  */
 static irqreturn_t nps_core_int_isr(int irq, void *data)
 {
-	struct nitrox_device *ndev =3D data;
+	struct nitrox_q_vector *qvec =3D data;
+	struct nitrox_device *ndev =3D qvec->ndev;
 	union nps_core_int_active core_int;
=20
 	core_int.value =3D nitrox_read_csr(ndev, NPS_CORE_INT_ACTIVE);
@@ -246,6 +248,10 @@ static irqreturn_t nps_core_int_isr(int irq, void *dat=
a)
 	if (core_int.s.bmi)
 		clear_bmi_err_intr(ndev);
=20
+	/* Mailbox interrupt */
+	if (core_int.s.mbox)
+		nitrox_pf2vf_mbox_handler(ndev);
+
 	/* If more work callback the ISR, set resend */
 	core_int.s.resend =3D 1;
 	nitrox_write_csr(ndev, NPS_CORE_INT_ACTIVE, core_int.value);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/ca=
vium/nitrox/nitrox_main.c
index 6595c95af9f1..014e9863c20e 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -1,6 +1,5 @@
 #include <linux/aer.h>
 #include <linux/delay.h>
-#include <linux/debugfs.h>
 #include <linux/firmware.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -13,9 +12,9 @@
 #include "nitrox_csr.h"
 #include "nitrox_hal.h"
 #include "nitrox_isr.h"
+#include "nitrox_debugfs.h"
=20
 #define CNN55XX_DEV_ID	0x12
-#define MAX_PF_QUEUES	64
 #define UCODE_HLEN 48
 #define SE_GROUP 0
=20
diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cav=
ium/nitrox/nitrox_mbx.c
new file mode 100644
index 000000000000..02ee95064841
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/workqueue.h>
+
+#include "nitrox_csr.h"
+#include "nitrox_hal.h"
+#include "nitrox_dev.h"
+
+#define RING_TO_VFNO(_x, _y)	((_x) / (_y))
+
+/**
+ * mbx_msg_type - Mailbox message types
+ */
+enum mbx_msg_type {
+	MBX_MSG_TYPE_NOP,
+	MBX_MSG_TYPE_REQ,
+	MBX_MSG_TYPE_ACK,
+	MBX_MSG_TYPE_NACK,
+};
+
+/**
+ * mbx_msg_opcode - Mailbox message opcodes
+ */
+enum mbx_msg_opcode {
+	MSG_OP_VF_MODE =3D 1,
+	MSG_OP_VF_UP,
+	MSG_OP_VF_DOWN,
+	MSG_OP_CHIPID_VFID,
+};
+
+struct pf2vf_work {
+	struct nitrox_vfdev *vfdev;
+	struct nitrox_device *ndev;
+	struct work_struct pf2vf_resp;
+};
+
+static inline u64 pf2vf_read_mbox(struct nitrox_device *ndev, int ring)
+{
+	u64 reg_addr;
+
+	reg_addr =3D NPS_PKT_MBOX_VF_PF_PFDATAX(ring);
+	return nitrox_read_csr(ndev, reg_addr);
+}
+
+static inline void pf2vf_write_mbox(struct nitrox_device *ndev, u64 value,
+				    int ring)
+{
+	u64 reg_addr;
+
+	reg_addr =3D NPS_PKT_MBOX_PF_VF_PFDATAX(ring);
+	nitrox_write_csr(ndev, reg_addr, value);
+}
+
+static void pf2vf_send_response(struct nitrox_device *ndev,
+				struct nitrox_vfdev *vfdev)
+{
+	union mbox_msg msg;
+
+	msg.value =3D vfdev->msg.value;
+
+	switch (vfdev->msg.opcode) {
+	case MSG_OP_VF_MODE:
+		msg.data =3D ndev->mode;
+		break;
+	case MSG_OP_VF_UP:
+		vfdev->nr_queues =3D vfdev->msg.data;
+		atomic_set(&vfdev->state, __NDEV_READY);
+		break;
+	case MSG_OP_CHIPID_VFID:
+		msg.id.chipid =3D ndev->idx;
+		msg.id.vfid =3D vfdev->vfno;
+		break;
+	case MSG_OP_VF_DOWN:
+		vfdev->nr_queues =3D 0;
+		atomic_set(&vfdev->state, __NDEV_NOT_READY);
+		break;
+	default:
+		msg.type =3D MBX_MSG_TYPE_NOP;
+		break;
+	}
+
+	if (msg.type =3D=3D MBX_MSG_TYPE_NOP)
+		return;
+
+	/* send ACK to VF */
+	msg.type =3D MBX_MSG_TYPE_ACK;
+	pf2vf_write_mbox(ndev, msg.value, vfdev->ring);
+
+	vfdev->msg.value =3D 0;
+	atomic64_inc(&vfdev->mbx_resp);
+}
+
+static void pf2vf_resp_handler(struct work_struct *work)
+{
+	struct pf2vf_work *pf2vf_resp =3D container_of(work, struct pf2vf_work,
+						     pf2vf_resp);
+	struct nitrox_vfdev *vfdev =3D pf2vf_resp->vfdev;
+	struct nitrox_device *ndev =3D pf2vf_resp->ndev;
+
+	switch (vfdev->msg.type) {
+	case MBX_MSG_TYPE_REQ:
+		/* process the request from VF */
+		pf2vf_send_response(ndev, vfdev);
+		break;
+	case MBX_MSG_TYPE_ACK:
+	case MBX_MSG_TYPE_NACK:
+		break;
+	};
+
+	kfree(pf2vf_resp);
+}
+
+void nitrox_pf2vf_mbox_handler(struct nitrox_device *ndev)
+{
+	struct nitrox_vfdev *vfdev;
+	struct pf2vf_work *pfwork;
+	u64 value, reg_addr;
+	u32 i;
+	int vfno;
+
+	/* loop for VF(0..63) */
+	reg_addr =3D NPS_PKT_MBOX_INT_LO;
+	value =3D nitrox_read_csr(ndev, reg_addr);
+	for_each_set_bit(i, (const unsigned long *)&value, BITS_PER_LONG) {
+		/* get the vfno from ring */
+		vfno =3D RING_TO_VFNO(i, ndev->iov.max_vf_queues);
+		vfdev =3D ndev->iov.vfdev + vfno;
+		vfdev->ring =3D i;
+		/* fill the vf mailbox data */
+		vfdev->msg.value =3D pf2vf_read_mbox(ndev, vfdev->ring);
+		pfwork =3D kzalloc(sizeof(*pfwork), GFP_ATOMIC);
+		if (!pfwork)
+			continue;
+
+		pfwork->vfdev =3D vfdev;
+		pfwork->ndev =3D ndev;
+		INIT_WORK(&pfwork->pf2vf_resp, pf2vf_resp_handler);
+		queue_work(ndev->iov.pf2vf_wq, &pfwork->pf2vf_resp);
+		/* clear the corresponding vf bit */
+		nitrox_write_csr(ndev, reg_addr, BIT_ULL(i));
+	}
+
+	/* loop for VF(64..127) */
+	reg_addr =3D NPS_PKT_MBOX_INT_HI;
+	value =3D nitrox_read_csr(ndev, reg_addr);
+	for_each_set_bit(i, (const unsigned long *)&value, BITS_PER_LONG) {
+		/* get the vfno from ring */
+		vfno =3D RING_TO_VFNO(i + 64, ndev->iov.max_vf_queues);
+		vfdev =3D ndev->iov.vfdev + vfno;
+		vfdev->ring =3D (i + 64);
+		/* fill the vf mailbox data */
+		vfdev->msg.value =3D pf2vf_read_mbox(ndev, vfdev->ring);
+
+		pfwork =3D kzalloc(sizeof(*pfwork), GFP_ATOMIC);
+		if (!pfwork)
+			continue;
+
+		pfwork->vfdev =3D vfdev;
+		pfwork->ndev =3D ndev;
+		INIT_WORK(&pfwork->pf2vf_resp, pf2vf_resp_handler);
+		queue_work(ndev->iov.pf2vf_wq, &pfwork->pf2vf_resp);
+		/* clear the corresponding vf bit */
+		nitrox_write_csr(ndev, reg_addr, BIT_ULL(i));
+	}
+}
+
+int nitrox_mbox_init(struct nitrox_device *ndev)
+{
+	struct nitrox_vfdev *vfdev;
+	int i;
+
+	ndev->iov.vfdev =3D kcalloc(ndev->iov.num_vfs,
+				  sizeof(struct nitrox_vfdev), GFP_KERNEL);
+	if (!ndev->iov.vfdev)
+		return -ENOMEM;
+
+	for (i =3D 0; i < ndev->iov.num_vfs; i++) {
+		vfdev =3D ndev->iov.vfdev + i;
+		vfdev->vfno =3D i;
+	}
+
+	/* allocate pf2vf response workqueue */
+	ndev->iov.pf2vf_wq =3D alloc_workqueue("nitrox_pf2vf", 0, 0);
+	if (!ndev->iov.pf2vf_wq) {
+		kfree(ndev->iov.vfdev);
+		return -ENOMEM;
+	}
+	/* enable pf2vf mailbox interrupts */
+	enable_pf2vf_mbox_interrupts(ndev);
+
+	return 0;
+}
+
+void nitrox_mbox_cleanup(struct nitrox_device *ndev)
+{
+	/* disable pf2vf mailbox interrupts */
+	disable_pf2vf_mbox_interrupts(ndev);
+	/* destroy workqueue */
+	if (ndev->iov.pf2vf_wq)
+		destroy_workqueue(ndev->iov.pf2vf_wq);
+
+	kfree(ndev->iov.vfdev);
+	ndev->iov.pf2vf_wq =3D NULL;
+	ndev->iov.vfdev =3D NULL;
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.h b/drivers/crypto/cav=
ium/nitrox/nitrox_mbx.h
new file mode 100644
index 000000000000..5008399775a9
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __NITROX_MBX_H
+#define __NITROX_MBX_H
+
+int nitrox_mbox_init(struct nitrox_device *ndev);
+void nitrox_mbox_cleanup(struct nitrox_device *ndev);
+void nitrox_pf2vf_mbox_handler(struct nitrox_device *ndev);
+
+#endif /* __NITROX_MBX_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_sriov.c b/drivers/crypto/c=
avium/nitrox/nitrox_sriov.c
index 7ba0cc5d6d02..bf439d8256ba 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_sriov.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_sriov.c
@@ -6,6 +6,7 @@
 #include "nitrox_hal.h"
 #include "nitrox_common.h"
 #include "nitrox_isr.h"
+#include "nitrox_mbx.h"
=20
 /**
  * num_vfs_valid - validate VF count
@@ -52,6 +53,31 @@ static inline enum vf_mode num_vfs_to_mode(int num_vfs)
 	return mode;
 }
=20
+static inline int vf_mode_to_nr_queues(enum vf_mode mode)
+{
+	int nr_queues =3D 0;
+
+	switch (mode) {
+	case __NDEV_MODE_PF:
+		nr_queues =3D MAX_PF_QUEUES;
+		break;
+	case __NDEV_MODE_VF16:
+		nr_queues =3D 8;
+		break;
+	case __NDEV_MODE_VF32:
+		nr_queues =3D 4;
+		break;
+	case __NDEV_MODE_VF64:
+		nr_queues =3D 2;
+		break;
+	case __NDEV_MODE_VF128:
+		nr_queues =3D 1;
+		break;
+	}
+
+	return nr_queues;
+}
+
 static void nitrox_pf_cleanup(struct nitrox_device *ndev)
 {
 	 /* PF has no queues in SR-IOV mode */
@@ -94,16 +120,31 @@ static int nitrox_pf_reinit(struct nitrox_device *ndev=
)
 	return nitrox_crypto_register();
 }
=20
-static int nitrox_sriov_init(struct nitrox_device *ndev)
-{
-	/* register interrupts for PF in SR-IOV */
-	return nitrox_sriov_register_interupts(ndev);
-}
-
 static void nitrox_sriov_cleanup(struct nitrox_device *ndev)
 {
 	/* unregister interrupts for PF in SR-IOV */
 	nitrox_sriov_unregister_interrupts(ndev);
+	nitrox_mbox_cleanup(ndev);
+}
+
+static int nitrox_sriov_init(struct nitrox_device *ndev)
+{
+	int ret;
+
+	/* register interrupts for PF in SR-IOV */
+	ret =3D nitrox_sriov_register_interupts(ndev);
+	if (ret)
+		return ret;
+
+	ret =3D nitrox_mbox_init(ndev);
+	if (ret)
+		goto sriov_init_fail;
+
+	return 0;
+
+sriov_init_fail:
+	nitrox_sriov_cleanup(ndev);
+	return ret;
 }
=20
 static int nitrox_sriov_enable(struct pci_dev *pdev, int num_vfs)
@@ -126,8 +167,9 @@ static int nitrox_sriov_enable(struct pci_dev *pdev, in=
t num_vfs)
 	}
 	dev_info(DEV(ndev), "Enabled VF(s) %d\n", num_vfs);
=20
-	ndev->iov.num_vfs =3D num_vfs;
 	ndev->mode =3D num_vfs_to_mode(num_vfs);
+	ndev->iov.num_vfs =3D num_vfs;
+	ndev->iov.max_vf_queues =3D vf_mode_to_nr_queues(ndev->mode);
 	/* set bit in flags */
 	set_bit(__NDEV_SRIOV_BIT, &ndev->flags);
=20
@@ -169,6 +211,7 @@ static int nitrox_sriov_disable(struct pci_dev *pdev)
 	clear_bit(__NDEV_SRIOV_BIT, &ndev->flags);
=20
 	ndev->iov.num_vfs =3D 0;
+	ndev->iov.max_vf_queues =3D 0;
 	ndev->mode =3D __NDEV_MODE_PF;
=20
 	/* cleanup PF SR-IOV resources */
--=20
2.19.1
