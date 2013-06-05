From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: picoxcell - replace strict_strtoul() with
 kstrtoul()
Date: Wed, 5 Jun 2013 16:54:24 +0800
Message-ID: <20130605085424.GF12202@gondor.apana.org.au>
References: <000101ce5e96$774ca4a0$65e5ede0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Jamie Iles' <jamie@jamieiles.com>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53246 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753177Ab3FEIy0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jun 2013 04:54:26 -0400
Content-Disposition: inline
In-Reply-To: <000101ce5e96$774ca4a0$65e5ede0$@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 01, 2013 at 04:05:57PM +0900, Jingoo Han wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
