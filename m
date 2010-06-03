From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND][PATCH] crypto: twofish: Rename twofish to
	twofish_generic and add an alias
Date: Thu, 3 Jun 2010 21:03:47 +1000
Message-ID: <20100603110347.GD31063@gondor.apana.org.au>
References: <4BFD875D.2090709@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Joachim Fritschi <jfritschi@freenet.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:38870 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab0FCLDz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jun 2010 07:03:55 -0400
Content-Disposition: inline
In-Reply-To: <4BFD875D.2090709@freenet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 26, 2010 at 10:41:01PM +0200, Joachim Fritschi wrote:
> This fixes the broken autoloading of the corresponding twofish assembler
> ciphers on x86 and x86_64 if they are available. The module name of the
> generic implementation was in conflict with the alias in the assembler
> modules. The generic twofish c implementation is renamed to
> twofish_generic according to the other algorithms with assembler
> implementations and an module alias is added for 'twofish'. You can now
> load 'twofish' giving you the best implementation by priority,
> 'twofish-generic' to get the c implementation or 'twofish-asm' to get
> the assembler version of cipher.
>
> Signed-off-by: Joachim Fritschi jfritschi@freenet.de

I had to fix up your patch by hand becaus it was white space
damaged.  Also you should put angle brackets around your email
address on the sign-off line.

Anyway I've applied your patch.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
