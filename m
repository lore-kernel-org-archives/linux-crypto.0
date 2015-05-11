From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Mon, 11 May 2015 17:42:12 +0800
Message-ID: <20150511094212.GA4224@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <43350012.VMEhAijB9c@tauon>
 <20150501073036.GA1999@gondor.apana.org.au>
 <1472762.oGxlyZfssS@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38891 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbbEKJmQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:42:16 -0400
Content-Disposition: inline
In-Reply-To: <1472762.oGxlyZfssS@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 01, 2015 at 03:21:19PM +0200, Stephan Mueller wrote:
>
> My idea would be to use keywrap in step 3.

How is dm-crypt going to cope with the increase in ciphertext size?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
