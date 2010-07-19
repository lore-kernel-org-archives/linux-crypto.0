From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: talitos - fix bug in sg_copy_end_to_buffer
Date: Mon, 19 Jul 2010 14:12:01 +0800
Message-ID: <20100719061201.GA19903@gondor.apana.org.au>
References: <1279066287-11349-1-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40483 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0GSGME (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jul 2010 02:12:04 -0400
Content-Disposition: inline
In-Reply-To: <1279066287-11349-1-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 14, 2010 at 12:11:27AM +0000, Lee Nipper wrote:
> In function sg_copy_end_to_buffer, too much data
> is copied when a segment in the scatterlist
> has .length greater than the requested copy length.
> 
> This patch adds the limit checks to fix this bug of over copying,
> which affected only the ahash algorithms.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Applied to crypto-2.6.  Thanks Lee!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
