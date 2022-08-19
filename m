Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB3FC32772
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 11:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348532AbiHSLGm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 07:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348622AbiHSLGW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 07:06:22 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41A7FC314;
        Fri, 19 Aug 2022 04:05:59 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzp3-00CppL-BG; Fri, 19 Aug 2022 21:05:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 19:05:53 +0800
Date:   Fri, 19 Aug 2022 19:05:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tuo Cao <91tuocao@gmail.com>
Cc:     jesper.nilsson@axis.com, lars.persson@axis.com,
        davem@davemloft.net, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: axis: artpec6_crypto: move spin_lock_bh to
 spin_lock in tasklet
Message-ID: <Yv9ukQYJ+0+ZnwMM@gondor.apana.org.au>
References: <20220814130054.6444-1-91tuocao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814130054.6444-1-91tuocao@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 14, 2022 at 09:00:54PM +0800, Tuo Cao wrote:
> it is unnecessary to call spin_lock_bh in a tasklet.
> 
> Signed-off-by: Tuo Cao <91tuocao@gmail.com>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
