From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
Date: Wed, 22 Jun 2016 14:40:47 +0800
Message-ID: <20160622064047.GA29318@gondor.apana.org.au>
References: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
 <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
 <20160622005115.GB27134@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193664C@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53902 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbcFVGlU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 02:41:20 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D03193664C@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 06:37:50AM +0000, Benedetto, Salvatore wrote:
>
> Can you explain me the benefit in doing so?

The less code we have the better.  Most of our algorithm types
have a single test function, I have seen no reason why kpp should
be different.

akcipher has been an anomaly and I'm fixing it right now.

> I thought my patchset had reached an 'acceptable' state by now :-)

Now that the secret is encoded to a format under our control, you
can generate byte-stream test vectors for both DH and ECDH using the
same format.  So there is no need to have test functions specific to
one algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
