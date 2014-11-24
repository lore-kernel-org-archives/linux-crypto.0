From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: prefix module autoloading with "crypto-"
Date: Mon, 24 Nov 2014 22:47:35 +0800
Message-ID: <20141124144734.GA31900@gondor.apana.org.au>
References: <20141121010553.GA5959@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59320 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKXOrk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2014 09:47:40 -0500
Content-Disposition: inline
In-Reply-To: <20141121010553.GA5959@www.outflux.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 20, 2014 at 05:05:53PM -0800, Kees Cook wrote:
> This prefixes all crypto module loading with "crypto-" so we never run
> the risk of exposing module auto-loading to userspace via a crypto API,
> as demonstrated by Mathias Krause:
> 
> https://lkml.org/lkml/2013/3/4/70
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied.

For the template issue please create a patch on top of this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
