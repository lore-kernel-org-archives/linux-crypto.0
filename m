Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8260FC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 13:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566E2204FD
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 13:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHKNvM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 09:51:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:4208 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgHKNua (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 09:50:30 -0400
IronPort-SDR: G5jEnu56gkZopzM+EwFGS7YpMY7dqiKJ/pILlDB/UQGUk0QHdO8zTeSceVlqG4t2p4ZIpAEisd
 WCL1p33HzlRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="133265300"
X-IronPort-AV: E=Sophos;i="5.75,461,1589266800"; 
   d="scan'208";a="133265300"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 06:42:26 -0700
IronPort-SDR: IGG3KvWHnyd5Cx+1H0XrXcRky30p/IxTk56Yc7IRB5vn7trPqZsQtZLOC8o3fWs3Y9lm0Ea9xl
 sjRXpHnBbs4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,461,1589266800"; 
   d="scan'208";a="495150725"
Received: from marshy.an.intel.com ([10.122.105.159])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2020 06:42:25 -0700
From:   richard.gong@linux.intel.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@kernel.org, richard.gong@intel.com
Subject: [PATCHv1 1/2] firmware: stratix10-svc: extend svc to support new crypto features
Date:   Tue, 11 Aug 2020 08:56:21 -0500
Message-Id: <1597154182-26970-2-git-send-email-richard.gong@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1597154182-26970-1-git-send-email-richard.gong@linux.intel.com>
References: <1597154182-26970-1-git-send-email-richard.gong@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Richard Gong <richard.gong@intel.com>

Extend Intel service layer driver to support new crypto services on
Intel SoCFPGA platforms.

The crypto services include security certificate, image boot validation,
security key cancellation, get provision data, random number generation,
advance encrtption standard (AES) encryption and decryption services.

Signed-off-by: Richard Gong <richard.gong@intel.com>
---
 drivers/firmware/stratix10-svc.c                   | 178 +++++++++++++++++++--
 include/linux/firmware/intel/stratix10-smc.h       | 147 ++++++++++++++++-
 .../linux/firmware/intel/stratix10-svc-client.h    |  42 +++++
 3 files changed, 348 insertions(+), 19 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 3aa489d..994d0a1 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -34,12 +34,13 @@
  * timeout is set to 30 seconds (30 * 1000) at Intel Stratix10 SoC.
  */
 #define SVC_NUM_DATA_IN_FIFO			32
-#define SVC_NUM_CHANNEL				2
+#define SVC_NUM_CHANNEL				3
 #define FPGA_CONFIG_DATA_CLAIM_TIMEOUT_MS	200
 #define FPGA_CONFIG_STATUS_TIMEOUT_SEC		30
 
 /* stratix10 service layer clients */
 #define STRATIX10_RSU				"stratix10-rsu"
+#define INTEL_FCS				"intel-fcs"
 
 typedef void (svc_invoke_fn)(unsigned long, unsigned long, unsigned long,
 			     unsigned long, unsigned long, unsigned long,
@@ -53,6 +54,7 @@ struct stratix10_svc_chan;
  */
 struct stratix10_svc {
 	struct platform_device *stratix10_svc_rsu;
+	struct platform_device *intel_svc_fcs;
 };
 
 /**
@@ -97,8 +99,10 @@ struct stratix10_svc_data_mem {
 /**
  * struct stratix10_svc_data - service data structure
  * @chan: service channel
- * @paddr: playload physical address
- * @size: playload size
+ * @paddr: physical address of to be processed payload
+ * @size: to be processed playload size
+ * @paddr_output: physical address of the processed payload
+ * @size_output: the processed payload size
  * @command: service command requested by client
  * @flag: configuration type (full or partial)
  * @arg: args to be passed via registers and not physically mapped buffers
@@ -109,6 +113,8 @@ struct stratix10_svc_data {
 	struct stratix10_svc_chan *chan;
 	phys_addr_t paddr;
 	size_t size;
+	phys_addr_t paddr_output;
+	size_t size_output;
 	u32 command;
 	u32 flag;
 	u64 arg[3];
@@ -246,32 +252,54 @@ static void svc_thread_cmd_config_status(struct stratix10_svc_controller *ctrl,
 {
 	struct arm_smccc_res res;
 	int count_in_sec;
+	unsigned long a0, a1, a2;
 
 	cb_data->kaddr1 = NULL;
 	cb_data->kaddr2 = NULL;
 	cb_data->kaddr3 = NULL;
 	cb_data->status = BIT(SVC_STATUS_ERROR);
 
-	pr_debug("%s: polling config status\n", __func__);
+	pr_debug("%s: polling completed status\n", __func__);
+
+	a0 = INTEL_SIP_SMC_FPGA_CONFIG_ISDONE;
+	a1 = (unsigned long)p_data->paddr;
+	a2 = (unsigned long)p_data->size;
+
+	if (p_data->command == COMMAND_POLL_SERVICE_STATUS)
+		a0 = INTEL_SIP_SMC_SERVICE_COMPLETED;
 
 	count_in_sec = FPGA_CONFIG_STATUS_TIMEOUT_SEC;
 	while (count_in_sec) {
-		ctrl->invoke_fn(INTEL_SIP_SMC_FPGA_CONFIG_ISDONE,
-				0, 0, 0, 0, 0, 0, 0, &res);
+		ctrl->invoke_fn(a0, a1, a2, 0, 0, 0, 0, 0, &res);
 		if ((res.a0 == INTEL_SIP_SMC_STATUS_OK) ||
-		    (res.a0 == INTEL_SIP_SMC_STATUS_ERROR))
+		    (res.a0 == INTEL_SIP_SMC_STATUS_ERROR) ||
+		    (res.a0 == INTEL_SIP_SMC_STATUS_REJECTED))
 			break;
 
 		/*
-		 * configuration is still in progress, wait one second then
+		 * request is still in progress, wait one second then
 		 * poll again
 		 */
 		msleep(1000);
 		count_in_sec--;
-	}
+	};
 
