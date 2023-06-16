Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DE6EB64D8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 10:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345295AbjFPK6z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 06:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243634AbjFPK60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 06:58:26 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF392D4C;
        Fri, 16 Jun 2023 03:51:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qA6jR-003lae-CS; Fri, 16 Jun 2023 18:31:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jun 2023 18:31:05 +0800
Date:   Fri, 16 Jun 2023 18:31:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mahmoud Adam <mngyadam@amazon.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KEYS: use kfree_sensitive with key
Message-ID: <ZIw56UTG3fPtp/DM@gondor.apana.org.au>
References: <20230615125712.105873-1-mngyadam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615125712.105873-1-mngyadam@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 15, 2023 at 12:57:13PM +0000, Mahmoud Adam wrote:
> key might contain private part of the key, so better use
> kfree_sensitive to free it
> 
> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
> ---
> v2: kfree_sensitive only private key
> 
>  crypto/asymmetric_keys/public_key.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Sorry, I was confused by the naming in this file.  These public_keys
can indeed be private.  So I'll just take your original patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
