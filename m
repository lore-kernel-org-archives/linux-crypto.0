From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
Date: Sat, 10 Dec 2016 13:37:12 +0800
Message-ID: <20161210053711.GB27951@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com>
 <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kernel-hardening@lists.openwall.com"
        <kernel-hardening@lists.openwall.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40206 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752030AbcLJFhW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Dec 2016 00:37:22 -0500
Content-Disposition: inline
In-Reply-To: <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 09, 2016 at 09:25:38PM -0800, Andy Lutomirski wrote:
>
> Herbert, how hard would it be to teach the crypto code to use a more
> sensible data structure than scatterlist and to use coccinelle fix
> this stuff for real?

First of all we already have a sync non-SG hash interface, it's
called shash.

If we had enough sync-only users of skcipher then I'll consider
adding an interface for it.  However, at this point in time it
appears to more sense to convert such users over to the async
interface rather than the other way around.

As for AEAD we never had a sync interface to begin with and I
don't think I'm going to add one.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
