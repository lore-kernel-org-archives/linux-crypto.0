From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - fix unaligned cbc decrypt for
 x86-32
Date: Thu, 31 May 2012 20:55:06 +1000
Message-ID: <20120531105506.GB6266@gondor.apana.org.au>
References: <1338334988-20025-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Daniel <garkein@mailueberfall.de>, linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:42165 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581Ab2EaKzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 May 2012 06:55:12 -0400
Content-Disposition: inline
In-Reply-To: <1338334988-20025-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 30, 2012 at 01:43:08AM +0200, Mathias Krause wrote:
> The 32 bit variant of cbc(aes) decrypt is using instructions requiring
> 128 bit aligned memory locations but fails to ensure this constraint in
> the code. Fix this by loading the data into intermediate registers with
> load unaligned instructions.
> 
> This fixes reported general protection faults related to aesni.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=43223
> Reported-by: Daniel <garkein@mailueberfall.de>
> Cc: stable@kernel.org [v2.6.39+]
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Patch applied to crypto.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
