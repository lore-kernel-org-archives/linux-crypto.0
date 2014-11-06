From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] aesni-intel_glue.c: remove unnecessary #define
Date: Thu, 6 Nov 2014 23:16:29 +0800
Message-ID: <20141106151629.GA4544@gondor.apana.org.au>
References: <1413884132-9776-1-git-send-email-valentinrothberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, tglx@linutronix.de,
	linux-crypto@vger.kernel.org
To: Valentin Rothberg <valentinrothberg@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34666 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKFPQh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 10:16:37 -0500
Content-Disposition: inline
In-Reply-To: <1413884132-9776-1-git-send-email-valentinrothberg@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 21, 2014 at 11:35:32AM +0200, Valentin Rothberg wrote:
> The CPP identifier 'HAS_PCBC' is defined when the Kconfig
> option CRYPTO_PCBC is set as 'y' or 'm', and is further
> used in two ifdef blocks to conditionally compile source
> code. This indirection hides the actual Kconfig dependency
> and complicates readability. Moreover, it's inconsistent
> with the rest of the ifdef blocks in the file, which
> directly reference Kconfig options.
> 
> This patch removes 'HAS_PCBC' and replaces its occurrences
> with the actual dependency on 'CRYPTO_PCBC' being set as
> 'y' or 'm'.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
