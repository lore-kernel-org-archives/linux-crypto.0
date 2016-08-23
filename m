From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 linux-next] hwrng: update Freescale i.MX RNGA Random Number Generator
Date: Tue, 23 Aug 2016 14:27:36 +0200
Message-ID: <5512149.8JX5d16kGe@wuerfel>
References: <1471376985-7791-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58688 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753386AbcHWM2m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Aug 2016 08:28:42 -0400
In-Reply-To: <1471376985-7791-1-git-send-email-fabf@skynet.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, August 16, 2016 9:49:45 PM CEST Fabian Frederick wrote:
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
> 

Thanks for fixing my mistake!

Acked-by: Arnd Bergmann <arnd@arndb.de>
