Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D12CDB482
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 06:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjJPGuH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjJPGuF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 02:50:05 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410F1AD
        for <linux-crypto@vger.kernel.org>; Sun, 15 Oct 2023 23:50:01 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39FMoJaZ030467;
        Sun, 15 Oct 2023 23:49:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=HpTtwsvRG/61NzTxR93dU5h9c8flyupPdKdkVUtgPbQ=;
 b=UqNLZsArRNEX+q1YOpLmPUDe3V1lH3L0SN1e/dtyYteD3T4hpyHamfHlD1VZ7MulxllB
 GCmkKUKh6okjfpkHOApcBm95Kx3df2zSOWw402rwxysYpsP7QI4mIMIxpwfr+t8ZHU6k
 nuLAF3eCRMdWYnELkh1QeCmWWuymP2wC8BHRn/FDzzM7icmaDzCg3EFPFu8ppjhHYZ9Z
 mNYBsddhpmx74+n1N4uEbVnH1iKwYt+jF4nFqIqB1X/iTzQkZMq52A03ckio0QQzFvU2
 ey8v5TP3jHknEhbUYFSb3w+K29MYI7rAz+mVwGKfdAdAaz6rp1Il4r+p7NpSkkEgEkLK tw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3tqtgkm92k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Oct 2023 23:49:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 15 Oct
 2023 23:49:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 15 Oct 2023 23:49:44 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 2BAC03F705C;
        Sun, 15 Oct 2023 23:49:41 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <schalla@marvell.com>
Subject: [PATCH 02/10] crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
Date:   Mon, 16 Oct 2023 12:19:26 +0530
Message-ID: <20231016064934.1913964-3-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016064934.1913964-1-schalla@marvell.com>
References: <20231016064934.1913964-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: kz7A7A9FcKxkOoJm9XS8ejAtczHUqcgF
X-Proofpoint-ORIG-GUID: kz7A7A9FcKxkOoJm9XS8ejAtczHUqcgF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-15_09,2023-10-12_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Scatter Gather input format for CPT has changed on CN10KB/CN10KA B0 HW
to make it comapatible with NIX Scatter Gather format to support SG mode
for inline IPsec. This patch modifies the code to make the driver works
for the same. This patch also enables CPT firmware load for these chips.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  19 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |   1 +
 .../marvell/octeontx2/otx2_cpt_common.h       |  41 ++-
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |   3 +
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 291 ++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   2 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  26 +-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |   2 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  33 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
 .../marvell/octeontx2/otx2_cptvf_main.c       |  13 +
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  25 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 160 +---------
 14 files changed, 444 insertions(+), 177 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
index 93d22b328991..b23ae3a020e0 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
@@ -14,12 +14,14 @@ static struct cpt_hw_ops otx2_hw_ops = {
 	.send_cmd = otx2_cpt_send_cmd,
 	.cpt_get_compcode = otx2_cpt_get_compcode,
 	.cpt_get_uc_compcode = otx2_cpt_get_uc_compcode,
+	.cpt_sg_info_create = otx2_sg_info_create,
 };
 
 static struct cpt_hw_ops cn10k_hw_ops = {
 	.send_cmd = cn10k_cpt_send_cmd,
 	.cpt_get_compcode = cn10k_cpt_get_compcode,
 	.cpt_get_uc_compcode = cn10k_cpt_get_uc_compcode,
+	.cpt_sg_info_create = otx2_sg_info_create,
 };
 
 static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
@@ -78,12 +80,9 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
 	struct pci_dev *pdev = cptvf->pdev;
 	resource_size_t offset, size;
 
-	if (!test_bit(CN10K_LMTST, &cptvf->cap_flag)) {
-		cptvf->lfs.ops = &otx2_hw_ops;
+	if (!test_bit(CN10K_LMTST, &cptvf->cap_flag))
 		return 0;
-	}
 
-	cptvf->lfs.ops = &cn10k_hw_ops;
 	offset = pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
 	size = pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
 	/* Map VF LMILINE region */
@@ -96,3 +95,15 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(cn10k_cptvf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT);
+
+int cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf)
+{
+	if (!test_bit(CN10K_LMTST, &cptvf->cap_flag)) {
+		cptvf->lfs.ops = &otx2_hw_ops;
+		return 0;
+	}
+	cptvf->lfs.ops = &cn10k_hw_ops;
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cptvf_hw_ops_get, CRYPTO_DEV_OCTEONTX2_CPT);
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
index aaefc7e38e06..0f714ee564f5 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
@@ -30,5 +30,6 @@ static inline u8 otx2_cpt_get_uc_compcode(union otx2_cpt_res_s *result)
 
 int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);
 int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);
+int cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf);
 
 #endif /* __CN10K_CPTLF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 46b778bbbee4..9a2cbee5a834 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -102,7 +102,10 @@ union otx2_cpt_eng_caps {
 		u64 kasumi:1;
 		u64 des:1;
 		u64 crc:1;
