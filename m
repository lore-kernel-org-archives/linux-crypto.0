From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] chtls_netdev() can be static
Date: Thu, 15 Feb 2018 20:26:39 +0800
Message-ID: <20180215122639.GA128160@lkp-hsx02>
References: <1518437249-14732-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, davejwatson@fb.com, herbert@gondor.apana.org.au,
        sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1518437249-14732-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Fixes: 5995a3b59239 ("Makefile Kconfig")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 chtls_main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 58efb4a..3452f44 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -136,8 +136,8 @@ static int chtls_stop_listen(struct sock *sk)
 	return 0;
 }
 
-struct net_device *chtls_netdev(struct tls_device *dev,
-				struct net_device *netdev)
+static struct net_device *chtls_netdev(struct tls_device *dev,
+				       struct net_device *netdev)
 {
 	struct chtls_dev *cdev = to_chtls_dev(dev);
 	int i;
@@ -149,12 +149,12 @@ struct net_device *chtls_netdev(struct tls_device *dev,
 	return cdev->ports[i];
 }
 
-void chtls_update_prot(struct tls_device *dev, struct sock *sk)
+static void chtls_update_prot(struct tls_device *dev, struct sock *sk)
 {
 	sk->sk_prot = &chtls_base_prot;
 }
 
-int chtls_inline_feature(struct tls_device *dev)
+static int chtls_inline_feature(struct tls_device *dev)
 {
 	struct chtls_dev *cdev = to_chtls_dev(dev);
 	struct net_device *netdev;
@@ -168,14 +168,14 @@ int chtls_inline_feature(struct tls_device *dev)
 	return 1;
 }
 
-int chtls_create_hash(struct tls_device *dev, struct sock *sk)
+static int chtls_create_hash(struct tls_device *dev, struct sock *sk)
 {
 	if (sk->sk_state == TCP_LISTEN)
 		return chtls_start_listen(sk);
 	return 0;
 }
 
-void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
+static void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
 {
 	if (sk->sk_state == TCP_LISTEN)
 		chtls_stop_listen(sk);
