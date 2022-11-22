Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69638C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiKVKPL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiKVKPI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:15:08 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E8A54B17
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:15:04 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxQIq-00H4U2-Fe; Tue, 22 Nov 2022 18:14:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 18:14:56 +0800
Date:   Tue, 22 Nov 2022 18:14:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] crypto: ccree - Make cc_debugfs_global_fini() available
 for module init function
Message-ID: <Y3yhIKPbwK2UZLxV@gondor.apana.org.au>
References: <20221121172236.114438-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221121172236.114438-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 21, 2022 at 06:22:36PM +0100, Uwe Kleine-König wrote:
> ccree_init() calls cc_debugfs_global_fini(), the former is an init
> function and the latter an exit function though.
> 
> A modular build emits:
> 
> 	WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in reference: init_module (section: .init.text) -> cc_debugfs_global_fini (section: .exit.text)
> 
> (with CONFIG_DEBUG_SECTION_MISMATCH=y).
> 
> Fixes: 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/crypto/ccree/cc_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
