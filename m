From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: omap-sham: Add support for SHA384/SHA512 for
 OMAP5/AM43xx Soc's
Date: Thu, 1 Aug 2013 11:47:41 +1000
Message-ID: <20130801014741.GE24286@gondor.apana.org.au>
References: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
	rnayak@ti.com, nsekhar@ti.com, joelf@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48769 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975Ab3HABrq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Jul 2013 21:47:46 -0400
Content-Disposition: inline
In-Reply-To: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 26, 2013 at 12:29:13PM +0530, Lokesh Vutla wrote:
> This patch series adds support for SHA348 and SHA512 in addition to MD5,
> SHA1, SHA224 SHA256 that the omap sha module supports. Also adding the pdata
> for OMAP5 and AM43xx Soc's.
> And using devm_* calls to make cleanup paths simpler.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