-	if (res.a0 == INTEL_SIP_SMC_STATUS_OK && count_in_sec)
+	if (!count_in_sec) {
+		pr_err("%s: poll status timeout\n", __func__);
+		cb_data->status = BIT(SVC_STATUS_BUSY);
+	} else if (res.a0 == INTEL_SIP_SMC_STATUS_OK) {
 		cb_data->status = BIT(SVC_STATUS_COMPLETED);
+		cb_data->kaddr2 = (res.a2) ?
+				  svc_pa_to_va(res.a2) : NULL;
+		cb_data->kaddr3 = (res.a3) ? &res.a3 : NULL;
+	} else {
+		pr_err("%s: poll status error\n", __func__);
+		cb_data->kaddr1 = &res.a1;
+		cb_data->kaddr2 = (res.a2) ?
+				  svc_pa_to_va(res.a2) : NULL;
+		cb_data->kaddr3 = (res.a3) ? &res.a3 : NULL;
+		cb_data->status = BIT(SVC_STATUS_ERROR);
+	}
 
 	p_data->chan->scl->receive_cb(p_data->chan->scl, cb_data);
 }
@@ -296,6 +324,10 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 	case COMMAND_RECONFIG:
 	case COMMAND_RSU_UPDATE:
 	case COMMAND_RSU_NOTIFY:
+	case COMMAND_FCS_REQUEST_SERVICE:
+	case COMMAND_FCS_SEND_CERTIFICATE:
+	case COMMAND_FCS_DATA_ENCRYPTION:
+	case COMMAND_FCS_DATA_DECRYPTION:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		break;
 	case COMMAND_RECONFIG_DATA_SUBMIT:
@@ -314,6 +346,14 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 		cb_data->kaddr1 = &res.a1;
 		cb_data->kaddr2 = &res.a2;
 		break;
+	case COMMAND_FCS_RANDOM_NUMBER_GEN:
+	case COMMAND_FCS_GET_PROVISION_DATA:
+	case COMMAND_POLL_SERVICE_STATUS:
+		cb_data->status = BIT(SVC_STATUS_OK);
+		cb_data->kaddr1 = &res.a1;
+		cb_data->kaddr2 = svc_pa_to_va(res.a2);
+		cb_data->kaddr3 = &res.a3;
+		break;
 	default:
 		pr_warn("it shouldn't happen\n");
 		break;
