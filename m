Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809A5C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Mar 2022 03:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiCIDXE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDXD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 22:23:03 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A4D15AF22;
        Tue,  8 Mar 2022 19:22:06 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nRmtc-0002x0-MX; Wed, 09 Mar 2022 14:21:53 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Mar 2022 15:21:52 +1200
Date:   Wed, 9 Mar 2022 15:21:52 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     gilad@benyossef.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: Fix use after free in cc_cipher_exit()
Message-ID: <YigdUOfr9kx4ZaIN@gondor.apana.org.au>
References: <20220303022337.460971-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303022337.460971-1-niejianglei2021@163.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 03, 2022 at 10:23:37AM +0800, Jianglei Nie wrote:
> kfree_sensitive(ctx_p->user.key) will free the ctx_p->user.key. But
> ctx_p->user.key is still used in the next line, which will lead to a
> use after free.
> 
> We can call kfree_sensitive() after dev_dbg() to avoid the uaf.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
