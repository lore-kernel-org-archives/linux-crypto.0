Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBFDC77B60
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 09:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbjDZJ1a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Apr 2023 05:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240136AbjDZJ1C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2023 05:27:02 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9585B3598
        for <linux-crypto@vger.kernel.org>; Wed, 26 Apr 2023 02:26:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1prbQ8-002Wa4-TT; Wed, 26 Apr 2023 17:26:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Apr 2023 17:26:42 +0800
Date:   Wed, 26 Apr 2023 17:26:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: jitter - change module_init(jent_mod_init)
 to subsys_initcall(jent_mod_init)
Message-ID: <ZEjuUg9GQGB+4WO/@gondor.apana.org.au>
References: <20230425125709.39470-1-cuigaosheng1@huawei.com>
 <ZEjkmOPvk7Iz213G@gondor.apana.org.au>
 <d3198a93-3811-69d3-9a19-602bf8b849aa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3198a93-3811-69d3-9a19-602bf8b849aa@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 26, 2023 at 05:18:11PM +0800, cuigaosheng wrote:
> Thanks for taking time to review this patch.
> 
> We have not used subsystem initialisation ordering to guarantee the
> order of registration since commit adad556efcdd ("crypto: api - Fix
> built-in testing dependency failures"),but this patch is not a bugfix,
> it's not merged into the earlier stable branch.

You're going about this backwards.  We don't apply patches to
the mainline kernel to fix problems that only exist in an older
version.

If you have a problem with an older kernel then you should fix
it there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
