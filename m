Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4DBC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Dec 2021 09:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348138AbhLAJF4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Dec 2021 04:05:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348068AbhLAJF4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Dec 2021 04:05:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B115qe3028997;
        Wed, 1 Dec 2021 01:02:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Wnt0F+5Jz/c03R5H+RYX4TDcvnORPvQQAM7q98ubNzw=;
 b=Bpo4YwTr/frENCIIgZ+/m4h0FgjJuyxQ0K2dJ1ivy2KvsPN1ZlsFr8OS8eSUYHcow/lB
 BvZMk52M2Xb+AlwTuurfvxmS9bzL3Lx2eWgI2Dc2/w6AkXmGjCLIlpunOnO5qNfG2zwa
 ktWWdC7OlbamBLG7TPSC9mKbeOue9R9/P7iLmlWFcpPIofWVyeoM1pjpaH2e6Ba5bnQ+
 W06weQ/n67FmLKnA3VhlJzib4ZnaxGz6ZMM+4IbmKfoZpIXOWssmHARbXOI48CosxuYv
 qbDRpD/IhOUERRvo7wVgytdJjBMLaC/lyIr8w44PZy5BGfc5DNrVxLp83Ftgyg+Oj96C Ig== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cnqvyugat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 01:02:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 1 Dec
 2021 01:02:27 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Dec 2021 01:02:27 -0800
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id D5F665B6924;
        Wed,  1 Dec 2021 01:02:24 -0800 (PST)
From:   Shijith Thotton <sthotton@marvell.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Srujana Challa <schalla@marvell.com>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <gcherian@marvell.com>,
        <ndabilpuram@marvell.com>, Shijith Thotton <sthotton@marvell.com>
Subject: [PATCH 2/2] crypto: octeontx2: parameters for custom engine groups
Date:   Wed, 1 Dec 2021 14:32:01 +0530
Message-ID: <aab2b236c5996f1271d2e73e5f79aa275b981a32.1638348922.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638348922.git.sthotton@marvell.com>
References: <cover.1638348922.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Y1YDXUKWWyzwvC5EIUkuUero2nb96fWq
X-Proofpoint-GUID: Y1YDXUKWWyzwvC5EIUkuUero2nb96fWq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

Added devlink parameters to create and delete custom CPT engine groups.

Example:
devlink dev param set pci/0002:20:00.0 name egrp_create value \
                "se:32;se.out" cmode runtime
devlink dev param set pci/0002:20:00.0 name egrp_delete value \
                "egrp:1" cmode runtime

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Shijith Thotton <sthotton@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
 .../marvell/octeontx2/otx2_cpt_common.h       |   1 +
 .../marvell/octeontx2/otx2_cpt_devlink.c      | 108 ++++++++++++++++++
 .../marvell/octeontx2/otx2_cpt_devlink.h      |  20 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   3 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |   9 ++
 6 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.h

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index c242d22008c3..965297e96954 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += rvu_cptpf.o rvu_cptvf.o
 
 rvu_cptpf-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
 		  otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o \
