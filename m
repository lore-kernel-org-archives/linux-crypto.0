From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] crypto: img-hash - Fix null pointer exception
Date: Tue, 12 Jul 2016 15:41:01 +0800
Message-ID: <20160712074101.GA29651@gondor.apana.org.au>
References: <1468229616-3888-2-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, will.thomas@imgtec.com
To: Will Thomas <will.thomas@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43061 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcGLHlI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 03:41:08 -0400
Content-Disposition: inline
In-Reply-To: <1468229616-3888-2-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Will Thomas <will.thomas@imgtec.com> wrote:
> Sporadic null pointer exceptions came from here. Fix them.
> 
> Signed-off-by: Will Thomas <will.thomas@imgtec.com>
> Reviewed-by: James Hartley <james.hartley@imgtec.com>
> ---
> drivers/crypto/img-hash.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
> index 68e8aa9..a5f270b 100644
> --- a/drivers/crypto/img-hash.c
> +++ b/drivers/crypto/img-hash.c
> @@ -361,7 +361,7 @@ static void img_hash_dma_task(unsigned long d)
>        size_t nbytes, bleft, wsend, len, tbc;
>        struct scatterlist tsg;
> 
> -       if (!ctx->sg)
> +       if (!ctx || !ctx->sg)
>                return;

This makes no sense.  ctx comes from ahash_request_ctx which can
never be NULL.  Perhaps you meant !hdev->req?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
