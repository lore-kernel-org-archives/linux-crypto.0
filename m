Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbfAJUSY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/11] crypto: af_alg - make some functions static
Date: Thu, 10 Jan 2019 12:18:00 -0800
Message-Id: <20190110201802.82442-10-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Some exported functions in af_alg.c aren't used outside of that file.
Therefore, un-export them and make them 'static'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/af_alg.c         | 20 +++++++-------------
 include/crypto/if_alg.h |  7 -------
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 17eb09d222ff4..ccae4a7ada8ab 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -425,12 +425,12 @@ int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len)
 }
 EXPORT_SYMBOL_GPL(af_alg_make_sg);
 
-void af_alg_link_sg(struct af_alg_sgl *sgl_prev, struct af_alg_sgl *sgl_new)
+static void af_alg_link_sg(struct af_alg_sgl *sgl_prev,
+			   struct af_alg_sgl *sgl_new)
 {
 	sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
 	sg_chain(sgl_prev->sg, sgl_prev->npages + 1, sgl_new->sg);
 }
-EXPORT_SYMBOL_GPL(af_alg_link_sg);
 
 void af_alg_free_sg(struct af_alg_sgl *sgl)
 {
@@ -441,7 +441,7 @@ void af_alg_free_sg(struct af_alg_sgl *sgl)
 }
 EXPORT_SYMBOL_GPL(af_alg_free_sg);
 
-int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
+static int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 {
 	struct cmsghdr *cmsg;
 
@@ -480,7 +480,6 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(af_alg_cmsg_send);
 
 /**
  * af_alg_alloc_tsgl - allocate the TX SGL
@@ -488,7 +487,7 @@ EXPORT_SYMBOL_GPL(af_alg_cmsg_send);
  * @sk socket of connection to user space
  * @return: 0 upon success, < 0 upon error
  */
-int af_alg_alloc_tsgl(struct sock *sk)
+static int af_alg_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
@@ -517,7 +516,6 @@ int af_alg_alloc_tsgl(struct sock *sk)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(af_alg_alloc_tsgl);
 
 /**
  * aead_count_tsgl - Count number of TX SG entries
@@ -654,7 +652,7 @@ EXPORT_SYMBOL_GPL(af_alg_pull_tsgl);
  *
  * @areq Request holding the TX and RX SGL
  */
-void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
+static void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -683,7 +681,6 @@ void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
 	}
 }
-EXPORT_SYMBOL_GPL(af_alg_free_areq_sgls);
 
 /**
  * af_alg_wait_for_wmem - wait for availability of writable memory
@@ -692,7 +689,7 @@ EXPORT_SYMBOL_GPL(af_alg_free_areq_sgls);
  * @flags If MSG_DONTWAIT is set, then only report if function would sleep
  * @return 0 when writable memory is available, < 0 upon error
  */
-int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
+static int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = -ERESTARTSYS;
@@ -717,7 +714,6 @@ int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(af_alg_wait_for_wmem);
 
 /**
  * af_alg_wmem_wakeup - wakeup caller when writable memory is available
@@ -786,8 +782,7 @@ EXPORT_SYMBOL_GPL(af_alg_wait_for_data);
  *
  * @sk socket of connection to user space
  */
-
-void af_alg_data_wakeup(struct sock *sk)
+static void af_alg_data_wakeup(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
@@ -805,7 +800,6 @@ void af_alg_data_wakeup(struct sock *sk)
 	sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(af_alg_data_wakeup);
 
 /**
  * af_alg_sendmsg - implementation of sendmsg system call handler
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 482461d8931d9..0d464db74bf53 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -169,9 +169,6 @@ int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern);
 
 int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
 void af_alg_free_sg(struct af_alg_sgl *sgl);
-void af_alg_link_sg(struct af_alg_sgl *sgl_prev, struct af_alg_sgl *sgl_new);
-
-int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con);
 
 static inline struct alg_sock *alg_sk(struct sock *sk)
 {
@@ -230,15 +227,11 @@ static inline bool af_alg_readable(struct sock *sk)
 	return PAGE_SIZE <= af_alg_rcvbuf(sk);
 }
 
-int af_alg_alloc_tsgl(struct sock *sk);
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
-void af_alg_free_areq_sgls(struct af_alg_async_req *areq);
-int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags);
 void af_alg_wmem_wakeup(struct sock *sk);
 int af_alg_wait_for_data(struct sock *sk, unsigned flags);
-void af_alg_data_wakeup(struct sock *sk);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
-- 
2.20.1.97.g81188d93c3-goog
