From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/7] crypto: add blkcipher implementation of ARC4
Date: Mon, 5 Apr 2010 16:42:09 +0800
Message-ID: <20100405084209.GA16788@gondor.apana.org.au>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35310 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752240Ab0DEJZg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Apr 2010 05:25:36 -0400
Content-Disposition: inline
In-Reply-To: <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 03, 2010 at 09:49:24AM +0200, Sebastian Andrzej Siewior wrote:
>
> +#include <crypto/arc4.h>

This file doesn't seem to exist in the kernel tree or your patch-set?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
