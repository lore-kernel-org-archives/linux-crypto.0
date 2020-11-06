Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C1CC55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A422078B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgKFL2h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:59372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgKFL2g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:36 -0500
IronPort-SDR: PbbOpGyTX7duVRY/zVv66VVq/LaTjT2sMqqWH/oZBEb8gqKBGCrwjCzmzWHf2m3RqzkVcgSQV1
 pI29yb8Lr8fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698278"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698278"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:35 -0800
IronPort-SDR: VSLPp2tBjO/tBCqhOi8Ho5vVq+TYBbY/uZD897aoDaECfCl6WWW0IN+Vg1qOsSMKisO9XEZ5j6
 e0LfRhPOOmrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779163"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:33 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Jack Xu <jack.xu@intel.com>
Subject: [PATCH 01/32] crypto: qat - support for mof format in fw loader
Date:   Fri,  6 Nov 2020 19:27:39 +0800
Message-Id: <20201106112810.2566-2-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Implement infrastructure for the Multiple Object File (MOF) format
in the firmware loader. This will allow to load a specific firmware
image contained inside an MOF file.

This patch is based on earlier work done by Pingchao Yang.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Jack Xu <jack.xu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_engine.c  |   2 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |   2 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h |   1 +
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  |  69 +++++
 drivers/crypto/qat/qat_common/qat_uclo.c      | 262 +++++++++++++++++-
 5 files changed, 331 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index c8ad85b882be..1da4176356ab 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -38,7 +38,7 @@ int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 		dev_err(&GET_DEV(accel_dev), "Failed to load MMP\n");
 		goto out_err;
 	}
-	if (qat_uclo_map_obj(loader_data->fw_loader, uof_addr, uof_size)) {
+	if (qat_uclo_map_obj(loader_data->fw_loader, uof_addr, uof_size, NULL)) {
 		dev_err(&GET_DEV(accel_dev), "Failed to map FW\n");
 		goto out_err;
 	}
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index f22342f612c1..8e6e346fd841 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -184,7 +184,7 @@ void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
 int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle, void *addr_ptr,
 		       int mem_size);
 int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
-		     void *addr_ptr, int mem_size);
+		     void *addr_ptr, u32 mem_size, char *obj_name);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 3e8e291cd122..7d44786a223a 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -27,6 +27,7 @@ struct icp_qat_fw_loader_handle {
 	struct pci_dev *pci_dev;
 	void *obj_handle;
 	void *sobj_handle;
+	void *mobj_handle;
 	bool fw_auth;
 	void __iomem *hal_sram_addr_v;
 	void __iomem *hal_cap_g_ctl_csr_addr_v;
diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index 8fe1ec344fa2..101de1430896 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -31,6 +31,15 @@
 #define ICP_QAT_SUOF_FID  0x53554f46
 #define ICP_QAT_SUOF_MAJVER 0x0
 #define ICP_QAT_SUOF_MINVER 0x1
+#define ICP_QAT_SUOF_OBJ_NAME_LEN 128
+#define ICP_QAT_MOF_OBJ_ID_LEN 8
+#define ICP_QAT_MOF_OBJ_CHUNKID_LEN 8
+#define ICP_QAT_MOF_FID 0x00666f6d
+#define ICP_QAT_MOF_MAJVER 0x0
+#define ICP_QAT_MOF_MINVER 0x1
+#define ICP_QAT_MOF_SYM_OBJS "SYM_OBJS"
+#define ICP_QAT_SUOF_OBJS "SUF_OBJS"
+#define ICP_QAT_SUOF_IMAG "SUF_IMAG"
 #define ICP_QAT_SIMG_AE_INIT_SEQ_LEN    (50 * sizeof(unsigned long long))
 #define ICP_QAT_SIMG_AE_INSTS_LEN       (0x4000 * sizeof(unsigned long long))
 #define ICP_QAT_CSS_FWSK_MODULUS_LEN    256
@@ -481,4 +490,64 @@ struct icp_qat_suof_objhdr {
 	unsigned int img_length;
 	unsigned int reserved;
 };
+
+struct icp_qat_mof_file_hdr {
+	unsigned int file_id;
+	unsigned int checksum;
+	char min_ver;
+	char maj_ver;
+	unsigned short reserved;
+	unsigned short max_chunks;
+	unsigned short num_chunks;
+};
+
+struct icp_qat_mof_chunkhdr {
+	char chunk_id[ICP_QAT_MOF_OBJ_ID_LEN];
+	u64 offset;
+	u64 size;
+};
+
+struct icp_qat_mof_str_table {
+	unsigned int tab_len;
+	unsigned int strings;
+};
+
+struct icp_qat_mof_obj_hdr {
+	unsigned short max_chunks;
+	unsigned short num_chunks;
+	unsigned int reserved;
+};
+
+struct icp_qat_mof_obj_chunkhdr {
+	char chunk_id[ICP_QAT_MOF_OBJ_CHUNKID_LEN];
+	u64 offset;
+	u64 size;
+	unsigned int name;
+	unsigned int reserved;
+};
+
+struct icp_qat_mof_objhdr {
+	char *obj_name;
+	char *obj_buf;
+	unsigned int obj_size;
+};
+
+struct icp_qat_mof_table {
+	unsigned int num_objs;
+	struct icp_qat_mof_objhdr *obj_hdr;
+};
+
+struct icp_qat_mof_handle {
+	unsigned int file_id;
+	unsigned int checksum;
+	char min_ver;
+	char maj_ver;
+	char *mof_buf;
+	u32 mof_size;
+	char *sym_str;
+	unsigned int sym_size;
+	char *uobjs_hdr;
+	char *sobjs_hdr;
+	struct icp_qat_mof_table obj_table;
+};
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 5d1f28cd6680..b475f6bfb90b 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1437,18 +1437,272 @@ static int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 	return -ENOMEM;
 }
 
