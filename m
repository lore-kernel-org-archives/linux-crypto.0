From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Thu, 15 May 2008 00:01:17 +0800
Message-ID: <20080514160117.GA24905@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604720952@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	Shasi Pulijala <spulijala@amcc.com>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43019 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbYENQBX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 12:01:23 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604720952@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2008 at 08:04:22AM -0700, Loc Ho wrote:
> Hi,
> 
> Yes... It is intended not to patch OpenSSL twice. Besides the interface
> API, the internal does NOT resemble OCF in anyway.

But it's exactly the interface that would tie us down to OCF.
For instance, we use strings to locate algorithms rather than
hard-coded integer IDs.  Compatibility with an interface that
was never part of the Linux kernel is simply not an issue.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
