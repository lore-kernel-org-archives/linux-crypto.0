Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF382C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1CAA20718
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbfKVLKJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:10:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:53964 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730998AbfKVLKI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 06:10:08 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY6pD-0005HU-Ce; Fri, 22 Nov 2019 19:10:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY6pD-0002jy-8q; Fri, 22 Nov 2019 19:10:07 +0800
Date:   Fri, 22 Nov 2019 19:10:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: mips/chacha - select CRYPTO_SKCIPHER, not
 CRYPTO_BLKCIPHER
Message-ID: <20191122111007.52ol7lyuqqd6rig2@gondor.apana.org.au>
References: <20191117025324.22929-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117025324.22929-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 16, 2019 at 06:53:24PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Another instance of CRYPTO_BLKCIPHER made it in just after it was
> renamed to CRYPTO_SKCIPHER.  Fix it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
