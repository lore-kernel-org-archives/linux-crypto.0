From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Linux 2.6.28 and AEAD initialization
Date: Wed, 28 Jan 2009 14:10:14 +1100
Message-ID: <20090128031014.GB5536@gondor.apana.org.au>
References: <4976889C.3090602@strongswan.org> <20090127070102.GA28643@gondor.apana.org.au> <497FA471.9070405@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andreas Steffen <andreas.steffen@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbZA1DKR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 22:10:17 -0500
Content-Disposition: inline
In-Reply-To: <497FA471.9070405@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2009 at 01:18:57AM +0100, Andreas Steffen wrote:
> Hi Herbert,
> 
> your patch fixes the initialization problem!

Thanks for testing! I'll push this fix out.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
