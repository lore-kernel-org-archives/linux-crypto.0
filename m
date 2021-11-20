Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4352DC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhKTEgg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:36:36 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56920 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235104AbhKTEga (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:36:30 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moI40-0001LJ-6D; Sat, 20 Nov 2021 12:33:20 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moI3s-0006oX-FM; Sat, 20 Nov 2021 12:33:12 +0800
Date:   Sat, 20 Nov 2021 12:33:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, john.allen@amd.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: ccp-dev: no need to initialise statics to 0
Message-ID: <20211120043312.GN25752@gondor.apana.org.au>
References: <20211113063023.251246-1-wangborong@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211113063023.251246-1-wangborong@cdjrlc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 13, 2021 at 02:30:23PM +0800, Jason Wang wrote:
> Static variables do not need to be initialized to 0.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/crypto/ccp/ccp-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
