Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2820FC001E0
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbjG1KWP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjG1KWM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:22:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316E23A8D;
        Fri, 28 Jul 2023 03:22:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qPKbf-0011pM-RZ; Fri, 28 Jul 2023 18:22:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jul 2023 18:21:59 +0800
Date:   Fri, 28 Jul 2023 18:21:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mahmoud Adam <mngyadam@amazon.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KEYS: use kfree_sensitive with key
Message-ID: <ZMOWx2zxHQ1+JpeR@gondor.apana.org.au>
References: <20230717125509.105015-1-mngyadam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717125509.105015-1-mngyadam@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 17, 2023 at 12:55:09PM +0000, Mahmoud Adam wrote:
> key might contain private part of the key, so better use
> kfree_sensitive to free it
> 
> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
> ---
>  crypto/asymmetric_keys/public_key.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
