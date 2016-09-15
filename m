From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] revamp fips_allowed flag
Date: Thu, 15 Sep 2016 14:26:29 +0800
Message-ID: <20160915062629.GA14950@gondor.apana.org.au>
References: <1818375.56xtGUSNII@tauon.atsec.com>
 <20160915055808.GA14688@gondor.apana.org.au>
 <2606890.Z1PDhBGeZR@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38572 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933823AbcIOG0e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 02:26:34 -0400
Content-Disposition: inline
In-Reply-To: <2606890.Z1PDhBGeZR@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 15, 2016 at 08:23:05AM +0200, Stephan Mueller wrote:
> 
> Where shall we draw the line here? Shall that be only for authenc, or seqiv? 
> Or shall we also consider rfc4106 too, knowing that there are implementations 
> which provide a full rfc4106 GCM combo (x86 for example). What about the 
> current pkcspad1 template where we could expect that there may be entire HW 
> implementations with that?

That's something that only you can tell us :)

For such templates we could move that info into the generic
template implementation code and have them declare themselves
as such that for any X if X is FIPS allowed then so is T(X).

This info can then be used in testmgr.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
