From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/7] [CRYPTO] users: Use crypto_comp and crypto_has_*
Date: Sat, 02 Sep 2006 21:06:51 +1000
Message-ID: <E1GJTKt-0001Fl-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44304 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751065AbWIBLGu
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:50 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] users: Use crypto_comp and crypto_has_*

This patch converts all users to use the new crypto_comp type and the
crypto_has_* functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c          |    8 ++++----
 drivers/crypto/padlock.c |    6 +++---
 drivers/net/ppp_mppe.c   |    4 ++--
 include/linux/crypto.h   |    5 +++++
 include/net/ipcomp.h     |    5 ++---
 net/ipv4/ipcomp.c        |   25 +++++++++++++------------
 net/ipv6/ipcomp6.c       |   25 +++++++++++++------------
 net/xfrm/xfrm_algo.c     |   27 ++++++++++++++++++---------
 8 files changed, 60 insertions(+), 45 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -749,7 +749,7 @@ static void test_deflate(void)
 {
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
-	struct crypto_tfm *tfm;
+	struct crypto_comp *tfm;
 	struct comp_testvec *tv;
 	unsigned int tsize;
 
@@ -821,7 +821,7 @@ static void test_deflate(void)
 		       ilen, dlen);
 	}
 out:
-	crypto_free_tfm(tfm);
+	crypto_free_comp(tfm);
 }
 
 static void test_available(void)
@@ -830,8 +830,8 @@ static void test_available(void)
 
 	while (*name) {
 		printk("alg %s ", *name);
-		printk((crypto_alg_available(*name, 0)) ?
-			"found\n" : "not found\n");
+		printk(crypto_has_alg(*name, 0, CRYPTO_ALG_ASYNC) ?
+		       "found\n" : "not found\n");
 		name++;
 	}
 }
