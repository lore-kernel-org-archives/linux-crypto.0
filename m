Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF90C1B0E3
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 082A9233A1
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgLGJBa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgLGJBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:30 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD18C0613D0
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:18 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id b5so3176131pjl.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4mCl+VG1quISRri67xJaj5KQFCDnCTzLaRrkOWH7JsU=;
        b=lnQ5v3UX2W2r/x/vQHyes6K9heq249ZpMufZCezzXxp4d3l6W96+iwRF5MVEXJrN6i
         ua1fA19fke3Qdvv2JTLeqx4d7pNgd0B35SlIuBVpQbF8B7OcIc+yRjr2vut2Ig1DKf7m
         34YaWpfsrEOpCNCC6+Is6FySQEf32A0QBIOsygJDkuOU2yFXOg0kv+bIfdp4g3zfJQJu
         EkXI9jvLARJAEBpbFzxiU+C+szZVXbI14ikJAIGdEUn42omWyH9GtPiG+b41c2xAXijX
         HwT3E1tsvL12TgnAImytds8DPV3N/jGrEafcFspFuHM8d3bVlxbW/KJHHKnOYFlXt1C9
         QFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mCl+VG1quISRri67xJaj5KQFCDnCTzLaRrkOWH7JsU=;
        b=SKeKQlZdhNXMaPIvP++Tj//Wwrhs+FcI+n6vzrzVZXIpIxjYXKKaHSrMDRrsaL6wKc
         XvuBhIyw9Uv9TucuiopnlsKudrY2UrA1fLTzNbfd6E82QYU5z1/31/S/FwFsE/WFs3hv
         gzXA3Zldgf+501tEOdMgaR/QJHcTPZ1jZS0xDGQHb9UqbpiBckzOuuUfLv23Fkfh2YgX
         Y02BEGi5AujMkHlofLgd4vZ9eEX67S7tRFHbUTX5mcmPzJvnRUpKxo7QXxzCAgJf2Ea0
         gkqje4ji8V/0iLz+sPP16oVv/MlIJ+1qiq3jBByfGNZSAm13qaL2KkxLrkd9aNAxhMBr
         Dc3A==
X-Gm-Message-State: AOAM531/mZCV2IHeUDmCKuFf4Q7vO0onZdcd7B602TTuJ/vfi0mRtn5Y
        CX3lpcCI5mxiSVrxwPmiZ54=
X-Google-Smtp-Source: ABdhPJyLsO9zc8jmQ5yZ74tnN7d4rzTrT/9FZk3hpbmLQCVW8ta4eNKtpJOEzuKc/61XrgpBnPzkdA==
X-Received: by 2002:a17:90b:4785:: with SMTP id hz5mr16116798pjb.157.1607331677750;
        Mon, 07 Dec 2020 01:01:17 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:17 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 14/19] crypto: qat: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:26 +0530
Message-Id: <20201207085931.661267-15-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c               |  5 ++---
 drivers/crypto/qat/qat_common/adf_sriov.c             | 10 +++++-----
 drivers/crypto/qat/qat_common/adf_transport.c         |  4 ++--
 .../crypto/qat/qat_common/adf_transport_internal.h    |  2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c            | 11 +++++------
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 36136f7db509..2c725c01ee4f 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -239,9 +239,8 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 	int i;
 
 	for (i = 0; i < hw_data->num_banks; i++)
-		tasklet_init(&priv_data->banks[i].resp_handler,
-			     adf_response_handler,
-			     (unsigned long)&priv_data->banks[i]);
+		tasklet_setup(&priv_data->banks[i].resp_handler,
+			     adf_response_handler);
 	return 0;
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 963b2bea78f2..f9e276cb6f23 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -49,9 +49,10 @@ static void adf_iov_send_resp(struct work_struct *work)
 	kfree(pf2vf_resp);
 }
 
-static void adf_vf2pf_bh_handler(void *data)
+static void adf_vf2pf_bh_handler(struct tasklet_struct *t)
 {
-	struct adf_accel_vf_info *vf_info = (struct adf_accel_vf_info *)data;
+	struct adf_accel_vf_info *vf_info =
+				 from_tasklet(vf_info, t, vf2pf_bh_tasklet);
 	struct adf_pf2vf_resp *pf2vf_resp;
 
 	pf2vf_resp = kzalloc(sizeof(*pf2vf_resp), GFP_ATOMIC);
@@ -81,9 +82,8 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		vf_info->accel_dev = accel_dev;
 		vf_info->vf_nr = i;
 
-		tasklet_init(&vf_info->vf2pf_bh_tasklet,
-			     (void *)adf_vf2pf_bh_handler,
-			     (unsigned long)vf_info);
+		tasklet_setup(&vf_info->vf2pf_bh_tasklet,
+			     adf_vf2pf_bh_handler);
 		mutex_init(&vf_info->pf2vf_lock);
 		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
 				     DEFAULT_RATELIMIT_INTERVAL,
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 2ad774017200..60982c67b466 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -297,9 +297,9 @@ static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
 	}
 }
 
-void adf_response_handler(uintptr_t bank_addr)
+void adf_response_handler(struct tasklet_struct *t)
 {
-	struct adf_etr_bank_data *bank = (void *)bank_addr;
+	struct adf_etr_bank_data *bank = from_tasklet(bank, t, resp_handler);
 
 	/* Handle all the responses and reenable IRQs */
 	adf_ring_response_handler(bank);
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index c7faf4e2d302..ff891f5bc783 100644
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
index c4a44dc6af3e..79c0d51ea263 100644
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
@@ -215,8 +215,7 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 {
 	struct adf_etr_data *priv_data = accel_dev->transport;
 
-	tasklet_init(&priv_data->banks[0].resp_handler, adf_response_handler,
-		     (unsigned long)priv_data->banks);
+	tasklet_setup(&priv_data->banks[0].resp_handler, adf_response_handler);
 	return 0;
 }
 
-- 
2.25.1