-		u64 reserved_14_63:50;
+		u64 mmul:1;
+		u64 reserved_15_33:19;
+		u64 pdcp_chain:1;
+		u64 reserved_35_63:29;
 	};
 };
 
@@ -145,6 +148,41 @@ static inline bool is_dev_otx2(struct pci_dev *pdev)
 	return false;
 }
 
+static inline bool is_dev_cn10ka(struct pci_dev *pdev)
+{
+	if (pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A)
+		return true;
+
+	return false;
+}
+
+static inline bool is_dev_cn10ka_ax(struct pci_dev *pdev)
+{
+	if ((pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A) &&
+	    ((pdev->revision & 0xFF) == 4 || (pdev->revision & 0xFF) == 0x50 ||
+	     (pdev->revision & 0xff) == 0x51))
+		return true;
+
+	return false;
+}
+
+static inline bool is_dev_cn10kb(struct pci_dev *pdev)
+{
+	if (pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_B)
+		return true;
+
+	return false;
+}
+
+static inline bool is_dev_cn10ka_b0(struct pci_dev *pdev)
+{
+	if ((pdev->subsystem_device == CPT_PCI_SUBSYS_DEVID_CN10K_A) &&
+	    (pdev->revision & 0xFF) == 0x54)
+		return true;
+
+	return false;
+}
+
 static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 					unsigned long *cap_flag)
 {
@@ -154,7 +192,6 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 	}
 }
 
-
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
index 6f947978e4e8..756aee0c2b05 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
@@ -13,6 +13,9 @@
 #define CN10K_CPT_PCI_PF_DEVICE_ID 0xA0F2
 #define CN10K_CPT_PCI_VF_DEVICE_ID 0xA0F3
 
+#define CPT_PCI_SUBSYS_DEVID_CN10K_A 0xB900
+#define CPT_PCI_SUBSYS_DEVID_CN10K_B 0xBD00
+
 /* Mailbox interrupts offset */
 #define OTX2_CPT_PF_MBOX_INT	6
 #define OTX2_CPT_PF_INT_VEC_E_MBOXX(x, a) ((x) + (a))
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index dbb1ee746f4c..fc5aca209837 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -143,6 +143,8 @@ struct otx2_cpt_inst_info {
 	unsigned long time_in;
 	u32 dlen;
 	u32 dma_len;
+	u64 gthr_sz;
+	u64 sctr_sz;
 	u8 extra_time;
 };
 
@@ -157,6 +159,16 @@ struct otx2_cpt_sglist_component {
 	__be64 ptr3;
 };
 
