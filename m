From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: api - Clear CRYPTO_ALG_DEAD bit before
 registering an alg
Date: Wed, 1 Feb 2017 22:06:30 +0800
Message-ID: <20170201140630.GB32415@gondor.apana.org.au>
References: <1484308448-3225-1-git-send-email-salvatore.benedetto@intel.com>
 <20170123145735.GA20806@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D031A56A79@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41627 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750790AbdBAOGs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 09:06:48 -0500
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D031A56A79@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 23, 2017 at 05:06:34PM +0000, Benedetto, Salvatore wrote:
> 
> I forgot to add CC stable to it.
> 
> This error was introduced in 4.8 and so I think it should go into stable 4.8 and 4.9.
> 
> Should I resend or can you add that?

I had added it when applying the patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
