From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH 1/2] crypto/nx: Use percpu send window for NX requests
Date: Sun, 24 Sep 2017 23:43:02 -0700
Message-ID: <1506321782.13257.4.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, mpe@ellerman.id.au, ddstreet@ieee.org,
        mikey@neuling.org, suka@us.ibm.com, npiggin@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932230AbdIYGnW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 02:43:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8P6d9Jt028743
        for <linux-crypto@vger.kernel.org>; Mon, 25 Sep 2017 02:43:21 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2d6txw5jn0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 25 Sep 2017 02:43:21 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Mon, 25 Sep 2017 00:43:20 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH 1/2] crypto/nx: Use percpu send window for NX requests

For P9 NX, the send window is opened for each crypto session and closed
upon free. But VAS supports 64K windows per chip for all coprocessors
including in user space support. So there is a possibility of not
getting the window for kernel requests.

This patch reserves windows for each coprocessor type (NX842) and are
available forever for kernel requests, Opens each window for each CPU
on the corresponding chip during driver initialization. So then use the
percpu txwin for NX requests depends on the CPU on which the process
is executing.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 149 +++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 81 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index eb221ed..3780ae1 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -46,7 +46,6 @@ struct nx842_workmem {
 
 	ktime_t start;
 
-	struct vas_window *txwin;	/* Used with VAS function */
 	char padding[WORKMEM_ALIGN]; /* unused, to allow alignment */
 } __packed __aligned(WORKMEM_ALIGN);
 