@@ -340,7 +380,7 @@ static int svc_normal_to_secure_thread(void *data)
 	struct stratix10_svc_data *pdata;
 	struct stratix10_svc_cb_data *cbdata;
 	struct arm_smccc_res res;
-	unsigned long a0, a1, a2;
+	unsigned long a0, a1, a2, a3, a4, a5;
 	int ret_fifo = 0;
 
 	pdata =  kmalloc(sizeof(*pdata), GFP_KERNEL);
@@ -357,6 +397,9 @@ static int svc_normal_to_secure_thread(void *data)
 	a0 = INTEL_SIP_SMC_FPGA_CONFIG_LOOPBACK;
 	a1 = 0;
 	a2 = 0;
+	a3 = 0;
+	a4 = 0;
+	a5 = 0;
 
 	pr_debug("smc_hvc_shm_thread is running\n");
 
@@ -422,6 +465,52 @@ static int svc_normal_to_secure_thread(void *data)
 			a1 = 0;
 			a2 = 0;
 			break;
+
+		/* for FPGA crypto service */
+		case COMMAND_FCS_DATA_ENCRYPTION:
+			a0 = INTEL_SIP_SMC_FCS_CRYPTION;
+			a1 = 1;
+			a2 = (unsigned long)pdata->paddr;
+			a3 = (unsigned long)pdata->size;
+			a4 = (unsigned long)pdata->paddr_output;
+			a5 = (unsigned long)pdata->size_output;
+			break;
+		case COMMAND_FCS_DATA_DECRYPTION:
+			a0 = INTEL_SIP_SMC_FCS_CRYPTION;
+			a1 = 0;
+			a2 = (unsigned long)pdata->paddr;
+			a3 = (unsigned long)pdata->size;
+			a4 = (unsigned long)pdata->paddr_output;
+			a5 = (unsigned long)pdata->size_output;
+			break;
+		case COMMAND_FCS_RANDOM_NUMBER_GEN:
+			a0 = INTEL_SIP_SMC_FCS_RANDOM_NUMBER;
+			a1 = (unsigned long)pdata->paddr;
+			a2 = 0;
+			break;
+		case COMMAND_FCS_REQUEST_SERVICE:
+			a0 = INTEL_SIP_SMC_FCS_SERVICE_REQUEST;
+			a1 = (unsigned long)pdata->paddr;
+			a2 = (unsigned long)pdata->size;
+			break;
+		case COMMAND_FCS_SEND_CERTIFICATE:
+			a0 = INTEL_SIP_SMC_FCS_SEND_CERTIFICATE;
+			a1 = (unsigned long)pdata->paddr;
+			a2 = (unsigned long)pdata->size;
+			break;
+		case COMMAND_FCS_GET_PROVISION_DATA:
+			a0 = INTEL_SIP_SMC_FCS_GET_PROVISION_DATA;
+			a1 = (unsigned long)pdata->paddr;
+			a2 = 0;
+			break;
+
+		/* for general service status polling */
+		case COMMAND_POLL_SERVICE_STATUS:
+			a0 = INTEL_SIP_SMC_SERVICE_COMPLETED;
+			a1 = (unsigned long)pdata->paddr;
+			a2 = (unsigned long)pdata->size;
+			break;
+
 		default:
 			pr_warn("it shouldn't happen\n");
 			break;
@@ -430,7 +519,14 @@ static int svc_normal_to_secure_thread(void *data)
 			 __func__, (unsigned int)a0, (unsigned int)a1);
 		pr_debug(" a2=0x%016x\n", (unsigned int)a2);
 
-		ctrl->invoke_fn(a0, a1, a2, 0, 0, 0, 0, 0, &res);
+		if (a0 == INTEL_SIP_SMC_FCS_CRYPTION) {
+			pr_debug(" a3=0x%016x\n", (unsigned int)a3);
+			pr_debug(" a4=0x%016x\n", (unsigned int)a4);
+			pr_debug(" a5=0x%016x\n", (unsigned int)a5);
+			ctrl->invoke_fn(a0, a1, a2, a3, a4, a5, 0, 0, &res);
+		} else {
+			ctrl->invoke_fn(a0, a1, a2, 0, 0, 0, 0, 0, &res);
+		}
 
 		pr_debug("%s: after SMC call -- res.a0=0x%016x",
 			 __func__, (unsigned int)res.a0);
