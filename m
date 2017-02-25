From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Sat, 25 Feb 2017 22:42:04 +0800
Message-ID: <20170225144204.GA28593@gondor.apana.org.au>
References: <20170222221700.GA19026@gallifrey>
 <20170223112156.GA14038@gondor.apana.org.au>
 <20170223134204.GB10083@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45785 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751231AbdBYOmL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Feb 2017 09:42:11 -0500
Content-Disposition: inline
In-Reply-To: <20170223134204.GB10083@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 23, 2017 at 10:42:04AM -0300, Marcelo Cerri wrote:
> It makes sense. Thanks for the clarification, Herbert.
> 
> One more question: are you planning to convert the ctr template to
> skcipher?

Yes everything will be converted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
