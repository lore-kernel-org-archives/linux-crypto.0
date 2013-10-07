From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] sha256_ssse3: also test for BMI2
Date: Mon, 7 Oct 2013 18:11:19 +1100
Message-ID: <20131007071119.GF7522@gondor.apana.org.au>
References: <1380630886-6863-1-git-send-email-oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	Oliver Neukum <oneukum@suse.de>
To: oliver@neukum.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35658 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3JGHL0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Oct 2013 03:11:26 -0400
Content-Disposition: inline
In-Reply-To: <1380630886-6863-1-git-send-email-oliver@neukum.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 01, 2013 at 02:34:46PM +0200, oliver@neukum.org wrote:
> From: Oliver Neukum <oneukum@suse.de>
> 
> The AVX2 implementation also uses BMI2 instructions,
> but doesn't test for their availability. The assumption
> that AVX2 and BMI2 always go together is false. Some
> Haswells have AVX2 but not BMI2.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
