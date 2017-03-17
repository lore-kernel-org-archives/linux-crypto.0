From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 4/4] crypto: s5p-sss - Use mutex instead of spinlock
Date: Fri, 17 Mar 2017 18:28:29 +0100
Message-ID: <4289522.7Nbtc4pSSm@amdc3058>
References: <20170317144922.27379-1-krzk@kernel.org>
 <20170317144922.27379-5-krzk@kernel.org>
 <CGME20170317172831epcas1p12280386c43fd0b819bb87cf4ba78eab3@epcas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Nathan Royce <nroycea+kernel@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52133 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdCQRai (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 13:30:38 -0400
In-reply-to: <20170317144922.27379-5-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi,

On Friday, March 17, 2017 04:49:22 PM Krzysztof Kozlowski wrote:
> Driver uses threaded interrupt handler so there is no real need for
> using spinlocks for synchronization.  Mutexes would do fine and are
> friendlier for overall system preemptivness and real-time behavior.

Are you sure that this conversion is safe?  This driver also uses
a tasklet and tasklets run in the interrupt context.

> @@ -667,18 +666,17 @@ static void s5p_tasklet_cb(unsigned long data)
>  	struct s5p_aes_dev *dev = (struct s5p_aes_dev *)data;
>  	struct crypto_async_request *async_req, *backlog;
>  	struct s5p_aes_reqctx *reqctx;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&dev->lock, flags);
> +	mutex_lock(&dev->lock);
>  	backlog   = crypto_get_backlog(&dev->queue);
>  	async_req = crypto_dequeue_request(&dev->queue);
>  
>  	if (!async_req) {
>  		dev->busy = false;
> -		spin_unlock_irqrestore(&dev->lock, flags);
> +		mutex_unlock(&dev->lock);
>  		return;
>  	}
> -	spin_unlock_irqrestore(&dev->lock, flags);
> +	mutex_unlock(&dev->lock);

Best regards,