@@ -462,6 +558,7 @@ static int svc_normal_to_secure_thread(void *data)
 							  pdata, cbdata);
 				break;
 			case COMMAND_RECONFIG_STATUS:
+			case COMMAND_POLL_SERVICE_STATUS:
 				svc_thread_cmd_config_status(ctrl,
 							     pdata, cbdata);
 				break;
@@ -472,14 +569,31 @@ static int svc_normal_to_secure_thread(void *data)
 			break;
 		case INTEL_SIP_SMC_STATUS_REJECTED:
 			pr_debug("%s: STATUS_REJECTED\n", __func__);
+			/* for FPGA crypto service */
+			switch (pdata->command) {
+			case COMMAND_FCS_REQUEST_SERVICE:
+			case COMMAND_FCS_SEND_CERTIFICATE:
+			case COMMAND_FCS_GET_PROVISION_DATA:
+			case COMMAND_FCS_DATA_ENCRYPTION:
+			case COMMAND_FCS_DATA_DECRYPTION:
+			case COMMAND_FCS_RANDOM_NUMBER_GEN:
+				cbdata->status = BIT(SVC_STATUS_INVALID_PARAM);
+				cbdata->kaddr1 = NULL;
+				cbdata->kaddr2 = NULL;
+				cbdata->kaddr3 = NULL;
+				pdata->chan->scl->receive_cb(pdata->chan->scl,
+							     cbdata);
+				break;
+			}
 			break;
 		case INTEL_SIP_SMC_STATUS_ERROR:
 		case INTEL_SIP_SMC_RSU_ERROR:
 			pr_err("%s: STATUS_ERROR\n", __func__);
 			cbdata->status = BIT(SVC_STATUS_ERROR);
-			cbdata->kaddr1 = NULL;
-			cbdata->kaddr2 = NULL;
-			cbdata->kaddr3 = NULL;
+			cbdata->kaddr1 = &res.a1;
+			cbdata->kaddr2 = (res.a2) ?
+				svc_pa_to_va(res.a2) : NULL;
+			cbdata->kaddr3 = (res.a3) ? &res.a3 : NULL;
 			pdata->chan->scl->receive_cb(pdata->chan->scl, cbdata);
 			break;
 		default:
@@ -503,7 +617,7 @@ static int svc_normal_to_secure_thread(void *data)
 			break;
 
 		}
-	}
+	};
 
 	kfree(cbdata);
 	kfree(pdata);
@@ -845,15 +959,25 @@ int stratix10_svc_send(struct stratix10_svc_chan *chan, void *msg)
 		list_for_each_entry(p_mem, &svc_data_mem, node)
 			if (p_mem->vaddr == p_msg->payload) {
 				p_data->paddr = p_mem->paddr;
+				p_data->size = p_msg->payload_length;
 				break;
 			}
+		if (p_msg->payload_output) {
+			list_for_each_entry(p_mem, &svc_data_mem, node)
+				if (p_mem->vaddr == p_msg->payload_output) {
+					p_data->paddr_output =
+						p_mem->paddr;
+					p_data->size_output =
+						p_msg->payload_length_output;
+					break;
+				}
+		}
 	}
 
 	p_data->command = p_msg->command;
 	p_data->arg[0] = p_msg->arg[0];
 	p_data->arg[1] = p_msg->arg[1];
 	p_data->arg[2] = p_msg->arg[2];
-	p_data->size = p_msg->payload_length;
 	p_data->chan = chan;
 	pr_debug("%s: put to FIFO pa=0x%016x, cmd=%x, size=%u\n", __func__,
 	       (unsigned int)p_data->paddr, p_data->command,
@@ -949,6 +1073,7 @@ void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 			break;
 		}
 
+	memset(kaddr, 0, size);
 	gen_pool_free(chan->ctrl->genpool, (unsigned long)kaddr, size);
 	pmem->vaddr = NULL;
 	list_del(&pmem->node);
