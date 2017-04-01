From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG: handle 0 lengths in af_alg_make_sg
Date: Sat, 01 Apr 2017 17:04:28 +0200
Message-ID: <2380853.MJYDG7HQLD@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58726 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdDAPEn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 11:04:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

If you concur with the patch, I think it should go to 4.11 as well as
to stable.

Ciao
Stephan

---8<---

The function af_alg_make_sg converts user-provided IOVECs into an SGL.
Thus it operates directly on the user-space provided number of IOVECs.
When user space provides 0 for the number of IOVECs iov_iter_get_pages
returns a bogus number of bytes. This in turn will cause a crash when
the SGL is processed.

The fix initializes an SGL with one entry for handling chaining
operation but does not contain data.

In addition, the patch changes variable type of len from int to size_t
to be consistent with the data type of the invoker and the data type
where len is used.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 10 +++++++++-
 include/crypto/if_alg.h |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 24dc082..5992997 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -399,12 +399,20 @@ static const struct net_proto_family alg_family = {
 	.owner	=	THIS_MODULE,
 };
 
-int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len)
+int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, size_t len)
 {
 	size_t off;
 	ssize_t n;
 	int npages, i;
 
+	if (!len) {
+		/* init one for linking */
+		sg_init_table(sgl->sg, 1);
+		sg_mark_end(sgl->sg);
+		sgl->npages = 0;
+		return 0;
+	}
+
 	n = iov_iter_get_pages(iter, sgl->pages, len, ALG_MAX_PAGES, &off);
 	if (n < 0)
 		return n;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 6c3e6e7..c637ac9 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -76,7 +76,7 @@ int af_alg_release(struct socket *sock);
 void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock);
 
-int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
+int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, size_t len);
 void af_alg_free_sg(struct af_alg_sgl *sgl);
 void af_alg_link_sg(struct af_alg_sgl *sgl_prev, struct af_alg_sgl *sgl_new);
 
-- 
2.9.3
