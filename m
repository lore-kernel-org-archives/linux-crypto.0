From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/11] crypto: caam: Error reporting fixes
Date: Thu, 8 May 2014 22:01:06 +0800
Message-ID: <20140508140106.GA13769@gondor.apana.org.au>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Horia Geanta <horia.geanta@freescale.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60133 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaEHOBK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2014 10:01:10 -0400
Content-Disposition: inline
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 24, 2014 at 08:05:11PM +0200, Marek Vasut wrote:
> First stab at reworking the error.c thing in Freescale CAAM.
> This patchset cleans it up so it's not doing any too insane
> string messing anymore.
> 
> NOTE: Can someone please test this on real hardware? I have
>       none at hand, so THIS IS COMPILE-TESTED ONLY!
> 
> Marek Vasut (11):

All applied.  Thanks Marek.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