@@ -1029,6 +1154,11 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 	chans[1].name = SVC_CLIENT_RSU;
 	spin_lock_init(&chans[1].lock);
 
+	chans[2].scl = NULL;
+	chans[2].ctrl = controller;
+	chans[2].name = SVC_CLIENT_FCS;
+	spin_lock_init(&chans[2].lock);
+
 	list_add_tail(&controller->node, &svc_ctrl);
 	platform_set_drvdata(pdev, controller);
 
@@ -1048,6 +1178,19 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 		platform_device_put(svc->stratix10_svc_rsu);
 		return ret;
 	}
+
+	svc->intel_svc_fcs = platform_device_alloc(INTEL_FCS, 1);
+	if (!svc->intel_svc_fcs) {
+		dev_err(dev, "failed to allocate %s device\n", INTEL_FCS);
+		return -ENOMEM;
+	}
+
+	ret = platform_device_add(svc->intel_svc_fcs);
+	if (ret) {
+		platform_device_put(svc->intel_svc_fcs);
+		return ret;
+	}
+
 	dev_set_drvdata(dev, svc);
 
 	pr_info("Intel Service Layer Driver Initialized\n");
@@ -1060,6 +1203,7 @@ static int stratix10_svc_drv_remove(struct platform_device *pdev)
 	struct stratix10_svc *svc = dev_get_drvdata(&pdev->dev);
 	struct stratix10_svc_controller *ctrl = platform_get_drvdata(pdev);
 
+	platform_device_unregister(svc->intel_svc_fcs);
 	platform_device_unregister(svc->stratix10_svc_rsu);
 
 	kfifo_free(&ctrl->svc_fifo);
diff --git a/include/linux/firmware/intel/stratix10-smc.h b/include/linux/firmware/intel/stratix10-smc.h
index c3e5ab0..07d6345 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -321,8 +321,6 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 #define INTEL_SIP_SMC_ECC_DBE \
 	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_ECC_DBE)
 
