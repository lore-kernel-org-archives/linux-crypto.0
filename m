Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B54C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E896B21726
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfH3IDy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:03:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59564 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfH3IDx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:03:53 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i3bsr-0003vO-4o; Fri, 30 Aug 2019 18:03:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2019 18:03:48 +1000
Date:   Fri, 30 Aug 2019 18:03:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH 08/17] crypto: skcipher - add the ability to abort a
 skcipher walk
Message-ID: <20190830080347.GA6677@gondor.apana.org.au>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821143253.30209-9-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 21, 2019 at 05:32:44PM +0300, Ard Biesheuvel wrote:
> After starting a skcipher walk, the only way to ensure that all
> resources it has tied up are released is to complete it. In some
> cases, it will be useful to be able to abort a walk cleanly after
> it has started, so add this ability to the skcipher walk API.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/skcipher.c                  | 3 +++
>  include/crypto/internal/skcipher.h | 5 +++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 5d836fc3df3e..973ab1c7dcca 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -140,6 +140,9 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
>  		goto already_advanced;
>  	}
>  
> +	if (unlikely(!n))
> +		goto finish;
> +
>  	scatterwalk_advance(&walk->in, n);
>  	scatterwalk_advance(&walk->out, n);
>  already_advanced:
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index d68faa5759ad..bc488173531f 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -148,6 +148,11 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
>  			       struct aead_request *req, bool atomic);
>  void skcipher_walk_complete(struct skcipher_walk *walk, int err);
>  
> +static inline void skcipher_walk_abort(struct skcipher_walk *walk)
> +{
> +	skcipher_walk_done(walk, walk->nbytes);
> +}

Couldn't you just abort it by supplying an error in place of
walk->bytes? IOW I'm fine with this helper but you don't need
to touch skcipher_walk_done as just giving it an negative err
value should do the trick.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
