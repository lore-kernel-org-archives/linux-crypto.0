From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Mon, 10 Apr 2017 18:56:38 +0800
Message-ID: <20170410105638.GB8615@gondor.apana.org.au>
References: <2473716.zZb2vDUueJ@positron.chronox.de>
 <1663859.jv2e0HPzin@positron.chronox.de>
 <20170410104333.GB8427@gondor.apana.org.au>
 <1936619.vexBXQoksL@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51884 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbdDJK5C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:57:02 -0400
Content-Disposition: inline
In-Reply-To: <1936619.vexBXQoksL@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 10, 2017 at 12:54:58PM +0200, Stephan Müller wrote:
> Am Montag, 10. April 2017, 12:43:33 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Sat, Apr 01, 2017 at 10:52:30PM +0200, Stephan Müller wrote:
> > >  	lock_sock(sk);
> > > 
> > > -	while (msg_data_left(msg)) {
> > > -		if (!ctx->used) {
> > > -			err = skcipher_wait_for_data(sk, flags);
> > > -			if (err)
> > > -				goto unlock;
> > > +	while (iov_iter_count(&msg->msg_iter)) {
> > 
> > Please keep it as msg_data_left.
> 
> Shall I apply the algif_aead patch on top of your patch just sent to stable?

It doesn't really matter.  I'll figure it out when I apply it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
