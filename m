Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:59081 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbeJRWF5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 18:05:57 -0400
From: Ganesh Goudar <ganeshgr@chelsio.com>
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com,
        harsh@chelsio.com, linux-crypto@vger.kernel.org,
        Ganesh Goudar <ganeshgr@chelsio.com>
Subject: [PATCH net-next] cxgb4: fix the error path of cxgb4_uld_register()
Date: Thu, 18 Oct 2018 19:34:19 +0530
Message-Id: <1539871459-6921-1-git-send-email-ganeshgr@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On multi adapter setup if the uld registration fails even on
one adapter, the allocated resources for the uld on all the
adapters are freed, rendering the functioning adapters unusable.

This commit fixes the issue by freeing the allocated resources
only for the failed adapter.

Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c             |  4 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 46 ++++++--------------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h |  2 +-
 3 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 04f277c..62249d4 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -237,9 +237,7 @@ static int chcr_uld_state_change(void *handle, enum cxgb4_state state)
 
 static int __init chcr_crypto_init(void)
 {
-	if (cxgb4_register_uld(CXGB4_ULD_CRYPTO, &chcr_uld_info))
-		pr_err("ULD register fail: No chcr crypto support in cxgb4\n");
-
+	cxgb4_register_uld(CXGB4_ULD_CRYPTO, &chcr_uld_info);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 4bc2110..2673226 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -702,15 +702,14 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
  *	about any presently available devices that support its type.  Returns
  *	%-EBUSY if a ULD of the same type is already registered.
  */
-int cxgb4_register_uld(enum cxgb4_uld type,
-		       const struct cxgb4_uld_info *p)
+void cxgb4_register_uld(enum cxgb4_uld type,
+			const struct cxgb4_uld_info *p)
 {
 	int ret = 0;
-	unsigned int adap_idx = 0;
 	struct adapter *adap;
 
 	if (type >= CXGB4_ULD_MAX)
-		return -EINVAL;
+		return;
 
 	mutex_lock(&uld_mutex);
 	list_for_each_entry(adap, &adapter_list, list_node) {
@@ -733,52 +732,29 @@ int cxgb4_register_uld(enum cxgb4_uld type,
 		}
 		if (adap->flags & FULL_INIT_DONE)
 			enable_rx_uld(adap, type);
-		if (adap->uld[type].add) {
-			ret = -EBUSY;
+		if (adap->uld[type].add)
 			goto free_irq;
-		}
 		ret = setup_sge_txq_uld(adap, type, p);
 		if (ret)
 			goto free_irq;
 		adap->uld[type] = *p;
 		uld_attach(adap, type);
-		adap_idx++;
-	}
-	mutex_unlock(&uld_mutex);
-	return 0;
-
+		continue;
 free_irq:
-	if (adap->flags & FULL_INIT_DONE)
-		quiesce_rx_uld(adap, type);
-	if (adap->flags & USING_MSIX)
-		free_msix_queue_irqs_uld(adap, type);
-free_rxq:
-	free_sge_queues_uld(adap, type);
-free_queues:
-	free_queues_uld(adap, type);
-out:
-
-	list_for_each_entry(adap, &adapter_list, list_node) {
-		if ((type == CXGB4_ULD_CRYPTO && !is_pci_uld(adap)) ||
-		    (type != CXGB4_ULD_CRYPTO && !is_offload(adap)))
-			continue;
-		if (type == CXGB4_ULD_ISCSIT && is_t4(adap->params.chip))
-			continue;
-		if (!adap_idx)
-			break;
-		adap->uld[type].handle = NULL;
-		adap->uld[type].add = NULL;
-		release_sge_txq_uld(adap, type);
 		if (adap->flags & FULL_INIT_DONE)
 			quiesce_rx_uld(adap, type);
 		if (adap->flags & USING_MSIX)
 			free_msix_queue_irqs_uld(adap, type);
+free_rxq:
 		free_sge_queues_uld(adap, type);
+free_queues:
 		free_queues_uld(adap, type);
-		adap_idx--;
+out:
+		dev_warn(adap->pdev_dev,
+			 "ULD registration failed for uld type %d\n", type);
 	}
 	mutex_unlock(&uld_mutex);
-	return ret;
+	return;
 }
 EXPORT_SYMBOL(cxgb4_register_uld);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index de9ad31..5fa9a2d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -384,7 +384,7 @@ struct cxgb4_uld_info {
 	int (*tx_handler)(struct sk_buff *skb, struct net_device *dev);
 };
 
-int cxgb4_register_uld(enum cxgb4_uld type, const struct cxgb4_uld_info *p);
+void cxgb4_register_uld(enum cxgb4_uld type, const struct cxgb4_uld_info *p);
 int cxgb4_unregister_uld(enum cxgb4_uld type);
 int cxgb4_ofld_send(struct net_device *dev, struct sk_buff *skb);
 int cxgb4_immdata_send(struct net_device *dev, unsigned int idx,
-- 
2.1.0
