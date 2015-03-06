From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH trivial/resend 4/9] crypto: ux500: Update error message
 for dmaengine_prep_slave_sg() API
Date: Fri, 6 Mar 2015 23:01:55 +1100
Message-ID: <20150306120155.GC5363@gondor.apana.org.au>
References: <1425460770-9816-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47158 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbCFMCB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 07:02:01 -0500
Content-Disposition: inline
In-Reply-To: <1425460770-9816-1-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 04, 2015 at 10:19:30AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Commit 7e933d3b1e25b250 ("crypto: ux500: use dmaengine_prep_slave_sg
> API") changed the code to use the new API, but forgot to update an error
> message.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
