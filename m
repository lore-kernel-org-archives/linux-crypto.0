From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium: fix Kconfig dependencies
Date: Wed, 15 Feb 2017 13:35:27 +0800
Message-ID: <20170215053527.GJ14043@gondor.apana.org.au>
References: <20170214170739.2687818-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Cherian <george.cherian@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55187 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750814AbdBOFfo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:35:44 -0500
Content-Disposition: inline
In-Reply-To: <20170214170739.2687818-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2017 at 06:07:31PM +0100, Arnd Bergmann wrote:
> The driver fails to build if MSI support is disabled:
> 
> In file included from /git/arm-soc/drivers/crypto/cavium/cpt/cptpf_main.c:18:0:
> drivers/crypto/cavium/cpt/cptpf.h:57:20: error: array type has incomplete element type 'struct msix_entry'
>   struct msix_entry msix_entries[CPT_PF_MSIX_VECTORS];
>                     ^~~~~~~~~~~~
> drivers/crypto/cavium/cpt/cptpf_main.c: In function 'cpt_enable_msix':
> drivers/crypto/cavium/cpt/cptpf_main.c:344:8: error: implicit declaration of function 'pci_enable_msix';did you mean 'cpt_enable_msix'? [-Werror=implicit-function-declaration]
> 
> On the other hand, it doesn't seem to have any build dependency on ARCH_THUNDER,
> so let's allow compile-testing to catch this kind of problem more easily.
> The 64-bit dependency is needed for the use of readq/writeq.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