+struct cn10kb_cpt_sglist_component {
+	__be16 len0;
+	__be16 len1;
+	__be16 len2;
+	__be16 valid_segs;
+	__be64 ptr0;
+	__be64 ptr1;
+	__be64 ptr2;
+};
+
 static inline void otx2_cpt_info_destroy(struct pci_dev *pdev,
 					 struct otx2_cpt_inst_info *info)
 {
@@ -188,6 +200,285 @@ static inline void otx2_cpt_info_destroy(struct pci_dev *pdev,
 	kfree(info);
 }
 
+static inline int setup_sgio_components(struct pci_dev *pdev,
+					struct otx2_cpt_buf_ptr *list,
+					int buf_count, u8 *buffer)
+{
+	struct otx2_cpt_sglist_component *sg_ptr = NULL;
+	int ret = 0, i, j;
+	int components;
+
+	if (unlikely(!list)) {
+		dev_err(&pdev->dev, "Input list pointer is NULL\n");
+		return -EFAULT;
+	}
+
+	for (i = 0; i < buf_count; i++) {
+		if (unlikely(!list[i].vptr))
+			continue;
+		list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
+						  list[i].size,
+						  DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
+			dev_err(&pdev->dev, "Dma mapping failed\n");
+			ret = -EIO;
+			goto sg_cleanup;
+		}
+	}
+	components = buf_count / 4;
+	sg_ptr = (struct otx2_cpt_sglist_component *)buffer;
+	for (i = 0; i < components; i++) {
+		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->len3 = cpu_to_be16(list[i * 4 + 3].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		sg_ptr->ptr3 = cpu_to_be64(list[i * 4 + 3].dma_addr);
+		sg_ptr++;
+	}
+	components = buf_count % 4;
+
+	switch (components) {
+	case 3:
+		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		fallthrough;
+	case 2:
+		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		fallthrough;
+	case 1:
+		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		break;
+	default:
+		break;
+	}
+	return ret;
+
+sg_cleanup:
+	for (j = 0; j < i; j++) {
+		if (list[j].dma_addr) {
+			dma_unmap_single(&pdev->dev, list[j].dma_addr,
+					 list[j].size, DMA_BIDIRECTIONAL);
+		}
+
+		list[j].dma_addr = 0;
+	}
+	return ret;
+}
+
+static inline int sgv2io_components_setup(struct pci_dev *pdev,
+					  struct otx2_cpt_buf_ptr *list,
+					  int buf_count, u8 *buffer)
+{
+	struct cn10kb_cpt_sglist_component *sg_ptr = NULL;
+	int ret = 0, i, j;
+	int components;
+
+	if (unlikely(!list)) {
+		dev_err(&pdev->dev, "Input list pointer is NULL\n");
+		return -EFAULT;
+	}
+
+	for (i = 0; i < buf_count; i++) {
+		if (unlikely(!list[i].vptr))
+			continue;
+		list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
+						  list[i].size,
+						  DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
+			dev_err(&pdev->dev, "Dma mapping failed\n");
+			ret = -EIO;
+			goto sg_cleanup;
+		}
+	}
+	components = buf_count / 3;
+	sg_ptr = (struct cn10kb_cpt_sglist_component *)buffer;
+	for (i = 0; i < components; i++) {
+		sg_ptr->len0 = list[i * 3 + 0].size;
+		sg_ptr->len1 = list[i * 3 + 1].size;
+		sg_ptr->len2 = list[i * 3 + 2].size;
+		sg_ptr->ptr0 = list[i * 3 + 0].dma_addr;
+		sg_ptr->ptr1 = list[i * 3 + 1].dma_addr;
+		sg_ptr->ptr2 = list[i * 3 + 2].dma_addr;
+		sg_ptr->valid_segs = 3;
+		sg_ptr++;
+	}
+	components = buf_count % 3;
+
+	sg_ptr->valid_segs = components;
+	switch (components) {
+	case 2:
+		sg_ptr->len1 = list[i * 3 + 1].size;
+		sg_ptr->ptr1 = list[i * 3 + 1].dma_addr;
+		fallthrough;
+	case 1:
+		sg_ptr->len0 = list[i * 3 + 0].size;
+		sg_ptr->ptr0 = list[i * 3 + 0].dma_addr;
+		break;
+	default:
+		break;
+	}
+	return ret;
+
+sg_cleanup:
+	for (j = 0; j < i; j++) {
+		if (list[j].dma_addr) {
+			dma_unmap_single(&pdev->dev, list[j].dma_addr,
+					 list[j].size, DMA_BIDIRECTIONAL);
+		}
+
+		list[j].dma_addr = 0;
+	}
+	return ret;
+}
+
+static inline struct otx2_cpt_inst_info *cn10k_sgv2_info_create(struct pci_dev *pdev,
+					      struct otx2_cpt_req_info *req,
+					      gfp_t gfp)
+{
+	u32 dlen = 0, g_len, sg_len, info_len;
+	int align = OTX2_CPT_DMA_MINALIGN;
+	struct otx2_cpt_inst_info *info;
+	u16 g_sz_bytes, s_sz_bytes;
+	u32 total_mem_len;
+	int i;
+
+	g_sz_bytes = ((req->in_cnt + 2) / 3) *
+		      sizeof(struct cn10kb_cpt_sglist_component);
+	s_sz_bytes = ((req->out_cnt + 2) / 3) *
+		      sizeof(struct cn10kb_cpt_sglist_component);
+
+	g_len = ALIGN(g_sz_bytes, align);
+	sg_len = ALIGN(g_len + s_sz_bytes, align);
+	info_len = ALIGN(sizeof(*info), align);
+	total_mem_len = sg_len + info_len + sizeof(union otx2_cpt_res_s);
+
+	info = kzalloc(total_mem_len, gfp);
+	if (unlikely(!info))
+		return NULL;
+
+	for (i = 0; i < req->in_cnt; i++)
+		dlen += req->in[i].size;
+
+	info->dlen = dlen;
+	info->in_buffer = (u8 *)info + info_len;
+	info->gthr_sz = req->in_cnt;
+	info->sctr_sz = req->out_cnt;
+
+	/* Setup gather (input) components */
+	if (sgv2io_components_setup(pdev, req->in, req->in_cnt,
+				    info->in_buffer)) {
+		dev_err(&pdev->dev, "Failed to setup gather list\n");
+		goto destroy_info;
+	}
+
+	if (sgv2io_components_setup(pdev, req->out, req->out_cnt,
+				    &info->in_buffer[g_len])) {
+		dev_err(&pdev->dev, "Failed to setup scatter list\n");
+		goto destroy_info;
+	}
+
+	info->dma_len = total_mem_len - info_len;
+	info->dptr_baddr = dma_map_single(&pdev->dev, info->in_buffer,
+					  info->dma_len, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
+		dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
+		goto destroy_info;
+	}
+	info->rptr_baddr = info->dptr_baddr + g_len;
+	/*
+	 * Get buffer for union otx2_cpt_res_s response
+	 * structure and its physical address
+	 */
+	info->completion_addr = info->in_buffer + sg_len;
+	info->comp_baddr = info->dptr_baddr + sg_len;
+
+	return info;
+
+destroy_info:
+	otx2_cpt_info_destroy(pdev, info);
+	return NULL;
+}
+
+/* SG list header size in bytes */
+#define SG_LIST_HDR_SIZE	8
+static inline struct otx2_cpt_inst_info *otx2_sg_info_create(struct pci_dev *pdev,
+					      struct otx2_cpt_req_info *req,
+					      gfp_t gfp)
+{
+	int align = OTX2_CPT_DMA_MINALIGN;
+	struct otx2_cpt_inst_info *info;
+	u32 dlen, align_dlen, info_len;
+	u16 g_sz_bytes, s_sz_bytes;
+	u32 total_mem_len;
+
+	if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
+		     req->out_cnt > OTX2_CPT_MAX_SG_OUT_CNT)) {
+		dev_err(&pdev->dev, "Error too many sg components\n");
+		return NULL;
+	}
+
+	g_sz_bytes = ((req->in_cnt + 3) / 4) *
+		      sizeof(struct otx2_cpt_sglist_component);
+	s_sz_bytes = ((req->out_cnt + 3) / 4) *
+		      sizeof(struct otx2_cpt_sglist_component);
+
+	dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
+	align_dlen = ALIGN(dlen, align);
+	info_len = ALIGN(sizeof(*info), align);
+	total_mem_len = align_dlen + info_len + sizeof(union otx2_cpt_res_s);
+
+	info = kzalloc(total_mem_len, gfp);
+	if (unlikely(!info))
+		return NULL;
+
+	info->dlen = dlen;
+	info->in_buffer = (u8 *)info + info_len;
+
+	((u16 *)info->in_buffer)[0] = req->out_cnt;
+	((u16 *)info->in_buffer)[1] = req->in_cnt;
+	((u16 *)info->in_buffer)[2] = 0;
+	((u16 *)info->in_buffer)[3] = 0;
+	cpu_to_be64s((u64 *)info->in_buffer);
+
+	/* Setup gather (input) components */
+	if (setup_sgio_components(pdev, req->in, req->in_cnt,
+				  &info->in_buffer[8])) {
+		dev_err(&pdev->dev, "Failed to setup gather list\n");
+		goto destroy_info;
+	}
+
+	if (setup_sgio_components(pdev, req->out, req->out_cnt,
+				  &info->in_buffer[8 + g_sz_bytes])) {
+		dev_err(&pdev->dev, "Failed to setup scatter list\n");
+		goto destroy_info;
+	}
+
+	info->dma_len = total_mem_len - info_len;
+	info->dptr_baddr = dma_map_single(&pdev->dev, info->in_buffer,
+					  info->dma_len, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
+		dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
+		goto destroy_info;
+	}
+	/*
+	 * Get buffer for union otx2_cpt_res_s response
+	 * structure and its physical address
+	 */
+	info->completion_addr = info->in_buffer + align_dlen;
+	info->comp_baddr = info->dptr_baddr + align_dlen;
+
+	return info;
+
+destroy_info:
+	otx2_cpt_info_destroy(pdev, info);
+	return NULL;
+}
+
 struct otx2_cptlf_wqe;
 int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 			int cpu_num);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index 5302fe3d0e6f..fcdada184edd 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -99,6 +99,8 @@ struct cpt_hw_ops {
 			 struct otx2_cptlf_info *lf);
 	u8 (*cpt_get_compcode)(union otx2_cpt_res_s *result);
 	u8 (*cpt_get_uc_compcode)(union otx2_cpt_res_s *result);
