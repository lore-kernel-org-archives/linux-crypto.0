From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm/sha512 - accelerated SHA-512 using ARM
 generic ASM and NEON
Date: Mon, 11 May 2015 15:20:25 +0800
Message-ID: <20150511072025.GA2789@gondor.apana.org.au>
References: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150511065952.GB2598@gondor.apana.org.au>
 <CAKv+Gu9+xrX2nB43cskOoL63WjZGTDdq9ZTO-maWas5u=ng=JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40646 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbbEKHUb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 03:20:31 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9+xrX2nB43cskOoL63WjZGTDdq9ZTO-maWas5u=ng=JQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2015 at 09:00:49AM +0200, Ard Biesheuvel wrote:
>
> Yes, you are right. Let me figure out what's going on and send you a
> new version.

Don't worry.  I fixed it up while applying the patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
