From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif_aead - Require setkey before accept(2)
Date: Tue, 25 Apr 2017 16:47:48 +0800
Message-ID: <20170425084748.GA24078@gondor.apana.org.au>
References: <2439869.UPpkkqdW7f@positron.chronox.de>
 <1688100.DB4uBLsSBi@positron.chronox.de>
 <20170424102239.GE20943@gondor.apana.org.au>
 <41476204.egAyRFCtmD@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:47438 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1176850AbdDYIsW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 04:48:22 -0400
Content-Disposition: inline
In-Reply-To: <41476204.egAyRFCtmD@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 24, 2017 at 12:26:15PM +0200, Stephan Müller wrote:
> Am Montag, 24. April 2017, 12:22:39 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > Patch applied.  Thanks.
> 
> Thank you.
> 
> The patch regarding the memory management of algif_aead is affected by this 
> change as well. Shall I roll a new version of that patch for algif_aead or do 
> you want me to wait for another review round?

Could you wait until the next merge window closes?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
