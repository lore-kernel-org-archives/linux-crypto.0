From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: engine - Permit to enqueue skcipher
 request
Date: Mon, 19 Jun 2017 09:55:24 +0200
Message-ID: <20170619075524.GA27419@Red>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
 <20170606134417.18850-3-clabbe.montjoie@gmail.com>
 <20170619052707.GA13180@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38248 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdFSHzb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 03:55:31 -0400
Content-Disposition: inline
In-Reply-To: <20170619052707.GA13180@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 19, 2017 at 01:27:08PM +0800, Herbert Xu wrote:
> On Tue, Jun 06, 2017 at 03:44:17PM +0200, Corentin Labbe wrote:
> > The crypto engine could actually only enqueue hash and ablkcipher request.
> > This patch permit it to enqueue skcipher requets by adding all necessary
> > functions.
> > The only problem is that ablkcipher and skcipher id are the same, so
> > only one cipher type is usable on the same crypto engine.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> 
> I think this should be done as part of the skcipher conversion rather
> than as a standalone patch.
> 

Since there are two different user of "crypto engine + ablkcipher", it will be not easy to convert them in one serie. (I could do it, but I simply could not test it for OMAP (lack of hw))
And any new user which want to use crypto engine+skcipher (like me with the sun8i-ce driver) are simply stuck.

Regards
