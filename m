From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 01/27] crypto: omap-sham: use runtime_pm autosuspend
 for clock handling
Date: Fri, 24 Jun 2016 21:30:36 +0800
Message-ID: <20160624133036.GA21111@gondor.apana.org.au>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-2-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	tony@atomide.com, davem@davemloft.net, lokeshvutla@ti.com,
	linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48319 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbcFXNa5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 09:30:57 -0400
Content-Disposition: inline
In-Reply-To: <1466601840-18486-2-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 04:23:34PM +0300, Tero Kristo wrote:
> Calling runtime PM API for every block causes serious performance hit to
> crypto operations that are done on a long buffer. As crypto is performed
> on a page boundary, encrypting large buffers can cause a series of crypto
> operations divided by page. The runtime PM API is also called those many
> times.
> 
> Convert the driver to use runtime_pm autosuspend instead, with a default
> timeout value of 1 second. This results in upto ~50% speedup.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>

Patches 1-4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
