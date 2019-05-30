Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71D8C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5BEF259CC
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfE3Nlo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:41:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38002 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfE3Nlo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:41:44 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWLJP-0005ab-7P; Thu, 30 May 2019 21:41:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWLJP-0003eX-2U; Thu, 30 May 2019 21:41:43 +0800
Date:   Thu, 30 May 2019 21:41:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hash - remove CRYPTO_ALG_TYPE_DIGEST
Message-ID: <20190530134142.3zag6nmge4cmbeig@gondor.apana.org.au>
References: <20190520165446.169693-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520165446.169693-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 20, 2019 at 09:54:46AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove the unnecessary constant CRYPTO_ALG_TYPE_DIGEST, which has the
> same value as CRYPTO_ALG_TYPE_HASH.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/crypto/architecture.rst | 4 +---
>  crypto/cryptd.c                       | 2 +-
>  include/linux/crypto.h                | 1 -
>  3 files changed, 2 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
