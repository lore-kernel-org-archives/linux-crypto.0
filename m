Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD1FC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 05:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4978207F7
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 05:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591335652;
	bh=v4PD1W9NMI56rAQRAMgOhrw4zlSHOIVPnkc7AQXWU+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iD1BRqvVsVWW8sx312Uoc7q60anKMWRkwXVoyYlW4n17EN1pJa+QAdcjabiEMLzX6
	 T35Y6A7xI0jg2xKZ0694oda8jUX5RcQdyXEawyIz0mad38oRlUnPngOtmJ471AVaJi
	 /hhE2ZTOnU8AWXgkJrXFuA6hptwPnEDguutXZBMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgFEFkw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 01:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgFEFkv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 01:40:51 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDA8207D3;
        Fri,  5 Jun 2020 05:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591335651;
        bh=v4PD1W9NMI56rAQRAMgOhrw4zlSHOIVPnkc7AQXWU+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gxef/59XYxgTRCA5uhs+iDMQnjI0jUdgl0g63ZxKp7Nn0FupxLo6QEzj0ur6GTXu1
         na6zu8KhBtt3kra3AiNoPUq5MZykqVUVt8T7iynNhpGHEE+goVMzGIZVQog/sixHMT
         fyRV7rt+UjmjjieABSwPdl/mNGgTkI1BRouQHLf0=
Date:   Thu, 4 Jun 2020 22:40:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200605054049.GT2667@sol.localdomain>
References: <20200604063324.GA28813@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604063324.GA28813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 04, 2020 at 04:33:24PM +1000, Herbert Xu wrote:
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
> +	return;
>  }

The last return statement is unnecessary.

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

Wouldn't it make more sense to initialize crct10dif_tfm before registering the
notifier?  Then the mutex wouldn't be needed.

- Eric
