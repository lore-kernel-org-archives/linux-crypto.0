From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH 4/5] crypto/nx: Add P9 NX support for 842 compression
 engine.
Date: Sat, 01 Apr 2017 10:01:47 -0700
Message-ID: <1491066107.29552.29.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        benh@kernel.crashing.org, mikey@neuling.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, mpe@ellerman.id.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751752AbdDARB4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 13:01:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v31Gwk8L013520
        for <linux-crypto@vger.kernel.org>; Sat, 1 Apr 2017 13:01:56 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29jaa05de6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sat, 01 Apr 2017 13:01:55 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Sat, 1 Apr 2017 11:01:55 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH 4/5] crypto/nx: Add P9 NX support for 842 compression engine.

This patch adds P9 NX support for 842 compression engine. Virtual
Accelerator Switchboard (VAS) is used to access 842 engine on P9.

For each NX engine per chip, setup receive window using
vas_rx_win_open() which configures RxFIFo with FIFO address, lpid,
pid and tid values. This unique (lpid, pid, tid) combination will
be used to identify the target engine. Then open send window with
vas_tx_win_open() which is used to send NX requests to VAS. NX 
provides high and normal priority FIFOs. For compression /
decompression requests, we use only hight priority FIFOs in kernel.

Each NX request will be communicated to VAS using copy/paste
instructions with vas_copy_crb() / vas_paste_crb() functions.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 arch/powerpc/include/asm/vas.h     |   2 +
 drivers/crypto/nx/Kconfig          |   1 +
 drivers/crypto/nx/nx-842-powernv.c | 315 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 313 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index 4e5a470..7315621 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -19,6 +19,8 @@
 #define VAS_RX_FIFO_SIZE_MIN	(1 << 10)	/* 1KB */
 #define VAS_RX_FIFO_SIZE_MAX	(8 << 20)	/* 8MB */
 
+#define is_vas_available()	(cpu_has_feature(CPU_FTR_ARCH_300))
+
 /*
  * Co-processor Engine type.
  */
diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index ad7552a..4ad7fdb 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -38,6 +38,7 @@ config CRYPTO_DEV_NX_COMPRESS_PSERIES
 config CRYPTO_DEV_NX_COMPRESS_POWERNV
 	tristate "Compression acceleration support on PowerNV platform"
 	depends on PPC_POWERNV
+	select VAS
 	default y
 	help
 	  Support for PowerPC Nest (NX) compression acceleration. This
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 8737e90..66efd39 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -23,6 +23,7 @@
 #include <asm/prom.h>
 #include <asm/icswx.h>
 #include <asm/vas.h>
+#include <asm/reg.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
@@ -52,10 +53,20 @@ struct nx842_coproc {
 			unsigned int ct;
 			unsigned int ci;
 		} icswx;
+		struct {
+			struct vas_window *txwin;
+			struct vas_window *rxwin;
+		} vas;
 	};
 	struct list_head list;
 };
 
+/*
+ * Send the request to NX engine on the chip for the corresponding CPU
+ * where the process is executing. Use with VAS function.
+ */
+static DEFINE_PER_CPU(struct vas_window *, nx842_txwin);
+
 /* no cpu hotplug on powernv, so this list never changes after init */
 static LIST_HEAD(nx842_coprocs);
 static unsigned int nx842_ct;	/* use with icswx function */
