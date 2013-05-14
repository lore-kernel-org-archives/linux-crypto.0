From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: remove dependency on EXPERIMENTAL
Date: Tue, 14 May 2013 10:38:27 +0800
Message-ID: <20130514023827.GG19306@gondor.apana.org.au>
References: <1368359839.1350.10.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33753 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756527Ab3ENCic (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 22:38:32 -0400
Content-Disposition: inline
In-Reply-To: <1368359839.1350.10.camel@x61.thuisdomein>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 12, 2013 at 01:57:19PM +0200, Paul Bolle wrote:
> The Kconfig symbol EXPERIMENTAL was removed in v3.9. So this dependency
> makes it impossible to set CRYPTO_DEV_SAHARA. It's unlikely that this is
> what is intended, so let's remove this dependency.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
