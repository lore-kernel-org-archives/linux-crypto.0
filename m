Return-Path: <SRS0=Odag=Z5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1691C43603
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 04:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73CDC2245C
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 04:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575694358;
	bh=wSXMdmp7zUXkCtikv/+x5h1l9+XKEi3MCwDQWbgvyNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=J9O5J+5fzvqpa+F1x3yGxHdkawZILRpIG9RdvJCRuoSsZTmR+2qOiyGq5+GcftHOu
	 BKfWBuiitIyY/8y77+Wxr0wIu7VQ+ukjscMzPpxW5vbJnJHEnghZDCSKSpBhmKB7+o
	 5Org8TuUnPSjRB1KV5MhntgTFkWoK7CPdsOwGcb0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLGEwi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 23:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfLGEwh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 23:52:37 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51FBC21835;
        Sat,  7 Dec 2019 04:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575694356;
        bh=wSXMdmp7zUXkCtikv/+x5h1l9+XKEi3MCwDQWbgvyNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kmuzyNS9JKRQngis8IElcBXw5fNTURkn6cSI6F+kqj8+vGYGXyv7JPk9H5xEQ4G/J
         iWRN8yz0ISXU8HmWNDm6Ww1uigisbXMCjlGj6Pwk3CHt2saUbm5ABrczgZjr3cko9z
         3syQ6YWvkhihysUqH8zDeWTOnhoI/GdnlP7ZH8dQ=
Date:   Fri, 6 Dec 2019 20:52:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/4] crypto: aead - Retain alg refcount in
 crypto_grab_aead
Message-ID: <20191207045234.GA5948@sol.localdomain>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G9-00051G-5w@gondobar>
 <20191206224155.GE246840@gmail.com>
 <20191207033059.h6kgx7j7jtnqotuy@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207033059.h6kgx7j7jtnqotuy@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 07, 2019 at 11:30:59AM +0800, Herbert Xu wrote:
> On Fri, Dec 06, 2019 at 02:41:55PM -0800, Eric Biggers wrote:
> >
> > This approach seems too error-prone, since the prototype of crypto_grab_aead()
> > doesn't give any indication that it takes a reference to the algorithm which the
> > caller *must* drop.
> 
> Fair point.
> 
> > How about returning the alg pointer in the last argument, similar to
> > skcipher_alloc_instance_simple()?  I know you sent a patch to remove that
> > argument, but I think it's better to have it...
> 
> You probably guessed that I don't really like returning two objects
> from the same function :)
> 
> So how about this: we let the Crypto API manage the refcount and
> hide it from all the users.  Something like this patch:
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index adb516380be9..34473ab992f2 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -563,6 +563,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
>  			     struct crypto_instance *inst)
>  {
>  	struct crypto_larval *larval;
> +	struct crypto_spawn *spawn;
>  	int err;
>  
>  	err = crypto_check_alg(&inst->alg);
> @@ -588,6 +589,9 @@ int crypto_register_instance(struct crypto_template *tmpl,
>  	if (IS_ERR(larval))
>  		goto err;
>  
> +	hlist_for_each_entry(spawn, &inst->spawn_list, spawn_list)
> +		crypto_mod_put(spawn->alg);
> +
>  	crypto_wait_for_test(larval);
>  	err = 0;
>  
> @@ -623,6 +627,7 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
>  
>  	spawn->inst = inst;
>  	spawn->mask = mask;
> +	hlist_add_head(&spawn->spawn_list, &inst->spawn_list);
>  
>  	down_write(&crypto_alg_sem);
>  	if (!crypto_is_moribund(alg)) {
> @@ -674,6 +679,9 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
>  	if (!spawn->dead)
>  		list_del(&spawn->list);
>  	up_write(&crypto_alg_sem);
> +
> +	if (hlist_unhashed(&spawn->inst->list))
> +		crypto_mod_put(spawn->alg);
>  }
>  EXPORT_SYMBOL_GPL(crypto_drop_spawn);
>  
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 771a295ac755..284e96f2eda2 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -48,6 +48,7 @@ struct crypto_instance {
>  
>  	struct crypto_template *tmpl;
>  	struct hlist_node list;
> +	struct hlist_head spawn_list;
>  
>  	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
> @@ -66,6 +67,7 @@ struct crypto_template {
>  
>  struct crypto_spawn {
>  	struct list_head list;
> +	struct hlist_node spawn_list;
>  	struct crypto_alg *alg;
>  	struct crypto_instance *inst;
>  	const struct crypto_type *frontend;
> 

I think the general idea is much better.  But it's not going to work as-is due
to all the templates that directly use crypto_init_spawn(),
crypto_init_shash_spawn(), and crypto_init_ahash_spawn().  I think they should
be converted to use new functions crypto_grab_cipher(), crypto_grab_shash(), and
crypto_grab_cipher(), so that everyone is consistently using crypto_grab_*().

- Eric