+	struct otx2_cpt_inst_info * (*cpt_sg_info_create)(struct pci_dev *pdev,
+				    struct otx2_cpt_req_info *req, gfp_t gfp);
 };
 
 struct otx2_cptlfs_info {
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 5436b0d3685c..c64c50a964ed 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -14,6 +14,8 @@
 #define OTX2_CPT_DRV_STRING  "Marvell RVU CPT Physical Function Driver"
 
 #define CPT_UC_RID_CN9K_B0   1
+#define CPT_UC_RID_CN10K_A   4
+#define CPT_UC_RID_CN10K_B   5
 
 static void cptpf_enable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
 					int num_vfs)
@@ -587,6 +589,26 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
 	return 0;
 }
 
+static int cptpf_get_rid(struct pci_dev *pdev, struct otx2_cptpf_dev *cptpf)
+{
+	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
+	u64 reg_val = 0x0;
+
+	if (is_dev_otx2(pdev)) {
+		eng_grps->rid = pdev->revision;
+		return 0;
+	}
+	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
+			     BLKADDR_CPT0);
+	if ((is_dev_cn10ka_b0(pdev) && (reg_val & BIT_ULL(18))) ||
+	    is_dev_cn10ka_ax(pdev))
+		eng_grps->rid = CPT_UC_RID_CN10K_A;
+	else if (is_dev_cn10kb(pdev) || is_dev_cn10ka_b0(pdev))
+		eng_grps->rid = CPT_UC_RID_CN10K_B;
+
+	return 0;
+}
+
 static void cptpf_check_block_implemented(struct otx2_cptpf_dev *cptpf)
 {
 	u64 cfg;
@@ -657,7 +679,9 @@ static int cptpf_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	ret = cptpf_register_vfpf_intr(cptpf, num_vfs);
 	if (ret)
 		goto destroy_flr;
-
+	ret = cptpf_get_rid(pdev, cptpf);
+	if (ret)
+		goto disable_intr;
 	/* Get CPT HW capabilities using LOAD_FVC operation. */
 	ret = otx2_cpt_discover_eng_capabilities(cptpf);
 	if (ret)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 480b3720f15a..390ed146d309 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -78,7 +78,7 @@ static int handle_msg_get_caps(struct otx2_cptpf_dev *cptpf,
 	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
 	rsp->hdr.pcifunc = req->pcifunc;
 	rsp->cpt_pf_drv_version = OTX2_CPT_PF_DRV_VERSION;
-	rsp->cpt_revision = cptpf->pdev->revision;
+	rsp->cpt_revision = cptpf->eng_grps.rid;
 	memcpy(&rsp->eng_caps, &cptpf->eng_caps, sizeof(rsp->eng_caps));
 
 	return 0;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 1958b797a421..7fccc348f66e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -117,12 +117,10 @@ static char *get_ucode_type_str(int ucode_type)
 
 static int get_ucode_type(struct device *dev,
 			  struct otx2_cpt_ucode_hdr *ucode_hdr,
-			  int *ucode_type)
+			  int *ucode_type, u16 rid)
 {
-	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
 	char ver_str_prefix[OTX2_CPT_UCODE_VER_STR_SZ];
 	char tmp_ver_str[OTX2_CPT_UCODE_VER_STR_SZ];
-	struct pci_dev *pdev = cptpf->pdev;
 	int i, val = 0;
 	u8 nn;
 
@@ -130,7 +128,7 @@ static int get_ucode_type(struct device *dev,
 	for (i = 0; i < strlen(tmp_ver_str); i++)
 		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
 
-	sprintf(ver_str_prefix, "ocpt-%02d", pdev->revision);
+	sprintf(ver_str_prefix, "ocpt-%02d", rid);
 	if (!strnstr(tmp_ver_str, ver_str_prefix, OTX2_CPT_UCODE_VER_STR_SZ))
 		return -EINVAL;
 
@@ -359,7 +357,7 @@ static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
 }
 
 static int load_fw(struct device *dev, struct fw_info_t *fw_info,
-		   char *filename)
+		   char *filename, u16 rid)
 {
 	struct otx2_cpt_ucode_hdr *ucode_hdr;
 	struct otx2_cpt_uc_info_t *uc_info;
@@ -375,7 +373,7 @@ static int load_fw(struct device *dev, struct fw_info_t *fw_info,
 		goto free_uc_info;
 
 	ucode_hdr = (struct otx2_cpt_ucode_hdr *)uc_info->fw->data;
-	ret = get_ucode_type(dev, ucode_hdr, &ucode_type);
+	ret = get_ucode_type(dev, ucode_hdr, &ucode_type, rid);
 	if (ret)
 		goto release_fw;
 
@@ -389,6 +387,7 @@ static int load_fw(struct device *dev, struct fw_info_t *fw_info,
 	set_ucode_filename(&uc_info->ucode, filename);
 	memcpy(uc_info->ucode.ver_str, ucode_hdr->ver_str,
 	       OTX2_CPT_UCODE_VER_STR_SZ);
+	uc_info->ucode.ver_str[OTX2_CPT_UCODE_VER_STR_SZ] = 0;
 	uc_info->ucode.ver_num = ucode_hdr->ver_num;
 	uc_info->ucode.type = ucode_type;
 	uc_info->ucode.size = ucode_size;
@@ -448,7 +447,8 @@ static void print_uc_info(struct fw_info_t *fw_info)
 	}
 }
 
-static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_info)
+static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_info,
+			     u16 rid)
 {
 	char filename[OTX2_CPT_NAME_LENGTH];
 	char eng_type[8] = {0};
@@ -462,9 +462,9 @@ static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_info)
 			eng_type[i] = tolower(eng_type[i]);
 
 		snprintf(filename, sizeof(filename), "mrvl/cpt%02d/%s.out",
-			 pdev->revision, eng_type);
+			 rid, eng_type);
 		/* Request firmware for each engine type */
