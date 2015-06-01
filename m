From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 PATCH] crypto: aesni - Convert rfc4106 to new AEAD interface
Date: Mon, 1 Jun 2015 17:52:45 +0800
Message-ID: <20150601095245.GA12754@gondor.apana.org.au>
References: <20150528140311.GA8423@gondor.apana.org.au>
 <2306645.epOL7FXtYn@tauon>
 <20150601090951.GA12317@gondor.apana.org.au>
 <5138754.L8j0JzbJL1@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40301 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbFAJwy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:52:54 -0400
Content-Disposition: inline
In-Reply-To: <5138754.L8j0JzbJL1@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 11:44:22AM +0200, Stephan Mueller wrote:
>
> That code crashes with the following stacktrace:
> 
> [ 2000.433502] BUG: unable to handle kernel NULL pointer dereference at           
> (null)

This crash is totally different from the previous crash you sent.
This one is expected because you're calling givencrypt on an
algorithm that has already been converted.

Once converted they no longer have a givencrypt function and
calling crypto_aead_givencrypt on them will crash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
