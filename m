From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v2 2/2] crypto: qat - fix resource release omissions
Date: Tue, 6 Sep 2016 11:18:51 +0100
Message-ID: <20160906101851.GA27032@sivswdev01.ir.intel.com>
References: <20160902144753.31334-1-lambert.quentin@gmail.com>
 <20160902144753.31334-3-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, giovanni.cabiddu@gmail.com,
        giovanni.cabiddu@intel.com
To: Quentin Lambert <lambert.quentin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:60583 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934463AbcIFKTE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 06:19:04 -0400
Content-Disposition: inline
In-Reply-To: <20160902144753.31334-3-lambert.quentin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Lambert,

On Fri, Sep 02, 2016 at 04:47:53PM +0200, Quentin Lambert wrote:
> In certain cases qat_uclo_parse_uof_obj used to return with an error code
> before releasing all resources. This patch add a jump to the appropriate label
> ensuring that the resources are properly released before returning.
> 
> This issue was found with Hector.
Thanks for the patches. This can be easily fixed by moving the kcalloc after 
the compatibility check function. What do you think?

---8<---
Subject: [PATCH] crypto: qat - fix leak on error path

Fix a memory leak in an error path in uc loader.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 9b961b3..e2454d9 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -967,10 +967,6 @@ static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned int ae;
 
-	obj_handle->uword_buf = kcalloc(UWORD_CPYBUF_SIZE, sizeof(uint64_t),
-					GFP_KERNEL);
-	if (!obj_handle->uword_buf)
-		return -ENOMEM;
 	obj_handle->encap_uof_obj.beg_uof = obj_handle->obj_hdr->file_buff;
 	obj_handle->encap_uof_obj.obj_hdr = (struct icp_qat_uof_objhdr *)
 					     obj_handle->obj_hdr->file_buff;
@@ -982,6 +978,10 @@ static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
 		pr_err("QAT: UOF incompatible\n");
 		return -EINVAL;
 	}
+	obj_handle->uword_buf = kcalloc(UWORD_CPYBUF_SIZE, sizeof(uint64_t),
+					GFP_KERNEL);
+	if (!obj_handle->uword_buf)
+		return -ENOMEM;
 	obj_handle->ustore_phy_size = ICP_QAT_UCLO_MAX_USTORE;
 	if (!obj_handle->obj_hdr->file_buff ||
 	    !qat_uclo_map_str_table(obj_handle->obj_hdr, ICP_QAT_UOF_STRT,
-- 