-		  cn10k_cpt.o
+		  cn10k_cpt.o otx2_cpt_devlink.o
 rvu_cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
 		  otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
 		  otx2_cptvf_algs.o cn10k_cpt.o
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index c5445b05f53c..fb56824cb0a6 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
+#include <net/devlink.h>
 #include "otx2_cpt_hw_types.h"
 #include "rvu.h"
 #include "mbox.h"
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
new file mode 100644
index 000000000000..bb02e0db3615
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2021 Marvell. */
+
+#include "otx2_cpt_devlink.h"
+
+static int otx2_cpt_dl_egrp_create(struct devlink *dl, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+
+	return otx2_cpt_dl_custom_egrp_create(cptpf, ctx);
+}
+
+static int otx2_cpt_dl_egrp_delete(struct devlink *dl, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+
+	return otx2_cpt_dl_custom_egrp_delete(cptpf, ctx);
+}
+
+static int otx2_cpt_dl_uc_info(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_cpt_devlink *cpt_dl = devlink_priv(dl);
+	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
+
+	otx2_cpt_print_uc_dbg_info(cptpf);
+
+	return 0;
+}
+
+enum otx2_cpt_dl_param_id {
+	OTX2_CPT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_CREATE,
+	OTX2_CPT_DEVLINK_PARAM_ID_EGRP_DELETE,
+};
+
+static const struct devlink_param otx2_cpt_dl_params[] = {
+	DEVLINK_PARAM_DRIVER(OTX2_CPT_DEVLINK_PARAM_ID_EGRP_CREATE,
+			     "egrp_create", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_cpt_dl_uc_info, otx2_cpt_dl_egrp_create,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(OTX2_CPT_DEVLINK_PARAM_ID_EGRP_DELETE,
+			     "egrp_delete", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_cpt_dl_uc_info, otx2_cpt_dl_egrp_delete,
+			     NULL),
+};
+
+static int otx2_cpt_devlink_info_get(struct devlink *devlink,
+				     struct devlink_info_req *req,
+				     struct netlink_ext_ack *extack)
+{
+	return devlink_info_driver_name_put(req, "rvu_cptpf");
+}
+
+static const struct devlink_ops otx2_cpt_devlink_ops = {
+	.info_get = otx2_cpt_devlink_info_get,
+};
+
+int otx2_cpt_register_dl(struct otx2_cptpf_dev *cptpf)
+{
+	struct device *dev = &cptpf->pdev->dev;
+	struct otx2_cpt_devlink *cpt_dl;
+	struct devlink *dl;
+	int ret;
+
+	dl = devlink_alloc(&otx2_cpt_devlink_ops,
+			   sizeof(struct otx2_cpt_devlink), dev);
+	if (!dl) {
+		dev_warn(dev, "devlink_alloc failed\n");
+		return -ENOMEM;
+	}
+
+	cpt_dl = devlink_priv(dl);
+	cpt_dl->dl = dl;
+	cpt_dl->cptpf = cptpf;
+	cptpf->dl = dl;
+	ret = devlink_params_register(dl, otx2_cpt_dl_params,
+				      ARRAY_SIZE(otx2_cpt_dl_params));
+	if (ret) {
+		dev_err(dev, "devlink params register failed with error %d",
+			ret);
+		devlink_free(dl);
+		return ret;
+	}
+
+	devlink_register(dl);
+
+	return 0;
+}
+
+void otx2_cpt_unregister_dl(struct otx2_cptpf_dev *cptpf)
+{
+	struct devlink *dl = cptpf->dl;
+
+	if (!dl)
+		return;
+
+	devlink_unregister(dl);
+	devlink_params_unregister(dl, otx2_cpt_dl_params,
+				  ARRAY_SIZE(otx2_cpt_dl_params));
+	devlink_free(dl);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.h
new file mode 100644
index 000000000000..8b7d88c5d519
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2021 Marvell.
+ */
+
+#ifndef __OTX2_CPT_DEVLINK_H
+#define __OTX2_CPT_DEVLINK_H
+
+#include "otx2_cpt_common.h"
+#include "otx2_cptpf.h"
+
+struct otx2_cpt_devlink {
+	struct devlink *dl;
+	struct otx2_cptpf_dev *cptpf;
+};
+
+/* Devlink APIs */
+int otx2_cpt_register_dl(struct otx2_cptpf_dev *cptpf);
+void otx2_cpt_unregister_dl(struct otx2_cptpf_dev *cptpf);
+
+#endif /* __OTX2_CPT_DEVLINK_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 5ebba86c65d9..05b2d9c650e1 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -53,6 +53,9 @@ struct otx2_cptpf_dev {
 	u8 enabled_vfs;		/* Number of enabled VFs */
 	u8 kvf_limits;		/* Kernel crypto limits */
 	bool has_cpt1;
+
+	/* Devlink */
+	struct devlink *dl;
 };
 
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 146a55ac4b9b..e8be0e7bbd1b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -4,6 +4,7 @@
 #include <linux/firmware.h>
 #include "otx2_cpt_hw_types.h"
 #include "otx2_cpt_common.h"
+#include "otx2_cpt_devlink.h"
 #include "otx2_cptpf_ucode.h"
 #include "otx2_cptpf.h"
 #include "cn10k_cpt.h"
@@ -767,8 +768,15 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 	err = sysfs_create_group(&dev->kobj, &cptpf_sysfs_group);
 	if (err)
 		goto cleanup_eng_grps;
+
+	err = otx2_cpt_register_dl(cptpf);
+	if (err)
+		goto sysfs_grp_del;
+
 	return 0;
 
+sysfs_grp_del:
+	sysfs_remove_group(&dev->kobj, &cptpf_sysfs_group);
 cleanup_eng_grps:
 	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
 unregister_intr:
@@ -788,6 +796,7 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 		return;
 
 	cptpf_sriov_disable(pdev);
+	otx2_cpt_unregister_dl(cptpf);
 	/* Delete sysfs entry created for kernel VF limits */
 	sysfs_remove_group(&pdev->dev.kobj, &cptpf_sysfs_group);
 	/* Cleanup engine groups */
-- 
2.25.1

