From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/9] crypto: omap-sham - Updates & New Functionality
Date: Sat, 5 Jan 2013 21:44:22 +1100
Message-ID: <20130105104421.GC28670@gondor.apana.org.au>
References: <1356109449-11624-1-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1356109449-11624-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 21, 2012 at 10:04:00AM -0700, Mark A. Greer wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> [This supersedes the omap-sham driver patches sent in the
>  "crypto: omap-sham updates" series sent a few weeks ago.]
> 
> This patch series does several things to the omap-sham crypto
> driver including:
>  - converting to use pm_runtime
>  - adding suspend/resume support
>  - converting to use dmaengine API
>  - adding device tree support
>  - adding OMAP4/AM33XX support
>  - adding SHA224 and SHA256 support
>  - some minor cleanups
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

All applied.  Thaks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
