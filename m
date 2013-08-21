From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sham: Misc updates for driver
Date: Wed, 21 Aug 2013 21:51:30 +1000
Message-ID: <20130821115130.GH23287@gondor.apana.org.au>
References: <1377010955-5605-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	rnayak@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48905 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523Ab3HULvc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 07:51:32 -0400
Content-Disposition: inline
In-Reply-To: <1377010955-5605-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 20, 2013 at 08:32:33PM +0530, Lokesh Vutla wrote:
> This patch series updates the following for the driver:
> -> Enable polling mode if DMA fails.
> -> Correct the DMA burst size.
> 
> Lokesh Vutla (2):
>   crypto: omap-sham: Enable Polling mode if DMA fails
>   crypto: omap-sham: correct dma burst size

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
