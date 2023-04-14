Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CEDC77B70
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Apr 2023 08:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDNIyh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDNIyg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2023 04:54:36 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A079E6189;
        Fri, 14 Apr 2023 01:54:34 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pnFBr-00FoD9-C5; Fri, 14 Apr 2023 16:53:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Apr 2023 16:53:55 +0800
Date:   Fri, 14 Apr 2023 16:53:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Tianfei zhang <tianfei.zhang@intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Amadeusz =?utf-8?B?U8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware_loader: rework crypto dependencies
Message-ID: <ZDkUowCa9ft1x6FH@gondor.apana.org.au>
References: <20230414080329.76176-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414080329.76176-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 14, 2023 at 10:03:07AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The crypto dependencies for the firmwware loader are incomplete,
> in particular a built-in FW_LOADER fails to link against a modular
> crypto hash driver:
> 
> ld.lld: error: undefined symbol: crypto_alloc_shash
> ld.lld: error: undefined symbol: crypto_shash_digest
> ld.lld: error: undefined symbol: crypto_destroy_tfm
> >>> referenced by main.c
> >>>               drivers/base/firmware_loader/main.o:(fw_log_firmware_info) in archive vmlinux.a
> 
> Rework this to use the usual 'select' from the driver module,
> to respect the built-in vs module dependencies, and add a
> more verbose crypto dependency to the debug option to prevent
> configurations that lead to a link failure.
> 
> Fixes: 02fe26f25325 ("firmware_loader: Add debug message with checksum for FW file")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Tested on a few hundred randconfig builds
> ---
>  drivers/base/firmware_loader/Kconfig | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
