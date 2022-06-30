Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4DFCCA47E
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 08:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiF3IRR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiF3IQm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 04:16:42 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C10E4339C;
        Thu, 30 Jun 2022 01:14:14 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6pJI-00Cy63-Jj; Thu, 30 Jun 2022 18:14:02 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 16:14:00 +0800
Date:   Thu, 30 Jun 2022 16:14:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, Julia.Lawall@inria.fr, jiangjian@cdjrlc.com,
        hanyihao@vivo.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ux500/hash - drop unexpected word "the"
Message-ID: <Yr1bSGO5PyLpKn89@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621102733.88445-1-jiangjian@cdjrlc.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jiang Jian <jiangjian@cdjrlc.com> wrote:
> there is an unexpected word "the" in the comments that need to be dropped
> 
>>-  * specified in the the hw design spec. Either due to incorrect info in the
>>+  * specified in the hw design spec. Either due to incorrect info in the
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
> drivers/crypto/ux500/hash/hash_core.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
