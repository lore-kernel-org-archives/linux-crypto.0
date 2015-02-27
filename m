From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt speed: fix filter for aead algorithms
Date: Fri, 27 Feb 2015 22:25:03 +1300
Message-ID: <20150227092503.GA27831@gondor.apana.org.au>
References: <1422971988-21517-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35019 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbbB0JZN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2015 04:25:13 -0500
Content-Disposition: inline
In-Reply-To: <1422971988-21517-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 03, 2015 at 03:59:48PM +0200, Cristian Stoica wrote:
> test_aead_speed is written for sync algorithms without specifically
> requiring them. The effect is that an async algorithm may be used without
> setting up the request callback, this leading to a kernel panic.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Please fix it to test asynchronously instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
