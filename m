Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F287FC2BB48
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C98622396F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgLQRSB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:18:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:37646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbgLQRSB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:18:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1DB45B291;
        Thu, 17 Dec 2020 17:17:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 21DACDA83A; Thu, 17 Dec 2020 18:15:40 +0100 (CET)
Date:   Thu, 17 Dec 2020 18:15:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 3/5] crypto: blake2b - export helpers for optimized
 implementations
Message-ID: <20201217171540.GU6430@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
References: <20201215234708.105527-1-ebiggers@kernel.org>
 <20201215234708.105527-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215234708.105527-4-ebiggers@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 15, 2020 at 03:47:06PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In preparation for adding architecture-specific implementations of
> BLAKE2b, create a header <crypto/blake2b.h> that contains common
> constants, structs, and helper functions for BLAKE2b.
> 
> Furthermore, export the BLAKE2b generic setkey(), init(), update(), and
> final() functions, and add functions __crypto_blake2b_update() and
> __crypto_blake2b_final() which take a pointer to a
> blake2b_compress_blocks_t function.
> 
> This way, optimized implementations of BLAKE2b only have to provide an
> implementation of blake2b_compress_blocks_t.  (This is modeled on how
> the nhpoly1305 implementations work.  Also, the prototype of
> blake2b_compress_blocks_t is meant to be similar to that of
> blake2s_compress_arch().)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: David Sterba <dsterba@suse.com>