-		ret = load_fw(&pdev->dev, fw_info, filename);
+		ret = load_fw(&pdev->dev, fw_info, filename, rid);
 		if (ret)
 			goto release_fw;
 	}
@@ -1155,7 +1155,7 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	if (eng_grps->is_grps_created)
 		goto unlock;
 
-	ret = cpt_ucode_load_fw(pdev, &fw_info);
+	ret = cpt_ucode_load_fw(pdev, &fw_info, eng_grps->rid);
 	if (ret)
 		goto unlock;
 
@@ -1230,14 +1230,16 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	 */
 	rnm_to_cpt_errata_fixup(&pdev->dev);
 
+	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_val,
+			     BLKADDR_CPT0);
 	/*
 	 * Configure engine group mask to allow context prefetching
 	 * for the groups and enable random number request, to enable
 	 * CPT to request random numbers from RNM.
 	 */
+	reg_val |= OTX2_CPT_ALL_ENG_GRPS_MASK << 3 | BIT_ULL(16);
 	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL,
-			      OTX2_CPT_ALL_ENG_GRPS_MASK << 3 | BIT_ULL(16),
-			      BLKADDR_CPT0);
+			      reg_val, BLKADDR_CPT0);
 	/*
 	 * Set interval to periodically flush dirty data for the next
 	 * CTX cache entry. Set the interval count to maximum supported
@@ -1412,7 +1414,7 @@ static int create_eng_caps_discovery_grps(struct pci_dev *pdev,
 	int ret;
 
 	mutex_lock(&eng_grps->lock);
-	ret = cpt_ucode_load_fw(pdev, &fw_info);
+	ret = cpt_ucode_load_fw(pdev, &fw_info, eng_grps->rid);
 	if (ret) {
 		mutex_unlock(&eng_grps->lock);
 		return ret;
@@ -1686,13 +1688,14 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 		goto err_unlock;
 	}
 	INIT_LIST_HEAD(&fw_info.ucodes);
-	ret = load_fw(dev, &fw_info, ucode_filename[0]);
+
+	ret = load_fw(dev, &fw_info, ucode_filename[0], eng_grps->rid);
 	if (ret) {
 		dev_err(dev, "Unable to load firmware %s\n", ucode_filename[0]);
 		goto err_unlock;
 	}
 	if (ucode_idx > 1) {
-		ret = load_fw(dev, &fw_info, ucode_filename[1]);
+		ret = load_fw(dev, &fw_info, ucode_filename[1], eng_grps->rid);
 		if (ret) {
 			dev_err(dev, "Unable to load firmware %s\n",
 				ucode_filename[1]);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
index e69320a54b5d..365fe8943bd9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -73,7 +73,7 @@ struct otx2_cpt_ucode_hdr {
 };
 
 struct otx2_cpt_ucode {
-	u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];/*
+	u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ + 1];/*
 					       * ucode version in readable
 					       * format
 					       */
