From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v6 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Mon, 10 Apr 2017 12:54:58 +0200
Message-ID: <1936619.vexBXQoksL@tauon.chronox.de>
References: <2473716.zZb2vDUueJ@positron.chronox.de> <1663859.jv2e0HPzin@positron.chronox.de> <20170410104333.GB8427@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58894 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752757AbdDJKzA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:55:00 -0400
In-Reply-To: <20170410104333.GB8427@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 10. April 2017, 12:43:33 CEST schrieb Herbert Xu:

Hi Herbert,

> On Sat, Apr 01, 2017 at 10:52:30PM +0200, Stephan Müller wrote:
> >  	lock_sock(sk);
> > 
> > -	while (msg_data_left(msg)) {
> > -		if (!ctx->used) {
> > -			err = skcipher_wait_for_data(sk, flags);
> > -			if (err)
> > -				goto unlock;
> > +	while (iov_iter_count(&msg->msg_iter)) {
> 
> Please keep it as msg_data_left.

Shall I apply the algif_aead patch on top of your patch just sent to stable?

Thanks.

Ciao
Stephan