-#endif
-
 /**
  * Request INTEL_SIP_SMC_RSU_NOTIFY
  *
@@ -404,3 +402,148 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 #define INTEL_SIP_SMC_FUNCID_RSU_MAX_RETRY 18
 #define INTEL_SIP_SMC_RSU_MAX_RETRY \
 	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_RSU_MAX_RETRY)
+
+/**
+ * Request INTEL_SIP_SMC_SERVICE_COMPLETED
+ * Sync call to check if the secure world have completed service request
+ * or not.
+ *
+ * Call register usage:
+ * a0: INTEL_SIP_SMC_SERVICE_COMPLETED
+ * a1: this register is optional. If used, it is the physical address for
+ *     secure firmware to put output data
+ * a2: this register is optional. If used, it is the size of output data
+ * a3-a7: not used
+ *
+ * Return status:
+ * a0: INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_STATUS_ERROR,
+ *     INTEL_SIP_SMC_REJECTED or INTEL_SIP_SMC_STATUS_BUSY
+ * a1: mailbox error if a0 is INTEL_SIP_SMC_STATUS_ERROR
+ * a2: physical address containing the process info
+ *     for FCS certificate -- the data contains the certificate status
+ *     for FCS cryption -- the data contains the actual data size FW processes
+ * a3: output data size
+ */
+#define INTEL_SIP_SMC_FUNCID_SERVICE_COMPLETED 30
+#define INTEL_SIP_SMC_SERVICE_COMPLETED \
+	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_SERVICE_COMPLETED)
+
+/**
+ * SMC call protocol for Mailbox, starting FUNCID from 60
+ */
+#define INTEL_SIP_SMC_FUNCID_MBOX_SEND_CMD 60
+	#define INTEL_SIP_SMC_MBOX_SEND_CMD \
+	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_MBOX_SEND_CMD)
+
+/**
+ * SMC call protocol for FPGA Crypto Service (FCS)
+ * FUNCID starts from 90
+ */
+
+/**
+ * Request INTEL_SIP_SMC_FCS_RANDOM_NUMBER
+ *
+ * Sync call used to query the random number generated by the firmware
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_FCS_RANDOM_NUMBER
+ * a1 the physical address for firmware to write generated random data
+ * a2-a7 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_FCS_ERROR or
+ *      INTEL_SIP_SMC_FCS_REJECTED
+ * a1 mailbox error
+ * a2 the physical address of generated random number
+ * a3 size
+ */
+#define INTEL_SIP_SMC_FUNCID_FCS_RANDOM_NUMBER 90
+#define INTEL_SIP_SMC_FCS_RANDOM_NUMBER \
+	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_RANDOM_NUMBER)
+
+/**
+ * Request INTEL_SIP_SMC_FCS_CRYPTION
+ * Async call for data encryption and HMAC signature generation, or for
+ * data decryption and HMAC verification.
+ *
+ * Call INTEL_SIP_SMC_SERVICE_COMPLETED to get the output encrypted or
+ * decrypted data
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_FCS_CRYPTION
+ * a1 cryption mode (1 for encryption and 0 for decryption)
+ * a2 physical address which stores to be encrypted or decrypted data
+ * a3 input data size
+ * a4 physical address which will hold the encrypted or decrypted output data
+ * a5 output data size
+ * a6-a7 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_STATUS_ERROR or
+ *      INTEL_SIP_SMC_STATUS_REJECTED
+ * a1-3 not used
+ */
+#define INTEL_SIP_SMC_FUNCID_FCS_CRYPTION 91
+#define INTEL_SIP_SMC_FCS_CRYPTION \
+	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_CRYPTION)
+
+/**
+ * Request INTEL_SIP_SMC_FCS_SERVICE_REQUEST
+ * Async call for authentication service of HPS software
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_FCS_SERVICE_REQUEST
+ * a1 the physical address of data block
+ * a2 size of data block
+ * a3-a7 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_ERROR or
+ *      INTEL_SIP_SMC_REJECTED
+ * a1-a3 not used
+ */
+#define INTEL_SIP_SMC_FUNCID_FCS_SERVICE_REQUEST 92
+#define INTEL_SIP_SMC_FCS_SERVICE_REQUEST \
+	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_SERVICE_REQUEST)
+
+/**
+ * Request INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE
+ * Sync call to send a signed certificate
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_FCS_SEND_CERTIFICATE
+ * a1 the physical address of CERTIFICATE block
+ * a2 size of data block
+ * a3-a7 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK or INTEL_SIP_SMC_FCS_REJECTED
+ * a1-a3 not used
+ */
+#define INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE 93
+#define INTEL_SIP_SMC_FCS_SEND_CERTIFICATE \
+	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE)
+
+/**
+ * Request INTEL_SIP_SMC_FCS_GET_PROVISION_DATA
+ * Sync call to dump all the fuses and key hashes
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_FCS_GET_PROVISION_DATA
+ * a1 the physical address for firmware to write structure of fuse and
+ *    key hashes
+ * a2-a7 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_FCS_ERROR or
+ *      INTEL_SIP_SMC_FCS_REJECTED
+ * a1 mailbox error
+ * a2 physical address for the structure of fuse and key hashes
+ * a3 the size of structure
+ *
+ */
+#define INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA 94
+#define INTEL_SIP_SMC_FCS_GET_PROVISION_DATA \
+	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA)
+
+#endif
diff --git a/include/linux/firmware/intel/stratix10-svc-client.h b/include/linux/firmware/intel/stratix10-svc-client.h
index a93d859..d858cf0 100644
--- a/include/linux/firmware/intel/stratix10-svc-client.h
+++ b/include/linux/firmware/intel/stratix10-svc-client.h
@@ -11,9 +11,11 @@
  *
  * fpga: for FPGA configuration
  * rsu: for remote status update
+ * fcs: for FPGA crypto service
  */
 #define SVC_CLIENT_FPGA			"fpga"
 #define SVC_CLIENT_RSU			"rsu"
+#define SVC_CLIENT_FCS			"fcs"
 
 /**
  * Status of the sent command, in bit number
@@ -41,6 +43,9 @@
  * SVC_STATUS_NO_SUPPORT:
  * Secure firmware doesn't support requested features such as RSU retry
  * or RSU notify.
+ *
+ * SVC_STATUS_INVALID_PARAM:
+ * Request received by secure firmware has invalid parameter(s).
  */
 #define SVC_STATUS_OK			0
 #define SVC_STATUS_BUFFER_SUBMITTED	1
