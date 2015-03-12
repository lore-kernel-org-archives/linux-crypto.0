From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/5] ARM: crypto: ARMv8 Crypto Extensions
Date: Thu, 12 Mar 2015 21:19:49 +1100
Message-ID: <20150312101949.GA18614@gondor.apana.org.au>
References: <1425977268-27835-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@iki.fi, linux-crypto@vger.kernel.org,
	linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
	nico@linaro.org, will.deacon@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49834 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbbCLKT7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 06:19:59 -0400
Content-Disposition: inline
In-Reply-To: <1425977268-27835-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 10, 2015 at 09:47:43AM +0100, Ard Biesheuvel wrote:
> This is v2 of the ARM crypto series I sent out yesterday, erroneously without
> a cover letter.
> 
> Patch #1 moves all the ARM specific crypto options to arch/arm/crypto/Kconfig.
> 
> Patches #2 - #5 implement SHA1, SHA-224/256, AES-ECB/CBC/CTR/XTS and GHASH,
> respectively.
> 
> Changes since v1:
> - fixes for BE (currently still untested)
> - added alignment hints where appropriate (e,g., [rX, :128])
> - various minor tweaks

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
