From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/10] crypto: omap-aes - Updates & New Functionality
Date: Sun, 20 Jan 2013 11:12:51 +1100
Message-ID: <20130120001251.GB26742@gondor.apana.org.au>
References: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	russ.dill@gmail.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 08, 2013 at 11:57:37AM -0700, Mark A. Greer wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> Changes from v1:
>  - Addressed comments by Russ Dill by defining omap_aes_of_match[] to
>    contain an empty entry (end of list indicator) and defining 
>    omap_aes_get_res_of() instead of incorrectly defining
>    omap_aes_get_res_dev() when CONFIG_OF is not defined.
> 
> This patch series does several things to the omap-aes crypto
> driver including:
>  - converting to use pm_runtime
>  - adding suspend/resume support
>  - converting to use dmaengine API
>  - adding device tree support
>  - adding OMAP4/AM33XX support
>  - adding CTR support
>  - some misc. cleanups
> 
> The patches are based on the current k.o. 54e37b8 (Merge tag
> 'vfio-for-v3.8-v2' of git://github.com/awilliam/linux-vfio), plus:
>  - the ARM hwmod, etc patches from 
>    "[PATCH 00/15] OMAP SHAM & AES Crypto Updates"
>    (http://marc.info/?l=linux-omap&m=135610732120447&w=2)
>  - the EDMA dmaengine patches submitted by Matt Porter
>    "[RFC PATCH v3 00/16] DMA Engine support for AM33XX]"
>    (https://lkml.org/lkml/2012/10/18/256)
>  - some misc patches required by the EDMA patches
>  - a hack to fix the compilation error that the current k.o. kernel has
> 
> A working examle is here:
> 
> 	git@github.com:mgreeraz/linux-mag.git submitted/crypto/aes
> 
> This patch series does several things to the omap-aes crypto
> driver including:
>  - converting to use pm_runtime
>  - adding suspend/resume support
>  - converting to use dmaengine API
>  - adding device tree support
>  - adding OMAP4/AM33XX support
>  - adding CTR support
>  - some misc. cleanups
> 
> The patches are based on the current k.o. kernel, plus:
>  - the ARM hwmod, etc patches from 
>    "[PATCH 00/15] OMAP SHAM & AES Crypto Updates"
>    (http://marc.info/?l=linux-omap&m=135610732120447&w=2)
>  - the EDMA dmaengine patches submitted by Matt Porter
>    "[RFC PATCH v3 00/16] DMA Engine support for AM33XX]"
>    (https://lkml.org/lkml/2012/10/18/256)
>  - some misc patches required by the EDMA patches
>  - a hack to fix the compilation error that the current k.o. kernel has

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
