Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EAEC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 18:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3A22074B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591381360;
	bh=6M5f60iATNrWxKvYy3bdRq9cSDKBDDmQNzWAvM9LlPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Bb86shgdhIAvpSDk17dMX4I9P0D2eL6ogQctZx7C+tnofTsPt373ogPQGDX4maFTD
	 4wAn0oaBy0DO/q1ufIPhSceGwahezVx+0PVsnxryfC1N0t4CpFmbE+RfidqlVgoIls
	 Neb4nkYNXZfZ6C2YGC95Pw20ZxuQ6kAwSE5VLK7c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgFESWj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 14:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgFESWj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 14:22:39 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66DC0207F7;
        Fri,  5 Jun 2020 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591381358;
        bh=6M5f60iATNrWxKvYy3bdRq9cSDKBDDmQNzWAvM9LlPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hwIbC6w8P26W9Y92m1N8VVxPRy2d82v+VXfK2sJz6f1W6Aw6bYJ6HEHZV/uKhMA5y
         yoRVUxvMsT2+VueekR2gFvxRr/skCmkMK8Waq6KBCPOwi7mRGxvT6d6pyG/3Gv5/X4
         sL/4vjt1FQ42phqhsnWdd5FKg7Cq+Aeq+RPGv5sc=
Date:   Fri, 5 Jun 2020 11:22:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [v2 PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200605182237.GG1373@sol.localdomain>
References: <20200604063324.GA28813@gondor.apana.org.au>
 <20200605065918.GA813@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605065918.GA813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 04:59:18PM +1000, Herbert Xu wrote:
> The crypto notify call occurs with a read mutex held so you must
> not do any substantial work directly.  In particular, you cannot
> call crypto_alloc_* as they may trigger further notifications
> which may dead-lock in the presence of another writer.
> 
> This patch fixes this by postponing the work into a work queue and
> taking the same lock in the module init function.
> 
> While we're at it this patch also ensures that all RCU accesses are
> marked appropriately (tested with sparse).
> 
> Finally this also reveals a race condition in module param show
> function as it may be called prior to the module init function.
> It's fixed by testing whether crct10dif_tfm is NULL (this is true
> iff the init function has not completed assuming fallback is false).
> 
> Fixes: 11dcb1037f40 ("crc-t10dif: Allow current transform to be...")
> Fixes: b76377543b73 ("crc-t10dif: Pick better transform if one...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
> index 8cc01a603416..c9acf1c12cfc 100644
> --- a/lib/crc-t10dif.c
> +++ b/lib/crc-t10dif.c
> @@ -19,39 +19,46 @@
>  static struct crypto_shash __rcu *crct10dif_tfm;
>  static struct static_key crct10dif_fallback __read_mostly;
>  static DEFINE_MUTEX(crc_t10dif_mutex);
> +static struct work_struct crct10dif_rehash_work;
>  
> -static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
> +static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, void *data)
>  {
>  	struct crypto_alg *alg = data;
> -	struct crypto_shash *new, *old;
>  
>  	if (val != CRYPTO_MSG_ALG_LOADED ||
>  	    static_key_false(&crct10dif_fallback) ||
>  	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
>  		return 0;
>  
> +	schedule_work(&crct10dif_rehash_work);
> +	return 0;
> +}
> +
> +static void crc_t10dif_rehash(struct work_struct *work)
> +{
> +	struct crypto_shash *new, *old;
> +
>  	mutex_lock(&crc_t10dif_mutex);
>  	old = rcu_dereference_protected(crct10dif_tfm,
>  					lockdep_is_held(&crc_t10dif_mutex));
>  	if (!old) {
>  		mutex_unlock(&crc_t10dif_mutex);
> -		return 0;
> +		return;
>  	}
>  	new = crypto_alloc_shash("crct10dif", 0, 0);
>  	if (IS_ERR(new)) {
>  		mutex_unlock(&crc_t10dif_mutex);
> -		return 0;
> +		return;
>  	}
>  	rcu_assign_pointer(crct10dif_tfm, new);
>  	mutex_unlock(&crc_t10dif_mutex);
>  
>  	synchronize_rcu();
>  	crypto_free_shash(old);
> -	return 0;
>  }
>  
>  static struct notifier_block crc_t10dif_nb = {
> -	.notifier_call = crc_t10dif_rehash,
> +	.notifier_call = crc_t10dif_notify,
>  };
>  
>  __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
> @@ -86,19 +93,26 @@ EXPORT_SYMBOL(crc_t10dif);
>  
>  static int __init crc_t10dif_mod_init(void)
>  {
> +	struct crypto_shash *tfm;
> +
> +	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
>  	crypto_register_notifier(&crc_t10dif_nb);
> -	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
> -	if (IS_ERR(crct10dif_tfm)) {
> +	mutex_lock(&crc_t10dif_mutex);
> +	tfm = crypto_alloc_shash("crct10dif", 0, 0);
> +	if (IS_ERR(tfm)) {
>  		static_key_slow_inc(&crct10dif_fallback);
> -		crct10dif_tfm = NULL;
> +		tfm = NULL;
>  	}
> +	RCU_INIT_POINTER(crct10dif_tfm, tfm);
> +	mutex_unlock(&crc_t10dif_mutex);
>  	return 0;
>  }
>  
>  static void __exit crc_t10dif_mod_fini(void)
>  {
>  	crypto_unregister_notifier(&crc_t10dif_nb);
> -	crypto_free_shash(crct10dif_tfm);
> +	cancel_work_sync(&crct10dif_rehash_work);
> +	crypto_free_shash(rcu_dereference_protected(crct10dif_tfm, 1));
>  }
>  
>  module_init(crc_t10dif_mod_init);
> @@ -106,11 +120,27 @@ module_exit(crc_t10dif_mod_fini);
>  
>  static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
>  {
> +	struct crypto_shash *tfm;
> +	const char *name;
> +	int len;
> +
>  	if (static_key_false(&crct10dif_fallback))
>  		return sprintf(buffer, "fallback\n");
>  
> -	return sprintf(buffer, "%s\n",
> -		crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
> +	rcu_read_lock();
> +	tfm = rcu_dereference(crct10dif_tfm);
> +	if (!tfm) {
> +		len = sprintf(buffer, "init\n");
> +		goto unlock;
> +	}

Wouldn't it be better to have crct10dif_fallback enabled by default, and then
disable it once the tfm is allocated?

That would make the checks for a NULL tfm in crc_t10dif_transform_show() and
crc_t10dif_notify() unnecessary.  Also, it would make it so that
crc_t10dif_update() no longer crashes if called before module_init().

- Eric
