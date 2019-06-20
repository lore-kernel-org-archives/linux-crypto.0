Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC63CC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BAF820449
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFTIGe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 04:06:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43602 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfFTIGe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 04:06:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hds5S-0002ED-0a; Thu, 20 Jun 2019 16:06:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hds5R-0007aV-M2; Thu, 20 Jun 2019 16:06:25 +0800
Date:   Thu, 20 Jun 2019 16:06:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: talitos - fix max key size for sha384 and sha512
Message-ID: <20190620080625.5q5sok7ihh4ell2y@gondor.apana.org.au>
References: <5f1004d33b2347dcfbc677551bafc9d469bb079e.1560318544.git.christophe.leroy@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f1004d33b2347dcfbc677551bafc9d469bb079e.1560318544.git.christophe.leroy@c-s.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 05:49:50AM +0000, Christophe Leroy wrote:
> Below commit came with a typo in the CONFIG_ symbol, leading
> to a permanently reduced max key size regarless of the driver
> capabilities.
> 
> Reported-by: Horia Geantă <horia.geanta@nxp.com>
> Fixes: b8fbdc2bc4e7 ("crypto: talitos - reduce max key size for SEC1")
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>  drivers/crypto/talitos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