+static int qat_uclo_map_mof_file_hdr(struct icp_qat_fw_loader_handle *handle,
+				     struct icp_qat_mof_file_hdr *mof_ptr,
+				     u32 mof_size)
+{
+	struct icp_qat_mof_handle *mobj_handle = handle->mobj_handle;
+	unsigned int min_ver_offset;
+	unsigned int checksum;
+
+	mobj_handle->file_id = ICP_QAT_MOF_FID;
+	mobj_handle->mof_buf = (char *)mof_ptr;
+	mobj_handle->mof_size = mof_size;
+
+	min_ver_offset = mof_size - offsetof(struct icp_qat_mof_file_hdr,
+					     min_ver);
+	checksum = qat_uclo_calc_str_checksum(&mof_ptr->min_ver,
+					      min_ver_offset);
+	if (checksum != mof_ptr->checksum) {
+		pr_err("QAT: incorrect MOF checksum\n");
+		return -EINVAL;
+	}
+
+	mobj_handle->checksum = mof_ptr->checksum;
+	mobj_handle->min_ver = mof_ptr->min_ver;
+	mobj_handle->maj_ver = mof_ptr->maj_ver;
+	return 0;
+}
+
+static void qat_uclo_del_mof(struct icp_qat_fw_loader_handle *handle)
+{
+	struct icp_qat_mof_handle *mobj_handle = handle->mobj_handle;
+
+	kfree(mobj_handle->obj_table.obj_hdr);
+	mobj_handle->obj_table.obj_hdr = NULL;
+	kfree(handle->mobj_handle);
+	handle->mobj_handle = NULL;
+}
+
+static int qat_uclo_seek_obj_inside_mof(struct icp_qat_mof_handle *mobj_handle,
+					char *obj_name, char **obj_ptr,
+					unsigned int *obj_size)
+{
+	struct icp_qat_mof_objhdr *obj_hdr = mobj_handle->obj_table.obj_hdr;
+	unsigned int i;
+
+	for (i = 0; i < mobj_handle->obj_table.num_objs; i++) {
+		if (!strncmp(obj_hdr[i].obj_name, obj_name,
+			     ICP_QAT_SUOF_OBJ_NAME_LEN)) {
+			*obj_ptr  = obj_hdr[i].obj_buf;
+			*obj_size = obj_hdr[i].obj_size;
+			return 0;
+		}
+	}
+
+	pr_err("QAT: object %s is not found inside MOF\n", obj_name);
+	return -EINVAL;
+}
+
+static int qat_uclo_map_obj_from_mof(struct icp_qat_mof_handle *mobj_handle,
+				     struct icp_qat_mof_objhdr *mobj_hdr,
+				     struct icp_qat_mof_obj_chunkhdr *obj_chunkhdr)
+{
+	u8 *obj;
+
+	if (!strncmp(obj_chunkhdr->chunk_id, ICP_QAT_UOF_IMAG,
+		     ICP_QAT_MOF_OBJ_CHUNKID_LEN)) {
+		obj = mobj_handle->uobjs_hdr + obj_chunkhdr->offset;
+	} else if (!strncmp(obj_chunkhdr->chunk_id, ICP_QAT_SUOF_IMAG,
+			    ICP_QAT_MOF_OBJ_CHUNKID_LEN)) {
+		obj = mobj_handle->sobjs_hdr + obj_chunkhdr->offset;
+	} else {
+		pr_err("QAT: unsupported chunk id\n");
+		return -EINVAL;
+	}
+	mobj_hdr->obj_buf = obj;
+	mobj_hdr->obj_size = (unsigned int)obj_chunkhdr->size;
+	mobj_hdr->obj_name = obj_chunkhdr->name + mobj_handle->sym_str;
+	return 0;
+}
+
+static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
+{
+	struct icp_qat_mof_obj_chunkhdr *uobj_chunkhdr;
+	struct icp_qat_mof_obj_chunkhdr *sobj_chunkhdr;
+	struct icp_qat_mof_obj_hdr *uobj_hdr;
+	struct icp_qat_mof_obj_hdr *sobj_hdr;
+	struct icp_qat_mof_objhdr *mobj_hdr;
+	unsigned int uobj_chunk_num = 0;
+	unsigned int sobj_chunk_num = 0;
+	unsigned int *valid_chunk;
+	int ret, i;
+
+	uobj_hdr = (struct icp_qat_mof_obj_hdr *)mobj_handle->uobjs_hdr;
+	sobj_hdr = (struct icp_qat_mof_obj_hdr *)mobj_handle->sobjs_hdr;
+	if (uobj_hdr)
+		uobj_chunk_num = uobj_hdr->num_chunks;
+	if (sobj_hdr)
+		sobj_chunk_num = sobj_hdr->num_chunks;
+
+	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+			   sizeof(*mobj_hdr), GFP_KERNEL);
+	if (!mobj_hdr)
+		return -ENOMEM;
+
+	mobj_handle->obj_table.obj_hdr = mobj_hdr;
+	valid_chunk = &mobj_handle->obj_table.num_objs;
+	uobj_chunkhdr = (struct icp_qat_mof_obj_chunkhdr *)
+			 ((uintptr_t)uobj_hdr + sizeof(*uobj_hdr));
+	sobj_chunkhdr = (struct icp_qat_mof_obj_chunkhdr *)
+			((uintptr_t)sobj_hdr + sizeof(*sobj_hdr));
+
+	/* map uof objects */
+	for (i = 0; i < uobj_chunk_num; i++) {
+		ret = qat_uclo_map_obj_from_mof(mobj_handle,
+						&mobj_hdr[*valid_chunk],
+						&uobj_chunkhdr[i]);
+		if (ret)
+			return ret;
+		(*valid_chunk)++;
+	}
+
+	/* map suof objects */
+	for (i = 0; i < sobj_chunk_num; i++) {
+		ret = qat_uclo_map_obj_from_mof(mobj_handle,
+						&mobj_hdr[*valid_chunk],
+						&sobj_chunkhdr[i]);
+		if (ret)
+			return ret;
+		(*valid_chunk)++;
+	}
+
+	if ((uobj_chunk_num + sobj_chunk_num) != *valid_chunk) {
+		pr_err("QAT: inconsistent UOF/SUOF chunk amount\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void qat_uclo_map_mof_symobjs(struct icp_qat_mof_handle *mobj_handle,
+				     struct icp_qat_mof_chunkhdr *mof_chunkhdr)
+{
+	char **sym_str = (char **)&mobj_handle->sym_str;
+	unsigned int *sym_size = &mobj_handle->sym_size;
+	struct icp_qat_mof_str_table *str_table_obj;
+
+	*sym_size = *(unsigned int *)(uintptr_t)
+		    (mof_chunkhdr->offset + mobj_handle->mof_buf);
+	*sym_str = (char *)(uintptr_t)
+		   (mobj_handle->mof_buf + mof_chunkhdr->offset +
+		    sizeof(str_table_obj->tab_len));
+}
+
+static void qat_uclo_map_mof_chunk(struct icp_qat_mof_handle *mobj_handle,
+				   struct icp_qat_mof_chunkhdr *mof_chunkhdr)
+{
+	char *chunk_id = mof_chunkhdr->chunk_id;
+
+	if (!strncmp(chunk_id, ICP_QAT_MOF_SYM_OBJS, ICP_QAT_MOF_OBJ_ID_LEN))
+		qat_uclo_map_mof_symobjs(mobj_handle, mof_chunkhdr);
+	else if (!strncmp(chunk_id, ICP_QAT_UOF_OBJS, ICP_QAT_MOF_OBJ_ID_LEN))
+		mobj_handle->uobjs_hdr = mobj_handle->mof_buf +
+					 mof_chunkhdr->offset;
+	else if (!strncmp(chunk_id, ICP_QAT_SUOF_OBJS, ICP_QAT_MOF_OBJ_ID_LEN))
+		mobj_handle->sobjs_hdr = mobj_handle->mof_buf +
+					 mof_chunkhdr->offset;
+}
+
+static int qat_uclo_check_mof_format(struct icp_qat_mof_file_hdr *mof_hdr)
+{
+	int maj = mof_hdr->maj_ver & 0xff;
+	int min = mof_hdr->min_ver & 0xff;
+
+	if (mof_hdr->file_id != ICP_QAT_MOF_FID) {
+		pr_err("QAT: invalid header 0x%x\n", mof_hdr->file_id);
+		return -EINVAL;
+	}
+
+	if (mof_hdr->num_chunks <= 0x1) {
+		pr_err("QAT: MOF chunk amount is incorrect\n");
+		return -EINVAL;
+	}
+	if (maj != ICP_QAT_MOF_MAJVER || min != ICP_QAT_MOF_MINVER) {
+		pr_err("QAT: bad MOF version, major 0x%x, minor 0x%x\n",
+		       maj, min);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int qat_uclo_map_mof_obj(struct icp_qat_fw_loader_handle *handle,
+				struct icp_qat_mof_file_hdr *mof_ptr,
+				u32 mof_size, char *obj_name, char **obj_ptr,
+				unsigned int *obj_size)
+{
+	struct icp_qat_mof_chunkhdr *mof_chunkhdr;
+	unsigned int file_id = mof_ptr->file_id;
+	struct icp_qat_mof_handle *mobj_handle;
+	unsigned short chunks_num;
+	unsigned int i;
+	int ret;
+
+	if (file_id == ICP_QAT_UOF_FID || file_id == ICP_QAT_SUOF_FID) {
+		if (obj_ptr)
+			*obj_ptr = (char *)mof_ptr;
+		if (obj_size)
+			*obj_size = mof_size;
+		return 0;
+	}
+	if (qat_uclo_check_mof_format(mof_ptr))
+		return -EINVAL;
+
+	mobj_handle = kzalloc(sizeof(*mobj_handle), GFP_KERNEL);
+	if (!mobj_handle)
+		return -ENOMEM;
+
+	handle->mobj_handle = mobj_handle;
+	ret = qat_uclo_map_mof_file_hdr(handle, mof_ptr, mof_size);
+	if (ret)
+		return ret;
+
+	mof_chunkhdr = (void *)mof_ptr + sizeof(*mof_ptr);
+	chunks_num = mof_ptr->num_chunks;
+
+	/* Parse MOF file chunks */
+	for (i = 0; i < chunks_num; i++)
+		qat_uclo_map_mof_chunk(mobj_handle, &mof_chunkhdr[i]);
+
+	/* All sym_objs uobjs and sobjs should be available */
+	if (!mobj_handle->sym_str ||
+	    (!mobj_handle->uobjs_hdr && !mobj_handle->sobjs_hdr))
+		return -EINVAL;
+
+	ret = qat_uclo_map_objs_from_mof(mobj_handle);
+	if (ret)
+		return ret;
+
+	/* Seek specified uof object in MOF */
+	return qat_uclo_seek_obj_inside_mof(mobj_handle, obj_name,
+					    obj_ptr, obj_size);
+}
+
 int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
-		     void *addr_ptr, int mem_size)
+		     void *addr_ptr, u32 mem_size, char *obj_name)
 {
+	char *obj_addr;
+	u32 obj_size;
+	int ret;
+
 	BUILD_BUG_ON(ICP_QAT_UCLO_MAX_AE >=
 		     (sizeof(handle->hal_handle->ae_mask) * 8));
 
 	if (!handle || !addr_ptr || mem_size < 24)
 		return -EINVAL;
 
+	if (obj_name) {
+		ret = qat_uclo_map_mof_obj(handle, addr_ptr, mem_size, obj_name,
+					   &obj_addr, &obj_size);
+		if (ret)
+			return ret;
+	} else {
+		obj_addr = addr_ptr;
+		obj_size = mem_size;
+	}
+
 	return (handle->fw_auth) ?
-			qat_uclo_map_suof_obj(handle, addr_ptr, mem_size) :
-			qat_uclo_map_uof_obj(handle, addr_ptr, mem_size);
+			qat_uclo_map_suof_obj(handle, obj_addr, obj_size) :
+			qat_uclo_map_uof_obj(handle, obj_addr, obj_size);
 }
 
 void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle)
@@ -1456,6 +1710,8 @@ void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle)
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned int a;
 
+	if (handle->mobj_handle)
+		qat_uclo_del_mof(handle);
 	if (handle->sobj_handle)
 		qat_uclo_del_suof(handle);
 	if (!obj_handle)
-- 
2.25.4

