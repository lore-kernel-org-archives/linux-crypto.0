From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: echainiv not working as supposed to be?
Date: Wed, 7 Sep 2016 00:08:10 +0800
Message-ID: <20160906160810.GA10311@gondor.apana.org.au>
References: <CA+rthh9_=PsJgZDtfoHQsaFZ2fH2hz4w_sbhn8fnx7a3LOatXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41966 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbcIFQIX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 12:08:23 -0400
Content-Disposition: inline
In-Reply-To: <CA+rthh9_=PsJgZDtfoHQsaFZ2fH2hz4w_sbhn8fnx7a3LOatXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 06, 2016 at 02:24:59PM +0200, Mathias Krause wrote:
> 
> For each request it XORs the salt into the provided IV (req->iv). For
> ESP the provided IV is the sequence number or, at least, parts of it.
> The thus modified IV gets written into the *destination* buffer
> (req->dst) which might be a different buffer than the source buffer
> (not in the ESP case, though, as it passes the same sg for src and
> dst). Afterwards, the per-cpu IV gets copied over into req->iv,
> effectively overwriting the generated XORed value. Then the inner
> crypto request gets initiated which may finish synchronously or
> asynchronously. Either way, the per-cpu IV gets updated with the new
> value from subreq->iv, which should be equal to req->iv in the normal
> case.

I think your description is basically correct.  However, you seem
to be missing the fact that the real IV (i.e., the IV transmitted
over the wire) is the first block of the encrypted ciphertext.

IOW the per-cpu IV is never sent over the wire.  It's only used
to encrypt the first block of the ciphertext, which becomes the
actual IV.

> So, should echainiv use a per-context per-cpu array instead that --
> for simplicity -- gets initialised with random bytes and will be
> updated as it's now, just not with a single global per-cpu array, but
> a per-context one?

As I said, the per-cpu IV is never seen by anyone so there is no
need to make it per-tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
