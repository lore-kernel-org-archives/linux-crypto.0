Return-Path: <SRS0=5TcX=2G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471B3C43603
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 04:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA0220725
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 04:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576471613;
	bh=yF0M0juvqij+/iiFoJA0QY9Nr4iU+JJD//ObHsCV33I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Pw5mttHB/gft3+MsjgxQH0Rqtw+TIDh/1zdc1kRgjlVjCQaQTFr71n2vJzFfbXXCm
	 c7EivJR+7p+3VS7qBA6zga6wuuFOCzEs+EzWfnAKQmmZ8MQnk/RuLpjW17pE8r8EhV
	 s931OjeUgUf3UVRw2OTUUpFHjpJPSwutQ3QOGEN0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLPEqw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 23:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfLPEqv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 23:46:51 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE18820674;
        Mon, 16 Dec 2019 04:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576471611;
        bh=yF0M0juvqij+/iiFoJA0QY9Nr4iU+JJD//ObHsCV33I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hCG8rArBQ6DLkkS3h1VJLj0Af6zbcWOkgM2F2K9dvzJn+9FVewKF+niRrX8Mvh/Ew
         Hu0Km42tQ3BnXKKCD9I46W5d6CGOgCycXDncHeZGOtcc8BZ0pj8AU7gIv7dok4H3Fn
         /ar3kwPGeOp4KcTWBsa2adsM9EryyxWIwTX5quz0=
Date:   Sun, 15 Dec 2019 20:46:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH] crypto: api - Retain alg refcount in crypto_grab_spawn
Message-ID: <20191216044649.GA908@sol.localdomain>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G9-00051G-5w@gondobar>
 <20191206224155.GE246840@gmail.com>
 <20191207033059.h6kgx7j7jtnqotuy@gondor.apana.org.au>
 <20191207045234.GA5948@sol.localdomain>
 <20191207145504.gcwc75enxhqfqhxe@gondor.apana.org.au>
 <20191214064404.qlxgabr3k47473uh@gondor.apana.org.au>
 <20191215041119.ndcodt4bw4rr52es@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215041119.ndcodt4bw4rr52es@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 15, 2019 at 12:11:19PM +0800, Herbert Xu wrote:
> On Sat, Dec 14, 2019 at 02:44:04PM +0800, Herbert Xu wrote:
> >
> >  			/*
> > -			 * We may encounter an unregistered instance here, since
> > -			 * an instance's spawns are set up prior to the instance
> > -			 * being registered.  An unregistered instance will have
> > -			 * NULL ->cra_users.next, since ->cra_users isn't
> > -			 * properly initialized until registration.  But an
> > -			 * unregistered instance cannot have any users, so treat
> > -			 * it the same as ->cra_users being empty.
> > +			 * We may encounter an unregistered instance
> > +			 * here, since an instance's spawns are set
> > +			 * up prior to the instance being registered.
> > +			 * An unregistered instance cannot have any
> > +			 * users, so treat it the same as ->cra_users
> > +			 * being empty.
> >  			 */
> > -			if (spawns->next == NULL)
> > +			if (!spawn->registered)
> >  				break;
> 
> This is not quite right.  spawn->registered only allows us to
> dereference spawn->inst, it doesn't actually mean that inst itself
> is on the cra_list.  Here is a better patch:
> 
> ---8<---
> This patch changes crypto_grab_spawn to retain the reference count
> on the algorithm.  This is because the caller needs to access the
> algorithm parameters and without the reference count the algorithm
> can be freed at any time.
> 
> The reference count will be subsequently dropped by the crypto API
> once the instance has been registered.  The helper crypto_drop_spawn
> will also conditionally drop the reference count depending on whether
> it has been registered.
> 
> Note that the code is actually added to crypto_init_spawn.  However,
> unless the caller activates this by setting spawn->dropref beforehand
> then nothing happens.  The only caller that sets dropref is currently
> crypto_grab_spawn.
> 
> Once all legacy users of crypto_init_spawn disappear, then we can
> kill the dropref flag.
> 
> Internally each instance will maintain a list of its spawns prior
> to registration.  This memory used by this list is shared with
> other fields that are only used after registration.  In order for
> this to work a new flag spawn->registered is added to indicate
> whether spawn->inst can be used.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index cd643e294664..a2a5372efe1d 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -124,8 +124,6 @@ static void crypto_remove_instance(struct crypto_instance *inst,
>  		return;
>  
>  	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
> -	if (hlist_unhashed(&inst->list))
> -		return;
>  
>  	if (!tmpl || !crypto_tmpl_get(tmpl))
>  		return;
> @@ -179,10 +177,14 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
>  
>  			list_move(&spawn->list, &stack);
>  
> -			if (&inst->alg == nalg)
> +			if (spawn->registered && &inst->alg == nalg)
>  				break;

There's still code above that uses spawn->inst without verifying that
spawn->registered is set.

		inst = spawn->inst;

		BUG_ON(&inst->alg == alg);

Also, the below code looks redundant now that it's only executed when
spawn->registered.  If it's still needed, maybe the comment needs to be updated?

	/*
	 * We may encounter an unregistered instance here, since
	 * an instance's spawns are set up prior to the instance
	 * being registered.  An unregistered instance will have
	 * NULL ->cra_users.next, since ->cra_users isn't
	 * properly initialized until registration.  But an
	 * unregistered instance cannot have any users, so treat
	 * it the same as ->cra_users being empty.
	 */
	if (spawns->next == NULL)
		break;

> @@ -700,6 +724,11 @@ void crypto_drop_spawn(struct crypto_spawn *spawn)
>  	if (!spawn->dead)
>  		list_del(&spawn->list);
>  	up_write(&crypto_alg_sem);
> +
> +	if (!spawn->dropref || spawn->registered)
> +		return;
> +
> +	crypto_mod_put(spawn->alg);
>  }
>  EXPORT_SYMBOL_GPL(crypto_drop_spawn);

How about:

	if (spawn->dropref && !spawn->registered)
		crypto_mod_put(spawn->alg);

> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 771a295ac755..29202b8f12fa 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -47,7 +47,13 @@ struct crypto_instance {
>  	struct crypto_alg alg;
>  
>  	struct crypto_template *tmpl;
> -	struct hlist_node list;
> +
> +	union {
> +		/* List of instances after registration. */
> +		struct hlist_node list;

This really should say "Node in list of instances after registration."
Otherwise it sounds like it's a list, not an element of a list.

> +		/* List of attached spawns before registration. */
> +		struct crypto_spawn *spawns;
> +	};
>  

- Eric
