From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] crypto: compress - Add pcomp interface
Date: Thu, 19 Feb 2009 12:14:24 +0800
Message-ID: <20090219041424.GA1137@gondor.apana.org.au>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42666 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237AbZBSEO0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 23:14:26 -0500
Content-Disposition: inline
In-Reply-To: <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 18, 2009 at 04:53:18PM +0100, Geert Uytterhoeven wrote:
>
> +	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params);

I think the lack of a length field is the only thing preventing me
from applying this :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
