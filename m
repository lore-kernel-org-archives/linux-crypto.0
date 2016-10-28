From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: acomp: export all scomp interfaces
Date: Fri, 28 Oct 2016 12:36:35 +0200
Message-ID: <1985399.JeVYi9VsdT@wuerfel>
References: <20161027141029.2566709-1-arnd@arndb.de> <20161027210328.GA12705@SILVIXA00369791-F22-1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:59450 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbcJ1Kg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 06:36:57 -0400
In-Reply-To: <20161027210328.GA12705@SILVIXA00369791-F22-1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, October 27, 2016 10:03:29 PM CEST Giovanni Cabiddu wrote:
> Hi Arnd,
> 
> On Thu, Oct 27, 2016 at 04:09:49PM +0200, Arnd Bergmann wrote:
> > The newly added scomp/acomp interface has a couple of functions
> > that should be exported to allow linking the two drivers
> > as loadable modules:
> >
> > ERROR: "crypto_acomp_scomp_free_ctx" [crypto/acompress.ko] undefined!
> > ERROR: "crypto_acomp_scomp_alloc_ctx" [crypto/acompress.ko] undefined!
> > ERROR: "crypto_init_scomp_ops_async" [crypto/acompress.ko] undefined!
> These functions were not exported on purpose. They should not be called
> by other modules.
> 
> > Alternatively, both of them could be combined into one loadable module.
> I think this is the correct approach. Here is a patch with an
> alternative fix: https://patchwork.kernel.org/patch/9396503/

Yes, your patch is exactly what I had in mind as the alternative,
looks good to me.

	Arnd
