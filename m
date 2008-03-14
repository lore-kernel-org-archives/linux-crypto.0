From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/2] zcrypt: add support for large random numbers
Date: Fri, 14 Mar 2008 10:25:25 +0100
Message-ID: <20080314093046.914555041@de.ibm.com>
References: <20080314092523.147382820@de.ibm.com>
Cc: Ralph Wuerthner <rwuerthn@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:3312 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYCNJaw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2008 05:30:52 -0400
Content-Disposition: inline; filename=112-long-random.diff
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

This patch allows user space applications to access large amounts of 
truly random data. The random data source is the build-in hardware 
random number generator on the CEX2C cards.

Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/crypto/Kconfig              |    1 
 drivers/s390/crypto/zcrypt_api.c    |  120 +++++++++++++++++++++
 drivers/s390/crypto/zcrypt_api.h    |    8 +
 drivers/s390/crypto/zcrypt_pcixcc.c |  199 +++++++++++++++++++++++++++++++++++-
 4 files changed, 327 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/crypto/Kconfig
===================================================================
--- quilt-2.6.orig/drivers/crypto/Kconfig
+++ quilt-2.6/drivers/crypto/Kconfig
@@ -64,6 +64,7 @@ config ZCRYPT
 	tristate "Support for PCI-attached cryptographic adapters"
 	depends on S390
 	select ZCRYPT_MONOLITHIC if ZCRYPT="y"
+	select HW_RANDOM
 	help
 	  Select this option if you want to use a PCI-attached cryptographic
 	  adapter like:
Index: quilt-2.6/drivers/s390/crypto/zcrypt_api.c
===================================================================
--- quilt-2.6.orig/drivers/s390/crypto/zcrypt_api.c
+++ quilt-2.6/drivers/s390/crypto/zcrypt_api.c
@@ -36,6 +36,7 @@
 #include <linux/compat.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
+#include <linux/hw_random.h>
 
 #include "zcrypt_api.h"
 
@@ -52,6 +53,9 @@ static LIST_HEAD(zcrypt_device_list);
 static int zcrypt_device_count = 0;
 static atomic_t zcrypt_open_count = ATOMIC_INIT(0);
 
+static int zcrypt_rng_device_add(void);
+static void zcrypt_rng_device_remove(void);
+
 /**
  * Device attributes common for all crypto devices.
  */
@@ -216,6 +220,22 @@ int zcrypt_device_register(struct zcrypt
 	__zcrypt_increase_preference(zdev);
 	zcrypt_device_count++;
 	spin_unlock_bh(&zcrypt_device_lock);
+	if (zdev->ops->rng) {
+		rc = zcrypt_rng_device_add();
+		if (rc)
+			goto out_unregister;
+	}
+	return 0;
+
+out_unregister:
+	spin_lock_bh(&zcrypt_device_lock);
+	zcrypt_device_count--;
+	list_del_init(&zdev->list);
+	spin_unlock_bh(&zcrypt_device_lock);
+	sysfs_remove_group(&zdev->ap_dev->device.kobj,
+			   &zcrypt_device_attr_group);
+	put_device(&zdev->ap_dev->device);
+	zcrypt_device_put(zdev);
 out:
 	return rc;
 }
