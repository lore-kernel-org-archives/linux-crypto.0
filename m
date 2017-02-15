From: Mahipal Challa <mahipalreddy2006@gmail.com>
Subject: [RFC PATCH v2 3/3] crypto: zip - Add Compression/Decompression statistics
Date: Wed, 15 Feb 2017 10:45:10 +0530
Message-ID: <1487135710-9692-4-git-send-email-Mahipal.Challa@cavium.com>
References: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan.Glauber@cavium.com,
        Vishnu.Nair@cavium.com, pathreya@cavium.com,
        Mahipal.Challa@cavium.com, Jan Glauber <jglauber@cavium.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add statistics for compression/decompression hardware offload
under debugfs.

Signed-off-by: Mahipal Challa <Mahipal.Challa@cavium.com>
Signed-off-by: Jan Glauber <jglauber@cavium.com>
---
 drivers/crypto/cavium/zip/zip_deflate.c |  10 ++
 drivers/crypto/cavium/zip/zip_inflate.c |  12 ++
 drivers/crypto/cavium/zip/zip_main.c    | 234 ++++++++++++++++++++++++++++++++
 drivers/crypto/cavium/zip/zip_main.h    |  15 ++
 4 files changed, 271 insertions(+)

diff --git a/drivers/crypto/cavium/zip/zip_deflate.c b/drivers/crypto/cavium/zip/zip_deflate.c
index b02789c..9a944b8 100644
--- a/drivers/crypto/cavium/zip/zip_deflate.c
+++ b/drivers/crypto/cavium/zip/zip_deflate.c
@@ -122,12 +122,19 @@ int zip_deflate(struct zip_operation *zip_ops, struct zip_state *s,
 	/* Prepares zip command based on the input parameters */
 	prepare_zip_command(zip_ops, s, zip_cmd);
 
+	atomic64_add(zip_ops->input_len, &zip_dev->stats.comp_in_bytes);
 	/* Loads zip command into command queues and rings door bell */
 	queue = zip_load_instr(zip_cmd, zip_dev);
 
+	/* Stats update for compression requests submitted */
+	atomic64_inc(&zip_dev->stats.comp_req_submit);
+
 	while (!result_ptr->s.compcode)
 		continue;
 
+	/* Stats update for compression requests completed */
+	atomic64_inc(&zip_dev->stats.comp_req_complete);
+
 	zip_ops->compcode = result_ptr->s.compcode;
 	switch (zip_ops->compcode) {
 	case ZIP_CMD_NOTDONE:
@@ -175,6 +182,9 @@ int zip_deflate(struct zip_operation *zip_ops, struct zip_state *s,
 		zip_err("Unknown Format:%d\n", zip_ops->format);
 	}
 
+	atomic64_add(result_ptr->s.totalbyteswritten,
+		     &zip_dev->stats.comp_out_bytes);
+
 	/* Update output_len */
 	if (zip_ops->output_len < result_ptr->s.totalbyteswritten) {
 		/* Dynamic stop && strm->output_len < zipconstants[onfsize] */
diff --git a/drivers/crypto/cavium/zip/zip_inflate.c b/drivers/crypto/cavium/zip/zip_inflate.c
index 5f43a8c..50cbdd8 100644
--- a/drivers/crypto/cavium/zip/zip_inflate.c
+++ b/drivers/crypto/cavium/zip/zip_inflate.c
@@ -135,12 +135,20 @@ int zip_inflate(struct zip_operation *zip_ops, struct zip_state *s,
 	/* Prepare inflate zip command */
 	prepare_inflate_zcmd(zip_ops, s, zip_cmd);
 
+	atomic64_add(zip_ops->input_len, &zip_dev->stats.decomp_in_bytes);
+
 	/* Load inflate command to zip queue and ring the doorbell */
 	queue = zip_load_instr(zip_cmd, zip_dev);
 
+	/* Decompression requests submitted stats update */
+	atomic64_inc(&zip_dev->stats.decomp_req_submit);
+
 	while (!result_ptr->s.compcode)
 		continue;
 
+	/* Decompression requests completed stats update */
+	atomic64_inc(&zip_dev->stats.decomp_req_complete);
+
 	zip_ops->compcode = result_ptr->s.compcode;
 	switch (zip_ops->compcode) {
 	case ZIP_CMD_NOTDONE:
@@ -157,6 +165,7 @@ int zip_inflate(struct zip_operation *zip_ops, struct zip_state *s,
 
 	default:
 		zip_dbg("Instruction failed. Code = %d\n", zip_ops->compcode);
+		atomic64_inc(&zip_dev->stats.decomp_bad_reqs);
 		zip_update_cmd_bufs(zip_dev, queue);
 		return ZIP_ERROR;
 	}
@@ -169,6 +178,9 @@ int zip_inflate(struct zip_operation *zip_ops, struct zip_state *s,
 
 	zip_ops->csum = result_ptr->s.adler32;
 
+	atomic64_add(result_ptr->s.totalbyteswritten,
+		     &zip_dev->stats.decomp_out_bytes);
+
 	if (zip_ops->output_len < result_ptr->s.totalbyteswritten) {
 		zip_err("output_len (%d) < total bytes written (%d)\n",
 			zip_ops->output_len, result_ptr->s.totalbyteswritten);
diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index dd5814a..0951e20 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -451,6 +451,228 @@ static void zip_unregister_compression_device(void)
 	crypto_unregister_scomp(&zip_scomp_lzs);
 }
 
+/*
+ * debugfs functions
+ */
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+/* Displays ZIP device statistics */
+static int zip_show_stats(struct seq_file *s, void *unused)
+{
+	u64 val = 0ull;
+	u64 avg_chunk = 0ull, avg_cr = 0ull;
+	u32 q = 0;
+
+	int index  = 0;
+	struct zip_device *zip;
+	struct zip_stats  *st;
+
+	for (index = 0; index < MAX_ZIP_DEVICES; index++) {
+		if (zip_dev[index]) {
+			zip = zip_dev[index];
+			st  = &zip->stats;
+
+			/* Get all the pending requests */
+			for (q = 0; q < ZIP_NUM_QUEUES; q++) {
+				val = zip_reg_read((zip->reg_base +
+						    ZIP_DBG_COREX_STA(q)));
+				val = (val >> 32);
+				val = val & 0xffffff;
+				atomic64_add(val, &st->pending_req);
+			}
+
+			avg_chunk = (atomic64_read(&st->comp_in_bytes) /
+				     atomic64_read(&st->comp_req_complete));
+			avg_cr = (atomic64_read(&st->comp_in_bytes) /
+				  atomic64_read(&st->comp_out_bytes));
+			seq_printf(s, "        ZIP Device %d Stats\n"
+				      "-----------------------------------\n"
+				      "Comp Req Submitted        : \t%ld\n"
+				      "Comp Req Completed        : \t%ld\n"
+				      "Compress In Bytes         : \t%ld\n"
+				      "Compressed Out Bytes      : \t%ld\n"
+				      "Average Chunk size        : \t%llu\n"
+				      "Average Compression ratio : \t%llu\n"
+				      "Decomp Req Submitted      : \t%ld\n"
+				      "Decomp Req Completed      : \t%ld\n"
+				      "Decompress In Bytes       : \t%ld\n"
+				      "Decompressed Out Bytes    : \t%ld\n"
+				      "Decompress Bad requests   : \t%ld\n"
+				      "Pending Req               : \t%ld\n"
+					"---------------------------------\n",
+				       index,
+				       atomic64_read(&st->comp_req_submit),
+				       atomic64_read(&st->comp_req_complete),
+				       atomic64_read(&st->comp_in_bytes),
+				       atomic64_read(&st->comp_out_bytes),
+				       avg_chunk,
+				       avg_cr,
+				       atomic64_read(&st->decomp_req_submit),
+				       atomic64_read(&st->decomp_req_complete),
+				       atomic64_read(&st->decomp_in_bytes),
+				       atomic64_read(&st->decomp_out_bytes),
+				       atomic64_read(&st->decomp_bad_reqs),
+				       atomic64_read(&st->pending_req));
+
+			/* Reset pending requests  count */
+			atomic64_set(&st->pending_req, 0);
+		}
+	}
+	return 0;
+}
+
+/* Clears stats data */
+static int zip_clear_stats(struct seq_file *s, void *unused)
+{
+	int index = 0;
+
+	for (index = 0; index < MAX_ZIP_DEVICES; index++) {
+		if (zip_dev[index]) {
+			memset(&zip_dev[index]->stats, 0,
+			       sizeof(struct zip_state));
+			seq_printf(s, "Cleared stats for zip %d\n", index);
+		}
+	}
+
+	return 0;
+}
+
+static struct zip_registers zipregs[64] = {
+	{"ZIP_CMD_CTL        ",  0x0000ull},
+	{"ZIP_THROTTLE       ",  0x0010ull},
+	{"ZIP_CONSTANTS      ",  0x00A0ull},
+	{"ZIP_QUE0_MAP       ",  0x1400ull},
+	{"ZIP_QUE1_MAP       ",  0x1408ull},
+	{"ZIP_QUE_ENA        ",  0x0500ull},
+	{"ZIP_QUE_PRI        ",  0x0508ull},
+	{"ZIP_QUE0_DONE      ",  0x2000ull},
+	{"ZIP_QUE1_DONE      ",  0x2008ull},
+	{"ZIP_QUE0_DOORBELL  ",  0x4000ull},
+	{"ZIP_QUE1_DOORBELL  ",  0x4008ull},
+	{"ZIP_QUE0_SBUF_ADDR ",  0x1000ull},
+	{"ZIP_QUE1_SBUF_ADDR ",  0x1008ull},
+	{"ZIP_QUE0_SBUF_CTL  ",  0x1200ull},
+	{"ZIP_QUE1_SBUF_CTL  ",  0x1208ull},
+	{ NULL, 0}
+};
+
+/* Prints registers' contents */
+static int zip_print_regs(struct seq_file *s, void *unused)
+{
+	u64 val = 0;
+	int i = 0, index = 0;
+
+	for (index = 0; index < MAX_ZIP_DEVICES; index++) {
+		if (zip_dev[index]) {
+			seq_printf(s, "--------------------------------\n"
+				      "     ZIP Device %d Registers\n"
+				      "--------------------------------\n",
+				      index);
+
+			i = 0;
+
+			while (zipregs[i].reg_name) {
+				val = zip_reg_read((zip_dev[index]->reg_base +
+						    zipregs[i].reg_offset));
+				seq_printf(s, "%s: 0x%016llx\n",
+					   zipregs[i].reg_name, val);
+				i++;
+			}
+		}
+	}
+	return 0;
+}
+
+static int zip_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, zip_show_stats, NULL);
+}
+
+static const struct file_operations zip_stats_fops = {
+	.owner = THIS_MODULE,
+	.open  = zip_stats_open,
+	.read  = seq_read,
+};
+
+static int zip_clear_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, zip_clear_stats, NULL);
+}
+
+static const struct file_operations zip_clear_fops = {
+	.owner = THIS_MODULE,
+	.open  = zip_clear_open,
+	.read  = seq_read,
+};
+
+static int zip_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, zip_print_regs, NULL);
+}
+
+static const struct file_operations zip_regs_fops = {
+	.owner = THIS_MODULE,
+	.open  = zip_regs_open,
+	.read  = seq_read,
+};
+
+/* Root directory for thunderx_zip debugfs entry */
+static struct dentry *zip_debugfs_root;
+
+static int __init zip_debugfs_init(void)
+{
+	struct dentry *zip_stats, *zip_clear, *zip_regs;
+
+	if (!debugfs_initialized())
+		return -ENODEV;
+
+	zip_debugfs_root = debugfs_create_dir("thunderx_zip", NULL);
+	if (!zip_debugfs_root)
+		return -ENOMEM;
+
+	/* Creating files for entries inside thunderx_zip directory */
+	zip_stats = debugfs_create_file("zip_stats", 0444,
+					zip_debugfs_root,
+					NULL, &zip_stats_fops);
+	if (!zip_stats)
+		goto failed_to_create;
+
+	zip_clear = debugfs_create_file("zip_clear", 0444,
+					zip_debugfs_root,
+					NULL, &zip_clear_fops);
+	if (!zip_clear)
+		goto failed_to_create;
+
+	zip_regs = debugfs_create_file("zip_regs", 0444,
+				       zip_debugfs_root,
+				       NULL, &zip_regs_fops);
+	if (!zip_regs)
+		goto failed_to_create;
+
+	return 0;
+
+failed_to_create:
+	debugfs_remove_recursive(zip_debugfs_root);
+	return -ENOENT;
+}
+
+static void __exit zip_debugfs_exit(void)
+{
+	debugfs_remove_recursive(zip_debugfs_root);
+}
+
+#else
+static int __init zip_debugfs_init(void)
+{
+	return 0;
+}
+
+static void __exit zip_debugfs_exit(void) { }
+
+#endif
+/* debugfs - end */
+
 static int __init zip_init_module(void)
 {
 	int ret;
@@ -470,8 +692,18 @@ static int __init zip_init_module(void)
 		goto err_pci_unregister;
 	}
 
