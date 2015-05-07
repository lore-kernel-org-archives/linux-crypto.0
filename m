From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm64/crc32: bring in line with generic CRC32
Date: Thu, 7 May 2015 11:18:38 +0800
Message-ID: <20150507031838.GA29557@gondor.apana.org.au>
References: <1430730017-3712-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, yazen.ghannam@linaro.org,
	steve.capper@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52977 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbEGDSn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 23:18:43 -0400
Content-Disposition: inline
In-Reply-To: <1430730017-3712-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2015 at 11:00:16AM +0200, Ard Biesheuvel wrote:
> The arm64 CRC32 (not CRC32c) implementation was not quite doing
> the same thing as the generic one. Fix that.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
