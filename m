From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 4/4] crypto: qat: Fix error path crash when no firmware is
 present
Date: Tue, 24 Jun 2014 15:19:40 -0700
Message-ID: <20140624221940.3872.55853.stgit@tstruk-mobl1.intel.com>
References: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaFXWWf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Jun 2014 18:22:35 -0400
In-Reply-To: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Firmware loader crashes when no firmware file is present.

Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2 +-
 drivers/crypto/qat/qat_common/qat_uclo.c       |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 3cea9fa..5e8f9d4 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -186,7 +186,7 @@ int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
 int qat_hal_wr_lm(struct icp_qat_fw_loader_handle *handle,
 		  unsigned char ae, unsigned short lm_addr, unsigned int value);
 int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle);
-int qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
+void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
 int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 			 void *addr_ptr, int mem_size);
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 20b6b42..dd4e0d3 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -959,8 +959,6 @@ static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
 	obj_handle->encap_uof_obj.beg_uof = obj_handle->obj_hdr->file_buff;
 	obj_handle->encap_uof_obj.obj_hdr = (struct icp_qat_uof_objhdr *)
 					     obj_handle->obj_hdr->file_buff;
-	obj_handle->encap_uof_obj.chunk_hdr = (struct icp_qat_uof_chunkhdr *)
-	   (obj_handle->obj_hdr->file_buff + sizeof(struct icp_qat_uof_objhdr));
 	obj_handle->uword_in_bytes = 6;
 	obj_handle->prod_type = ICP_QAT_AC_C_CPU_TYPE;
 	obj_handle->prod_rev = PID_MAJOR_REV |
@@ -1040,23 +1038,25 @@ out_objbuf_err:
 	return -ENOMEM;
 }
 
-int qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle)
+void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle)
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	int a;
 
+	if (!obj_handle)
+		return;
+
 	kfree(obj_handle->uword_buf);
 	for (a = 0; a < obj_handle->uimage_num; a++)
 		kfree(obj_handle->ae_uimage[a].page);
 
 	for (a = 0; a <= (int)handle->hal_handle->ae_max_num; a++)
 		qat_uclo_free_ae_data(&obj_handle->ae_data[a]);
-	kfree(obj_handle->obj_hdr);
 
+	kfree(obj_handle->obj_hdr);
 	kfree(obj_handle->obj_buf);
 	kfree(obj_handle);
 	handle->obj_handle = NULL;
-	return 0;
 }
 
 static void qat_uclo_fill_uwords(struct icp_qat_uclo_objhandle *obj_handle,
