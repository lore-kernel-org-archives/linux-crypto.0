From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: GCM aesni and 192/256-bit keys
Date: Mon, 5 Jan 2015 21:06:44 +1100
Message-ID: <20150105100644.GA24595@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41325 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbAEKGu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 05:06:50 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz:

It appears that the GCM aesni implementation does not support
192/256-bit keys.  This is not allowed as accelerated drivers
must support everything supported by the software implementation.

Could we add 192/256-bit support to it please? If for some reason
this cannot be done then at least implement a software fallback
so that it continues to work.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
