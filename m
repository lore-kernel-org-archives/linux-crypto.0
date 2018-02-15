From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v5 01/12] tls: tls_device struct to register TLS drivers
Date: Thu, 15 Feb 2018 12:24:43 +0530
Message-ID: <1518677694-28448-2-git-send-email-atul.gupta@chelsio.com>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

tls_device structure to register Inline TLS drivers
with net/tls

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/net/tls.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 936cfc5..6b64510 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -55,6 +55,28 @@
 
 #define TLS_AAD_SPACE_SIZE		13
 
+#define TLS_DEVICE_NAME_MAX             32
+
+enum {
+	TLS_BASE_TX,
+	TLS_SW_TX,
+	TLS_FULL_HW, /* TLS record processed Inline */
+	TLS_NUM_CONFIG,
+};
+extern struct proto tls_prots[TLS_NUM_CONFIG];
+
+struct tls_device {
+	char name[TLS_DEVICE_NAME_MAX];
+	struct list_head dev_list;
+
+	/* netdev present in registered inline tls driver */
+	int (*netdev)(struct tls_device *device,
+		      struct net_device *netdev);
+	int (*feature)(struct tls_device *device);
+	int (*hash)(struct tls_device *device, struct sock *sk);
+	void (*unhash)(struct tls_device *device, struct sock *sk);
+};
+
 struct tls_sw_context {
 	struct crypto_aead *aead_send;
 
@@ -254,5 +276,7 @@ static inline struct tls_offload_context *tls_offload_ctx(
 
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
+void tls_register_device(struct tls_device *device);
+void tls_unregister_device(struct tls_device *device);
 
 #endif /* _TLS_OFFLOAD_H */
-- 
1.8.3.1
