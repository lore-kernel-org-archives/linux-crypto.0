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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBB5C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3188A206FA
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbhAUEoy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732044AbhAUEnh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:43:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E225BC061757;
        Wed, 20 Jan 2021 20:42:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m5so800247pjv.5;
        Wed, 20 Jan 2021 20:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qp9LBDTmnPZcn3zbp0ts8Zh1JyTpVMJr9nqNyHr6PFs=;
        b=o/lkqyQFzs4RW/ABushd5cU3kQqz7E7fIT81eyzErV+QAgEJY6dGrscoZ3gFte+H41
         owcmN/qzhGHjLzwF8A6OSyvAyYflWMrxM6jdvQIl3jeNB9nemBQtFFozFcaJUDmDZQEI
         KglKxLIlti4D8ZajrrLab+uRm+kLkcj/T5actvFG59pi3EpNjUVLLVRYUUTg+4llPtdk
         ua10pw/atw5AQHJEjdCuAGvnEyqAuanMTrJ21AwpOUIljw7o37D0LockJH2oMGGdrBiY
         0248Im7oGZSr+M37u8gJO9mzV32nqbxBJM7Ys5LP3pqaCiyL5Xx962skK9n3TSQQAyFy
         yIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qp9LBDTmnPZcn3zbp0ts8Zh1JyTpVMJr9nqNyHr6PFs=;
        b=tnUpKXpGk2I+hMEW3X6PuiRDD3oFYhvMadDZvgnsRCTP5Gh64xqJSXuaAomHPbJ9CQ
         gYwnT29cYOVRuttO5gLhLZ3HJ/NogIKb7wS95cAuF1qcuG7qUMApEriGCVOVCn0T4rvb
         UNN2ITV53dAmFfSf0xfUBqaX1laKfBuA24BBC6vEwGZ6VbaSyNUmFatb0iOEHQQbG5ef
         ukQZ3iq9n2m0UYG5aGGdeF+DQD+RtA4uV1D+FvdQrCis7lCTXTtaazU9xzGjO7tcae2H
         qQb1GmJJfnLe45ZlYEMOXVkBDfOF+Vyiixwz2D6KUsriRNndheAvEyCeEqvqRa+nzUfO
         3z5g==
X-Gm-Message-State: AOAM532hTpOazg0ISO9mAWL0brsmvRAt4P3Gqw/04bQHkB/FaWJCHp9K
        njX6SQeTLoxJqxnpifim5BA=
X-Google-Smtp-Source: ABdhPJylCAvW3LVkG69kqT8x4LlWGA1fRRD/pBOTSoyitwyxD0N4zC7hjGUBGUhnQRnL3TdYZ3CEaQ==
X-Received: by 2002:a17:902:ff06:b029:de:362c:bd0b with SMTP id f6-20020a170902ff06b02900de362cbd0bmr12827667plj.13.1611204161491;
        Wed, 20 Jan 2021 20:42:41 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:42:40 -0800 (PST)
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
Subject: [PATCH v4 05/19] crypto: cavium: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:12 +0530
Message-Id: <20210121044126.152274-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121044126.152274-1-allen.lkml@gmail.com>
References: <20210121044126.152274-1-allen.lkml@gmail.com>
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
 drivers/crypto/cavium/cpt/cptvf_main.c       |  9 ++++-----
 drivers/crypto/cavium/nitrox/nitrox_common.h |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c    | 13 +++++--------
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c |  4 ++--
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index f016448e43bb..6424bcc74139 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -21,10 +21,10 @@ struct cptvf_wqe_info {
 	struct cptvf_wqe vq_wqe[CPT_NUM_QS_PER_VF];
 };
 
-static void vq_work_handler(unsigned long data)
+static void vq_work_handler(struct tasklet_struct *t)
 {
-	struct cptvf_wqe_info *cwqe_info = (struct cptvf_wqe_info *)data;
-	struct cptvf_wqe *cwqe = &cwqe_info->vq_wqe[0];
+	struct cptvf_wqe *cwqe = from_tasklet(cwqe, t, twork);
+	struct cptvf_wqe_info *cwqe_info = container_of(cwqe, typeof(*cwqe_info), vq_wqe[0]);
 
 	vq_post_process(cwqe->cptvf, cwqe->qno);
 }
