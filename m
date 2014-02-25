From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] arm64: add support for AES in CCM mode using Crypto
 Extensions
Date: Tue, 25 Feb 2014 15:16:26 +0800
Message-ID: <20140225071626.GA10524@gondor.apana.org.au>
References: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140225070252.GB9934@gondor.apana.org.au>
 <CAKv+Gu-HnTk5RCLRoCnae7-HH7C-Tq2YJF57Nc-hOEykdY52XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	Nicolas Pitre <nico@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47112 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHQ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:16:29 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-HnTk5RCLRoCnae7-HH7C-Tq2YJF57Nc-hOEykdY52XA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:12:36AM +0100, Ard Biesheuvel wrote:
>
> Do you have any comments specifically about using an inner blkcipher
> instance to implement the aead?

Indeed, the inner block cipher looks superfluous since it's only
used once by ccm and there is no nesting similar to aesni-intel.

Inner algorithms are only needed if you want to nest it, e.g.,
through fpu().  Otherwise I don't see any difference vs. calling
the underlying functions directly, especially since you seem to
be calling them directly anyway.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