diff --git a/drivers/crypto/padlock.c b/drivers/crypto/padlock.c
--- a/drivers/crypto/padlock.c
+++ b/drivers/crypto/padlock.c
@@ -26,13 +26,13 @@ static int __init padlock_init(void)
 {
 	int success = 0;
 
-	if (crypto_alg_available("aes-padlock", 0))
+	if (crypto_has_cipher("aes-padlock", 0, 0))
 		success++;
 
-	if (crypto_alg_available("sha1-padlock", 0))
+	if (crypto_has_hash("sha1-padlock", 0, 0))
 		success++;
 
-	if (crypto_alg_available("sha256-padlock", 0))
+	if (crypto_has_hash("sha256-padlock", 0, 0))
 		success++;
 
 	if (!success) {
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -710,8 +710,8 @@ static struct compressor ppp_mppe = {
 static int __init ppp_mppe_init(void)
 {
 	int answer;
-	if (!(crypto_alg_available("ecb(arc4)", 0) &&
-	      crypto_alg_available("sha1", 0)))
+	if (!(crypto_has_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC) &&
+	      crypto_has_hash("sha1", 0, CRYPTO_ALG_ASYNC)))
 		return -ENODEV;
 
 	sha_pad = kmalloc(sizeof(struct sha_pad), GFP_KERNEL);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -928,6 +928,11 @@ static inline int crypto_has_comp(const 
 	return crypto_has_alg(alg_name, type, mask);
 }
 
+static inline const char *crypto_comp_name(struct crypto_comp *tfm)
+{
+	return crypto_tfm_alg_name(crypto_comp_tfm(tfm));
+}
+
 static inline struct compress_tfm *crypto_comp_crt(struct crypto_comp *tfm)
 {
 	return &crypto_comp_tfm(tfm)->crt_compress;
diff --git a/include/net/ipcomp.h b/include/net/ipcomp.h
--- a/include/net/ipcomp.h
+++ b/include/net/ipcomp.h
@@ -1,15 +1,14 @@
 #ifndef _NET_IPCOMP_H
 #define _NET_IPCOMP_H
 
+#include <linux/crypto.h>
 #include <linux/types.h>
 
 #define IPCOMP_SCRATCH_SIZE     65400
 
-struct crypto_tfm;
-
 struct ipcomp_data {
 	u16 threshold;
-	struct crypto_tfm **tfms;
+	struct crypto_comp **tfms;
 };
 
 #endif
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -32,7 +32,7 @@
 
 struct ipcomp_tfms {
 	struct list_head list;
-	struct crypto_tfm **tfms;
+	struct crypto_comp **tfms;
 	int users;
 };
 
@@ -46,7 +46,7 @@ static int ipcomp_decompress(struct xfrm
 	int err, plen, dlen;
 	struct ipcomp_data *ipcd = x->data;
 	u8 *start, *scratch;
-	struct crypto_tfm *tfm;
+	struct crypto_comp *tfm;
 	int cpu;
 	
 	plen = skb->len;
@@ -107,7 +107,7 @@ static int ipcomp_compress(struct xfrm_s
 	struct iphdr *iph = skb->nh.iph;
 	struct ipcomp_data *ipcd = x->data;
 	u8 *start, *scratch;
-	struct crypto_tfm *tfm;
+	struct crypto_comp *tfm;
 	int cpu;
 	
 	ihlen = iph->ihl * 4;
@@ -302,7 +302,7 @@ static void **ipcomp_alloc_scratches(voi
 	return scratches;
 }
 
-static void ipcomp_free_tfms(struct crypto_tfm **tfms)
+static void ipcomp_free_tfms(struct crypto_comp **tfms)
 {
 	struct ipcomp_tfms *pos;
 	int cpu;
@@ -324,28 +324,28 @@ static void ipcomp_free_tfms(struct cryp
 		return;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_tfm *tfm = *per_cpu_ptr(tfms, cpu);
-		crypto_free_tfm(tfm);
+		struct crypto_comp *tfm = *per_cpu_ptr(tfms, cpu);
+		crypto_free_comp(tfm);
 	}
 	free_percpu(tfms);
 }
 
-static struct crypto_tfm **ipcomp_alloc_tfms(const char *alg_name)
+static struct crypto_comp **ipcomp_alloc_tfms(const char *alg_name)
 {
 	struct ipcomp_tfms *pos;
-	struct crypto_tfm **tfms;
+	struct crypto_comp **tfms;
 	int cpu;
 
 	/* This can be any valid CPU ID so we don't need locking. */
 	cpu = raw_smp_processor_id();
 
 	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
-		struct crypto_tfm *tfm;
+		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
 		tfm = *per_cpu_ptr(tfms, cpu);
 
-		if (!strcmp(crypto_tfm_alg_name(tfm), alg_name)) {
+		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
 			return tfms;
 		}
@@ -359,12 +359,13 @@ static struct crypto_tfm **ipcomp_alloc_
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_tfm *);
+	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
 	if (!tfms)
 		goto error;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_tfm *tfm = crypto_alloc_tfm(alg_name, 0);
+		struct crypto_comp *tfm = crypto_alloc_comp(alg_name, 0,
+							    CRYPTO_ALG_ASYNC);
 		if (!tfm)
 			goto error;
 		*per_cpu_ptr(tfms, cpu) = tfm;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -53,7 +53,7 @@
 
 struct ipcomp6_tfms {
 	struct list_head list;
-	struct crypto_tfm **tfms;
+	struct crypto_comp **tfms;
 	int users;
 };
 
@@ -70,7 +70,7 @@ static int ipcomp6_input(struct xfrm_sta
 	int plen, dlen;
 	struct ipcomp_data *ipcd = x->data;
 	u8 *start, *scratch;
-	struct crypto_tfm *tfm;
+	struct crypto_comp *tfm;
 	int cpu;
 
 	if (skb_linearize_cow(skb))
@@ -129,7 +129,7 @@ static int ipcomp6_output(struct xfrm_st
 	struct ipcomp_data *ipcd = x->data;
 	int plen, dlen;
 	u8 *start, *scratch;
-	struct crypto_tfm *tfm;
+	struct crypto_comp *tfm;
 	int cpu;
 
 	hdr_len = skb->h.raw - skb->data;
@@ -301,7 +301,7 @@ static void **ipcomp6_alloc_scratches(vo
 	return scratches;
 }
 
-static void ipcomp6_free_tfms(struct crypto_tfm **tfms)
+static void ipcomp6_free_tfms(struct crypto_comp **tfms)
 {
 	struct ipcomp6_tfms *pos;
 	int cpu;
@@ -323,28 +323,28 @@ static void ipcomp6_free_tfms(struct cry
 		return;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_tfm *tfm = *per_cpu_ptr(tfms, cpu);
-		crypto_free_tfm(tfm);
+		struct crypto_comp *tfm = *per_cpu_ptr(tfms, cpu);
+		crypto_free_comp(tfm);
 	}
 	free_percpu(tfms);
 }
 
-static struct crypto_tfm **ipcomp6_alloc_tfms(const char *alg_name)
+static struct crypto_comp **ipcomp6_alloc_tfms(const char *alg_name)
 {
 	struct ipcomp6_tfms *pos;
-	struct crypto_tfm **tfms;
+	struct crypto_comp **tfms;
 	int cpu;
 
 	/* This can be any valid CPU ID so we don't need locking. */
 	cpu = raw_smp_processor_id();
 
 	list_for_each_entry(pos, &ipcomp6_tfms_list, list) {
-		struct crypto_tfm *tfm;
+		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
 		tfm = *per_cpu_ptr(tfms, cpu);
 
-		if (!strcmp(crypto_tfm_alg_name(tfm), alg_name)) {
+		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
 			return tfms;
 		}
@@ -358,12 +358,13 @@ static struct crypto_tfm **ipcomp6_alloc
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp6_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_tfm *);
+	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
 	if (!tfms)
 		goto error;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_tfm *tfm = crypto_alloc_tfm(alg_name, 0);
+		struct crypto_comp *tfm = crypto_alloc_comp(alg_name, 0,
+							    CRYPTO_ALG_ASYNC);
 		if (!tfm)
 			goto error;
 		*per_cpu_ptr(tfms, cpu) = tfm;
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -363,8 +363,8 @@ struct xfrm_algo_desc *xfrm_calg_get_byi
 EXPORT_SYMBOL_GPL(xfrm_calg_get_byid);
 
 static struct xfrm_algo_desc *xfrm_get_byname(struct xfrm_algo_desc *list,
-					      int entries, char *name,
-					      int probe)
+					      int entries, u32 type, u32 mask,
+					      char *name, int probe)
 {
 	int i, status;
 
@@ -382,7 +382,7 @@ static struct xfrm_algo_desc *xfrm_get_b
 		if (!probe)
 			break;
 
-		status = crypto_alg_available(name, 0);
+		status = crypto_has_alg(name, type, mask | CRYPTO_ALG_ASYNC);
 		if (!status)
 			break;
 
@@ -394,19 +394,25 @@ static struct xfrm_algo_desc *xfrm_get_b
 
 struct xfrm_algo_desc *xfrm_aalg_get_byname(char *name, int probe)
 {
-	return xfrm_get_byname(aalg_list, aalg_entries(), name, probe);
+	return xfrm_get_byname(aalg_list, aalg_entries(),
+			       CRYPTO_ALG_TYPE_HASH, CRYPTO_ALG_TYPE_HASH_MASK,
+			       name, probe);
 }
 EXPORT_SYMBOL_GPL(xfrm_aalg_get_byname);
 
 struct xfrm_algo_desc *xfrm_ealg_get_byname(char *name, int probe)
 {
-	return xfrm_get_byname(ealg_list, ealg_entries(), name, probe);
+	return xfrm_get_byname(ealg_list, ealg_entries(),
+			       CRYPTO_ALG_TYPE_BLKCIPHER, CRYPTO_ALG_TYPE_MASK,
+			       name, probe);
 }
 EXPORT_SYMBOL_GPL(xfrm_ealg_get_byname);
 
 struct xfrm_algo_desc *xfrm_calg_get_byname(char *name, int probe)
 {
-	return xfrm_get_byname(calg_list, calg_entries(), name, probe);
+	return xfrm_get_byname(calg_list, calg_entries(),
+			       CRYPTO_ALG_TYPE_COMPRESS, CRYPTO_ALG_TYPE_MASK,
+			       name, probe);
 }
 EXPORT_SYMBOL_GPL(xfrm_calg_get_byname);
 
@@ -441,19 +447,22 @@ void xfrm_probe_algs(void)
 	BUG_ON(in_softirq());
 
 	for (i = 0; i < aalg_entries(); i++) {
-		status = crypto_alg_available(aalg_list[i].name, 0);
+		status = crypto_has_hash(aalg_list[i].name, 0,
+					 CRYPTO_ALG_ASYNC);
 		if (aalg_list[i].available != status)
 			aalg_list[i].available = status;
 	}
 	
 	for (i = 0; i < ealg_entries(); i++) {
-		status = crypto_alg_available(ealg_list[i].name, 0);
+		status = crypto_has_blkcipher(ealg_list[i].name, 0,
+					      CRYPTO_ALG_ASYNC);
 		if (ealg_list[i].available != status)
 			ealg_list[i].available = status;
 	}
 	
 	for (i = 0; i < calg_entries(); i++) {
-		status = crypto_alg_available(calg_list[i].name, 0);
+		status = crypto_has_comp(calg_list[i].name, 0,
+					 CRYPTO_ALG_ASYNC);
 		if (calg_list[i].available != status)
 			calg_list[i].available = status;
 	}

-- 
VGER BF report: H 0