@@ -499,6 +510,103 @@ static int nx842_icswx_function(const unsigned char *in, unsigned int inlen,
 }
 
 /**
+ * nx842_vas_function - compress/decompress data using the 842 algorithm
+ *
+ * (De)compression provided by the NX842 coprocessor on IBM PowerNV systems.
+ * This compresses or decompresses the provided input buffer into the provided
+ * output buffer.
+ *
+ * Upon return from this function @outlen contains the length of the
+ * output data.  If there is an error then @outlen will be 0 and an
+ * error will be specified by the return code from this function.
+ *
+ * The @workmem buffer should only be used by one function call at a time.
+ *
+ * @in: input buffer pointer
+ * @inlen: input buffer size
+ * @out: output buffer pointer
+ * @outlenp: output buffer size pointer
+ * @workmem: working memory buffer pointer, size determined by
+ *           nx842_powernv_driver.workmem_size
+ * @fc: function code, see CCW Function Codes in nx-842.h
+ *
+ * Returns:
+ *   0		Success, output of length @outlenp stored in the buffer
+ *		at @out
+ *   -ENODEV	Hardware unavailable
+ *   -ENOSPC	Output buffer is to small
+ *   -EMSGSIZE	Input buffer too large
+ *   -EINVAL	buffer constraints do not fix nx842_constraints
+ *   -EPROTO	hardware error during operation
+ *   -ETIMEDOUT	hardware did not complete operation in reasonable time
+ *   -EINTR	operation was aborted
+ */
+static int nx842_vas_function(const unsigned char *in, unsigned int inlen,
+				  unsigned char *out, unsigned int *outlenp,
+				  void *workmem, int fc)
+{
+	struct coprocessor_request_block *crb;
+	struct coprocessor_status_block *csb;
+	struct nx842_workmem *wmem;
+	struct vas_window *txwin;
+	int ret;
+	u32 ccw;
+	unsigned int outlen = *outlenp;
+
+	wmem = PTR_ALIGN(workmem, WORKMEM_ALIGN);
+
+	*outlenp = 0;
+
+	crb = &wmem->crb;
+	csb = &crb->csb;
+
+	ret = nx842_cfg_crb(in, inlen, out, outlen, wmem);
+	if (ret)
+		return ret;
+
+	ccw = 0;
+	ccw = SET_FIELD(CCW_FC_842, ccw, fc);
+	crb->ccw = cpu_to_be32(ccw);
+
+	/*
+	 * Send request to the NX engine on the chip that corresponds to
+	 * the current CPU.
+	 */
+	txwin = per_cpu(nx842_txwin, smp_processor_id());
+	/* shoudn't happen, we don't load without a coproc */
+	if (!txwin) {
+		pr_err_ratelimited("NX-842 coprocessor is not available");
+		return -ENODEV;
+	}
+
+	wmem->start = ktime_get();
+
+	/*
+	 * VAS copy CRB into L2 cache. Refer <asm/vas.h>.
+	 * @crb, @offset and @first (must be true)
+	 */
+	vas_copy_crb(crb, 0, 1);
+
+	/*
+	 * VAS paste previously copied CRB to NX.
+	 * @txwin, @offset, @last (must be true) and @re is expected/assumed
+	 * to be true for NX windows.
+	 */
+	ret = vas_paste_crb(txwin, 0, 1, 1);
+
+	if (ret) {
+		pr_err_ratelimited("NX-842: VAS copy/paste failed\n");
+		return ret;
+	}
+
+	ret = wait_for_csb(wmem, csb);
+	if (!ret)
+		*outlenp = be32_to_cpu(csb->count);
+
+	return ret;
+}
+
+/**
  * nx842_powernv_compress - Compress data using the 842 algorithm
  *
  * Compression provided by the NX842 coprocessor on IBM PowerNV systems.
@@ -554,6 +662,164 @@ static int nx842_powernv_decompress(const unsigned char *in, unsigned int inlen,
 				      wmem, CCW_FC_842_DECOMP_CRC);
 }
 
+
+static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
+					int vasid, int ct)
+{
+	struct vas_window *rxwin, *txwin = NULL;
+	struct vas_rx_win_attr rxattr;
+	struct vas_tx_win_attr txattr;
+	struct nx842_coproc *coproc;
+	u32 lpid, pid, tid;
+	u64 rx_fifo;
+	int ret;
+#define RX_FIFO_SIZE 0x8000
+
+	if (of_property_read_u64(dn, "rx-fifo-address", (void *)&rx_fifo)) {
+		pr_err("ibm,nx-842: Missing rx-fifo-address property\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(dn, "lpid", &lpid)) {
+		pr_err("ibm,nx-842: Missing lpid property\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(dn, "pid", &pid)) {
+		pr_err("ibm,nx-842: Missing pid property\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(dn, "tid", &tid)) {
+		pr_err("ibm,nx-842: Missing tid property\n");
+		return -EINVAL;
+	}
+
+	vas_init_rx_win_attr(&rxattr, ct);
+	rxattr.rx_fifo = (void *)rx_fifo;
+	rxattr.rx_fifo_size = RX_FIFO_SIZE;
+	rxattr.lnotify_lpid = lpid;
+	rxattr.lnotify_pid = pid;
+	rxattr.lnotify_tid = tid;
+	rxattr.wcreds_max = 64;
+
+	/*
+	 * Open a VAS receice window which is used to configure RxFIFO
+	 * for NX.
+	 */
+	rxwin = vas_rx_win_open(vasid, ct, &rxattr);
+	if (IS_ERR(rxwin)) {
+		pr_err("ibm,nx-842: setting RxFIFO with VAS failed: %ld\n",
+			PTR_ERR(rxwin));
+		return PTR_ERR(rxwin);
+	}
+
+	/*
+	 * Kernel requests will be high priority. So open send
+	 * windows only for high priority RxFIFO entries.
+	 */
+	if (ct == VAS_COP_TYPE_842_HIPRI) {
+		vas_init_tx_win_attr(&txattr, ct);
+		txattr.lpid = 0;	/* lpid is 0 for kernel requests */
+		txattr.pid = mfspr(SPRN_PID);
+
+		/*
+		 * Open a VAS send window which is used to send request to NX.
+		 */
+		txwin = vas_tx_win_open(vasid, ct, &txattr);
+		if (IS_ERR(txwin)) {
+			pr_err("ibm,nx-842: Can not open TX window: %ld\n",
+				PTR_ERR(txwin));
+			ret = PTR_ERR(txwin);
+			goto err_out;
+		}
+	}
+
+	coproc = kmalloc(sizeof(*coproc), GFP_KERNEL);
+	if (!coproc) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	coproc->chip_id = chip_id;
+	coproc->vas.rxwin = rxwin;
+	coproc->vas.txwin = txwin;
+
+	INIT_LIST_HEAD(&coproc->list);
+	list_add(&coproc->list, &nx842_coprocs);
+
+	return 0;
+
+err_out:
+	if (txwin)
+		vas_win_close(txwin);
+
+	vas_win_close(rxwin);
+
+	return ret;
+}
+
+
+static int __init nx842_powernv_probe_vas(struct device_node *dn)
+{
+	struct device_node *nxdn, *np;
+	int chip_id, vasid, rc;
+
+	chip_id = of_get_ibm_chip_id(dn);
+	if (chip_id < 0) {
+		pr_err("ibm,chip-id missing\n");
+		return -EINVAL;
+	}
+
+	np = of_find_node_by_name(dn, "vas");
+	if (!np) {
+		pr_err("ibm,xscom: Missing VAS device node\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32(np, "vas-id", &vasid)) {
+		pr_err("ibm,vas: Missing vas-id device property\n");
+		of_node_put(np);
+		return -EINVAL;
+	}
+
+	of_node_put(np);
+
+	nxdn = of_find_compatible_node(dn, NULL, "ibm,power-nx");
+	if (!nxdn) {
+		pr_err("ibm,xscom: Missing NX device node\n");
+		return -EINVAL;
+	}
+
+	np = of_find_node_by_name(nxdn, "ibm,nx-842-high");
+	if (!np) {
+		pr_err("ibm,nx-842-high device node is missing\n");
+		rc = -EINVAL;
+		goto out_nd_put;
+	}
+
+	rc = vas_cfg_coproc_info(np, chip_id, vasid, VAS_COP_TYPE_842_HIPRI);
+	of_node_put(np);
+	if (rc)
+		goto out_nd_put;
+
+	np = of_find_node_by_name(nxdn, "ibm,nx-842-normal");
+	if (!np) {
+		pr_err("ibm,nx-842-normal device node is missing\n");
+		rc = -EINVAL;
+		goto out_nd_put;
+	}
+
+	rc = vas_cfg_coproc_info(np, chip_id, vasid, VAS_COP_TYPE_842);
+	of_node_put(np);
+	if (!rc)
+		return 0;
+
+out_nd_put:
+	of_node_put(nxdn);
+	return rc;
+}
+
 static int __init nx842_powernv_probe(struct device_node *dn)
 {
 	struct nx842_coproc *coproc;
@@ -602,11 +868,42 @@ static void nx842_delete_coproc(void)
 	struct nx842_coproc *coproc, *n;
 
 	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
+		if (is_vas_available()) {
+			vas_win_close(coproc->vas.rxwin);
+			/*
+			 * txwin opened only for high priority RxFIFOs
+			 */
+			if (coproc->vas.txwin)
+				vas_win_close(coproc->vas.txwin);
+		}
 		list_del(&coproc->list);
 		kfree(coproc);
 	}
 }
 