@@ -150,6 +150,7 @@ struct otx2_cpt_eng_grps {
 	int engs_num;			/* total number of engines supported */
 	u8 eng_ref_cnt[OTX2_CPT_MAX_ENGINES];/* engines reference count */
 	bool is_grps_created; /* Is the engine groups are already created */
+	u16 rid;
 };
 struct otx2_cptpf_dev;
 int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
index 994291e90da1..11ab9af1df15 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
@@ -22,6 +22,7 @@ struct otx2_cptvf_dev {
 	int blkaddr;
 	void *bbuf_base;
 	unsigned long cap_flag;
+	u64 eng_caps[OTX2_CPT_MAX_ENG_TYPES];
 };
 
 irqreturn_t otx2_cptvf_pfvf_mbox_intr(int irq, void *arg);
@@ -29,5 +30,6 @@ void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work);
 int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int eng_type);
 int otx2_cptvf_send_kvf_limits_msg(struct otx2_cptvf_dev *cptvf);
 int otx2_cpt_mbox_bbuf_init(struct otx2_cptvf_dev *cptvf, struct pci_dev *pdev);
+int otx2_cptvf_send_caps_msg(struct otx2_cptvf_dev *cptvf);
 
 #endif /* __OTX2_CPTVF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index bac729c885f9..5d1e11135c17 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -380,6 +380,19 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 		goto destroy_pfvf_mbox;
 
 	cptvf->blkaddr = BLKADDR_CPT0;
