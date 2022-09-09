Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EE6ECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 09:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiIIJJY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiIIJJU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 05:09:20 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD92135D5B;
        Fri,  9 Sep 2022 02:09:19 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oWa0M-002oG6-T3; Fri, 09 Sep 2022 19:08:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Sep 2022 17:08:54 +0800
Date:   Fri, 9 Sep 2022 17:08:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     cgel.zte@gmail.com
Cc:     leitao@debian.org, nayna@linux.ibm.com, pfsmorigo@gmail.com,
        mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] crypto: nx - Remove the unneeded result
 variable
Message-ID: <YxsCplvrUl89F8B9@gondor.apana.org.au>
References: <20220902073055.319464-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902073055.319464-1-ye.xingchen@zte.com.cn>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 02, 2022 at 07:30:55AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Return the value set_msg_len() directly instead of storing it in another
> redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/crypto/nx/nx-aes-ccm.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
