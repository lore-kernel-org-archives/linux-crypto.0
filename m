From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC] Generic crypto counters
Date: Fri, 15 Jun 2012 09:14:33 +0200
Message-ID: <1339744473.8069.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:44820 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2FOHRV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2012 03:17:21 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <jang@linux.vnet.ibm.com>;
	Fri, 15 Jun 2012 08:17:19 +0100
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q5F7HFxE2777324
	for <linux-crypto@vger.kernel.org>; Fri, 15 Jun 2012 08:17:16 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q5F7HFeH026010
	for <linux-crypto@vger.kernel.org>; Fri, 15 Jun 2012 01:17:15 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I've noticed that the powerpc folks were able to sneak counters for
their hardware crypto implementation into upstream [1].

Simple counters for the number of processed bytes per algorithm is
something which I wanted to have for some time now. The reason is that
its not obvious to tell if the hardware or software implementation
was used. The only way to determine this currently is to look at the
speed of the operation or add debug output, both methods kind of suck.

So I could also brew up some debugfs files for s390 CPACF but I
wonder if we shouldn't come up with a generic counter implementation
for all crypto algorithms. The output could be added to the
existing per algorithm values under /proc/crypto.

Below is a quick hack to implement these counters for the shash
algorithms, just to show what I'm thinking about...

Is this approach feasible? Can we have something generic? Or should I also go
the debugfs way?

thanks,
Jan

[1] drivers/crypto/nx/nx_debugfs.c

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 056571b..001842b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -190,6 +190,10 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	/* No cheating! */
 	alg->cra_flags &= ~CRYPTO_ALG_TESTED;
 
+	/* Init statistics */
+	atomic_set(&alg->cra_stats.ops, 0);
+	atomic_set(&alg->cra_stats.bytes, 0);
+
 	ret = -EEXIST;
 
 	atomic_set(&alg->cra_refcnt, 1);
diff --git a/crypto/proc.c b/crypto/proc.c
index 4a0a7aa..c167e79 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -96,6 +96,14 @@ static int c_show(struct seq_file *m, void *p)
 		goto out;
 	}
 
+	/* only show for supported types */
+	if (alg->cra_flags & CRYPTO_ALG_TYPE_SHASH) {
+		seq_printf(m, "operations   : %u\n",
+			   atomic_read(&alg->cra_stats.ops));
+		seq_printf(m, "bytes        : %Lu\n",
+			   atomic_read(&alg->cra_stats.bytes));
+	}
+
 	if (alg->cra_type && alg->cra_type->show) {
 		alg->cra_type->show(m, alg);
 		goto out;
diff --git a/crypto/shash.c b/crypto/shash.c
index 21fc12e..e842899 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -100,11 +100,15 @@ int crypto_shash_update(struct shash_desc *desc, const u8 *data,
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
 
 	if ((unsigned long)data & alignmask)
-		return shash_update_unaligned(desc, data, len);
-
-	return shash->update(desc, data, len);
+		err = shash_update_unaligned(desc, data, len);
+	else
+		err = shash->update(desc, data, len);
+	if (!err)
+		crypto_stat_inc(&desc->tfm->base, len);
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_update);
 
@@ -135,11 +139,15 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out)
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
 
 	if ((unsigned long)out & alignmask)
-		return shash_final_unaligned(desc, out);
-
-	return shash->final(desc, out);
+		err = shash_final_unaligned(desc, out);
+	else
+		err = shash->final(desc, out);
+	if (!err)
+		crypto_stat_inc(&desc->tfm->base, crypto_shash_digestsize(desc->tfm));
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_final);
 
@@ -156,11 +164,15 @@ int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
 
 	if (((unsigned long)data | (unsigned long)out) & alignmask)
-		return shash_finup_unaligned(desc, data, len, out);
-
-	return shash->finup(desc, data, len, out);
+		err = shash_finup_unaligned(desc, data, len, out);
+	else
+		err = shash->finup(desc, data, len, out);
+	if (!err)
+		crypto_stat_inc(&desc->tfm->base, len);
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_finup);
 
@@ -177,11 +189,15 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	int err;
 
 	if (((unsigned long)data | (unsigned long)out) & alignmask)
-		return shash_digest_unaligned(desc, data, len, out);
-
-	return shash->digest(desc, data, len, out);
+		err = shash_digest_unaligned(desc, data, len, out);
+	else
+		err = shash->digest(desc, data, len, out);
+	if (!err)
+		crypto_stat_inc(&desc->tfm->base, len);
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b92eadf..4f9a970 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -277,6 +277,11 @@ struct rng_alg {
 #define cra_compress	cra_u.compress
 #define cra_rng		cra_u.rng
 
+struct crypto_alg_stats {
+	atomic_t	ops;
+	atomic_t	bytes;
+};
+
 struct crypto_alg {
 	struct list_head cra_list;
 	struct list_head cra_users;
@@ -306,7 +311,9 @@ struct crypto_alg {
 	int (*cra_init)(struct crypto_tfm *tfm);
 	void (*cra_exit)(struct crypto_tfm *tfm);
 	void (*cra_destroy)(struct crypto_alg *alg);
-	
+
+	struct crypto_alg_stats cra_stats;
+
 	struct module *cra_module;
 };
 
@@ -558,6 +565,12 @@ static inline unsigned int crypto_tfm_ctx_alignment(void)
 	return __alignof__(tfm->__crt_ctx);
 }
 
+static inline void crypto_stat_inc(struct crypto_tfm *tfm, unsigned long bytes)
+{
+	atomic_inc(&tfm->__crt_alg->cra_stats.ops);
+	atomic_add(bytes, &tfm->__crt_alg->cra_stats.bytes);
+}
+
 /*
  * API wrappers.
  */
