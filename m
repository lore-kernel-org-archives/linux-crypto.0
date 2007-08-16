From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 10/10] cryptoapi: async speed test
Date: Thu, 16 Aug 2007 22:01:15 +0200
Message-ID: <20070816200138.277096000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60604 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbXHPUFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:53 -0400
Content-Disposition: inline; filename=limi_speed_async.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This was used to test the async AES algo. trcypt is working as well but does
enqueue that much :-)

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -468,6 +468,12 @@ config CRYPTO_TEST
 	help
 	  Quick & dirty crypto test module.
 
+config CRYPTO_LIMI_SPEED_ASYNC
+	tristate "Crypto algorithm speed test with msec resolution"
+	help
+	  insmod/modprobe the module, and watch dmesg for results.
+	  Test is for aes only, see modinfo for options
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += mich
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+obj-$(CONFIG_CRYPTO_LIMI_SPEED_ASYNC) += limi-speeda.o
 
 #
 # generic algorithms and the async_tx api
--- /dev/null
+++ b/crypto/limi-speeda.c
@@ -0,0 +1,191 @@
+/*
+ * Code derived von crypt/tcrypt.h
+ *
+ * Small speed test with time resolution in msec.
+ * Author: Sebastian Siewior (sebastian _at_ breakpoint.cc)
+ * License: GPL v2
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <linux/jiffies.h>
+#include <linux/types.h>
+#include <linux/err.h>
+
+static unsigned int buff_size = 16 * 1024;
+module_param(buff_size, uint, 0444);
+MODULE_PARM_DESC(buff_size, "Buffer allocated by kmalloc()");
+
+static unsigned int keylen = 16;
+module_param(keylen, uint, 0444);
+MODULE_PARM_DESC(keylen, "Length of the key (16,24 or 32 bits");
+
+static unsigned int mode = 0;
+module_param(mode, uint, 0444);
+MODULE_PARM_DESC(mode, "0 -> encryption else decryption");
+
+static unsigned int big_loops = 10;
+module_param(big_loops, uint, 0444);
+MODULE_PARM_DESC(big_loops, "Number of mensurations.");
+
+static unsigned int small_loops = 10000;
+module_param(small_loops, uint, 0444);
+MODULE_PARM_DESC(small_loops, "loops within one mesurement.");
+
+static unsigned int alg = 1;
+module_param(alg, uint, 0444);
+MODULE_PARM_DESC(alg, "0 -> ecb(aes), else -> cbc(aes)");
+
+static atomic_t req_pending;
+
+static void request_complete(struct crypto_async_request *req, int err)
+{
+	wait_queue_head_t *complete_wq = req->data;
+	struct ablkcipher_request *ablk_req = ablkcipher_request_cast(req);
+
+	atomic_dec(&req_pending);
+	ablkcipher_request_free(ablk_req);
+	wake_up_all(complete_wq);
+}
+
+static int __init init(void)
+{
+	struct scatterlist sg[1];
+	unsigned char iv[16];
+	struct crypto_ablkcipher *tfm;
+	static char *in;
+	unsigned int i;
+	unsigned int ret;
+	unsigned long start, end;
+	unsigned long total = 0;
+	unsigned long size_kb;
+	unsigned char key[32] = { 1, 2, 3, 4, 5, 6 };
+	const unsigned char *algname;
+	struct ablkcipher_request *ablk_req = NULL;
+	wait_queue_head_t complete_wq;
+	DEFINE_WAIT(wait_for_request);
+
+	algname = alg ? "cbc(aes)" : "ecb(aes)";
+	printk("Limi-speed: %s buff_size: %u, keylen: %d, mode: %s\n", algname, buff_size, keylen,
+			mode ? "decryption" : "encryption");
+	printk("loops: %d, iterations: %d, ", big_loops, small_loops);
+	size_kb = small_loops * buff_size / 1024;
+	printk("=> %lu kb or %lu mb a loop\n", size_kb, size_kb/1024);
+
+	if (keylen != 16 && keylen != 24 && keylen != 32) {
+		printk("Invalid keysize\n");
+		return -EINVAL;
+	}
+
+	in = kmalloc(buff_size, GFP_KERNEL);
+	if (in == NULL) {
+		printk("Failed to allocate memory.\n");
+		return -ENOMEM;
+	}
+	printk("'Alloc' in %d @%p\n", buff_size, in);
+	memset(in, 0x24, buff_size);
+	sg_set_buf(sg, in, buff_size);
+
+	tfm = crypto_alloc_ablkcipher(algname, 0, 0 /* CRYPTO_ALG_ASYNC */);
+
+	if (IS_ERR(tfm)) {
+		printk("failed to load transform for %s: %ld\n", algname, PTR_ERR(tfm));
+		goto leave;
+	}
+
+	ret = crypto_ablkcipher_setkey(tfm, key, keylen);
+	if (ret) {
+		printk("setkey() failed\n");
+		goto out_tfm;
+	}
+
+	init_waitqueue_head(&complete_wq);
+	atomic_set(&req_pending, 0);
+
+	for (i=0 ; i<big_loops; i++) {
+		int j;
+		ret = 0;
+		start = jiffies;
+
+		for (j=0; j < small_loops; j++) {
+			while (1) {
+
+				prepare_to_wait(&complete_wq, &wait_for_request, TASK_INTERRUPTIBLE);
+				ablk_req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
+				if (likely(ablk_req))
+					break;
+				printk("ablkcipher_request_alloc() failed\n");
+				schedule();
+			}
+			atomic_inc(&req_pending);
+
+			ablkcipher_request_set_callback(ablk_req, CRYPTO_TFM_REQ_MAY_BACKLOG, request_complete, &complete_wq);
+			ablkcipher_request_set_crypt(ablk_req, sg, sg, buff_size, &iv);
+
+			if (!mode)
+				ret = crypto_ablkcipher_encrypt(ablk_req);
+			else
+				ret = crypto_ablkcipher_decrypt(ablk_req);
+
+			if (unlikely(ret == -EBUSY)) {
+				schedule();
+
+			} else if (unlikely(ret == 0)) {
+				printk("Process in SYNC mode, this is not cool\n");
+				ablkcipher_request_free(ablk_req);
+				goto out_tfm;
+			} else if (unlikely(ret != -EINPROGRESS)) {
+				printk("encryption failed: %d after (i,j) (%u,%u) iterations\n", ret, i, j);
+				ablkcipher_request_free(ablk_req);
+				goto out_tfm;
+			}
+
+			if (signal_pending(current)) {
+				printk("signal catched\n");
+				break;
+			}
+
+		}
+
+		while (1) {
+//clean_up_exit:
+			prepare_to_wait(&complete_wq, &wait_for_request, TASK_INTERRUPTIBLE);
+			if (atomic_read(&req_pending) == 0)
+				break;
+			schedule();
+		}
+
+		end = jiffies;
+		finish_wait(&complete_wq, &wait_for_request);
+
+		if ( !time_after(start, end)) {
+			printk("Run: %u msec\n", jiffies_to_msecs(end - start));
+			total += jiffies_to_msecs(end - start);
+		} else {
+			printk("Run: %u msec\n", jiffies_to_msecs(start - end));
+			total += jiffies_to_msecs(start - end);
+		}
+		if (signal_pending(current))
+			break;
+	}
+
+	total /= big_loops;
+	size_kb *= 1000;
+	size_kb /= total;
+	printk("Average: %lu msec, approx. %lu kb/sec || %lu mb/sec  \n", total,
+			size_kb, size_kb/1024);
+out_tfm:
+	crypto_free_ablkcipher(tfm);
+leave:
+	kfree(in);
+	return -ENODEV;
+}
+
+static void __exit fini(void) { }
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");

-- 
