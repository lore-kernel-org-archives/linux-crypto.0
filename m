From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 2/2] crypto: user - Fix size of netlink dump message
Date: Mon, 26 Mar 2012 09:28:27 +0200
Message-ID: <20120326072827.GB16191@secunet.com>
References: <20120326072729.GA16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:50326 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab2CZH2d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Mar 2012 03:28:33 -0400
Content-Disposition: inline
In-Reply-To: <20120326072729.GA16191@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The default netlink message size limit might be exceeded when dumping a
lot of algorithms to userspace. As a result, not all of the instantiated
algorithms dumped to userspace. So calculate an upper bound on the message
size and call netlink_dump_start() with that value.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c       |    8 +++++++-
 include/linux/cryptouser.h |    3 +++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 38534aa..7fca04c 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -456,11 +456,17 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
+		struct crypto_alg *alg;
+		u16 dump_alloc = 0;
+
 		if (link->dump == NULL)
 			return -EINVAL;
 
+		list_for_each_entry(alg, &crypto_alg_list, cra_list)
+			dump_alloc += CRYPTO_REPORT_MAXSIZE;
+
 		return netlink_dump_start(crypto_nlsk, skb, nlh,
-					  link->dump, link->done, 0);
+					  link->dump, link->done, dump_alloc);
 	}
 
 	err = nlmsg_parse(nlh, crypto_msg_min[type], attrs, CRYPTOCFGA_MAX,
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
