Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223E2C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 13:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E964F23711
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567518626;
	bh=jwDqtP9jUUTCcakKBXh0Rc1jrojcO4GPILrHYrKwzRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jgHj2+dHtAVOGzIz+LasbuH+YETj6oMId4K6GTDuo9Lz8BJbCylRR07BDDk9bj3fw
	 8KNRW3LUr+CvLf+uG2d6tiOJQiHMRv0qo/HsS5yf4IS9HpWjXO3JZRGPblKIPWJNEF
	 2aR8KffLCpY9BwjO5PwRmj/gXW4Qt0qd96WvN4iQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfICNuZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbfICNuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 09:50:24 -0400
Received: from zzz.localdomain (h184-61-154-48.mdsnwi.dsl.dynamic.tds.net [184.61.154.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F90623697;
        Tue,  3 Sep 2019 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567518624;
        bh=jwDqtP9jUUTCcakKBXh0Rc1jrojcO4GPILrHYrKwzRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lI2oxNnhqZsLhU190DLBO0I4xF6ILS70vckJC7FnoaoxHgk+tB5TaSNNoiHJb5Q/i
         aEiivu6F+qB/oQjPWCrLvuXN4KQHfyoT9UwzKn99gvU6DBsKJCT/CuZSgPi3oE7z+i
         hZQbr+PaWD6dQh2WW+0kCu4SV8lrLYy5xvCW9wZY=
Date:   Tue, 3 Sep 2019 08:50:20 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: crypto: skcipher - Unmap pages after an external error
Message-ID: <20190903135020.GB5144@zzz.localdomain>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org>
 <20190830080347.GA6677@gondor.apana.org.au>
 <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903065438.GA9372@gondor.apana.org.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 03, 2019 at 04:54:38PM +1000, Herbert Xu wrote:
>  int skcipher_walk_done(struct skcipher_walk *walk, int err)
>  {
> -	unsigned int n; /* bytes processed */
> -	bool more;
> -
> -	if (unlikely(err < 0))
> -		goto finish;
> +	unsigned int n = walk->nbytes - err;
> +	unsigned int nbytes;
>  
> -	n = walk->nbytes - err;
> -	walk->total -= n;
> -	more = (walk->total != 0);
> +	nbytes = walk->total - n;
>  
> -	if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
> -				    SKCIPHER_WALK_SLOW |
> -				    SKCIPHER_WALK_COPY |
> -				    SKCIPHER_WALK_DIFF)))) {
> +	if (unlikely(err < 0)) {
> +		nbytes = 0;
> +		n = 0;
> +	} else if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
> +					   SKCIPHER_WALK_SLOW |
> +					   SKCIPHER_WALK_COPY |
> +					   SKCIPHER_WALK_DIFF)))) {
>  unmap_src:
>  		skcipher_unmap_src(walk);
>  	} else if (walk->flags & SKCIPHER_WALK_DIFF) {
> @@ -134,25 +134,34 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
>  			 * the algorithm requires it.
>  			 */
>  			err = -EINVAL;
> -			goto finish;
> -		}
> -		skcipher_done_slow(walk, n);
> -		goto already_advanced;
> +			nbytes = 0;
> +		} else
> +			n = skcipher_done_slow(walk, n);
>  	}
>  
> +	if (err > 0)
> +		err = 0;
> +
> +	walk->total = nbytes;
> +	walk->nbytes = nbytes;
> +
>  	scatterwalk_advance(&walk->in, n);
>  	scatterwalk_advance(&walk->out, n);
> -already_advanced:
> -	scatterwalk_done(&walk->in, 0, more);
> -	scatterwalk_done(&walk->out, 1, more);
> +	scatterwalk_done(&walk->in, 0, nbytes);
> +	scatterwalk_done(&walk->out, 1, nbytes);
>  
> -	if (more) {
> +	if (nbytes) {
>  		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
>  			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
>  		return skcipher_walk_next(walk);
>  	}
> -	err = 0;
> -finish:
> +
> +	return skcipher_walk_unwind(walk, err);
> +}
> +EXPORT_SYMBOL_GPL(skcipher_walk_done);

Doesn't this re-introduce the same bug that my patch fixed -- that
scatterwalk_done() could be called after 0 bytes processed, causing a crash in
scatterwalk_pagedone()?

- Eric
