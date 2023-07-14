Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73552EB64DC
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 08:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbjGNIvH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbjGNIvF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 04:51:05 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1796F26B2;
        Fri, 14 Jul 2023 01:51:05 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qKEVn-001RdR-BA; Fri, 14 Jul 2023 18:50:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jul 2023 18:50:44 +1000
Date:   Fri, 14 Jul 2023 18:50:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] verify_pefile: fix kernel-doc warnings in
 verify_pefile
Message-ID: <ZLEMZNemwIGlVRo3@gondor.apana.org.au>
References: <20230619132424.80587-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619132424.80587-1-cuigaosheng1@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 19, 2023 at 09:24:24PM +0800, Gaosheng Cui wrote:
> Fix kernel-doc warnings in verify_pefile:
> 
> crypto/asymmetric_keys/verify_pefile.c:423: warning: Excess function
> parameter 'trust_keys' description in 'verify_pefile_signature'
> 
> crypto/asymmetric_keys/verify_pefile.c:423: warning: Function parameter
> or member 'trusted_keys' not described in 'verify_pefile_signature'
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  crypto/asymmetric_keys/verify_pefile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
