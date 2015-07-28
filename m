From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] jent: use safe format string parameters
Date: Tue, 28 Jul 2015 15:07:13 +0800
Message-ID: <20150728070713.GF25287@gondor.apana.org.au>
References: <20150724224127.GA29924@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40345 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbG1HHX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2015 03:07:23 -0400
Content-Disposition: inline
In-Reply-To: <20150724224127.GA29924@www.outflux.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 24, 2015 at 03:41:27PM -0700, Kees Cook wrote:
> Since the API for jent_panic() does not include format string parameters,
> adjust the call to panic() to use a literal string to avoid any future
> callers from leaking format strings into the panic message.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
