Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D6FC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbjHKJ1o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbjHKJ1n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:27:43 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8D7110
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:27:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOQh-0020V0-EN; Fri, 11 Aug 2023 17:27:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:27:35 +0800
Date:   Fri, 11 Aug 2023 17:27:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH 0/36] Move crypto_engine callback into algorithm object
Message-ID: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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
