From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: sha512_ssse3 - add sha384 support
Date: Tue, 28 May 2013 17:53:01 +0800
Message-ID: <20130528095301.GG24414@gondor.apana.org.au>
References: <20130521141044.16352.75962.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58881 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932Ab3E1JxE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 05:53:04 -0400
Content-Disposition: inline
In-Reply-To: <20130521141044.16352.75962.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 21, 2013 at 05:10:44PM +0300, Jussi Kivilinna wrote:
> Add sha384 implementation to sha512_ssse3 module.
> 
> This also fixes sha512_ssse3 module autoloading issue when 'sha384' is used
> before 'sha512'. Previously in such case, just sha512_generic was loaded and
> not sha512_ssse3 (since it did not provide sha384). Now if 'sha512' was used
> after 'sha384' usage, sha512_ssse3 would remain unloaded. For example, this
> happens with tcrypt testing module since it tests 'sha384' before 'sha512'.
> 
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
