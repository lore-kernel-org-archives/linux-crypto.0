From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: drbg - Add select on sha256
Date: Thu, 11 Jun 2015 09:40:04 +0800
Message-ID: <20150611014004.GA9616@gondor.apana.org.au>
References: <20150611005510.GA9267@gondor.apana.org.au>
 <7796083.9xmz0KqbMC@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36858 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbFKBkG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 21:40:06 -0400
Content-Disposition: inline
In-Reply-To: <7796083.9xmz0KqbMC@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 11, 2015 at 03:37:38AM +0200, Stephan Mueller wrote:
> Am Donnerstag, 11. Juni 2015, 08:55:10 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > The hash-based DRBG variants all use sha256 so we need to add a
> > select on it.
> 
> Would that be sufficient? We can have SHA1, SHA384 and SHA512 with the current 
> drbg_cores[] too.

Yes but only sha256 is used by default, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
