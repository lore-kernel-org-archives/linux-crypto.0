From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm: ignore generated SHA2 assembly files
Date: Mon, 6 Jul 2015 16:34:31 +0800
Message-ID: <20150706083431.GC20800@gondor.apana.org.au>
References: <e9fad4b90e8d3aac883e2a5ac99b330653bcc354.1436155417.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52784 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbGFIeq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 04:34:46 -0400
Content-Disposition: inline
In-Reply-To: <e9fad4b90e8d3aac883e2a5ac99b330653bcc354.1436155417.git.baruch@tkos.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 06, 2015 at 07:03:37AM +0300, Baruch Siach wrote:
> These files are generated since commits f2f770d74a8d (crypto: arm/sha256 - Add
> optimized SHA-256/224, 2015-04-03) and c80ae7ca3726 (crypto: arm/sha512 -
> accelerated SHA-512 using ARM generic ASM and NEON, 2015-05-08).
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
