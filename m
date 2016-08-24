From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2 linux-next] hwrng: update Freescale i.MX RNGA Random
 Number Generator
Date: Wed, 24 Aug 2016 21:13:06 +0800
Message-ID: <20160824131306.GA3850@gondor.apana.org.au>
References: <1471376985-7791-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45933 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbcHXNN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 09:13:26 -0400
Content-Disposition: inline
In-Reply-To: <1471376985-7791-1-git-send-email-fabf@skynet.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 16, 2016 at 09:49:45PM +0200, Fabian Frederick wrote:
> We can directly depend on SOC_IMX31 since commit c9ee94965dce
> ("ARM: imx: deconstruct mxc_rnga initialization")
> 
> Since that commit, CONFIG_HW_RANDOM_MXC_RNGA could not be switched on
> with unknown symbol ARCH_HAS_RNGA and mxc-rnga.o can't be generated with
> ARCH=arm make M=drivers/char/hw_random
> Previously, HW_RANDOM_MXC_RNGA required ARCH_HAS_RNGA
> which was based on IMX_HAVE_PLATFORM_MXC_RNGA  && ARCH_MXC.
> IMX_HAVE_PLATFORM_MXC_RNGA  was based on SOC_IMX31.
> 
> Fixes: c9ee94965dce ("ARM: imx: deconstruct mxc_rnga initialization")
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> -Cc to linux-crypto (suggested by Herbert Xu)
> -Adding "Fixes:" (suggested by Arnd Bergmann)
> -This patch appeared in 4.8-rc1 (not in stable yet)
> -Improving patch description

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