+	/* comp-decomp statistics are handled with debugfs interface */
+	ret = zip_debugfs_init();
+	if (ret < 0) {
+		zip_err("ZIP: debugfs initialization failed\n");
+		goto err_crypto_unregister;
+	}
+
 	return ret;
 
+err_crypto_unregister:
+	zip_unregister_compression_device();
+
 err_pci_unregister:
 	pci_unregister_driver(&zip_driver);
 	return ret;
@@ -479,6 +711,8 @@ static int __init zip_init_module(void)
 
 static void __exit zip_cleanup_module(void)
 {
+	zip_debugfs_exit();
+
 	/* Unregister from the kernel crypto interface */
 	zip_unregister_compression_device();
 
diff --git a/drivers/crypto/cavium/zip/zip_main.h b/drivers/crypto/cavium/zip/zip_main.h
index 1775c77..64e051f 100644
--- a/drivers/crypto/cavium/zip/zip_main.h
+++ b/drivers/crypto/cavium/zip/zip_main.h
@@ -68,6 +68,20 @@ struct zip_registers {
 	u64   reg_offset;
 };
 
+/* ZIP Compression - Decompression stats */
+struct zip_stats {
+	atomic64_t    comp_req_submit;
+	atomic64_t    comp_req_complete;
+	atomic64_t    decomp_req_submit;
+	atomic64_t    decomp_req_complete;
+	atomic64_t    pending_req;
+	atomic64_t    comp_in_bytes;
+	atomic64_t    comp_out_bytes;
+	atomic64_t    decomp_in_bytes;
+	atomic64_t    decomp_out_bytes;
+	atomic64_t    decomp_bad_reqs;
+};
+
 /* ZIP Instruction Queue */
 struct zip_iq {
 	u64        *sw_head;
@@ -93,6 +107,7 @@ struct zip_device {
 	u64               ctxsize;
 
 	struct zip_iq     iq[ZIP_MAX_NUM_QUEUES];
+	struct zip_stats  stats;
 };
 
 /* Prototypes */
-- 
1.8.3.1
