From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: notify expected failures on aead tests
Date: Tue, 20 Jan 2015 14:35:49 +1100
Message-ID: <20150120033549.GA10814@gondor.apana.org.au>
References: <1421675664-26107-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	horia.geanta@freescale.com, tudor.ambarus@freescale.com
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48968 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbATDfx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2015 22:35:53 -0500
Content-Disposition: inline
In-Reply-To: <1421675664-26107-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 19, 2015 at 03:54:24PM +0200, Cristian Stoica wrote:
> Some hardware drivers (e.g. caamalg) log failed operations reported by
> hw to assist in debugging. However, these messages are confusing when they
> are the result of a testmgr test that is expected to fail.
> 
> This patch puts the driver messages in their testing context and helps the
> user classify them as harmless.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

No, I'm not going to create spam in everybody's dmesg just so that
you can make sense of the spam coming from one driver.

If it doesn't make sense on its own then it probably shouldn't be
emitting them.  Verification failures are normal events, e.g., you
can get them via packet corruption.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
