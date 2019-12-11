Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CB2C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB1A2073B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576035380;
	bh=SkVfA6xgJAbS059jIkmd/O2ESqZPtM5+P7Tsfh7xNHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DBLJJYSfamA1rAxH8pX/YQuOzfYu5iSS7FKhAomzIDbLWPQzAGEVjn442g7M5XYiw
	 7NATi1kTO2rhGeWvvetl8xJ5+gSw7StupzxwJzJG3QDM0wMxZgqYGF4vrR8u+YP5Ju
	 /k/L2FuZPCOg5dA6tP//KeljMB73Oi30coT4z72c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLKDgU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 22:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfLKDgU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 22:36:20 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABDC720718;
        Wed, 11 Dec 2019 03:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576035379;
        bh=SkVfA6xgJAbS059jIkmd/O2ESqZPtM5+P7Tsfh7xNHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HXgH5NOpv7dtdabPUStdREksXfiM6EBnlOAFlTfX55k1+aQTa5qGni/Mu+vXGymtL
         TJqZUMsexRZmWBywPGL/+tNEvXVN+ZFmsovJGiA81602MEHyG+siTFiiFDaOuKNJq6
         hMqDxoGMJ54idwxLQRqbSGosB1vTAszc7hw2r+hw=
Date:   Tue, 10 Dec 2019 19:36:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: api - Check spawn->alg under lock in
 crypto_drop_spawn
Message-ID: <20191211033618.GG732@sol.localdomain>
References: <20191206055517.53o7xtpxdo2bx6qe@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206055517.53o7xtpxdo2bx6qe@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 01:55:17PM +0800, Herbert Xu wrote:
> We need to check whether spawn->alg is NULL under lock as otherwise
> the algorithm could be removed from under us after we have checked
> it and found it to be non-NULL.  This could cause us to remove the
> spawn from a non-existent list.
> 
> Fixes: 6bfd48096ff8 ("[CRYPTO] api: Added spawns")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 783006f4d339..6869feb31c99 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -668,11 +668,9 @@ EXPORT_SYMBOL_GPL(crypto_grab_spawn);
>  
>  void crypto_drop_spawn(struct crypto_spawn *spawn)
>  {
> -	if (!spawn->alg)
> -		return;
> -
>  	down_write(&crypto_alg_sem);
> -	list_del(&spawn->list);
> +	if (spawn->alg)
> +		list_del(&spawn->list);
>  	up_write(&crypto_alg_sem);
>  }
>  EXPORT_SYMBOL_GPL(crypto_drop_spawn);

Seems the Fixes tag is wrong.  It should be:

Fixes: 7ede5a5ba55a ("crypto: api - Fix crypto_drop_spawn crash on blank spawns")

- Eric
