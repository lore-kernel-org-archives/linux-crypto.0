From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed
 statesize
Date: Mon, 4 Jul 2016 17:42:14 +0800
Message-ID: <20160704094214.GA32058@gondor.apana.org.au>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-7-git-send-email-t-kristo@ti.com>
 <20160624103209.GA19607@gondor.apana.org.au>
 <5770B283.8000902@ti.com>
 <20160627050031.GA5673@gondor.apana.org.au>
 <577A298E.4040803@ti.com>
 <20160704091925.GA31964@gondor.apana.org.au>
 <577A2BE4.1090202@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	tony@atomide.com, davem@davemloft.net, lokeshvutla@ti.com,
	linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40505 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcGDJm0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 05:42:26 -0400
Content-Disposition: inline
In-Reply-To: <577A2BE4.1090202@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 12:27:00PM +0300, Tero Kristo wrote:
>
> The driver allocates a largish buffer for copying the input data
> from the sgs into a sequential space. If I don't save the contents
> of this buffer anywhere, the export/import doesn't work as expected
> it seems.
> 
> Actually I am now wondering why the driver allocates this sequential
> buffer at all, DMA should be possible to use over the sgs just fine,
> at least some other crypto drivers are doing this.

Indeed this is totally broken.  No hash driver should be holding
data without actually hashing it, unless of course if there is less
than a block of data.

So either fix the driver to hash the data as they come in, or
make it use a software fallback for update.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