+
+	ret = cptvf_hw_ops_get(cptvf);
+	if (ret)
+		goto unregister_interrupts;
+
+	ret = otx2_cptvf_send_caps_msg(cptvf);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't get CPT engine capabilities.\n");
+		goto unregister_interrupts;
+	}
+	if (cptvf->eng_caps[OTX2_CPT_SE_TYPES] & BIT_ULL(35))
+		cptvf->lfs.ops->cpt_sg_info_create = cn10k_sgv2_info_create;
+
 	/* Initialize CPT LFs */
 	ret = cptvf_lf_init(cptvf);
 	if (ret)
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
index 75c403f2b1d9..333bd4024d1a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -72,6 +72,7 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 	struct otx2_cptlfs_info *lfs = &cptvf->lfs;
 	struct otx2_cpt_kvf_limits_rsp *rsp_limits;
 	struct otx2_cpt_egrp_num_rsp *rsp_grp;
+	struct otx2_cpt_caps_rsp *eng_caps;
 	struct cpt_rd_wr_reg_msg *rsp_reg;
 	struct msix_offset_rsp *rsp_msix;
 	int i;
@@ -127,6 +128,10 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 		rsp_limits = (struct otx2_cpt_kvf_limits_rsp *) msg;
 		cptvf->lfs.kvf_limits = rsp_limits->kvf_limits;
 		break;
+	case MBOX_MSG_GET_CAPS:
+		eng_caps = (struct otx2_cpt_caps_rsp *) msg;
+		memcpy(cptvf->eng_caps, eng_caps->eng_caps, sizeof(cptvf->eng_caps));
+		break;
 	default:
 		dev_err(&cptvf->pdev->dev, "Unsupported msg %d received.\n",
 			msg->id);
@@ -205,3 +210,23 @@ int otx2_cptvf_send_kvf_limits_msg(struct otx2_cptvf_dev *cptvf)
 
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+
+int otx2_cptvf_send_caps_msg(struct otx2_cptvf_dev *cptvf)
+{
+	struct otx2_mbox *mbox = &cptvf->pfvf_mbox;
+	struct pci_dev *pdev = cptvf->pdev;
+	struct mbox_msghdr *req;
+
+	req = (struct mbox_msghdr *)
+	      otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+				      sizeof(struct otx2_cpt_caps_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	req->id = MBOX_MSG_GET_CAPS;
+	req->sig = OTX2_MBOX_REQ_SIG;
+	req->pcifunc = OTX2_CPT_RVU_PFFUNC(cptvf->vf_id, 0);
+
+	return otx2_cpt_send_mbox_msg(mbox, pdev);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 811ded72ce5f..997a2eb60c66 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -4,9 +4,6 @@
 #include "otx2_cptvf.h"
 #include "otx2_cpt_common.h"
 
-/* SG list header size in bytes */
-#define SG_LIST_HDR_SIZE	8
-
 /* Default timeout when waiting for free pending entry in us */
 #define CPT_PENTRY_TIMEOUT	1000
 #define CPT_PENTRY_STEP		50
@@ -26,9 +23,9 @@ static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,
 
 	pr_debug("Gather list size %d\n", req->in_cnt);
 	for (i = 0; i < req->in_cnt; i++) {
-		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i,
+		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%llx\n", i,
 			 req->in[i].size, req->in[i].vptr,
-			 (void *) req->in[i].dma_addr);
+			 req->in[i].dma_addr);
 		pr_debug("Buffer hexdump (%d bytes)\n",
 			 req->in[i].size);
 		print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
@@ -36,9 +33,9 @@ static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,
 	}
 	pr_debug("Scatter list size %d\n", req->out_cnt);
 	for (i = 0; i < req->out_cnt; i++) {
-		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i,
+		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%llx\n", i,
 			 req->out[i].size, req->out[i].vptr,
-			 (void *) req->out[i].dma_addr);
+			 req->out[i].dma_addr);
 		pr_debug("Buffer hexdump (%d bytes)\n", req->out[i].size);
 		print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
 				     req->out[i].vptr, req->out[i].size, false);
@@ -84,149 +81,6 @@ static inline void free_pentry(struct otx2_cpt_pending_entry *pentry)
 	pentry->busy = false;
 }
 
