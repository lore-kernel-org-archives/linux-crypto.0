From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v15 net-next 02/12] ethtool: enable Inline TLS in HW
Date: Sat, 31 Mar 2018 21:41:53 +0530
Message-ID: <1522512723-31747-3-git-send-email-atul.gupta@chelsio.com>
References: <1522512723-31747-1-git-send-email-atul.gupta@chelsio.com>
Cc: davejwatson@fb.com, sd@queasysnail.net, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com, atul.gupta@chelsio.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522512723-31747-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ethtool option enables TLS record offload on HW, user
configures the feature for netdev capable of Inline TLS.
This allows user to define custom sk_prot for Inline TLS sock

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/linux/netdev_features.h | 2 ++
 net/core/ethtool.c              | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index db84c51..35b79f4 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -79,6 +79,7 @@ enum {
 	NETIF_F_RX_UDP_TUNNEL_PORT_BIT, /* Offload of RX port for UDP tunnels */
 
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
+	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -145,6 +146,7 @@ enum {
 #define NETIF_F_HW_ESP		__NETIF_F(HW_ESP)
 #define NETIF_F_HW_ESP_TX_CSUM	__NETIF_F(HW_ESP_TX_CSUM)
 #define	NETIF_F_RX_UDP_TUNNEL_PORT  __NETIF_F(RX_UDP_TUNNEL_PORT)
+#define NETIF_F_HW_TLS_RECORD	__NETIF_F(HW_TLS_RECORD)
 
 #define for_each_netdev_feature(mask_addr, bit)	\
 	for_each_set_bit(bit, (unsigned long *)mask_addr, NETDEV_FEATURE_COUNT)
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index eb55252..03416e6 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -108,6 +108,7 @@ int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	[NETIF_F_HW_ESP_BIT] =		 "esp-hw-offload",
 	[NETIF_F_HW_ESP_TX_CSUM_BIT] =	 "esp-tx-csum-hw-offload",
 	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =	 "rx-udp_tunnel-port-offload",
+	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
 };
 
 static const char
-- 
1.8.3.1
