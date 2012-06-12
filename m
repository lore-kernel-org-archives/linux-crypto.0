From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RFC: support for MV_CESA with TDMA
Date: Tue, 12 Jun 2012 18:04:37 +0800
Message-ID: <20120612100437.GD14078@gondor.apana.org.au>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:47383 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853Ab2FLKEl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 06:04:41 -0400
Content-Disposition: inline
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 25, 2012 at 06:08:26PM +0200, Phil Sutter wrote:
>
> The point for this being RFC is backwards-compatibility: earlier
> hardware (Orion) ships a (slightly) different DMA engine (IDMA) along
> with the same crypto engine, so in fact mv_cesa.c is in use on these
> platforms, too. But since I don't possess hardware of this kind, I am
> not able to make this code IDMA-compatible. Also, due to the quite
> massive reorganisation of code flow, I don't really see how to make TDMA
> support optional in mv_cesa.c.

So does this break existing functionality or not?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
