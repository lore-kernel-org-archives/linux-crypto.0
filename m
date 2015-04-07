From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: user - Fix crypto_alg_match race
Date: Tue, 7 Apr 2015 21:27:01 +0800
Message-ID: <20150407132701.GA19476@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38156 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbbDGN1J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 09:27:09 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function crypto_alg_match returns an algorithm without taking
any references on it.  This means that the algorithm can be freed
at any time, therefore all users of crypto_alg_match are buggy.

This patch fixes this by taking a reference count on the algorithm
to prevent such races.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index eab2497..41dfe76 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -62,10 +62,14 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 		else if (!exact)
 			match = !strcmp(q->cra_name, p->cru_name);
 
-		if (match) {
-			alg = q;
-			break;
-		}
+		if (!match)
+			continue;
+
+		if (unlikely(!crypto_mod_get(q)))
+			continue;
+
+		alg = q;
+		break;
 	}
 
 	up_read(&crypto_alg_sem);
@@ -205,9 +209,10 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	if (!alg)
 		return -ENOENT;
 
+	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb)
-		return -ENOMEM;
+		goto drop_alg;
 
 	info.in_skb = in_skb;
 	info.out_skb = skb;
@@ -215,6 +220,10 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	info.nlmsg_flags = 0;
 
 	err = crypto_report_alg(alg, &info);
+
+drop_alg:
+	crypto_mod_put(alg);
+
 	if (err)
 		return err;
 
@@ -284,6 +293,7 @@ static int crypto_update_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	up_write(&crypto_alg_sem);
 
+	crypto_mod_put(alg);
 	crypto_remove_final(&list);
 
 	return 0;
@@ -294,6 +304,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct crypto_alg *alg;
 	struct crypto_user_alg *p = nlmsg_data(nlh);
+	int err;
 
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
@@ -310,13 +321,19 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	 * if we try to unregister. Unregistering such an algorithm without
 	 * removing the module is not possible, so we restrict to crypto
 	 * instances that are build from templates. */
+	err = -EINVAL;
 	if (!(alg->cra_flags & CRYPTO_ALG_INSTANCE))
-		return -EINVAL;
+		goto drop_alg;
 
-	if (atomic_read(&alg->cra_refcnt) != 1)
-		return -EBUSY;
+	err = -EBUSY;
+	if (atomic_read(&alg->cra_refcnt) > 2)
+		goto drop_alg;
 
-	return crypto_unregister_instance((struct crypto_instance *)alg);
+	err = crypto_unregister_instance((struct crypto_instance *)alg);
+
+drop_alg:
+	crypto_mod_put(alg);
+	return err;
 }
 
 static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32 type,
@@ -395,8 +412,10 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	alg = crypto_alg_match(p, exact);
-	if (alg)
+	if (alg) {
+		crypto_mod_put(alg);
 		return -EEXIST;
+	}
 
 	if (strlen(p->cru_driver_name))
 		name = p->cru_driver_name;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
