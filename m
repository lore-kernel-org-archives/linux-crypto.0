Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23340C0015E
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 11:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbjHKLGw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbjHKLGF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 07:06:05 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5F02709;
        Fri, 11 Aug 2023 04:05:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUPx0-0023ap-Mq; Fri, 11 Aug 2023 19:05:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 19:05:02 +0800
Date:   Fri, 11 Aug 2023 19:05:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yonggang Wu <wuyonggang001@208suo.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wuyonggang001@208suo.com
Subject: Re: [PATCH] lib: crypto: Modify format error
Message-ID: <ZNYV3vTNmhLtW5Nf@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804062107.25913-1-wuyonggang001@208suo.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Yonggang Wu <wuyonggang001@208suo.com> wrote:
> Fix the error(s):
> space prohibited after that open square bracket '['
> 
> Signed-off-by: Yonggang Wu <wuyonggang001@208suo.com>
> ---
> lib/crypto/gf128mul.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)

This patch is pointless.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
