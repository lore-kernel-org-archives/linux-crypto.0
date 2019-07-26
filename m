Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C695C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B63822ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfGZMhC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:37:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46558 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfGZMhC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:37:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzT1-000456-8f; Fri, 26 Jul 2019 22:36:59 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzT0-0002F2-R8; Fri, 26 Jul 2019 22:36:58 +1000
Date:   Fri, 26 Jul 2019 22:36:58 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [PATCH] crypto: ghash - add comment and improve help text
Message-ID: <20190726123658.GA8609@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720060918.25880-1-ebiggers@kernel.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> To help avoid confusion, add a comment to ghash-generic.c which explains
> the convention that the kernel's implementation of GHASH uses.
> 
> Also update the Kconfig help text and module descriptions to call GHASH
> a "hash function" rather than a "message digest", since the latter
> normally means a real cryptographic hash function, which GHASH is not.
> 
> Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm/crypto/ghash-ce-glue.c            |  2 +-
> arch/s390/crypto/ghash_s390.c              |  2 +-
> arch/x86/crypto/ghash-clmulni-intel_glue.c |  3 +--
> crypto/Kconfig                             | 11 ++++----
> crypto/ghash-generic.c                     | 31 +++++++++++++++++++---
> drivers/crypto/Kconfig                     |  6 ++---
> include/crypto/ghash.h                     |  2 +-
> 7 files changed, 41 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
