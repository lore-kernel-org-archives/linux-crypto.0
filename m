From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] crypto: img-hash - Add support for export and import
Date: Tue, 12 Jul 2016 15:49:29 +0800
Message-ID: <20160712074929.GA29737@gondor.apana.org.au>
References: <1468229616-3888-6-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, james.hartley@imgtec.com
To: Will Thomas <will.thomas@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54869 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcGLHtc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 03:49:32 -0400
Content-Disposition: inline
In-Reply-To: <1468229616-3888-6-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Will Thomas <will.thomas@imgtec.com> wrote:
>
> @@ -714,9 +740,12 @@ static struct ahash_alg img_algs[] = {
>                .update = img_hash_update,
>                .final = img_hash_final,
>                .finup = img_hash_finup,
> +               .export = img_hash_export,
> +               .import = img_hash_import,
>                .digest = img_hash_digest,
>                .halg = {
>                        .digestsize = MD5_DIGEST_SIZE,
> +                       .statesize = sizeof(struct md5_state),

This is wrong.  The fallback state size is not guaranteed to be
the same as the generic MD5.  I suppose the easiest fix is to
explicitly request for md5-generic/sha1-generic/etc. when you
allocate the fallback.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
