From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH] crypto: AF_ALG - fix race accessing cipher request
Date: Fri, 8 Dec 2017 11:39:06 +0000
Message-ID: <20171208113906.000050aa@huawei.com>
References: <001a1141f050d78763055f85c42e@google.com>
        <5543369.6UIL7PonCy@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: <herbert@gondor.apana.org.au>,
        syzbot
        <bot+3cbaad7926415bb8cfce88469e5f66a2bbd0d0cd@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:55267 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751641AbdLHLji (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Dec 2017 06:39:38 -0500
In-Reply-To: <5543369.6UIL7PonCy@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 8 Dec 2017 11:50:37 +0100
Stephan Müller <smueller@chronox.de> wrote:

> Hi Herbert,
> 
> This patch would go on top of 7d2c3f54e6f646887d019faa45f35d6fe9fe82ce
> "crypto: af_alg - remove locking in async callback" found in Linus' tree
> which is not yet in the cryptodev-2.6 tree.
> 
> In addition, this patch is already on top of the other patches discussed
> on this list fixing similar issues. I.e. depending in which order you apply
> the patches, there may be a hunk. In case you want me to rebase the patch,
> please let me know.
> 
> ---8<---
> When invoking an asynchronous cipher operation, the invocation of the
> callback may be performed before the subsequent operations in the
> initial code path are invoked. The callback deletes the cipher request
> data structure which implies that after the invocation of the
> asynchronous cipher operation, this data structure must not be accessed
> any more.
> 
> The setting of the return code size with the request data structure must
> therefore be moved before the invocation of the asynchronous cipher
> operation.
> 
> Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Have an identical patch in my queue having observed this happening on our
hardware - though only had the skcipher case.

As a heads up, the other nasties we've found so far are around hitting limits
on the various socket buffers.  When you run into those you can end up with
parts of the data to be encrypted going through without it being obvious.

Will update on that properly once I've chased down a local problem that
is limiting the length of my test runs to a few million messages.

Jonathan

> ---
>  crypto/algif_aead.c     | 10 +++++-----
>  crypto/algif_skcipher.c | 10 +++++-----
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 15e561dc47b5..d7ec2f4ebaf9 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -291,6 +291,10 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  		/* AIO operation */
>  		sock_hold(sk);
>  		areq->iocb = msg->msg_iocb;
> +
> +		/* Remember output size that will be generated. */
> +		areq->outlen = outlen;
> +
>  		aead_request_set_callback(&areq->cra_u.aead_req,
>  					  CRYPTO_TFM_REQ_MAY_BACKLOG,
>  					  af_alg_async_cb, areq);
> @@ -298,12 +302,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  				 crypto_aead_decrypt(&areq->cra_u.aead_req);
>  
>  		/* AIO operation in progress */
> -		if (err == -EINPROGRESS || err == -EBUSY) {
> -			/* Remember output size that will be generated. */
> -			areq->outlen = outlen;
> -
> +		if (err == -EINPROGRESS || err == -EBUSY)
>  			return -EIOCBQUEUED;
> -		}
>  
>  		sock_put(sk);
>  	} else {
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 6fb595cd63ac..baef9bfccdda 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -125,6 +125,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  		/* AIO operation */
>  		sock_hold(sk);
>  		areq->iocb = msg->msg_iocb;
> +
> +		/* Remember output size that will be generated. */
> +		areq->outlen = len;
> +
>  		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
>  					      CRYPTO_TFM_REQ_MAY_SLEEP,
>  					      af_alg_async_cb, areq);
> @@ -133,12 +137,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
>  
>  		/* AIO operation in progress */
> -		if (err == -EINPROGRESS || err == -EBUSY) {
> -			/* Remember output size that will be generated. */
> -			areq->outlen = len;
> -
> +		if (err == -EINPROGRESS || err == -EBUSY)
>  			return -EIOCBQUEUED;
> -		}
>  
>  		sock_put(sk);
>  	} else {
