From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: powerpc - move files to fix build error
Date: Mon, 9 Mar 2015 21:08:26 +1100
Message-ID: <20150309100826.GE4452@gondor.apana.org.au>
References: <20150306184621.c2d277457bb1b3112b1d3a64@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Markus Stockhausen <stockhausen@collogia.de>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49808 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbCIKJC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 06:09:02 -0400
Content-Disposition: inline
In-Reply-To: <20150306184621.c2d277457bb1b3112b1d3a64@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 06, 2015 at 06:46:21PM -0600, Kim Phillips wrote:
> The current cryptodev-2.6 tree commits:
> 
> d9850fc529ef ("crypto: powerpc/sha1 - kernel config")
> 50ba29aaa7b0 ("crypto: powerpc/sha1 - glue")
> 
> failed to properly place files under arch/powerpc/crypto, which
> leads to build errors:
> 
> make[1]: *** No rule to make target 'arch/powerpc/crypto/sha1-spe-asm.o', needed by 'arch/powerpc/crypto/sha1-ppc-spe.o'.  Stop.
> make[1]: *** No rule to make target 'arch/powerpc/crypto/sha1_spe_glue.o', needed by 'arch/powerpc/crypto/sha1-ppc-spe.o'.  Stop.
> Makefile:947: recipe for target 'arch/powerpc/crypto' failed
> 
> Move the two sha1 spe files under crypto/, and whilst there, rename
> other powerpc crypto files with underscores to use dashes for
> consistency.
> 
> Cc: Markus Stockhausen <stockhausen@collogia.de>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
