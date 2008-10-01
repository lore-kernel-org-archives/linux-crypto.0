From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: CTS (cipher text stealing mode) and short packets
Date: Wed, 1 Oct 2008 23:55:09 +0800
Message-ID: <20081001155509.GA14952@gondor.apana.org.au>
References: <f9d2a5e10809292008i48e66474hbde8c7723b848c50@mail.gmail.com> <E1KkgHv-00011M-OJ@gondolin.me.apana.org.au> <f9d2a5e10809300941m2f63bf4cuc89b2c5f5fe5382@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kwc@citi.umich.edu, linux-crypto@vger.kernel.org
To: Russ Dill <russ.dill@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35582 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752541AbYJAPzR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Oct 2008 11:55:17 -0400
Content-Disposition: inline
In-Reply-To: <f9d2a5e10809300941m2f63bf4cuc89b2c5f5fe5382@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 30, 2008 at 09:41:04AM -0700, Russ Dill wrote:
>
> I'm just not sure how to best fit that into an API. In the case of
> number of bytes being greater than the underlying block size,
> everything works "normally". But in the case of the number of bytes
> being less than or equal to the block size, the IV sent to the remote
> end needs to be modified.

I see.  I think the easiest way right now is to use the givencrypt
interface.  The only time you can modify the IV is when you are
able to send the IV to the other side, in which case givencrypt
should be a reasonable interface.

If the user calls you through encrypt then you just fail any
requests <= block_size.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
