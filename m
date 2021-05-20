Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B4FC43461
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 09:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D76E61606
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 09:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhETJg1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhETJe0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 05:34:26 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEE7C0612A4
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 02:27:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 62so7712360wmb.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 02:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vcq3anHnSeSLpEDPgaw2WlJt773i7Ai6CVK22immmrg=;
        b=Z9JdVvLS9muvINy9rohhP2YBdp+KBjFplNimDfPxaQrph6GTa6oJ5frvs/IkDw/AJL
         gTTvcwja0cIkTbh2EYo1ATdpmVKVO83cCBL6PRxpEb1PNLRdEpOjAeYWmwIJIi6vGeA4
         bR0G6/S+EQMGR5qzX861aXnQQbT21wU+qk7h3AGbz+ABzYkX7fSjEhCaBf+9J39E5+o7
         4TC/IltnKBQJqSP5Cc8pC40EfEJwr9te4j+T0HumuZ21944FBefLDk4X6GLeKzy0a+uy
         RIwhif6SViRp2xT1TbC5XxJhumKjzrtqz4JYENP07tZo9RQ1SuaU6BxRgJWgZxHKTipJ
         8/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vcq3anHnSeSLpEDPgaw2WlJt773i7Ai6CVK22immmrg=;
        b=XInhqWDCrkISpjEyD/G6ZkRRtrAoPeLIlb+hNkaLP0ptqknO2QmsBpoeq5n96VeJlg
         /8CK11dZhuRAtzBxtTSjs+NTxl2NOy8W09rx5W+mxbyaeHHP8+5yrmeDE4LmK+DcbsWG
         vXgglJUR/wJZe2kdRZOdeX/HiyGSS6twsgb96cWgD8r74tBO3gG4t8d3afkewyOZDyYv
         GmEnf3/aSPeAc/U3Cy8NEtst6OLkNu9QNZPveBGG4h550HFvPMNTR85UaDLAp18O9sQG
         K4Iq/ndHVM48OLi6kzjaya+D7yRCIwwHbSpjt0MRcAjjwjNrQwyQD6DoMhx65XnGi9CI
         XAiQ==
X-Gm-Message-State: AOAM5314ZbD0/4etuheieibqRNJUKOHQCsSnJTFuj+ZHw6tO1PmtJUu1
        4WfckXOsNzB3ABFM/fSN1lC+4Q==
X-Google-Smtp-Source: ABdhPJx729hK29beb50o3uS4oYe550wD6Jv1xdh+11VEeWP4brJbb+3hKjfjIueSqYr017+zORZnXw==
X-Received: by 2002:a7b:c052:: with SMTP id u18mr3097847wmc.105.1621502857275;
        Thu, 20 May 2021 02:27:37 -0700 (PDT)
Received: from dell.default ([91.110.221.215])
        by smtp.gmail.com with ESMTPSA id u11sm722971wrw.14.2021.05.20.02.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 02:27:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] crypto: cavium: Fix a bunch of kernel-doc related issues
Date:   Thu, 20 May 2021 10:27:31 +0100
Message-Id: <20210520092733.3434378-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092733.3434378-1-lee.jones@linaro.org>
References: <20210520092733.3434378-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/cavium/nitrox/nitrox_main.c:41: warning: cannot understand function prototype: 'const struct pci_device_id nitrox_pci_tbl[] = '
 drivers/crypto/cavium/nitrox/nitrox_main.c:73: warning: Function parameter or member 'ndev' not described in 'write_to_ucd_unit'
 drivers/crypto/cavium/nitrox/nitrox_main.c:73: warning: Function parameter or member 'ucode_size' not described in 'write_to_ucd_unit'
 drivers/crypto/cavium/nitrox/nitrox_main.c:73: warning: Function parameter or member 'ucode_data' not described in 'write_to_ucd_unit'
 drivers/crypto/cavium/nitrox/nitrox_main.c:73: warning: Function parameter or member 'block_num' not described in 'write_to_ucd_unit'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:46: warning: Function parameter or member 'index' not described in 'incr_index'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:46: warning: Function parameter or member 'count' not described in 'incr_index'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:46: warning: Function parameter or member 'max' not described in 'incr_index'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:46: warning: expecting prototype for Response codes from SE microcode(). Prototype was for incr_index() instead
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:287: warning: Function parameter or member 'cmdq' not described in 'post_se_instr'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:381: warning: Function parameter or member 'callback' not described in 'nitrox_process_se_request'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:381: warning: Function parameter or member 'cb_arg' not described in 'nitrox_process_se_request'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:381: warning: expecting prototype for nitrox_se_request(). Prototype was for nitrox_process_se_request() instead
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:535: warning: Function parameter or member 'cmdq' not described in 'process_response_list'
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:535: warning: expecting prototype for process_request_list(). Prototype was for process_response_list() instead
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:584: warning: Function parameter or member 'data' not described in 'pkt_slc_resp_tasklet'
 drivers/crypto/cavium/nitrox/nitrox_mbx.c:14: warning: cannot understand function prototype: 'enum mbx_msg_type '
 drivers/crypto/cavium/nitrox/nitrox_mbx.c:24: warning: cannot understand function prototype: 'enum mbx_msg_opcode '
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c:26: warning: cannot understand function prototype: 'const struct nitrox_cipher flexi_cipher_table[] = '
 drivers/crypto/cavium/cpt/cptpf_main.c:411: warning: Function parameter or member 'cpt' not described in 'cpt_unload_microcode'
 drivers/crypto/cavium/cpt/cptpf_main.c:411: warning: expecting prototype for Ensure all cores are disengaged from all groups by(). Prototype was for cpt_unload_microcode() instead
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c:17: warning: Function parameter or member 'q' not described in 'get_free_pending_entry'
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c:17: warning: Function parameter or member 'qlen' not described in 'get_free_pending_entry'

