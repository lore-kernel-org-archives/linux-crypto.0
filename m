From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 22:20:50 +0800
Message-ID: <20160622142050.GA540@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
 <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
 <20160622140225.GA315@gondor.apana.org.au>
 <576A9E64.2020209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Denis Kenzior <denkenz@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55403 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbcFVOVq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:21:46 -0400
Content-Disposition: inline
In-Reply-To: <576A9E64.2020209@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 09:19:16AM -0500, Denis Kenzior wrote:
> Just to clarify, we use this from userspace.  So we _already_ depend
> on this functionality.  Please keep the hash and non-hash versions
> of pkcs1pad available.

How can you be depending on this in userspace when we haven't
even exported akcipher to userspace? Colour me confused.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