@@ -65,7 +64,7 @@ struct nx842_coproc {
  * Send the request to NX engine on the chip for the corresponding CPU
  * where the process is executing. Use with VAS function.
  */
-static DEFINE_PER_CPU(struct nx842_coproc *, coproc_inst);
+static DEFINE_PER_CPU(struct vas_window *, cpu_txwin);
 
 /* no cpu hotplug on powernv, so this list never changes after init */
 static LIST_HEAD(nx842_coprocs);
@@ -586,16 +585,11 @@ static int nx842_exec_vas(const unsigned char *in, unsigned int inlen,
 	ccw = SET_FIELD(CCW_FC_842, ccw, fc);
 	crb->ccw = cpu_to_be32(ccw);
 
-	txwin = wmem->txwin;
-	/* shoudn't happen, we don't load without a coproc */
-	if (!txwin) {
-		pr_err_ratelimited("NX-842 coprocessor is not available");
-		return -ENODEV;
-	}
-
 	do {
 		wmem->start = ktime_get();
 		preempt_disable();
+		txwin = this_cpu_read(cpu_txwin);
+
 		/*
 		 * VAS copy CRB into L2 cache. Refer <asm/vas.h>.
 		 * @crb and @offset.
@@ -689,25 +683,6 @@ static inline void nx842_add_coprocs_list(struct nx842_coproc *coproc,
 	list_add(&coproc->list, &nx842_coprocs);
 }
 
-/*
- * Identify chip ID for each CPU and save coprocesor adddress for the
- * corresponding NX engine in percpu coproc_inst.
- * coproc_inst is used in crypto_init to open send window on the NX instance
- * for the corresponding CPU / chip where the open request is executed.
- */
-static void nx842_set_per_cpu_coproc(struct nx842_coproc *coproc)
-{
-	unsigned int i, chip_id;
-
-	for_each_possible_cpu(i) {
-		chip_id = cpu_to_chip_id(i);
-
-		if (coproc->chip_id == chip_id)
-			per_cpu(coproc_inst, i) = coproc;
-	}
-}
-
-
 static struct vas_window *nx842_alloc_txwin(struct nx842_coproc *coproc)
 {
 	struct vas_window *txwin = NULL;
@@ -725,15 +700,58 @@ static struct vas_window *nx842_alloc_txwin(struct nx842_coproc *coproc)
 	 * Open a VAS send window which is used to send request to NX.
 	 */
 	txwin = vas_tx_win_open(coproc->vas.id, coproc->ct, &txattr);
-	if (IS_ERR(txwin)) {
+	if (IS_ERR(txwin))
 		pr_err("ibm,nx-842: Can not open TX window: %ld\n",
 				PTR_ERR(txwin));
-		return NULL;
-	}
 
 	return txwin;
 }
 
+/*
+ * Identify chip ID for each CPU, open send wndow for the corresponding NX
+ * engine and save txwin in percpu cpu_txwin.
+ * cpu_txwin is used in copy/paste operation for each compression /
+ * decompression request.
+ */
+static int nx842_open_percpu_txwins(void)
+{
+	struct nx842_coproc *coproc, *n;
+	unsigned int i, chip_id;
+
+	for_each_possible_cpu(i) {
+		struct vas_window *txwin = NULL;
+
+		chip_id = cpu_to_chip_id(i);
+
+		list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
+			/*
+			 * Kernel requests use only high priority FIFOs. So
+			 * open send windows for these FIFOs.
+			 */
+
+			if (coproc->ct != VAS_COP_TYPE_842_HIPRI)
+				continue;
+
+			if (coproc->chip_id == chip_id) {
+				txwin = nx842_alloc_txwin(coproc);
+				if (IS_ERR(txwin))
+					return PTR_ERR(txwin);
+
+				per_cpu(cpu_txwin, i) = txwin;
+				break;
+			}
+		}
+
+		if (!per_cpu(cpu_txwin, i)) {
+			/* shoudn't happen, Each chip will have NX engine */
+			pr_err("NX engine is not availavle for CPU %d\n", i);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 					int vasid)
 {
@@ -819,14 +837,6 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 	coproc->vas.id = vasid;
 	nx842_add_coprocs_list(coproc, chip_id);
 
-	/*
-	 * Kernel requests use only high priority FIFOs. So save coproc
-	 * info in percpu coproc_inst which will be used to open send
-	 * windows for crypto open requests later.
-	 */
-	if (coproc->ct == VAS_COP_TYPE_842_HIPRI)
-		nx842_set_per_cpu_coproc(coproc);
-
 	return 0;
 
 err_out:
@@ -916,6 +926,19 @@ static int __init nx842_powernv_probe(struct device_node *dn)
 static void nx842_delete_coprocs(void)
 {
 	struct nx842_coproc *coproc, *n;
+	struct vas_window *txwin;
+	int i;
+
+	/*
+	 * close percpu txwins that are opened for the corresponding coproc.
+	 */
+	for_each_possible_cpu(i) {
+		txwin = per_cpu(cpu_txwin, i);
+		if (txwin)
+			vas_win_close(txwin);
+
+		per_cpu(cpu_txwin, i) = 0;
+	}
 
 	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
 		if (coproc->vas.rxwin)
@@ -942,46 +965,6 @@ static void nx842_delete_coprocs(void)
 	.decompress =	nx842_powernv_decompress,
 };
 
-static int nx842_powernv_crypto_init_vas(struct crypto_tfm *tfm)
-{
-	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct nx842_workmem *wmem;
-	struct nx842_coproc *coproc;
-	int ret;
-
-	ret = nx842_crypto_init(tfm, &nx842_powernv_driver);
-
-	if (ret)
-		return ret;
-
-	wmem = PTR_ALIGN((struct nx842_workmem *)ctx->wmem, WORKMEM_ALIGN);
-	coproc = per_cpu(coproc_inst, smp_processor_id());
-
-	ret = -EINVAL;
-	if (coproc && coproc->vas.rxwin) {
-		wmem->txwin = nx842_alloc_txwin(coproc);
-		if (!IS_ERR(wmem->txwin))
-			return 0;
-
-		ret = PTR_ERR(wmem->txwin);
-	}
-
-	return ret;
-}
-
-void nx842_powernv_crypto_exit_vas(struct crypto_tfm *tfm)
-{
-	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct nx842_workmem *wmem;
-
-	wmem = PTR_ALIGN((struct nx842_workmem *)ctx->wmem, WORKMEM_ALIGN);
-
-	if (wmem && wmem->txwin)
-		vas_win_close(wmem->txwin);
-
-	nx842_crypto_exit(tfm);
-}
-
 static int nx842_powernv_crypto_init(struct crypto_tfm *tfm)
 {
 	return nx842_crypto_init(tfm, &nx842_powernv_driver);
@@ -1032,9 +1015,13 @@ static __init int nx842_powernv_init(void)
 
 		nx842_powernv_exec = nx842_exec_icswx;
 	} else {
+		ret = nx842_open_percpu_txwins();
+		if (ret) {
+			nx842_delete_coprocs();
+			return ret;
+		}
+
 		nx842_powernv_exec = nx842_exec_vas;
-		nx842_powernv_alg.cra_init = nx842_powernv_crypto_init_vas;
-		nx842_powernv_alg.cra_exit = nx842_powernv_crypto_exit_vas;
 	}
 
 	ret = crypto_register_alg(&nx842_powernv_alg);
-- 
1.8.3.1
