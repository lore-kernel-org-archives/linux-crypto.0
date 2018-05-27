From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v2 2/5] crypto: chtls: wait for memory sendmsg, sendpage
Date: Sun, 27 May 2018 21:15:19 +0530
Message-ID: <1527435922-6727-3-git-send-email-atul.gupta@chelsio.com>
References: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Cc: gustavo@embeddedor.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, davem@davemloft.net, atul.gupta@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

address suspicious code <gustavo@embeddedor.com>

1210       set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
1211       }

The issue is that in the code above, set_bit is never reached
due to the 'continue' statement at line 1208.

Also reported by bug report:<dan.carpenter@oracle.com>
1210       set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Not reachable.

Its required to wait for buffer in the send path and takes care of
unaddress and un-handled SOCK_NOSPACE.

v2: use csk_mem_free where appropriate
    proper indent of goto do_nonblock
    replace out with do_rm_wq

Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h      |  1 +
 drivers/crypto/chelsio/chtls/chtls_io.c   | 90 +++++++++++++++++++++++++++++--
 drivers/crypto/chelsio/chtls/chtls_main.c |  1 +
 3 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 1b2f43c..a53a0e6 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -144,6 +144,7 @@ struct chtls_dev {
 	struct list_head rcu_node;
 	struct list_head na_node;
 	unsigned int send_page_order;
+	int max_host_sndbuf;
 	struct key_map kmap;
 };
 
diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 840dd01..7aa5d90 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -914,6 +914,78 @@ static u16 tls_header_read(struct tls_hdr *thdr, struct iov_iter *from)
 	return (__force u16)cpu_to_be16(thdr->length);
 }
 
+static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
+{
+	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
+}
+
+static int csk_wait_memory(struct chtls_dev *cdev,
+			   struct sock *sk, long *timeo_p)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int sndbuf, err = 0;
+	long current_timeo;
+	long vm_wait = 0;
+	bool noblock;
+
+	current_timeo = *timeo_p;
+	noblock = (*timeo_p ? false : true);
+	sndbuf = cdev->max_host_sndbuf;
+	if (csk_mem_free(cdev, sk)) {
+		current_timeo = (prandom_u32() % (HZ / 5)) + 2;
+		vm_wait = (prandom_u32() % (HZ / 5)) + 2;
+	}
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	while (1) {
+		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
+
+		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
+			goto do_error;
+		if (!*timeo_p) {
+			if (noblock)
+				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+			goto do_nonblock;
+		}
+		if (signal_pending(current))
+			goto do_interrupted;
+		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
+		if (csk_mem_free(cdev, sk) && !vm_wait)
+			break;
+
+		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+		sk->sk_write_pending++;
+		sk_wait_event(sk, &current_timeo, sk->sk_err ||
+			      (sk->sk_shutdown & SEND_SHUTDOWN) ||
+			      (csk_mem_free(cdev, sk) && !vm_wait), &wait);
+		sk->sk_write_pending--;
+
+		if (vm_wait) {
+			vm_wait -= current_timeo;
+			current_timeo = *timeo_p;
+			if (current_timeo != MAX_SCHEDULE_TIMEOUT) {
+				current_timeo -= vm_wait;
+				if (current_timeo < 0)
+					current_timeo = 0;
+			}
+			vm_wait = 0;
+		}
+		*timeo_p = current_timeo;
+	}
+do_rm_wq:
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return err;
+do_error:
+	err = -EPIPE;
+	goto do_rm_wq;
+do_nonblock:
+	err = -EAGAIN;
+	goto do_rm_wq;
+do_interrupted:
+	err = sock_intr_errno(*timeo_p);
+	goto do_rm_wq;
+}
+
 int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
@@ -952,6 +1024,8 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			copy = mss - skb->len;
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		}
+		if (!csk_mem_free(cdev, sk))
+			goto wait_for_sndbuf;
 
 		if (is_tls_tx(csk) && !csk->tlshws.txleft) {
 			struct tls_hdr hdr;
@@ -1099,8 +1173,10 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND)
 			push_frames_if_head(sk);
 		continue;
+wait_for_sndbuf:
+		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 wait_for_memory:
-		err = sk_stream_wait_memory(sk, &timeo);
+		err = csk_wait_memory(cdev, sk, &timeo);
 		if (err)
 			goto do_error;
 	}
@@ -1131,6 +1207,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 		   int offset, size_t size, int flags)
 {
 	struct chtls_sock *csk;
+	struct chtls_dev *cdev;
 	int mss, err, copied;
 	struct tcp_sock *tp;
 	long timeo;
@@ -1138,6 +1215,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 	tp = tcp_sk(sk);
 	copied = 0;
 	csk = rcu_dereference_sk_user_data(sk);
+	cdev = csk->cdev;
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 
 	err = sk_stream_wait_connect(sk, &timeo);
@@ -1156,6 +1234,8 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
 		    copy <= 0) {
 new_buf:
+			if (!csk_mem_free(cdev, sk))
+				goto wait_for_sndbuf;
 
 			if (is_tls_tx(csk)) {
 				skb = get_record_skb(sk,
@@ -1167,7 +1247,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 				skb = get_tx_skb(sk, 0);
 			}
 			if (!skb)
-				goto do_error;
+				goto wait_for_memory;
 			copy = mss;
 		}
 		if (copy > size)
@@ -1206,8 +1286,12 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 		if (unlikely(ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND))
 			push_frames_if_head(sk);
 		continue;
-
+wait_for_sndbuf:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+wait_for_memory:
+		err = csk_wait_memory(cdev, sk, &timeo);
+		if (err)
+			goto do_error;
 	}
 out:
 	csk_reset_flag(csk, CSK_TX_MORE_DATA);
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 53ffb00..273afd3 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -238,6 +238,7 @@ static void *chtls_uld_add(const struct cxgb4_lld_info *info)
 	spin_lock_init(&cdev->idr_lock);
 	cdev->send_page_order = min_t(uint, get_order(32768),
 				      send_page_order);
+	cdev->max_host_sndbuf = 48 * 1024;
 
 	if (lldi->vr->key.size)
 		if (chtls_init_kmap(cdev, lldi))
-- 
1.8.3.1
