From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx: Hardware crypto support for IXP4xx CPUs
Date: Wed, 25 Jun 2008 14:43:15 +0800
Message-ID: <20080625064315.GA17520@gondor.apana.org.au>
References: <20080615123719.GG21180@mail3.prorata.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Christian Hohnstaedt <christian@hohnstaedt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38254 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbYFYGnU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2008 02:43:20 -0400
Content-Disposition: inline
In-Reply-To: <20080615123719.GG21180@mail3.prorata.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 15, 2008 at 12:37:19PM +0000, Christian Hohnstaedt wrote:
> Add support for the hardware crypto engine provided by the NPE C
> of the Intel IXP4xx networking processor series.
> 
> Supported ciphers: des, des3, aes
> and a combination of them with md5 and sha1 hmac
> 
> Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>

Applied to crpytodev-2.6.  Thanks Christian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
