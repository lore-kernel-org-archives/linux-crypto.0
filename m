From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Thu, 8 Aug 2013 15:02:30 +1000
Message-ID: <20130808050230.GB9636@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <20130806120540.GA364@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48172 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755260Ab3HHFCc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 01:02:32 -0400
Content-Disposition: inline
In-Reply-To: <20130806120540.GA364@oc8526070481.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 06, 2013 at 09:05:41AM -0300, Marcelo Cerri wrote:
>
> I saw it's possible to keep a context in an ablkcipher_request
> structure. I'm assuming that multiple callers using the same tfm still
> would have to use different requests. So do you think that implementing
> it as an asynchronous block cipher would be an alternative to locks in
> the NX driver?

It really depends on your hardware.  For example, does it provide
a convenient way of notifying the completion of an operation?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
