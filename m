From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH bugfix 1/2] crypto: arm64/sha1-ce - prevent asm code
 finalization in final() path
Date: Thu, 7 May 2015 11:19:01 +0800
Message-ID: <20150507031901.GB29557@gondor.apana.org.au>
References: <1430920472-20416-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45648 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbEGDTD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 23:19:03 -0400
Content-Disposition: inline
In-Reply-To: <1430920472-20416-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 06, 2015 at 03:54:31PM +0200, Ard Biesheuvel wrote:
> Ensure that the asm code finalization path is not triggered when
> invoked via final(), since it already takes care of that itself.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Both applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
