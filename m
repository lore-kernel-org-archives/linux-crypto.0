From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Enable VIA PadLock on x86_64
Date: Mon, 11 May 2009 00:29:01 +0800
Message-ID: <20090510162901.GA9026@gondor.apana.org.au>
References: <20090510160341.GH12152@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56093 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751965AbZEJQ3G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 12:29:06 -0400
Content-Disposition: inline
In-Reply-To: <20090510160341.GH12152@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2009 at 12:03:41AM +0800, Harald Welte wrote:
> [CRYPTO] Support VIA PadLock hardware crypto on x86-64
> 
> The VIA Nano CPU supports x86_64, so it is now wrong to assume PadLock 
> would only exist on X86_32 builds.
> 
> This patch just alters Kconfig to reflect this fact, as well as a trivial
> one-line fix to an assembly statement in padlock-aes.c
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>

A similar patch is already in cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
