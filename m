Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E922C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319D620879
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfEWGvk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:51:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47792 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfEWGvk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:51:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThZh-0001oV-Lv; Thu, 23 May 2019 14:51:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThZe-0006BE-OW; Thu, 23 May 2019 14:51:34 +0800
Date:   Thu, 23 May 2019 14:51:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: talitos - fix skcipher failure due to wrong
 output IV
Message-ID: <20190523065134.hcvkalkpayywlonl@gondor.apana.org.au>
References: <a5b0d31d8fc9fc9bc2b69baa5330466090825a39.1557923113.git.christophe.leroy@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5b0d31d8fc9fc9bc2b69baa5330466090825a39.1557923113.git.christophe.leroy@c-s.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 12:29:03PM +0000, Christophe Leroy wrote:
> Selftests report the following:
> 
> [    2.984845] alg: skcipher: cbc-aes-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> [    2.995377] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
> [    3.032673] alg: skcipher: cbc-des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> [    3.043185] 00000000: fe dc ba 98 76 54 32 10
> [    3.063238] alg: skcipher: cbc-3des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> [    3.073818] 00000000: 7d 33 88 93 0f 93 b2 42
> 
> This above dumps show that the actual output IV is indeed the input IV.
> This is due to the IV not being copied back into the request.
> 
> This patch fixes that.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>  drivers/crypto/talitos.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
