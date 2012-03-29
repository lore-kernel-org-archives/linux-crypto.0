From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 2/2] crypto: user - Fix size of netlink dump message
Date: Thu, 29 Mar 2012 09:04:46 +0200
Message-ID: <20120329070446.GE1021@secunet.com>
References: <20120329070347.GD1021@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:34684 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915Ab2C2HEu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 03:04:50 -0400
Content-Disposition: inline
In-Reply-To: <20120329070347.GD1021@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The default netlink message size limit might be exceeded when dumping a
lot of algorithms to userspace. As a result, not all of the instantiated
algorithms dumped to userspace. So calculate an upper bound on the message
size and call netlink_dump_start() with that value.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |    8 ++++++++
 include/linux/cryptouser.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e91c161..f1ea0a0 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -457,12 +457,20 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
+		struct crypto_alg *alg;
+		u16 dump_alloc = 0;
+
 		if (link->dump == NULL)
 			return -EINVAL;
+
+		list_for_each_entry(alg, &crypto_alg_list, cra_list)
+			dump_alloc += CRYPTO_REPORT_MAXSIZE;
+
 		{
 			struct netlink_dump_control c = {
 				.dump = link->dump,
 				.done = link->done,
+				.min_dump_alloc = dump_alloc,
 			};
 			return netlink_dump_start(crypto_nlsk, skb, nlh, &c);
 		}
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 532fb58..4abf2ea 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -100,3 +100,6 @@ struct crypto_report_rng {
 	char type[CRYPTO_MAX_NAME];
 	unsigned int seedsize;
 };
+
+#define CRYPTO_REPORT_MAXSIZE (sizeof(struct crypto_user_alg) + \
+			       sizeof(struct crypto_report_blkcipher))
-- 
1.7.0.4
