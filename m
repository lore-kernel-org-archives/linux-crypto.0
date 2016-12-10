From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: algif for compression?
Date: Sat, 10 Dec 2016 16:10:14 +0800
Message-ID: <20161210081014.GA32746@gondor.apana.org.au>
References: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: abed mohammad kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39578 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752534AbcLJIKT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Dec 2016 03:10:19 -0500
Content-Disposition: inline
In-Reply-To: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

abed mohammad kamaluddin <abedamu@gmail.com> wrote:
> 
> We are also looking for user-space access to the kernel crypto layer
> compression algorithms. I have gone through AF_ALG but couldn’t find
> support for compression ops through it. This is required for our
> hardware zip engines whose driver hooks up to the crypto layer.
> 
> I was going through the lists and stumbled across this thread. Has
> there been  any updates or efforts put up in this direction since this
> thread is a few years old. If not, are there any alternate
> implementations that allow user-space access to compression? I have
> gone through cryptodev and see the same limitation there.
> 
> Would appreciate any pointers in this regard.

The compression interface is currently in a state of flux.  We
should make it settle down first before exporting it to user-space.

For a start it would be good to actually switch IPsec/IPcomp over
to the new compression interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
