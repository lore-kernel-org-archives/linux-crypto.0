From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx - tweak Makefile dependencies
Date: Wed, 27 May 2015 17:50:43 +0800
Message-ID: <20150527095043.GA28255@gondor.apana.org.au>
References: <1432529116-21279-1-git-send-email-cyrilbur@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Cyril Bur <cyrilbur@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36112 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbE0Jus (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:50:48 -0400
Content-Disposition: inline
In-Reply-To: <1432529116-21279-1-git-send-email-cyrilbur@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 25, 2015 at 02:45:16PM +1000, Cyril Bur wrote:
> Selecting CRYPTO_DEV_NX causes a conditional include of nx/Kconfig but
> options within nx/Kconfig do not depend on it. The included options should
> depend on CRYPTO_DEV_NX since currently CRYPTO_DEV_NX cannot be built for
> little endian. While Kconfig appears to understand this convoluted
> dependency situation, it isn't explicitly stated.
> 
> This patch addresses the missing dependencies for CRYPTO_DEV_NX_ENCRYPT and
> CRYPTO_DEV_NX_COMPRESS which should depend on CRYPTO_DEV_NX. It also makes
> more sense to put all three options into the nx/Kconfig file and have the
> file included unconditionally.
> 
> CC: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> CC: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> CC: linux-crypto@vger.kernel.org
> CC: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Cyril Bur <cyrilbur@gmail.com>

Your patch doesn't apply against the cryptodev tree.  Please rebase
it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
