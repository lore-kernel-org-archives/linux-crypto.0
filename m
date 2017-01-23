From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH] crypto: api - Clear CRYPTO_ALG_DEAD bit before
 registering an alg
Date: Mon, 23 Jan 2017 17:06:34 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031A56A79@IRSMSX102.ger.corp.intel.com>
References: <1484308448-3225-1-git-send-email-salvatore.benedetto@intel.com>
 <20170123145735.GA20806@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:55529 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbdAWRGg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 12:06:36 -0500
In-Reply-To: <20170123145735.GA20806@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Monday, January 23, 2017 2:58 PM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH] crypto: api - Clear CRYPTO_ALG_DEAD bit before
> registering an alg
> 
> On Fri, Jan 13, 2017 at 11:54:08AM +0000, Salvatore Benedetto wrote:
> > Make sure CRYPTO_ALG_DEAD bit is cleared before proceeding with the
> > algorithm registration. This fixes qat-dh registration when driver is
> > restarted
> >
> > Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> 
> Patch applied.  Thanks.

I forgot to add CC stable to it.

This error was introduced in 4.8 and so I think it should go into stable 4.8 and 4.9.

Should I resend or can you add that?

Regards,
Salvatore

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