@@ -49,6 +54,7 @@
 #define SVC_STATUS_BUSY			4
 #define SVC_STATUS_ERROR		5
 #define SVC_STATUS_NO_SUPPORT		6
+#define SVC_STATUS_INVALID_PARAM	7
 
 /**
  * Flag bit for COMMAND_RECONFIG
@@ -66,6 +72,8 @@
 #define SVC_RECONFIG_REQUEST_TIMEOUT_MS         300
 #define SVC_RECONFIG_BUFFER_TIMEOUT_MS          720
 #define SVC_RSU_REQUEST_TIMEOUT_MS              300
+#define SVC_FCS_REQUEST_TIMEOUT_MS		2000
+#define SVC_COMPLETED_TIMEOUT_MS		30000
 
 struct stratix10_svc_chan;
 
@@ -104,6 +112,27 @@ struct stratix10_svc_chan;
  *
  * @COMMAND_RSU_DCMF_VERSION: query firmware for the DCMF version, return status
  * is SVC_STATUS_OK or SVC_STATUS_ERROR
+ *
+ * @COMMAND_FCS_REQUEST_SERVICE: request validation of image from firmware,
+ * return status is SVC_STATUS_OK, SVC_STATUS_INVALID_PARAM
+ *
+ * @COMMAND_FCS_SEND_CERTIFICATE: send a certificate, return status is
+ * SVC_STATUS_OK, SVC_STATUS_INVALID_PARAM, SVC_STATUS_ERROR
+ *
+ * @COMMAND_FCS_GET_PROVISION_DATA: read the provisioning data, return status is
+ * SVC_STATUS_OK, SVC_STATUS_INVALID_PARAM, SVC_STATUS_ERROR
+ *
+ * @COMMAND_FCS_DATA_ENCRYPTION: encrypt the data, return status is
+ * SVC_STATUS_OK, SVC_STATUS_INVALID_PARAM, SVC_STATUS_ERROR
+ *
+ * @COMMAND_FCS_DATA_DECRYPTION: decrypt the data, return status is
+ * SVC_STATUS_OK, SVC_STATUS_INVALID_PARAM, SVC_STATUS_ERROR
+ *
+ * @COMMAND_FCS_RANDOM_NUMBER_GEN: generate a random number, return status
+ * is SVC_STATUS_OK, SVC_STATUS_ERROR
+ *
+ * @COMMAND_POLL_SERVICE_STATUS: poll if the service request is complete,
+ * return statis is SVC_STATUS_OK, SVC_STATUS_ERROR or SVC_STATUS_BUSY
  */
 enum stratix10_svc_command_code {
 	COMMAND_NOOP = 0,
@@ -117,18 +146,31 @@ enum stratix10_svc_command_code {
 	COMMAND_RSU_RETRY,
 	COMMAND_RSU_MAX_RETRY,
 	COMMAND_RSU_DCMF_VERSION,
+	/* for FPGA crypto service */
+	COMMAND_FCS_REQUEST_SERVICE = 20,
+	COMMAND_FCS_SEND_CERTIFICATE,
+	COMMAND_FCS_GET_PROVISION_DATA,
+	COMMAND_FCS_DATA_ENCRYPTION,
+	COMMAND_FCS_DATA_DECRYPTION,
+	COMMAND_FCS_RANDOM_NUMBER_GEN,
+	/* for general service status poll */
+	COMMAND_POLL_SERVICE_STATUS = 40,
 };
 
 /**
  * struct stratix10_svc_client_msg - message sent by client to service
  * @payload: starting address of data need be processed
  * @payload_length: data size in bytes
+ * @payload_output: starting address of the processed data
+ * payload_length_output: the processed data size in bytes
  * @command: service command
  * @arg: args to be passed via registers and not physically mapped buffers
  */
 struct stratix10_svc_client_msg {
 	void *payload;
 	size_t payload_length;
+	void *payload_output;
+	size_t payload_length_output;
 	enum stratix10_svc_command_code command;
 	u64 arg[3];
 };
-- 
2.7.4

