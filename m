Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B5CC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Apr 2022 08:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiDHIdC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiDHIdB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Apr 2022 04:33:01 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38CF2FF507;
        Fri,  8 Apr 2022 01:30:57 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nck18-000SDS-CU; Fri, 08 Apr 2022 18:30:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Apr 2022 16:30:54 +0800
Date:   Fri, 8 Apr 2022 16:30:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] crypto: engine: Add parameter description in
 crypto_transfer_request() kernel-doc comment
Message-ID: <Yk/yvg+K/uHP11wW@gondor.apana.org.au>
References: <20220316010301.3166-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316010301.3166-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 16, 2022 at 09:03:01AM +0800, Yang Li wrote:
> Add the description of @need_pump in crypto_transfer_request() kernel-doc
> comment to remove warning found by running scripts/kernel-doc, which is
> caused by using 'make W=1'.
> 
> crypto/crypto_engine.c:260: warning: Function parameter or member
> 'need_pump' not described in 'crypto_transfer_request'
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  crypto/crypto_engine.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
