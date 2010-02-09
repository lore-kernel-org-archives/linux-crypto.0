From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 9 Feb 2010 18:41:46 +1100
Message-ID: <20100209074146.GA17681@gondor.apana.org.au>
References: <4B69B07D.9010909@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39669 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752934Ab0BIHls (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 02:41:48 -0500
Content-Disposition: inline
In-Reply-To: <4B69B07D.9010909@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
> 
> One interesting issue
> 
> Many clients in the kernel set CRYPTO_TFM_REQ_MAY_SLEEP to desc.flags.
> It is used by crypto_yeld().

That flag is really only meaningful for synchronous implementations.

For hardware crypto that is asynchronous, you can simply ignore it
in most cases (exceptions include invoking a syncrhonous backup, for
example).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
