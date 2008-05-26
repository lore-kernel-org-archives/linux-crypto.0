From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] [CRYPTO] ripemd: Fix endian issues
Date: Mon, 26 May 2008 20:55:00 +1000
Message-ID: <20080526105500.GA14743@gondor.apana.org.au>
References: <1211312992-6439-1-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sebastian@breakpoint.cc, linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from goliath.apana.org.au ([203.14.152.44]:52753 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756383AbYE0QYS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2008 12:24:18 -0400
Content-Disposition: inline
In-Reply-To: <1211312992-6439-1-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 20, 2008 at 09:49:49PM +0200, Adrian-Ken Rueegsegger wrote:
> These patches fix the endian issues reported by Sebastian Siewior for
> the three remaining RIPEMD modules rmd160, rmd256 and rmd320.
> 
>  crypto/rmd160.c |   37 +++++++++----------------------------
>  crypto/rmd256.c |   37 +++++++++----------------------------
>  crypto/rmd320.c |   37 +++++++++----------------------------
>  3 files changed, 27 insertions(+), 84 deletions(-)

All applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
