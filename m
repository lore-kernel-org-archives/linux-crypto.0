From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: algif_akcipher
Date: Mon, 5 Sep 2016 16:57:14 +0800
Message-ID: <20160905085714.GA30191@gondor.apana.org.au>
References: <1708704.H7uTHYKb98@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60595 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbcIEI5u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2016 04:57:50 -0400
Content-Disposition: inline
In-Reply-To: <1708704.H7uTHYKb98@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 04, 2016 at 04:06:43PM +0200, Stephan Mueller wrote:
> Hi Herbert, David,
> 
> may I inquire for the plans with algif_akcipher? The reason I am asking is 
> whether this interface may be accepted or whether a key rings based solution 
> is used and whether I can leave or remove the akcipher related API from my 
> libkcapi.

I do plan to add something like this eventually.  However, at this
point in time I'd like to see akcipher itself mature a bit before
we set it in stone with a user-space interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
