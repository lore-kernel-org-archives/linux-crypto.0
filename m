Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47331C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 06:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D62206DC
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 06:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgFDGd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 02:33:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36268 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDGd3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 02:33:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jgjRM-0002OM-5z; Thu, 04 Jun 2020 16:33:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Jun 2020 16:33:24 +1000
Date:   Thu, 4 Jun 2020 16:33:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200604063324.GA28813@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto notify call occurs with a read mutex held so you must
not do any substantial work directly.  In particular, you cannot
call crypto_alloc_* as they may trigger further notifications
which may dead-lock in the presence of another writer.

This patch fixes this by postponing the work into a work queue and
taking the same lock in the module init function.

While we're at it this patch also ensures that all RCU accesses are
marked appropriately (tested with sparse).

Finally this also reveals a race condition in module param show
function as it may be called prior to the module init function.
It's fixed by testing whether crct10dif_tfm is NULL (this is true
iff the init function has not completed assuming fallback is false).

Fixes: 11dcb1037f40 ("crc-t10dif: Allow current transform to be...")
Fixes: b76377543b73 ("crc-t10dif: Pick better transform if one...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 8cc01a603416..7063442377b1 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -19,39 +19,47 @@
 static struct crypto_shash __rcu *crct10dif_tfm;
 static struct static_key crct10dif_fallback __read_mostly;
 static DEFINE_MUTEX(crc_t10dif_mutex);
+static struct work_struct crct10dif_rehash_work;
 
-static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
+static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct crypto_alg *alg = data;
-	struct crypto_shash *new, *old;
 
 	if (val != CRYPTO_MSG_ALG_LOADED ||
 	    static_key_false(&crct10dif_fallback) ||
 	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
 		return 0;
 
+	schedule_work(&crct10dif_rehash_work);
+	return 0;
+}
+
+static void crc_t10dif_rehash(struct work_struct *work)
+{
+	struct crypto_shash *new, *old;
+
 	mutex_lock(&crc_t10dif_mutex);
 	old = rcu_dereference_protected(crct10dif_tfm,
 					lockdep_is_held(&crc_t10dif_mutex));
 	if (!old) {
 		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
+		return;
 	}
 	new = crypto_alloc_shash("crct10dif", 0, 0);
 	if (IS_ERR(new)) {
 		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
+		return;
 	}
 	rcu_assign_pointer(crct10dif_tfm, new);
 	mutex_unlock(&crc_t10dif_mutex);
 
 	synchronize_rcu();
 	crypto_free_shash(old);
-	return 0;
+	return;
 }
 
 static struct notifier_block crc_t10dif_nb = {
-	.notifier_call = crc_t10dif_rehash,
+	.notifier_call = crc_t10dif_notify,
 };
 
 __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
@@ -86,19 +94,26 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
+	struct crypto_shash *tfm;
+
+	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
 	crypto_register_notifier(&crc_t10dif_nb);
-	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
-	if (IS_ERR(crct10dif_tfm)) {
+	mutex_lock(&crc_t10dif_mutex);
+	tfm = crypto_alloc_shash("crct10dif", 0, 0);
+	if (IS_ERR(tfm)) {
 		static_key_slow_inc(&crct10dif_fallback);
-		crct10dif_tfm = NULL;
+		tfm = NULL;
 	}
+	RCU_INIT_POINTER(crct10dif_tfm, tfm);
+	mutex_unlock(&crc_t10dif_mutex);
 	return 0;
 }
 
 static void __exit crc_t10dif_mod_fini(void)
 {
 	crypto_unregister_notifier(&crc_t10dif_nb);
-	crypto_free_shash(crct10dif_tfm);
+	cancel_work_sync(&crct10dif_rehash_work);
+	crypto_free_shash(rcu_dereference_protected(crct10dif_tfm, 1));
 }
 
 module_init(crc_t10dif_mod_init);
@@ -106,11 +121,27 @@ module_exit(crc_t10dif_mod_fini);
 
 static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
 {
+	struct crypto_shash *tfm;
+	const char *name;
+	int len;
+
 	if (static_key_false(&crct10dif_fallback))
 		return sprintf(buffer, "fallback\n");
 
-	return sprintf(buffer, "%s\n",
-		crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
+	rcu_read_lock();
+	tfm = rcu_dereference(crct10dif_tfm);
+	if (!tfm) {
+		len = sprintf(buffer, "init\n");
+		goto unlock;
+	}
+
+	name = crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
+	len = sprintf(buffer, "%s\n", name);
+
+unlock:
+	rcu_read_unlock();
+
+	return len;
 }
 
 module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0644);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
