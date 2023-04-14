Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0833BC77B6E
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Apr 2023 16:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDNQm1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Apr 2023 12:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjDNQmZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2023 12:42:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61EDA262;
        Fri, 14 Apr 2023 09:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xeWMlPq0xRVk5owVixj8aWUv5F/+OmFxsmotcc+TkSI=; b=ZL/nIaHU6GnKzHLQG5/V3u6NBS
        U8Bz5xqhILbRTpVJQw3Tg2ZIZ1KtQcOoCXFixeqBpQJe245s4enN7D8+uJdBUaJHaw/2HA8ZOfYZ4
        bTGEqnae1kqBgpx0UkuIqho3/oSm03IfgxxikiiOg9o/gbT86vw2O9XfMfP41lbrW8exNcg07Igio
        Wo3rLb6kM+8GK464wcQOauW0mK+AmBNhoeybDJq6HznJY1dy6rZP58+Xpkz/auGX+OKn6pInLBUAx
        veWM5wBCORZtgLH+2M9qgswkEV9xZiiJN7yv5Ds+VVRX15O7t1Dt4t+BKQZeS1h57mzFnKH8ue8ok
        iB0JjPGA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pnMVD-00A8X0-2k;
        Fri, 14 Apr 2023 16:42:23 +0000
Date:   Fri, 14 Apr 2023 09:42:23 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Russ Weight <russell.h.weight@intel.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Tianfei zhang <tianfei.zhang@intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Amadeusz =?utf-8?B?U8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware_loader: rework crypto dependencies
Message-ID: <ZDmCbxt7MTJecXJ8@bombadil.infradead.org>
References: <20230414080329.76176-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414080329.76176-1-arnd@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
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

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
