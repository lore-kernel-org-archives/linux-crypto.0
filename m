Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB2EC001DE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjHMGxa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjHMGx3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:53:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862831718
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:53:27 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV4yX-002bid-8E; Sun, 13 Aug 2023 14:53:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:53:21 +0800
Date:   Sun, 13 Aug 2023 14:53:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Gaurav Jain <gaurav.jain@nxp.com>
Subject: [v2 PATCH 0/36] Move crypto_engine callback into algorithm object
Message-ID: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v2 fixes build failures in allwinner drivers when debugfs is enabled.

As it stands, every crypto_engine user sets up callbacks in struct
crypto_engine_ctx which is stored at the head of the tfm context.

This is error-prone because there is no guarantee for that callback
to be there at all.  In fact this is exactly what happened when the
tfm context was moved for DMA alignment.

The first part of this series eliminates the unnecessary prepare
and unprepare callbacks so that only one function remains.

Then that last callback is moved into the algorithm object.  This
is checked by using special register/unregister functions that are
specific to crypto_engine.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
