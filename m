From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Mon, 2 Jun 2008 15:49:35 +1000
Message-ID: <20080602054935.GA20651@gondor.apana.org.au>
References: <1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch> <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50126 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751629AbYFBFti (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 01:49:38 -0400
Content-Disposition: inline
In-Reply-To: <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 01, 2008 at 07:16:18PM +0200, Adrian-Ken Rueegsegger wrote:
> This patch fixes the usage of RIPEMD-160 in xfrm_algo which in turn
> allows hmac(rmd160) to be used as authentication mechanism in IPsec
> ESP and AH (see RFC 2857).
> 
> Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>

Please submit this patch to davem@davemloft.net and cc
netdev@vger.kernel.org.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
