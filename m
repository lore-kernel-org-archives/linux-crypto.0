Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49386C31E4A
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27B4C215EA
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbfFMQlU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:41:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49970 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730556AbfFMGzJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 02:55:09 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hbJdc-0006Cy-6f; Thu, 13 Jun 2019 14:55:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hbJdc-00051t-22; Thu, 13 Jun 2019 14:55:08 +0800
Date:   Thu, 13 Jun 2019 14:55:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: aead - un-inline encrypt and decrypt functions
Message-ID: <20190613065507.w2cpvuocaop7cxuv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603054516.6080-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_aead_encrypt() and crypto_aead_decrypt() have grown to be more
> than a single indirect function call.  They now also check whether a key
> has been set, the decryption side checks whether the input is at least
> as long as the authentication tag length, and with CONFIG_CRYPTO_STATS=y
> they also update the crypto statistics.  That can add up to a lot of
> bloat at every call site.  Moreover, these always involve a function
> call anyway, which greatly limits the benefits of inlining.
> 
> So change them to be non-inline.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/aead.c         | 36 ++++++++++++++++++++++++++++++++++++
> include/crypto/aead.h | 34 ++--------------------------------
> 2 files changed, 38 insertions(+), 32 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
