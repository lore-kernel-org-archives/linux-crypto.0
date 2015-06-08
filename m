From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto driver -DCP
Date: Mon, 8 Jun 2015 12:52:00 +0800
Message-ID: <20150608045200.GA25459@gondor.apana.org.au>
References: <554BBD05.3050807@freescale.com>
 <201506041734.40053.marex@denx.de>
 <20150605035433.GB527@gondor.apana.org.au>
 <201506051638.03892.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53286 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbFHEwQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 00:52:16 -0400
Content-Disposition: inline
In-Reply-To: <201506051638.03892.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 05, 2015 at 04:38:03PM +0200, Marek Vasut wrote:
> 
> In general, it would probably make sense to add a flag to .setkey() to
> store the key in a keyslot. The keyslot allocation would be up to the
> driver. In case all keyslots would be full, the setkey() with the flag
> set would simply fail. This would imply you would need to have a counterpart
> function to .setkey() to free keyslots -- something like .unsetkey() .

Changing setkey is going to cause too much churn.  In any case
I don't think these key slots should be written to by the kernel
since the intention appears to be for entites outside the kernel
to place secret keys in there that can then be used but not read
by the kernel.

So as far as the kernel is concerned these are constant keys.

Therefore there should be no need for unsetkey.

So perhaps just add a new call setkey_slot that is optional and
only needs to be implemented by drivers such as ccp.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
