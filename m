From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Fix race around ctx->rcvused by making it atomic_t
Date: Tue, 19 Dec 2017 12:11:19 +0100
Message-ID: <3581602.Ey9azVmcPc@tauon.chronox.de>
References: <20171218161045.0000161c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44412 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936039AbdLSLLW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 06:11:22 -0500
In-Reply-To: <20171218161045.0000161c@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 19. Dezember 2017, 11:31:22 CET schrieb Jonathan Cameron:

Hi Jonathan,

> This variable was increased and decreased without any protection.
> Result was an occasional misscount and negative wrap around resulting
> in false resource allocation failures.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> ---
> Resending due to incompetence on my part - sorry all!
> 
> The fixes tag is probably not ideal as I'm not 100% sure when this actually
> became a bug.  The code in question was introduced in
> 
> Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> and related.
> rcvused moved in
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> So I have gone with the latter option as that is where it will cleanly
> apply. However, it probably doesn't matter as both are present only in the
> 4.14 final kernel.
> 
>  crypto/af_alg.c         | 4 ++--
>  crypto/algif_aead.c     | 2 +-
>  crypto/algif_skcipher.c | 2 +-
>  include/crypto/if_alg.h | 5 +++--
>  4 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 8612aa36a3ef..759cfa678c04 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -664,7 +664,7 @@ void af_alg_free_areq_sgls(struct af_alg_async_req
> *areq) unsigned int i;
> 
>  	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
> -		ctx->rcvused -= rsgl->sg_num_bytes;
> +		atomic_sub(rsgl->sg_num_bytes, &ctx->rcvused);
>  		af_alg_free_sg(&rsgl->sgl);
>  		list_del(&rsgl->list);
>  		if (rsgl != &areq->first_rsgl)
> @@ -1173,7 +1173,7 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr
> *msg, int flags,
> 
>  		areq->last_rsgl = rsgl;
>  		len += err;
> -		ctx->rcvused += err;
> +		atomic_add(err, &ctx->rcvused);
>  		rsgl->sg_num_bytes = err;
>  		iov_iter_advance(&msg->msg_iter, err);
>  	}
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index db9378a45296..d3da3b0869f5 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -550,7 +550,7 @@ static int aead_accept_parent_nokey(void *private,
> struct sock *sk) INIT_LIST_HEAD(&ctx->tsgl_list);
>  	ctx->len = len;
>  	ctx->used = 0;
> -	ctx->rcvused = 0;
> +	atomic_set(&ctx->rcvused, 0);

I think ATOMIC_INIT(0) is more suitable here.

>  	ctx->more = 0;
>  	ctx->merge = 0;
>  	ctx->enc = 0;
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index c7c75ef41952..a5b4898f625a 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -388,7 +388,7 @@ static int skcipher_accept_parent_nokey(void *private,
> struct sock *sk) INIT_LIST_HEAD(&ctx->tsgl_list);
>  	ctx->len = len;
>  	ctx->used = 0;
> -	ctx->rcvused = 0;
> +	atomic_set(&ctx->rcvused, 0);

dto.

>  	ctx->more = 0;
>  	ctx->merge = 0;
>  	ctx->enc = 0;
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 38d9c5861ed8..f38227a78eae 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -18,6 +18,7 @@
>  #include <linux/if_alg.h>
>  #include <linux/scatterlist.h>
>  #include <linux/types.h>
> +#include <linux/atomic.h>
>  #include <net/sock.h>
> 
>  #include <crypto/aead.h>
> @@ -150,7 +151,7 @@ struct af_alg_ctx {
>  	struct crypto_wait wait;
> 
>  	size_t used;
> -	size_t rcvused;
> +	atomic_t rcvused;
> 
>  	bool more;
>  	bool merge;
> @@ -215,7 +216,7 @@ static inline int af_alg_rcvbuf(struct sock *sk)
>  	struct af_alg_ctx *ctx = ask->private;
> 
>  	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
> -			  ctx->rcvused, 0);
> +		     atomic_read(&ctx->rcvused), 0);
>  }
> 
>  /**

Other than the comments above:

Reviewed-by: Stephan Mueller <smueller@chronox.de>


Ciao
Stephan
