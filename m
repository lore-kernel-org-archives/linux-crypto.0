From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v4 01/12] tls: tls_device struct to register TLS drivers
Date: Mon, 12 Feb 2018 17:33:48 +0530
Message-ID: <1518437028-14250-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

added tls_device structure to register Inline TLS
drivers with net/tls

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/net/tls.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 936cfc5..2a9f392 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -55,6 +55,25 @@
 
 #define TLS_AAD_SPACE_SIZE		13
 
+#define TLS_DEVICE_NAME_MAX            64
+
+struct tls_device {
+	char name[TLS_DEVICE_NAME_MAX];
+	struct list_head dev_list;
+
+	/* When calling get_netdev, the HW vendor's driver should return the
+	 * net device of device @device at port @port_num or NULL if such
+	 * a net device doesn't exist
+	 */
+	struct net_device *(*netdev)(struct tls_device *device,
+				     struct net_device *netdev);
+	int (*feature)(struct tls_device *device);
+	int (*hash)(struct tls_device *device, struct sock *sk);
+	void (*unhash)(struct tls_device *device, struct sock *sk);
+	void (*prot)(struct tls_device *device,
+		     struct sock *sk);
+};
+
 struct tls_sw_context {
 	struct crypto_aead *aead_send;
 
@@ -254,5 +273,7 @@ static inline struct tls_offload_context *tls_offload_ctx(
 
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
+void tls_register_device(struct tls_device *device);
+void tls_unregister_device(struct tls_device *device);
 
 #endif /* _TLS_OFFLOAD_H */
-- 
1.8.3.1
