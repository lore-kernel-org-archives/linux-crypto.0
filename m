From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data.
Date: Tue, 25 Nov 2014 22:42:45 +0800
Message-ID: <20141125144245.GA8278@gondor.apana.org.au>
References: <20141121171406.1147.31491.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59683 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKYOmw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2014 09:42:52 -0500
Content-Disposition: inline
In-Reply-To: <20141121171406.1147.31491.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 21, 2014 at 09:14:06AM -0800, Tadeusz Struk wrote:
>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 85e3bdb..e393c71 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -359,8 +359,6 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
>  	err = 0;
>  
>  	ctx->more = msg->msg_flags & MSG_MORE;
> -	if (!ctx->more && !list_empty(&ctx->tsgl))
> -		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
>  
>  unlock:
>  	skcipher_data_wakeup(sk);
> @@ -408,9 +406,6 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
>  
>  done:
>  	ctx->more = flags & MSG_MORE;
> -	if (!ctx->more && !list_empty(&ctx->tsgl))
> -		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
> -
>  unlock:
>  	skcipher_data_wakeup(sk);
>  	release_sock(sk);

Please put these clean-ups in a separate patch.

> @@ -469,6 +464,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
>  			if (!used)
>  				goto free;
>  
> +			sg_mark_end(&sg[sgl->cur - 1]);

I don't think this will work as if we only partially use up the
SGs and MSG_MORE is set then bad things will happen to the next
send call on the socket.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
