From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: authenc: crash if key is not set
Date: Mon, 10 Apr 2017 18:41:25 +0800
Message-ID: <20170410104125.GA8427@gondor.apana.org.au>
References: <13796038.esLDiIrSPd@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51832 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752829AbdDJKl4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 06:41:56 -0400
Content-Disposition: inline
In-Reply-To: <13796038.esLDiIrSPd@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 24, 2017 at 09:24:34PM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> I am working on fuzzing the AF_ALG interface.
> 
> The fuzzer reliably triggered the following type of bug when I use 
> authenc(hmac(sha256),cbc(aes)) or other types of authenc() but do not call 
> setkey.
> 
> Note, it works with gcm or ccm.
> 
> Is that bug similar in nature as the algif_skcipher and algif_hash bugs that 
> were fixed with the *nokey functions?

Yes we need to add the same thing to AEAD.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
