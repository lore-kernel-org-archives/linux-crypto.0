From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: twofish: rename twofish to twofish_generic and
	add an alias
Date: Wed, 26 May 2010 10:42:52 +1000
Message-ID: <20100526004252.GD20073@gondor.apana.org.au>
References: <4BFA3D24.4020700@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Joachim Fritschi <jfritschi@freenet.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:52030 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750800Ab0EZAmz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:42:55 -0400
Content-Disposition: inline
In-Reply-To: <4BFA3D24.4020700@freenet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 24, 2010 at 10:47:32AM +0200, Joachim Fritschi wrote:
> This fixes the broken autoloading of the corresponding twofish
> assembler ciphers on x86 and x86_64 if they are available. The module
> name of the generic implementation was in conflict with the alias in the  
> assembler modules.
> The generic twofish c implementation is renamed to twofish_generic
> according to the other algorithms with assembler implementations and an  
> module alias is added for 'twofish'.
> You can now load 'twofish' giving you the best implementation by
> priority, 'twofish-generic' to get the c implementation or 'twofish-asm'  
> to get the assembler version of cipher.
>
> Signed-off-by: Joachim Fritschi jfritschi@freenet.de

Sorry, patch doesn't apply:

1 out of 1 hunk FAILED -- saving rejects to file crypto/Makefile.rej
patch: **** malformed patch at line 55: * have put this under the GNU General Public License.

BTW, when you regenerate your patch please use the -M option
to git diff.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
