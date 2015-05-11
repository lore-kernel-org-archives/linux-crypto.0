From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: testmgr: add test cases for CRC32
Date: Mon, 11 May 2015 15:21:29 +0800
Message-ID: <20150511072129.GC2789@gondor.apana.org.au>
References: <1430730017-3712-1-git-send-email-ard.biesheuvel@linaro.org>
 <1430730017-3712-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, yazen.ghannam@linaro.org,
	steve.capper@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54440 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbbEKHVc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 03:21:32 -0400
Content-Disposition: inline
In-Reply-To: <1430730017-3712-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2015 at 11:00:17AM +0200, Ard Biesheuvel wrote:
> This adds a couple of test cases for CRC32 (not CRC32c) to
> ensure that the generic and arch specific implementations
> are in sync.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied to cryptodev.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
