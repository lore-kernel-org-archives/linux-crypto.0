From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 01/10] crypto: qat: Cleanup - remove unnecessary return codes
Date: Fri, 25 Jul 2014 15:55:09 -0700
Message-ID: <20140725225509.24909.8297.stgit@gitlad.jf.intel.com>
References: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <davem@davemloft.net>,
	<bruce.w.allan@intel.com>, <bo.cui@intel.com>,
	<pingchao.yang@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57331 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWzT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:19 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove unnecessary return code variables and change function types
accordingly.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/qat_uclo.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index dd4e0d3..f22b488 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1088,14 +1088,13 @@ static void qat_uclo_fill_uwords(struct icp_qat_uclo_objhandle *obj_handle,
 		*uword = fill;
 }
 
-static int qat_uclo_wr_uimage_raw_page(struct icp_qat_fw_loader_handle *handle,
-				       struct icp_qat_uclo_encap_page
-				       *encap_page, unsigned int ae)
+static void qat_uclo_wr_uimage_raw_page(struct icp_qat_fw_loader_handle *handle,
+					struct icp_qat_uclo_encap_page
+					*encap_page, unsigned int ae)
 {
 	unsigned int uw_physical_addr, uw_relative_addr, i, words_num, cpylen;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	uint64_t fill_pat;
-	int status = 0;
 
 	/* load the page starting at appropriate ustore address */
 	/* get fill-pattern from an image -- they are all the same */
@@ -1126,18 +1125,15 @@ static int qat_uclo_wr_uimage_raw_page(struct icp_qat_fw_loader_handle *handle,
 		uw_relative_addr += cpylen;
 		words_num -= cpylen;
 	}
-	return status;
 }
 
-static int
-qat_uclo_wr_uimage_pages(struct icp_qat_fw_loader_handle *handle,
-			 struct icp_qat_uof_image *image)
+static void qat_uclo_wr_uimage_pages(struct icp_qat_fw_loader_handle *handle,
+				     struct icp_qat_uof_image *image)
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned int ctx_mask, s;
 	struct icp_qat_uclo_page *page;
 	unsigned char ae;
-	int retval = 0;
 	int ctx;
 
 	if (ICP_QAT_CTX_MODE(image->ae_mode) == ICP_QAT_UCLO_MAX_CTX)
@@ -1160,8 +1156,7 @@ qat_uclo_wr_uimage_pages(struct icp_qat_fw_loader_handle *handle,
 		page = obj_handle->ae_data[ae].ae_slices[s].page;
 		if (!page->encap_page->def_page)
 			continue;
-		if (qat_uclo_wr_uimage_raw_page(handle, page->encap_page, ae))
-			return -EINVAL;
+		qat_uclo_wr_uimage_raw_page(handle, page->encap_page, ae);
 
 		page = obj_handle->ae_data[ae].ae_slices[s].page;
 		for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++)
@@ -1172,7 +1167,6 @@ qat_uclo_wr_uimage_pages(struct icp_qat_fw_loader_handle *handle,
 		qat_hal_set_pc(handle, (unsigned char)ae, image->ctx_assigned,
 			       image->entry_address);
 	}
-	return retval;
 }
 
 int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle)
@@ -1187,9 +1181,8 @@ int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle)
 			return -EINVAL;
 		if (qat_uclo_init_ustore(handle, &(obj_handle->ae_uimage[i])))
 			return -EINVAL;
-		if (qat_uclo_wr_uimage_pages(handle,
-					     obj_handle->ae_uimage[i].img_ptr))
-			return -EINVAL;
+		qat_uclo_wr_uimage_pages(handle,
+					 obj_handle->ae_uimage[i].img_ptr);
 	}
 	return 0;
 }