@@ -45,8 +45,7 @@ static int init_worker_threads(struct cpt_vf *cptvf)
 	}
 
 	for (i = 0; i < cptvf->nr_queues; i++) {
-		tasklet_init(&cwqe_info->vq_wqe[i].twork, vq_work_handler,
-			     (u64)cwqe_info);
+		tasklet_setup(&cwqe_info->vq_wqe[i].twork, vq_work_handler);
 		cwqe_info->vq_wqe[i].qno = i;
 		cwqe_info->vq_wqe[i].cptvf = cptvf;
 	}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_common.h b/drivers/crypto/cavium/nitrox/nitrox_common.h
index e4be69d7e6e5..f73ae8735272 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_common.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_common.h
@@ -19,7 +19,7 @@ void nitrox_put_device(struct nitrox_device *ndev);
 int nitrox_common_sw_init(struct nitrox_device *ndev);
 void nitrox_common_sw_cleanup(struct nitrox_device *ndev);
 
-void pkt_slc_resp_tasklet(unsigned long data);
+void pkt_slc_resp_tasklet(struct tasklet_struct *t);
 int nitrox_process_se_request(struct nitrox_device *ndev,
 			      struct se_crypto_request *req,
 			      completion_t cb,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index 99b053094f5a..c6fb8b3263e1 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -201,9 +201,9 @@ static void clear_bmi_err_intr(struct nitrox_device *ndev)
 	dev_err_ratelimited(DEV(ndev), "BMI_INT  0x%016llx\n", value);
 }
 
-static void nps_core_int_tasklet(unsigned long data)
+static void nps_core_int_tasklet(struct tasklet_struct *t)
 {
-	struct nitrox_q_vector *qvec = (void *)(uintptr_t)(data);
+	struct nitrox_q_vector *qvec = from_tasklet(qvec, t, resp_tasklet);
 	struct nitrox_device *ndev = qvec->ndev;
 
 	/* if pf mode do queue recovery */
@@ -343,8 +343,7 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
 		cpu = qvec->ring % num_online_cpus();
 		irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-		tasklet_init(&qvec->resp_tasklet, pkt_slc_resp_tasklet,
-			     (unsigned long)qvec);
+		tasklet_setup(&qvec->resp_tasklet, pkt_slc_resp_tasklet);
 		qvec->valid = true;
 	}
 
@@ -364,8 +363,7 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
 	cpu = num_online_cpus();
 	irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
-		     (unsigned long)qvec);
+	tasklet_setup(&qvec->resp_tasklet, nps_core_int_tasklet);
 	qvec->valid = true;
 
 	return 0;
@@ -442,8 +440,7 @@ int nitrox_sriov_register_interupts(struct nitrox_device *ndev)
 	cpu = num_online_cpus();
 	irq_set_affinity_hint(vec, get_cpu_mask(cpu));
 
-	tasklet_init(&qvec->resp_tasklet, nps_core_int_tasklet,
-		     (unsigned long)qvec);
+	tasklet_setup(&qvec->resp_tasklet, nps_core_int_tasklet);
 	qvec->valid = true;
 
 	return 0;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 53ef06792133..676f3d00bf61 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -580,9 +580,9 @@ static void process_response_list(struct nitrox_cmdq *cmdq)
 /**
  * pkt_slc_resp_tasklet - post processing of SE responses
  */
-void pkt_slc_resp_tasklet(unsigned long data)
+void pkt_slc_resp_tasklet(struct tasklet_struct *t)
 {
-	struct nitrox_q_vector *qvec = (void *)(uintptr_t)(data);
+	struct nitrox_q_vector *qvec = from_tasklet(qvec, t, resp_tasklet);
 	struct nitrox_cmdq *cmdq = qvec->cmdq;
 	union nps_pkt_slc_cnts slc_cnts;
 
-- 
2.25.1

