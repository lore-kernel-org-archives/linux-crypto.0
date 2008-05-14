From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Wed, 14 May 2008 19:03:11 +0800
Message-ID: <20080514110311.GA22116@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loc Ho <lho@amcc.com>, Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59598 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753894AbYENLD0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 07:03:26 -0400
Content-Disposition: inline
In-Reply-To: <20080514103224.GA10416@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2008 at 12:32:24PM +0200, Sebastian Siewior wrote:
>
> >This should add support for OpenSSL. Please note that user of this patch
> >musts patch OpenSSL. The OpenSSL patch can be found in OCF-Linux as this
> >interface uses the same I/O control interface.
> So this interface must stay as it in order not to patch openssl twice?

I don't think compatibility with OCF is necessary at all.  We
should create an interface that is suitable for Linux first of
all rather than concentrating on OCF.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
