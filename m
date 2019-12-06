Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBECC43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 22:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E87872245C
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 22:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575672119;
	bh=dmfqjacyLdI7fngnVa1ldt3rOjL0hxxdvaCR0dVfI2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IRpdwMGozL6Kx1LgQQKGEia5ND1yAhbKe60Lq/Sk5yrA19UV5b6Pv/M8g2oNjy5dG
	 PZIdgRdmJStMaV9t278/zFNMlI78tNvaS15HdI6FRAOLOjlJykhWkpRPa+Jp/eV8P7
	 M2cWZc5tw5WxyEGuhIzYtz+S9HC5ciLIRgOkAdg8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLFWl6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 17:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFWl6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 17:41:58 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AFF21835;
        Fri,  6 Dec 2019 22:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575672117;
        bh=dmfqjacyLdI7fngnVa1ldt3rOjL0hxxdvaCR0dVfI2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xbepbxa9Wi8WtcBXFRgs9Q+X4pidbNsLYlT6gtH3UJkOh3K7mwRUNg/5ntmuJ/2wN
         TQs2CJOXM5mrk/NDh0+x9bA13QXAqWk8yuNoGA2TEZeyRH5AFR8cbsFVsBj/+uyoVI
         h19Wcn01GlX1NVO/n5saxOd4koujMa8/wwimEpy4=
Date:   Fri, 6 Dec 2019 14:41:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/4] crypto: aead - Retain alg refcount in
 crypto_grab_aead
Message-ID: <20191206224155.GE246840@gmail.com>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G9-00051G-5w@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1id7G9-00051G-5w@gondobar>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 02:38:37PM +0800, Herbert Xu wrote:
> This patch changes crypto_grab_aead to retain the reference count
> on the algorithm.  This is because the caller needs to access the
> algorithm parameters and without the reference count the algorithm
> can be freed at any time.
> 
> All callers have been modified to drop the reference count instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/aead.c                   |    7 +------
>  crypto/ccm.c                    |    3 +++
>  crypto/cryptd.c                 |    3 ++-
>  crypto/echainiv.c               |    1 +
>  crypto/essiv.c                  |   10 +++++++++-
>  crypto/gcm.c                    |    6 ++++++
>  crypto/geniv.c                  |    1 +
>  crypto/pcrypt.c                 |    3 +++
>  crypto/seqiv.c                  |    1 +
>  include/crypto/internal/aead.h  |    5 +++++
>  include/crypto/internal/geniv.h |    7 +++++++
>  11 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/aead.c b/crypto/aead.c
> index f548a5c3f74d..47f16d139e8e 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -210,13 +210,8 @@ static const struct crypto_type crypto_aead_type = {
>  int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
>  		     u32 type, u32 mask)
>  {
> -	int err;
> -
>  	spawn->base.frontend = &crypto_aead_type;
> -	err = crypto_grab_spawn(&spawn->base, name, type, mask);
> -	if (!err)
> -		crypto_mod_put(spawn->base.alg);
> -	return err;
> +	return crypto_grab_spawn(&spawn->base, name, type, mask);
>  }
>  EXPORT_SYMBOL_GPL(crypto_grab_aead);
>  
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 380eb619f657..6f555342a4a7 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -819,11 +819,14 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
>  	if (err)
>  		goto out_drop_alg;
>  
> +	aead_alg_put(alg);
> +
>  out:
>  	return err;
>  
>  out_drop_alg:
>  	crypto_drop_aead(spawn);
> +	aead_alg_put(alg);
>  out_free_inst:
>  	kfree(inst);
>  	goto out;

This approach seems too error-prone, since the prototype of crypto_grab_aead()
doesn't give any indication that it takes a reference to the algorithm which the
caller *must* drop.

How about returning the alg pointer in the last argument, similar to
skcipher_alloc_instance_simple()?  I know you sent a patch to remove that
argument, but I think it's better to have it...

That would actually simplify the code, since then the callers wouldn't need to
call crypto_spawn_aead_alg() to get the alg pointer.

Likewise for skcipher and akcipher.

> diff --git a/crypto/essiv.c b/crypto/essiv.c
> index 808f2b362106..08e0209d1b09 100644
> --- a/crypto/essiv.c
> +++ b/crypto/essiv.c
> @@ -622,6 +622,12 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
>  		goto out_free_hash;
>  
>  	crypto_mod_put(_hash_alg);
> +
> +	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
> +		;
> +	else
> +		aead_alg_put(aead_alg);

Or more conventionally:

	if (type != CRYPTO_ALG_TYPE_SKCIPHER)
		aead_alg_put(aead_alg);

> @@ -629,8 +635,10 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
>  out_drop_skcipher:
>  	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
>  		crypto_drop_skcipher(&ictx->u.skcipher_spawn);
> -	else
> +	else {
>  		crypto_drop_aead(&ictx->u.aead_spawn);
> +		aead_alg_put(aead_alg);
> +	}

Should have braces around the 'if' clause too.

- Eric
