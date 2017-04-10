From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: [linux-next:master 7274/8070] undefined reference to
 `crypto_alloc_shash'
Date: Mon, 10 Apr 2017 18:22:23 +0800
Message-ID: <20170410102223.GA8340@gondor.apana.org.au>
References: <1827882.yksAJm9a6v@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51824 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751946AbdDJKWz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:22:55 -0400
Content-Disposition: inline
In-Reply-To: <1827882.yksAJm9a6v@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 09, 2017 at 10:09:54PM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> I got the attached error report. This is due to CRYPTO_HASH2 is selected as m 
> whereas security/keys/dh.c is compiled as y. Note CRYPTO_HASH is selected as 
> y.

Hmm that's weird because CRYPTO_HASH selects CRYPTO_HASH2.  Do
you have a kconfig file that reproduces this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
