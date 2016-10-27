From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: acomp: export all scomp interfaces
Date: Thu, 27 Oct 2016 22:03:29 +0100
Message-ID: <20161027210328.GA12705@SILVIXA00369791-F22-1>
References: <20161027141029.2566709-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161027141029.2566709-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Arnd,

On Thu, Oct 27, 2016 at 04:09:49PM +0200, Arnd Bergmann wrote:
> The newly added scomp/acomp interface has a couple of functions
> that should be exported to allow linking the two drivers
> as loadable modules:
>
> ERROR: "crypto_acomp_scomp_free_ctx" [crypto/acompress.ko] undefined!
> ERROR: "crypto_acomp_scomp_alloc_ctx" [crypto/acompress.ko] undefined!
> ERROR: "crypto_init_scomp_ops_async" [crypto/acompress.ko] undefined!
These functions were not exported on purpose. They should not be called
by other modules.

> Alternatively, both of them could be combined into one loadable module.
I think this is the correct approach. Here is a patch with an
alternative fix: https://patchwork.kernel.org/patch/9396503/

Thanks,

--
Giovanni
