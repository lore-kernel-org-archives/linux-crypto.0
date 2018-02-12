From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v4 02/12] ethtool: feature for Inline TLS in HW
Date: Mon, 12 Feb 2018 17:34:10 +0530
Message-ID: <1518437050-14298-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/linux/netdev_features.h | 2 ++
 net/core/ethtool.c              | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index b1b0ca7..e1a33b7 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -77,6 +77,7 @@ enum {
 	NETIF_F_HW_ESP_BIT,		/* Hardware ESP transformation offload */
 	NETIF_F_HW_ESP_TX_CSUM_BIT,	/* ESP with TX checksum offload */
 	NETIF_F_RX_UDP_TUNNEL_PORT_BIT, /* Offload of RX port for UDP tunnels */
+	NETIF_F_HW_TLS_INLINE_BIT,      /* Offload TLS record */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -142,6 +143,7 @@ enum {
 #define NETIF_F_HW_ESP		__NETIF_F(HW_ESP)
 #define NETIF_F_HW_ESP_TX_CSUM	__NETIF_F(HW_ESP_TX_CSUM)
 #define	NETIF_F_RX_UDP_TUNNEL_PORT  __NETIF_F(RX_UDP_TUNNEL_PORT)
+#define NETIF_F_HW_TLS_INLINE   __NETIF_F(HW_TLS_INLINE)
 
 #define for_each_netdev_feature(mask_addr, bit)	\
 	for_each_set_bit(bit, (unsigned long *)mask_addr, NETDEV_FEATURE_COUNT)
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index f8fcf45..cac1c77 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -106,6 +106,7 @@ int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	[NETIF_F_HW_ESP_BIT] =		 "esp-hw-offload",
 	[NETIF_F_HW_ESP_TX_CSUM_BIT] =	 "esp-tx-csum-hw-offload",
 	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =	 "rx-udp_tunnel-port-offload",
+	[NETIF_F_HW_TLS_INLINE_BIT] =    "tls-inline",
 };
 
 static const char
-- 
1.8.3.1
