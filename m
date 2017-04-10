From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Mon, 10 Apr 2017 18:43:33 +0800
Message-ID: <20170410104333.GB8427@gondor.apana.org.au>
References: <2473716.zZb2vDUueJ@positron.chronox.de>
 <1663859.jv2e0HPzin@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51840 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752696AbdDJKnw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:43:52 -0400
Content-Disposition: inline
In-Reply-To: <1663859.jv2e0HPzin@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 01, 2017 at 10:52:30PM +0200, Stephan Müller wrote:
>
>  	lock_sock(sk);
> -	while (msg_data_left(msg)) {
> -		if (!ctx->used) {
> -			err = skcipher_wait_for_data(sk, flags);
> -			if (err)
> -				goto unlock;
> +	while (iov_iter_count(&msg->msg_iter)) {

Please keep it as msg_data_left.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
