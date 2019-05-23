Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4773AC04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146392133D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfEWGwr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:52:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47814 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfEWGwr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:52:47 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThao-0001qs-ET; Thu, 23 May 2019 14:52:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThan-0006D9-2p; Thu, 23 May 2019 14:52:45 +0800
Date:   Thu, 23 May 2019 14:52:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/2] crypto: crypto4xx - fix blocksize for cfb and ofb
Message-ID: <20190523065245.x3y6spbez3so3ryv@gondor.apana.org.au>
References: <20190518212812.21414-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518212812.21414-1-chunkeey@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 18, 2019 at 11:28:11PM +0200, Christian Lamparter wrote:
> While the hardware consider them to be blockciphers, the
> reference implementation defines them as streamciphers.
> 
> Do the right thing and set the blocksize to 1. This
> was found by CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
> 
> This fixes the following issues:
> skcipher: blocksize for ofb-aes-ppc4xx (16) doesn't match generic impl (1)
> skcipher: blocksize for cfb-aes-ppc4xx (16) doesn't match generic impl (1)
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
