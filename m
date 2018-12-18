Return-Path: <SRS0=al0q=O3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:44861 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbeLRCSr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Dec 2018 21:18:47 -0500
From: YueHaibing <yuehaibing@huawei.com>
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        Kees Cook <keescook@chromium.org>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: chtls - remove set but not used variables 'err, adap, request, hws'
Date: Tue, 18 Dec 2018 02:26:14 +0000
Message-ID: <1545099974-39327-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/chelsio/chtls/chtls_io.c: In function 'csk_wait_memory':
drivers/crypto/chelsio/chtls/chtls_io.c:925:6: warning:
 variable 'sndbuf' set but not used [-Wunused-but-set-variable]

drivers/crypto/chelsio/chtls/chtls_io.c: In function 'chtls_pt_recvmsg':
drivers/crypto/chelsio/chtls/chtls_io.c:1411:6: warning:
 variable 'request' set but not used [-Wunused-but-set-variable]

drivers/crypto/chelsio/chtls/chtls_io.c:1407:18: warning:
 variable 'adap' set but not used [-Wunused-but-set-variable]

drivers/crypto/chelsio/chtls/chtls_io.c: In function 'chtls_recvmsg':
drivers/crypto/chelsio/chtls/chtls_io.c:1701:6: warning:
 variable 'request' set but not used [-Wunused-but-set-variable]

drivers/crypto/chelsio/chtls/chtls_io.c:1697:20: warning:
 variable 'hws' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 18f553f..1285a1b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -922,14 +922,13 @@ static int csk_wait_memory(struct chtls_dev *cdev,
 			   struct sock *sk, long *timeo_p)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	int sndbuf, err = 0;
+	int err = 0;
 	long current_timeo;
 	long vm_wait = 0;
 	bool noblock;
 
 	current_timeo = *timeo_p;
 	noblock = (*timeo_p ? false : true);
-	sndbuf = cdev->max_host_sndbuf;
 	if (csk_mem_free(cdev, sk)) {
 		current_timeo = (prandom_u32() % (HZ / 5)) + 2;
 		vm_wait = (prandom_u32() % (HZ / 5)) + 2;
@@ -1401,23 +1400,18 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			    int nonblock, int flags, int *addr_len)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
-	struct net_device *dev = csk->egress_dev;
 	struct chtls_hws *hws = &csk->tlshws;
 	struct tcp_sock *tp = tcp_sk(sk);
-	struct adapter *adap;
 	unsigned long avail;
 	int buffers_freed;
 	int copied = 0;
-	int request;
 	int target;
 	long timeo;
 
-	adap = netdev2adap(dev);
 	buffers_freed = 0;
 
 	timeo = sock_rcvtimeo(sk, nonblock);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-	request = len;
 
 	if (unlikely(csk_flag(sk, CSK_UPDATE_RCV_WND)))
 		chtls_cleanup_rbuf(sk, copied);
@@ -1694,11 +1688,9 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct chtls_sock *csk;
-	struct chtls_hws *hws;
 	unsigned long avail;    /* amount of available data in current skb */
 	int buffers_freed;
 	int copied = 0;
-	int request;
 	long timeo;
 	int target;             /* Read at least this many bytes */
 
@@ -1718,7 +1710,6 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	lock_sock(sk);
 	csk = rcu_dereference_sk_user_data(sk);
-	hws = &csk->tlshws;
 
 	if (is_tls_rx(csk))
 		return chtls_pt_recvmsg(sk, msg, len, nonblock,
@@ -1726,7 +1717,6 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	timeo = sock_rcvtimeo(sk, nonblock);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-	request = len;
 
 	if (unlikely(csk_flag(sk, CSK_UPDATE_RCV_WND)))
 		chtls_cleanup_rbuf(sk, copied);
