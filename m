From: Ganesh Goudar <ganeshgr@chelsio.com>
Subject: [PATCH] chtls: fix null dereference chtls_free_uld()
Date: Fri, 10 Aug 2018 18:27:41 +0530
Message-ID: <1533905861-27339-1-git-send-email-ganeshgr@chelsio.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, indranil@chelsio.com,
        dt@chelsio.com, Ganesh Goudar <ganeshgr@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

call chtls_free_uld() only for the initialized cdev,
this fixes NULL dereference in chtls_free_uld()

Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h      | 5 +++++
 drivers/crypto/chelsio/chtls/chtls_main.c | 7 +++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index a53a0e6..7725b6e 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -96,6 +96,10 @@ enum csk_flags {
 	CSK_CONN_INLINE,	/* Connection on HW */
 };
 
+enum chtls_cdev_state {
+	CHTLS_CDEV_STATE_UP = 1
+};
+
 struct listen_ctx {
 	struct sock *lsk;
 	struct chtls_dev *cdev;
@@ -146,6 +150,7 @@ struct chtls_dev {
 	unsigned int send_page_order;
 	int max_host_sndbuf;
 	struct key_map kmap;
+	unsigned int cdev_state;
 };
 
 struct chtls_hws {
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 9b07f91..f59b044 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -160,6 +160,7 @@ static void chtls_register_dev(struct chtls_dev *cdev)
 	tlsdev->hash = chtls_create_hash;
 	tlsdev->unhash = chtls_destroy_hash;
 	tls_register_device(&cdev->tlsdev);
+	cdev->cdev_state = CHTLS_CDEV_STATE_UP;
 }
 
 static void chtls_unregister_dev(struct chtls_dev *cdev)
@@ -281,8 +282,10 @@ static void chtls_free_all_uld(void)
 	struct chtls_dev *cdev, *tmp;
 
 	mutex_lock(&cdev_mutex);
-	list_for_each_entry_safe(cdev, tmp, &cdev_list, list)
-		chtls_free_uld(cdev);
+	list_for_each_entry_safe(cdev, tmp, &cdev_list, list) {
+		if (cdev->cdev_state == CHTLS_CDEV_STATE_UP)
+			chtls_free_uld(cdev);
+	}
 	mutex_unlock(&cdev_mutex);
 }
 
-- 
2.1.0
