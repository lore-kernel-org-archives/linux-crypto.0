From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: alloc of Intel rfc4106 crashes
Date: Fri, 22 May 2015 19:29:04 +0800
Message-ID: <20150522112904.GA5582@gondor.apana.org.au>
References: <5617832.rX3Zor0TMY@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38378 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811AbbEVL3X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 07:29:23 -0400
Content-Disposition: inline
In-Reply-To: <5617832.rX3Zor0TMY@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 22, 2015 at 12:31:52PM +0200, Stephan Mueller wrote:
> 
> With the current cryptodev-2.6 tree (ex the patches to AEAD from the last 2 days), I get the following oops that is triggered by simply calling

This should be fixed in the latest tree by:

commit 9b8c456e081e7eca856ad9b2a92980a68887f533
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu May 21 15:10:57 2015 +0800

    crypto: cryptd - Use crypto_grab_aead

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