Cc: George Cherian <gcherian@marvell.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/cavium/cpt/cptpf_main.c         |  2 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c   |  4 ++--
 drivers/crypto/cavium/nitrox/nitrox_main.c     |  4 ++--
 drivers/crypto/cavium/nitrox/nitrox_mbx.c      |  4 ++--
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c   | 12 +++++++-----
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c |  2 +-
 6 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 06ee42e8a2458..8c32d0eb8fcf2 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -401,7 +401,7 @@ static void cpt_disable_all_cores(struct cpt_device *cpt)
 	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0), 0);
 }
 
-/**
+/*
  * Ensure all cores are disengaged from all groups by
  * calling cpt_disable_all_cores() before calling this
  * function.
diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index feb0f76783dda..153004bdfb5cd 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -9,8 +9,8 @@
 
 /**
  * get_free_pending_entry - get free entry from pending queue
- * @param pqinfo: pending_qinfo structure
- * @param qno: queue number
+ * @q: pending queue
+ * @qlen: queue length
  */
 static struct pending_entry *get_free_pending_entry(struct pending_queue *q,
 						    int qlen)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index d385daf2c71c3..144d554bd44dd 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -35,7 +35,7 @@ static LIST_HEAD(ndevlist);
 static DEFINE_MUTEX(devlist_lock);
 static unsigned int num_devices;
 
-/**
+/*
  * nitrox_pci_tbl - PCI Device ID Table
  */
 static const struct pci_device_id nitrox_pci_tbl[] = {
@@ -65,7 +65,7 @@ struct ucode {
 	u64 code[];
 };
 
-/**
+/*
  * write_to_ucd_unit - Write Firmware to NITROX UCD unit
  */
 static void write_to_ucd_unit(struct nitrox_device *ndev, u32 ucode_size,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index c1af9d4fca6e3..2e9c0d2143632 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -8,7 +8,7 @@
 
 #define RING_TO_VFNO(_x, _y)	((_x) / (_y))
 
-/**
+/*
  * mbx_msg_type - Mailbox message types
  */
 enum mbx_msg_type {
@@ -18,7 +18,7 @@ enum mbx_msg_type {
 	MBX_MSG_TYPE_NACK,
 };
 
-/**
+/*
  * mbx_msg_opcode - Mailbox message opcodes
  */
 enum mbx_msg_opcode {
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 4434c92d6229f..55c18da4a5007 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -19,7 +19,7 @@
 #define REQ_BACKLOG    2
 #define REQ_POSTED     3
 
-/**
+/*
  * Response codes from SE microcode
  * 0x00 - Success
  *   Completion with no error
@@ -279,6 +279,7 @@ static inline bool cmdq_full(struct nitrox_cmdq *cmdq, int qlen)
 /**
  * post_se_instr - Post SE instruction to Packet Input ring
  * @sr: Request structure
+ * @cmdq: Command queue structure
  *
  * Returns 0 if successful or a negative error code,
  * if no space in ring.
@@ -372,6 +373,8 @@ static int nitrox_enqueue_request(struct nitrox_softreq *sr)
  * nitrox_process_se_request - Send request to SE core
  * @ndev: NITROX device
  * @req: Crypto request
+ * @callback: Completion callback
+ * @cb_arg: Completion callback arguments
  *
  * Returns 0 on success, or a negative error code.
  */
@@ -526,9 +529,8 @@ static bool sr_completed(struct nitrox_softreq *sr)
 }
 
 /**
- * process_request_list - process completed requests
- * @ndev: N5 device
- * @qno: queue to operate
+ * process_response_list - process completed requests
+ * @cmdq: Command queue structure
  *
  * Returns the number of responses processed.
  */
@@ -578,7 +580,7 @@ static void process_response_list(struct nitrox_cmdq *cmdq)
 	}
 }
 
-/**
+/*
  * pkt_slc_resp_tasklet - post processing of SE responses
  */
 void pkt_slc_resp_tasklet(unsigned long data)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index a553ac65f3249..248b4fff1c729 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -20,7 +20,7 @@ struct nitrox_cipher {
 	enum flexi_cipher value;
 };
 
-/**
+/*
  * supported cipher list
  */
 static const struct nitrox_cipher flexi_cipher_table[] = {
-- 
2.31.1

