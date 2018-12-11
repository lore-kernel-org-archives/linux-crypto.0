Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:43213 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbeLKIEQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 03:04:16 -0500
From: YueHaibing <yuehaibing@huawei.com>
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: chelsio - remove set but not used variable 'kctx_len'
Date: Tue, 11 Dec 2018 08:11:59 +0000
Message-ID: <1544515919-193254-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/chelsio/chcr_ipsec.c: In function 'chcr_ipsec_xmit':
drivers/crypto/chelsio/chcr_ipsec.c:674:33: warning:
 variable 'kctx_len' set but not used [-Wunused-but-set-variable]
  unsigned int flits = 0, ndesc, kctx_len;

It not used since commit 8362ea16f69f ("crypto: chcr - ESN for Inline IPSec Tx")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 9321d2b..82ca331 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -671,7 +671,7 @@ int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ipsec_sa_entry *sa_entry;
 	u64 *pos, *end, *before, *sgl;
 	int qidx, left, credits;
-	unsigned int flits = 0, ndesc, kctx_len;
+	unsigned int flits = 0, ndesc;
 	struct adapter *adap;
 	struct sge_eth_txq *q;
 	struct port_info *pi;
@@ -682,7 +682,6 @@ int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 
 	sa_entry = (struct ipsec_sa_entry *)x->xso.offload_handle;
-	kctx_len = sa_entry->kctx_len;
 
 	if (skb->sp->len != 1) {
 out_free:       dev_kfree_skb_any(skb);
