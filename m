From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/1] crypto: engine: permit to enqueue ashash_request
Date: Sun, 12 Jun 2016 19:01:01 +0800
Message-ID: <20160612110101.GA883@gondor.apana.org.au>
References: <1464873212-15426-1-git-send-email-clabbe.montjoie@gmail.com>
 <1464873212-15426-2-git-send-email-clabbe.montjoie@gmail.com>
 <20160607103139.GA325@gondor.apana.org.au>
 <20160610144309.GA25816@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, baolin.wang@linaro.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40590 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbcFLLBN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Jun 2016 07:01:13 -0400
Content-Disposition: inline
In-Reply-To: <20160610144309.GA25816@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 10, 2016 at 04:43:09PM +0200, LABBE Corentin wrote:
>
> So I need to split do_one_request to cipher_one_request/hash_one_request.
> Same with prepare_request to prepare_hash_request/prepare_cipher_request.
> With the choice of each function done in crypto_engine.c.

Yes.  As a general rule we should make sure that the API exposed
to driver authors is strongly typed so that they don't have to do
casts at all.

> Since this modification need to add <crypto/hash.h> to algapi.h, I think it is necessary to move all crypto engine stuff to crypto/engine.h
> Do you agree ?

That sounds like a good idea.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
