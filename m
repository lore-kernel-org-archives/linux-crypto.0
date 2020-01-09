Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3234C32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B13042073A
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgAIFPJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:15:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40450 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgAIFPJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:15:09 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQ9z-0003MU-OA; Thu, 09 Jan 2020 13:15:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQ9z-0003Y2-Iw; Thu, 09 Jan 2020 13:15:07 +0800
Date:   Thu, 9 Jan 2020 13:15:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/6] crypto: remove old way of allocating and freeing
 instances
Message-ID: <20200109051507.bbofb4otahxkdnmg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103040440.12375-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series makes all crypto templates use the new way of freeing
> instances where a ->free() method is installed to the instance struct
> itself.  This replaces the weakly-typed method crypto_template::free().
> 
> skcipher and akcipher were already using the new way, while aead was
> mostly but not always using the new way.  shash and ahash were using the
> old way.  This series eliminates this inconsistency (and the redundant
> code associated with it) by making everyone use the new way.
> 
> The last patch adds registration-time checks which verify that all
> instances really have a ->free() method.
> 
> This series is an internal cleanup only; there are no changes for users
> of the crypto API.
> 
> This series is based on top of my other series
> "[PATCH v2 00/28] crypto: template instantiation cleanup".
> 
> Changed v1 => v2:
> 
>  - Rebased onto v2 of the other series.
> 
> Eric Biggers (6):
>  crypto: hash - add support for new way of freeing instances
>  crypto: geniv - convert to new way of freeing instances
>  crypto: cryptd - convert to new way of freeing instances
>  crypto: shash - convert shash_free_instance() to new style
>  crypto: algapi - remove crypto_template::{alloc,free}()
>  crypto: algapi - enforce that all instances have a ->free() method
> 
> crypto/aead.c                   |  8 +++----
> crypto/ahash.c                  | 11 +++++++++
> crypto/akcipher.c               |  2 ++
> crypto/algapi.c                 |  5 ----
> crypto/algboss.c                | 12 +---------
> crypto/ccm.c                    |  5 ++--
> crypto/cmac.c                   |  5 ++--
> crypto/cryptd.c                 | 42 ++++++++++++++++-----------------
> crypto/echainiv.c               | 20 ++++------------
> crypto/geniv.c                  | 15 ++++++------
> crypto/hmac.c                   |  5 ++--
> crypto/seqiv.c                  | 20 ++++------------
> crypto/shash.c                  | 19 +++++++++++----
> crypto/skcipher.c               |  3 +++
> crypto/vmac.c                   |  5 ++--
> crypto/xcbc.c                   |  5 ++--
> include/crypto/algapi.h         |  2 --
> include/crypto/internal/geniv.h |  1 -
> include/crypto/internal/hash.h  |  4 +++-
> 19 files changed, 89 insertions(+), 100 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
