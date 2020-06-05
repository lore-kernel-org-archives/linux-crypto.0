Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEF0C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 18:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841C12074B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 18:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591382730;
	bh=nCZZpXwxIKJQ3WGagmVFnfGYcRDcEiWAbFpFyY0glLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GO5ASAjorSitG1P3cJNaC7HaMU6gwUNSZs3EILmdhdQWNq/LGj/GUz5ncgJueYBKJ
	 FJ8pfK5UBPJOLNZ0MLGWq01zVnWiqMg3tWCufcRPItXIzKu0W3PSUPEEpoyZ3z6NJy
	 ZezOPzF8sO/iSYqGi7WuwyniMVLSBsbhokzrrCYg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgFESpa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 14:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgFESp3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 14:45:29 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61DB206FA;
        Fri,  5 Jun 2020 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591382729;
        bh=nCZZpXwxIKJQ3WGagmVFnfGYcRDcEiWAbFpFyY0glLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0a5qAh964zho1Lw9roRzTHl+dU9PMVcMfSyzUkgO22mAtIeBbOmOkdLuRWOyPBnD5
         wtPQAEVPE1DblQE+om1wxu+TJEY9u61JuHGcFC0pG/+VkZDT8GxwqZiYEs09RQKdxr
         MrTH2M5ut68iopMz1bmxmdcCGh99ISWcIOr5Y28g=
Date:   Fri, 5 Jun 2020 11:45:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [v2 PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200605184527.GH1373@sol.localdomain>
References: <20200604063324.GA28813@gondor.apana.org.au>
 <20200605065918.GA813@gondor.apana.org.au>
 <20200605182237.GG1373@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605182237.GG1373@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 11:22:37AM -0700, Eric Biggers wrote:
> 
> Wouldn't it be better to have crct10dif_fallback enabled by default, and then
> disable it once the tfm is allocated?
> 
> That would make the checks for a NULL tfm in crc_t10dif_transform_show() and
> crc_t10dif_notify() unnecessary.  Also, it would make it so that
> crc_t10dif_update() no longer crashes if called before module_init().
> 
> - Eric

How about the following:

(It includes some other cleanups too, like switching to the static_branch API,
 since the static_key one is deprecated and confusing.  I can split it into
 separate patches...)

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 8cc01a60341656..c45698f559cfb9 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -17,64 +17,70 @@
 #include <linux/notifier.h>
 
 static struct crypto_shash __rcu *crct10dif_tfm;
-static struct static_key crct10dif_fallback __read_mostly;
+static DEFINE_STATIC_KEY_TRUE(crct10dif_fallback);
 static DEFINE_MUTEX(crc_t10dif_mutex);
+static struct work_struct crct10dif_rehash_work;
 
-static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
+static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct crypto_alg *alg = data;
-	struct crypto_shash *new, *old;
 
 	if (val != CRYPTO_MSG_ALG_LOADED ||
-	    static_key_false(&crct10dif_fallback) ||
-	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
-		return 0;
+	    strcmp(alg->cra_name, CRC_T10DIF_STRING))
+		return NOTIFY_DONE;
+
+	schedule_work(&crct10dif_rehash_work);
+	return NOTIFY_OK;
+}
+
+static void crc_t10dif_rehash(struct work_struct *work)
+{
+	struct crypto_shash *new, *old;
 
 	mutex_lock(&crc_t10dif_mutex);
 	old = rcu_dereference_protected(crct10dif_tfm,
 					lockdep_is_held(&crc_t10dif_mutex));
-	if (!old) {
-		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
-	}
-	new = crypto_alloc_shash("crct10dif", 0, 0);
+	new = crypto_alloc_shash(CRC_T10DIF_STRING, 0, 0);
 	if (IS_ERR(new)) {
 		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
+		return;
 	}
 	rcu_assign_pointer(crct10dif_tfm, new);
 	mutex_unlock(&crc_t10dif_mutex);
 
-	synchronize_rcu();
-	crypto_free_shash(old);
-	return 0;
+	if (old) {
+		synchronize_rcu();
+		crypto_free_shash(old);
+	} else {
+		static_branch_disable(&crct10dif_fallback);
+	}
 }
 
 static struct notifier_block crc_t10dif_nb = {
-	.notifier_call = crc_t10dif_rehash,
+	.notifier_call = crc_t10dif_notify,
 };
 
 __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[2];
+		__u16 crc;
 	} desc;
 	int err;
 
-	if (static_key_false(&crct10dif_fallback))
+	if (static_branch_unlikely(&crct10dif_fallback))
 		return crc_t10dif_generic(crc, buffer, len);
 
 	rcu_read_lock();
 	desc.shash.tfm = rcu_dereference(crct10dif_tfm);
-	*(__u16 *)desc.ctx = crc;
+	desc.crc = crc;
 
 	err = crypto_shash_update(&desc.shash, buffer, len);
 	rcu_read_unlock();
 
 	BUG_ON(err);
 
-	return *(__u16 *)desc.ctx;
+	return desc.crc;
 }
 EXPORT_SYMBOL(crc_t10dif_update);
 
@@ -86,19 +92,18 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
+	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
 	crypto_register_notifier(&crc_t10dif_nb);
-	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
-	if (IS_ERR(crct10dif_tfm)) {
-		static_key_slow_inc(&crct10dif_fallback);
-		crct10dif_tfm = NULL;
-	}
+
+	crc_t10dif_rehash(&crct10dif_rehash_work);
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
@@ -106,14 +111,21 @@ module_exit(crc_t10dif_mod_fini);
 
 static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
 {
-	if (static_key_false(&crct10dif_fallback))
+	struct crypto_shash *tfm;
+	int len;
+
+	if (static_branch_unlikely(&crct10dif_fallback))
 		return sprintf(buffer, "fallback\n");
 
-	return sprintf(buffer, "%s\n",
-		crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
+	rcu_read_lock();
+	tfm = rcu_dereference(crct10dif_tfm);
+	len = sprintf(buffer, "%s\n", crypto_shash_driver_name(tfm));
+	rcu_read_unlock();
+
+	return len;
 }
 
-module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0644);
+module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0444);
 
 MODULE_DESCRIPTION("T10 DIF CRC calculation");
 MODULE_LICENSE("GPL");
