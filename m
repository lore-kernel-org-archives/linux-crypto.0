Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A950C4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 08:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiL3Inv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 03:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiL3Int (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 03:43:49 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55C718E36
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2022 00:43:48 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pBAzS-00CHXl-61; Fri, 30 Dec 2022 16:43:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Dec 2022 16:43:46 +0800
Date:   Fri, 30 Dec 2022 16:43:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Markus Stockhausen <markus.stockhausen@gmx.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 3/6] crypto/realtek: hash algorithms
Message-ID: <Y66kwtiHnLmzzlCP@gondor.apana.org.au>
References: <Y66ZgBx+hduj9S3K@gondor.apana.org.au>
 <b9931836dea5109a8a5aaa0a6e1abe558766d137.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9931836dea5109a8a5aaa0a6e1abe558766d137.camel@gmx.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 30, 2022 at 09:38:21AM +0100, Markus Stockhausen wrote:
>
> Can I just replace the calls with dma_map_single() or do I need other
> initialization or cleanup calls?

Pretty much.  Just don't forget to unmap them after the DMA has
completed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
