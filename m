From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 03/n]: Indicate asynchronous processing to crypto API
Date: Wed, 7 May 2008 16:23:08 +0400
Message-ID: <20080507122307.GA17128@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <48219E58.4000503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35962 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbYEGMXV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:23:21 -0400
Content-Disposition: inline
In-Reply-To: <48219E58.4000503@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Wed, May 07, 2008 at 02:19:36PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>     hifn_setup_crypto() needs to return -EINPROGRESS on success to indicate
>     asynchronous processing to the crypto API. This also means it must not
>     return the errno code returned by hifn_process_queue(), if any.

Then how to indicate that error occured?
What if we will return -EINPROGRESS in case of success and negative
errno otherwise?

> @@ -2202,9 +2202,9 @@ static int hifn_setup_crypto(struct ablkcipher_request *req, u8 op,
>  		return err;
>  
>  	if (dev->started < HIFN_QUEUE_LENGTH &&	dev->queue.qlen)
> -		err = hifn_process_queue(dev);
> +		hifn_process_queue(dev);
>  
> -	return err;
> +	return -EINPROGRESS;

Thus we are not able to return any error at all...

-- 
	Evgeniy Polyakov