-static inline int setup_sgio_components(struct pci_dev *pdev,
-					struct otx2_cpt_buf_ptr *list,
-					int buf_count, u8 *buffer)
-{
-	struct otx2_cpt_sglist_component *sg_ptr = NULL;
-	int ret = 0, i, j;
-	int components;
-
-	if (unlikely(!list)) {
-		dev_err(&pdev->dev, "Input list pointer is NULL\n");
-		return -EFAULT;
-	}
-
-	for (i = 0; i < buf_count; i++) {
-		if (unlikely(!list[i].vptr))
-			continue;
-		list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
-						  list[i].size,
-						  DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
-			dev_err(&pdev->dev, "Dma mapping failed\n");
-			ret = -EIO;
-			goto sg_cleanup;
-		}
-	}
-	components = buf_count / 4;
-	sg_ptr = (struct otx2_cpt_sglist_component *)buffer;
-	for (i = 0; i < components; i++) {
-		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
-		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
-		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
-		sg_ptr->len3 = cpu_to_be16(list[i * 4 + 3].size);
-		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
-		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
-		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
-		sg_ptr->ptr3 = cpu_to_be64(list[i * 4 + 3].dma_addr);
-		sg_ptr++;
-	}
-	components = buf_count % 4;
-
-	switch (components) {
-	case 3:
-		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
-		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
-		fallthrough;
-	case 2:
-		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
-		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
-		fallthrough;
-	case 1:
-		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
-		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
-		break;
-	default:
-		break;
-	}
-	return ret;
-
-sg_cleanup:
-	for (j = 0; j < i; j++) {
-		if (list[j].dma_addr) {
-			dma_unmap_single(&pdev->dev, list[j].dma_addr,
-					 list[j].size, DMA_BIDIRECTIONAL);
-		}
-
-		list[j].dma_addr = 0;
-	}
-	return ret;
-}
-
-static inline struct otx2_cpt_inst_info *info_create(struct pci_dev *pdev,
-					      struct otx2_cpt_req_info *req,
-					      gfp_t gfp)
-{
-	int align = OTX2_CPT_DMA_MINALIGN;
-	struct otx2_cpt_inst_info *info;
-	u32 dlen, align_dlen, info_len;
-	u16 g_sz_bytes, s_sz_bytes;
-	u32 total_mem_len;
-
-	if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
-		     req->out_cnt > OTX2_CPT_MAX_SG_OUT_CNT)) {
-		dev_err(&pdev->dev, "Error too many sg components\n");
-		return NULL;
-	}
-
-	g_sz_bytes = ((req->in_cnt + 3) / 4) *
-		      sizeof(struct otx2_cpt_sglist_component);
-	s_sz_bytes = ((req->out_cnt + 3) / 4) *
-		      sizeof(struct otx2_cpt_sglist_component);
-
-	dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
-	align_dlen = ALIGN(dlen, align);
-	info_len = ALIGN(sizeof(*info), align);
-	total_mem_len = align_dlen + info_len + sizeof(union otx2_cpt_res_s);
-
-	info = kzalloc(total_mem_len, gfp);
-	if (unlikely(!info))
-		return NULL;
-
-	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
-
-	((u16 *)info->in_buffer)[0] = req->out_cnt;
-	((u16 *)info->in_buffer)[1] = req->in_cnt;
-	((u16 *)info->in_buffer)[2] = 0;
-	((u16 *)info->in_buffer)[3] = 0;
-	cpu_to_be64s((u64 *)info->in_buffer);
-
-	/* Setup gather (input) components */
-	if (setup_sgio_components(pdev, req->in, req->in_cnt,
-				  &info->in_buffer[8])) {
-		dev_err(&pdev->dev, "Failed to setup gather list\n");
-		goto destroy_info;
-	}
-
-	if (setup_sgio_components(pdev, req->out, req->out_cnt,
-				  &info->in_buffer[8 + g_sz_bytes])) {
-		dev_err(&pdev->dev, "Failed to setup scatter list\n");
-		goto destroy_info;
-	}
-
-	info->dma_len = total_mem_len - info_len;
-	info->dptr_baddr = dma_map_single(&pdev->dev, info->in_buffer,
-					  info->dma_len, DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
-		dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
-		goto destroy_info;
-	}
-	/*
-	 * Get buffer for union otx2_cpt_res_s response
-	 * structure and its physical address
-	 */
-	info->completion_addr = info->in_buffer + align_dlen;
-	info->comp_baddr = info->dptr_baddr + align_dlen;
-
-	return info;
-
-destroy_info:
-	otx2_cpt_info_destroy(pdev, info);
-	return NULL;
-}
-
 static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 			   struct otx2_cpt_pending_queue *pqueue,
 			   struct otx2_cptlf_info *lf)
@@ -247,7 +101,7 @@ static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 	if (unlikely(!otx2_cptlf_started(lf->lfs)))
 		return -ENODEV;
 
-	info = info_create(pdev, req, gfp);
+	info = lf->lfs->ops->cpt_sg_info_create(pdev, req, gfp);
 	if (unlikely(!info)) {
 		dev_err(&pdev->dev, "Setting up cpt inst info failed");
 		return -ENOMEM;
@@ -303,8 +157,8 @@ static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 
 	/* 64-bit swap for microcode data reads, not needed for addresses*/
 	cpu_to_be64s(&iq_cmd.cmd.u);
-	iq_cmd.dptr = info->dptr_baddr;
-	iq_cmd.rptr = 0;
+	iq_cmd.dptr = info->dptr_baddr | info->gthr_sz << 60;
+	iq_cmd.rptr = info->rptr_baddr | info->sctr_sz << 60;
 	iq_cmd.cptr.u = 0;
 	iq_cmd.cptr.s.grp = ctrl->s.grp;
 
-- 
2.25.1

