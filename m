From: Stephan Mueller <smueller@chronox.de>
Subject: Re: general protection fault in af_alg_free_areq_sgls
Date: Tue, 28 Nov 2017 10:10:55 +0100
Message-ID: <2008707.GtIZiUutxC@tauon.chronox.de>
References: <001a1140f578d9710d055efb76a9@google.com> <20171128090252.GB23413@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+ff72ab869817b6ea60bc570f638ee030f4fc73e5@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42558 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751368AbdK1JK6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 04:10:58 -0500
In-Reply-To: <20171128090252.GB23413@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. November 2017, 10:02:52 CET schrieb Eric Biggers:

Hi Eric,

> ---
>  crypto/af_alg.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 358749c38894..415a54ced4d6 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -672,14 +672,15 @@ void af_alg_free_areq_sgls(struct af_alg_async_req
> *areq) }
> 
>  	tsgl = areq->tsgl;
> -	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
> -		if (!sg_page(sg))
> -			continue;
> -		put_page(sg_page(sg));
> -	}
> +	if (tsgl) {
> +		for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
> +			if (!sg_page(sg))
> +				continue;
> +			put_page(sg_page(sg));
> +		}
> 
> -	if (areq->tsgl && areq->tsgl_entries)

Why do you want to remove the check for areq->tsgl_entries? I know in the 
current code that cannot happen. But it should be caught in case of a 
programming error.

Thus, should we add a BUG_ON(!areq->tsgl_entries)?

Otherwise:

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