@@ -226,6 +246,8 @@ EXPORT_SYMBOL(zcrypt_device_register);
  */
 void zcrypt_device_unregister(struct zcrypt_device *zdev)
 {
+	if (zdev->ops->rng)
+		zcrypt_rng_device_remove();
 	spin_lock_bh(&zcrypt_device_lock);
 	zcrypt_device_count--;
 	list_del_init(&zdev->list);
@@ -427,6 +449,37 @@ static long zcrypt_send_cprb(struct ica_
 	return -ENODEV;
 }
 
+static long zcrypt_rng(char *buffer)
+{
+	struct zcrypt_device *zdev;
+	int rc;
+
+	spin_lock_bh(&zcrypt_device_lock);
+	list_for_each_entry(zdev, &zcrypt_device_list, list) {
+		if (!zdev->online || !zdev->ops->rng)
+			continue;
+		zcrypt_device_get(zdev);
+		get_device(&zdev->ap_dev->device);
+		zdev->request_count++;
+		__zcrypt_decrease_preference(zdev);
+		if (try_module_get(zdev->ap_dev->drv->driver.owner)) {
+			spin_unlock_bh(&zcrypt_device_lock);
+			rc = zdev->ops->rng(zdev, buffer);
+			spin_lock_bh(&zcrypt_device_lock);
+			module_put(zdev->ap_dev->drv->driver.owner);
+		} else
+			rc = -EAGAIN;
+		zdev->request_count--;
+		__zcrypt_increase_preference(zdev);
+		put_device(&zdev->ap_dev->device);
+		zcrypt_device_put(zdev);
+		spin_unlock_bh(&zcrypt_device_lock);
+		return rc;
+	}
+	spin_unlock_bh(&zcrypt_device_lock);
+	return -ENODEV;
+}
+
 static void zcrypt_status_mask(char status[AP_DEVICES])
 {
 	struct zcrypt_device *zdev;
@@ -1041,6 +1094,73 @@ out:
 	return count;
 }
 
+static int zcrypt_rng_device_count;
+static u32 *zcrypt_rng_buffer;
+static int zcrypt_rng_buffer_index;
+static DEFINE_MUTEX(zcrypt_rng_mutex);
+
+static int zcrypt_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	int rc;
+
+	/**
+	 * We don't need locking here because the RNG API guarantees serialized
+	 * read method calls.
+	 */
+	if (zcrypt_rng_buffer_index == 0) {
+		rc = zcrypt_rng((char *) zcrypt_rng_buffer);
+		if (rc < 0)
+			return -EIO;
+		zcrypt_rng_buffer_index = rc / sizeof *data;
+	}
+	*data = zcrypt_rng_buffer[--zcrypt_rng_buffer_index];
+	return sizeof *data;
+}
+
+static struct hwrng zcrypt_rng_dev = {
+	.name		= "zcrypt",
+	.data_read	= zcrypt_rng_data_read,
+};
+
+static int zcrypt_rng_device_add(void)
+{
+	int rc = 0;
+
+	mutex_lock(&zcrypt_rng_mutex);
+	if (zcrypt_rng_device_count == 0) {
+		zcrypt_rng_buffer = (u32 *) get_zeroed_page(GFP_KERNEL);
+		if (!zcrypt_rng_buffer) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		zcrypt_rng_buffer_index = 0;
+		rc = hwrng_register(&zcrypt_rng_dev);
+		if (rc)
+			goto out_free;
+		zcrypt_rng_device_count = 1;
+	} else
+		zcrypt_rng_device_count++;
+	mutex_unlock(&zcrypt_rng_mutex);
+	return 0;
+
+out_free:
+	free_page((unsigned long) zcrypt_rng_buffer);
+out:
+	mutex_unlock(&zcrypt_rng_mutex);
+	return rc;
+}
+
+static void zcrypt_rng_device_remove(void)
+{
+	mutex_lock(&zcrypt_rng_mutex);
+	zcrypt_rng_device_count--;
+	if (zcrypt_rng_device_count == 0) {
+		hwrng_unregister(&zcrypt_rng_dev);
+		free_page((unsigned long) zcrypt_rng_buffer);
+	}
+	mutex_unlock(&zcrypt_rng_mutex);
+}
+
 /**
  * The module initialization code.
  */
