From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos: Init zero_entry more compatibly
Date: Sun, 2 Aug 2015 09:22:33 +0800
Message-ID: <20150802012233.GA10055@gondor.apana.org.au>
References: <767312390.183043.1438296525267.JavaMail.zimbra@xes-inc.com>
 <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Aaron Sierra <asierra@xes-inc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38308 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbHBCAb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Aug 2015 22:00:31 -0400
Content-Disposition: inline
In-Reply-To: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 31, 2015 at 12:27:41PM -0500, Aaron Sierra wrote:
>
> -static const struct talitos_ptr zero_entry = {
> -	.len = 0,
> -	.j_extent = 0,
> -	.eptr = 0,
> -	.ptr = 0
> -};
> +static const struct talitos_ptr zero_entry = {{{ 0 }}};

Please get rid of the initialiser completely.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
