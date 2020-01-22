Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEB3C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5C72467F
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAVKPZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:15:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39176 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgAVKPZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:15:25 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iuD2h-0000Yw-Ul; Wed, 22 Jan 2020 18:15:23 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iuD2h-00044F-O6; Wed, 22 Jan 2020 18:15:23 +0800
Date:   Wed, 22 Jan 2020 18:15:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH] crypto: chacha20poly1305 - add back missing test vectors
 and test chunking
Message-ID: <20200122101523.fp3byv6peqmvr3zv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116202634.142137-1-Jason@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> When this was originally ported, the 12-byte nonce vectors were left out
> to keep things simple. I agree that we don't need nor want a library
> interface for 12-byte nonces. But these test vectors were specially
> crafted to look at issues in the underlying primitives and related
> interactions.  Therefore, we actually want to keep around all of the
> test vectors, and simply have a helper function to test them with.
> 
> Secondly, the sglist-based chunking code in the library interface is
> rather complicated, so this adds a developer-only test for ensuring that
> all the book keeping is correct, across a wide array of possibilities.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> lib/crypto/chacha20poly1305-selftest.c | 1712 +++++++++++++++++++++++-
> 1 file changed, 1698 insertions(+), 14 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
