From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: talitos: Remove zero_entry static initializer
Date: Tue, 4 Aug 2015 07:31:20 +0800
Message-ID: <20150803233120.GA26617@gondor.apana.org.au>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
 <926902712.309275.1438618477197.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Aaron Sierra <asierra@xes-inc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47573 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbbHCXba (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 19:31:30 -0400
Content-Disposition: inline
In-Reply-To: <926902712.309275.1438618477197.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 03, 2015 at 11:14:37AM -0500, Aaron Sierra wrote:
> Compiling the talitos driver with my GCC 4.3.1 e500v2 cross-compiler
> resulted in a failed build due to the anonymous union/structures
> introduced in this commit:
> 
>   crypto: talitos - enhanced talitos_desc struct for SEC1
> 
> The build error was:
> 
>   drivers/crypto/talitos.h:56: error: unknown field 'len' specified in initializer
>   drivers/crypto/talitos.h:56: warning: missing braces around initializer
>   drivers/crypto/talitos.h:56: warning: (near initialization for 'zero_entry.<anonymous>')
>   drivers/crypto/talitos.h:57: error: unknown field 'j_extent' specified in initializer
>   drivers/crypto/talitos.h:58: error: unknown field 'eptr' specified in initializer
>   drivers/crypto/talitos.h:58: warning: excess elements in struct initializer
>   drivers/crypto/talitos.h:58: warning: (near initialization for 'zero_entry')
>   make[2]: *** [drivers/crypto/talitos.o] Error 1
>   make[1]: *** [drivers/crypto] Error 2
>   make: *** [drivers] Error 2
> 
> This patch eliminates the errors by moving the static constant
> zero_entry to the talitos_private structure. As a member of that
> structure, zero_entry gets initialized for free (and compatibly) by
> the kzalloc() during device probe.

Why? A static variable is always zeroed.  Please just get rid
of the initialisation and it will work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
