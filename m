From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH] crypto: qat: Remove deprecated create_workqueue
Date: Wed, 8 Jun 2016 02:47:47 +0530
Message-ID: <20160607211746.GA17667@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Conor McLoughlin <conor.mcloughlin@intel.com>,
	Pingchao Yang <pingchao.yang@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	John Griffin <john.griffin@intel.com>,
	Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

alloc_workqueue replaces deprecated create_workqueue().

The workqueue device_reset_wq has workitem &reset_data->reset_work per
adf_reset_dev_data. The workqueue  pf2vf_resp_wq is a workqueue for
PF2VF responses has workitem &pf2vf_resp->pf2vf_resp_work per pf2vf_resp.
The workqueue adf_vf_stop_wq is used to call adf_dev_stop()
asynchronously.

Dedicated workqueues have been used in all cases since the workitems
on the workqueues are involved in operation of crypto which can be used in
the IO path which is depended upon during memory reclaim. Hence,
WQ_MEM_RECLAIM has been set to gurantee forward progress under memory
pressure.
Since there are only a fixed number of work items, explicit concurrency
limit is unnecessary.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c    | 3 ++-
 drivers/crypto/qat/qat_common/adf_sriov.c  | 2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index b40d9c8..7bfb57f 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -243,7 +243,8 @@ EXPORT_SYMBOL_GPL(adf_disable_aer);

 int adf_init_aer(void)
 {
-	device_reset_wq = create_workqueue("qat_device_reset_wq");
+	device_reset_wq = alloc_workqueue("qat_device_reset_wq",
+					  WQ_MEM_RECLAIM, 0);
 	return !device_reset_wq ? -EFAULT : 0;
 }

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 4a526e2..9320ae1 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL_GPL(adf_sriov_configure);
 int __init adf_init_pf_wq(void)
 {
 	/* Workqueue for PF2VF responses */
-	pf2vf_resp_wq = create_workqueue("qat_pf2vf_resp_wq");
+	pf2vf_resp_wq = alloc_workqueue("qat_pf2vf_resp_wq", WQ_MEM_RECLAIM, 0);

 	return !pf2vf_resp_wq ? -ENOMEM : 0;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index aa689ca..bf99e11 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -321,7 +321,7 @@ EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);

 int __init adf_init_vf_wq(void)
 {
-	adf_vf_stop_wq = create_workqueue("adf_vf_stop_wq");
+	adf_vf_stop_wq = alloc_workqueue("adf_vf_stop_wq", WQ_MEM_RECLAIM, 0);

 	return !adf_vf_stop_wq ? -EFAULT : 0;
 }
