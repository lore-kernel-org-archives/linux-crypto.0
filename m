Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF212C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJULeh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiJULeR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:34:17 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD56262DD7
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 04:34:09 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqHG-004djs-0A; Fri, 21 Oct 2022 19:34:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:34:02 +0800
Date:   Fri, 21 Oct 2022 19:34:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yuan Can <yuancan@huawei.com>
Cc:     thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Remove unused struct ccp_crypto_cpu
Message-ID: <Y1KDqmSuwombojlH@gondor.apana.org.au>
References: <20220927133955.104353-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927133955.104353-1-yuancan@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 27, 2022 at 01:39:55PM +0000, Yuan Can wrote:
> After commit bc3854476f36("crypto: ccp - Use a single queue for proper ordering
> of tfm requests"), no one use struct ccp_crypto_cpu, so remove it.
> 
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/crypto/ccp/ccp-crypto-main.c | 7 -------
>  1 file changed, 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
