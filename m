From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] crypto: move ablk_helper out of arch/x86
Date: Tue, 24 Sep 2013 06:09:45 +1000
Message-ID: <20130923200944.GF21243@gondor.apana.org.au>
References: <1379663741-21085-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, jussi.kivilinna@iki.fi, arnd@arndb.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:45830 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753450Ab3IWUJu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 16:09:50 -0400
Content-Disposition: inline
In-Reply-To: <1379663741-21085-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 20, 2013 at 09:55:39AM +0200, Ard Biesheuvel wrote:
> v3:
> - added generic and x86 versions of <asm/simd.h> containing may_use_simd(), and
>   use it to decide whether to take the sync or the async path
> 
> v2:
> - whitespace fix
> - split into two patches so that the first one applies cleanly to the ARM/ARM64
>   trees as well
> - rebased onto cryptodev/master
> 
> Ard Biesheuvel (2):
>   crypto: create generic version of ablk_helper
>   crypto: move x86 to the generic version of ablk_helper

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
