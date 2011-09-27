From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 17/17] crypto: Add userspace report for compress type
 algorithms
Date: Tue, 27 Sep 2011 07:48:48 +0200
Message-ID: <20110927054848.GT1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33013 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab1I0Fsv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:48:51 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/crypto_user.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 52459ae..748990f 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -89,6 +89,21 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp rcomp;
+
+	snprintf(rcomp.type, CRYPTO_MAX_ALG_NAME, "%s", "compression");
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		sizeof(struct crypto_report_comp), &rcomp);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
@@ -127,6 +142,11 @@ static int crypto_report_one(struct crypto_alg *alg,
 			goto nla_put_failure;
 
 		break;
+	case CRYPTO_ALG_TYPE_COMPRESS:
+		if (crypto_report_comp(skb, alg))
+			goto nla_put_failure;
+
+		break;
 	}
 
 out:
-- 
1.7.0.4
