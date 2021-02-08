Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15ABC433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D4A64E37
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhBHJuu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhBHJrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C4C061224;
        Mon,  8 Feb 2021 01:45:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gb24so1477434pjb.4;
        Mon, 08 Feb 2021 01:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aDBTv2B+LhvFEC7t2eWQQe9AxBbS9DBJDy7E87hqcXE=;
        b=siJ6+j8TuHgDILZggavh5bKrmcVso9V+EBRwMeeZBwBrea4nkgUsYTQm1RTHLq1KoN
         Obra3nYLNldthT/AfV7hdQRVpLcHWmnpgrD7KJm4b6e6lQSjCI52FxEaoNAqmCaOWlvI
         Q09VINQkGZbnx/xkAoe1zNnKhX8/dsTUNJnTNnuUUHkkd8qDFB/7aaLaIwmgBT+cd4no
         Q+nhjB+0QoN5TwCSkeLGynmevXifLsrIU4udSKIKBowB2kGbZDcPqvYFSQyYmszBCBhz
         +p9+2T6AKAswBrizpMYAwQaEPc96XJTNyeMxZpvZHoeAsOwVun2roxy/RLt/d13MQ0Aj
         EDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDBTv2B+LhvFEC7t2eWQQe9AxBbS9DBJDy7E87hqcXE=;
        b=LmS7y2okpdvWXCyPK4YxfMdhCjN6VQnPbQ9OAv/YmWB2KLSFAlAZV1zWyog14FmxvD
         q0Ukrd2gGN2wOKp/l394Se9AbDo/lX24FfYee7Z0aYHYXm6jzxKeFnJr24/Pf7QTIN2Y
         cnjgySfeOanfboUzhddXCSulIDVs91H9oK8bYF0VcIQH1Q/wMTflmkgvrpmaDuJc9pQV
         vRLF7bNBqJwWYxW9nF0eGqnquPoI1eS7uwFXYYrhMh4nSpwP557vALIEN3VM5wW7T+tM
         ajgk9UD5hUD5vhyKdtDpDinSpfrC0TeWWKDLXCkC44MejpX2Cw95Ibv0XBItKUaXCRSd
         j8qw==
X-Gm-Message-State: AOAM5329NImd7+NcgQVkqViQ5SwsNib2Yb4voeNmpSVWkxEBVSuVcGY1
        3J4uzXet/V9LWNYxnFhv5v4=
X-Google-Smtp-Source: ABdhPJxf3z3n4GRmAZfL3s3LnsJiJbV2V9TBn5IKSqsdt1d6mYm9/Bg+uMj03RdKwhNpQ6MSn3ZYSg==
X-Received: by 2002:a17:90a:8e82:: with SMTP id f2mr16056920pjo.234.1612777514096;
        Mon, 08 Feb 2021 01:45:14 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:45:13 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v5 14/19] crypto: qat: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:33 +0530
Message-Id: <20210208094238.571015-15-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c               |  5 ++---
 drivers/crypto/qat/qat_common/adf_sriov.c             | 10 +++++-----
 drivers/crypto/qat/qat_common/adf_transport.c         |  4 ++--
 .../crypto/qat/qat_common/adf_transport_internal.h    |  2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c            | 11 +++++------
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index c45853463530..50b4dcd49753 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -244,9 +244,8 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 	int i;
 
 	for (i = 0; i < hw_data->num_banks; i++)
-		tasklet_init(&priv_data->banks[i].resp_handler,
-			     adf_response_handler,
-			     (unsigned long)&priv_data->banks[i]);
+		tasklet_setup(&priv_data->banks[i].resp_handler,
+			      adf_response_handler);
 	return 0;
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 8c822c2861c2..748f81294fb5 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -24,9 +24,10 @@ static void adf_iov_send_resp(struct work_struct *work)
 	kfree(pf2vf_resp);
 }
 
-static void adf_vf2pf_bh_handler(void *data)
+static void adf_vf2pf_bh_handler(struct tasklet_struct *t)
 {
-	struct adf_accel_vf_info *vf_info = (struct adf_accel_vf_info *)data;
+	struct adf_accel_vf_info *vf_info =
+				from_tasklet(vf_info, t, vf2pf_bh_tasklet);
 	struct adf_pf2vf_resp *pf2vf_resp;
 
 	pf2vf_resp = kzalloc(sizeof(*pf2vf_resp), GFP_ATOMIC);
@@ -52,9 +53,8 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		vf_info->accel_dev = accel_dev;
 		vf_info->vf_nr = i;
 
-		tasklet_init(&vf_info->vf2pf_bh_tasklet,
-			     (void *)adf_vf2pf_bh_handler,
-			     (unsigned long)vf_info);
+		tasklet_setup(&vf_info->vf2pf_bh_tasklet,
+			      adf_vf2pf_bh_handler);
 		mutex_init(&vf_info->pf2vf_lock);
 		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
 				     DEFAULT_RATELIMIT_INTERVAL,
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 5a7030acdc33..03dcbeac25d7 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -324,9 +324,9 @@ static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
 		adf_handle_response(&bank->rings[i]);
 }
 
-void adf_response_handler(uintptr_t bank_addr)
+void adf_response_handler(struct tasklet_struct *t)
 {
-	struct adf_etr_bank_data *bank = (void *)bank_addr;
+	struct adf_etr_bank_data *bank = from_tasklet(bank, t, resp_handler);
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(bank->accel_dev);
 
 	/* Handle all the responses and reenable IRQs */
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index 501bcf0f1809..aaec7b2bc220 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -46,7 +46,7 @@ struct adf_etr_data {
 	struct dentry *debug;
 };
 
-void adf_response_handler(uintptr_t bank_addr);
+void adf_response_handler(struct tasklet_struct *t);
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 int adf_bank_debugfs_add(struct adf_etr_bank_data *bank);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 38d316a42ba6..1d0ff58fd9b5 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -68,9 +68,10 @@ static void adf_dev_stop_async(struct work_struct *work)
 	kfree(stop_data);
 }
 
-static void adf_pf2vf_bh_handler(void *data)
+static void adf_pf2vf_bh_handler(struct tasklet_struct *t)
 {
-	struct adf_accel_dev *accel_dev = data;
+	struct adf_accel_dev *accel_dev = from_tasklet(accel_dev, t,
+						       vf.pf2vf_bh_tasklet);
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
@@ -138,8 +139,7 @@ static void adf_pf2vf_bh_handler(void *data)
 
 static int adf_setup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 {
-	tasklet_init(&accel_dev->vf.pf2vf_bh_tasklet,
-		     (void *)adf_pf2vf_bh_handler, (unsigned long)accel_dev);
+	tasklet_setup(&accel_dev->vf.pf2vf_bh_tasklet, adf_pf2vf_bh_handler);
 
 	mutex_init(&accel_dev->vf.vf2pf_lock);
 	return 0;
@@ -216,8 +216,7 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 {
 	struct adf_etr_data *priv_data = accel_dev->transport;
 
-	tasklet_init(&priv_data->banks[0].resp_handler, adf_response_handler,
-		     (unsigned long)priv_data->banks);
+	tasklet_setup(&priv_data->banks[0].resp_handler, adf_response_handler);
 	return 0;
 }
 
-- 
2.25.1

