From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] how to handle AAD copy operation for algif_aead
Date: Thu, 9 Mar 2017 18:23:16 +0800
Message-ID: <20170309102316.GA7027@gondor.apana.org.au>
References: <13406914.zeok8basum@positron.chronox.de>
 <78373946.kaJU5cUr5f@tauon.atsec.com>
 <20170309100554.GA6945@gondor.apana.org.au>
 <9194388.iDFJIB4SCo@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46199 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754213AbdCIKYC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:24:02 -0500
Content-Disposition: inline
In-Reply-To: <9194388.iDFJIB4SCo@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 09, 2017 at 11:08:32AM +0100, Stephan Müller wrote:
>
> This is the first patch (0001-crypto-algif_aead-copy-AAD-from-src-to-
> dst_separate.patch).
> 
> The second alternative patch (0001-crypto-algif_aead-copy-AAD-from-src-to-
> dst_inplace.patch) does:

I see.  Yes that looks good.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
