Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4211C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1E6F214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfLKJmZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:42:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54636 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbfLKJmZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:42:25 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieyVj-0000Km-Ri; Wed, 11 Dec 2019 17:42:23 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieyVj-0000CL-Jk; Wed, 11 Dec 2019 17:42:23 +0800
Date:   Wed, 11 Dec 2019 17:42:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: shash - allow essiv and hmac to use OPTIONAL_KEY
 algorithms
Message-ID: <20191211094223.rhtnupwkgidjla2m@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129193522.52513-1-ebiggers@kernel.org>
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
> The essiv and hmac templates refuse to use any hash algorithm that has a
> ->setkey() function, which includes not just algorithms that always need
> a key, but also algorithms that optionally take a key.
> 
> Previously the only optionally-keyed hash algorithms in the crypto API
> were non-cryptographic algorithms like crc32, so this didn't really
> matter.  But that's changed with BLAKE2 support being added.  BLAKE2
> should work with essiv and hmac, just like any other cryptographic hash.
> 
> Fix this by allowing the use of both algorithms without a ->setkey()
> function and algorithms that have the OPTIONAL_KEY flag set.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/essiv.c                 | 2 +-
> crypto/hmac.c                  | 4 ++--
> crypto/shash.c                 | 3 +--
> include/crypto/internal/hash.h | 6 ++++++
> 4 files changed, 10 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
