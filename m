Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48502 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfARK5o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:57:44 -0500
Date: Fri, 18 Jan 2019 18:57:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/5] crypto: testmgr - add rfc4543(gcm(aes)) decryption
 test to encryption tests
Message-ID: <20190118105742.crqssee5pnu7siqx@gondor.apana.org.au>
References: <20190113233228.5851-1-ebiggers@kernel.org>
 <20190113233228.5851-5-ebiggers@kernel.org>
 <20190115174538.GA10955@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115174538.GA10955@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 15, 2019 at 09:45:40AM -0800, Eric Biggers wrote:
> On Sun, Jan 13, 2019 at 03:32:27PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > One "ccm(aes)" decryption test vector doesn't exactly match any of the
> > encryption test vectors with input and result swapped.  In preparation
> 
> This should say "rfc4543(gcm(aes))".  If I happen to send v2 of this series I'll
> fix it, otherwise Herbert can you fix this when applying?  Thanks!

I have made this change.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
