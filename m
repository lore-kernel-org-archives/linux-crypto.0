From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 06/10] crypto: qat: Cleanup - change slice->regions to
	slice->region
Date: Fri, 25 Jul 2014 15:55:41 -0700
Message-ID: <20140725225541.24909.28307.stgit@gitlad.jf.intel.com>
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
Received: from mga03.intel.com ([143.182.124.21]:57408 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWzn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:43 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change ptr name slice->regions to slice->region to reflect the same
in the page struct.

Signed-off-by: Pingchao Yang <pingchao.yang@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/icp_qat_uclo.h |    2 +-
 drivers/crypto/qat/qat_common/qat_uclo.c     |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index 120fbce..2132a8c 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -124,7 +124,7 @@ struct icp_qat_uclo_region {
 };
 
 struct icp_qat_uclo_aeslice {
-	struct icp_qat_uclo_region *regions;
+	struct icp_qat_uclo_region *region;
 	struct icp_qat_uclo_page *page;
 	struct icp_qat_uclo_page *cur_page[ICP_QAT_UCLO_MAX_CTX];
 	struct icp_qat_uclo_encapme *encap_image;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index b1a16eb..557fa60 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -79,37 +79,37 @@ static int qat_uclo_init_ae_data(struct icp_qat_uclo_objhandle *obj_handle,
 	} else {
 		ae_slice->ctx_mask_assigned = 0;
 	}
-	ae_slice->regions = kzalloc(sizeof(*ae_slice->regions), GFP_KERNEL);
-	if (!ae_slice->regions)
+	ae_slice->region = kzalloc(sizeof(*ae_slice->region), GFP_KERNEL);
+	if (!ae_slice->region)
 		return -ENOMEM;
 	ae_slice->page = kzalloc(sizeof(*ae_slice->page), GFP_KERNEL);
 	if (!ae_slice->page)
 		goto out_err;
 	page = ae_slice->page;
 	page->encap_page = encap_image->page;
-	ae_slice->page->region = ae_slice->regions;
+	ae_slice->page->region = ae_slice->region;
 	ae_data->slice_num++;
 	return 0;
 out_err:
-	kfree(ae_slice->regions);
-	ae_slice->regions = NULL;
+	kfree(ae_slice->region);
+	ae_slice->region = NULL;
 	return -ENOMEM;
 }
 
 static int qat_uclo_free_ae_data(struct icp_qat_uclo_aedata *ae_data)
 {
-	unsigned int ss = 0;
+	unsigned int i;
 
 	if (!ae_data) {
 		pr_err("QAT: bad argument, ae_data is NULL\n ");
 		return -EINVAL;
 	}
 
-	for (ss = 0; ss < ae_data->slice_num; ss++) {
-		kfree(ae_data->ae_slices[ss].regions);
-		ae_data->ae_slices[ss].regions = NULL;
-		kfree(ae_data->ae_slices[ss].page);
-		ae_data->ae_slices[ss].page = NULL;
+	for (i = 0; i < ae_data->slice_num; i++) {
+		kfree(ae_data->ae_slices[i].region);
+		ae_data->ae_slices[i].region = NULL;
+		kfree(ae_data->ae_slices[i].page);
+		ae_data->ae_slices[i].page = NULL;
 	}
 	return 0;
 }
