From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: [linux-next:master 7274/8070] undefined reference to
 `crypto_alloc_shash'
Date: Tue, 11 Apr 2017 18:50:00 +0800
Message-ID: <20170411105000.GA12081@gondor.apana.org.au>
References: <1827882.yksAJm9a6v@positron.chronox.de>
 <20170410102223.GA8340@gondor.apana.org.au>
 <1883619.lA7a8XQHvy@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50220 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753045AbdDKKuJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2017 06:50:09 -0400
Content-Disposition: inline
In-Reply-To: <1883619.lA7a8XQHvy@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 10, 2017 at 12:46:22PM +0200, Stephan Müller wrote:
> Am Montag, 10. April 2017, 12:22:23 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > Hmm that's weird because CRYPTO_HASH selects CRYPTO_HASH2.  Do
> > you have a kconfig file that reproduces this?
> 
> Please see attached.

I see the problem.  When you select CRYPTO_HASH you must also
select CRYPTO.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
