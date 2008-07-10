From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - add support for sha256 and md5 variants
Date: Thu, 10 Jul 2008 18:29:36 +0800
Message-ID: <20080710102936.GA24431@gondor.apana.org.au>
References: <1215627543.18037.3.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Lee Nipper <lee.nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60066 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752068AbYGJK3k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 06:29:40 -0400
Content-Disposition: inline
In-Reply-To: <1215627543.18037.3.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 09, 2008 at 06:19:03PM +0000, Lee Nipper wrote:
> This patch adds support for:
> authenc(hmac(sha256),cbc(aes)),
> authenc(hmac(sha256),cbc(des3_ede)),
> authenc(hmac(md5),cbc(aes)),
> authenc(hmac(md5),cbc(des3_ede)).
> Some constant usage was changed to use aes, des, and sha include files.
> 
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