Index: quilt-2.6/drivers/s390/crypto/zcrypt_api.h
===================================================================
--- quilt-2.6.orig/drivers/s390/crypto/zcrypt_api.h
+++ quilt-2.6/drivers/s390/crypto/zcrypt_api.h
@@ -100,6 +100,13 @@ struct ica_z90_status {
 #define ZCRYPT_CEX2C		5
 #define ZCRYPT_CEX2A		6
 
+/**
+ * Large random numbers are pulled in 4096 byte chunks from the crypto cards
+ * and stored in a page. Be carefull when increasing this buffer due to size
+ * limitations for AP requests.
+ */
+#define ZCRYPT_RNG_BUFFER_SIZE	4096
+
 struct zcrypt_device;
 
 struct zcrypt_ops {
@@ -107,6 +114,7 @@ struct zcrypt_ops {
 	long (*rsa_modexpo_crt)(struct zcrypt_device *,
 				struct ica_rsa_modexpo_crt *);
 	long (*send_cprb)(struct zcrypt_device *, struct ica_xcRB *);
+	long (*rng)(struct zcrypt_device *, char *);
 };
 
 struct zcrypt_device {
Index: quilt-2.6/drivers/s390/crypto/zcrypt_pcixcc.c
===================================================================
--- quilt-2.6.orig/drivers/s390/crypto/zcrypt_pcixcc.c
+++ quilt-2.6/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -356,6 +356,55 @@ static int XCRB_msg_to_type6CPRB_msgX(st
 }
 
 /**
+ * Prepare a type6 CPRB message for random number generation
+ *
+ * @ap_dev: AP device pointer
+ * @ap_msg: pointer to AP message
+ */
+static void rng_type6CPRB_msgX(struct ap_device *ap_dev,
+			       struct ap_message *ap_msg,
+			       unsigned random_number_length)
+{
+	struct {
+		struct type6_hdr hdr;
+		struct CPRBX cprbx;
+		char function_code[2];
+		short int rule_length;
+		char rule[8];
+		short int verb_length;
+		short int key_length;
+	} __attribute__((packed)) *msg = ap_msg->message;
+	static struct type6_hdr static_type6_hdrX = {
+		.type		= 0x06,
+		.offset1	= 0x00000058,
+		.agent_id	= {'C', 'A'},
+		.function_code	= {'R', 'L'},
+		.ToCardLen1	= sizeof *msg - sizeof(msg->hdr),
+		.FromCardLen1	= sizeof *msg - sizeof(msg->hdr),
+	};
+	static struct CPRBX static_cprbx = {
+		.cprb_len	= 0x00dc,
+		.cprb_ver_id	= 0x02,
+		.func_id	= {0x54, 0x32},
+		.req_parml	= sizeof *msg - sizeof(msg->hdr) -
+				  sizeof(msg->cprbx),
+		.rpl_msgbl	= sizeof *msg - sizeof(msg->hdr),
+	};
+
+	msg->hdr = static_type6_hdrX;
+	msg->hdr.FromCardLen2 = random_number_length,
+	msg->cprbx = static_cprbx;
+	msg->cprbx.rpl_datal = random_number_length,
+	msg->cprbx.domain = AP_QID_QUEUE(ap_dev->qid);
+	memcpy(msg->function_code, msg->hdr.function_code, 0x02);
+	msg->rule_length = 0x0a;
+	memcpy(msg->rule, "RANDOM  ", 8);
+	msg->verb_length = 0x02;
+	msg->key_length = 0x02;
+	ap_msg->length = sizeof *msg;
+}
+
+/**
  * Copy results from a type 86 ICA reply message back to user space.
  *
  * @zdev: crypto device pointer
@@ -509,6 +558,26 @@ static int convert_type86_xcrb(struct zc
 	return 0;
 }
 
+static int convert_type86_rng(struct zcrypt_device *zdev,
+			  struct ap_message *reply,
+			  char *buffer)
+{
+	struct {
+		struct type86_hdr hdr;
+		struct type86_fmt2_ext fmt2;
+		struct CPRBX cprbx;
+	} __attribute__((packed)) *msg = reply->message;
+	char *data = reply->message;
+
+	if (msg->cprbx.ccp_rtcode != 0 || msg->cprbx.ccp_rscode != 0) {
+		PDEBUG("RNG response error on PCIXCC/CEX2C rc=%hu/rs=%hu\n",
+		       rc, rs);
+		return -EINVAL;
+	}
+	memcpy(buffer, data + msg->fmt2.offset2, msg->fmt2.count2);
+	return msg->fmt2.count2;
+}
+
 static int convert_response_ica(struct zcrypt_device *zdev,
 			    struct ap_message *reply,
 			    char __user *outputdata,
@@ -567,6 +636,31 @@ static int convert_response_xcrb(struct 
 	}
 }
 
+static int convert_response_rng(struct zcrypt_device *zdev,
+				 struct ap_message *reply,
+				 char *data)
+{
+	struct type86x_reply *msg = reply->message;
+
+	switch (msg->hdr.type) {
+	case TYPE82_RSP_CODE:
+	case TYPE88_RSP_CODE:
+		return -EINVAL;
+	case TYPE86_RSP_CODE:
+		if (msg->hdr.reply_code)
+			return -EINVAL;
+		if (msg->cprbx.cprb_ver_id == 0x02)
+			return convert_type86_rng(zdev, reply, data);
+		/* no break, incorrect cprb version is an unknown response */
+	default: /* Unknown response type, this should NEVER EVER happen */
+		PRINTK("Unrecognized Message Header: %08x%08x\n",
+		       *(unsigned int *) reply->message,
+		       *(unsigned int *) (reply->message+4));
+		zdev->online = 0;
+		return -EAGAIN;	/* repeat the request on a different device. */
+	}
+}
+
 /**
  * This function is called from the AP bus code after a crypto request
  * "msg" has finished with the reply message "reply".
@@ -736,6 +830,42 @@ out_free:
 }
 
 /**
+ * The request distributor calls this function if it picked the PCIXCC/CEX2C
+ * device to generate random data.
+ * @zdev: pointer to zcrypt_device structure that identifies the
+ *	  PCIXCC/CEX2C device to the request distributor
+ * @buffer: pointer to a memory page to return random data
+ */
+
+static long zcrypt_pcixcc_rng(struct zcrypt_device *zdev,
+				    char *buffer)
+{
+	struct ap_message ap_msg;
+	struct response_type resp_type = {
+		.type = PCIXCC_RESPONSE_TYPE_XCRB,
+	};
+	int rc;
+
+	ap_msg.message = kmalloc(PCIXCC_MAX_XCRB_MESSAGE_SIZE, GFP_KERNEL);
+	if (!ap_msg.message)
+		return -ENOMEM;
+	ap_msg.psmid = (((unsigned long long) current->pid) << 32) +
+				atomic_inc_return(&zcrypt_step);
+	ap_msg.private = &resp_type;
+	rng_type6CPRB_msgX(zdev->ap_dev, &ap_msg, ZCRYPT_RNG_BUFFER_SIZE);
+	init_completion(&resp_type.work);
+	ap_queue_message(zdev->ap_dev, &ap_msg);
+	rc = wait_for_completion_interruptible(&resp_type.work);
+	if (rc == 0)
+		rc = convert_response_rng(zdev, &ap_msg, buffer);
+	else
+		/* Signal pending. */
+		ap_cancel_message(zdev->ap_dev, &ap_msg);
+	kfree(ap_msg.message);
+	return rc;
+}
+
+/**
  * The crypto operations for a PCIXCC/CEX2C card.
  */
 static struct zcrypt_ops zcrypt_pcixcc_ops = {
@@ -744,6 +874,13 @@ static struct zcrypt_ops zcrypt_pcixcc_o
 	.send_cprb = zcrypt_pcixcc_send_cprb,
 };
 
+static struct zcrypt_ops zcrypt_pcixcc_with_rng_ops = {
+	.rsa_modexpo = zcrypt_pcixcc_modexpo,
+	.rsa_modexpo_crt = zcrypt_pcixcc_modexpo_crt,
+	.send_cprb = zcrypt_pcixcc_send_cprb,
+	.rng = zcrypt_pcixcc_rng,
+};
+
 /**
  * Micro-code detection function. Its sends a message to a pcixcc card
  * to find out the microcode level.
@@ -859,6 +996,58 @@ out_free:
 }
 
 /**
+ * Large random number detection function. Its sends a message to a pcixcc
+ * card to find out if large random numbers are supported.
+ * @ap_dev: pointer to the AP device.
+ *
+ * Returns 1 if large random numbers are supported, 0 if not and < 0 on error.
+ */
+static int zcrypt_pcixcc_rng_supported(struct ap_device *ap_dev)
+{
+	struct ap_message ap_msg;
+	unsigned long long psmid;
+	struct {
+		struct type86_hdr hdr;
+		struct type86_fmt2_ext fmt2;
+		struct CPRBX cprbx;
+	} __attribute__((packed)) *reply;
+	int rc, i;
+
+	ap_msg.message = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!ap_msg.message)
+		return -ENOMEM;
+
+	rng_type6CPRB_msgX(ap_dev, &ap_msg, 4);
+	rc = ap_send(ap_dev->qid, 0x0102030405060708ULL, ap_msg.message,
+		     ap_msg.length);
+	if (rc)
+		goto out_free;
+
+	/* Wait for the test message to complete. */
+	for (i = 0; i < 2 * HZ; i++) {
+		msleep(1000 / HZ);
+		rc = ap_recv(ap_dev->qid, &psmid, ap_msg.message, 4096);
+		if (rc == 0 && psmid == 0x0102030405060708ULL)
+			break;
+	}
+
+	if (i >= 2 * HZ) {
+		/* Got no answer. */
+		rc = -ENODEV;
+		goto out_free;
+	}
+
+	reply = ap_msg.message;
+	if (reply->cprbx.ccp_rtcode == 0 && reply->cprbx.ccp_rscode == 0)
+		rc = 1;
+	else
+		rc = 0;
+out_free:
+	free_page((unsigned long) ap_msg.message);
+	return rc;
+}
+
+/**
  * Probe function for PCIXCC/CEX2C cards. It always accepts the AP device
  * since the bus_match already checked the hardware type. The PCIXCC
  * cards come in two flavours: micro code level 2 and micro code level 3.
@@ -874,7 +1063,6 @@ static int zcrypt_pcixcc_probe(struct ap
 	if (!zdev)
 		return -ENOMEM;
 	zdev->ap_dev = ap_dev;
-	zdev->ops = &zcrypt_pcixcc_ops;
 	zdev->online = 1;
 	if (ap_dev->device_type == AP_DEVICE_TYPE_PCIXCC) {
 		rc = zcrypt_pcixcc_mcl(ap_dev);
@@ -901,6 +1089,15 @@ static int zcrypt_pcixcc_probe(struct ap
 		zdev->min_mod_size = PCIXCC_MIN_MOD_SIZE;
 		zdev->max_mod_size = PCIXCC_MAX_MOD_SIZE;
 	}
+	rc = zcrypt_pcixcc_rng_supported(ap_dev);
+	if (rc < 0) {
+		zcrypt_device_free(zdev);
+		return rc;
+	}
+	if (rc)
+		zdev->ops = &zcrypt_pcixcc_with_rng_ops;
+	else
+		zdev->ops = &zcrypt_pcixcc_ops;
 	ap_dev->reply = &zdev->reply;
 	ap_dev->private = zdev;
 	rc = zcrypt_device_register(zdev);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

