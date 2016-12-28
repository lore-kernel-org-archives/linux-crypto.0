From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Wed, 28 Dec 2016 17:13:44 +0800
Message-ID: <20161228091344.GA12266@gondor.apana.org.au>
References: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161227100400.GA10629@gondor.apana.org.au>
 <6124F827-BA28-4A3D-B05F-EBCB1323955D@linaro.org>
 <20161228090350.GD11904@gondor.apana.org.au>
 <AA6F25FA-C998-462F-9E25-FF543BBE3EA7@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45139 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751103AbcL1JNu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:13:50 -0500
Content-Disposition: inline
In-Reply-To: <AA6F25FA-C998-462F-9E25-FF543BBE3EA7@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 28, 2016 at 09:11:03AM +0000, Ard Biesheuvel wrote:
> 
> > On 28 Dec 2016, at 09:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > 
> >> On Tue, Dec 27, 2016 at 02:26:35PM +0000, Ard Biesheuvel wrote:
> >> 
> >> You just nacked the v2 of this series (due to the chunksize/walksize) and i rewrote them as skciphers as well
> > 
> > Sorry.  Would you like me to revert or just send a new series
> > on top of this?
> > 
> 
> No worries. If you can, please drop them entirely, or revert them otherwise. I will resend after the holidays

OK I will revert.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
