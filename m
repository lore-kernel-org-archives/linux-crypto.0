From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algapi - remove unused notifications
Date: Fri, 5 Jan 2018 22:17:30 +1100
Message-ID: <20180105111729.GD16156@gondor.apana.org.au>
References: <20171229160646.25273-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49996 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751589AbeAELRd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 06:17:33 -0500
Content-Disposition: inline
In-Reply-To: <20171229160646.25273-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 29, 2017 at 10:06:46AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There is a message posted to the crypto notifier chain when an algorithm
> is unregistered, and when a template is registered or unregistered.  But
> nothing is listening for those messages; currently there are only
> listeners for the algorithm request and registration messages.
> 
> Get rid of these unused notifications for now.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