+/*
+ * Identify chip ID for each CPU and save send window address in percpu
+ * nx842_txwin for the corresponding NX engine.
+ * nx842_txwin is used later to send the NX request with the txwin for
+ * the CPU where the request is running.
+ */
+static void nx842_set_per_cpu_txwin(void)
+{
+	unsigned int i, chip_id;
+	struct nx842_coproc *coproc, *n;
+
+	for_each_possible_cpu(i) {
+		chip_id = cpu_to_chip_id(i);
+		list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
+			if ((coproc->chip_id == chip_id) &&
+				coproc->vas.txwin) {
+				per_cpu(nx842_txwin, i) = coproc->vas.txwin;
+				break;
+			}
+		}
+	}
+}
+
 static struct nx842_constraints nx842_powernv_constraints = {
 	.alignment =	DDE_BUFFER_ALIGN,
 	.multiple =	DDE_BUFFER_LAST_MULT,
@@ -656,13 +953,21 @@ static __init int nx842_powernv_init(void)
 	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
 	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
 
-	for_each_compatible_node(dn, NULL, "ibm,power-nx")
-		nx842_powernv_probe(dn);
+	if (is_vas_available()) {
+		for_each_compatible_node(dn, NULL, "ibm,xscom")
+			nx842_powernv_probe_vas(dn);
 
-	if (!nx842_ct)
-		return -ENODEV;
+		nx842_set_per_cpu_txwin();
+		nx842_powernv_function = nx842_vas_function;
+	} else {
+		for_each_compatible_node(dn, NULL, "ibm,power-nx")
+			nx842_powernv_probe(dn);
 
-	nx842_powernv_function = nx842_icswx_function;
+		nx842_powernv_function = nx842_icswx_function;
+	}
+
+	if (list_empty(&nx842_coprocs))
+		return -ENODEV;
 
 	ret = crypto_register_alg(&nx842_powernv_alg);
 	if (ret) {
-- 
1.8.3.1
