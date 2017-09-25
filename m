From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 4/5] crypto: qat: pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 16:06:15 +0530
Message-ID: <1506335776-1887-5-git-send-email-arvind.yadav.cs@gmail.com>
References: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, arei.gonglei@huawei.com, harsh@chelsio.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index e2454d9..399604c 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -567,26 +567,26 @@ static unsigned int qat_uclo_calc_str_checksum(char *ptr, int num)
 		       code_page->imp_expr_tab_offset);
 	if (uc_var_tab->entry_num || imp_var_tab->entry_num ||
 	    imp_expr_tab->entry_num) {
-		pr_err("QAT: UOF can't contain imported variable to be parsed");
+		pr_err("QAT: UOF can't contain imported variable to be parsed\n");
 		return -EINVAL;
 	}
 	neigh_reg_tab = (struct icp_qat_uof_objtable *)
 			(encap_uof_obj->beg_uof +
 			code_page->neigh_reg_tab_offset);
 	if (neigh_reg_tab->entry_num) {
-		pr_err("QAT: UOF can't contain shared control store feature");
+		pr_err("QAT: UOF can't contain shared control store feature\n");
 		return -EINVAL;
 	}
 	if (image->numpages > 1) {
-		pr_err("QAT: UOF can't contain multiple pages");
+		pr_err("QAT: UOF can't contain multiple pages\n");
 		return -EINVAL;
 	}
 	if (ICP_QAT_SHARED_USTORE_MODE(image->ae_mode)) {
-		pr_err("QAT: UOF can't use shared control store feature");
+		pr_err("QAT: UOF can't use shared control store feature\n");
 		return -EFAULT;
 	}
 	if (RELOADABLE_CTX_SHARED_MODE(image->ae_mode)) {
-		pr_err("QAT: UOF can't use reloadable feature");
+		pr_err("QAT: UOF can't use reloadable feature\n");
 		return -EFAULT;
 	}
 	return 0;
@@ -702,7 +702,7 @@ static int qat_uclo_map_ae(struct icp_qat_fw_loader_handle *handle, int max_ae)
 		}
 	}
 	if (!mflag) {
-		pr_err("QAT: uimage uses AE not set");
+		pr_err("QAT: uimage uses AE not set\n");
 		return -EINVAL;
 	}
 	return 0;
-- 
1.9.1
