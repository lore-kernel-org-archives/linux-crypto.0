From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GCM / seqiv and SP800-38D
Date: Sat, 28 Feb 2015 23:47:12 +1300
Message-ID: <20150228104712.GA7720@gondor.apana.org.au>
References: <5009281.r2g8PApWDK@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57198 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbB1KrS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 05:47:18 -0500
Content-Disposition: inline
In-Reply-To: <5009281.r2g8PApWDK@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 19, 2015 at 07:56:48AM +0100, Stephan Mueller wrote:
>
> In case of rfc4106(gcm(aes)), the IV is 96 bits. Thus, our constructed 
> IV looks like:

The IV to rfc4106 is 96 bits, but the IV to the underlying gcm
is 128 bits so that's what guarantees the uniqueness.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
